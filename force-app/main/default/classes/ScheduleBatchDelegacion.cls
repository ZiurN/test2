global class ScheduleBatchDelegacion implements Schedulable {
	
	global void execute(SchedulableContext sc) {
		MasterConfigs__c config = MasterConfigs__c.getOrgDefaults();
		Datetime lastUpdate = System.now();
		if (config != null && config.Delegaciones__c != null) {
			lastUpdate = config.Delegaciones__c;
		}
		//-----------------------------------------------------------------------
//		lastUpdate = Datetime.newInstance(2020, 01, 20, 12, 30, 2);
		//-----------------------------------------------------------------------
		Database.executeBatch(new MasterBatch(new DelegacionProcessor(100, lastUpdate)));
	}

}