@isTest 
private class CaseTestReintegroBtnCtrlTest {
	
	static XHttpCalloutMock getResponseFoundPres;
	static XHttpCalloutMock getResponseFoundMed;
	static XHttpCalloutMock getErrorResponse;
	static Account asociado;
	static Nomenclador_de_Prestacion__c nomenclador;
	static Medicamento__c medicamento;
	static String bodyPres;
	static String bodyMed;

	static {
		getResponseFoundPres = new XHttpCalloutMock();
		getResponseFoundPres.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundPres.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSCaseTestReintegroMock.getFoundPres())
			.addForAddress(WSCaseTestReintegro.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/test');

		getResponseFoundMed = new XHttpCalloutMock();
		getResponseFoundMed.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundMed.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSCaseTestReintegroMock.getFoundMed())
			.addForAddress(WSCaseTestReintegro.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/test');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSCaseTestReintegroMock.getError())
			.addForAddress(WSCaseTestReintegro.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/test');

		asociado = Build.anAccountCuentapersonal().build();
		asociado.Codigo_de_Afiliado__c = '46940/16';
		insert asociado;

		nomenclador = new Nomenclador_de_Prestacion__c(Codigo__c = '02146003');
		insert nomenclador;

		medicamento = new Medicamento__c(Codigo_medicamento__c = '48896');
		insert medicamento;

		bodyPres = 
			'{' +
				'"contexto": "A",' +
				'"tipo": "prestacion",' +
				'"fecha": "27/03/2020",' +
				'"asociado": "' + asociado.Id + '",' +
				'"prestacion": "' + nomenclador.Id + '"' +
			'}';
		bodyMed = 
			'{' +
				'"contexto": "A",' +
				'"tipo": "medicamento",' +
				'"asociado": "' + asociado.Id + '",' +
				'"medicamento": "' + medicamento.Id + '"' +
			'}';				
	}

	@isTest
	private static void whenClickTheMedicamentoButton_showTheCorrectResponse() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundMed);
		
		Test.startTest();
		CaseTestReintegroBtnCtrl.Response responseToAssert = CaseTestReintegroBtnCtrl.testReintegro(bodyMed);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals('48896', responseToAssert.data.medicamento);
		System.assertEquals('66441.35', responseToAssert.data.precio_vta);
		System.assertEquals('53153.08', responseToAssert.data.precio_vta_20);
		System.assertEquals('40', responseToAssert.data.porc_cob);
		System.assertEquals('21261.23', responseToAssert.data.total);
	}

	@isTest
	private static void whenClickThePrestacionButton_showTheCorrectResponse() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundPres);
		
		Test.startTest();
		CaseTestReintegroBtnCtrl.Response responseToAssert = CaseTestReintegroBtnCtrl.testReintegro(bodyPres);
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals('02146003', responseToAssert.data.prestacion);
		System.assertEquals('257', responseToAssert.data.honorario);
		System.assertEquals('257', responseToAssert.data.gastos);
		System.assertEquals('100.66', responseToAssert.data.copago);
		System.assertEquals('413.34', responseToAssert.data.total);
	}

	@isTest
	private static void whenClickThePrestacionButtonWithIncompleteData_showTheCorrectErrorMsg() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundPres);
		
		String body = '{"tipo": "prestacion"}';

		Test.startTest();
		CaseTestReintegroBtnCtrl.Response responseToAssert = CaseTestReintegroBtnCtrl.testReintegro(body);
		Test.stopTest();

		String msg = '- El asociado está vacío.\n' + '- La prestacion está vacía.\n';
		
		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals(msg, responseToAssert.message);
		
		
	}

	@isTest
	private static void whenClickTheMedicamentoButtonWithIncompleteData_showTheCorrectErrorMsg() {
		Test.setMock(HttpCalloutMock.class, getResponseFoundPres);
		
		String body = '{"tipo": "medicamento"}';

		Test.startTest();
		CaseTestReintegroBtnCtrl.Response responseToAssert = CaseTestReintegroBtnCtrl.testReintegro(body);
		Test.stopTest();

		String msg = '- El asociado está vacío.\n' + '- El medicamento está vacío.\n';
		
		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals(msg, responseToAssert.message);
		
	}

	@IsTest
	private static void whenHaveAnError_ShowTheErrorMsgFromWS() {
		Test.setMock(HttpCalloutMock.class, getErrorResponse);

		Test.startTest();
		CaseTestReintegroBtnCtrl.Response responseToAssert = CaseTestReintegroBtnCtrl.testReintegro(bodyMed);
		Test.stopTest();

		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals('Debe cargar un medicamente o una prestación.\n', responseToAssert.message);
	}

	@IsTest
	private static void getTheRTReintegroInCase() {
		String reintegroRTId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;

		Test.startTest();
		String responseToAssert = CaseTestReintegroBtnCtrl.getReintegroRT();
		Test.stopTest();
	
		System.assertEquals(reintegroRTId, responseToAssert);
	}
}