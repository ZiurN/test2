/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase manejadora del desencadenador para el objeto Case
@date			08/12/2021
------------------------------------------------------------------------------------------------------------------------*/
@SuppressWarnings('PMD.ApexCRUDViolation')
public with sharing class CaseTriggerHandler extends TriggerHandler {
	List<Case> lNew = (List<Case>) Trigger.new;
	List<Case> lOld = (List<Case>) Trigger.old;
	Map<Id,Case> mNew = (Map<Id,Case>) Trigger.newMap;
	Map<Id,Case> mOld = (Map<Id,Case>) Trigger.oldMap;
	/** Variables */
	private static Id casoATipificarRtId = XappiaHelper.getRecordType('Case', 'Caso_a_tipificar').Id;
	private static Id solicitudDeDatosParticulares = XappiaHelper.getRecordType('Case','Solicitud_de_datos_particulares').Id;
	private static Id apRtId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
	private static Id internacionRtId = XappiaHelper.getRecordType('Case', 'Internacion').Id;
	private static Id reintegroRtId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
	private static Id seguimientoRtId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
	private static List<Id> casosValidosActualizarStatus = new List<Id>{
		XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id,
		XappiaHelper.getRecordType('Case', 'Reintegro').Id,
		XappiaHelper.getRecordType('Case', 'Internacion').Id,
		XappiaHelper.getRecordType('Case', 'Seguimiento').Id,
		XappiaHelper.getRecordType('Case', 'Solicitud_de_alta_familiar').Id,
		XappiaHelper.getRecordType('Case', 'Solicitud_de_despegues').Id
	};
	public override void beforeInsert() {
		List<Case> casesToChangeDelegacionFront = new List<Case>();
		CaseTriggerHelper.checkDuplicateDNIOnAltaFamiliar(lNew);
		caseLiveChatHelper.assignAccounts(lNew);
		SLAUtils.assignEntitlements(lNew);
		CaseTriggerHelper.avoidCreationOfReintegroWithALoteThatIsClosed(lNew);
	}
	public override void beforeUpdate() {
		CaseTriggerHelper.checkIfHaveEquipoDeCaso(lNew, mOld);
		CaseTriggerHelper.checkDuplicateDNIOnAltaFamiliar(lNew);
		CaseTriggerHelper.changeStatusToClosed(lNew, mOld);
		Set<Id> casesIdBaja = new Set<Id>();
		List<Case> casesToUpdateStatus = new List<Case>();
		List<Case> casesToChangeDelegacion = new List<Case>();
		List<Case> updatedCases = new List<Case>();
		List<Case> casesWhereEstadoDeDocumentacionIsChanged = new List<Case>();
		List<Case> casesToCloseSla = new List<Case>();
		List<Case> casesWithMedicoAsignadoChangedAndOldInNull = new List<Case>();
		List<Case> casesWithMedicoAsignadoChangedAndOldNotNull = new List<Case>();
		List<Case> casesWithResponsableChangedAndOldInNull = new List<Case>();
		List<Case> casesWithResponsableChangedAndOldNotNull = new List<Case>();
		List<Case> casesWithResponsablePresuChangedAndOldInNull = new List<Case>();
		List<Case> casesWithResponsablePresuChangedAndOldNotNull = new List<Case>();
		List<Case> casesToUpdateFieldsOnEM = new List<Case>();
		List<Case> casesToChangeLote = new List<Case>();
		Map<Id, Case> casesToReopenSLAById = new Map<Id, Case>();
		for(Case caso : lNew) {
			Case oldCase = mOld.get(caso.Id);
			Boolean rtToValidateResp = caso.RecordTypeId == seguimientoRtId
										|| caso.RecordTypeId == internacionRtId
										|| caso.RecordTypeId == reintegroRtId
										|| caso.RecordTypeId == apRtId;
			Boolean isFromEM = String.isNotBlank(caso.Evento_Medico__c)
								&& (caso.RecordTypeId == seguimientoRtId
									|| caso.RecordTypeId == internacionRtId);
			if(oldCase.RecordTypeId == casoATipificarRtId && oldCase.RecordTypeId != caso.RecordTypeId){
				caso.Cambio_Manual__c = false;
				caso.Usuario__c = null;
				if(caso.Type == null){
					Case dummyCase = (Case)Case.sObjectType.newSObject(caso.RecordTypeId,true);
					caso.Type = dummyCase.Type;
				}
				casesToChangeDelegacion.add(caso);
				if(casosValidosActualizarStatus.contains(caso.RecordTypeId)){
					casesToUpdateStatus.add(caso);
				}else if(caso.RecordTypeId == solicitudDeDatosParticulares){
					caso.SuppliedEmail = '';
				}
			}
			if(oldCase.Medico_asignado__c != caso.Medico_asignado__c && rtToValidateResp) {
				if (oldCase.Medico_asignado__c == null) {
					casesWithMedicoAsignadoChangedAndOldInNull.add(caso);
				}
				else {
					casesWithMedicoAsignadoChangedAndOldNotNull.add(caso);
				}
			}
			if(oldCase.Responsable_de_presupuesto__c != caso.Responsable_de_presupuesto__c && rtToValidateResp) {
				if (oldCase.Responsable_de_presupuesto__c == null) {
					casesWithResponsablePresuChangedAndOldInNull.add(caso);
				}
				else {
					casesWithResponsablePresuChangedAndOldNotNull.add(caso);
				}
			}
			if(oldCase.Usuario__c != caso.Usuario__c && rtToValidateResp && oldCase.RecordTypeId != casoATipificarRtId) {
				if (oldCase.Usuario__c == null) {
					casesWithResponsableChangedAndOldInNull.add(caso);
				}
				else {
					casesWithResponsableChangedAndOldNotNull.add(caso);
				}
			}
			if((caso.Status == 'CA-----G' && oldCase.Status == 'Rechazado')
				|| (!caso.Caso_Rechazado__c && oldCase.Caso_Rechazado__c)) {
				casesToReopenSLAById.put(caso.Id, caso);
			}
			if(caso.FormulatiempoSLA__c != oldCase.FormulatiempoSLA__c
				|| (caso.AccountId != oldCase.AccountId && oldCase.AccountId == null)) {
				updatedCases.add(caso);
			}
			if(caso.Estado_de_documentacion__c != oldCase.estado_de_documentacion__c
				&& caso.Estado_de_documentacion__c != 'Documentacion faltante'){
				casesWhereEstadoDeDocumentacionIsChanged.add(caso);
			}
			if(isFromEM && CaseTriggerHelper.hasChangesSomeFieldToUpdateEM(caso, oldCase)) {
				casesToUpdateFieldsOnEM.add(caso);
			}
			if((!oldCase.Retencion_lograda__c && caso.Retencion_lograda__c) && caso.Origin == 'Web'){
				casesIdBaja.add(caso.Id);
			}
			if(caso.RecordTypeId == reintegroRTId && caso.Status == 'Rechazado'){
				caso.Derivacion_de_lote__c	= 'Lote Devolucion';
				casesToChangeLote.add(caso);
			}
		}
		if(!casesToChangeLote.isEmpty()){
			if(!Test.isRunningTest()){
				Lote__c lote;
				if(ConfigUtils.isSandboxEnviroment()){
					lote = [SELECT Id, Name FROM Lote__c WHERE Name = 'LOTE-0004'];
				}else{
					lote = [SELECT Id,Name FROM Lote__c WHERE Name = 'LOTE-0001'];
				}
				for(Case caso : casesToChangeLote){
					caso.Lote__c = lote.Id;
				}
			}
		}
		if(!casesToChangeDelegacion.isEmpty()){
			CaseTriggerHelperWithoutSharing.cambiarDelegacionCDC(casesToChangeDelegacion);
		}
		if(!casesToUpdateStatus.isEmpty()){
			CaseTriggerHelperWithoutSharing.changeStateToDefaultPicklist(casesToUpdateStatus);
		}
		if(!casesIdBaja.isEmpty()){
			CaseTriggerHelper.darDeBajaCasos(casesIdBaja);
		}
		if(!casesToReopenSLAById.isEmpty()) {
			SLAUtils.reopenSLA(casesToReopenSLAById);
		}
		if(!updatedCases.isEmpty()) {
			SLAUtils.assignEntitlements(updatedCases);
		}
		if(!casesWithMedicoAsignadoChangedAndOldInNull.isEmpty()) {
			CaseTriggerHelper.validateMedicoAsignadoOldInNull(casesWithMedicoAsignadoChangedAndOldInNull, 'medico');
		}
		if(!casesWithMedicoAsignadoChangedAndOldNotNull.isEmpty()) {
			CaseTriggerHelper.validateMedicoAsignadoOldNotNull(casesWithMedicoAsignadoChangedAndOldNotNull, 'medico');
		}
		if(!casesWithResponsableChangedAndOldInNull.isEmpty()) {
			CaseTriggerHelper.validateMedicoAsignadoOldInNull(casesWithResponsableChangedAndOldInNull, 'responsable');
		}
		if(!casesWithResponsableChangedAndOldNotNull.isEmpty()) {
			CaseTriggerHelper.validateMedicoAsignadoOldNotNull(casesWithResponsableChangedAndOldNotNull, 'responsable');
		}
		if(!casesWithResponsablePresuChangedAndOldInNull.isEmpty()) {
			CaseTriggerHelper.validateMedicoAsignadoOldInNull(casesWithResponsablePresuChangedAndOldInNull, 'presupuesto');
		}
		if(!casesWithResponsablePresuChangedAndOldNotNull.isEmpty()) {
			CaseTriggerHelper.validateMedicoAsignadoOldNotNull(casesWithResponsablePresuChangedAndOldNotNull, 'presupuesto');
		}
		if(casesWhereEstadoDeDocumentacionIsChanged.size() > 0) {
			CaseTriggerHelper.derivaconAlCompletarDocumentacion(casesWhereEstadoDeDocumentacionIsChanged);
		}
		if(!casesToUpdateFieldsOnEM.isEmpty()) {
			CaseTriggerHelper.updateFieldsOnEM(casesToUpdateFieldsOnEM);
		}
	}
	public override void beforeDelete() {
		// Nothing
	}
	public override void afterInsert() {
		Map<Id, List<Case>> userIdCasesMap = new Map<Id, List<Case>>();
		List<Id> casesToChangeDelegacionFront = new List<Id>();
		for (Case caso : lNew) {
			if(caso.RecordTypeId == casoATipificarRtId){
				casesToChangeDelegacionFront.add(caso.Id);
			}
			if (userIdCasesMap.containsKey(caso.OwnerId)) {
				List<Case> casesFromMap = userIdCasesMap.get(caso.OwnerId);
				casesFromMap.add(new Case(Id = caso.Id));
				userIdCasesMap.put(caso.OwnerId, casesFromMap);
			} else {
				userIdCasesMap.put(caso.OwnerId, new List<Case>{new Case(Id = caso.Id)});
			}
		}
		if (!userIdCasesMap.isEmpty()) {
			CaseTriggerHelper.assignDelegacionFromUser(userIdCasesMap);
		}
		if(!casesToChangeDelegacionFront.isEmpty()){
			CaseTriggerHelperWithoutSharing.cambiarDelegacionFront(casesToChangeDelegacionFront);
		}
	}
	public override void afterUpdate() {
		List<Case> reintegrosAReasignar =  new List<Case>();
		Map<Id, String> mapCases = new Map<Id, String>();
		Case[] casesChangeAlertAMPending = new List<Case>();
		Map<Id, Case> casesToReopenSLAById = new Map<Id, Case>();
		Boolean isAsync = System.isFuture() || System.isQueueable();
		for(Case caso : lNew){
			Case oldCase = mOld.get(caso.Id);
			Boolean changeContieneAlertaAM = caso.Contiene_alerta_AM__c != oldCase.Contiene_alerta_AM__c;
			Boolean changeSinAlertaAM = caso.Sin_alertas_AM_pendientes__c != oldCase.Sin_alertas_AM_pendientes__c;
			if(caso.RecordTypeId == reintegroRtId
				&& caso.Lote__c != mOld.get(caso.Id).Lote__c
				&& caso.Codigo_reintegro_SS__c != null) {
				reintegrosAReasignar.add(caso);
			}
			if(caso.Evento_Medico__c != null && (changeContieneAlertaAM || changeSinAlertaAM)) {
				casesChangeAlertAMPending.add(caso);
			}
			if(caso.RecordTypeId == XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id) {
				if(caso.Status == 'CA-----N') {
					mapCases.put( caso.Orden_de_Compra__c, 'Anulada');
				}

				else if(caso.Status == 'CA-----E') {
					mapCases.put(caso.Orden_de_Compra__c, 'Finalizada');
				}

				else if(caso.Status == 'Rechazado' || caso.caso_rechazado__c == true) {
					mapCases.put(caso.Orden_de_Compra__c, 'Rechazada');
				}
			}
		}
		List<Orden_de_Compra__c> ordenes = [SELECT Id,
												Estado_OC__c,
												(SELECT Id
													FROM Cotizaciones_Prestadores__r)
											FROM Orden_de_Compra__c
											WHERE Id IN :mapCases.keySet()];
		for (Orden_de_Compra__c orden : ordenes) {
			orden.Estado_OC__c = mapCases.get(orden.Id);
			if(orden.Estado_OC__c == 'Finalizada' && orden.Cotizaciones_Prestadores__r.isEmpty()) {
				orden.Estado_OC__c = 'Desestimada';
			}
		}
		update ordenes;
		if(!reintegrosAReasignar.isEmpty() && !isAsync) {
			System.enqueueJob(new ReintegroReasignacionQueueable(reintegrosAReasignar));
		}
		if(!casesChangeAlertAMPending.isEmpty()) {
			CaseTriggerHelper.checkNoAlertsPendingOnEM(casesChangeAlertAMPending);
		}
	}
	public override void afterDelete() {
		// Nothing
	}
	public override void afterUndelete() {
		// Nothing
	}
}