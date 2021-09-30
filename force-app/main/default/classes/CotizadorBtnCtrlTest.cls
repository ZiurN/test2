@isTest 
private class CotizadorBtnCtrlTest {
	static XHttpCalloutMock getResponseFoundInd;
	static XHttpCalloutMock getResponseFoundCorp;
	static XHttpCalloutMock getErrorInd;
	static XHttpCalloutMock getErrorCorp;
	static XHttpCalloutMock responseFound;

	static {
		getResponseFoundInd = new XHttpCalloutMock();
		getResponseFoundInd.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundInd.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSCotizadorMock.getFound())
				.addForAddress(WSCotizador.SERVICE_CONFIG.URL__c + '/v1/cotizador/cotizaciones');

		getErrorInd = new XHttpCalloutMock();
		getErrorInd.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorInd.buildResponse()
				.withStatus('El campo tipo dni id es obligatorio.')
				.withStatusCode(422)
				.withBody(WSCotizadorMock.getError())
				.addForAddress(WSCotizador.SERVICE_CONFIG.URL__c + '/v1/cotizador/cotizaciones');

		getResponseFoundCorp = new XHttpCalloutMock();
		getResponseFoundCorp.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundCorp.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSCotizadorMock.getFoundCorporativa())
				.addForAddress(WSCotizador.SERVICE_CONFIG.URL__c + '/v1/cotizador/corporativa/cotizaciones');
		getResponseFoundCorp.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSCotizadorCorporativaPDFMock.getFound())
				.addForAddress(WSCotizador.SERVICE_CONFIG.URL__c + '/v1/cotizador/corporativa/cotizaciones/print/310606');


		responseFound = new XHttpCalloutMock();
        responseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        responseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSCotizadorGetPDFMock.getResponseFound())
                .addForAddress(WSCotizador.SERVICE_CONFIG.URL__c + '/v1/cotizador/cotizaciones/print/731');

		
	}


	@isTest
	private static void testCotizacionCorp() {
		Test.setMock(HttpCalloutMock.class,getResponseFoundCorp);
		Opportunity op = new Opportunity(Calle__c='falsa',Name='Prueba test',CloseDate=Date.today(),
		StageName='Contactado',Numero__c=123,Piso__c='1',RecordTypeId = XappiaHelper.getRecordType('Opportunity','Corporativo').Id);
		op.Plan_Grupo_Corporativo__c = 'AS200';
		op.Tipo_de_mercado__c = '1';
		insert op;
		ContentVersion ver = new ContentVersion(VersionData=Blob.valueOf('test'),Title='Prueba',PathOnClient='/prueba');
		insert ver;
		ContentVersion updatedVer = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver.Id];
		Test.startTest();
		CotizadorBtnCtrl.Response cotResp = CotizadorBtnCtrl.sendToWSCotizadorCorp(op.Id,updatedVer.ContentDocumentId);
		Test.stopTest();
		System.debug(cotResp);

		System.assertEquals(false,cotResp.hasError);
		
		Cotizacion__c cot = [SELECT Id, Nro_Cotizacion_Corporativa__c FROM Cotizacion__c];
		System.assertEquals('310606', cot.Nro_Cotizacion_Corporativa__c);

		ContentDocumentLink[] cdls = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :cot.Id];
		System.assertEquals(2, cdls.size());
		Id[] cdIds = new List<Id>{cdls[0].ContentDocumentId, cdls[1].ContentDocumentId};

		ContentDocument[] cdXLSX = [SELECT Id, FileType FROM ContentDocument WHERE Id IN :cdIds AND FileExtension = 'xlsx'];
		ContentDocument[] cdPDF = [SELECT Id, FileType FROM ContentDocument WHERE Id IN :cdIds AND FileType = 'PDF'];
		System.assertEquals(1, cdXLSX.size());
		System.assertEquals(1, cdPDF.size());
	}


	@isTest
	private static void testCotizacionInd() {
		Localidad__c loc = Build.aLocalidad()
			.withLocId('123')
			.withNombreLocalidad('Ciudadela')
			.withCodigoPostal('1702')
			.withCodigoProvincia('B')
			.withOrganizador(UserInfo.getUserId())
			.build();
		insert loc;
		Test.setMock(HttpCalloutMock.class,getResponseFoundInd);
		Account ac = Build.anAccountCuentapersonal().build();
		insert ac;
		Opportunity op = new Opportunity(Calle__c='falsa',Name='Prueba test',CloseDate=Date.today(),
		StageName='Contactado',Numero__c=123,Piso__c='1');
		op.AccountId = ac.Id;
		insert op;
		Cotizacion__c coti = new Cotizacion__c(Nombre_y_Apellido__c='Prueba test',Edad__c=20,
		Tipo_de_Documento__c='DNI',Nro_de_Documento__c=100000,Localidad__c='1349',Estado_Civil__c='C',
		Edad_conyuge__c=20,Telfono__c='161651',Tipo_de_afiliado__c='Voluntario',
		Tipo_de_contacto__c='2',Hijos_hasta_20_aos__c=0,Hijos_entre_21_y_25_aos__c=0,
		Correo_electronico__c='pepito@test.com',Pago_con_debito__c='1',
		Plan_a_cotizar__c='AS200');
		coti.Localidad_new__c = loc.Id;
		coti.Oportunidad__c = op.Id;
		insert coti;

		Test.startTest();
		CotizadorBtnCtrl.Response cotResp = CotizadorBtnCtrl.sendToWSCotizadorInd(coti.Id);
		Test.stopTest();

		System.assertEquals(false,cotResp.hasError);
		Cotizacion__c updatedCot = [
			SELECT Id,Total_de_capitas_cotizadas__c, Nro_cotizacion_individual__c,Precio_Titular__c,
			Precio_1er_hijo_menor_21_aos__c,Precio_Conyuge__c,Precio_hijo_entre_21_y_25_aos__c,Precio_total__c,
			Deduccion_de_aportes__c,Deduccin_de_aportes_Monotributo__c,Bonif_especial_6_meses__c,
			Dto_pago_con_tarjeta_de_credito__c,Diferencia_a_pagar__c,Precio_2do_hijo_menor_21_aos__c,Precio_3er_hijo_menor_21_aos__c 
			FROM Cotizacion__c 
			WHERE Id = :coti.Id
		];
		System.assertEquals('4',updatedCot.Total_de_capitas_cotizadas__c);
		System.assertEquals(null,updatedCot.Nro_cotizacion_individual__c);
		System.assertEquals('3192.95',updatedCot.Precio_Titular__c);
		System.assertEquals(null,updatedCot.Precio_1er_hijo_menor_21_aos__c);
		System.assertEquals('2313.67',updatedCot.Precio_Conyuge__c);
		System.assertEquals('2553.21',updatedCot.Precio_hijo_entre_21_y_25_aos__c);
		System.assertEquals('8059.84',updatedCot.Precio_total__c);
		System.assertEquals('32500',updatedCot.Deduccion_de_aportes__c);
		System.assertEquals(null,updatedCot.Deduccin_de_aportes_Monotributo__c);
		System.assertEquals('805.98',updatedCot.Bonif_especial_6_meses__c);
		System.assertEquals(null,updatedCot.Dto_pago_con_tarjeta_de_credito__c);
		System.assertEquals('2794.88',updatedCot.Diferencia_a_pagar__c);
		System.assertEquals(null,updatedCot.Precio_2do_hijo_menor_21_aos__c);
		System.assertEquals(null,updatedCot.Precio_3er_hijo_menor_21_aos__c);

	}

	@isTest
	private static void testCotizacionIndFails() {
		Test.setMock(HttpCalloutMock.class,getErrorInd);
		Account ac = Build.anAccountCuentapersonal().build();
		insert ac;
		Opportunity op = new Opportunity(Calle__c='falsa',Name='Prueba test',CloseDate=Date.today(),
		StageName='Contactado',Numero__c=123,Piso__c='1');
		op.AccountId = ac.Id;
		insert op;
		Cotizacion__c coti = new Cotizacion__c(Nombre_y_Apellido__c='Prueba test',Edad__c=20,
		Tipo_de_Documento__c='DNI',Nro_de_Documento__c=0,Localidad__c='1349',Estado_Civil__c='C',
		Edad_conyuge__c=20,Telfono__c='161651',Tipo_de_afiliado__c='Voluntario',
		Tipo_de_contacto__c='2',Hijos_hasta_20_aos__c=0,Hijos_entre_21_y_25_aos__c=0,
		Correo_electronico__c='pepito@test.com',Pago_con_debito__c='1',
		Plan_a_cotizar__c='AS200');
		coti.Oportunidad__c = op.Id;
		insert coti;

		Test.startTest();
		CotizadorBtnCtrl.Response cotResp = CotizadorBtnCtrl.sendToWSCotizadorInd(coti.Id);
		Test.stopTest();

		System.assertEquals(true,cotResp.hasError);

	}

	@IsTest
	private static void getPdfFromCotizacion(){
		Test.setMock(HttpCalloutMock.class, responseFound);
		Localidad__c loc = Build.aLocalidad()
			.withLocId('123')
			.withNombreLocalidad('Ciudadela')
			.withCodigoPostal('1702')
			.withCodigoProvincia('B')
			.withOrganizador(UserInfo.getUserId())
			.build();
		insert loc;
		Account ac = Build.anAccountCuentapersonal().build();
		insert ac;
		Opportunity op = new Opportunity(Calle__c='falsa',Name='Prueba test',CloseDate=Date.today(),
		StageName='Contactado',Numero__c=123,Piso__c='1');
		op.AccountId = ac.Id;
		insert op;
		Cotizacion__c coti = new Cotizacion__c(Nombre_y_Apellido__c='Prueba test',Edad__c=20,
		Tipo_de_Documento__c='DNI',Nro_de_Documento__c=100000,Localidad__c='1349',Estado_Civil__c='C',
		Edad_conyuge__c=20,Telfono__c='161651',Tipo_de_afiliado__c='Voluntario',
		Tipo_de_contacto__c='2',Hijos_hasta_20_aos__c=0,Hijos_entre_21_y_25_aos__c=0,
		Correo_electronico__c='pepito@test.com',Pago_con_debito__c='1',
		Plan_a_cotizar__c='AS200');
		coti.Localidad_new__c = loc.Id;
		coti.Oportunidad__c = op.Id;
		coti.Nro_cotizacion_individual__c = '731';
		insert coti;

		Test.startTest();
		CotizadorBtnCtrl.generatePDF(coti.Id);
		Test.stopTest();
		List<ContentVersion> versions = [
			SELECT Id
			FROM ContentVersion
		];
		System.assertEquals(1,versions.size());
	}
}