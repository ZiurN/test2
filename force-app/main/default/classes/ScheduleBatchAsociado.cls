public without sharing class ScheduleBatchAsociado implements Schedulable {
	public void execute(SchedulableContext sc) {
		MasterConfigs__c config = MasterConfigs__c.getOrgDefaults();
		Datetime lastUpdate = System.now();
		if (config != null && config.Asociados__c != null) {
			lastUpdate = config.Asociados__c;
		}
		Database.executeBatch(new MasterBatch(new AccountProcessor(100, lastUpdate)));
	}
}