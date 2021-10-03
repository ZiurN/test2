trigger LoteTrigger on Lote__c (after insert)  { 
	
	if(Trigger.isAfter){
		if(Trigger.isInsert){
			List<Lote__c> lotes = new List<Lote__c>();

			for(Lote__c lote : Trigger.new){
				if(lote.Tipo__c != 'Pendiente' && lote.Tipo__c != 'Devoluciones'){
					lotes.add(lote);
				}
				
			}
			
			//LoteTriggerHelper.sendToSSAndFillFields(Trigger.new);
			System.enqueueJob(new LoteQueueable(lotes));
		}

	}
}