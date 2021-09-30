@IsTest
private class OpportunityCorpArchivosContratoCtrlTest  {

	static XHttpCalloutMock getResponseFound;
	
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
				.withBody(WSCotizadorCorporativaPDFMock.getFound())
				.addForAddress(WSCotizador.SERVICE_CONFIG.URL__c + '/v1/cotizador/corporativa/cotizaciones/print/310606/contrato');
	}

	@isTest
	private static void attachContratoToOpp() {
		Test.setMock(HttpCalloutMock.class,getResponseFound);
		Opportunity corpOpp = Build.anOpportunityCorporativo().build();
		corpOpp.Tipo_de_mercado__c = '3';
		corpOpp.Plan_Grupo_Corporativo__c = 'AS200';
		insert corpOpp;
		Cotizacion__c newCotCorp = new Cotizacion__c();
		newCotCorp.Oportunidad__c = corpOpp.Id;
		newCotCorp.Nro_Cotizacion_Corporativa__c = '310606';
		insert newCotCorp;

		corpOpp.Cotizacion_Corporativa_elegida__c = newCotCorp.Id;
		corpOpp.StageName = 'Contrato Generado';
		update corpOpp;

		//ContentVersion ver = new ContentVersion();
		//ver.VersionData = EncodingUtil.base64Decode('IlBsYW4gYSBDb3RpemFyIiwiQXBlbGxpZG8geSBOb21icmUiCiJBUyAzMDAiLCJSb2JlcnRvIg==');
		//ver.Title = 'Cotizacion.csv';
		//ver.PathOnClient = '/cotizacion.csv';
		//insert ver;
		//ver = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver.Id];

		//ContentDocumentLink link = new ContentDocumentLink();
		//link.ContentDocumentId = ver.ContentDocumentId;
		//link.LinkedEntityId = newCotCorp.Id;
		//link.ShareType = 'V';
		//insert link;

		Test.startTest();
		OpportunityCorpArchivosContratoCtrl.Response res  = OpportunityCorpArchivosContratoCtrl.getArchivosContrato(corpOpp.Id);
		Test.stopTest();

		System.assertEquals('Archivos adjuntados', res.message);
		System.assertEquals(false, res.hasError);

		ContentDocumentLink cdl = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :corpOpp.Id];
		System.assertNotEquals(null, cdl.ContentDocumentId);

		ContentDocument cd = [SELECT Id, FileType FROM ContentDocument WHERE Id = :cdl.ContentDocumentId];
		System.assertEquals('PDF', cd.FileType);
	}

	//static XHttpCalloutMock canalAbierto;
	//static XHttpCalloutMock canalLaSegunda;
	//static XHttpCalloutMock gestionCompartida;

	//static{
		//Blob fakeContent = Blob.valueOf('test');
        
	
		//canalAbierto = new XHttpCalloutMock();
		//canalAbierto.buildResponse()
                //.withStatus('OK')
                //.withStatusCode(200)
                //.withBody(EncodingUtil.base64Encode(fakeContent))
                //.addForAddress('http://extranet.avalian.com/CORPORATIVO_SF/DiagramasPrestaciones/AS200.jpg');
		//canalAbierto.buildResponse()
                //.withStatus('OK')
                //.withStatusCode(200)
                //.withBody(EncodingUtil.base64Encode(fakeContent))
                //.addForAddress('http://extranet.avalian.com/CORPORATIVO_SF/Convenio_Empresas_Canal_Abierto/Anexo I (GV-F-01.01) Esquema de Descuentos-v01.pdf');
		//canalAbierto.buildResponse()
                //.withStatus('OK')
                //.withStatusCode(200)
                //.withBody(EncodingUtil.base64Encode(fakeContent))
                //.addForAddress('http://extranet.avalian.com/CORPORATIVO_SF/Convenio_Empresas_Canal_Abierto/Anexo II (GV-F-01.01) Esquema de Bonificaciones-v00.pdf');
		//canalAbierto.buildResponse()
                //.withStatus('OK')
                //.withStatusCode(200)
                //.withBody(EncodingUtil.base64Encode(fakeContent))
                //.addForAddress('http://extranet.avalian.com/CORPORATIVO_SF/Convenio_Empresas_Canal_Abierto/GV-F-01.01 Convenio Empresas-Canal Abierto-v00.pdf');
		//canalAbierto.buildResponse()
                //.withStatus('OK')
                //.withStatusCode(200)
                //.withBody(EncodingUtil.base64Encode(fakeContent))
                //.addForAddress('http://extranet.avalian.com/CORPORATIVO_SF/Convenio_Empresas_Canal_Abierto/GV-F-01.05 Descripción Convenio-v01.pdf');

		//canalLaSegunda = new XHttpCalloutMock();
		//canalLaSegunda.buildResponse()
                //.withStatus('OK')
                //.withStatusCode(200)
                //.withBody(EncodingUtil.base64Encode(fakeContent))
                //.addForAddress('http://extranet.avalian.com/CORPORATIVO_SF/DiagramasPrestaciones/AS200.jpg');
		//canalLaSegunda.buildResponse()
                //.withStatus('OK')
                //.withStatusCode(200)
                //.withBody(EncodingUtil.base64Encode(fakeContent))
                //.addForAddress('http://extranet.avalian.com/CORPORATIVO_SF/Convenio_Empresas_Canal_LaSegunda/Anexo I (GV-F-01.02) Esquema de Descuentos-v01.pdf');
		//canalLaSegunda.buildResponse()
                //.withStatus('OK')
                //.withStatusCode(200)
                //.withBody(EncodingUtil.base64Encode(fakeContent))
                //.addForAddress('http://extranet.avalian.com/CORPORATIVO_SF/Convenio_Empresas_Canal_LaSegunda/Anexo II (GV-F-01.02) Esquema de Bonificaciones-v00.pdf');
		//canalLaSegunda.buildResponse()
                //.withStatus('OK')
                //.withStatusCode(200)
                //.withBody(EncodingUtil.base64Encode(fakeContent))
                //.addForAddress('http://extranet.avalian.com/CORPORATIVO_SF/Convenio_Empresas_Canal_LaSegunda/GV-F-01.02 Convenio Empresas-Canal LaSegunda-v00.pdf');
		//canalLaSegunda.buildResponse()
                //.withStatus('OK')
                //.withStatusCode(200)
                //.withBody(EncodingUtil.base64Encode(fakeContent))
                //.addForAddress('http://extranet.avalian.com/CORPORATIVO_SF/Convenio_Empresas_Canal_LaSegunda/GV-F-01.05 Descripción Convenio-v01.pdf');

		//gestionCompartida = new XHttpCalloutMock();
		//gestionCompartida.buildResponse()
                //.withStatus('OK')
                //.withStatusCode(200)
                //.withBody(EncodingUtil.base64Encode(fakeContent))
                //.addForAddress('http://extranet.avalian.com/CORPORATIVO_SF/DiagramasPrestaciones/AS200.jpg');
		//gestionCompartida.buildResponse()
                //.withStatus('OK')
                //.withStatusCode(200)
                //.withBody(EncodingUtil.base64Encode(fakeContent))
                //.addForAddress('http://extranet.avalian.com/CORPORATIVO_SF/Convenio_Gestion_Compartida/Anexo IV (GV-F-01.03) Modelo Gestión Compartida-CA-v00.pdf');
		//gestionCompartida.buildResponse()
                //.withStatus('OK')
                //.withStatusCode(200)
                //.withBody(EncodingUtil.base64Encode(fakeContent))
                //.addForAddress('http://extranet.avalian.com/CORPORATIVO_SF/Convenio_Gestion_Compartida/GV-F-01.03 Convenio Gestión Compartida-Canal Abierto-v00.pdf');
		//gestionCompartida.buildResponse()
                //.withStatus('OK')
                //.withStatusCode(200)
                //.withBody(EncodingUtil.base64Encode(fakeContent))
                //.addForAddress('http://extranet.avalian.com/CORPORATIVO_SF/Convenio_Gestion_Compartida/GV-F-01.05 Descripción Convenio-v01.pdf');
	//}

	//@isTest
	//private static void attachFilesToOppWithCanalAbierto() {
		//Test.setMock(HttpCalloutMock.class,canalAbierto);
		//Opportunity corpOpp = Build.anOpportunityCorporativo().build();
		//corpOpp.Tipo_de_mercado__c = '1';
		//corpOpp.Plan_Grupo_Corporativo__c = 'AS200';
		//insert corpOpp;
		//Cotizacion__c newCotCorp = new Cotizacion__c();
		//newCotCorp.Oportunidad__c = corpOpp.Id;
		//insert newCotCorp;

		//corpOpp.Cotizacion_Corporativa_elegida__c = newCotCorp.Id;
		//corpOpp.StageName = 'Contrato Generado';
		//update corpOpp;

		//ContentVersion ver = new ContentVersion();
		//ver.VersionData = EncodingUtil.base64Decode('IlBsYW4gYSBDb3RpemFyIiwiQXBlbGxpZG8geSBOb21icmUiCiJBUyAzMDAiLCJSb2JlcnRvIg==');
		//ver.Title = 'Cotizacion.csv';
		//ver.PathOnClient = '/cotizacion.csv';
		//insert ver;
		//ver = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver.Id];

		//ContentDocumentLink link = new ContentDocumentLink();
		//link.ContentDocumentId = ver.ContentDocumentId;
		//link.LinkedEntityId = newCotCorp.Id;
		//link.ShareType = 'V';
		//insert link;

		//Test.startTest();
		//OpportunityCorpArchivosContratoCtrl.Response res  = OpportunityCorpArchivosContratoCtrl.getArchivosContrato(corpOpp.Id);
		//Test.stopTest();

		//System.assertEquals('Archivos adjuntados', res.message);
		//System.assertEquals(false, res.hasError);
	//}

		//@isTest
	//private static void attachFilesToOppWithCanalLaSegunda() {
		//Test.setMock(HttpCalloutMock.class,canalLaSegunda);
		//Opportunity corpOpp = Build.anOpportunityCorporativo().build();
		//corpOpp.Tipo_de_mercado__c = '2';
		//corpOpp.Plan_Grupo_Corporativo__c = 'AS200';
		//insert corpOpp;
		//Cotizacion__c newCotCorp = new Cotizacion__c();
		//newCotCorp.Oportunidad__c = corpOpp.Id;
		//insert newCotCorp;

		//corpOpp.Cotizacion_Corporativa_elegida__c = newCotCorp.Id;
		//corpOpp.StageName = 'Contrato Generado';
		//update corpOpp;

		//ContentVersion ver = new ContentVersion();
		//ver.VersionData = EncodingUtil.base64Decode('IlBsYW4gYSBDb3RpemFyIiwiQXBlbGxpZG8geSBOb21icmUiCiJBUyAzMDAiLCJSb2JlcnRvIg==');
		//ver.Title = 'Cotizacion.csv';
		//ver.PathOnClient = '/cotizacion.csv';
		//insert ver;
		//ver = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver.Id];

		//ContentDocumentLink link = new ContentDocumentLink();
		//link.ContentDocumentId = ver.ContentDocumentId;
		//link.LinkedEntityId = newCotCorp.Id;
		//link.ShareType = 'V';
		//insert link;

		//Test.startTest();
		//OpportunityCorpArchivosContratoCtrl.Response res  = OpportunityCorpArchivosContratoCtrl.getArchivosContrato(corpOpp.Id);
		//Test.stopTest();

		//System.assertEquals('Archivos adjuntados', res.message);
		//System.assertEquals(false, res.hasError);
	//}

	//@isTest
	//private static void attachFilesToOppWithGestionCompartida() {
		//Test.setMock(HttpCalloutMock.class,gestionCompartida);
		//Opportunity corpOpp = Build.anOpportunityCorporativo().build();
		//corpOpp.Tipo_de_mercado__c = '3';
		//corpOpp.Plan_Grupo_Corporativo__c = 'AS200';
		//insert corpOpp;
		//Cotizacion__c newCotCorp = new Cotizacion__c();
		//newCotCorp.Oportunidad__c = corpOpp.Id;
		//insert newCotCorp;

		//corpOpp.Cotizacion_Corporativa_elegida__c = newCotCorp.Id;
		//corpOpp.StageName = 'Contrato Generado';
		//update corpOpp;

		//ContentVersion ver = new ContentVersion();
		//ver.VersionData = EncodingUtil.base64Decode('IlBsYW4gYSBDb3RpemFyIiwiQXBlbGxpZG8geSBOb21icmUiCiJBUyAzMDAiLCJSb2JlcnRvIg==');
		//ver.Title = 'Cotizacion.csv';
		//ver.PathOnClient = '/cotizacion.csv';
		//insert ver;
		//ver = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver.Id];

		//ContentDocumentLink link = new ContentDocumentLink();
		//link.ContentDocumentId = ver.ContentDocumentId;
		//link.LinkedEntityId = newCotCorp.Id;
		//link.ShareType = 'V';
		//insert link;

		//Test.startTest();
		//OpportunityCorpArchivosContratoCtrl.Response res  = OpportunityCorpArchivosContratoCtrl.getArchivosContrato(corpOpp.Id);
		//Test.stopTest();

		//System.assertEquals('Archivos adjuntados', res.message);
		//System.assertEquals(false, res.hasError);
	//}
}