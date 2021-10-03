public class ConveniosProcessor  implements IMasterBuilder{
    public List<String> efectores;
    public Datetime runTime;
    public Datetime lastUpdateForEfectores;


    public ConveniosProcessor(List<String> accs, Datetime runTime) {
        this.runTime = runTime;
        this.efectores = accs;
    }

    public List<WSEfectorConveniosResp.Data> callWebService() {


        List<WSEfectorConveniosResp.Data> wsData = new List<WSEfectorConveniosResp.Data>();
        //for(String cod : this.efectores){
            //WSEfectorConvenios.Response result;
            //result = WSEfectorConvenios.getConvenios(cod);


            //if(!result.hasError) {

                //wsData.addAll(result.convenios.data);
            //}
        //}

        return wsData;
    }

    public void processResponse(List<Object> wsResponses) {
        //List<ContentVersion> contents = new List<ContentVersion>();
        //List<ContentVersion> existingContents = new List<ContentVersion>();

        //Map<Id,Account> efectores = new Map<Id,Account>([
                //SELECT Id,Codigo_de_efector__c
                //FROM Account
                //WHERE Codigo_de_efector__c IN :efectores
        //]);
        //List<ContentDocumentLink> dbLinks = [
                //SELECT LinkedEntityId,ContentDocumentId,ContentDocument.LatestPublishedVersionId
                //FROM ContentDocumentLink
                //WHERE LinkedEntityId IN :efectores.keySet()
        //];
        //Map<String,List<ContentDocumentLink>> linksMap = new Map<String, List<ContentDocumentLink>>();
        //List<Id> existingContentDocumentIds = new List<Id>();

        //for(ContentDocumentLink l : dbLinks){
            //existingContentDocumentIds.add(l.ContentDocumentId);
            //String cod = efectores.get(l.LinkedEntityId).Codigo_de_efector__c;
            //if(!linksMap.containsKey(cod)){
                //linksMap.put(cod,new List<ContentDocumentLink>{l});
            //}
            //else{
                //List<ContentDocumentLink> listTmp = linksMap.get(cod);
                //listTmp.add(l);
                //linksMap.put(cod,listTmp);
            //}

        //}

        //Map<Id,ContentVersion> dbContents = new Map<Id, ContentVersion>([
                //SELECT Id, Title
                //FROM ContentVersion
                //WHERE ContentDocumentId IN :existingContentDocumentIds
        //]);

        //Map<String,Account> efectoresMap = new Map<String, Account>();
        //Map<Id,List<ContentVersion>> contentMap = new Map<Id, List<ContentVersion>>();

        //for(Account acc : efectores.values()){
            //efectoresMap.put(acc.Codigo_de_efector__c,acc);
        //}
        //for(Object res : wsResponses){
            //WSEfectorConveniosResp.Data response = (WSEfectorConveniosResp.Data) res;
            //// Efector tiene archivos adjuntos
            //if(linksMap.containsKey(response.efe_codigo)) {
                //Boolean founded = false;
                ////Por cada link del efector
                //for (ContentDocumentLink efeLink : linksMap.get(response.efe_codigo)) {
                    ////El archivo adjunto es el de la response actual => actualizo el content version
                    //if (dbContents.containsKey(efeLink.ContentDocument.LatestPublishedVersionId) &&
                            //dbContents.get(efeLink.ContentDocument.LatestPublishedVersionId).Title == response.nombre_arch) {
                        //ContentVersion version = this.buildPDF(response,efeLink.ContentDocument.LatestPublishedVersionId);

                        //existingContents.add(version);
                        //founded = true;
                        //break;

                    //}

                //}
                    ////El archivo del WS no esta en salesforce => Creo nuevo content version y link
                //if(!founded){
                    //ContentVersion version = this.buildPDF(response,null);

                    //if (contentMap.get(efectoresMap.get(response.efe_codigo).Id) == null) {
                        //contentMap.put(efectoresMap.get(response.efe_codigo).Id, new List<ContentVersion>{
                                //version
                        //});
                    //} else {
                        //List<ContentVersion> verList = contentMap.get(efectoresMap.get(response.efe_codigo).Id);
                        //verList.add(version);
                        //contentMap.put(efectoresMap.get(response.efe_codigo).Id, verList);
                    //}

                    //contents.add(version);
                    //break;
                //}
            //}
            ////No tiene ningun archivo adjunto
            //else{
                //ContentVersion version = this.buildPDF(response,null);

                //if (contentMap.get(efectoresMap.get(response.efe_codigo).Id) == null) {
                    //contentMap.put(efectoresMap.get(response.efe_codigo).Id, new List<ContentVersion>{
                            //version
                    //});
                //} else {
                    //List<ContentVersion> verList = contentMap.get(efectoresMap.get(response.efe_codigo).Id);
                    //verList.add(version);
                    //contentMap.put(efectoresMap.get(response.efe_codigo).Id, verList);
                //}

                //contents.add(version);
            //}

        //}
        //Database.SaveResult[] resultsUpsert = Database.update(existingContents,false);
        //Database.SaveResult[] resultsContent = Database.insert(contents,false);
        //Id[] contentIds = new List<Id>();
        //for(ContentVersion cont : contents){
            //contentIds.add(cont.Id);
        //}

        //Map<Id,ContentVersion> updatedContentVersions = new Map<Id,ContentVersion>([
                //SELECT Id,ContentDocumentId
                //FROM ContentVersion
                //WHERE Id in :contentIds
        //]);

        //List<ContentDocumentLink> linksToUpsert = new List<ContentDocumentLink>();

        //for(Account acc : efectores.values()){
            //if(contentMap.get(acc.Id) != null){
                //for(ContentVersion cont : contentMap.get(acc.Id)){
                    //ContentVersion updatedContent = updatedContentVersions.get(cont.Id);
                    //ContentDocumentLink documentLink = new ContentDocumentLink();
                    //documentLink.ContentDocumentId = updatedContent.ContentDocumentId;
                    //documentLink.LinkedEntityId = acc.Id;
                    //documentLink.ShareType = 'V';
                    //linksToUpsert.add(documentLink);
                //}
            //}

        //}


        //Database.UpsertResult[] resultsLinks = Database.upsert(linksToUpsert,false);
		//EmailUtils.sendErrorMail(resultsLinks,null,null, 'Convenios(pdf)');

    }

    //public ContentVersion buildPDF(WSEfectorConveniosResp.Data response,Id id){
        //ContentVersion version = new ContentVersion();
        //if(id != null){
            //version.Id = id;

        //}
        //else {
            //version.PathOnClient = '/' + response.nombre_arch;
            //version.origin = 'H';
        //}
        //version.Title = response.nombre_arch;
        //String formattedLink = response.p_link.replace(' ', '%20');
        //PageReference pdf = new PageReference(formattedLink);
        //Blob pdfBody;
        //try {
            //pdfBody = pdf.getContentAsPDF();
        //} catch (Exception e) {
            //pdfBody = Blob.valueOf('Unable to grab pdf content.');
        //}

        //version.VersionData = pdfBody;
        //return version;
    //}



    public void updateDate() {
//        ConsultoriosEfectorProcessor consultoriosProcessor = new ConsultoriosEfectorProcessor(100,runTime);
//        Database.executeBatch(new MasterBatch(consultoriosProcessor));

    }



}