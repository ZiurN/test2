global class ScheduleBatchTelefono implements Schedulable {
	
	global void execute(SchedulableContext sc) {
		MasterConfigs__c config = MasterConfigs__c.getOrgDefaults();
		Datetime lastUpdate = System.now();

		if (config != null && config.Telefonos__c != null) {
			lastUpdate = config.Telefonos__c; 
		}

		Database.executeBatch(new MasterBatch(new TelefonoProcessor(150, lastUpdate)));
	}

}