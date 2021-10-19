@IsTest
private class WSCotizadorCorporativaTest {

    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorResponse;
    static XHttpCalloutMock getErrornetwork;

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
                .withBody(WSCotizadorMock.getFoundCorporativa())
                .addForAddress(WSCotizador.SERVICE_CONFIG.URL__c + '/v1/cotizador/corporativa/cotizaciones');


        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Invalid data')
                .withStatusCode(500)
                .withBody(WSCotizadorMock.getErrorCorporativa())
                .addForAddress(WSCotizador.SERVICE_CONFIG.URL__c + '/v1/cotizador/corporativa/cotizaciones');

        getErrorNetwork = new XHttpCalloutMock();
        getErrorNetwork.buildResponse()
                .simulateNetworkError()
                .withExceptionMessage('No pudo autorizarse')
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
    }

    @IsTest
    static void whenWSCotizadorCorporativaIsConsumedWithValidDataItShouldReturnACotizacionCSV() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        String body = '{'+
		'"archivo": "data:text/plain;base64,cHJ1ZWJhIGRlIGVudmlvIGFyY2hpdm8gYmFzZTY0",'+
		'"transaccionId": 88462123'+
		'}';
        Test.startTest();
        WSCotizador.ResponseCorporativa responseToAssert = WSCotizador.cotizarCorporativa(body);
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
        System.assertEquals('310606', responseToAssert.cotizacion.data.idCotizacion);
    }

    @IsTest
    static void whenWSCotizadorCorporativaIsConsumedWithInvalidDataItShouldReturnAnError() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        String body = '{'+
		'"archivo": "",'+
		'"transaccionId": "a0SQ0000008OAqeMAG"'+
		'}';
        Test.startTest();
        WSCotizador.ResponseCorporativa responseToAssert = WSCotizador.cotizarCorporativa(body);
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals(500, responseToAssert.response.getStatusCode());
        System.assertEquals('Invalid data', responseToAssert.response.getStatus());
    }
    @IsTest
    static void ifSendToWSCotizadorCorporativaHasAnNetworkError_ShouldReturnAnError(){
        Test.setMock(HttpCalloutMock.class, getErrornetwork);
        String body = '{'+
		'"archivo": "data:text/plain;base64,cHJ1ZWJhIGRlIGVudmlvIGFyY2hpdm8gYmFzZTY0",'+
		'"transaccionId": "invalidID"'+
        '}';
        Test.startTest();
        WSCotizador.ResponseCorporativa responseToAssert = WSCotizador.cotizarCorporativa(body);
        Test.stopTest();
        System.assertEquals(true, responseToAssert.hasError);
        System.AssertEquals('No pudo autorizarse', responseToAssert.message);
    }
}