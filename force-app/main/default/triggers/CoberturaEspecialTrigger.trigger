trigger CoberturaEspecialTrigger on Cobertura_Especial__c (
	before delete, after insert, 
	after update
	) {
	
	if(Trigger.isBefore) {
		if(Trigger.isDelete) {
			CoberturaEspecialTriggerHelper.avoidDeletionOfSentCoberturas(Trigger.old);
		}
	}
	else if(Trigger.isAfter) {
		if(Trigger.isInsert) {
			List<Cobertura_Especial__c> coberturasToSendToSS = new List<Cobertura_Especial__c>();
			
			for(Cobertura_Especial__c cobertura : Trigger.new) {
				if(String.isBlank(cobertura.Id_externo__c)) {
					coberturasToSendToSS.add(cobertura);
				}
			}

			System.enqueueJob(new CoberturaEspecialQueueable(coberturasToSendToSS));
		}
		else if(Trigger.isUpdate) {
			List<Cobertura_Especial__c> coberturasToSendToSS = new List<Cobertura_Especial__c>();

			for(Cobertura_Especial__c cobertura : Trigger.new) {
				Cobertura_Especial__c oldCobertura = Trigger.oldMap.get(cobertura.Id);

				if((String.isBlank(cobertura.Id_externo__c) 
					|| CoberturaEspecialTriggerHelper.isChangedSomeFieldToSendToSS(cobertura, oldCobertura))
					&& !UserInfo.getName().contains('Integracion')
				) {
					System.debug('Entra al enviar a ss de cobertura');
					coberturasToSendToSS.add(cobertura);
				}
			}

			if(!coberturasToSendToSS.isEmpty() && !System.isQueueable()) {
				System.enqueueJob(new CoberturaEspecialQueueable(coberturasToSendToSS));
			}
		}
	}

}