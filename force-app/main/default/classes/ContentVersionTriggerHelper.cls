public class ContentVersionTriggerHelper {
	public static void copyContentNoteToNotaFieldInLead(Map<Id, String> dataStringByContentDocumentIds) {
		Map<Id, Id> leadIdByContentNoteId = new Map<Id, Id>();
		Lead[] leadsToUpdate = new List<Lead>(); 

		for(ContentDocument cd : [
			SELECT Id, FileType,
				(SELECT LinkedEntityId FROM ContentDocumentLinks WHERE LinkedEntity.Type = 'Lead')
			FROM ContentDocument
			WHERE Id IN :dataStringByContentDocumentIds.keySet()
		]) {
			
			if(cd.FileType == 'SNOTE' && !cd.ContentDocumentLinks.isEmpty()) {
				leadIdByContentNoteId.put(cd.Id, cd.ContentDocumentLinks[0].LinkedEntityId);
			}
		}

		System.debug('****leadIdByContentNoteId: ' + leadIdByContentNoteId);
			
		Lead[] leadsWithAttachedContentNotes = [
			SELECT Id, Nota__c, (
				SELECT id, TextPreview, FileType, CreatedDate FROM AttachedContentNotes ORDER BY CreatedDate DESC
			) 
			FROM Lead 
			WHERE Id IN :leadIdByContentNoteId.values()
		];

		System.debug('****leadsWithAttachedContentNotes: ' + leadsWithAttachedContentNotes);

		for(Lead cand : leadsWithAttachedContentNotes) {
			String dataString = dataStringByContentDocumentIds.get(cand.AttachedContentNotes[0].Id);

			System.debug('****cand.AttachedContentNotes[0].TextPreview: ' + cand.AttachedContentNotes[0].TextPreview);
			System.debug('****dataString: ' + dataString);

			if(String.isBlank(dataString)) {
				dataString = cand.AttachedContentNotes[0].TextPreview;
			}
			
			if(String.isNotBlank(dataString)) {
				if(cand.Nota__c != dataString) {
					cand.Nota__c = dataString;

					leadsToUpdate.add(cand);
				}
			}
			
		}

		update leadsToUpdate;
	}

	// dice opportunities pero sirve para casos tmb 
	public static void avoidUploadANewVersion(
		Map<Id, ContentVersion> ContentVersionBycontentDocumentId
	) {
		String[] caseRT = new List<String>{
			'Solicitud_de_alta_familiar', 'Solicitud_de_baja', 'Solicitud_de_cambio_de_plan', 
			'Solicitud_de_datos_particulares', 'Solicitud_de_despegues', 'Solicitud_de_nueva_credencial',
			'Solicitud_de_segmento', 'Interfaz_financiera'
		};
		Id[] opportunityContentDocumentIds = new List<Id>();
		// Id[] caseContentDocumentIds = new List<Id>();
		
		for(ContentDocumentLink cdl : [
			SELECT Id, ContentDocumentId, LinkedEntityId, LinkedEntity.RecordType.DeveloperName, LinkedEntity.Type 
			FROM ContentDocumentLink 
			WHERE ContentDocumentId IN :ContentVersionBycontentDocumentId.keySet() 
		]) {
			if(cdl.LinkedEntity.Type == 'Opportunity' && cdl.LinkedEntity.RecordType.DeveloperName == 'Individuos'
				|| cdl.LinkedEntity.Type == 'Case' && caseRT.contains(cdl.LinkedEntity.RecordType.DeveloperName)
			) {
				opportunityContentDocumentIds.add(cdl.ContentDocumentId);
			}
		}

		for(ContentDocument cd : [
			SELECT Id, (SELECT Id FROM ContentVersions) FROM ContentDocument WHERE Id IN :opportunityContentDocumentIds
		]) {
			if(cd.ContentVersions.size() > 1) {
				ContentVersionBycontentDocumentId.get(cd.Id).addError('No se permite cargar una nueva version');
			}
		}
	}
}