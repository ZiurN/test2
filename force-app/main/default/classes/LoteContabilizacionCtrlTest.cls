@isTest 
private class LoteContabilizacionCtrlTest {

	static XHttpCalloutMock getResponseSuccessCont;
	static XHttpCalloutMock getResponseSuccessAnul;
	static XHttpCalloutMock getResponseError;
	static Lote__c lote;

	static {
		getResponseSuccessCont = new XHttpCalloutMock();
		getResponseSuccessCont.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseSuccessCont.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSLoteContabilizarMock.getFoundContabilizar())
			.addForAddress(WSLoteContabilizar.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5402/contabilizacion');
		
		getResponseSuccessAnul = new XHttpCalloutMock();
		getResponseSuccessAnul.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseSuccessAnul.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSLoteContabilizarMock.getFoundAnular())
			.addForAddress(WSLoteContabilizar.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5402/contabilizacion');
		
		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
			.withStatus('No se pudo contabilizar el lote.')
			.withStatusCode(400)
			.withBody(WSLoteContabilizarMock.getError())
			.addForAddress(WSLoteContabilizar.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5407/contabilizacion');
		
	}

	@TestSetup
	private static void setup(){
		lote = new Lote__c(Estado__c = 'A', Id_lote_SS__c = '5402');
		Test.startTest();
		Database.SaveResult res = Database.insert(lote);
		System.debug(res);		
		Test.stopTest();
	}

	@IsTest
	private static void contabilizarLote(){
		lote = [SELECT Id_lote_SS__c, Estado__c, Fecha_de_fallo__c, Fallo_en_SS__c FROM Lote__c LIMIT 1];
		lote.Estado__c = 'C';
		lote.Bloqueo__c = false;

		update lote;
		Test.setMock(HttpCalloutMock.class,getResponseSuccessCont);
		Test.startTest();
		LoteContabilizacionCtrl.Response resp = LoteContabilizacionCtrl.contabilizacion(lote.Id_lote_SS__c, 'CONTABILIZAR');
		Test.stopTest();

		lote = [SELECT Estado__c FROM Lote__c WHERE Id = :lote.Id];

		System.assertEquals(false, resp.hasError);
		System.assertEquals('Se contabilizó correctamente el lote.', resp.message);
		System.assertEquals('O', lote.Estado__c);
	}

	@IsTest
	private static void anularContabilizarLote(){
		lote = [SELECT Id_lote_SS__c, Estado__c, Fecha_de_fallo__c, Fallo_en_SS__c FROM Lote__c LIMIT 1];
		lote.Estado__c = 'O';
		update lote;

		Test.setMock(HttpCalloutMock.class,getResponseSuccessAnul);
		Test.startTest();
		LoteContabilizacionCtrl.Response resp = LoteContabilizacionCtrl.contabilizacion(lote.Id_lote_SS__c, 'ANULAR');
		Test.stopTest();

		lote = [SELECT Estado__c FROM Lote__c WHERE Id = :lote.Id];

		System.assertEquals(false, resp.hasError);
		System.assertEquals('Se anuló correctamente la contabilización del lote.', resp.message);
		System.assertEquals('C', lote.Estado__c);
	}

	@IsTest
	private static void shouldNotContabilizarTheLoteWhenItsStateIsNotClosed(){
		lote = [SELECT Id_lote_SS__c, Estado__c, Fecha_de_fallo__c, Fallo_en_SS__c FROM Lote__c LIMIT 1];
		lote.Estado__c = 'O';
		update lote;

		Test.setMock(HttpCalloutMock.class,getResponseSuccessCont);
		Test.startTest();
		LoteContabilizacionCtrl.Response resp = LoteContabilizacionCtrl.contabilizacion(lote.Id_lote_SS__c, 'CONTABILIZAR');
		Test.stopTest();

		lote = [SELECT Estado__c FROM Lote__c WHERE Id = :lote.Id];

		System.assertEquals(true, resp.hasError);
		System.assertEquals('El lote debe estar cerrado para poder contabilizarlo', resp.message);
		System.assertEquals('O', lote.Estado__c);
	}


	@IsTest
	private static void shouldNotAnularContabilizarTheLoteWhenItsStateIsNotContabilizado(){
		lote = [SELECT Id_lote_SS__c, Estado__c, Fecha_de_fallo__c, Fallo_en_SS__c FROM Lote__c LIMIT 1];
		lote.Estado__c = 'C';
		lote.Bloqueo__c = false;
		update lote;

		Test.setMock(HttpCalloutMock.class,getResponseSuccessAnul);
		Test.startTest();
		LoteContabilizacionCtrl.Response resp = LoteContabilizacionCtrl.contabilizacion(lote.Id_lote_SS__c, 'ANULAR');
		Test.stopTest();

		lote = [SELECT Estado__c FROM Lote__c WHERE Id = :lote.Id];

		System.assertEquals(true, resp.hasError);
		System.assertEquals('El lote debe estar contabilizado para poder anularlo', resp.message);
		System.assertEquals('C', lote.Estado__c);
	}


	@IsTest
	private static void shouldNotContabilizarTheLoteWhenItHasNoExternalID(){
		lote = [SELECT Id_lote_SS__c, Estado__c, Fecha_de_fallo__c, Fallo_en_SS__c FROM Lote__c LIMIT 1];
		lote.Id_lote_SS__c = '';
		update lote;

		Test.setMock(HttpCalloutMock.class,getResponseSuccessCont);
		Test.startTest();
		LoteContabilizacionCtrl.Response resp = LoteContabilizacionCtrl.contabilizacion(lote.Id_lote_SS__c, 'CONTABILIZAR');
		Test.stopTest();

		lote = [SELECT Estado__c FROM Lote__c WHERE Id = :lote.Id];

		System.assertEquals(true, resp.hasError);
		System.assertEquals('El lote no existe en SS', resp.message);
		System.assertEquals('A', lote.Estado__c);
	}

	@IsTest
	private static void shouldNotContabilizarTheLoteWhenTheWSFails(){
		lote = [SELECT Id_lote_SS__c, Estado__c, Fecha_de_fallo__c,Bloqueo__c, Fallo_en_SS__c FROM Lote__c LIMIT 1];
		lote.Id_lote_SS__c = '5407';
		lote.Bloqueo__c = false;
		lote.Estado__c = 'C';
		update lote;

		Test.setMock(HttpCalloutMock.class,getResponseError);
		Test.startTest();
		LoteContabilizacionCtrl.Response resp = LoteContabilizacionCtrl.contabilizacion(lote.Id_lote_SS__c, 'CONTABILIZAR');
		Test.stopTest();

		lote = [SELECT Estado__c FROM Lote__c WHERE Id = :lote.Id];

		System.assertEquals(true, resp.hasError);
		System.assertEquals('ERROR AL CONTABILIZAR LOTE. no esta en estado CERRADO', resp.message);
		System.assertEquals('C', lote.Estado__c);
	}

}