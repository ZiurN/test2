public without sharing class EventoMedicoAnularBtnCtrl {
    @AuraEnabled
    public static Response anularEM(String emId) {
        List<Evento_medico__c> eventoMedico = [
                SELECT Estado__c, OwnerId, Nro_de_Evento_Medico_SS__c, (
                        SELECT Status FROM Casos__r
                )
                FROM Evento_medico__c
                WHERE Id =: emId
        ];
		User usuario = [SELECT CommunityNickname, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		Response validationOwner = validateOwner(eventoMedico[0], usuario);

		if(validationOwner.message != 'ok') {
			return validationOwner;
		}

		if(String.isNotBlank(eventoMedico[0].Nro_de_Evento_Medico_SS__c)) {

			String body = JSON.serialize(new Map<String, Object> {'usuario' => usuario.CommunityNickname.toUpperCase()});
			WSEventoMedicoAnular.Response wsResponse = WSEventoMedicoAnular.anularEM(
				eventoMedico[0].Nro_de_Evento_Medico_SS__c, body
			);

			if(!wsResponse.hasError) {
				cancelEmAndCases(eventoMedico[0]);
            
				return new Response(false, 'ok');
			}
			else {
				return new Response(true, wsResponse.message);
			}
		}
		else {
			cancelEmAndCases(eventoMedico[0]);

			return new Response(false, 'ok');
		}
    }

	private static void cancelEmAndCases(Evento_medico__c eventoMedico) {
		List<Case> casesToCancel = new List<Case>();
		
		eventoMedico.Estado__c = 'Anulado';

        for(Case caso : eventoMedico.Casos__r) {
			caso.Cambio_Manual__c = false;
            caso.Status = 'CA-----N';
            casesToCancel.add(caso);
        }

        Database.SaveResult resultEm = Database.update(eventoMedico);
        List<Database.SaveResult> resultCases = Database.update(casesToCancel);
        System.debug('**** resultEm: ' + resultEm);
        System.debug('**** resultCases: ' + resultCases);
	}

	private static Response validateOwner(Evento_medico__c em, User usuario) {
		Boolean propietario = usuario.Profile.Name == 'Administrador del sistema' || usuario.Profile.Name == 'CDC'
								|| em.OwnerId == usuario.Id;

		if(!propietario) {
			return new Response(false, 'El usuario no es el propietario');
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