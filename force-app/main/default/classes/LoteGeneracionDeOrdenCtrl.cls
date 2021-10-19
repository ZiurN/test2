public class LoteGeneracionDeOrdenCtrl  {

	@AuraEnabled
    public static Response validarReintegrosEnAuditoria(String id_lote) {
		
		if(String.isBlank(id_lote)){
			return new Response(true, 'El lote no existe en SS');
		}

		Lote__c lote = [SELECT Id, Estado__c FROM Lote__c WHERE Id_lote_SS__c = :id_lote];
		List<Case> reintegros = [
            SELECT Id, Status, Codigo_reintegro_SS__c, CaseNumber, Caso_Rechazado__c, Prestaciones_en_auditoria__c
            FROM Case 
            WHERE Lote__c = :lote.Id
        ];
		String msg = 'Los siguientes reintegros tienen prestaciones en auditoría: \n';
		Boolean err = false;

		if(!reintegros.isEmpty()) {
			for(Case reintegro : reintegros) {
				if(reintegro.Prestaciones_en_auditoria__c && reintegro.Status == 'CA-----A') {
					err = true;
					msg += '- Nro en SF: ' + reintegro.CaseNumber + 
							'. Código en SS: ' + reintegro.Codigo_reintegro_SS__c + '\n';
				}
			}
		}

		if(err) {
			return new Response(err, msg);
		}
		
		return new Response(false, 'ok');
	}

	@AuraEnabled
    public static Response generacionDeOrden(String id_lote,String accion) {

		Lote__c lote = [SELECT Id, Estado__c,Errores_reintegros__c,Flag_Deshace_Orden__c,Bloqueo__c FROM Lote__c WHERE Id_lote_SS__c = :id_lote];

		User usuario = [SELECT Id,CommunityNickname FROM User WHERE Id = :UserInfo.getUserId()];
		String apodo = usuario.CommunityNickname != null ? usuario.CommunityNickname.toUpperCase() : null;

		String body = '{"accion":"'+ accion +'","usuario":"'+ apodo +'"}';
		System.debug('****body: ' + body);
		WSLoteGeneracionDeOrden.Response wsResponse =  WSLoteGeneracionDeOrden.generacionDeOrden(id_lote,body);
		System.debug('RESULTADO');
		System.debug(wsResponse);

        if(!wsResponse.hasError){
			lote.Estado__c = wsResponse.lote.data.lote.estado;
			lote.Bloqueo__c = false;
			if(lote.Estado__c == 'C' && accion == 'GENERAR'){
				lote.Flag_Deshace_Orden__c = true;
			}
			else{
				lote.Flag_Deshace_Orden__c = false;
			}
			
			Map<String,String> reintegrosWithError = new Map<String,String>();
			if(accion == 'GENERAR'){
				if(wsResponse.lote.data.lote.logs != null){
					lote.Errores_reintegros__c = true;
					for(WSLoteGeneracionDeOrdenResp.Logs log : wsResponse.lote.data.lote.logs){
						reintegrosWithError.put(log.rei_rei_id, log.texto);
					}
				}
			}else{
				lote.Errores_reintegros__c = false;
			}
			update lote;
			
            List<Case> reintegros = [
                SELECT Id, Status, Codigo_reintegro_SS__c, Error__c, Caso_Rechazado__c, Prestaciones_en_auditoria__c
                FROM Case 
                WHERE Lote__c = :lote.Id
            ];

			List<Id> reintegroIds = new List<Id>((new Map<Id,Case>(reintegros)).keySet());
			

			Case[] reintegrosToUpdate = new List<Case>();
			if(accion == 'GENERAR') {
				//System.enqueueJob(new ReintegroEmitirOrdenQueueable(reintegros, reintegrosWithError));
				emitirOrdenReintegros(reintegroIds, reintegrosWithError);
			}
			else {
				for(Case reintegro : reintegros){
					reintegro.Cambio_Manual__c = false;
					reintegro.Error__c = null;
					reintegro.Status = 'CA-----A';

					reintegrosToUpdate.add(reintegro);
					
				}

				update reintegrosToUpdate;
			}
            
            return new Response(false, wsResponse.lote.message);
        }
		return new Response(true, wsResponse.message);
    }

	@Future(callout=true)
	private static void emitirOrdenReintegros(List<Id> reintegroIds, Map<String,String> reintegrosWithError) {
		Map<Id, Case> reintegros = new Map<Id, Case>([
			SELECT Id, Status, Prestaciones_en_auditoria__c, Codigo_reintegro_SS__c, Caso_Rechazado__c, Lote__c
			FROM Case 
			WHERE Id IN :reintegroIds
		]);
		Lote__c[] lotePendiente = [SELECT Id, Tipo__c FROM Lote__c WHERE Tipo__c = 'Pendiente'];
		Case[] reintegrosToUpdate = new List<Case>();
		Case[] reintegrosPendientes = new List<Case>();
		Case[] reintegrosPendientesToReasignar = new List<Case>();
		Case[] reintegrosConError = new List<Case>();
		Integer i = 0;
		Integer cant = reintegroIds.size();

		for(i = 0; i < cant; i++) {			
			Id reintegroId = reintegroIds.remove(0);
			Case reintegro = reintegros.get(reintegroId);

			if(reintegrosWithError.containsKey(reintegro.Codigo_reintegro_SS__c)) {
				reintegro.Error__c = reintegrosWithError.get(reintegro.Codigo_reintegro_SS__c);

				reintegrosConError.add(reintegro);
			}
			else {
				reintegro.Cambio_Manual__c = false;
				reintegro.Error__c = null;
				if(reintegro.Status == 'CA-----G' || reintegro.Status == 'CA-----N' || reintegro.Caso_Rechazado__c) {
					reintegro.Derivacion_de_lote__c = 'Lote Pendiente';
					reintegro.Lote__c = lotePendiente.isEmpty() ? reintegro.Lote__c : lotePendiente[0].Id;
						
					if(String.isBlank(reintegro.Codigo_reintegro_SS__c)) {
						reintegrosPendientes.add(reintegro);
					}
					else {
						reintegrosPendientesToReasignar.add(reintegro);
					}

				} 
				else if(!reintegro.Prestaciones_en_auditoria__c 
						&& (reintegro.Status == 'CA-----A' || reintegro.Status == 'Autorizada')
				) {
					reintegro.Status = 'CA-----E';

					reintegrosToUpdate.add(reintegro);
				}
			}

		}

		Database.SaveResult[] resultsEmitir = Database.update(reintegrosToUpdate);
		System.debug('**** resultsEmitir: ' + resultsEmitir);

		Database.SaveResult[] resultsPendientes = Database.update(reintegrosPendientes);
		System.debug('**** resultsPendientes: ' + resultsPendientes);

		Database.SaveResult[] resultsReasignar = Database.update(reintegrosPendientesToReasignar);
		System.debug('**** resultsReasignar: ' + resultsReasignar);

		Database.SaveResult[] resultsReintegrosConError = Database.update(reintegrosConError);
		System.debug('**** resultsReintegrosConError: ' + resultsReintegrosConError);

		if(!reintegrosPendientesToReasignar.isEmpty()) {
			System.enqueueJob(new ReintegroReasignacionQueueable(reintegrosPendientesToReasignar));
		}
		
	}

    public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;

        public Response(Boolean hasError, String message){
            this.hasError = hasError;
            this.message = message;
        }
    }
}