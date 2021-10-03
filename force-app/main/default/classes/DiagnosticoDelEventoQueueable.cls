public class DiagnosticoDelEventoQueueable implements Queueable, Database.AllowsCallouts {
	List<Diagnostico_del_Evento__c> diagnosticos;

	public DiagnosticoDelEventoQueueable(List<Diagnostico_del_Evento__c> diagnosticosList) {
		diagnosticos = diagnosticosList;
	}

	public void execute(QueueableContext context) {
		User usuario = [
            SELECT Alias, CommunityNickname, Profile.Name 
            FROM User 
            WHERE Id =: UserInfo.getUserId()
        ];
		String apodo = usuario.CommunityNickname != null ? usuario.CommunityNickname.toUpperCase() : null;

		if(!diagnosticos.isEmpty()) {
			Diagnostico_del_Evento__c diagnosticoOriginal = diagnosticos.remove(0);
			Diagnostico_del_Evento__c diagnostico = [
				SELECT Id, Fecha__c, Diagnostico__r.Codigo_del_Diagnostico__c, Tipo__c,
					Evento_Medico__r.Nro_de_Evento_Medico_SS__c, Error_en_SS__c
				FROM Diagnostico_del_Evento__c 
				WHERE Id =: diagnosticoOriginal.Id
					AND Evento_Medico__r.Nro_de_Evento_Medico_SS__c != null
			];

			String body = DiagnosticoDelEventoTriggerHelper.generateJson(diagnostico, apodo);

			WSDiagnosticoDelEventoEnviar.Response resp = WSDiagnosticoDelEventoEnviar.enviarDiagnostico(
				diagnostico.Evento_Medico__r.Nro_de_Evento_Medico_SS__c, body
			);

			System.debug('****resp: ' + resp);
			
			if(!resp.hasError) {
				diagnostico.Error_en_SS__c = null;
			}
			else {
				diagnostico.Error_en_SS__c = '<p style="color: rgb(228, 10, 10);">' + resp.message + '</p>';
			}

			Database.SaveResult resultDiagnostico = Database.update(diagnostico);
			System.debug('****resultDiagnostico: ' + resultDiagnostico);

			if(!diagnosticos.isEmpty()){
				System.enqueueJob(new DiagnosticoDelEventoQueueable(diagnosticos));
			}
		}
	}
}