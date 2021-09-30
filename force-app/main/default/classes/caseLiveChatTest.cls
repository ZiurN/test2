@isTest 
private class caseLiveChatTest {
    @TestSetup
    private static void InitializeAllVars() {
        Account acc = new Account(LastName ='LastNameTest', Numero_de_documento__c = '123456789', Tipo_de_documento__c = 'DNI');
        insert acc;
    }
    @isTest
    private static void insertCaseWith_DNI_liveagent_ShouldAssignCaseAccountIdToACorrespondientAccount() {
        Account acc = [SELECT id, Numero_de_documento__c FROM Account WHERE LastName = 'LastNameTest' LIMIT 1];
        Case cs = new Case(
            subject = 'TestCase',
            origin = 'Web',
            DNI_liveagent__c = '123456789'
        );
        
        insert cs;
        System.assertEquals(1, [SELECT count() FROM Case], 'The case is not created');
        Case caso = [SELECT id, DNI_liveagent__c, AccountId FROM Case WHERE subject = 'TestCase' LIMIT 1];
        System.assertEquals(acc.Id, caso.AccountId, 'The accountId is not assigned correctly');
    }
    @isTest
    private static void insertCaseWithInvalid_DNI_liveagent_SholdNotAssignAccount () {
        Case cs = new Case(
            subject = 'TestCase',
            origin = 'Web',
            DNI_liveagent__c = '00000000'
        );
        
        insert cs;
        System.assertEquals(1, [SELECT count() FROM Case], 'The case is not created');
        Case caso = [SELECT id, DNI_liveagent__c, AccountId FROM Case WHERE subject = 'TestCase' LIMIT 1];
        System.assertEquals(null, caso.AccountId, 'The accountId is assigned incorrectly');
    }
}