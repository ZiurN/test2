@isTest 
private class ReingresoBtnCtrlTest {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getErrorResponseDomicilios;

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
			.withBody(WSAsociadoGetCuentaCorrienteMock.getEmpty())
			.addForAddress(WSAsociadoGetCuentaCorriente.SERVICE_CONFIG.URL__c + '/v1/salud/cuenta-corriente/473981');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoGetDomiciliosMock.getFound())
			.addForAddress(WSAsociadoGetDomicilios.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/domicilios/473981');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetCuentaCorrienteMock.getError())
			.addForAddress(WSAsociadoGetCuentaCorriente.SERVICE_CONFIG.URL__c + '/v1/salud/cuenta-corriente/0');

		getErrorResponseDomicilios = new XHttpCalloutMock();
		getErrorResponseDomicilios.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponseDomicilios.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoGetCuentaCorrienteMock.getEmpty())
			.addForAddress(WSAsociadoGetCuentaCorriente.SERVICE_CONFIG.URL__c + '/v1/salud/cuenta-corriente/473981');
		getErrorResponseDomicilios.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetDomiciliosMock.getError())
			.addForAddress(WSAsociadoGetDomicilios.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/domicilios/0');

	}
	//@isTest
	//private static void assignOpportunityToSalesWithServiceUser() {
		//Test.setMock(HttpCalloutMock.class, getResponseFound);

		//Account acc = Build.anAccountCuentapersonal().build();
		//acc.Estado__c = 'Dado de baja';
		//acc.Fecha_vigencia__c= System.today().addDays(-336);
		//acc.PersonBirthdate = System.today().addYears(-50);
		//acc.Afi_Id__c = '473981';
		//insert acc;

		//List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Lider service'];

        //User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
                //EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                //LocaleSidKey='en_US', ProfileId = profileList[0].Id,
                //TimeZoneSidKey='America/Los_Angeles', UserName='userToAssignOpportunityToSales@xappia.com'
        //);
        //insert usuario;

		//ReingresoBtnCtrl.Response resp;  
		//System.runAs(usuario) {
			//Test.startTest();
			//resp = ReingresoBtnCtrl.assingTo(acc.Id); 
			//Test.stopTest();
		//}
		
		//System.assertEquals('Ventas', resp.message);

	//}

	//@isTest
	//private static void assignOpportunityToSalesWithSalesUser() {
		//Test.setMock(HttpCalloutMock.class, getResponseFound);

		//Account acc = Build.anAccountCuentapersonal().build();
		//acc.Estado__c = 'Dado de baja';
		//acc.Fecha_vigencia__c= System.today().addDays(-30);
		//acc.Afi_Id__c = '473981';
		//insert acc;

		//List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Agente de Ventas'];
		//UserRole rol = [SELECT Id FROM UserRole WHERE Name = 'Comercial AMBA' LIMIT 1];

		//User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
				//EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				//LocaleSidKey='en_US', ProfileId = profileList[0].Id, UserRoleId = rol.Id,
				//TimeZoneSidKey='America/Los_Angeles', UserName='userToAssignOpportunityToSales2@xappia.com'
		//);

		//Localidad__c loc = new Localidad__c();
		//loc.Organizador_lookup__c = UserInfo.getUserId();
		//loc.Codigo_Postal__c = '2743ARY';
		//insert loc;

		//System.runAs(new User(Id = UserInfo.getUserId())) {
			//insert usuario;
		//}


		//ReingresoBtnCtrl.Response resp;  
		//System.runAs(usuario) {
			//Test.startTest();
			//resp = ReingresoBtnCtrl.assingTo(acc.Id); 
			//Test.stopTest();
		//}
		
		//System.assertEquals('Ventas', resp.message);
		//System.assertEquals(loc.Organizador_lookup__c, resp.organizador);

	//}

	@isTest
	private static void assignOpportunityToServiceWithServiceUser() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);

		Account acc = Build.anAccountCuentapersonal().build();
		acc.Estado__c = 'B';
		acc.Fecha_vigencia__c= System.today().addDays(-100);
		acc.PersonBirthdate = System.today().addYears(-50);
		acc.Afi_Id__c = '473981';
		insert acc;

		List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = 'Administrador del sistema'];

        User usuario = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = profileList[0].Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='userToAssignOpportunityToSales@xappia.com'
        );
        insert usuario;

		ReingresoBtnCtrl.Response resp;  
		System.runAs(usuario) {
			Test.startTest();
			resp = ReingresoBtnCtrl.assingTo(acc.Id); 
			Test.stopTest();
		}
		
		System.assertEquals('Servicio', resp.message);
        System.assertEquals('System Administrator', resp.profile);

	}

	//@isTest
	//private static void getErrorWhenTheWSCuentaCorrienteFails() {
		//Test.setMock(HttpCalloutMock.class, getErrorResponse);

		//Account acc = Build.anAccountCuentapersonal().build();
		//acc.Afi_Id__c = '473981';
		//insert acc;

		//Test.startTest();
		//ReingresoBtnCtrl.Response resp = ReingresoBtnCtrl.assingTo(acc.Id); 
		//Test.stopTest();

		//System.assertEquals('No se puede obtener la deuda del asociado', resp.message);
	//}

	//@isTest
	//private static void getErrorWhenTheWSDomiciliosFails() {
		//Test.setMock(HttpCalloutMock.class, getErrorResponseDomicilios);

		//Account acc = Build.anAccountCuentapersonal().build();
		//acc.Afi_Id__c = '473981';
		//insert acc;

		//Test.startTest();
		//ReingresoBtnCtrl.Response resp = ReingresoBtnCtrl.assingTo(acc.Id); 
		//Test.stopTest();

		//System.assertEquals('No se puede obtener el domicilio del asociado', resp.message);
	//}
}