public class PrestacionReintegroTriggerHelper  {
	
	public static void checkPrestacionesEnAuditoriaInCase(Prestacion_de_reintegro__c[] prestaciones) {
		Set<Id> idReintegros = new Set<Id>();
		Case[] reintegrosToUpdate = new List<Case>();

		for(Prestacion_de_reintegro__c prest : prestaciones) {
			idReintegros.add(prest.Caso__c);
		}
		  
		Case[] reintegros = [
			SELECT Id, Prestaciones_en_auditoria__c, 
				(SELECT Id, Estado__c FROM Prestaciones_de_reintegros__r)
			FROM Case
			WHERE Id IN :idReintegros
		];

		for(Case reintegro : reintegros) {
			Boolean prestacionesEnAuditoria = false;

			for(Prestacion_de_reintegro__c prest : reintegro.Prestaciones_de_reintegros__r) {
				if(prest.Estado__c == 'C1-----A') {
					prestacionesEnAuditoria = true;
				}
			}

			System.debug(reintegro.Prestaciones_en_auditoria__c);
			if(prestacionesEnAuditoria != reintegro.Prestaciones_en_auditoria__c) {
				reintegro.Prestaciones_en_auditoria__c = prestacionesEnAuditoria;
				reintegro.Cambio_Manual__c = false;
				reintegrosToUpdate.add(reintegro);
			}
		}

		update reintegrosToUpdate;
		
	}

	public static void updateReintegroTotalFieldInCasesAssociate(Map<Id,Prestacion_de_reintegro__c> prestUpdatedOrCreated){
		
		Map<Id,Decimal> mapIdCaseImporteReintegro = new Map<Id,Decimal>();
		/*Map<Id,Prestacion_de_reintegro__c> mapIdPrest = new Map<Id,Prestacion_de_reintegro__c>();
		mapIdPrest.putAll(prestUpdatedOrCreated);*/
		Set<Id> setIdCasosAsociados = new Set<Id>();
		for(Prestacion_de_reintegro__c prest : prestUpdatedOrCreated.values()){
			setIdCasosAsociados.add(prest.Caso__c);
		}
		for(Prestacion_de_reintegro__c prestAsociadas : [
			SELECT Id, Caso__c,Caso__r.Reintegro_total__c, Cantidad__c,Importe_reintegro_Auditor__c, Importe_reintegro_Sys__c 
			FROM Prestacion_de_reintegro__c 
			WHERE Id NOT IN :prestUpdatedOrCreated.keySet() 
			AND Caso__c IN :setIdCasosAsociados]
		){
			prestUpdatedOrCreated.put(prestAsociadas.Id,prestAsociadas);
		}
		for(Prestacion_de_reintegro__c prest : prestUpdatedOrCreated.values()){
			if(!String.isBlank(prest.Caso__c)){
				
				if(prest.Importe_Reintegro_auditor__c != null || prest.Importe_reintegro_sys__c != null){
					Decimal cantidad = prest.Cantidad__c == null ? 1 : prest.Cantidad__c ;
					System.debug('cantidad: ' + cantidad);
					if(mapIdCaseImporteReintegro.containsKey(prest.Caso__c)){
					
						Decimal totalActual = mapIdCaseImporteReintegro.get(prest.Caso__c);

						System.debug(totalActual + ' + ' + prest.Importe_Reintegro_auditor__c); 
						Decimal importeAIngresar = 0;
						if(
							(prest.Importe_Reintegro_Auditor__c == 0 || prest.Importe_Reintegro_auditor__c == null) &&
							(prest.Importe_Reintegro_sys__c != 0 && prest.Importe_reintegro_sys__c != null)
						){
							importeAIngresar = prest.Importe_Reintegro_sys__c * cantidad;
						}else if(prest.Importe_reintegro_Auditor__c != 0  && prest.Importe_reintegro_Auditor__c != null){
							importeAIngresar = Prest.Importe_reintegro_Auditor__c * cantidad;
						}
						System.debug(importeAIngresar);
						totalActual += importeAIngresar;
						mapIdCaseImporteReintegro.put(prest.Caso__c,totalActual);
					}else{
						Decimal importeAIngresar = 0;
						if(
							(prest.Importe_Reintegro_Auditor__c == 0 || prest.Importe_Reintegro_auditor__c == null) &&
							(prest.Importe_Reintegro_sys__c != 0 && prest.Importe_reintegro_sys__c != null)
						){
							importeAIngresar = prest.Importe_Reintegro_sys__c * cantidad;
						}else if(prest.Importe_reintegro_Auditor__c != 0 && prest.Importe_reintegro_Auditor__c != null){
							importeAIngresar = Prest.Importe_reintegro_Auditor__c * cantidad;
						}
						System.debug(importeAIngresar);
						mapIdCaseImporteReintegro.put(prest.Caso__c,importeAIngresar);
					}
				}				
			}
		}

		List<Case> listaCasosAsociados = new List<Case>();
		if(!mapIdCaseImporteReintegro.keySet().isEmpty()){
			listaCasosAsociados = [
				SELECT Id,Reintegro_Total__c,RecordType.Name
				FROM Case
				WHERE Id IN :mapIdCaseImporteReintegro.keySet()
			];	
		}

		for(Case casoAsociado : listaCasosAsociados){
			System.debug(casoAsociado);
			if(mapIdCaseImporteReintegro.containsKey(casoAsociado.Id)){
				System.debug(mapIdCaseImporteReintegro);
				/*if(casoAsociado.Reintegro_Total__c == 0 || casoAsociado.Reintegro_Total__c == null){
					casoAsociado.Reintegro_Total__c = mapIdCaseImporteReintegro.get(casoAsociado.Id);
				}else{
					casoAsociado.Reintegro_Total__c += mapIdCaseImporteReintegro.get(casoAsociado.Id);
				}*/
				casoAsociado.Reintegro_Total__c = mapIdCaseImporteReintegro.get(casoAsociado.Id);
			}
		}

		update listaCasosAsociados;
	}
}