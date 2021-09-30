@IsTest
public with sharing class ScheduleBatchEmpresaTest {

    static testMethod void theBatchEmpresaCanBeScheduled() {

        String CRON_EXP = '0 0 6 * * ? *';

        Date executionDate = System.today();
		Time hour = Time.newInstance(6, 0, 0, 0);

		Datetime nextExecution = Datetime.newInstance(
			executionDate, hour 
		);
		
		if (System.now() > nextExecution) {
			nextExecution = nextExecution.addDays(1);
		}

        Test.startTest();
        String jobId = System.schedule(
                'EmpresastestScheduledApex',
                CRON_EXP,
                new ScheduleBatchEmpresa()
        );

        CronTrigger ct = [
                SELECT Id, CronExpression, TimesTriggered, NextFireTime
                FROM CronTrigger
                WHERE id = :jobId
        ];

        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);

        // Check next execution
        System.assertEquals(
                nextExecution.format('yyyy-MM-dd HH:mm:ss'),
                String.valueOf(ct.NextFireTime)
        );
        Test.stopTest();
    }

    static {
        insert Build.aMasterConfigs().build();
    }
}