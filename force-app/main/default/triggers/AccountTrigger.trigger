trigger AccountTrigger on Account (before update, after update)  { 
	if(Trigger.isBefore) {
		if(Trigger.isUpdate) {
			WSDatosAfiliados.updateAccountDetailsToWS(Trigger.new, Trigger.oldMap);
		}
	} else if(Trigger.isAfter) {
        
		if(Trigger.isUpdate) {

			Id[] accsToUpdateFacturaElectronicaInSS = new List<Id>();

			for(Account acc : Trigger.new) {
                Account oldAcc = Trigger.oldMap.get(acc.Id);
				Boolean isAsync = System.isBatch() || System.isFuture() || System.isQueueable() || System.isScheduled();
				
				if(acc.Envio_de_recibo__c != oldAcc.Envio_de_recibo__c && !isAsync) {
					accsToUpdateFacturaElectronicaInSS.add(acc.Id);
				}
			}
			if(!accsToUpdateFacturaElectronicaInSS.isEmpty()) {
				AccountTriggerHelper.updateFacturaElectronicaOnSS(accsToUpdateFacturaElectronicaInSS);
			}
		}

	}

}