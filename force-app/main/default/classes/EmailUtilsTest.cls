@IsTest
public  class EmailUtilsTest {

    @IsTest static void  sendEmailErrorTest() {
        List<Account> accountsList = new List<Account>{new Account()};
		List<String> ids = new List<String>{'1'};
        Integer beforeInvocations = Limits.getEmailInvocations();

        Test.startTest();
        Database.UpsertResult[] results = Database.upsert(accountsList, false);
        EmailUtils.sendErrorMail(results, null, null, ids, 'Ejemplo');
        System.assertNotEquals(beforeInvocations, Limits.getEmailInvocations());
        Test.stopTest();
    }

    @IsTest static void  sendEmailAttTest() {
        Integer beforeInvocations = Limits.getEmailInvocations();
		Case caso = new Case();
		insert caso;
        Test.startTest();

        EmailUtils.sendMailWithAttachment(new List<String>{'test@gmail.com'},Blob.valueof('test'),'',caso.Id,'Sol_de_preinscripcion','');
        System.assertNotEquals(beforeInvocations, Limits.getEmailInvocations());
        Test.stopTest();
    }
	
   	@IsTest
    static void testsendMailWithTemplate(){
        Integer beforeInvocations = Limits.getEmailInvocations();
        Case caso = new Case();
        insert caso;
        Test.startTest();
        
        EmailUtils.sendMailWithTemplate(new List<String>{'test@gmail.com'},caso.Id,'Sol_de_preinscripcion');
        System.assertNotEquals(beforeInvocations, Limits.getEmailInvocations());
        Test.stopTest();
    }


	@IsTest
    static void testsendMailWithTemplateWithoutEmail(){
        Integer beforeInvocations = Limits.getEmailInvocations();
        Case caso = new Case();
        insert caso;
        Test.startTest();
        
        EmailUtils.sendMailWithTemplate(new List<String>(),caso.Id,'Sol_de_preinscripcion');
        System.assertEquals(beforeInvocations, Limits.getEmailInvocations());
        Test.stopTest();
    }
    
    @IsTest
    static void testsendSimpleEmail(){
        Integer beforeInvocations = Limits.getEmailInvocations();
        Case caso = new Case();
        insert caso;
        Test.startTest();
        
        EmailUtils.sendSimpleEmail(new List<String>{'test@gmail.com'},'Body','subject');
        System.assertNotEquals(beforeInvocations, Limits.getEmailInvocations());
        Test.stopTest();
    }
}