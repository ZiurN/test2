@isTest
public class UtilsSendingMailWhenBatchFailsTest  {
	@IsTest static void  sendEmailTest() {
		List<Account> accountsList = new List<Account>{new Account()};
		Integer beforeInvocations = Limits.getEmailInvocations();

		Test.startTest();
		Database.UpsertResult[] results = Database.upsert(accountsList, false);
		UtilsSendingMailWhenBatchFails.sendMail(results, 'Ejemplo');
		System.assertNotEquals(beforeInvocations, Limits.getEmailInvocations());
		Test.stopTest();
	}
}