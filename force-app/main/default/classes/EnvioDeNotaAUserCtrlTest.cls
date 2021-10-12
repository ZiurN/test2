@isTest 
private class EnvioDeNotaAUserCtrlTest {
	static User u;
	static{
		String uniqueUserName = 'organizador' + DateTime.now().getTime() + '@testorg.com';
		Profile p = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' OR Name = 'System Administrator' LIMIT 1];
		UserRole role = [SELECT Id,Name FROM UserRole WHERE Name = 'Administrador'];
		u = new User(Alias = 'standt', Email='standarduser@testorg.com',
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
				LocaleSidKey='en_US', ProfileId = p.Id,
				TimeZoneSidKey='America/Los_Angeles',
				UserName=uniqueUserName,UserRole = role);
		insert u;
	}
	@isTest
	private static void sendEmailToOwnerAndDelegacion() {
		Account delegacion = Build.anAccountDelegacion().withEmail('delegacion@testorg.com').build();
		insert delegacion;
		u.Codigo_delegacion__c = delegacion.Id;
		update u;
		Case ap = new Case(OwnerId = u.Id, AccountId = delegacion.Id);
		insert ap;
		Tipo_nota_de_auditoria__c tipoNota = new Tipo_nota_de_auditoria__c(Codigo_tipoNA__c = 'NOT_COB_PROT');
		insert tipoNota;
		Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(APr_Id__c = ap.Id,Nota__c = 'Cuerpo del mail',Tipo_nota_de_Auditoria__c = tipoNota.Id);
		insert nota;
		Orden_de_Compra__c orden = new Orden_de_Compra__c(Caso__c = ap.Id);
		insert orden;
		Test.startTest();
		EnvioDeNotaAUserCtrl.Response resp = EnvioDeNotaAUserCtrl.envioNota(orden.Caso__c);
		Test.stopTest();
		Orden_de_Compra__c ordenToAssert = [SELECT Id, Estado_OC__c
											FROM Orden_de_Compra__c
											WHERE Id = :orden.Id];
		System.assertEquals(false, resp.hasError);
		System.assertEquals(System.Label.Email_EnvioCorrecto, resp.message);
		System.assertEquals('Diferencia Socio', ordenToAssert.Estado_OC__c);
	}
	@isTest
	private static void sendEmailFailsDueToOrdenWithoutCase() {
		Orden_de_Compra__c orden = new Orden_de_Compra__c();
		insert orden;
		Test.startTest();
		EnvioDeNotaAUserCtrl.Response resp = EnvioDeNotaAUserCtrl.envioNota(orden.Caso__c);
		Test.stopTest();
		System.assertEquals(true, resp.hasError);
		System.assertEquals('Debe tener un Caso asociado.', resp.message);
	}
		@isTest
	private static void sendEmailFailsDueToInexistingNota() {
		Account delegacion = Build.anAccountDelegacion().withEmail('delegacion@testorg.com').build();
		insert delegacion;
		u.Codigo_delegacion__c = delegacion.Id;
		update u;
		Case ap = new Case(OwnerId = u.Id, AccountId = delegacion.Id);
		insert ap;
		Tipo_nota_de_auditoria__c tipoNota = new Tipo_nota_de_auditoria__c(Codigo_tipoNA__c = 'Algo');
		insert tipoNota;
		Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(APr_Id__c = ap.Id,Nota__c = 'Cuerpo del mail',Tipo_nota_de_Auditoria__c = tipoNota.Id);
		insert nota;
		Orden_de_Compra__c orden = new Orden_de_Compra__c(Caso__c = ap.Id);
		insert orden;
		Test.startTest();
		EnvioDeNotaAUserCtrl.Response resp = EnvioDeNotaAUserCtrl.envioNota(ap.Id);
		Test.stopTest();
		System.assertEquals(true, resp.hasError);
		System.assertEquals('Nota de auditoria COB_PROT inexistente', resp.message);
	}
	@isTest
	private static void sendEmailToOrdenWithAnEM() {
		Evento_medico__c em = new Evento_medico__c();
		insert em;
		Case aCase = new Case();
		aCase.Evento_medico__c = em.Id;
		insert aCase;
		Tipo_nota_de_auditoria__c tipoNota = new Tipo_nota_de_auditoria__c();
		tipoNota.Name = 'AVISO COBERTURA DE MATERIAL';
		tipoNota.Codigo_tipoNA__c = 'NOT_COB_PROT';
		insert tipoNota;
		Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c();
		nota.Nota__c = 'Test';
		nota.Tipo_nota_de_auditoria__c = tipoNota.Id;
		nota.Fecha__c = Date.newInstance(2021, 10, 02);
		nota.Evento_Medico_Id__c = em.Id;
		insert nota;
		Orden_de_Compra__c orden = new Orden_de_Compra__c();
		orden.Caso__c = aCase.Id;
		insert orden;
		Test.startTest();
		EnvioDeNotaAUserCtrl.Response resp = EnvioDeNotaAUserCtrl.envioNota(orden.Caso__c);
		Test.stopTest();
		System.assertEquals(false, resp.hasError);
	}
}