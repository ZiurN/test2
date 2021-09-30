trigger DocuSignStatusTrigger on dsfs__DocuSign_Status__c (after update) {
    List<dsfs__DocuSign_Status__c> newStatusDocuSign = new List<dsfs__DocuSign_Status__c>();
    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            for(dsfs__DocuSign_Status__c newStatus : Trigger.new){
                if((newStatus.dsfs__Envelope_Status__c != Trigger.oldMap.get(newStatus.Id).dsfs__Envelope_Status__c)
                && (newStatus.dsfs__Opportunity__c != null)
                && (newStatus.dsfs__Envelope_Status__c.contains('Completed'))
                && (Trigger.oldMap.get(newStatus.Id).dsfs__Envelope_Status__c.contains('Sent'))){
                    newStatusDocuSign.add(newStatus);
                }
            }
            
            if(!newStatusDocuSign.isEmpty()){
                DocuSignStatusHelper.overwriteOpportunityWithNewFile(newStatusDocuSign, Trigger.oldMap);
            }
        }
    }
}