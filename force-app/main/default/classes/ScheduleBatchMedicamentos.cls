global class ScheduleBatchMedicamentos implements Schedulable {
	
	global void execute(SchedulableContext sc) {
		MasterConfigs__c config = MasterConfigs__c.getOrgDefaults();
		Datetime lastUpdate = System.now();
		if (config != null && config.Medicamentos__c != null) {
			lastUpdate = config.Medicamentos__c;
		}
		//-----------------------------------------------------------------------
		//lastUpdate = Datetime.newInstance(2019, 01, 01, 12, 30, 2);
		//-----------------------------------------------------------------------
		Database.executeBatch(new MasterBatch(new MedicamentosProcessor(100, lastUpdate)));
	}
}