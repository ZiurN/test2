public class CaseAPAnularBtnCtrl  {
	static final String[] ADMIN_PROFILES = new List<String> {'System Administrator',
															'Administrador del sistema',
															'Administrador de Servicio',
															'CDC'};
	@AuraEnabled
	public static Response ifStatusIsOrdenEmitidaAndRecordTypeIsSeguimientoCancelCase(String caseId) {
		List<Case> caso = [SELECT Status, RecordTypeId, Nivel_de_derivacion__c, Delegacion__r.Codigo_de_delegacion__c, Nro_AP__c
			FROM Case WHERE Id =: caseId];
		User usuario = [SELECT CommunityNickname, Profile.Name, UserRole.DeveloperName, Codigo_delegacion__c
			FROM User WHERE Id =: UserInfo.getUserId()];
		Response validation = validatePermissions(usuario, caso[0]);
		if(validation.message != 'ok') {
			return validation;
		}
		if(String.isNotBlank(caso[0].Nro_AP__c)) {
			String body = JSON.serialize(new Map<String, Object> {'username' => usuario.CommunityNickname.toUpperCase()});
			WSCaseAPAnular.Response resp = WSCaseAPAnular.anularCaso(caso[0].Nro_AP__c, body);
			if (!resp.hasError) {
				anularCaso(caso[0]);
				return new Response(false, 'ok');
			}
			return new Response(true, resp.message);
		}
		else {
			anularCaso(caso[0]);
			return new Response(false, 'ok');
		}
	}
	private static void anularCaso(Case caso) {
		caso.Cambio_Manual__c = false;
		caso.Status = 'CA-----N';
		Database.SaveResult result = Database.update(caso);
	}
	private static Response validatePermissions(User usuario, Case caso) {
		Boolean hasPermission = ADMIN_PROFILES.contains(usuario.Profile.Name);
		if(usuario.CommunityNickname == null) {
			return new Response(false, System.Label.Alerta_NoAuth_ApodoCMVacio);
		}
		List<GroupMember> grupo = new List<GroupMember>();
		if(caso.Nivel_de_derivacion__c == 'Nivel 1') {
			grupo = [SELECT Id FROM GroupMember WHERE Group.DeveloperName = 'Front' AND UserOrGroupId =: usuario.Id];
			if(grupo.isEmpty() && !hasPermission) {
				return new Response(false, System.Label.Alerta_NoAuth_UsuarioNoFront);
			}
		}
		else if(caso.Nivel_de_derivacion__c == 'Nivel 2') {
			grupo = [SELECT Id FROM GroupMember WHERE Group.DeveloperName = 'Mesa_de_ayuda' AND UserOrGroupId =: usuario.Id];
			if(grupo.isEmpty() && !hasPermission) {
				return new Response(false, System.Label.Alerta_NoAuth_UsuarioNoMesaAyuda);
			}
		}
		else if(caso.Nivel_de_derivacion__c == 'Nivel 3') {
			List<CaseTeamMember> equipo = [SELECT MemberId
											FROM CaseTeamMember
											WHERE ParentId =: caso.Id AND MemberId =: usuario.Id];
			if(equipo.isEmpty() && !hasPermission) {
				return new Response(false, System.Label.Alerta_NoAuth_UsuarioNoEquipoCaso);
			}
		}
		return new Response(false, 'ok');
	}
	@AuraEnabled
	public static Boolean canCancelAPs() {
		Boolean isLider = Utils.isLeader();
		Boolean isEncargado = Utils.isEncargado();
		return isLider || isEncargado;
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