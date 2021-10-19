public without sharing class AlertasHelper  {
	static String seguimientoRT = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
	static String autPrevRT = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
	static String internacionRT = XappiaHelper.getRecordType('Case', 'Internacion').Id;
	static String reintegroRT = XappiaHelper.getRecordType('Case', 'Reintegro').Id;

	public static void checkCaseState(List<Alerta__c> alerts) {
		Set<Id> setPrestacionIds = getPrestacionIds(alerts);
		Set<Id> setPrestacionReintegroIds = getPrestacionReintegroIds(alerts);

		//for(Alerta__c alert : alerts) {
			//if(alert.Prestacion__c != null) {
				//setPrestacionIds.add(alert.Prestacion__c);	
			//} 
			//if(alert.Prestacion_de_reintegro__c != null) {
				//setPrestacionReintegroIds.add(alert.Prestacion_de_reintegro__c);	
			//} 
		//}

		if( !setPrestacionIds.isEmpty() ) {
			checkAP(setPrestacionIds);
		}

		if( !setPrestacionReintegroIds.isEmpty() ) {
			checkReintegro(setPrestacionReintegroIds);
		}

	}

	public static void checkCaseNoAlertsAMPending(List<Alerta__c> alerts) {
		//Map<Id, Alerta__c[]> alertasByCaseId = new Map<Id, Alerta__c[]>();
		//Map<Case, Alerta__c[]> alertasByCase = new Map<Case, Alerta__c[]>();
		String[] funciones = new List<String>{'AM'};
		Case[] casesToUpdate = new List<Case>();
		Set<Id> setPrestacionIds = getPrestacionIds(alerts);
		Set<Id> setPrestacionReintegroIds = getPrestacionReintegroIds(alerts);
		Prestacion__c[] prestacionesWithAlertasAM = [
			SELECT Id, Ap__c, Ap__r.Sin_alertas_AM_pendientes__c, 
				(SELECT Funcion__c, Estado__c FROM Alertas__r) 
			FROM Prestacion__c 
			WHERE Id IN :setPrestacionIds 
				//AND Ap__r.Sin_alertas_AM_pendientes__c = false
				//AND Ap__r.Contiene_alerta_AM__c = true
				//AND prest.Ap__c != null
		];
		Prestacion_de_reintegro__c[] prestacionesReinWithAlertasAM = [
			SELECT Id, Caso__c, Caso__r.Sin_alertas_AM_pendientes__c, 
				(SELECT Funcion__c, Estado__c FROM Alertas__r) 
			FROM Prestacion_de_reintegro__c
			WHERE Id IN :setPrestacionReintegroIds
		];
		Set<Id> caseIdsWithAlertsAM = getCaseIdsFromPrest(prestacionesWithAlertasAM);
		
		caseIdsWithAlertsAM.addAll(getCaseIdsFromPrestRein(prestacionesReinWithAlertasAM));

		List<Case> casesWithAlertsAM = [
			SELECT Sin_alertas_AM_pendientes__c,
				(SELECT Id FROM Prestaciones__r),
				(SELECT Id FROM Prestaciones_de_reintegros__r)
			FROM Case
			WHERE Id IN :caseIdsWithAlertsAM
		];

		Map<Id, Prestacion__c> prestacionesWithAlertasAMById = new Map<Id, Prestacion__c>([
			SELECT Id, Ap__c, Ap__r.Sin_alertas_AM_pendientes__c, 
				(SELECT Funcion__c, Estado__c FROM Alertas__r) 
			FROM Prestacion__c 
			WHERE Ap__c IN :casesWithAlertsAM 
				//AND Ap__r.Sin_alertas_AM_pendientes__c = false
				//AND Ap__r.Contiene_alerta_AM__c = true
				//AND prest.Ap__c != null
		]);

		Map<Id, Prestacion_de_reintegro__c> prestacionesReinWithAlertasAMById = new Map<Id, Prestacion_de_reintegro__c>([
			SELECT Id, Caso__c, Caso__r.Sin_alertas_AM_pendientes__c, 
				(SELECT Funcion__c, Estado__c FROM Alertas__r) 
			FROM Prestacion_de_reintegro__c 
			WHERE Caso__c IN :casesWithAlertsAM 
				//AND Ap__r.Sin_alertas_AM_pendientes__c = false
				//AND Ap__r.Contiene_alerta_AM__c = true
				//AND prest.Ap__c != null
		]);

		//System.debug('##casesWithAlertsAM: ' + casesWithAlertsAM);
		//System.debug('##Prestaciones: ' + casesWithAlertsAM[0].Prestaciones__r);
		//System.debug('##prestacionesWithAlertasAMById: ' + prestacionesWithAlertasAMById);
		//System.debug('##keySet: ' + prestacionesWithAlertasAMById.keySet());
		//System.debug('##prestacionesWithAlertasAMById[0]: ' + prestacionesWithAlertasAMById.values()[0]);
		//System.debug('##prestacionesWithAlertasAMById[0]: ' + prestacionesWithAlertasAMById.values()[0].Alertas__r);
		

		Map<Case, Alerta__c[]> alertasByCase = getAlertsWithTheseFunctionsByCase(
			casesWithAlertsAM, prestacionesWithAlertasAMById, prestacionesReinWithAlertasAMById, funciones
		);
	
		System.debug('##alertasByCase: ' + alertasByCase);

		//for(Id caseId : alertasByCaseId.keySet()) {
		for(Case aCase : alertasByCase.keySet()) {
			Boolean noAlertsAMPending = true;
			//Case aCase = new Case(Id = caseId);

			for(Alerta__c alert : alertasByCase.get(aCase)) {
				
				if(isTheAlertPending(alert)) {
					noAlertsAMPending = false;
				}
			}

			if(aCase.Sin_alertas_AM_pendientes__c != noAlertsAMPending) {
				aCase.Cambio_Manual__c = false;
				aCase.Sin_alertas_AM_pendientes__c = noAlertsAMPending;
			
				casesToUpdate.add(aCase);
			}
		}

		update casesToUpdate;
	}

	private static void checkAp(Set<Id> setPrestacionIds) {
		Set<String> setCasos = new Set<String>();

		for(Prestacion__c prest : [
			SELECT Id, Ap__c, Ap__r.RecordTypeId
			FROM Prestacion__c 
			WHERE Id IN :setPrestacionIds AND Estado__c != 'C1-----A' AND Estado__c != 'C1-----G'
		]) {
			if(prest.Ap__c != null) {
				setCasos.add(prest.Ap__c);
			}
		}
		//Boolean autorizar = true;
		List<Case> listCasesToUpdate = new List<Case>();
		for(Case caso : [SELECT RecordTypeId, Status, (SELECT Estado__c FROM Prestaciones__r) FROM Case WHERE Id IN :setCasos]) {
			Boolean autorizar = true;
			Boolean rechazar = true;
			for(Prestacion__c prest : caso.Prestaciones__r) {
				Boolean prestRechazada = prest.Estado__c == 'C1---RSA' || prest.Estado__c == 'C1---RSP' 
											|| prest.Estado__c == 'C1EA-RAA' || prest.Estado__c == 'C1EA-RAP';
				Boolean prestAutorizada = prest.Estado__c == 'C1----AS' || prest.Estado__c == 'C1EA--AA';

				autorizar = autorizar && prestAutorizada;
				rechazar = rechazar && prestRechazada;
			}

			//if(autorizar) {
				//if(caso.Status != 'CA-----E' && caso.Status != 'CA-----N' && caso.Status != 'Autorizada') {
					//caso.Cambio_Manual__c = false;
					//caso.Ap_autorizada__c = true;
					//caso.Status = 'Autorizada';

					//listCasesToUpdate.add(caso);
				//}

			//}

			if(rechazar) {
				Boolean rtCorrect = caso.RecordTypeId == seguimientoRT || caso.RecordTypeId == internacionRT || caso.RecordTypeId == autPrevRT;
				
				if(rtCorrect) {
					caso.Cambio_Manual__c = false;
					caso.Status = 'Rechazado';
					caso.Caso_Rechazado__c = true;

					listCasesToUpdate.add(caso);
				}
			}

		}

		Database.SaveResult[] resultCasesToAuth = Database.update(listCasesToUpdate);
		//System.debug('##resultCasesToAuthOrRefuse ' + resultCasesToAuth);
	}

	private static void checkReintegro(Set<Id> setPrestacionReintegroIds) {
		Set<String> setCasos = new Set<String>();

		for(Prestacion_de_reintegro__c prest : [
			SELECT Id, Caso__c, Caso__r.RecordTypeId
			FROM Prestacion_de_reintegro__c 
			WHERE Id IN :setPrestacionReintegroIds AND Estado__c != 'C1-----A' AND Estado__c != 'C1-----G'
		]) {
			if(prest.Caso__c != null) {
				setCasos.add(prest.Caso__c);
			}
		}
		//Boolean autorizar = true;
		List<Case> listCasesToUpdate = new List<Case>();
		for(Case caso : [
			SELECT RecordTypeId, (SELECT Estado__c FROM Prestaciones_de_reintegros__r) 
			FROM Case 
			WHERE Id IN :setCasos
		]) {
			Boolean autorizar = true;
			Boolean rechazar = true;
			for(Prestacion_de_reintegro__c prest : caso.Prestaciones_de_reintegros__r) {
				Boolean prestRechazada = prest.Estado__c == 'C1---RSA' || prest.Estado__c == 'C1---RSP' 
											|| prest.Estado__c == 'C1EA-RAA' || prest.Estado__c == 'C1EA-RAP';
				Boolean prestAutorizada = prest.Estado__c == 'C1----AS' || prest.Estado__c == 'C1EA--AA';

				autorizar = autorizar && prestAutorizada;
				rechazar = rechazar && prestRechazada;
			}
			
			caso.Cambio_Manual__c = false;
			if(rechazar) {
				caso.Status = 'Rechazado';
				caso.Caso_Rechazado__c = true;

				listCasesToUpdate.add(caso);
			}

			if(autorizar){
				caso.Status = 'Autorizado';
				listCasesToUpdate.add(caso);
			}
		}

		Database.SaveResult[] resultCasesToRefuse = Database.update(listCasesToUpdate);
		//System.debug('##resultReintegrosToRefuse ' + resultCasesToRefuse);
	}

	public static void checkCaseAlertsDiscaPending(List<Alerta__c> alerts) {
		String[] pendingStates = new List<String>{'C1-----A', 'C1-----G', null, ''};
		String[] funciones = new List<String>{'FCION_DISCA', 'FCION_ID'};
		Case[] casesToUpdate = new List<Case>();
		Set<Id> setPrestacionIds = getPrestacionIds(alerts);
		Prestacion__c[] prestacionesWithAlertasDisca = [
			SELECT Id, Ap__c, Ap__r.Sin_alertas_AM_pendientes__c, 
				(SELECT Funcion__c, Estado__c FROM Alertas__r) 
			FROM Prestacion__c 
			WHERE Id IN :setPrestacionIds 
		];
		Set<Id> caseIdsWithAlertsDisca = getCaseIdsFromPrest(prestacionesWithAlertasDisca);
		List<Case> casesWithAlertsDisca = [
			SELECT Sin_alertas_AM_pendientes__c,
				(SELECT Id FROM Prestaciones__r)
			FROM Case
			WHERE Id IN :caseIdsWithAlertsDisca
		];
		Map<Id, Prestacion__c> prestacionesWithAlertasDiscaById = new Map<Id, Prestacion__c>([
			SELECT Id, Ap__c, Ap__r.Alertas_disca_ID_pendientes__c, Ap__r.Alertas_disca_pendientes__c,
				(
					SELECT Funcion__c, Estado__c 
					FROM Alertas__r 
					WHERE Estado__c IN :pendingStates 
					ORDER BY Nivel_de_auditoria__c ASC
					LIMIT 1
				) 
			FROM Prestacion__c 
			WHERE Ap__c IN :casesWithAlertsDisca 
		]);
		System.debug('####prestacionesWithAlertasDiscaById: ' + prestacionesWithAlertasDiscaById);
		for(Prestacion__c prest : prestacionesWithAlertasDiscaById.values()) {
			System.debug('####Alertas en prestacionesWithAlertasDiscaById: ' + prest.Alertas__r);
		}
		Map<Case, Alerta__c[]> alertasByCase = getAlertsWithTheseFunctionsByCase(
			casesWithAlertsDisca, prestacionesWithAlertasDiscaById, null, null
		);
		System.debug('####alertasByCase: ' + alertasByCase);

		for(Case aCase : alertasByCase.keySet()) {
			System.debug('####ENTRO AL FOR');
			Boolean alertsDiscaIDPending = false;
			Boolean alertsDiscaPending = false;

			// for(Alerta__c alert : alertasByCase.get(aCase)) {
				
			// 	if(isTheAlertPending(alert) && alert.Funcion__c == 'FCION_ID') {
			// 		alertsDiscaIDPending = true;
			// 	}
			// 	else if(isTheAlertPending(alert) && alert.Funcion__c == 'FCION_DISCA') {
			// 		alertsDiscaPending = true;
			// 	}
			// }

			for(Alerta__c alert : alertasByCase.get(aCase)) {
				
				if(alert.Funcion__c == 'FCION_ID') {
					alertsDiscaIDPending = true;
				}
				else if(alert.Funcion__c == 'FCION_DISCA') {
					alertsDiscaPending = true;
				}
			}

			// if(!alertasByCase.get(aCase).isEmpty()) {
			// 	Alerta__c alert = alertasByCase.get(aCase)[0];
				
			// 	alertsDiscaPending = alert.Funcion__c == 'FCION_DISCA';
			// 	alertsDiscaIDPending = alert.Funcion__c == 'FCION_ID';
			// }

			if(aCase.Alertas_disca_ID_pendientes__c != alertsDiscaIDPending 
				|| aCase.Alertas_disca_pendientes__c != alertsDiscaPending
			) {
				//aCase.Cambio_Manual__c = false;
				aCase.Alertas_disca_ID_pendientes__c = alertsDiscaIDPending;
				aCase.Alertas_disca_pendientes__c = alertsDiscaPending;
			
				casesToUpdate.add(aCase);
			}
		}

		update casesToUpdate;
	}

	private static Set<Id> getPrestacionIds(Alerta__c[] alerts) {
		Set<Id> setPrestacionIds = new Set<Id>();

		for(Alerta__c alert : alerts) {
			if(alert.Prestacion__c != null) {
				setPrestacionIds.add(alert.Prestacion__c);	
			} 
		}

		return setPrestacionIds;
	}

	private static Set<Id> getPrestacionReintegroIds(Alerta__c[] alerts) {
		Set<Id> setPrestacionReintegroIds = new Set<Id>();

		for(Alerta__c alert : alerts) {
			if(alert.Prestacion_de_reintegro__c != null) {
				setPrestacionReintegroIds.add(alert.Prestacion_de_reintegro__c);	
			} 
		}

		return setPrestacionReintegroIds;
	}

	private static Alerta__c[] getOnlyAlertsWithTheseFunctions(Alerta__c[] alerts, List<String> funciones) {
		Alerta__c[] alertsWithThisFuncion = new List<Alerta__c>();
		
		if(funciones == null) {
			return alerts;
		}

		for(Alerta__c alert : alerts) {
			if(funciones.contains(alert.Funcion__c)) {
				alertsWithThisFuncion.add(alert);
			}
		}

		return alertsWithThisFuncion;
	}

	private static Set<Id> getCaseIdsFromPrest(Prestacion__c[] prestaciones) {
		Set<Id> caseIds = new Set<Id>();

		for(Prestacion__c prest : prestaciones) {
			if(String.isNotBlank(prest.Ap__c)) {
				caseIds.add(prest.Ap__c);
			}
		}

		return caseIds;
	}

	private static Set<Id> getCaseIdsFromPrestRein(Prestacion_de_reintegro__c[] prestaciones) {
		Set<Id> caseIds = new Set<Id>();

		for(Prestacion_de_reintegro__c prest : prestaciones) {
			if(String.isNotBlank(prest.Caso__c)) {
				caseIds.add(prest.Caso__c);
			}
		}

		return caseIds;
	}

	private static Map<Case, Alerta__c[]> getAlertsWithTheseFunctionsByCase(
		Case[] casesWithAlerts, 
		Map<Id, Prestacion__c> prestacionesWithAlertasById,
		Map<Id, Prestacion_de_reintegro__c> prestacionesReinWithAlertasById,
		String[] functions
	) {
		Map<Case, Alerta__c[]> alertasByCase = new Map<Case, Alerta__c[]>();

		for(Case aCase : casesWithAlerts) {
			
			for(Prestacion__c prest : aCase.Prestaciones__r) {
				Alerta__c[] alertsAddToMap = new List<Alerta__c>();
				Prestacion__c prestWithAlerts = prestacionesWithAlertasById.get(prest.Id);

				if(alertasByCase.containsKey(prestWithAlerts.Ap__r)) {
					alertsAddToMap = alertasByCase.get(prestWithAlerts.Ap__r);
					alertsAddToMap.addAll(getOnlyAlertsWithTheseFunctions(prestWithAlerts.Alertas__r, functions));
				}
				else {
					alertsAddToMap = getOnlyAlertsWithTheseFunctions(prestWithAlerts.Alertas__r, functions);
				}

				alertasByCase.put(prestWithAlerts.Ap__r, alertsAddToMap);
			} 
			
			for(Prestacion_de_reintegro__c prest : aCase.Prestaciones_de_reintegros__r) {
				Alerta__c[] alertsAddToMap = new List<Alerta__c>();
				Prestacion_de_reintegro__c prestWithAlerts = prestacionesReinWithAlertasById.get(prest.Id);

				if(alertasByCase.containsKey(prestWithAlerts.Caso__r)) {
					alertsAddToMap = alertasByCase.get(prestWithAlerts.Caso__r);
					alertsAddToMap.addAll(getOnlyAlertsWithTheseFunctions(prestWithAlerts.Alertas__r, functions));
				}
				else {
					alertsAddToMap = getOnlyAlertsWithTheseFunctions(prestWithAlerts.Alertas__r, functions);
				}

				alertasByCase.put(prestWithAlerts.Caso__r, alertsAddToMap);
			} 

		}

		return alertasByCase;
	}

	private static Boolean isTheAlertPending(Alerta__c alert) {
		return alert.Estado__c == 'C1-----A' || alert.Estado__c == 'C1-----G' || String.isBlank(alert.Estado__c);
	}

}