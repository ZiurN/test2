global class ScheduleBatchObraSocial implements Schedulable{

    global void execute(SchedulableContext sc) {

        MasterConfigs__c config = MasterConfigs__c.getOrgDefaults();
        Datetime lastUpdate = System.now();
        if (config != null && config.Obras_Sociales__C != null) {
            lastUpdate = config.Obras_Sociales__C;
        }
        //-----------------------------------------------------------------------
        //lastUpdate = Datetime.newInstance(2020, 1, 20, 12, 30, 2);
        //-----------------------------------------------------------------------
        Database.executeBatch(new MasterBatch(new ObraSocialProcessor(100, lastUpdate)));
    }
}