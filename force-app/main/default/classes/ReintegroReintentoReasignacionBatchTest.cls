@isTest 
private class ReintegroReintentoReasignacionBatchTest {

	static XHttpCalloutMock getSuccessResponse;
	static XHttpCalloutMock getErrorResponse;

	static{
	    getSuccessResponse = new XHttpCalloutMock();
        getSuccessResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getSuccessResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSCaseReintegroReasignarMock.getFound())
                .addForAddress(WSCaseReintegroReasignar.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/553276');

        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Error')
                .withStatusCode(500)
                .withBody(WSCaseReintegroReasignarMock.getError())
                .addForAddress(WSCaseReintegroReasignar.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/123');

	}

	@isTest
	private static void testReintentoReasignacion() {
		Test.setMock(HttpCalloutMock.class, getSuccessResponse);
		
		Lote__c lote = new Lote__c();
		lote.Id_lote_SS__c = '999999';
		insert lote;

		Case reintegro = new Case();
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		reintegro.Codigo_reintegro_SS__c = '553276';
		reintegro.Lote__c = lote.Id;
		reintegro.Error_reasignacion__c = 'Error del WS';
		reintegro.Fecha_error_reasignacion__c = Datetime.now();
		reintegro.Usuario_error_reasignar__c = 'CRIOS';
		insert reintegro;


		Test.startTest();
		Database.executeBatch(new ReintegroReintentoReasignacionBatch());
		Test.stopTest();

		reintegro = [SELECT Error_reasignacion__c, Fecha_error_reasignacion__c, Usuario_error_reasignar__c FROM Case WHERE Id = :reintegro.Id];

		System.assertEquals(null, reintegro.Error_reasignacion__c);
		System.assertEquals(null, reintegro.Fecha_error_reasignacion__c);
		System.assertEquals(null, reintegro.Usuario_error_reasignar__c);

	}
}