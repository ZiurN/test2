@IsTest
public class WSBatchObraSocialTest {
    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorResponse;
    static XHttpCalloutMock getEmptyResponse;

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
                .withBody(WSBatchObraSocialMock.getFoundSecondPage())
                .addForAddress(WSBatchEmpresa.SERVICE_CONFIG.URL__c + '/v1/salud/batch/obras-sociales/2020-01-20?pageSize=100&page=1');

        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('Not Found')
                .withStatusCode(404)
                .withBody(WSBatchObraSocialMock.getError())
                .addForAddress(WSBatchEmpresa.SERVICE_CONFIG.URL__c + '/v1/salud/batch/obras-sociales/');
        getEmptyResponse = new XHttpCalloutMock();
        getEmptyResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getEmptyResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSBatchObraSocialMock.getEmpty())
                .addForAddress(WSBatchEmpresa.SERVICE_CONFIG.URL__c + '/v1/salud/batch/obras-sociales/2020-01-19?pageSize=100&page=1');

    }

    @IsTest
    private static void whenTheWSIsConsume_GetListOfObrasSociales(){
        Test.setMock(HttpCalloutMock.class, getResponseFound);

        Test.startTest();
        WSBatchObraSocial.Response responseToAssert = WSBatchObraSocial.getBatchObrasSociales('2020-01-20', 100, 1);
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
        System.assertEquals(2, responseToAssert.obrasSociales.data.size());
        System.assertEquals('640004', responseToAssert.obrasSociales.data[0].codigo);
        System.assertEquals('O.S.S.E.G.',responseToAssert.obrasSociales.data[0].nombre);
        System.assertEquals('OBRA SOCIAL DEL SEGURO', responseToAssert.obrasSociales.data[0].descripcion);
        System.assertEquals('901',responseToAssert.obrasSociales.data[0].codigo_rnos);
        System.assertEquals('Cliente',responseToAssert.obrasSociales.data[0].tipo);
        System.assertEquals('30500053522', responseToAssert.obrasSociales.data[0].cuit);
        System.assertEquals('1900-01-01 00:00:00', responseToAssert.obrasSociales.data[0].fecha_activacion);
        System.assertEquals(null, responseToAssert.obrasSociales.data[0].codigo_financiero);
        System.assertEquals('A', responseToAssert.obrasSociales.data[0].estado);
        System.assertEquals('sin mail', responseToAssert.obrasSociales.data[0].email);
        System.assertEquals('TRFAPO', responseToAssert.obrasSociales.data[0].codigo_agrupacion);
        System.assertEquals('TRANSFERENCIA DE APORTES', responseToAssert.obrasSociales.data[0].descripcion_agrupacion);
        System.assertEquals('Obra social sindical', responseToAssert.obrasSociales.data[0].clase);
        System.assertEquals('650098_ACA SALUD SUC. ROSARIO', responseToAssert.obrasSociales.data[0].delegacion);
        System.assertEquals(null, responseToAssert.obrasSociales.data[0].observaciones);
        System.assertEquals('2020-01-20 00:00:00', responseToAssert.obrasSociales.data[0].f_modif);


    }

    @IsTest
    private static void whenTheWSIsConsume_GetEmptyListOfObrasSociales(){
        Test.setMock(HttpCalloutMock.class, getEmptyResponse);

        Test.startTest();
        WSBatchObraSocial.Response responseToAssert = WSBatchObraSocial.getBatchObrasSociales('2020-01-19', 100, 1);
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
        System.assertEquals(0, responseToAssert.obrasSociales.data.size());


    }

    @IsTest
    private static void whenTheWSIsConsume_GetTokenErrorResponse(){
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Test.startTest();
        WSAuthToken.Response responseToAssert = WSAuthToken.getToken();
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals(404, responseToAssert.response.getStatusCode());
        System.assertEquals('404 not found', responseToAssert.response.getStatus());
        System.assertEquals(null, responseToAssert.token);
    }

}