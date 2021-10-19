@isTest 
private class CaseReintegroEnviarASSBtnCtrlTest {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static Prestacion_de_reintegro__c prest;
	static Case reintegro;
	static Account efector;
	static Account agencia;
	static Account asociado;
	static Diagnostico__c diagnostico;
	static Lote__c lote;
	static String medicamentoRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Medicamento').Id;
	static String odontologicaRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Odontologica').Id;
	static String prestacionalRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Prestacional').Id;
	static User userFront;

	static {
		
		String uniqueUserName = 'standarduserRevertirCase' + DateTime.now().getTime() + '@testorg.com';
		Profile pFront = [SELECT Id FROM Profile WHERE Name='Front'];
		UserRole role = [SELECT Id, Name, DeveloperName FROM UserRole WHERE DeveloperName = 'Filial_Casa_central'];
		userFront = new User(Alias = 'standt', Email='standarduser@testorg.com', Codigo_delegacion__c = '650886',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
				LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
				UserName=uniqueUserName + 'FrontEnviarReintegro', ProfileId = pFront.Id, UserRoleId = role.Id);
		System.runAs( new User( Id = UserInfo.getUserId() ) ) {
			insert userFront;
		}

		efector = Build.anAccountEfector().build();
		efector.Codigo_de_efector__c = '758415';
		efector.Es_Profesional__c = true;	
		efector.Estado__c = 'A';
		insert efector;

		agencia = Build.anAccountDelegacion().withCodigoDeDelegacion('650098').build();
		agencia.Type = 'Agencia';
		insert agencia;

		asociado = Build.anAccountCuentapersonal().build();
		asociado.Codigo_de_Afiliado__c = '69794/14';
		insert asociado;

		diagnostico = new Diagnostico__c();
		diagnostico.Codigo_del_Diagnostico__c = '999';
		insert diagnostico;

		lote = new Lote__c();
		lote.Id_lote_SS__c = '5392';
		insert lote;

		reintegro = new Case();
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		reintegro.Efector_realizador__c = efector.Id;
		reintegro.Prescriptor__c = efector.Id;
		reintegro.AccountId = asociado.Id;
		reintegro.Fecha__c = Date.today();
		reintegro.Fecha_prescripcion__c = Date.today().addDays(-25);
		reintegro.Diagnostico__c = diagnostico.Id;
		reintegro.Observaciones__c = 'observaciones';
		reintegro.Importe_presupuesto__c = 2500;
		reintegro.Tipo_de_Comprobante__c = 'FACA';
		reintegro.Razon_social__c = 'Fulano SA.';
		reintegro.Delegacion__c = agencia.Id;
		reintegro.CUIT__c = '20231231230';
		reintegro.Lote__c = lote.Id;
		insert reintegro;

		prest = new Prestacion_de_reintegro__c();
		prest.Estado__c = 'C1-----G';
		prest.Id_Externo__c = '74043156';
		prest.Caso__c = reintegro.Id;
		prest.Observaciones__c = 'obs';
		prest.Fecha_de_realizacion__c = Date.today();
		prest.Caras__c = 'Caras';
		prest.Pieza_dental__c = 'Pieza'; 
		prest.Importe_a_pagar__c = 2000;
		prest.Importe_total__c = 2000;
		prest.Cantidad__c = 1;
		insert prest;

		ContentVersion contentVersion = new ContentVersion(
			Title = 'testCaseReintegroEnviar',
			PathOnClient = 'testCaseReintegroEnviar.pdf',
			VersionData = Blob.valueOf('Test Content'),
			IsMajorVersion = true
		);
		insert contentVersion;    
		
		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
		ContentDocumentLink cdl = New ContentDocumentLink();
		cdl.LinkedEntityId = reintegro.Id;
		cdl.ContentDocumentId = documents[0].Id;
		cdl.shareType = 'V';
		insert cdl;
		
		WSCaseReintegroEnviarASSMock mock = new WSCaseReintegroEnviarASSMock();
		
		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(mock.getFound(prest.Id))
			.addForAddress(WSCaseReintegroEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSCaseReintegroEnviarASSMock.getError())
			.addForAddress(WSCaseReintegroEnviarASS.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros');
	}

	@isTest
	private static void whenTheResponseIsCorrect_updateTheReintegroPrestacionesAndAlerts() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		reintegro.Type = 'Prestacion';
		update reintegro;

		Nomenclador_de_Prestacion__c nom = new Nomenclador_de_Prestacion__c();
		nom.Codigo__c = '2222';
		nom.Estado__c = 'A';
		insert nom;

		prest.RecordTypeId = prestacionalRTId;
		prest.Prestacional__c = nom.Id;
		update prest;

		Test.startTest();
		CaseReintegroEnviarASSBtnCtrl.Response resp = CaseReintegroEnviarASSBtnCtrl.sendReintegroToSS(reintegro.Id);
		Test.stopTest();

		Case reintegroToAssert = [
			SELECT Codigo_reintegro_SS__c, Status, Existente_SS__c, Celula__c, Tiempo_SLA__c
			FROM Case
			WHERE Id =: reintegro.Id
		];
		
		System.assertEquals(false, resp.hasError);		
		System.assertEquals('553276', reintegroToAssert.Codigo_reintegro_SS__c);
		System.assertEquals('CA-----A', reintegroToAssert.Status);
		System.assertEquals(true, reintegroToAssert.Existente_SS__c);
		System.assertEquals('Celula 8', reintegroToAssert.Celula__c);
		System.assertEquals('240', reintegroToAssert.Tiempo_SLA__c);

		List<Prestacion_de_reintegro__c> prestacionesToAssert = [
			SELECT Estado__c, (SELECT Id FROM Alertas__r)
			FROM Prestacion_de_reintegro__c WHERE Caso__c =: reintegro.Id
		];

		System.assertEquals('C1-----A', prestacionesToAssert[0].Estado__c);
		
		//System.assertEquals(4, prestacionesToAssert[0].Alertas__r.size());

	}

	@isTest
	private static void whenTheResponseIsInvalid_ShowTheErrorMsgFromWs() {
		Test.setMock(HttpCalloutMock.class, getErrorResponse);

		Test.startTest();
		CaseReintegroEnviarASSBtnCtrl.Response resp = CaseReintegroEnviarASSBtnCtrl.sendReintegroToSS(reintegro.Id);
		Test.stopTest();

		String msg = 'El campo lote es obligatorio.\n' + 'El campo agencia codigo es obligatorio.\n';

		System.assertEquals(true, resp.hasError);
		System.assertEquals(msg, resp.message);

	}

	@isTest
	private static void getCodigoFromMedicamento() {
		System.debug(medicamentoRTId);
		System.debug(odontologicaRTId);
		System.debug(prestacionalRTId);

		Medicamento__c medicamento = new Medicamento__c();
		medicamento.Codigo_medicamento__c = '12345';
		medicamento.Estado_Presentacion__c = 'A';
		insert medicamento;

		prest.RecordTypeId = medicamentoRTId;
		prest.Medicamento__c = medicamento.Id;
		update prest;

		Test.startTest();
		Prestacion_de_reintegro__c prestQuery = [SELECT Medicamento__r.Codigo_medicamento__c, RecordTypeId 
			FROM Prestacion_de_reintegro__c WHERE Id =: prest.Id];
		String codigo = CaseReintegroEnviarASSBtnCtrl.getCodigoPrestacion(prestQuery);
		Test.stopTest();

		System.assertEquals('12345', codigo);
	}

	@isTest
	private static void getCodigoFromNomencladorWhenRTIsOdontologica() {		
		Nomenclador_de_Prestacion__c nom = new Nomenclador_de_Prestacion__c();
		nom.Codigo__c = '2222';
		nom.Descripcion_tipo_nomenclador__c = 'ODONTOLOGICAS';
		nom.Estado__c = 'A';
		insert nom;

		prest.RecordTypeId = odontologicaRTId;
		prest.Prestacion_odonto__c = nom.Id;
		update prest;


		Test.startTest();
		Prestacion_de_reintegro__c prestQuery = [SELECT Prestacion_odonto__r.Codigo__c, RecordTypeId 
			FROM Prestacion_de_reintegro__c WHERE Id =: prest.Id];
		String codigo = CaseReintegroEnviarASSBtnCtrl.getCodigoPrestacion(prestQuery);
		Test.stopTest();

		System.assertEquals('2222', codigo);
	}

	@isTest
    private static void whenAnEMHasNotAttachments_ShowErrorMessage() {
		Case reintegro = new Case();
		reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
		insert reintegro;

		Test.startTest();
		CaseReintegroEnviarASSBtnCtrl.Response resp = CaseReintegroEnviarASSBtnCtrl.sendReintegroToSS(reintegro.Id);
		Test.stopTest();

		System.assertEquals('No se puede enviar porque no tiene archivos adjuntos', resp.message);
	}

	// SE ELIMINO LA VALIDACION
	//@isTest
	//private static void whenAFrontUserNotBelongsToDelegacion_showTheErrorMsg() {
		//Account delegacion = Build.anAccountDelegacion().withCodigoDeDelegacion('123456').build();
		//insert delegacion;

		//reintegro.Delegacion__c = delegacion.Id;
		//reintegro.OwnerId = userFront.Id;
		//update reintegro;

		//CaseReintegroEnviarASSBtnCtrl.Response resp;
		//System.runAs(userFront) {	
			//Test.startTest();
			//resp = CaseReintegroEnviarASSBtnCtrl.sendReintegroToSS(reintegro.Id);
			//Test.stopTest();
		//}

		//System.assertEquals('El usuario puede modificar casos de su delegación solamente', resp.message);

	//}

}