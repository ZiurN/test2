@isTest 
private class LoteGeneracionDeOrdenTest {

	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseFoundDeshacer;
	static XHttpCalloutMock getResponseError;

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
			.withBody(WSLoteGeneracionDeOrdenMock.getFound())
			.addForAddress(WSLoteGeneracionDeOrden.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5402/orden');

		getResponseFoundDeshacer = new XHttpCalloutMock();
		getResponseFoundDeshacer.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundDeshacer.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSLoteGeneracionDeOrdenMock.getFoundDeshacer())
			.addForAddress(WSLoteGeneracionDeOrden.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5404/orden');

		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
			.withStatus('Error')
			.withStatusCode(422)
			.withBody(WSLoteGeneracionDeOrdenMock.getError())
			.addForAddress(WSLoteGeneracionDeOrden.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5600/orden');
		
	}

	@TestSetup 
	private static void setup() {
		Test.startTest(); 
		Lote__c lote = new Lote__c();
		lote.Tipo__c = 'Vigente';
		lote.Id_lote_SS__c = '5402';
		lote.Estado__c = 'A';
		insert lote;
		
		Case[] reintegros = new List<Case>();

		for(Integer i = 0; i < 200; i++) {
			Case rein = new Case();
			rein.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
			//rein.Status = 'CA-----G';
			//rein.Codigo_reintegro_SS__c = '0000' + i;
			rein.Status = 'CA-----A';
			rein.Observaciones__c = '|test|';
			rein.Lote__c = lote.Id;

			reintegros.add(rein);
		}

		insert reintegros;
		Test.stopTest();
	}

	@isTest
	private static void generateOrdenSSFailsInAReintegro() {
		Lote__c lote = [SELECT Id, Id_lote_SS__c FROM Lote__c WHERE Id_lote_SS__c = '5402'];
		//insert lote;

		Case reintegro = new Case(Lote__c = lote.Id, Codigo_reintegro_SS__c = '553279', Status = 'CA-----A', 
			RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id);
		insert reintegro;

		Case reintegro2 = new Case(Lote__c = lote.Id, Codigo_reintegro_SS__c = '553278', Status = 'CA-----A',
			RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id);
		insert reintegro2;

		Case reintegro3 = new Case(Lote__c = lote.Id, Codigo_reintegro_SS__c = '553277', Status = 'CA-----G',
			RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id);
		insert reintegro3;

		Test.setMock(HttpCalloutMock.class,getResponseFound);
		Test.startTest();
		LoteGeneracionDeOrdenCtrl.Response resp = LoteGeneracionDeOrdenCtrl.generacionDeOrden(lote.Id_lote_SS__c, 'GENERAR');
		Test.stopTest();

		lote = [SELECT Estado__c FROM Lote__c WHERE Id = :lote.Id];
		reintegro = [SELECT Status,Error__c FROM Case WHERE Id = :reintegro.Id];
		reintegro2 = [SELECT Status,Error__c FROM Case WHERE Id = :reintegro2.Id];
		reintegro3 = [SELECT Status,Error__c, Derivacion_de_lote__c FROM Case WHERE Id = :reintegro3.Id];

		System.assertEquals(false, resp.hasError);
		System.assertEquals('A', lote.Estado__c);
		System.assertEquals('CA_REI_0006:El reintegro 553279 tiene prestaciones o conceptos sin pasar por el centro autoirizador o pendientes de auditoría', reintegro.Error__c);
		System.assertEquals('CA-----A', reintegro.Status);
		System.assertEquals(null, reintegro2.Error__c);
		System.assertEquals('CA-----E', reintegro2.Status);
		System.assertEquals(null, reintegro3.Error__c);
		System.assertEquals('CA-----G', reintegro3.Status);
		System.assertEquals('Lote Pendiente', reintegro3.Derivacion_de_lote__c);


	}

	@isTest
	private static void undoOrdenSS() {
		Lote__c lote = new Lote__c(Estado__c = 'A', Id_lote_SS__c = '5404');
		insert lote;

		Case reintegro = new Case(Lote__c = lote.Id, Codigo_reintegro_SS__c = '553279', RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id);
		insert reintegro;

		Case reintegro2 = new Case(Lote__c = lote.Id, Codigo_reintegro_SS__c = '553278', RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id);
		insert reintegro2;

		Test.setMock(HttpCalloutMock.class,getResponseFoundDeshacer);
		Test.startTest();
		LoteGeneracionDeOrdenCtrl.Response resp = LoteGeneracionDeOrdenCtrl.generacionDeOrden(lote.Id_lote_SS__c, 'DESHACER');
		Test.stopTest();

		lote = [SELECT Estado__c FROM Lote__c WHERE Id = :lote.Id];
		reintegro = [SELECT Status,Error__c FROM Case WHERE Id = :reintegro.Id];
		reintegro2 = [SELECT Status,Error__c FROM Case WHERE Id = :reintegro2.Id];

		System.assertEquals(false, resp.hasError);
		System.assertEquals('A', lote.Estado__c);
		System.assertEquals('CA-----A', reintegro.Status);
		System.assertEquals('CA-----A', reintegro2.Status);
	}

	@isTest
	private static void generateOrdenSSWithError() {
		Lote__c lote = new Lote__c(Estado__c = 'A', Id_lote_SS__c = '5600');
		insert lote;

		Case reintegro = new Case(Lote__c = lote.Id, Codigo_reintegro_SS__c = '553279', RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id);
		insert reintegro;

		Case reintegro2 = new Case(Lote__c = lote.Id, Codigo_reintegro_SS__c = '553278', RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id);
		insert reintegro2;

		Test.setMock(HttpCalloutMock.class,getResponseError);
		Test.startTest();
		LoteGeneracionDeOrdenCtrl.Response resp = LoteGeneracionDeOrdenCtrl.generacionDeOrden(lote.Id_lote_SS__c, 'GENERAR');
		Test.stopTest();

		lote = [SELECT Estado__c FROM Lote__c WHERE Id = :lote.Id];
		reintegro = [SELECT Status,Error__c FROM Case WHERE Id = :reintegro.Id];
		reintegro2 = [SELECT Status,Error__c FROM Case WHERE Id = :reintegro2.Id];

		System.assertEquals(true, resp.hasError);
		System.assertEquals('A', lote.Estado__c);
		System.assertEquals('No se pudo generar la orden. No se pueden visualizar los datos en este momento', resp.message);

	}

	@isTest
	private static void whenTheLoteHasReintegrosEnAuditoria_showErrorMsg() {
		Lote__c lote = new Lote__c(Estado__c = 'A', Id_lote_SS__c = '5600');
		insert lote;

		Case reintegro = new Case(Lote__c = lote.Id, Codigo_reintegro_SS__c = '553279', RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id);
		reintegro.Status = 'CA-----A';
		insert reintegro;

		Case reintegro2 = new Case(Lote__c = lote.Id, Codigo_reintegro_SS__c = '553278', RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id);
		reintegro2.Status = 'CA-----A';
		insert reintegro2;

		Case reintegro3 = new Case(Lote__c = lote.Id, Codigo_reintegro_SS__c = '553281', RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id);
		reintegro3.Status = 'CA-----A';
		insert reintegro3;

		Prestacion_de_reintegro__c pRein = new Prestacion_de_reintegro__c();
		pRein.Estado__c = 'C1-----A';
		pRein.Caso__c = reintegro.Id;
		insert pRein;

		Prestacion_de_reintegro__c pRein2 = new Prestacion_de_reintegro__c();
		pRein2.Estado__c = 'C1-----A';
		pRein2.Caso__c = reintegro2.Id;
		insert pRein2;

		reintegro = [SELECT Prestaciones_en_auditoria__c FROM Case WHERE Id = :reintegro.Id];
		reintegro2 = [SELECT Prestaciones_en_auditoria__c FROM Case WHERE Id = :reintegro2.Id];

		Test.startTest();
		LoteGeneracionDeOrdenCtrl.Response resp = LoteGeneracionDeOrdenCtrl.validarReintegrosEnAuditoria(lote.Id_lote_SS__c);
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.assert(resp.message.contains('553278'));
		System.assert(resp.message.contains('553279'));
	}

	@isTest
	private static void whenTheLoteHasNotReintegrosEnAuditoria_showSuccessMsg() {
		Lote__c lote = new Lote__c(Estado__c = 'A', Id_lote_SS__c = '5600');
		insert lote;

		Case reintegro = new Case(Lote__c = lote.Id, Codigo_reintegro_SS__c = '553279', RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id);
		reintegro.Status = 'CA-----A';
		insert reintegro;

		Test.startTest();
		LoteGeneracionDeOrdenCtrl.Response resp = LoteGeneracionDeOrdenCtrl.validarReintegrosEnAuditoria(lote.Id_lote_SS__c);
		Test.stopTest();

		System.assertEquals(false, resp.hasError);
		System.assertEquals('ok', resp.message);
	}

	@isTest
	private static void whenTheLoteHasNotExternalId_showErrorMsg() {
		Lote__c lote = new Lote__c(Estado__c = 'A');
		insert lote;

		Case reintegro = new Case(Lote__c = lote.Id, Codigo_reintegro_SS__c = '553279', RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id);
		reintegro.Status = 'CA-----A';
		insert reintegro;

		Test.startTest();
		LoteGeneracionDeOrdenCtrl.Response resp = LoteGeneracionDeOrdenCtrl.validarReintegrosEnAuditoria(lote.Id_lote_SS__c);
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.assertEquals('El lote no existe en SS', resp.message);
	}
	 
	@isTest
	private static void testMuchosReintegros() {
		Lote__c lote = [SELECT Id, Id_lote_SS__c FROM Lote__c WHERE Id_lote_SS__c = '5402'];

		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		LoteGeneracionDeOrdenCtrl.Response resp = LoteGeneracionDeOrdenCtrl.generacionDeOrden(lote.Id_lote_SS__c, 'GENERAR');
		Test.stopTest();

		Case reintegro = [SELECT Id, Status FROM Case WHERE Lote__c = :lote.Id LIMIT 1];
		
		System.assertEquals('CA-----E', reintegro.Status);

	}
}