@IsTest
public class WSAsociadoGetDeudaTest {
    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getResponseEmpty;
    static XHttpCalloutMock getErrorResponse;

    static {
        //String today = System.now().format().substringBefore(' ').replace('/', '-');
		String today = System.now().format('yyyy-MM-dd');
        getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAsociadoGetDeudaMock.getFound())
                .addForAddress(WSAsociadoGetDeuda.SERVICE_CONFIG.URL__c + '/v1/salud/cuenta-corriente/deuda-actual/23162069/' + today);

        getResponseEmpty = new XHttpCalloutMock();
        getResponseEmpty.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseEmpty.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAsociadoGetDeudaMock.getEmpty())
                .addForAddress(WSAsociadoGetDeuda.SERVICE_CONFIG.URL__c + '/v1/salud/cuenta-corriente/deuda-actual/0/' + today);


        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('Not Found')
                .withStatusCode(404)
                .withBody(WSAsociadoGetDeudaMock.getError())
                .addForAddress(WSAsociadoGetDeuda.SERVICE_CONFIG.URL__c + '/v1/salud/cuenta-corriente/deuda-actual/');
    }

    @IsTest
    private static void whenTheWSIsConsume_GetListOfCuentaCorrienteOfAsociado(){
        Test.setMock(HttpCalloutMock.class, getResponseFound);

        Test.startTest();
        WSAsociadoGetDeuda.Response responseToAssert = WSAsociadoGetDeuda.getAsociadoDeuda(23162069,System.today(),'');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
        System.assertEquals('03/12/2019', responseToAssert.asociadoDeuda.data.vencimiento);
        System.assertEquals('23162069', responseToAssert.asociadoDeuda.data.p_dat_nro);
        System.assertEquals('FA', responseToAssert.asociadoDeuda.data.p_tcp_codigo_act);
        System.assertEquals('163.55', responseToAssert.asociadoDeuda.data.p_deuda_act);
        System.assertEquals('1', responseToAssert.asociadoDeuda.data.p_det_cuota_act);
        System.assertEquals('22', responseToAssert.asociadoDeuda.data.p_cpr_sucursal_act);
        System.assertEquals('1566119', responseToAssert.asociadoDeuda.data.p_cpr_numero_act);
        System.assertEquals('B', responseToAssert.asociadoDeuda.data.p_cpr_letra_act);
    }

    @IsTest
    private static void whenTheWSIsConsume_GetEmptyListOfCuentaCorrienteOfAsociado(){
        Test.setMock(HttpCalloutMock.class, getResponseEmpty);

        Test.startTest();
        WSAsociadoGetDeuda.Response responseToAssert = WSAsociadoGetDeuda.getAsociadoDeuda(0,System.today(),'HDSjklahdD5aD87D');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
        System.assertEquals(null, responseToAssert.asociadoDeuda.data.vencimiento);
        System.assertEquals(null, responseToAssert.asociadoDeuda.data.p_dat_nro);
        System.assertEquals(null, responseToAssert.asociadoDeuda.data.p_tcp_codigo_act);
        System.assertEquals(null, responseToAssert.asociadoDeuda.data.p_deuda_act);
        System.assertEquals(null, responseToAssert.asociadoDeuda.data.p_det_cuota_act);
        System.assertEquals(null, responseToAssert.asociadoDeuda.data.p_cpr_sucursal_act);
        System.assertEquals(null, responseToAssert.asociadoDeuda.data.p_cpr_numero_act);
        System.assertEquals(null, responseToAssert.asociadoDeuda.data.p_cpr_letra_act);


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