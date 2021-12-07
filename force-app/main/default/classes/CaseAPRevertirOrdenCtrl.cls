@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class CaseAPRevertirOrdenCtrl  {
	static final String[] ADMIN_PROFILES = new List<String>{'System Administrator','Administrador del sistema', 'Administrador de Servicio'};
	public static Id emiId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_internacion').Id;
	@AuraEnabled
	public static BasicResponse revertirOrden(String caseId) {
		Case caso = [SELECT Status, Nivel_de_derivacion__c, OwnerId, Delegacion__r.Codigo_de_delegacion__c, Nro_AP__c,
						Orden_de_Compra__c, Orden_de_Compra__r.Estado_OC__c, Evento_medico__c,Evento_medico__r.RecordTypeId,
						(SELECT Id FROM Prestaciones__r)
					FROM Case
					WHERE Id = :caseId];
		User usuario = [SELECT CommunityNickname, Profile.Name, UserRole.DeveloperName, Codigo_delegacion__c
						FROM User
						WHERE Id =: UserInfo.getUserId()];
		BasicResponse validation = validatePermissions(usuario, caso);
		if(validation.message != 'ok') {
			return validation;
		}
		String body = JSON.serialize(new Map<String, Object> {'username' => usuario.CommunityNickname?.toUpperCase()});
		WSCaseAPRevertirOrden.Response resp = WSCaseAPRevertirOrden.revertirOrden(caso.Nro_AP__c, body);
		if (!resp.hasError) {
			caso.Cambio_Manual__c = false;
			caso.Status = resp.caseRes.data.ap.estado;
			caso.Nivel_de_derivacion__c = resp.caseRes.data.ap.nivel;
			caso.Ap_autorizada__c = false;
			caso.Caso_Rechazado__c = false;
			deleteOrdenAttached(caseId);
			if(caso.Evento_medico__c != null && caso.Evento_medico__r.RecordTypeId == emiId){
				deleteOrdenAttached(caso.Evento_medico__c);
			}
			revertirOrdenDeCompra(caso);
			Database.SaveResult resultCaso = Database.update(caso);
			Map<Id, Prestacion__c> prestaciones = new Map<Id, Prestacion__c>(caso.Prestaciones__r);
			for(Prestacion__c prest : prestaciones.values()){
				prest.Estado__c = 'C1-----G';
			}
			List<Database.SaveResult> resultPrestaciones = Database.update(prestaciones.values());
			List<Alerta__c> alertasToDelete = [SELECT Id FROM Alerta__c WHERE Prestacion__c IN :prestaciones.keySet()];
			if (!prestaciones.isEmpty() && !alertasToDelete.isEmpty()) {
				delete alertasToDelete;
			}
			return new BasicResponse(false, 'ok');
		}
		return new BasicResponse(true, resp.message);
	}
	private static BasicResponse validatePermissions(User usuario, Case caso) {
		String strObjPrefix = String.valueOf(caso.OwnerId).substring(0, 3);
        Boolean isUserInqueue = false;
		if(strObjPrefix == Group.sObjectType.getDescribe().getKeyPrefix()){
			Group cola = [SELECT Id FROM Group WHERE Type = 'Queue' AND Id = :caso.OwnerId];
			if(cola != null){
				List<GroupMember> gms = [SELECT Id,UserOrGroupId FROM GroupMember WHERE GroupId = :cola.Id];
				for(GroupMember gm : gms){
					if(gm.UserOrGroupId == UserInfo.getUserId()){
						isUserInqueue = true;
                        break;
					}
				}
            }
        }
		String nick =  usuario.CommunityNickname != null ? usuario.CommunityNickname.toUppercase() : null;
		Boolean admin = ADMIN_PROFILES.contains(usuario.Profile.Name);
		Boolean propietario = admin || (isUserInqueue ? isUserInqueue : caso.OwnerId == usuario.Id);
		if(caso.Status != 'CA-----E') {
			return new BasicResponse(false, System.Label.Alerta_NoAuth_EstadoOrdenDebeSerEmitida);
		}
		if(usuario.CommunityNickname == null) {
			return new BasicResponse(false, System.Label.Alerta_NoAuth_ApodoCMVacio);
		}
		List<GroupMember> grupo = new List<GroupMember>();
		if(caso.Nivel_de_derivacion__c == 'Nivel 1') {
			grupo = [SELECT Id FROM GroupMember WHERE Group.DeveloperName = 'Front' AND UserOrGroupId =: usuario.Id];
			if(grupo.isEmpty() && !admin) {return new BasicResponse(false, System.Label.Alerta_NoAuth_UsuarioNoFront);
			}
		}
		else if(caso.Nivel_de_derivacion__c == 'Nivel 2') {
			grupo = [SELECT Id FROM GroupMember WHERE Group.DeveloperName = 'Mesa_de_ayuda' AND UserOrGroupId =: usuario.Id];
			if(grupo.isEmpty() && !admin) {
				return new BasicResponse(false, System.Label.Alerta_NoAuth_UsuarioNoMesaAyuda);
			}
		}
		else if(caso.Nivel_de_derivacion__c == 'Nivel 3') {
			List<CaseTeamMember> equipo = [SELECT MemberId FROM CaseTeamMember WHERE ParentId =: caso.Id AND MemberId =: usuario.Id];
			if(equipo.isEmpty() && !admin) {
				return new BasicResponse(false, System.Label.Alerta_NoAuth_UsuarioNoEquipoCaso);
			}
		}
		else if(caso.Nivel_de_derivacion__c == null && !propietario) {
			return new BasicResponse(false, System.Label.Alerta_NoAuth_UsuarioNoPropietario);
		}
		return new BasicResponse(false, 'ok');
	}
	private static void deleteOrdenAttached(Id caseId) {
		Id[] contentDocumentIds = new List<Id>();
		Id[] contentDocumentIdsToDelete = new List<Id>();
		ContentDocumentLink[] links = [SELECT LinkedEntityId, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title,
											ShareType, ContentDocument.FileType, ContentDocument.FileExtension
										FROM ContentDocumentLink
										WHERE LinkedEntityId =: caseId
											AND ContentDocument.Title LIKE 'Orden_%'
											AND ContentDocument.FileExtension = 'pdf'];

		for(ContentDocumentLink cdl : links) {
			contentDocumentIds.add(cdl.ContentDocumentId);
		}
		ContentVersion[] versions = [SELECT Id, PathOnClient, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :contentDocumentIds];
		for(ContentVersion version : versions) {
			if(!version.PathOnClient.startsWith('Orden_')) {
				contentDocumentIdsToDelete.add(version.ContentDocumentId);
			}
		}
		ContentDocument[] documentsToDelete = [SELECT Id FROM ContentDocument WHERE Id IN :contentDocumentIdsToDelete];
		Database.DeleteResult[] resultDocumentsToDelete = Database.delete(documentsToDelete);
	}
	private static void revertirOrdenDeCompra(Case caso) {
		if(String.isNotBlank(caso.Orden_de_Compra__c)) {
			Orden_de_Compra__c orden = caso.Orden_de_Compra__r;
			orden.Estado_OC__c = 'Generada';
			update orden;
		}
	}
	@AuraEnabled
	public static Boolean canRevertOrders() {
		Boolean isLider = Utils.isLeader();
		Boolean isEncargado = Utils.isEncargado();
		return isLider || isEncargado;
	}
}