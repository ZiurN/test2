@isTest
private class AsociadoInterfazFinancieraCtrlTest{
	
	@isTest
	static void ifResponseHasAnErrorValuesIsFalseShouldReturnInterfazFinancieraAndSectionMapsValuesNotNull(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);

		AsociadoInterfazFinancieraCtrl.Response response= new AsociadoInterfazFinancieraCtrl.Response();
		Test.startTest();
		response = AsociadoInterfazFinancieraCtrl.getInterfazFinanciera('69794');
		Test.stopTest();

		System.assert(!response.hasError);
		System.assertNotEquals(null, response.interfazFinanciera);
		System.assertEquals(8, response.gananciasSection.size());
		System.assertEquals(9, response.ivaSection.size());
		System.assertEquals(6, response.iibbSection.size());
		System.assertEquals(7, response.clienteSection.size());
		System.assertEquals(5, response.comprobanteSection.size());
		System.assertEquals(9, response.proveedorSection.size());
		System.assertEquals(5, response.otrosSection.size());
	}
	
	@isTest
	static void ifResponseHasAnErrorValueIsTrueFromTheWSShouldReturnInterfazFinancieraNull(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);

		AsociadoInterfazFinancieraCtrl.Response response= new AsociadoInterfazFinancieraCtrl.Response();
		Test.startTest();
		response = AsociadoInterfazFinancieraCtrl.getInterfazFinanciera('519100');
		Test.stopTest();

		System.assert(response.hasError);
		System.assertEquals(null, response.interfazFinanciera);
		System.assertEquals('Hubo un error al intentar obtener la interfaz financiera desde SaludSoft', response.message);
	}

	static Account acc, acc2, acc3;
	static List<Account> accList;
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static{
		acc = Build.anAccountCuentapersonal()
			  .withLastName('Xappia')
			  .withCodigodeEntidad('69794')
			  .build();

		acc2 = Build.anAccountCuentapersonal()
			  .withLastName('Xappia 2')
			  .build();

		acc3 = Build.anAccountCuentapersonal()
			  .withLastName('Xappia')
			  .withCodigodeEntidad('519100')
			  .build();

		accList = new List<Account>{acc, acc2, acc3};
		insert accList;	

		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoGetInterfazFinancieraMock.getInterfazFinancieraOK())
			.addForAddress(WSAsociadoGetInterfazFinanciera.SERVICE_CONFIG.URL__c + '/v1/salud/interfaz-financiera/69794');
	}
}