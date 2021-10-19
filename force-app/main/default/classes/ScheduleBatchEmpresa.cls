global class ScheduleBatchEmpresa implements Schedulable{

    global void execute(SchedulableContext sc) {

        MasterConfigs__c config = MasterConfigs__c.getOrgDefaults();
        Datetime lastUpdate = System.now();
        if (config != null && config.Empresas__c != null) {
            lastUpdate = config.Empresas__c;
        }
        //-----------------------------------------------------------------------
		//lastUpdate = Datetime.newInstance(2020, 5, 13, 12, 30, 2);
		//-----------------------------------------------------------------------
        Database.executeBatch(new MasterBatch(new AccountEmpresaProcessor(100, lastUpdate)));
    }
}