public without sharing class OpportunityCorpArchivosContratoCtrl  {

	@AuraEnabled
	public static Response getArchivosContrato(Id oppId){
		Opportunity opp = [
			SELECT Id,Tipo_de_mercado__c,Plan_Grupo_Corporativo__c, StageName, Cotizacion_Corporativa_elegida__c,
				Cotizacion_Corporativa_elegida__r.Nro_Cotizacion_Corporativa__c
			FROM Opportunity
			WHERE Id = :oppId
		];
		
		List<ContentVersion> filesToInsert = new List<ContentVersion>();

		if(opp.Cotizacion_Corporativa_elegida__c == null){
			return new Response(true, 'La oportunidad debe tener una cotización elegida.');
		}

		if(opp.StageName != 'Contrato Generado'){
			return new Response(true, 'La oportunidad debe estar en etapa Contrato Generado');
		}

		if(opp.Tipo_de_mercado__c == null){
			return new Response(true, 'La oportunidad no tiene tipo de mercado');
		}
		

		//switch on opp.Tipo_de_mercado__c{
			//when '1'{
				//filesToInsert = archivosCanalAbierto();
			//}
			//when '2'{
				//filesToInsert = archivosCanalLaSegunda();
			//}
			//when '3'{
				//filesToInsert = archivosGestionCompartida();
			//}
		//}

		//filesToInsert.addAll(getDiagramasPlan(opp.Plan_Grupo_Corporativo__c));
		//filesToInsert.add(cotizacionPdf(opp.Cotizacion_Corporativa_elegida__c));
		//-------------------------------*** NUEVO ***-------------------------------------
		WSCotizador.ResponseCorporativaPDF resp = WSCotizador.getContratoCorporativaPDF(opp.Cotizacion_Corporativa_elegida__r.Nro_Cotizacion_Corporativa__c);

		if(!resp.hasError) {
			Id[] docIdsToDelete = new List<Id>();
			String base64 = resp.cotizacion.data.base64.substringAfter(',');
			//CotizadorBtnCtrl.attachFile(oppId, base64, 'pdf');
			ContentVersion ver = new ContentVersion();
			ver.VersionData = EncodingUtil.base64Decode(base64);
			ver.Title = 'Contrato_' + String.valueOf(Date.today());
			ver.PathOnClient = '/Contrato' + oppId + '.' + 'pdf';
			insert ver;

			ver = [
				SELECT ContentDocumentId
				FROM ContentVersion
				WHERE Id = :ver.Id
			];			
 
			ContentDocumentLink newLink = new ContentDocumentLink();
			newLink.LinkedEntityId = oppId;
			newLink.ContentDocumentId = ver.ContentDocumentId;
			newLink.ShareType = 'V';
			insert newLink;
		
			List<ContentDocumentLink> linksToDelete = [
				SELECT Id,ContentDocumentId
				FROM ContentDocumentLink
				WHERE LinkedEntityId = :oppId AND ContentDocumentId != :ver.ContentDocumentId
			];

			for(ContentDocumentLink cdl : linksToDelete) {
				docIdsToDelete.add(cdl.ContentDocumentId);
			}

			List<ContentDocument> docsToDelete = [
				SELECT Id
				FROM ContentDocument
				WHERE Id IN :docIdsToDelete
			]; 

			Database.delete(linksToDelete, false);
			Database.delete(docsToDelete, false);
		}


		//---------------------------------------------------------------------------------

		//insert filesToInsert;
		//List<Id> versionIds = new List<Id>();
		//for(ContentVersion ver : filesToInsert){
			//versionIds.add(ver.Id);
		//}

		//filesToInsert = [
			//SELECT Id,ContentDocumentId
			//FROM ContentVersion
			//WHERE ID IN :versionIds
		//];

		//List<ContentDocumentLink> links = new List<ContentDocumentLink>();
		//List<ContentDocumentLink> linksToDelete = [
			//SELECT Id,ContentDocumentId
			//FROM ContentDocumentLink
			//WHERE LinkedEntityId = :oppId
		//];
		//List<Id> docsId = new List<Id>();
		//for(ContentDocumentLink link : linksToDelete){
			//docsId.add(link.ContentDocumentId);
		//}
		//List<ContentDocument> docs = [
			//SELECT Id
			//FROM ContentDocument
			//WHERE Id IN :docsId
		//];
		//for(ContentVersion ver : filesToInsert){
			//ContentDocumentLink link = new ContentDocumentLink();
			//link.ContentDocumentId = ver.ContentDocumentId;
			//link.LinkedEntityId = oppId;
			//link.ShareType = 'V';
			//links.add(link);
			
		//}

		
		//insert links;
		//Database.delete(linksToDelete);
		//Database.delete(docs,false);

		return new Response(false, 'Archivos adjuntados');
	}

	//private static List<ContentVersion> archivosCanalAbierto(){
		//List<ContratosUrl__mdt> mdts = [
			//SELECT Url__c
			//FROM ContratosUrl__mdt
			//WHERE DeveloperName = 'Canal_Abierto'
		//];
		//ContratosUrl__mdt mdt = mdts[0];

		//String extUrl = mdt.Url__c.replace(' ','%20');

		//List<String> urls = extUrl.split(';');
		//System.debug(urls);
		//List<String> urlsPdf = new List<String>();
		//List<String> urlsNoPdf = new List<String>();

		//for(String link : urls){
			//if(link.substringAfterLast('.') == 'pdf'){
				//urlsPdf.add(link);
			//}
			//else {
				//urlsNoPdf.add(link);
			//}
		//}

		//List<ContentVersion> filesToInsert = getFiles(urlsPdf,urlsNoPdf);
		//return filesToInsert;
	//}

	//private static List<ContentVersion> archivosCanalLaSegunda(){
		//List<ContratosUrl__mdt> mdts = [
			//SELECT Url__c
			//FROM ContratosUrl__mdt
			//WHERE DeveloperName = 'Canal_LaSegunda'
		//];
		
		//ContratosUrl__mdt mdt = mdts[0];
		//String extUrl = mdt.Url__c.replace(' ','%20');

		//List<String> urls = extUrl.split(';');

		//List<String> urlsPdf = new List<String>();
		//List<String> urlsNoPdf = new List<String>();

		//for(String link : urls){
			//if(link.substringAfterLast('.') == 'pdf'){
				//urlsPdf.add(link);
			//}
			//else {
				//urlsNoPdf.add(link);
			//}
		//}
		//List<ContentVersion> filesToInsert = getFiles(urlsPdf,urlsNoPdf);
		//return filesToInsert;
	//}

	//private static List<ContentVersion> archivosGestionCompartida(){
		//List<ContratosUrl__mdt> mdts = [
			//SELECT Url__c
			//FROM ContratosUrl__mdt
			//WHERE DeveloperName = 'Gestion_Compratida_Canal_Abierto'
		//];
		//ContratosUrl__mdt mdt = mdts[0];

		//String extUrl = mdt.Url__c.replace(' ','%20');

		//List<String> urls = extUrl.split(';');

		//List<String> urlsPdf = new List<String>();
		//List<String> urlsNoPdf = new List<String>();

		//for(String link : urls){
			//if(link.substringAfterLast('.') == 'pdf'){
				//urlsPdf.add(link);
			//}
			//else {
				//urlsNoPdf.add(link);
			//}
		//}

		//List<ContentVersion> filesToInsert = getFiles(urlsPdf,urlsNoPdf);
		//return filesToInsert;
	//}

	//private static List<ContentVersion> getDiagramasPlan(String planes){
		//List<String> planesList = new List<String>();
		//for(String plan : planes.split(';')){
			//planesList.add('Diagrama_' + plan);
		//}
		//List<ContratosUrl__mdt> mdts = [
			//SELECT Url__c
			//FROM ContratosUrl__mdt
			//WHERE DeveloperName IN :planesList
		//];
		//List<ContentVersion> filesToAttach = new List<ContentVersion>();
		//for(ContratosUrl__mdt mdt : mdts){

			//String extUrl = mdt.Url__c.replace(' ','%20');
			//Http h = new Http(); 
			//HttpRequest req = new HttpRequest(); 
			////Set the end point URL
			//req.setEndpoint(extUrl); 
			//req.setMethod('GET');
			//String contentType = 'image/jpg';
			//req.setHeader('Content-Type', contentType); 
			//req.setCompressed(true); 
			//req.setTimeout(60000); 
			////Now Send HTTP Request
			//HttpResponse res  = h.send(req); 
			////getBodyAsBlob method was will convert the response into Blob 
			
			//ContentVersion ver = new ContentVersion();
			//try{
				//blob retFile = res.getBodyAsBlob();
				//ver.VersionData = retFile;
			//}
			//catch(VisualforceException e){
				//if(Test.isRunningTest()){
					//ver.VersionData = Blob.valueOf('test blob');
				//}
				//System.debug(e.getMessage());
			//}

			//String filename = extUrl.substringAfterLast('/');

			//ver.Title = filename.replace('%20',' ');
			//ver.PathOnClient = '/' + filename;
			//filesToAttach.add(ver);
		//}
		
		//return filesToAttach;
	//}

	//private static List<ContentVersion> getFiles(List<String> urlsPdf, List<String> urlsNoPdf){
		//List<ContentVersion> filesToAttach = new List<ContentVersion>();
		//System.debug(urlsPdf);
		//System.debug(urlsNoPdf);
		//for(String link : urlsNoPdf){
			//System.debug(link);
			//Http h = new Http(); 
			//HttpRequest req = new HttpRequest(); 
			////Set the end point URL
			//req.setEndpoint(link); 
			//req.setMethod('GET');
			//String contentType;
			//switch on link.substringAfterLast('.'){
				//when 'jpg'{
					//contentType = 'image/jpg';
				//}
				//when 'docx'{
					//contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
				//}
			//}
			//req.setHeader('Content-Type', contentType); 
			//req.setCompressed(true); 
			//req.setTimeout(60000); 
			////Now Send HTTP Request
			//HttpResponse res  = h.send(req); 
			
			//ContentVersion ver = new ContentVersion();
			//try{
				//blob retFile = res.getBodyAsBlob();
				//ver.VersionData = retFile;
			//}
			//catch(VisualforceException e){
				//if(Test.isRunningTest()){
					//ver.VersionData = Blob.valueOf('test blob');
				//}
				//System.debug(e.getMessage());
			//}

			//String filename = link.substringAfterLast('/');
			//System.debug(link);
			//ver.Title = filename.replace('%20',' ');
			//ver.PathOnClient = '/' + filename;
			//filesToAttach.add(ver);
		//}

		//for(String link : urlsPdf){
			//System.debug(link);
			//PageReference page = new PageReference(link.replaceAll('ó','%C3%B3'));
			//ContentVersion ver = new ContentVersion();
			//try{
				//ver.VersionData = page.getContentAsPDF();
			//}
			//catch(Exception e){
				//if(Test.isRunningTest()){
					//ver.VersionData = Blob.valueOf('test blob');
				//}
				//System.debug(e.getMessage());
			//}
			//System.debug(link);
			//String filename = link.substringAfterLast('/');

			//ver.Title = filename.replace('%20', ' ');
			//ver.PathOnClient = '/' + filename;
			//System.debug(ver);
			//filesToAttach.add(ver);
		//}
		//System.debug(filesToAttach);
		//return filesToAttach;
	//}

	//private static ContentVersion cotizacionPdf(Id cotId){
		//PageReference ref = new PageReference('/apex/cotizacionCorpPDF?id='+cotId);
				
		////ref.getParameters().put('id', cotizacion.Id);
		//ContentVersion version = new ContentVersion();
		//version.PathOnClient = '/cotizacionCorp '+ String.valueOf(Date.today()) +'.pdf';
		//version.origin = 'H';
		//version.Title = 'Anexo Reporte de Cotizacion '+String.valueOf(Date.today())+'.pdf';
		//try{
			//version.VersionData = ref.getContentAsPDF();
		//}
		//catch(VisualforceException e){
			//if(Test.isRunningTest()){
				//version.VersionData = Blob.valueOf('test blob');
			//}
			//System.debug(e.getMessage());
		//}
		//return version;
	//}

	public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;

        public Response(Boolean hasError, String message){
            this.hasError = hasError;
            this.message = message;

        }
    }
}