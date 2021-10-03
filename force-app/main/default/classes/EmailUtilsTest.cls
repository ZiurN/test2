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

}