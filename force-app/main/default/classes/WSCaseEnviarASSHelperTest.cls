@isTest
public with sharing class WSCaseEnviarASSHelperTest {
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
                .withBody(WSCaseAPGenerarCentroMock.getFound(ap.Id))
                .addForAddress(WSCaseEnviarASSHelper.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones');
    }
    @IsTest
    private static void whenTheWSIsConsume_APUpdated() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        String body = '{'+
					'"fecha": "2019-05-05",'+
					'"fecha_prob": "2019-05-05",'+
					'"agencia_codigo": "650261",'+
					'"codigo_afiliado": "69794/14",'+
					'"evento_medico_id": "55863",'+
					'"fecha_pres": "2018-04-01",'+
					'"codigo_diagnostico": "X99",'+
					'"efectores_prestador": "707595",'+
					'"prestador": "707595",'+
					'"consultorio": "1",'+
					'"observaciones": "Autorización de evento médico XX",'+
					'"mail": "test@mapplics.com",'+
					'"otros_mail": null,'+
					'"alerta": "A22",'+
					'"contexto": "A",'+
					'"numero_sf": "1005277888",'+
					'"prestaciones": [{'+
						'"cantidad": 1,'+
						'"nom_prestacion_pdh": "02166001",'+
						'"tipo_prestacion": "N",'+
						'"descripcion": "ELECTROCARDIOGRAMA"'+
					'}]'+
				'}';
        Test.startTest();
        WSCaseEnviarASSHelper.Response responseToAssert = WSCaseEnviarASSHelper.enviarASS(body, 'autorizaciones', 'autorizaciones');
        Test.stopTest();
        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
    }
}
