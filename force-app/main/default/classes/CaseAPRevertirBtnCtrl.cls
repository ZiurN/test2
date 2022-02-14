@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class CaseAPRevertirBtnCtrl {
	static final String[] ADMIN_PROFILES = new List<String>{'System Administrator','Administrador del sistema', 'Administrador de Servicio'};
	@AuraEnabled
	public static Response deleteAlertasRelatedToCaseAndChangeStatusFromCase(String caseId) {
		Case caso = [SELECT Status,
						Nivel_de_derivacion__c,
						OwnerId, Delegacion__r.Codigo_de_delegacion__c,
						(SELECT Id FROM Prestaciones__r)
					FROM Case WHERE Nro_AP__c =: caseId];
		User usuario = [SELECT CommunityNickname,
							Profile.Name,
							UserRole.DeveloperName,
							Codigo_delegacion__c
						FROM User
						WHERE Id =: UserInfo.getUserId()];
		Response validation = validatePermissions(usuario, caso);
		if(validation.message != 'ok') {
			return validation;
		}
		String body = JSON.serialize(new Map<String, Object> {'username' => usuario.CommunityNickname.toUpperCase()});
		WSCaseEnviarASSHelper.Response res = WSCaseEnviarASSHelper.enviarASS(body, 'autorizaciones', 'centro-autorizador/revertir', caseId);
		if (!res.hasError) {
			caso.Cambio_Manual__c = false;
			caso.Status = 'CA-----G';
			caso.Ap_autorizada__c = false;
			caso.Caso_Rechazado__c = false;
			Database.SaveResult resultCaso = Database.update(caso);
			Map<Id, Prestacion__c> prestaciones = new Map<Id, Prestacion__c>(caso.Prestaciones__r);
			for(Prestacion__c prest : prestaciones.values()){
				prest.Estado__c = 'C1-----G';
			}
			List<Database.SaveResult> resultPrestaciones = Database.update(prestaciones.values());
			if (!prestaciones.isEmpty()) {
				List<Alerta__c> alertasToDelete = [SELECT Id FROM Alerta__c WHERE Prestacion__c IN :prestaciones.keySet()];
				if (!alertasToDelete.isEmpty()) {
					delete alertasToDelete;
				}
			}
			return new Response(false, 'ok');
		}
		return new Response(true, res.message);
	}
	private static Response validatePermissions(User usuario, Case caso) {
		String strObjPrefix = String.valueOf(caso.OwnerId).substring(0, 3);
		Boolean isUserInqueue = false;
		if(strObjPrefix == Group.sObjectType.getDescribe().getKeyPrefix()){
			Group cola = [SELECT Id FROM Group WHERE Type = 'Queue' AND Id = :caso.OwnerId];
			if(cola != null){
				List<GroupMember> gms = [SELECT Id,UserOrGroupId FROM GroupMember WHERE GroupId = :cola.Id];
				for(GroupMember gm : gms){
					if(gm.UserOrGroupId == usuario.Id){
						isUserInqueue = true;
						break;
					}
				}
			}
		}
		String nick =  usuario.CommunityNickname != null ? usuario.CommunityNickname.toUppercase() : null;
		Boolean admin = ADMIN_PROFILES.contains(usuario.Profile.Name);
		Boolean propietario = admin || (isUserInqueue ? isUserInqueue : caso.OwnerId == usuario.Id);
		if(caso.Status == 'CA-----G' || caso.Status == 'CA-----E' || caso.Status == 'CA-----N') {
			return new Response(false, System.Label.Alerta_CaseStatusInCorrect);
		}
		if(usuario.CommunityNickname == null) {
			return new Response(false, System.Label.Alerta_NoAuth_ApodoCMVacio);
		}
		List<GroupMember> grupo = new List<GroupMember>();
		if(caso.Nivel_de_derivacion__c == 'Nivel 1') {
			grupo = [SELECT Id FROM GroupMember WHERE Group.DeveloperName = 'Front' AND UserOrGroupId =: usuario.Id];
			if(grupo.isEmpty() && !admin) {
				return new Response(false, System.Label.Alerta_NoAuth_UsuarioNoFront);
			}
		}
		else if(caso.Nivel_de_derivacion__c == 'Nivel 2') {
			grupo = [SELECT Id FROM GroupMember WHERE Group.DeveloperName = 'Mesa_de_ayuda' AND UserOrGroupId =: usuario.Id];
			if(grupo.isEmpty() && !admin) {
				return new Response(false, System.Label.Alerta_NoAuth_UsuarioNoMesaAyuda);
			}
		}
		else if(caso.Nivel_de_derivacion__c == 'Nivel 3') {
			List<CaseTeamMember> equipo = [SELECT MemberId FROM CaseTeamMember WHERE ParentId =: caso.Id AND MemberId =: usuario.Id];
			if(equipo.isEmpty() && !admin) {
				return new Response(false, System.Label.Alerta_NoAuth_UsuarioNoEquipoCaso);
			}
		}
		else if(caso.Nivel_de_derivacion__c == null && !propietario) {
			return new Response(false, System.Label.Alerta_NoAuth_UsuarioNoPropietario);
		}
		return new Response(false, 'ok');
	}
	@AuraEnabled
	public static Boolean isLeader() {
		return Utils.isLeader();
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