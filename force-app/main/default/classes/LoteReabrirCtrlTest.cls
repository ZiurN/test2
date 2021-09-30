@IsTest
public class LoteReabrirCtrlTest  {
	

	static XHttpCalloutMock getResponseSuccess;
	static XHttpCalloutMock getResponseError;
	static Lote__c lote;

	static {
		getResponseSuccess = new XHttpCalloutMock();
		getResponseSuccess.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseSuccess.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSLoteReabrirMock.getFound())
			.addForAddress(WSLoteReabrir.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5397');
		
		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
			.withStatus('No se pudo reabrir el lote.')
			.withStatusCode(400)
			.withBody(WSLoteReabrirMock.getError())
			.addForAddress(WSLoteReabrir.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5397');
		
	}

	@TestSetup
	private static void setup(){
		Test.startTest();
		lote = new Lote__c(Id_lote_SS__c='5397',Estado__c = 'A');
		insert lote;
		Test.stopTest();
	}

	@IsTest
	private static void shouldReopenTheLote(){
		lote = [SELECT Id,Estado__c, Id_lote_SS__c FROM Lote__c LIMIT 1];

		lote.Estado__c = 'C';
		update lote;

		Test.setMock(HttpCalloutMock.class,getResponseSuccess);
		Test.startTest();
		LoteReabrirCtrl.Response resp = LoteReabrirCtrl.reopenLote(lote.Id_lote_SS__c);
		Test.stopTest();

		lote = [SELECT Estado__c FROM Lote__c WHERE Id = :lote.Id];

		System.assertEquals(false, resp.hasError);
		System.assertEquals('Se reabrió el lote con éxito.', resp.message);
		System.assertEquals('A', lote.Estado__c);
	}

	@IsTest
	private static void shouldNotReopenTheLoteWhenItsStateIsNotClosed(){
		lote = [SELECT Id,Estado__c, Id_lote_SS__c FROM Lote__c LIMIT 1];

		lote.Estado__c = 'O';
		update lote;

		Test.setMock(HttpCalloutMock.class,getResponseSuccess);
		Test.startTest();
		LoteReabrirCtrl.Response resp = LoteReabrirCtrl.reopenLote(lote.Id_lote_SS__c);
		Test.stopTest();

		lote = [SELECT Estado__c FROM Lote__c WHERE Id = :lote.Id];

		System.assertEquals(true, resp.hasError);
		System.assertEquals('El lote debe estar cerrado para poder reabrirlo', resp.message);
		System.assertEquals('O', lote.Estado__c);
	}


	@IsTest
	private static void shouldNotReopenTheLoteWhenItHasNoExternalID(){
		lote = [SELECT Id,Estado__c, Id_lote_SS__c FROM Lote__c LIMIT 1];
		lote.Id_lote_SS__c = null;
		lote.Estado__c = 'C';
		update lote;

		Test.setMock(HttpCalloutMock.class,getResponseSuccess);
		Test.startTest();
		LoteReabrirCtrl.Response resp = LoteReabrirCtrl.reopenLote(lote.Id_lote_SS__c);
		Test.stopTest();

		lote = [SELECT Estado__c FROM Lote__c WHERE Id = :lote.Id];

		System.assertEquals(true, resp.hasError);
		System.assertEquals('El lote no existe en SS', resp.message);
		System.assertEquals('C', lote.Estado__c);
	}

	@IsTest
	private static void shouldNotReopenTheLoteWhenTheWSFails(){
		lote = [SELECT Id,Estado__c, Id_lote_SS__c FROM Lote__c LIMIT 1];

		lote.Estado__c = 'C';
		update lote;

		Test.setMock(HttpCalloutMock.class,getResponseError);
		Test.startTest();
		LoteReabrirCtrl.Response resp = LoteReabrirCtrl.reopenLote(lote.Id_lote_SS__c);
		Test.stopTest();

		lote = [SELECT Estado__c FROM Lote__c WHERE Id = :lote.Id];

		System.assertEquals(true, resp.hasError);
		System.assertEquals('ERROR AL ABRIR LOTE. ERR Reabriendo el lote:. no esta en estado CERRADO', resp.message);
		System.assertEquals('C', lote.Estado__c);
	}

}