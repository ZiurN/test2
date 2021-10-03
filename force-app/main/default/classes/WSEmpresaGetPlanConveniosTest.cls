@IsTest
public class WSEmpresaGetPlanConveniosTest  {
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
                .withBody(WSEmpresaGetPlanConveniosMock.getFound())
                .addForAddress(WSEmpresaGetPlanConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/empresas/convenios/planes-permitidos/2843');


        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Not Found')
                .withStatusCode(404)
                .withBody(WSEmpresaGetPlanConveniosMock.getError())
                .addForAddress(WSEmpresaGetPlanConvenios.SERVICE_CONFIG.URL__c + '/v1/salud/empresas/convenios/planes-permitidos/0');
    }

	@IsTest
    static void whenTheWSIsConsume_GetListOfConveniosFromEmpresa() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        WSEmpresaGetPlanConvenios.Response responseToAssert = WSEmpresaGetPlanConvenios.getEmpresaPlanConvenios(2843);
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());

        System.assertEquals(1, responseToAssert.empresaPlanConvenios.data.size());
        System.assertEquals('01/07/2017', responseToAssert.empresaPlanConvenios.data[0].fecha_desde);
		System.assertEquals('30/06/2019', responseToAssert.empresaPlanConvenios.data[0].fecha_hasta);
		System.assertEquals('SUPERIOR AS300', responseToAssert.empresaPlanConvenios.data[0].plan_nombre);
    }

    @IsTest
    private static void whenTheWSIsConsume_consumeWSEmpresa_returnErrorMessage(){
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Test.startTest();
        WSEmpresaGetPlanConvenios.Response responseToAssert = WSEmpresaGetPlanConvenios.getEmpresaPlanConvenios(0);
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals(404, responseToAssert.response.getStatusCode());
        System.assertEquals('Not Found', responseToAssert.response.getStatus());
        System.assertEquals(null, responseToAssert.empresaPlanConvenios);
    }
}