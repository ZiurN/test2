public class TranscriptionChatCloseCasesQueueable implements Database.batchable<LiveChatTranscript>, Database.AllowsCallouts, Database.stateful { 

    Id casoATipificar = [SELECT idtipoderegistro__c FROM Tipo_de_registro__mdt WHERE DeveloperName = 'caso_a_tipificar'].idtipoderegistro__c;

    public Iterable<LiveChatTranscript> start(Database.BatchableContext info){
        List<LiveChatTranscript> chats = [SELECT Status, CaseId FROM LiveChatTranscript WHERE Status = 'Completed' AND Case.Status = 'En proceso' AND LastModifiedDate > :Date.today().addDays(-2)];
        return chats;
    }     

    public void execute(Database.BatchableContext info, List<LiveChatTranscript> scope){
        Map<Id, LiveChatTranscript> chatsToCheck = new Map<Id, LiveChatTranscript>();
        Map<Id, List<LiveChatTranscriptEvent>> eventsByChatId = new Map<Id, List<LiveChatTranscriptEvent>>();
        Map<Id, Id> caseByChatId = new Map<Id, Id>();
        Set<Id> casesToUpdate = new Set<Id>();
        for(LiveChatTranscript lCT : scope) {
            caseByChatId.put(lCT.id, lCT.CaseId);
            chatsToCheck.put(lCT.Id, lCT);
        }
        for(LiveChatTranscriptEvent event :[SELECT AgentId, LiveChatTranscriptId From LiveChatTranscriptEvent WHERE LiveChatTranscriptId IN :chatsToCheck.keySet()]){
            if(eventsByChatId.containsKey(event.LiveChatTranscriptId)) {
                List<LiveChatTranscriptEvent> chatEvents = eventsByChatId.get(event.LiveChatTranscriptId);
                chatEvents.add(event);
            } else {
                eventsByChatId.put(event.LiveChatTranscriptId, new List<LiveChatTranscriptEvent> {event});
            }
        }
        for(Id chatId :chatsToCheck.keySet()) {
            Boolean isBotChat = true;
            if(eventsByChatId.containsKey(chatId)) {
                for(LiveChatTranscriptEvent lCTE :eventsByChatId.get(chatId)) {
                    if(lCTE.AgentId != null) {
                        isBotChat = false;
                        break;
                    }
                }
            }
            if(isBotChat) {
                if(caseByChatId.containsKey(chatId)) {
                    casesToUpdate.add(caseByChatId.get(chatId));
                }
            }
        }
        if(!casesToUpdate.isEmpty()) {
            List<Case> updateList = new List<Case>();
            for(Case caso :[SELECT Status, id FROM Case WHERE id IN :casesToUpdate AND RecordTypeId = :casoATipificar]){
                caso.Status = 'Cerrado';
                updateList.add(caso);
            }
            if(!updateList.isEmpty()) {
                List<Database.SaveResult> result = database.update(updateList, false);
                for(Database.SaveResult res :result){
                    if(!res.isSuccess()) {
                        System.debug(res.getErrors());
                    }
                }
            }
        }
        
    }     
    public void finish(Database.BatchableContext info){ 
        AsyncApexJob objAsyncJob = [SELECT Id, TotalJobItems, NumberOfErrors, CompletedDate, CreatedDate FROM AsyncApexJob WHERE Id = :info.getJobId()];
         // Email Body
        String strBatchBody = 'The batch apex job processed ' + objAsyncJob.TotalJobItems + ' batches with ' + objAsyncJob.NumberOfErrors + ' failures.'
                   + 'Start time: ' + objAsyncJob.CreatedDate.format('MM/dd/yyyy HH:mm') + ''
                   + 'End time: ' + objAsyncJob.CompletedDate.format('MM/dd/yyyy HH:mm') + ''
                   + 'Time taken in minutes: ' + ((Decimal)(objAsyncJob.CompletedDate.getTime() - objAsyncJob.CreatedDate.getTime())/1000/60).setScale(2);
        System.debug(strBatchBody);
    } 
 }