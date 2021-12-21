@IsTest
public class WSArchivosCargaTest  {

	static XHttpCalloutMock getSuccessResponse;
	static XHttpCalloutMock getErrorResponse;

	static{
		getSuccessResponse = new XHttpCalloutMock();
        getSuccessResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getSuccessResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSArchivosCargaMock.getFound())
                .addForAddress(WSArchivosCarga.SERVICE_CONFIG.URL__c + '/v1/salud/archivos');
        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Error al cargar archivos.')
                .withStatusCode(422)
                .withBody(WSArchivosCargaMock.getError())
                .addForAddress(WSArchivosCarga.SERVICE_CONFIG.URL__c + '/v1/salud/archivos');
	}

	@IsTest
    private static void successfulUpload() {
		Test.setMock(HttpCalloutMock.class, getSuccessResponse);

		Test.startTest();
		WSArchivosCarga.Response resp= WSArchivosCarga.uploadFiles('{'+
										'"tipo_tramite": "evento_medico",'+
										'"id": "276441",'+
										'"usuario": "CRIOS",'+
										'"archivos": [{'+
												'"nombre": "prueba_arch_autorizacion.txt",'+
												'"datos": "data:text/plain;base64,cHJ1ZWJhIGRlIGVudmlvIGFyY2hpdm8gYmFzZTY0",'+
												'"descripcion": "Descripción",'+
												'"observaciones": "Observaciones"'+
    										'}'+
										']'+
									'}',null);
		Test.stopTest();

		System.assertEquals(false,resp.hasError);
		System.assertEquals('Ok', resp.message);
	}


	@IsTest
    private static void errorUpload() {
		Test.setMock(HttpCalloutMock.class, getErrorResponse);

		Test.startTest();
		WSArchivosCarga.Response resp= WSArchivosCarga.uploadFiles('{'+
										'"tipo_tramite": "evento_medico",'+
										'"id": "21",'+
										'"usuario": "CRIOS",'+
										'"archivos": [{'+
												'"nombre": "prueba_arch_autorizacion.txt",'+
												'"datos": "data:text/plain;base64,cHJ1ZWJhIGRlIGVudmlvIGFyY2hpdm8gYmFzZTY0",'+
												'"descripcion": "Descripción",'+
												'"observaciones": "Observaciones"'+
    										'}'+
										']'+
									'}',null);
		Test.stopTest();

		System.assertEquals(true,resp.hasError);
		System.assertNotEquals(null,resp.message);
	}
}