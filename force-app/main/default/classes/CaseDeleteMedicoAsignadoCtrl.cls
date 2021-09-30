public class CaseDeleteMedicoAsignadoCtrl  {
	@AuraEnabled
	public static Response deleteMedico(Id caseId) {
		
		Case[] cases = [SELECT Id, Celula__c, Medico_asignado__c FROM Case WHERE Id = :caseId];
		User usuario = [
			SELECT CommunityNickname, Profile.Name, UserRole.DeveloperName, Codigo_delegacion__c 
			FROM User 
			WHERE Id =: UserInfo.getUserId()
		];
		
		if(cases[0].Medico_asignado__c != null) {
			cases[0].Medico_asignado__c = null;

			update cases[0];

			return new Response(false, 'ok');
		}
		else {
			return new Response(false, 'No hay ningún médico asignado actualmente.');
		}
	}

	public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;

        public Response(Boolean hasError, String message) {
            this.hasError = hasError;
            this.message = message;
        }
    }
}