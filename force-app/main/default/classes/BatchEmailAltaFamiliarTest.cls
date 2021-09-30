@isTest 
private class BatchEmailAltaFamiliarTest {

	@isTest
	private static void shouldSendEmailsAfter30DaysOfCreationHavePassedWithoutFillingInformation() {

		Case caso = new Case();
		caso.Informacion_completa__c = false;
		caso.Bebe_nacido_en_sistema__c = true;
		caso.Correo_asociado__c = 'standarduser@testorg.com';
		caso.Correo_electronico_responsable__c = 'standarduser@testorg.com';
		Date myDate = Date.today().addDays(-30);
		Time myTime = Time.newInstance(0, 0, 0, 0);
		
		insert caso;
		Test.setCreatedDate(caso.Id, DateTime.newInstance(myDate, myTime) );
		BatchEmailAltaFamiliar bc = new BatchEmailAltaFamiliar();
		Test.startTest();
		Database.executeBatch(bc);
		Test.stopTest();
		System.assertEquals(2, BatchEmailAltaFamiliar.emailLimits);
	}

	@isTest
	private static void shouldSendEmailsAfter15DaysOfCreationHavePassedWithoutFillingInformation() {

		Case caso = new Case();
		caso.Informacion_completa__c = false;
		caso.Bebe_nacido_en_sistema__c = true;
		caso.Correo_asociado__c = 'standarduser@testorg.com';
		caso.Correo_electronico_responsable__c = 'standarduser@testorg.com';
		Date myDate = Date.today().addDays(-15);
		Time myTime = Time.newInstance(0, 0, 0, 0);
		
		insert caso;
		Test.setCreatedDate(caso.Id, DateTime.newInstance(myDate, myTime) );
		BatchEmailAltaFamiliar bc = new BatchEmailAltaFamiliar();
		Test.startTest();
		Database.executeBatch(bc);
		Test.stopTest();
		System.assertEquals(1, BatchEmailAltaFamiliar.emailLimits);
	}

	@isTest
	private static void shouldAllowSending10Emails() {
		List<Case> casos = new List<Case>();
		for(Integer i=0; i< 5; i++){
			Case caso = new Case();
			caso.Informacion_completa__c = false;
			caso.Bebe_nacido_en_sistema__c = true;
			caso.Correo_asociado__c = 'testAsociado@test.com';
			caso.Correo_electronico_responsable__c = 'testResponsable@test.com';
			casos.add(caso);
		}
		Date myDate = Date.today().addDays(-30);
		Time myTime = Time.newInstance(0, 0, 0, 0);
		
		insert casos;
		for(Case caso : casos){
			Test.setCreatedDate(caso.Id, DateTime.newInstance(myDate, myTime) );
		}
		Test.startTest();
		Database.executeBatch(new BatchEmailAltaFamiliar());
		Test.stopTest();
		System.assertEquals(10, BatchEmailAltaFamiliar.emailLimits);
	}
}