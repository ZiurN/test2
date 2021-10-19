@IsTest
private class SegmentoAltaBtnCtrlTest {
    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorResponse;

    static {
//        getResponseFound = new XHttpCalloutMock();
//        getResponseFound.buildResponse()
//                .withStatus('OK')
//                .withStatusCode(200)
//                .withBody(WSAuthTokenMock.getTokenSuccess())
//                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
//        getResponseFound.buildResponse()
//                .withStatus('OK')
//                .withStatusCode(200)
//                .withBody(WSSegmentoAltaMock.getFound())
//                .addForAddress(WSSegmentoAlta.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/275822/segmentos');

        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('exception')
                .withStatusCode(404)
                .withBody(WSSegmentoAltaMock.getError())
                .addForAddress(WSSegmentoAlta.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/275822/segmentos');

    }

    @IsTest
    private static void createSegmentTest() {
        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
		em.RecordTypeId = XappiaHelper.getRecordType('Evento_Medico__c', 'Evento_medico_de_internacion').Id; 
        insert em;

        Datetime actual = System.now();
        Datetime masCincoDias = actual.addDays(5);
        Segmentos__c seg1 = new Segmentos__c(
                Evento_Medico__c = em.Id,
                Fecha_Inicio_tentativa__c = actual,
                Fecha_Fin_tentativa__c = masCincoDias
        );
        insert seg1;

        WSSegmentoAltaMock mock = new WSSegmentoAltaMock();
        String body = mock.getFound(seg1.Id);
        getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(body)
                .addForAddress(WSSegmentoAlta.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/275822/segmentos');
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        BasicResponse resp = SegmentoAltaBtnCtrl.createSegmento(seg1.Id);
        Test.stopTest();

        System.assertEquals(false,resp.hasError);
        System.assertEquals('Segmento creado exitosamente', resp.message);
        Segmentos__c segToAssert = [SELECT Fecha_Inicio_real__c, Fecha_Fin_real__c FROM Segmentos__c WHERE Id =: seg1.Id];
        Datetime inicio = Datetime.newInstance(2020, 2, 3, 0, 0, 0);
        Datetime fin = Datetime.newInstance(2020, 2, 4, 0, 0, 0);
        System.assertEquals(inicio, segToAssert.Fecha_Inicio_real__c);
        System.assertEquals(fin, segToAssert.Fecha_Fin_real__c);

    }

    @IsTest
    private static void createSegmentErrorTest() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
        insert em;

        Segmentos__c seg = new Segmentos__c(Evento_Medico__c = em.Id);
        insert seg;

        Test.startTest();
        BasicResponse resp = SegmentoAltaBtnCtrl.createSegmento(seg.Id);
        Test.stopTest();

        System.assertEquals(true, resp.hasError);
		System.assertEquals('The given data was invalid.', resp.message);
        //System.assertEquals('efector es inválido.\n', resp.message);
    }
}