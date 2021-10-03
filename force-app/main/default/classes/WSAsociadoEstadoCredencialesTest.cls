@isTest 
private class WSAsociadoEstadoCredencialesTest {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;

	static {
		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoEstadoCredencialesMock.getFound())
			.addForAddress(WSAsociadoEstadoCredenciales.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/credenciales/estados/88501-19');

		getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
            .withStatus('Error')
            .withStatusCode(404)
            .withBody(WSAsociadoEstadoCredencialesMock.getError())
            .addForAddress(WSAsociadoEstadoCredenciales.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/credenciales/estados/1234');	
	}

	 @IsTest
    private static void whenTheWSIsConsume_showTheCredentialsStatus() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        
        Test.startTest();
        WSAsociadoEstadoCredenciales.Response responseToAssert = WSAsociadoEstadoCredenciales.getEstadoCredenciales('88501-19');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);

		System.assertEquals('88501/19', responseToAssert.result.data[0].codigo);
		System.assertEquals('TORRES GUSTAVO FABIAN', responseToAssert.result.data[0].apellido_nombre);
		System.assertEquals('5', responseToAssert.result.data[0].secuencia);
		System.assertEquals('2014-09-01', responseToAssert.result.data[0].fecha_emision);
		System.assertEquals('2014-09-01', responseToAssert.result.data[0].fecha_vigencia);
		System.assertEquals('2019-04-09', responseToAssert.result.data[0].fecha_baja);
		System.assertEquals('2019-04-09', responseToAssert.result.data[0].fecha_anulacion);
		System.assertEquals('167607213', responseToAssert.result.data[0].id_oca);
		System.assertEquals('Entregado Ag', responseToAssert.result.data[0].estado);

    }

	@IsTest
    private static void whenTheWSIsConsume_getErrorMsg() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        
        Test.startTest();
        WSAsociadoEstadoCredenciales.Response responseToAssert = WSAsociadoEstadoCredenciales.getEstadoCredenciales('1234');
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals(404, responseToAssert.response.getStatusCode());
		System.assertEquals('Error', responseToAssert.response.getStatus());
    }
}