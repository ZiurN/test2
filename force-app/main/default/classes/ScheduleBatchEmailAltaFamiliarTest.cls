@isTest 
private class ScheduleBatchEmailAltaFamiliarTest {

	@isTest
	private static void testRunSchedule() {

		String CRON_EXP = '0 0 1 1/1 * ? *';
		
		Test.startTest();
		System.debug('start test');
		String jobId = System.schedule('test', CRON_EXP, new ScheduleBatchEmailAltaFamiliar());
		Test.stopTest();
		
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
	}
}