@IsTest
private class SegmentoEliminarBtnCtrlTest {
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
                .withBody(WSSegmentoEliminarMock.getFound())
                .addForAddress(WSSegmentoEliminar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/275822/segmentos/305716');
        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('La autorización solicitada es inválida.')
                .withStatusCode(404)
                .withBody(WSSegmentoEliminarMock.getError())
                .addForAddress(WSSegmentoEliminar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/275822/segmentos/305716');

    }

    @IsTest
    private static void deleteValidSegment() {
        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
		em.RecordTypeId = XappiaHelper.getRecordType('Evento_Medico__c', 'Evento_medico_de_internacion').Id;
        em.Estado__c = 'Autorizado';

        insert em;

        Datetime actual = System.now();
        Segmentos__c seg1 = new Segmentos__c(Semid__c = '123',Evento_Medico__c = em.Id,Fecha_Fin_real__c = actual,Numero_del_segmento__c=1);
        insert seg1;

        Segmentos__c seg2 = new Segmentos__c(Semid__c = '305716',Evento_Medico__c = em.Id,Numero_del_segmento__c=2);
        insert seg2;

        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        SegmentoEliminarBtnCtrl.Response resp = SegmentoEliminarBtnCtrl.deleteSegmento('305716');
        Test.stopTest();

        System.assertEquals(false,resp.hasError);
        System.assertEquals('Segmento eliminado exitosamente',resp.message);
        System.assertEquals(actual,[SELECT Fecha_y_hora_fin_ems__c FROM Evento_medico__c].Fecha_y_hora_fin_ems__c);
        System.assertEquals(true, [SELECT Segmento_actual__c FROM Segmentos__c WHERE Id = :seg1.Id].Segmento_actual__c);


    }

    @IsTest
    private static void deleteInvalidSegment() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
        insert em;

        Segmentos__c seg = new Segmentos__c(Semid__c = '305716',Evento_Medico__c = em.Id);
        insert seg;

        Test.startTest();
        SegmentoEliminarBtnCtrl.Response resp = SegmentoEliminarBtnCtrl.deleteSegmento('305716');
        Test.stopTest();

        System.assertEquals(true, resp.hasError);
        System.assertEquals('El segmento solicitado es inválido.', resp.message);
    }

    @IsTest
    private static void showErrorMsgWhenTheExternalIdIsNull() {
//        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Evento_medico__c em = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = '275822');
        insert em;

        Segmentos__c seg = new Segmentos__c(Semid__c = null, Evento_Medico__c = em.Id);
        insert seg;

        Test.startTest();
        SegmentoEliminarBtnCtrl.Response resp = SegmentoEliminarBtnCtrl.deleteSegmento(seg.Semid__c);
        Test.stopTest();

        System.assertEquals(true, resp.hasError);
        System.assertEquals('El id externo está vacío', resp.message);
    }
}