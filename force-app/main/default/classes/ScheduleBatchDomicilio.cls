global class ScheduleBatchDomicilio implements Schedulable {
	
	global void execute(SchedulableContext sc) {
		MasterConfigs__c config = MasterConfigs__c.getOrgDefaults();
		Datetime lastUpdate = System.now();

		if (config != null && config.Domicilios__c != null) {
			lastUpdate = config.Domicilios__c; 
		}

		Database.executeBatch(new MasterBatch(new DomicilioProcessor(150, lastUpdate)));
	}

}