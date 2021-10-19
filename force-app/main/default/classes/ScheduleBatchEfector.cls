global class  ScheduleBatchEfector implements Schedulable{
    global void execute(SchedulableContext sc) {

        MasterConfigs__c config = MasterConfigs__c.getOrgDefaults();
        Datetime lastUpdate = System.now();
        if (config != null && config.Efectores__c != null) {
            lastUpdate = config.Efectores__c;
        }
		//-----------------------------------------------------------------------
		//lastUpdate = Datetime.newInstance(2019, 12, 09, 12, 30, 2);
		//-----------------------------------------------------------------------
        Database.executeBatch(new MasterBatch(new AccountEfectorProcessor(100, lastUpdate)));
    }
}