public class EfectorGetPdfConveniosBtnCtrl  {

	@AuraEnabled
	public static Response attachPfdConvenios(Id idEfector) {
		Account efector = [SELECT Id, Codigo_de_efector__c FROM Account WHERE Id = :idEfector];
		
		if(String.isBlank(efector.Codigo_de_efector__c)) {
			return new Response(false, 'El código de efector esta vacío.');
		}

		WSEfectorGetPdfConvenios.Response resp = WSEfectorGetPdfConvenios.getPdfConvenios(efector.Codigo_de_efector__c);

		if(!resp.hasError) {
			String[] titles = getAllTitles(resp.result.data);
			ContentVersion[] versions = getAllNonExistentContentVersions(resp.result.data, titles, idEfector);

			Database.SaveResult[] resultVersions = Database.insert(versions);
			System.debug('resultVersions: ' + resultVersions);

			attachFiles(versions, idEfector);

			return new Response(false, 'ok');
		}

		return new Response(true, resp.message);
	}

	private static List<String> getAllTitles(WSEfectorGetPdfConveniosResp.Data[] convenios) {
		String[] titles = new List<String>();

		for(WSEfectorGetPdfConveniosResp.Data convenio : convenios) {
			if(String.isNotBlank(convenio.nombre_arch)) {
				titles.add(convenio.nombre_arch);
			}
		}

		return titles;
	}

	private static ContentVersion[] getAllNonExistentContentVersions(
			WSEfectorGetPdfConveniosResp.Data[] convenios, 
			String[] titles, 
			Id idEfector
	) {

		String[] cdlExistentes = new List<String>();
		ContentVersion[] versions = new List<ContentVersion>();

		List<ContentDocumentLink> links = [
				SELECT LinkedEntityId, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, 
				ShareType, ContentDocument.FileType, ContentDocument.FileExtension
				FROM ContentDocumentLink
				WHERE LinkedEntityId = :idEfector AND ContentDocument.Title IN :titles
		];

		for(ContentDocumentLink cdl : links) {
			cdlExistentes.add(cdl.ContentDocument.Title);
		}

		for(WSEfectorGetPdfConveniosResp.Data convenio : convenios) {
			if(!cdlExistentes.contains(convenio.nombre_arch)) {
				versions.add(buildPDF(convenio));
			}
		}

		return versions;
	}

	private static void attachFiles(ContentVersion[] versions, Id idEfector) {
		List<Id> ids = new List<Id>();

		for(ContentVersion version : versions) {
			ids.add(version.Id);
		}

		List<ContentVersion> versionsUpdated = [
				SELECT ContentDocumentId
				FROM ContentVersion
				WHERE Id IN :ids
		];

		List<ContentDocumentLink> linksToUpdate = new List<ContentDocumentLink>();
		for(ContentVersion ver : versionsUpdated) {
			linksToUpdate.add(new ContentDocumentLink(
					LinkedEntityId = idEfector,
					ShareType = 'V',
					ContentDocumentId = ver.ContentDocumentId
			));
		}

		Database.SaveResult[] resultLinks = Database.insert(linksToUpdate);
		System.debug('****resultLinks: ' + resultLinks);
	}

	private static ContentVersion buildPDF(WSEfectorGetPdfConveniosResp.Data convenio) {
		ContentVersion version = new ContentVersion();

		//if(cdId != null) {
			//version.ContentDocumentId = cdId;
		//}

		version.VersionData = EncodingUtil.base64Decode(convenio.base64);
		version.Title = convenio.nombre_arch;
		version.PathOnClient = '/' + convenio.efe_codigo + convenio.nombre_arch;
		version.Description = convenio.descripcion;
		version.origin = 'H';
		
		return version;
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