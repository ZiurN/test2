@IsTest
private class SegmentoActualizarBtnCtrlTest {
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
                .withBody(WSSegmentoActualizarMock.getFound())
                .addForAddress(WSSegmentoActualizar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/275822/segmentos/305715');

        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('exception')
                .withStatusCode(404)
                .withBody(WSSegmentoActualizarMock.getError())
                .addForAddress(WSSegmentoActualizar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/275822/segmentos/305715');

    }

    @IsTest
    private static void updateSegmentTest() {
        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
		em.RecordTypeId = XappiaHelper.getRecordType('Evento_Medico__c', 'Evento_medico_de_internacion').Id;
        insert em;

        Datetime actual = System.now();
        Datetime masCincoDias = actual.addDays(5);
        Segmentos__c seg1 = new Segmentos__c(Semid__c = '305715',
                Evento_Medico__c = em.Id,
                Fecha_Inicio_real__c = actual,
                Fecha_Fin_real__c = masCincoDias
        );
        insert seg1;


        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        BasicResponse resp = SegmentoActualizarBtnCtrl.actualizarSegmento('305715');
        Test.stopTest();

        System.assertEquals(false,resp.hasError);
        System.assertEquals('Segmento actualizado exitosamente', resp.message);
        Segmentos__c segToAssert = [SELECT Estado__c, Fecha_Inicio_real__c, Fecha_Fin_real__c
            FROM Segmentos__c WHERE Id =: seg1.Id];
        System.assertEquals('Autorizado', segToAssert.Estado__c);
//        Datetime inicio = Datetime.newInstance(2020, 2, 1, 0, 0, 0);
//        Datetime fin = Datetime.newInstance(2020, 2, 2, 0, 0, 0);

//        System.assertEquals(inicio, segToAssert.Fecha_Inicio_real__c);
//        System.assertEquals(fin, segToAssert.Fecha_Fin_real__c);


    }

    @IsTest
    private static void updateSegmentErrorTest() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
        insert em;

        Segmentos__c seg = new Segmentos__c(Semid__c = '305715', Evento_Medico__c = em.Id);
        insert seg;

        Test.startTest();
        BasicResponse resp = SegmentoActualizarBtnCtrl.actualizarSegmento('305715');
        Test.stopTest();

        System.assertEquals(true, resp.hasError);
        System.debug(resp.message);
        System.assertEquals('El segmento solicitado es inválido.', resp.message);
    }
}