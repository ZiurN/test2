public class DocuSignStatusHelper {
    public static void overwriteOpportunityWithNewFile(List<dsfs__DocuSign_Status__c> statusDocuSigns, Map<Id, dsfs__DocuSign_Status__c> oldstatusDocuSignsById) {
        Map<Id, ContentVersion> cvById = new Map<Id, ContentVersion>();
        Map<Id, ContentDocumentLink> cdLinkByDocuSignId = new Map<Id, ContentDocumentLink>();
        Map<Id, ContentDocumentLink> cdLinkByStatusDocumentId = new Map<Id, ContentDocumentLink>();
        Map<Id, ContentDocumentLink> cdLinkByOpportunityId = new Map<Id, ContentDocumentLink>();
        Map<Id, ContentDocumentLink> cdLinkByOpportunityDocumentId = new Map<Id, ContentDocumentLink>();
        Map<Id, dsfs__DocuSign_Status__c> statusToProcessByOpportunities = new Map<Id, dsfs__DocuSign_Status__c>();
        List<ContentDocumentLink> cdLinksToDelete = new List<ContentDocumentLink>();
        Set<Id> opportunitiesIds = new Set<Id>();
        Set<Id> statusIds = new Set<Id>();
        List<ContentDocumentLink> newDocuments = new List<ContentDocumentLink>();
        List<dsfs__DocuSign_Status__c> statusToUpdate = new List<dsfs__DocuSign_Status__c>();

        for (dsfs__DocuSign_Status__c newStatus : statusDocuSigns) {
            if((newStatus.dsfs__Envelope_Status__c != oldstatusDocuSignsById.get(newStatus.Id).dsfs__Envelope_Status__c)
            && (newStatus.dsfs__Opportunity__c != null)
            && (newStatus.dsfs__Envelope_Status__c.contains('Completed'))){
                statusToProcessByOpportunities.put(newStatus.dsfs__Opportunity__c, newStatus);
                opportunitiesIds.add(newStatus.dsfs__Opportunity__c);
                statusIds.add(newStatus.Id);
                statusToUpdate.add(newStatus);
            }
        }

        if(!statusIds.isEmpty()
            && !opportunitiesIds.isEmpty()
            && !statusToProcessByOpportunities.isEmpty())
        {
                //GET DOCUSIGN STATUS DATA
            List<ContentDocumentLink> cdLinkDocuSign = [
                SELECT Id, ContentDocument.Title, ContentDocumentId, LinkedEntityId 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId IN: statusIds
            ];

            for(ContentDocumentLink cd : cdLinkDocuSign){
                cdLinkByDocuSignId.put(cd.LinkedEntityId, cd);
                cdLinkByStatusDocumentId.put(cd.ContentDocumentId, cd);
            }

            //GET OPPORTUNITIES DATA
            List<Opportunity> opportunities = [
                SELECT Id, Name
                FROM Opportunity
                WHERE Id IN: opportunitiesIds
            ];

            List<ContentDocumentLink> cdLinkOpportunities = [
                SELECT Id, ContentDocument.Title, ContentDocumentId, LinkedEntityId 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId IN: opportunitiesIds
            ];
            
            if(!cdLinkOpportunities.isEmpty()){
                for(ContentDocumentLink cd : cdLinkOpportunities){
                    cdLinksToDelete.add(cd);
                    //cdLinkByOpportunityId.put(cd.LinkedEntityId, cd);
                    //cdLinkByOpportunityDocumentId.put(cd.ContentDocumentId, cd);
                }
                if(!cdLinksToDelete.isEmpty()){
                    delete cdLinksToDelete;

                    for(ContentDocumentLink cdLink : cdLinkOpportunities){
                        ContentDocumentLink cDe = new ContentDocumentLink();
                        cDe.ContentDocumentId = cdLinkByDocuSignId.get(statusToProcessByOpportunities.get(cdLink.LinkedEntityId).Id).ContentDocumentId;
                        cDe.LinkedEntityId = cdLink.LinkedEntityId; // you can use objectId,GroupId etc
                        cDe.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
                        cDe.Visibility = 'AllUsers';
                        newDocuments.add(cDe);
                    }
                }
            }
            else{
                for(Opportunity op : opportunities){
                    ContentDocumentLink cDe = new ContentDocumentLink();
                    cDe.ContentDocumentId = cdLinkByDocuSignId.get(statusToProcessByOpportunities.get(op.Id).Id).ContentDocumentId;
                    cDe.LinkedEntityId = op.Id; // you can use objectId,GroupId etc
                    cDe.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
                    cDe.Visibility = 'AllUsers';
                    newDocuments.add(cDe);
                }  
            }
            insert newDocuments;
        }
    }
}