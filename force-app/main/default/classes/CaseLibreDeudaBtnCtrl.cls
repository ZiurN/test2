public without sharing class CaseLibreDeudaBtnCtrl {
	
	@AuraEnabled
	public static Response generatePdf(String caseId) {
		
		List<Case> caso = [
			SELECT Id, AccountId, Account.Plan_Nombre__c, Account.Type, Account.RecordType.DeveloperName, Account.Estado__c 
			FROM Case 
			WHERE Id = :caseId
			];

		if(caso[0].AccountId == null) {
			return new Response(true, 'El caso debe tener una cuenta asociada.');
		} 
		if(caso[0].Account.RecordType.DeveloperName != 'Cuenta_personal') {
			return new Response(true, 'La cuenta asociada al caso no es de un asociado.');
		}
		if(caso[0].Account.Type != 'TIT') {
			return new Response(true, 'La cuenta asociada al caso no pertenece a un titular.');
		}
		if(caso[0].Account.Estado__c != 'B') {
			return new Response(true, 'La cuenta asociada al caso no está dada de baja.');
		}

		return attachPDF(caso[0]);

	}

	private static PageReference getTheCorrectVF(Case caso) {
		PageReference vf;
		String plan = caso.Account.Plan_Nombre__c;
		Boolean planCopago = false;
		
		if(plan != null) {
			planCopago = plan.contains('AS300') || plan.contains('AS200') || plan.contains('AS204');
		}

		if(planCopago) {
			vf = new PageReference('/apex/LibreDeudaCopago?id=' + caso.AccountId);
		}
		else {
			vf = new PageReference('/apex/LibreDeuda?id=' + caso.AccountId);
		}

		return vf;
	}

	private static ContentVersion buildPDF(Blob pdfBody, String cdId) {
		ContentVersion version = new ContentVersion();
		version.PathOnClient = '/Libre_deuda_asociado.pdf';
		version.Title = 'Libre_deuda_asociado';
		version.VersionData = pdfBody;
		if(cdId != null) {
			version.ContentDocumentId = cdId;
		}

		return version;
	}

	private static Response attachPDF(Case caso) {
		ContentDocumentLink[] links = [
			SELECT Id, ContentDocument.LatestPublishedVersion.Title, ContentDocumentId
			FROM ContentDocumentLink
			WHERE LinkedEntityId = :caso.Id
			AND ContentDocument.LatestPublishedVersion.Title = 'Libre_deuda_asociado'
		];
		ContentVersion version = new ContentVersion();
		PageReference vf = getTheCorrectVF(caso);
		
		Blob pdfBody;
		
		try{
			pdfBody = vf.getContentAsPDF();
		}
		catch(Exception e){
			System.debug(e);
			if(Test.isRunningTest()){
				pdfBody = Blob.valueOf('test');
			}
			else{
				return new Response(true, 'Error al generar el pdf');
			}
		}

		if(!links.isEmpty()) {
			version = buildPDF(pdfBody, links[0].ContentDocumentId);
			
			insert version;
		}
		else {
			version = buildPDF(pdfBody, null);
			
			insert version;

			ContentVersion versionsUpdated = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :version.Id];
			ContentDocumentLink cdl = new ContentDocumentLink(
				LinkedEntityId = caso.Id,
				ShareType = 'V',
				ContentDocumentId = versionsUpdated.ContentDocumentId
			);

			Database.SaveResult resultCdl = Database.insert(cdl);
			System.debug('****resultCDL: ' + resultCdl);
		}

		return new Response(false, 'Se ha adjuntado el pdf correctamente.');	
	}

	public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;

        public Response(Boolean hasError, String message) {
            this.hasError = hasError;
            this.message = message;
        }
	}
}