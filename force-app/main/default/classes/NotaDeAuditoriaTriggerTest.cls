@isTest 
private class NotaDeAuditoriaTriggerTest {
	static XHttpCalloutMock getResponseFound;
	static User userDoctor;
	static User userDoctor2;

	static {
		String mockResponseBody = '{' +
									  '"error": false,' +
									  '"data": {"id_nota": "562866"},' +
									  '"httpCode": 200,' +
									  '"message": "Se actualizó satisfactoriamente la nota de auditor.",' +
									  '"meta": {' +
										'"allowed_includes": [],' +
										'"default_includes": []' +
									  '}' +
									'}';
		getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatusCode(200)
			.withBody(mockResponseBody)
			.addForAddress(WSNotaDeAuditoriaEnviarASS.SERVICE_CONFIG.URL__c  + '/v1/salud/notas-auditor');

		String uniqueUserName = 'standarduserNotaTrigger' + DateTime.now().getTime() + '@testorg.com';
		Profile perfilDoctor = [SELECT Id FROM Profile WHERE Name='Auditor Medico'];
		userDoctor = new User(Alias = 'standt', Email='standarduser@testorg.com',
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
			LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
			UserName=uniqueUserName + 'DoctorNotaTrigger', ProfileId = perfilDoctor.Id
		);
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert userDoctor;
		}

		userDoctor2 = new User(Alias = 'standt', Email='standarduser@testorg.com',
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
			LocaleSidKey='es_AR', TimeZoneSidKey='America/Argentina/Buenos_Aires',
			UserName=uniqueUserName + 'Doctor2NotaTrigger', ProfileId = perfilDoctor.Id
		);
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert userDoctor2;
		}
		
		List<Group> groupMesa = [SELECT Id, Name FROM Group WHERE DeveloperName = 'Mesa_de_ayuda'];
		List<GroupMember> groupMembersMesa = new List<GroupMember> {
			new GroupMember(groupId = groupMesa[0].Id, UserOrGroupId = userDoctor.Id),
			new GroupMember(groupId = groupMesa[0].Id, UserOrGroupId = userDoctor2.Id)
		};
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert groupMembersMesa;
		}
	}

	@isTest
	private static void whenANotaIsUpdatedSendToSS() {

		Case caso = new Case();
		insert caso;

		Tipo_nota_de_auditoria__c tnda = new Tipo_nota_de_auditoria__c(Codigo_tipoNA__c = 'UnCodigo');
		insert tnda;

		Nota_de_Auditoria__c nda = new Nota_de_Auditoria__c(Tipo_nota_de_auditoria__c = tnda.Id,
															APr_Id__c = caso.Id,
															Nota__c = 'Una nota');
		nda.RecordTypeId = XappiaHelper.getRecordType('Nota_de_Auditoria__c', 'Service').Id;
		nda.Nota__c = 'ej';
		insert nda;

		Test.setMock(HttpCalloutMock.class, getResponseFound);

		// Test
        Test.startTest();
        nda.Nota__c = 'ejUpdate';
		update nda;
        Test.stopTest();
	}

	@IsTest
	private static void whenADoctorCreateANotaAtCaseAndMedicoAsignadoIsEmpty_assignHimself() {
		Account acc = Build.anAccountCuentapersonal().build();
		insert acc;
		
		Case aCase = new Case();
		aCase.AccountId = acc.Id;
		aCase.Nivel_de_derivacion__c = 'Nivel 2';
		aCase.Contiene_alerta_AM__c = true;
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		insert aCase;

		Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c();
		nota.RecordTypeId = XappiaHelper.getRecordType('Nota_de_Auditoria__c', 'Service').Id;
		nota.APr_Id__c = aCase.Id;

		System.runAs(userDoctor) {
			Test.startTest();
			insert nota;
			Test.stopTest();
		}

		aCase = [SELECT Id, Medico_asignado__c FROM Case WHERE Id =: aCase.Id];

		System.assertEquals(userDoctor.Id, aCase.Medico_asignado__c);
	}


}