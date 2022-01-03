/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase manejadora del desencadenador para el objeto EmailMessage
@date			23/12/2021
------------------------------------------------------------------------------------------------------------------------*/
@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class EmailMessageTriggerHelper {
   	public static void ifEmailHaveFilesDeleteCDLinksIfParentHasTheSame (List<EmailMessage> emailsToSend) {
		String regExp = '(?<=documentforce\\.com\\/sfc\\/servlet\\.shepherd\\/version\\/download\\/).{15,18}(?=\\?)';
		Pattern p = Pattern.compile(regExp);
		Set<Id> listIDs = new Set<Id>();
		Set<Id> emailsIds = new Set<Id>();
		for (EmailMessage emailToSend : emailsToSend) {
			String htmlBody = emailToSend.HtmlBody;
			if (!String.isBlank(htmlBody)) {
				Matcher m = p.matcher(htmlBody);
				while(m.find()) {
					listIDs.add(m.group(0));
					emailsIds.add(emailToSend.Id);
				}
			}
		}
		if (!listIDs.isEmpty()) {
			List<ContentVersion> contentVs= [SELECT ContentDocumentId,
												Titulo_original__c
											FROM ContentVersion
											WHERE Id IN :listIDs];
			Set<Id> contentDocumentsIds = new Set<Id>();
			for (ContentVersion cv: contentVs) {
				contentDocumentsIds.add(cv.ContentDocumentId);
			}
			List<ContentDocumentLink> cdLinksToDelete = [SELECT Id
														FROM ContentDocumentLink
														WHERE LinkedEntityId IN: emailsIds
															AND ContentDocumentId IN: contentDocumentsIds];
			if (!cdLinksToDelete.isEmpty()) {
				delete cdLinksToDelete;
			}
		}
	}
}