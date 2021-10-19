@IsTest
public class WSAsociadoGetCuponDePagoTest {
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
                .withBody(WSAsociadoGetCuponDePagoMock.getFound())
                .addForAddress(WSAsociadoGetCuentaCorriente.SERVICE_CONFIG.URL__c + '/v1/salud/cupones');

    }

    @IsTest
    private static void whenTheWSIsConsume_GetLinkOfCuponDePago(){
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        String body = '{"dat_nro":"'+ '21406301'+
                '","cuota":"'+'1'+
                '","deuda":"'+'7000.00'+'"}';
        Test.startTest();
        WSAsociadoGetCuponDePago.Response responseToAssert = WSAsociadoGetCuponDePago.generateCupon(body,'');
        Test.stopTest();

        System.debug('*****responseToAssert*****: ' + responseToAssert);
        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
        System.assertEquals('http://www.extranet.acasalud.com.ar/SF/21406301.pdf',responseToAssert.linkDePago.Data.link);
    }
}