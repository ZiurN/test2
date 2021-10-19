global class CotizadorEliminarRegistrosBatch implements Database.Batchable<sObject>{

    public CotizadorEliminarRegistrosBatch(){

    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(
			'SELECT Id,CreatedDate,Cotizacion_de_prueba__c ' + 
			'FROM Cotizacion__c ' + 
			'WHERE CreatedDate < LAST_N_DAYS:7 AND Cotizacion_de_prueba__c = true'
		);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Cotizacion__c> cotizacionesAEliminar = new List<Cotizacion__c>();
		String[] ids = new List<String>();

        for(sObject s : scope){
            Cotizacion__c cot = (Cotizacion__c) s;
            //if(cot.Cotizacion_de_prueba__c
                    //&& (Date.valueOf(cot.CreatedDate)).daysBetween(Date.valueOf(Datetime.now())) >= 7
            //) {
                cotizacionesAEliminar.add(cot);
				ids.add(cot.Id);
            //}

        }

        Database.DeleteResult[] results = Database.delete(cotizacionesAEliminar,false);
		System.debug(results);
		//EmailUtils.sendErrorMail(null,null,results,ids,'Eliminacion de cotizaciones de prueba');

		Utils.insertBatchLogs(null,null,results,ids,'Eliminacion de cotizaciones de prueba');
    }

    global void finish(Database.BatchableContext BC) {
    }
}