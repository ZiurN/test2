global class ScheduleBatchClausulasTemp implements Schedulable {
	
	global void execute(SchedulableContext sc) {
		MasterConfigs__c config = MasterConfigs__c.getOrgDefaults();
		Datetime lastUpdate = System.now();
		if (config != null && config.Clausulas_Temporales__c != null) {
			lastUpdate = config.Clausulas_Temporales__c;
		}

		Database.executeBatch(new MasterBatch(new ClausulasTempProcessor(100, lastUpdate)));
	}

}