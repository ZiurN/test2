@isTest 
private class ConvertLeadControllerTest {

	@isTest
	private static void leadConversionTest() {
		Lead leadToConvert = new Lead(LastName='Test',Canal_de_contacto_Asesor_con_cliente__c = 'Telefono',Phone = '1144445555');
		insert leadToConvert;
		Test.startTest();
		ConvertLeadController.convertLead(leadToConvert.Id,'Contactado - Interesado');
		Test.stopTest();

		System.assertEquals(1,[SELECT COUNT() FROM Account]);
		System.assertEquals(1,[SELECT COUNT() FROM Opportunity]);
	}

	@isTest
	private static void leadCorpConversionTest() {
		Lead leadToConvert = new Lead(LastName='Test',Canal_de_contacto_Asesor_con_cliente__c = 'Telefono',Phone = '1144445555');
		leadToConvert.RecordTypeId = XappiaHelper.getRecordType('Lead', 'Corporativo').Id;
		leadToConvert.LeadSource = '1';
		leadToConvert.FirstName = 'Test';
		leadToConvert.LastName = '1';
		leadToConvert.Company = 'Test SA';
		leadToConvert.Phone = '1234567890';
		leadToConvert.Email = 'test@testorg.com';
		leadToConvert.Title = 'Gerente';
		insert leadToConvert;
		Test.startTest();
		ConvertLeadController.convertLead(leadToConvert.Id,'Contactado - Interesado');
		Test.stopTest();

		System.assertEquals(1,[SELECT COUNT() FROM Account]);
		System.assertEquals(1,[SELECT COUNT() FROM Opportunity]);
	}
}