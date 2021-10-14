trigger PrestacionTrigger on Prestacion__c (
	after insert, after update,
	before delete
	){
	if(Trigger.isBefore) {
		if(Trigger.isDelete) {
			Map<Id, Prestacion__c> prestsToDelete = new Map<Id, Prestacion__c>();
			for(Prestacion__c prest : Trigger.old) {
				if(String.isNotBlank(prest.Ap__c)) {
					prestsToDelete.put(prest.Id, prest);
				}
			}
			if(!prestsToDelete.isEmpty()) {
				PrestacionTriggerHelper.deleteWhenCasesStatusIsNotCentroAutorizador(prestsToDelete);
			}
		}
	}
	if(Trigger.isAfter) {
		if(Trigger.isInsert) {
			//Prestacion__c[] prestacionesToAuthorizeCase = new List<Prestacion__c>();
			Set<String> caseIdsToAuthorize = new Set<String>();
			Prestacion__c[] prestacionesToValidateDuplicateNomencladorOrMedicamento = new List<Prestacion__c>();
			for(Prestacion__c prest : Trigger.new) {
				if(prest.Ap__c != null
					&& (prest.Estado__c == 'C1----AS' || prest.Estado__c == 'C1EA--AA')
				) {
					caseIdsToAuthorize.add(prest.Ap__c);
				}

				if(prest.Ap__c != null && (prest.Prestacion__c != null || prest.Medicamento__c != null)) {
					prestacionesToValidateDuplicateNomencladorOrMedicamento.add(prest);
				}
			}
			if(!caseIdsToAuthorize.isEmpty()) {
				PrestacionTriggerHelper.authorizeCases(caseIdsToAuthorize);
			}
			if(!prestacionesToValidateDuplicateNomencladorOrMedicamento.isEmpty()) {
				PrestacionTriggerHelper.validateDuplicateNomencladorOrMedicamento(prestacionesToValidateDuplicateNomencladorOrMedicamento);
			}
		}
		if(Trigger.isUpdate) {
			Set<String> caseIdsToAuthorize = new Set<String>();
			Prestacion__c[] prestacionesToValidateDuplicateNomencladorOrMedicamento = new List<Prestacion__c>();

			for(Prestacion__c prest : Trigger.new) {
				Prestacion__c prestOld = Trigger.oldMap.get(prest.Id);
				Boolean changesPrest = prest.Prestacion__c != prestOld.Prestacion__c;
				Boolean changesMed = prest.Medicamento__c != prestOld.Medicamento__c;
				if(prest.Estado__c != prestOld.Estado__c
					&& prest.Ap__c != null
					&& (prest.Estado__c == 'C1----AS' || prest.Estado__c == 'C1EA--AA')
				) {
					caseIdsToAuthorize.add(prest.Ap__c);
				}
				if(prest.Ap__c != null
					&& (changesPrest && prest.Prestacion__c != null || changesMed && prest.Medicamento__c != null)
				) {
					prestacionesToValidateDuplicateNomencladorOrMedicamento.add(prest);
				}
			}
			if(!caseIdsToAuthorize.isEmpty() && PrestacionTriggerHelper.firstRun) {
				PrestacionTriggerHelper.firstRun = false;
				PrestacionTriggerHelper.authorizeCases(caseIdsToAuthorize);
			}
			if(!prestacionesToValidateDuplicateNomencladorOrMedicamento.isEmpty()) {
				PrestacionTriggerHelper.validateDuplicateNomencladorOrMedicamento(prestacionesToValidateDuplicateNomencladorOrMedicamento);
			}
		}
	}
}