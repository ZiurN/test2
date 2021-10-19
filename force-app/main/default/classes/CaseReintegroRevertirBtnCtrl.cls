public without sharing class CaseReintegroRevertirBtnCtrl  {

	static final String[] ADMIN_PROFILES = new List<String> {
		'Administrador del sistema', 
		'Administrador de Servicio',
		'System Administrator'
	};


	@AuraEnabled
	public static Response deleteAlertasRelatedToReintegroAndChangeStatusToReintegro(String reintegroId) {
		List<Case> reintegro = [
			SELECT Status, Nivel_de_derivacion__c, OwnerId, Delegacion__r.Codigo_de_delegacion__c, 
				(SELECT Id FROM Prestaciones_de_reintegros__r) 
			FROM Case 
			WHERE Codigo_reintegro_SS__c =: reintegroId
		];

		User usuario = [
			SELECT CommunityNickname, Profile.Name, UserRole.DeveloperName, Codigo_delegacion__c 
			FROM User 
			WHERE Id =: UserInfo.getUserId()
		];

		Response validation = validatePermissions(usuario, reintegro[0]);
		if(validation.message != 'ok') {
			return validation;
		}

		String body = JSON.serialize(new Map<String, Object> {
			'usuario' => usuario.CommunityNickname.toUpperCase(),
			'accion' => 'REVERTIR'
		});

		WSCaseReintegroRevertir.Response res = WSCaseReintegroRevertir.revertirReintegro(reintegroId, body);

		if (!res.hasError) {
			reintegro[0].Cambio_Manual__c = false;
			reintegro[0].Status = 'CA-----G';
			reintegro[0].Ap_autorizada__c = false;
			reintegro[0].Caso_Rechazado__c = false;
			if(!Test.isRunningTest()){
				Lote__c lote = [
					SELECT Id,Descripcion__c,Estado__c,Name,Tipo__c 
					FROM Lote__c 
					WHERE Tipo__c = 'Vigente' 
					AND Estado__c = 'A' 
					ORDER BY Name DESC
                    LIMIT 1
				];
				reintegro[0].Derivacion_de_Lote__c = 'Lote Vigente';
				reintegro[0].Lote__c = lote.Id;
			}
			Database.SaveResult resultReintegro = Database.update(reintegro[0]);
			System.debug('****resultReintegro: ' + resultReintegro);
			
			Map<Id, Prestacion_de_reintegro__c> prestaciones = new Map<Id, Prestacion_de_reintegro__c>(
				reintegro[0].Prestaciones_de_reintegros__r
			);

			for(Prestacion_de_reintegro__c prest : prestaciones.values()){
				prest.Estado__c = 'C1-----G';
			}

			List<Database.SaveResult> resultPrestaciones = Database.update(prestaciones.values());
			System.debug('****resultPrestaciones: ' + resultPrestaciones);
			
			if (!prestaciones.isEmpty()) {
				List<Alerta__c> alertasToDelete = [
					SELECT Id 
					FROM Alerta__c
					WHERE Prestacion_de_reintegro__c IN :prestaciones.keySet()
				];

				List<Database.DeleteResult> resultAlertas = Database.delete(alertasToDelete);
				System.debug('****resultAlertas: ' + resultAlertas);
				
			}
			return new Response(false, 'ok');
		}
		return new Response(true, res.message);
		 
	}

	private static Response validatePermissions(User usuario, Case caso) {
		String strObjPrefix = String.valueOf(caso.OwnerId).substring(0, 3);

        
        Boolean isUserInqueue = false;
		if(strObjPrefix == Group.sObjectType.getDescribe().getKeyPrefix()){            
			Group cola = [
				SELECT Id 
				FROM Group
				WHERE Type = 'Queue' AND Id = :caso.OwnerId
			];
			if(cola != null){
				List<GroupMember> gms = [
					SELECT Id,UserOrGroupId
					FROM GroupMember
					WHERE GroupId = :cola.Id
				];
				for(GroupMember gm : gms){
					if(gm.UserOrGroupId == UserInfo.getUserId()){
						isUserInqueue = true;
                        break;
					}
				}
            }    
        }
      
		String nick =  usuario.CommunityNickname != null ? usuario.CommunityNickname.toUppercase() : null;
        System.debug('usuario ' + usuario + ' nombre perfil ' + usuario.Profile.Name);
        System.debug( ADMIN_PROFILES.contains(usuario.Profile.Name) );
		Boolean propietario = ADMIN_PROFILES.contains(usuario.Profile.Name) || (isUserInqueue ? isUserInqueue : caso.OwnerId == usuario.Id);

		if(caso.Status == 'CA-----G' || caso.Status == 'CA-----E' || caso.Status == 'CA-----N') {
			return new Response(false, '- El estado debe ser Centro Autorizador o Autorizado.');
		}

		if(usuario.CommunityNickname == null) {
			return new Response(false, '- El apodo(CommunityNickname) del usuario está vacío.');
		}

		//if( !Utils.perteneceALaDelegacionCorrecta(caso, usuario) ) {	
			//return new Response(false, 'El usuario puede modificar casos de su delegación solamente');
		//}

		List<GroupMember> grupo = new List<GroupMember>();
		if(caso.Nivel_de_derivacion__c == 'Nivel 1') {
			grupo = [SELECT Id FROM GroupMember WHERE Group.DeveloperName = 'Front' AND UserOrGroupId =: usuario.Id];
			
			if(grupo.isEmpty() && usuario.Profile.Name != 'Administrador del sistema') {
				return new Response(false, '- El usuario no pertenece a Front');
			}
		} 
		else if(caso.Nivel_de_derivacion__c == 'Nivel 2') {
			grupo = [SELECT Id FROM GroupMember WHERE Group.DeveloperName = 'Mesa_de_ayuda' AND UserOrGroupId =: usuario.Id];
			
			if(grupo.isEmpty() && usuario.Profile.Name != 'Administrador del sistema') {
				return new Response(false, '- El usuario no pertenece a Mesa de Ayuda');
			}
		} 
		else if(caso.Nivel_de_derivacion__c == 'Nivel 3') {
			List<CaseTeamMember> equipo = [
				SELECT MemberId
				FROM CaseTeamMember
				WHERE ParentId =: caso.Id AND MemberId =: usuario.Id
			];
		
			if(equipo.isEmpty() && usuario.Profile.Name != 'Administrador del sistema') {
			//if(equipo.isEmpty()) {
				return new Response(false, '- El usuario no pertenece al equipo del caso');
			}
		}
		else if(caso.Nivel_de_derivacion__c == null && !propietario) {
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