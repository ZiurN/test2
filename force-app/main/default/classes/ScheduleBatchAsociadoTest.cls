@IsTest
public class ScheduleBatchAsociadoTest  {
	@isTest
	public static void theBatchAsociadoCanBeScheduled() {
		final String CRON_EXP = '0 0 6 * * ? *';
		Date executionDate = System.today();
		Time hour = Time.newInstance(6, 0, 0, 0);
		Datetime nextExecution = Datetime.newInstance(executionDate, hour);
		if (System.now() > nextExecution) {
			nextExecution = nextExecution.addDays(1);
		}
		Test.startTest();
		String jobId = System.schedule('testScheduledApex', CRON_EXP, new ScheduleBatchAsociado());
		CronTrigger ct = [SELECT Id,
							CronExpression,
							TimesTriggered,
							NextFireTime
						FROM CronTrigger
						WHERE id = :jobId];
		System.assertEquals(CRON_EXP, ct.CronExpression, 'Las expresiones temporales no coinciden');
		System.assertEquals(0, ct.TimesTriggered, 'Todavia no se debe haber ejecutado nada');
		System.assertEquals(
			nextExecution.format('yyyy-MM-dd HH:mm:ss'),
			String.valueOf(ct.NextFireTime),
			'La hora de la próxima ejecución no coincide');
		Test.stopTest();
	}
	static {
		insert Build.aMasterConfigs().build();
	}
}