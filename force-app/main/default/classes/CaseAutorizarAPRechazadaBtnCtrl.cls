public without Sharing class CaseAutorizarAPRechazadaBtnCtrl  {
	
	@AuraEnabled
	public static Response autorizarAPRechazada(String caseId) {
		List<Case> casos = [
			SELECT Status, Nivel_de_derivacion__c, OwnerId, Nro_AP__c, Delegacion__r.Codigo_de_delegacion__c,
				Caso_Rechazado__c, Celula__c,
					(SELECT Id, Prestacion_CA__c FROM Prestaciones__r)
			FROM Case 
			WHERE Id =: caseId
		];
		User usuario = [
			SELECT CommunityNickname, Profile.Name, UserRole.DeveloperName, Codigo_delegacion__c 
			FROM User 
			WHERE Id =: UserInfo.getUserId()
		];
		
		Response validation = validatePermissions(usuario, casos);
		if(validation.message != 'ok') {
			return validation;
		}

		String body = JSON.serialize(new Map<String, Object> {'usuario' => usuario.CommunityNickname.toUpperCase()});

		WSCaseAutorizarAPRechazada.Response resp = WSCaseAutorizarAPRechazada.autorizarApRechazada(casos[0].Nro_AP__c, body);
		
		if (!resp.hasError) {
			updateAPPrestsAndAlerts(resp.result.data.ap, casos[0]);
			return new Response(false, 'ok');
		}
		return new Response(true, resp.message);
		 
	}

	private static void updateAPPrestsAndAlerts(WSCaseAutorizarAPRechazadaResp.Ap apWS, Case caso) {
		List<Prestacion__c> prestacionesToUpdate = new List<Prestacion__c>();
		List<Alerta__c> alertasToUpsert = new List<Alerta__c>();
		
		caso.Cambio_Manual__c = false;
		//caso.Status = 'Autorizada';
		//caso.Ap_autorizada__c = true;
		caso.Caso_Rechazado__c = false;

		for(WSCaseAutorizarAPRechazadaResp.Prestaciones presWS: apWS.prestaciones) {
			for(Prestacion__c pres : caso.Prestaciones__r) {
				
				if(pres.Prestacion_CA__c == presWS.pca_id) {
					pres.Estado__c = presWS.estado_prestacion;

					prestacionesToUpdate.add(pres);

					for(WSCaseAutorizarAPRechazadaResp.Alertas alertWS : presWS.alertas) {
						Alerta__c alerta = new Alerta__c();
	//--------------------------------------------------------------------------------------
						alerta.Prestacion__c = pres.Id;
						//alerta.Evento_Medico__c = emFromSF.Id;
						alerta.idalerta__c = alertWs.aca_id;
						alerta.Control__c = alertWs.control;
						alerta.Funcion__c = alertWs.funcion;
						alerta.Texto_aclarativo__c = alertWs.texto_aclarativo;
						alerta.Nivel_de_auditoria__c = alertWs.nivel_auditoria != null
								? Integer.valueOf(alertWs.nivel_auditoria) : null;
						alerta.Fecha_de_generacion_de_Alerta__c = alertWs.fecha_generacion != null ?
								Date.valueOf(alertWs.fecha_generacion.substringBefore(' ')) :
								null;
						alerta.Lectura_de_alerta_auditor__c = alertWs.auditor_lee;
						alerta.Resolucion_de_alerta_auditor__c = alertWs.auditor_resuelve;
						alerta.Fecha_resolucion_de_Alerta__c = alertWs.fecha_resolucion != null
								? Date.valueOf(alertWs.fecha_resolucion) : null;
						//alerta.Fecha_resolucion_de_Alerta__c = alertWs.fecha_resolucion != null ?
								//Date.valueOf(alertWs.fecha_resolucion.substringBefore(' ')) :
								//null;
						alerta.Estado__c = alertWs.estado_alerta;
	//--------------------------------------------------------------------------------------
						alertasToUpsert.add(alerta);
					}
				}
			
			}
		}

		Database.SaveResult resultCaso = Database.update(caso);
		System.debug('****resultCaso: ' + resultCaso);
		List<Database.SaveResult> resultPrestaciones = Database.update(prestacionesToUpdate);
		System.debug('****resultPrestaciones: ' + resultPrestaciones);
		List<Database.UpsertResult> resultAlerts = Database.upsert(alertasToUpsert, Alerta__c.Fields.idalerta__c);
        System.debug('****resultAlerts ' + resultAlerts);
		
	}

	private static Response validatePermissions(User usuario, List<Case> casos) {
		//Boolean propietario = usuario.Profile.Name == 'Administrador del sistema' || caso.OwnerId == usuario.Id;
		Boolean liderMesa = usuario.Profile.Name == 'Administrador del sistema' 
							|| usuario.Profile.Name == 'Coordinador de Mesa de Ayuda';
		
		if(!casos[0].Caso_Rechazado__c) {
			return new Response(false, 'El caso debe estar rechazado');
		}

		//if( !Utils.perteneceALaDelegacionCorrecta(casos[0], usuario) ) {	
			//return new Response(false, 'El usuario puede modificar casos de su delegación solamente');
		//}
		if(casos[0].Nivel_de_derivacion__c == 'Nivel 1' || casos[0].Nivel_de_derivacion__c == null) {
			GroupMember[] members = [
				SELECT Id, UserOrGroupId, Group.DeveloperName 
				FROM GroupMember 
				WHERE Group.DeveloperName LIKE 'Celula%' AND UserOrGroupId = :usuario.Id
			];

			if(members.isEmpty() && !liderMesa) {
				return new Response(false, '- El usuario debe ser el líder de la célula');
			}
		} 
		else if(casos[0].Nivel_de_derivacion__c == 'Nivel 2') {
			if(!liderMesa) {
				return new Response(false, '- El usuario debe ser el líder de Mesa de Ayuda');
			}
		} 
		else if(casos[0].Nivel_de_derivacion__c == 'Nivel 3') {
			if(usuario.Profile.Name != 'Administrador del sistema') {
				if(String.isBlank(casos[0].Celula__c)) {
					return new Response(false, '- El campo célula debe estar completo');
				}
				else {
					String queueName = casos[0].Celula__c.replace(' ', '_');
					GroupMember[] members = [
						SELECT Id, UserOrGroupId, Group.DeveloperName 
						FROM GroupMember 
						WHERE Group.DeveloperName = :queueName AND UserOrGroupId = :usuario.Id
					];
		
					if(members.isEmpty()) {
						return new Response(false, '- El usuario debe ser el líder de la célula');
					}
				}
			}
		}

		return new Response(false, 'ok');
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