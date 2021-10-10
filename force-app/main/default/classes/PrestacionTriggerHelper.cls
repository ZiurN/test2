/**-----------------------------------------------------------------------------------------------------------------------
@author			Matias Moll
@description	Clase auxiliar para el trigger de Prestaciones
------------------------------------------------------------------------------------------------------------------------*/
@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class PrestacionTriggerHelper {
	public static Boolean firstRun = true;
	public static Id emInternacionId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_internacion').Id;
	public static void authorizeCases(Set<String> idCases) {
		Id emInternacionRT = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_internacion').Id;
		Id[] casesToEmitir = new List<Id>();
		Case[] casesToAuthorize = new List<Case>();
		Case[] cases = [SELECT Id, Status, RecordTypeId, Nro_AP__c, Evento_Medico__r.RecordTypeId,
							(SELECT Id, Estado__c FROM Prestaciones__r)
						FROM Case
						WHERE Id IN :idCases];
		for(Case aCase : cases) {
			Boolean authorize = true;
			for(Prestacion__c prest : aCase.Prestaciones__r) {
				if(prest.Estado__c != 'C1----AS' && prest.Estado__c != 'C1EA--AA') {
					authorize = false;
				}
			}
			if(authorize) {
				if(aCase.Status != 'CA-----E' && aCase.Status != 'CA-----N') {
					if(emInternacionRT == aCase.Evento_Medico__r.RecordTypeId) {
						aCase.Cambio_Manual__c = false;
						aCase.Ap_autorizada__c = true;
						aCase.Status = 'Autorizada';
						casesToAuthorize.add(aCase);
					}
					else {
						casesToEmitir.add(aCase.Id);
					}
				}
			}
		}
		update casesToAuthorize;
		if(!casesToEmitir.isEmpty()) {
			emitirOrdenInCases(casesToEmitir);
		}
	}
	public static void validateDuplicateNomencladorOrMedicamento(Prestacion__c[] prestaciones) {
		Set<Id> idCases = new Set<Id>();
		for(Prestacion__c prest : prestaciones) {
			if(prest.Ap__c != null) {
				idCases.add(prest.Ap__c);
			}
		}
		Map<Id, Case> casesById = new Map<Id, Case>([SELECT Id, Status, RecordTypeId,
														(SELECT Id, Estado__c, Prestacion__c, Medicamento__c FROM Prestaciones__r)
													FROM Case
													WHERE Id IN :idCases]);
		for(Prestacion__c prestToValidate : prestaciones) {
			for(Prestacion__c prestFromQuery : casesById.get(prestToValidate.Ap__c).Prestaciones__r) {
				if(prestToValidate.Id != prestFromQuery.Id
					&& prestToValidate.Prestacion__c == prestFromQuery.Prestacion__c
					&& prestToValidate.Prestacion__c != null
				) {
					prestToValidate.addError('No se permite cargar dos prestaciones con el mismo nomenclador al mismo caso');
				}
				if(prestToValidate.Id != prestFromQuery.Id
					&& prestToValidate.Medicamento__c == prestFromQuery.Medicamento__c
					&& prestToValidate.Medicamento__c != null
				) {
					prestToValidate.addError('No se permite cargar dos prestaciones con el mismo medicamento al mismo caso');
				}
			}
		}
	}
	public static void deleteWhenCasesStatusIsNotCentroAutorizador(Map<Id, Prestacion__c> prestacionesById) {
		Prestacion__c[] prestacionesWithCaseStatus = [SELECT Id, Ap__r.Status
														FROM Prestacion__c
														WHERE Id IN :prestacionesById.values()];
		User usuario = [SELECT Id, Profile.Name
						FROM User
						WHERE Id =: UserInfo.getUserId()];
		Boolean isAdmin = usuario.Profile.Name == 'Administrador del sistema';
		if(!isAdmin) {
			for(Prestacion__c prest : prestacionesWithCaseStatus) {
				if(prest.Ap__r.Status != 'CA-----G') {
					Prestacion__c prestToAddError = prestacionesById.get(prest.Id);
					prestToAddError.addError('El caso debe estar en estado "Generada" para poder eliminar prestaciones');
				}
			}
		}
	}
	@future (callout=true)
	public static void emitirOrdenInCases(Id[] caseIds) {
		Case[] casos = [SELECT Status, RecordTypeId, Nivel_de_derivacion__c, Delegacion__r.Codigo_de_delegacion__c,
							Evento_Medico__c, Ap_autorizada__c, Nro_AP__c, Prestador__r.Correo_electronico__c, Type,
							CaseNumber, Evento_Medico__r.Tipo__c, Correo_asociado__c,Sub_tipo__c,RecordType.Name, Codigo_Diag__c,
							Orden_de_Compra__c,Evento_Medico__r.RecordTypeId
						FROM Case
						WHERE Id IN: caseIds AND Status != 'CA-----E'];
		User usuario = [SELECT CommunityNickname, Profile.Name, UserRole.DeveloperName, Codigo_delegacion__c
			FROM User
			WHERE Id =: UserInfo.getUserId()];
		String rtSeguimiento = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		String rtInternacion = XappiaHelper.getRecordType('Case', 'Internacion').Id;
		Case[] casesToEmitir = new List<Case>();
		List<ContentVersion> versionsAll = new List<ContentVersion>();
		Map<Id, ContentVersion[]> versionsByEntityId = new Map<Id, ContentVersion[]>();
		Map<Id,Id> entityIdByContentVersionId = new Map<Id,Id>();
		List<ContentDocumentLink> links = new List<ContentDocumentLink>();
		for(Case caso : casos) {
			if(caso.RecordTypeId == rtSeguimiento) {
				casesToEmitir.add(emitirOrdenSinEnviar(caso));
			} else {
				String body = JSON.serialize(new Map<String, Object> {'username' => usuario.CommunityNickname.toUpperCase()});
				WSCaseAPEmitirOrden.Response resp = WSCaseAPEmitirOrden.emitirOrden(caso.Nro_AP__c, body);
				List<ContentVersion> versions = new List<ContentVersion>();
				if (!resp.hasError) {
					Id registroId = caso.RecordTypeId == rtInternacion ? caso.Evento_Medico__c : caso.Id;
					if(shouldGoNivelOne(caso) && resp.result.data.ap.nivel == 'N1' ){
						caso.Nivel_de_derivacion__c = 'Nivel 1';
					}
					casesToEmitir.add(emitirOrdenSinEnviar(caso));
					for(WSCaseAPEmitirOrdenResp.Ordenes orden : resp.result.data.ap.ordenes){
						ContentVersion version = CaseEmitirOrdenBtnCtrl.buildPDF(orden);
						version.Titulo_original__c = registroId;
						versions.add(version);
					}
					versionsAll.addAll(versions);
					versionsByEntityId.put(registroId, versions);
				}
			}
		}
		/**-------------------------------------------------------------------------------------
			sendToAWS(links, versionsByEntityId);
		--------------------------------------------------------------------------------------*/
		for(ContentVersion cv : versionsAll) {
			cv.Titulo_original__c = '';
		}
		insert versionsAll;
		for(Id entity : versionsByEntityId.keySet()) {
			for(ContentVersion cv : versionsByEntityId.get(entity)) {
				entityIdByContentVersionId.put(cv.Id, entity);
			}
		}
		Map<Id, ContentVersion> versionsUpdatedMap = new Map<Id, ContentVersion>([SELECT ContentDocumentId, VersionData, FileExtension
																					FROM ContentVersion
																					WHERE Id IN :versionsAll]);
		for(ContentVersion ver : versionsUpdatedMap.values()) {
			Id entityId = entityIdByContentVersionId.get(ver.Id);
			links.add(new ContentDocumentLink(
				LinkedEntityId = entityId,
				ShareType = 'V',
				ContentDocumentId = ver.ContentDocumentId
			));
		}
		for(Case caso : casos) {
			Id registroId = caso.RecordTypeId == rtInternacion ? caso.Evento_Medico__c : caso.Id;
			ContentVersion[] cv = versionsByEntityId.get(registroId);
			ContentVersion cvWithVersionData = new ContentVersion();
			if(cv != null && !cv.isEmpty()) {
				cvWithVersionData = versionsUpdatedMap.get(cv[0].Id);
			}
			if (CaseEmitirOrdenBtnCtrl.isToSendToPrestador(caso) && !versionsUpdatedMap.isEmpty() && caso.Evento_Medico__r.RecordTypeId != emInternacionId) {
				if(shouldGoNivelOne(caso)){
					caso.Nivel_de_derivacion__c = 'Nivel 1';
				}
				EmailUtils.MailResponse emailResp = EmailUtils.sendMailWithAttachment(new List<String>{caso.Prestador__r.Correo_electronico__c},
																						cvWithVersionData.VersionData,
																						'Orden_' + caso.CaseNumber + '.' + cvWithVersionData.FileExtension,
																						caso.Id,
																						'Orden_emitida_con_adjuntos',
																						null);
			}
			if (CaseEmitirOrdenBtnCtrl.isToSendToAasociado(caso) && !versionsUpdatedMap.isEmpty() && caso.Evento_Medico__r.RecordTypeId != emInternacionId) {
				if(shouldGoNivelOne(caso)){
					caso.Nivel_de_derivacion__c = 'Nivel 1';
				}
				EmailUtils.MailResponse emailRespAsociado = EmailUtils.sendMailWithAttachment(new List<String>{caso.Correo_asociado__c},
																								cvWithVersionData.VersionData,
																								'Orden_' + caso.CaseNumber + '.' + cvWithVersionData.FileExtension,
																								caso.Id,
																								'Notificacion_Ap_Emitida',
																								null,
																								true);
			}
		}
		insert links;
		Database.SaveResult[] resultCasosToEmitir = Database.update(casesToEmitir);
	}
	private static Case emitirOrdenSinEnviar(Case caso) {
		caso.Cambio_Manual__c = false;
		caso.Status = 'CA-----E';
		if(shouldGoNivelOne(caso)){
			caso.Nivel_de_derivacion__c = 'Nivel 1';
		}
		caso.Ap_autorizada__c = true;
		return caso;
	}
	public static Boolean shouldGoNivelOne(Case caso){
		return caso.Type != 'Oxigenoterapia' && caso.sub_tipo__c != 'Material';
	}
}