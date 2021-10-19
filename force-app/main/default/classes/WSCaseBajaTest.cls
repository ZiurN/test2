@isTest
public class WSCaseBajaTest {
    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorResponse;

    static {
		Case ap = new Case();	
		insert ap;
        getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSCaseBajaMock.getFound())
                .addForAddress(WSCaseBaja.SERVICE_CONFIG.URL__c + '/v1/extranet/sf/casos');

    }

    @IsTest
    private static void whenTheWSIsConsume_APUpdated(){
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        String body = '{'+        
                        '"caso": ['+
                            '{'+
                                '"tipo": "BAJA_T",'+
                                '"sf_id": null,'+
                                '"origen": "W"'+
                            '}'+
                        '],'+
                        '"autorizacion": ['+
                            '{'+
                                '"codigo_afiliado": "234428/65",'+
                                '"contexto": "A",'+
                                '"fecha_pedido_medico": "2018-03-12",'+
                                '"cantidad": "2",'+
                                '"grupo": "MEDICAMENTOS"'+
                            '}'+
                        ']'+
				    '}';
        Test.startTest();
        WSCaseBaja.Response responseToAssert = WSCaseBaja.darDeBajaCaso(body);
        Test.stopTest();

        System.debug('*****responseToAssert*****: ' + responseToAssert);
        System.debug('**error ' + responseToAssert.message);
        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
    }
}