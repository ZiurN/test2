@isTest 
private class PrestacionTriggerTest {
	static Case aCase;
	static Prestacion__c prest;

	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseEmitirOrdenFound;
	static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock serverMock;

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
				.withBody(WSCaseAPEmitirOrdenMock.getFound())
				.addForAddress(WSCaseAPEmitirOrden.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/orden-ap/generar/1014009998');

		getResponseEmitirOrdenFound = new XHttpCalloutMock();
		getResponseEmitirOrdenFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSAuthTokenMock.getTokenSuccess())
				.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseEmitirOrdenFound.buildResponse()
				.withStatus('OK')
				.withStatusCode(200)
				.withBody(WSCaseAPEmitirOrdenMock.getFound())
				.addForAddress(WSCaseAPEmitirOrden.SERVICE_CONFIG.URL__c + '/v1/salud/autorizaciones/orden-ap/generar/12345678');

		aCase = new Case();
		
		insert aCase;

		prest = new Prestacion__c();
		prest.Estado__c = 'C1-----A';
		prest.Ap__c = aCase.Id;

		insert prest;
	}

	@isTest
	private static void whenACaseIsAlreadyAuthorize_DontModifiedTheStatusAgain() {
		Case aCase = new Case();
		aCase.Status = 'Autorizada';

		insert aCase;

		Prestacion__c prest = new Prestacion__c();
		prest.Estado__c = 'C1-----A';
		prest.Ap__c = aCase.Id;

		insert prest;
		//Test.setMock(HttpCalloutMock.class, getResponseEmitirOrdenFound);
		Test.startTest();
		prest.Estado__c = 'C1----AS';

		update prest;
		Test.stopTest();

		aCase = [SELECT Status, CreatedDate, LastModifiedDate FROM Case WHERE Id = :aCase.Id];

		System.assertEquals('Autorizada', aCase.Status);
		System.assertEquals(aCase.LastModifiedDate, aCase.CreatedDate);
	}

	@isTest
	private static void whenAPrestacionIsNotAuthorized_DontAthorizeTheCase() {
		Prestacion__c prest2 = new Prestacion__c();
		prest2.Estado__c = 'C1-----A';
		prest2.Ap__c = aCase.Id;

		insert prest2;

		Test.startTest();
		prest.Estado__c = 'C1----AS';

		update prest;
		Test.stopTest();

		aCase = [SELECT Status FROM Case WHERE Id = :aCase.Id];

		System.assertEquals('CA-----G', aCase.Status);
	}

	@isTest
	private static void avoidAnotherPrestacionWithSameNomencladorCodeInTheSameCaseAtInsert() {
		Nomenclador_de_Prestacion__c nom = new Nomenclador_de_Prestacion__c();
		nom.Codigo__c = '123456';
		nom.Estado__c = 'A';
		insert nom;

		Case aCase = new Case();
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		insert aCase;

		Prestacion__c prest = new Prestacion__c();
		prest.Estado__c = 'C1-----A';
		prest.Ap__c = aCase.Id;
		prest.Prestacion__c = nom.Id;
		insert prest;

		Prestacion__c prest2 = new Prestacion__c();
		prest2.Estado__c = 'C1-----A';
		prest2.Ap__c = aCase.Id;
		prest2.Prestacion__c = nom.Id;

		Test.startTest();
		Database.SaveResult result = Database.insert(prest2, false);
		Test.stopTest();

		String errorMsg = 'No se permite cargar dos prestaciones con el mismo nomenclador al mismo caso';
		System.assert(!result.isSuccess());
		System.assertEquals(errorMsg, result.getErrors()[0].getMessage());
	}

	@isTest
	private static void avoidAnotherPrestacionWithSameNomencladorCodeInTheSameCaseAtUpdate() {
		Nomenclador_de_Prestacion__c nom = new Nomenclador_de_Prestacion__c();
		nom.Codigo__c = '123456';
		nom.Estado__c = 'A';
		insert nom;

		Case aCase = new Case();
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		insert aCase;

		Case aCase2 = new Case();
		aCase2.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		insert aCase2;

		Prestacion__c prest3 = new Prestacion__c();
		prest3.Estado__c = 'C1-----A';
		prest3.Ap__c = aCase2.Id;
		prest3.Prestacion__c = nom.Id;
		insert prest3;

		Prestacion__c prest = new Prestacion__c();
		prest.Estado__c = 'C1-----A';
		prest.Ap__c = aCase.Id;
		prest.Prestacion__c = nom.Id;
		insert prest;

		Prestacion__c prest2 = new Prestacion__c();
		prest2.Estado__c = 'C1-----A';
		prest2.Ap__c = aCase.Id;
		insert prest2;

		Test.startTest();
		prest2.Prestacion__c = nom.Id;
		Database.SaveResult result = Database.update(prest2, false);
		Test.stopTest();

		String errorMsg = 'No se permite cargar dos prestaciones con el mismo nomenclador al mismo caso';
		System.assert(!result.isSuccess());
		System.assertEquals(errorMsg, result.getErrors()[0].getMessage());
	}

	@isTest
	private static void avoidAnotherPrestacionWithSameMedicamentoCodeInTheSameCaseAtUpdate() {
		Medicamento__c med = new Medicamento__c();
		med.Codigo_medicamento__c = '123456';
		med.Estado_Presentacion__c = 'A';
		insert med;

		Case aCase = new Case();
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		insert aCase;

		Case aCase2 = new Case();
		aCase2.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		insert aCase2;

		Prestacion__c prest3 = new Prestacion__c();
		prest3.Estado__c = 'C1-----A';
		prest3.Ap__c = aCase2.Id;
		prest3.Medicamento__c = med.Id;
		insert prest3;

		Prestacion__c prest = new Prestacion__c();
		prest.Estado__c = 'C1-----A';
		prest.Ap__c = aCase.Id;
		prest.Medicamento__c = med.Id;
		insert prest;

		Prestacion__c prest2 = new Prestacion__c();
		prest2.Estado__c = 'C1-----A';
		prest2.Ap__c = aCase.Id;
		insert prest2;

		Test.startTest();
		prest2.Medicamento__c = med.Id;
		Database.SaveResult result = Database.update(prest2, false);
		Test.stopTest();

		String errorMsg = 'No se permite cargar dos prestaciones con el mismo medicamento al mismo caso';
		System.assert(!result.isSuccess());
		System.assertEquals(errorMsg, result.getErrors()[0].getMessage());
	}

	@isTest
	private static void WhenCaseStatusIsNotGeneradaAndTryToDeleteAPrestacion_showErrorMsg() {
		String uniqueUserName = 'standarduserprestaciontrigger' + DateTime.now().getTime() + '@testorg.com';
		Profile pFront = [SELECT Id FROM Profile WHERE Name='Front'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
		User usuarioFront = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'Front', ProfileId = pFront.Id, UserRole = role);
		insert usuarioFront;

		Account acc = Build.anAccountCuentapersonal().build();
		insert acc; 
		
		Case aCase = new Case();
		aCase.AccountId = acc.Id;
		aCase.OwnerId = usuarioFront.Id;
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		aCase.Status = 'CA-----A';
		insert aCase;

		Prestacion__c prest = new Prestacion__c();
		prest.Estado__c = 'C1-----A';
		prest.Ap__c = aCase.Id;
		insert prest;

		Database.DeleteResult result;
		System.runAs(usuarioFront) {
			Test.startTest();
			result = Database.delete(prest, false);
			Test.stopTest();
		}

		String errorMsg = 'El caso debe estar en estado "Generada" para poder eliminar prestaciones';
		System.assert(!result.isSuccess());
		System.assertEquals(errorMsg, result.getErrors()[0].getMessage());
	}

	@isTest
	private static void whenCaseStatusIsGenerada_deletePrestacion() {
		String uniqueUserName = 'standarduserprestaciontrigger' + DateTime.now().getTime() + '@testorg.com';
		Profile pFront = [SELECT Id FROM Profile WHERE Name='Front'];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
		User usuarioFront = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'Front', ProfileId = pFront.Id, UserRole = role);
		insert usuarioFront;

		Account acc = Build.anAccountCuentapersonal().build();
		insert acc; 
		
		Case aCase = new Case();
		aCase.AccountId = acc.Id;
		aCase.OwnerId = usuarioFront.Id;
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		aCase.Status = 'CA-----G';
		insert aCase;

		Prestacion__c prest = new Prestacion__c();
		prest.Estado__c = 'C1-----A';
		prest.Ap__c = aCase.Id;
		insert prest;

		Database.DeleteResult result;
		System.runAs(usuarioFront) {
			Test.startTest();
			result = Database.delete(prest, false);
			Test.stopTest();
		}

		System.assert(result.isSuccess());
	}

	@isTest
	private static void whenAllPrestacionesAreAuthorizedEmitirOrdenAtCase() {
		Account asociado = Build.anAccountCuentapersonal().withEmail('test@test.com').build();
		insert asociado;

		Case caso = new Case();
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		caso.Status = 'CA-----A	';
		caso.Nro_AP__c = '1014009998';
		caso.AccountId = asociado.Id;
		caso.Correo_asociado__c = 'test@test.com';
		insert caso;

		Prestacion__c prest = new Prestacion__c();
		prest.Estado__c = 'C1-----A';
		prest.Ap__c = caso.Id;
		insert prest;

		Test.setMock(HttpCalloutMock.class,getResponseFound);
		Test.startTest();
		prest.Estado__c = 'C1EA--AA';
		update prest;
		Test.stopTest();

		caso = [SELECT Status FROM Case WHERE Id = :caso.Id];
		System.assertEquals('CA-----E', caso.Status);
		
		ContentDocumentLink[] cdl = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :caso.Id];
		System.assert(!cdl.isEmpty());
	}

	@isTest
	private static void whenAPrestacionIsInsertAuthorized_AthorizeTheCase() {
		Case caso = new Case();
		caso.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		caso.Status = 'CA-----A	';
		caso.Nro_AP__c = '1014009998';
		insert caso;

		Prestacion__c prest = new Prestacion__c();
		prest.Estado__c = 'C1----AS';
		prest.Ap__c = caso.Id;

		Test.setMock(HttpCalloutMock.class,getResponseFound);
		Test.startTest();
		insert prest;
		Test.stopTest();

		caso = [SELECT Status FROM Case WHERE Id = :caso.Id];
		ContentDocumentLink[] cdl = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :caso.Id];

		System.assertEquals('CA-----E', caso.Status);
		System.assert(!cdl.isEmpty());

	}

	@isTest
	private static void whenAllPrestacionesAreAuthorizedInACaseRelatedToEMIAuthorizeTheCase() {
		Evento_medico__c emi = new Evento_medico__c();
		emi.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_internacion').Id;
		emi.Tipo__c = 'CLINICO';
		insert emi;

		Case aCase = new Case();
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		aCase.Nro_AP__c = '12345678';
		aCase.Evento_Medico__c = emi.Id;
		//aCase.Type= 'COVID';
		insert aCase;

		Prestacion__c prest = new Prestacion__c();
		prest.Estado__c = 'C1-----A';
		prest.Ap__c = aCase.Id;
		insert prest;

		Prestacion__c prest2 = new Prestacion__c();
		prest2.Estado__c = 'C1----AS';
		prest2.Ap__c = aCase.Id;
		insert prest2;

		Test.startTest();
		prest.Estado__c = 'C1----AS';
		update prest;
		Test.stopTest();

		aCase = [SELECT Status FROM Case WHERE Id =: aCase.Id];

		System.assertEquals('Autorizada', aCase.Status);
	}

	@isTest
	private static void whenAPrestacionChangedToAuthorizedAndCaseIsAPAndEMTypeCovid_EmitirOrdenAndSendEmail() {
		Integer futureCalls;

		Account prestador = Build.anAccountEfector().build();
		prestador.Es_Prestador__c = true;
		prestador.Correo_electronico__c = 'test@test.com';
		insert prestador;

		Evento_medico__c emCovid = new Evento_medico__c();
		emCovid.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
		emCovid.Tipo__c = 'COVID';
		insert emCovid;

		Case aCase = new Case();
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		aCase.Nro_AP__c = '12345678';
		aCase.Prestador__c = prestador.Id;
		aCase.Evento_Medico__c = emCovid.Id;
		//aCase.Type= 'COVID';
		insert aCase;

		Prestacion__c prest = new Prestacion__c();
		prest.Estado__c = 'C1----AS';
		prest.Ap__c = aCase.Id;

		Test.setMock(HttpCalloutMock.class, getResponseEmitirOrdenFound);
		Test.startTest();
		insert prest;
		futureCalls = Limits.getFutureCalls();
		Test.stopTest();

		aCase = [SELECT Status FROM Case WHERE Id =: aCase.Id];

		System.assertEquals('CA-----E', aCase.Status);
		System.assertEquals(1, futureCalls);

	}

	@isTest
	private static void whenAPrestacionISAutorizadaAndCaseIsTypeOxigenoterapiaShouldntGiveN1() {
		Integer futureCalls;

		Account prestador = Build.anAccountEfector().build();
		prestador.Es_Prestador__c = true;
		prestador.Correo_electronico__c = 'test@test.com';
		insert prestador;

		Evento_medico__c emCovid = new Evento_medico__c();
		emCovid.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
		emCovid.Tipo__c = 'COVID';
		insert emCovid;

		Case aCase = new Case();
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		aCase.Nro_AP__c = '12345678';
		aCase.Prestador__c = prestador.Id;
		aCase.Evento_Medico__c = emCovid.Id;
		aCase.Type= 'Oxigenoterapia';
		insert aCase;

		Prestacion__c prest = new Prestacion__c();
		prest.Estado__c = 'C1----AS';
		prest.Ap__c = aCase.Id;

		Test.setMock(HttpCalloutMock.class, getResponseEmitirOrdenFound);
		Test.startTest();
		insert prest;
		
		Test.stopTest();

		aCase = [SELECT Status,Nivel_de_derivacion__c FROM Case WHERE Id =: aCase.Id];

		System.assertNotEquals('Nivel 3',aCase.Nivel_de_derivacion__c);
		System.assertEquals('CA-----E', aCase.Status);
	}

	@isTest
	private static void whenAPrestacionISAutorizadaAndCaseIsNotTypeOxigenoterapiaShouldGiveN1() {
		Integer futureCalls;

		Account prestador = Build.anAccountEfector().build();
		prestador.Es_Prestador__c = true;
		prestador.Correo_electronico__c = 'test@test.com';
		insert prestador;

		Evento_medico__c emCovid = new Evento_medico__c();
		emCovid.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
		emCovid.Tipo__c = 'COVID';
		insert emCovid;

		Case aCase = new Case();
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		aCase.Nro_AP__c = '12345678';
		aCase.Prestador__c = prestador.Id;
		aCase.Evento_Medico__c = emCovid.Id;
		aCase.Type= 'Diabetes';
		insert aCase;

		Prestacion__c prest = new Prestacion__c();
		prest.Estado__c = 'C1----AS';
		prest.Ap__c = aCase.Id;

		Test.setMock(HttpCalloutMock.class, getResponseEmitirOrdenFound);
		Test.startTest();
		insert prest;
		
		Test.stopTest();

		aCase = [SELECT Status,Nivel_de_derivacion__c FROM Case WHERE Id =: aCase.Id];

		System.assertEquals('Nivel 1',aCase.Nivel_de_derivacion__c);
		System.assertEquals('CA-----E', aCase.Status);
	}


	@isTest
	public static void ifACaseIsCreatedWithPrestacionMaterialAndWithoutSubtipeMaterialShouldReturnError(){

		Nomenclador_de_Prestacion__c prest = new Nomenclador_de_Prestacion__c(Codigo__c = '700000',Estado__c = 'A');
		insert prest;

		Case caso = new Case();
		caso.RecordtypeId = XappiaHelper.getRecordType('Case','Solicitud_de_baja').Id;
		caso.Type = 'Estado de Cuenta';
		caso.Sub_tipo__c = 'Cuota';
		insert caso;

		
		Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042498',Prestacion__c = prest.Id,Ap__c = caso.Id);

		Test.startTest();
		System.debug(pres);
		Database.SaveResult result = Database.insert(pres,false);		
		Test.stopTest();
		System.debug(result);

		System.assert(!result.isSuccess());
		for(Database.Error err : result.getErrors()){
			System.debug(err.getMessage());
			System.assert(err.getMessage().contains('Al cargar un código de nomenclador de tipo Material, debe marcar el Subtipo como Material'));
		}
	}

	@isTest
	public static void ifACaseIsCreatedWithPrestacionMaterialAndWithSubtipeMaterialShouldnotReturnError(){

	
		Nomenclador_de_Prestacion__c prest = new Nomenclador_de_Prestacion__c(Codigo__c = '700000',Estado__c = 'A');
		insert prest;

		
		Case caso = new Case();
		caso.RecordtypeId = XappiaHelper.getRecordType('Case','Autorizacion_previa').Id;
		caso.Prestacion__c = prest.Id;
		caso.Type = 'Prestacion';
		caso.Sub_tipo__c = 'Material';
		insert caso;

		
		Prestacion__c pres = new Prestacion__c(Prestacion_CA__c = '74042498',Prestacion__c = prest.Id,Ap__c = caso.Id);

		Test.startTest();
		Database.SaveResult result = Database.insert(pres,false);		
		Test.stopTest();

		System.debug(result);
		System.assert(result.isSuccess());
	}
}