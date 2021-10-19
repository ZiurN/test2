global class LeadTiempoSinAbrirBatch implements 
    Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        List<Group> cdcQueue = [
            SELECT Id
            FROM Group
            WHERE Type = 'Queue'
            AND Name = 'CDC'
        ];
        String query = 'SELECT Id,Tiempo_sin_abrir__c,CreatedDate,Fecha_modificacion_usuario__c,Owner.Name '+
            'FROM Lead ' + 
            'WHERE Status = \'Nuevo\'';
        if(!cdcQueue.isEmpty()){
            String idRegistro = cdcQueue.get(0).Id;
            system.debug(idRegistro);
            query += ' AND OwnerId != :idRegistro';
        }
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Lead> scope){
		
		System.debug('********scope'+scope);
		List<Lead> leadsToUpdate = new List<Lead>();
		String[] ids = new List<String>();

        for (Lead cand : scope) {
			if(cand.Owner.Name == 'CDC') {
				break;
			}
            //logica para seleccionar Tiempo_sin_abrir__c
			Datetime fecha = cand.Fecha_modificacion_usuario__c == null ? cand.CreatedDate : cand.Fecha_modificacion_usuario__c;
            Long dt1Long = fecha.getTime();
            Long dt2Long = DateTime.now().getTime();
            Long milliseconds = dt2Long - dt1Long;
            Long seconds = milliseconds / 1000;
            Long minutes = seconds / 60;
            Long hours = minutes / 60;

			if(hours < 24 && cand.Tiempo_sin_abrir__c != null){
				cand.Tiempo_sin_abrir__c = null;
				leadsToUpdate.add(cand);
			}
            if(hours >= 24 && hours < 48 && cand.Tiempo_sin_abrir__c != '24 horas'){
					cand.Tiempo_sin_abrir__c = '24 horas';
                    System.debug('24 horas');
					leadsToUpdate.add(cand);			
            }
            if(hours >= 48 && hours < 72 && cand.Tiempo_sin_abrir__c != '48 horas'){
					cand.Tiempo_sin_abrir__c = '48 horas';
                    System.debug('48 horas');
					leadsToUpdate.add(cand);			
            }
			if(hours >= 72 && hours < 96 && cand.Tiempo_sin_abrir__c != '72 horas'){
                    cand.Tiempo_sin_abrir__c = '72 horas';
					System.debug('72 horas');
					leadsToUpdate.add(cand);			
            }
			if(hours >= 96 && hours < 120 && cand.Tiempo_sin_abrir__c != '96 horas'){
					cand.Tiempo_sin_abrir__c = '96 horas';
                    System.debug('96 horas');
					leadsToUpdate.add(cand);			
            }
			if(hours >= 120 && cand.Tiempo_sin_abrir__c != 'Mas de 96 Horas'){
					cand.Tiempo_sin_abrir__c = 'Mas de 96 Horas';
                    System.debug('Mas de 96 Horas');
					leadsToUpdate.add(cand);			
            }

			ids.add(cand.Id);
        }
		
        Database.SaveResult[] result = Database.update(leadsToUpdate,false);
		System.debug(result);
		//EmailUtils.sendErrorMail(null, result, null , ids, 'Errores candidatos - Tiempo sin abrir');

		Utils.insertBatchLogs(null, result, null , ids, 'Candidatos - Tiempo sin abrir');
    }    
    global void finish(Database.BatchableContext bc){

    }    
}