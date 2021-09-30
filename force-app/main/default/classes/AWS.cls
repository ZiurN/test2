public inherited sharing class AWS {
    @TestVisible
    private static final AWS_settings__mdt SERVICE_CONFIG = ConfigUtils.getAWSConfig('aws_s3');
    public static String url = 'callout:' + SERVICE_CONFIG.Name_Credential__c + '/' + SERVICE_CONFIG.File_Directory__c;
    public static String relativeLocation = '/' + SERVICE_CONFIG.File_Directory__c;
    public static String location = 'https://' + SERVICE_CONFIG.Bucket__c + '.s3.' + SERVICE_CONFIG.Region__c 
                                    + '.amazonaws.com/' + SERVICE_CONFIG.File_Directory__c;
    
    // System.debug(AWS_settings__mdt.getInstance('aws_s3'));
    
    public AWS() {

    }

    public static Response putFile(ContentVersion cv, String folder, Id linkedEntityId) {
        // String encodedTitle = EncodingUtil.urlEncode(cv.Title, 'UTF-8');
        // String encodedTitle = cv.Title.replaceAll(' ', '_');


        String extension = String.isBlank(cv.FileExtension) ? cv.FileExtension : (cv.FileExtension).toUpperCase();
        if(cv.Title.toLowerCase().contains('orden') && cv.Title.toLowerCase().contains('pdf')) {
            extension = 'pdf';
        }

        String title = '';
        if(cv.Title.contains('Orden') && cv.Title.contains('pdf')) {
            title = cv.Title.substring(0, cv.Title.length()-4);
        }
        else {
            title = cv.Title;
        }
        String encodedTitle = (EncodingUtil.urlEncode(Utils.getStringAlphanumericOnly(title).replaceAll(' ', '_'), 'UTF-8')).toUpperCase();
        String objectFolder = getParticularFolderForFile(linkedEntityId);
        String relativeLocation = relativeLocation.substringAfter('/').substringAfter('/') + objectFolder + folder + encodedTitle + '.' + extension;
        String location = location + objectFolder + folder + encodedTitle + '.' + extension;
        System.debug('****location: ' + location);
        System.debug('****relativeLocation: ' + relativeLocation);

        RestWS ws = new RestWS(
            url + objectFolder + folder + encodedTitle + '.' + extension,
            'PUT',
            null
        );

        String contentType = '';
        if(cv.Title.toLowerCase().contains('orden') && cv.Title.toLowerCase().contains('pdf')) {
            contentType = Utils.getTypeAndExtension(extension);
        }
        else {
            contentType = Utils.getTypeAndExtension(cv.FileExtension);
        }

        if(Test.isRunningTest() && contentType == null) {
            contentType = 'text/plain';
        }
        
        ws.request.setHeader('Content-Type', contentType);
        ws.request.setBodyAsBlob(cv.VersionData);
        System.debug('****Endpoint: ' + ws.request.getEndpoint());
        
        Response res = (Response) ws.invoke(new Response());
        res.url = location;
        res.relativeLocation = relativeLocation;
        return res;
    }

    public static Response deleteFile(Archivo_url__c archivoUrl) {
        RestWS ws = new RestWS(
            url + archivoUrl.Ruta_relativa__c,
            'DELETE',
            null
        );
        
        System.debug('****Endpoint: ' + ws.request.getEndpoint());
        
        Response res = (Response) ws.invoke(new Response());
        res.url = location;
        res.relativeLocation = relativeLocation;
        return res;
    }

    public class Response extends WSResult {
        public String url;
        public String relativeLocation;
        // public WSCaseReintegroEnviarASSResp result;
        public override void processResponse(HttpResponse response) {
			System.debug(response);
            //ej
            //System.HttpResponse[Status=OK, StatusCode=200]
            System.debug(response.getBody());
            //result = WSCaseReintegroEnviarASSResp.parse(response.getBody());
        }

        public override void processError(HttpResponse response) {
            System.debug(response);
            System.debug(response.getBody());
            // Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
			// message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        }
    }

    private static String getParticularFolderForFile(Id linkedEntityId) {
        String folder = '';
        String strObjPrefix = String.valueOf(LinkedEntityId).substring(0, 3);
        if(strObjPrefix == Case.sObjectType.getDescribe().getKeyPrefix()) {
            Case caso = [
                SELECT RecordTypeId
                FROM Case
                WHERE Id =: linkedEntityId
            ];

            if(caso.RecordTypeId == XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id) {
                folder = 'autorizaciones/';
            }
            else if(caso.RecordTypeId == XappiaHelper.getRecordType('Case', 'Reintegro').Id) {
                folder = 'reintegros/';
            }
            else if(caso.RecordTypeId == XappiaHelper.getRecordType('Case', 'Interfaz_financiera').Id
                || caso.RecordTypeId == XappiaHelper.getRecordType('Case', 'Solicitud_de_alta_familiar').Id
                ||caso.RecordTypeId == XappiaHelper.getRecordType('Case', 'Solicitud_de_baja').Id
                ||caso.RecordTypeId == XappiaHelper.getRecordType('Case', 'Solicitud_de_datos_particulares').Id
                ||caso.RecordTypeId == XappiaHelper.getRecordType('Case', 'Solicitud_de_despegues').Id
                ||caso.RecordTypeId == XappiaHelper.getRecordType('Case', 'Solicitud_de_segmento').Id
                || caso.RecordTypeId == XappiaHelper.getRecordType('Case', 'Solicitud_de_cambio_de_plan').Id
                || caso.RecordTypeId == XappiaHelper.getRecordType('Case', 'Solicitud_de_nueva_credencial').Id
            ) {
                folder = 'solicitudes_sf/';
            }
            else {
                folder = 'case/';
            } 
        }
        else if(strObjPrefix == Evento_medico__c.sObjectType.getDescribe().getKeyPrefix()) {
            folder = 'em/';
        }
        else if(strObjPrefix == Opportunity.sObjectType.getDescribe().getKeyPrefix()) {
            folder = 'solicitudes_sf/';
        }

        return folder;
    }
}