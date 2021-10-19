global class ScheduleBatchAsociado implements Schedulable {
	
	global void execute(SchedulableContext sc) {
		MasterConfigs__c config = MasterConfigs__c.getOrgDefaults();
		Datetime lastUpdate = System.now();
		if (config != null && config.Asociados__c != null) {
			lastUpdate = config.Asociados__c;
		}
		//-----------------------------------------------------------------------
		//lastUpdate = Datetime.newInstance(2019, 12, 17, 12, 30, 2);
		//-----------------------------------------------------------------------
		Database.executeBatch(new MasterBatch(new AccountProcessor(100, lastUpdate)));
	}

}