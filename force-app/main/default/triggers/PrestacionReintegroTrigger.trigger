trigger PrestacionReintegroTrigger on Prestacion_de_reintegro__c (after insert, before update, after update)  { 
	if(Trigger.isAfter) {
		Boolean isTestBatch = true;
		for(Prestacion_de_reintegro__c prest : Trigger.new){
			isTestBatch = isTestBatch && prest.HD__c != null && prest.HD__c == 'prestacion batch prueba' && Test.isRunningTest();
		}
		if(!isTestBatch){
			Map<Id,Prestacion_de_reintegro__c> mapNewPrest = new Map<Id,Prestacion_de_reintegro__c>();
			mapNewPrest.putAll(Trigger.newMap);
			PrestacionReintegroTriggerHelper.updateReintegroTotalFieldInCasesAssociate(mapNewPrest);
		}
		
		if(Trigger.isInsert) {
			Prestacion_de_reintegro__c[] prestacionesEnAuditoria = new List<Prestacion_de_reintegro__c>();

			for(Prestacion_de_reintegro__c prest : Trigger.new) {
				
				if(prest.Caso__c != null && prest.Estado__c == 'C1-----A') {
					prestacionesEnAuditoria.add(prest);
				}
			}

			PrestacionReintegroTriggerHelper.checkPrestacionesEnAuditoriaInCase(prestacionesEnAuditoria);

		}

		if(Trigger.isUpdate) {
			Map<Id,Prestacion_de_reintegro__c> presToUpdate = new Map<Id,Prestacion_de_reintegro__c>();
			for(Prestacion_de_reintegro__c prest : Trigger.new){
				Prestacion_de_reintegro__c viejaPrestacion = Trigger.oldMap.get(prest.Id);
				if(viejaPrestacion.Importe_Reintegro_auditor__c != prest.Importe_Reintegro_auditor__c ||
					viejaPrestacion.Importe_Reintegro_sys__c != prest.Importe_Reintegro_sys__c){
					presToUpdate.put(prest.Id,prest);
				}
			}
			if(!presToUpdate.isEmpty()){
				PrestacionReintegroTriggerHelper.updateReintegroTotalFieldInCasesAssociate(presToUpdate);
			}
			Prestacion_de_reintegro__c[] prestacionesWithStatusChanged = new List<Prestacion_de_reintegro__c>();

			for(Prestacion_de_reintegro__c prest : Trigger.new) {
				Prestacion_de_reintegro__c prestOld = Trigger.oldMap.get(prest.Id);
				
				if(prest.Caso__c != null && prest.Estado__c != prestOld.Estado__c) {
					prestacionesWithStatusChanged.add(prest);
				}
			}

			PrestacionReintegroTriggerHelper.checkPrestacionesEnAuditoriaInCase(prestacionesWithStatusChanged);

		}
	}
}