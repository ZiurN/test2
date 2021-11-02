public class CasoEnviarASSBtnCtrl  {
	static final String[] ADMIN_PROFILES = new List<String> {
		'Administrador del sistema', 
		'Administrador de Servicio',
		'CDC'
	};

	@AuraEnabled
    public static Boolean hasAttachments(Id caseId, Id emId) {
        List<EmailMessage> emailMessages = [
            SELECT Id 
            FROM 
            EmailMessage 
            WHERE ParentId = :caseId
        ];
        system.debug(emailMessages);
        List<ContentDocumentLink> dbLinks = [
            SELECT LinkedEntityId,ContentDocumentId,ContentDocument.LatestPublishedVersionId
            FROM ContentDocumentLink
            WHERE LinkedEntityId =: caseId 
            OR LinkedEntityId =: emId 
            OR LinkedEntityId IN :emailMessages
        ];
		system.debug(dbLinks);
        return !dbLinks.isEmpty();
    }
	
	@AuraEnabled
	public static Response sendCaseToSS(Id caseToSend){
		system.debug('sendCaseToSS(Id caseToSend)');
		Case caseFromSF = [
			SELECT Id,Fecha__c,Fecha_probable__c,Delegacion__r.Codigo_de_delegacion__c, Consultorio__r.Secuencia__c,
				Account.Codigo_de_Afiliado__c,Fecha_prescripcion__c,Diagnostico__r.Codigo_del_Diagnostico__c,
				Prestador__r.Codigo_de_efector__c,Consultorio__r.Codigo_externo__c,Observaciones__c,Mail__c,
				Otros_Mail__c,Evento_Medico__r.Nro_de_Evento_Medico_SS__c,AP_Material__c,AP_Presupuesto__c,Prescriptor__r.Codigo_de_efector__c,
				Status,Nro_AP__c,Categorizacion_SS__c,Nivel_de_derivacion__c,Importe_presupuesto__c, OwnerId, Evento_Medico__c,
				Orden_de_Compra__r.forma_de_Pago__c, Orden_de_Compra__r.Estado_OC__c, Evento_Medico__r.Estado__c, Urgente__c
			FROM Case
			WHERE Id = :caseToSend
		];
		Segmentos__c[] segmentos = [
			SELECT Id, Estado__c  
			FROM Segmentos__c 
			WHERE Evento_Medico__c = :caseFromSF.Evento_Medico__c 
				AND Segmento_actual__c = true
		];
		System.debug('****sendToSS(caseFromSF, segmentos):');
		return sendToSS(caseFromSF, segmentos); 

	}

	private static String updateCase(Case caseFromSF, WSCaseAPGenerarCentroResp.Ap ap, Segmentos__c[] segmentos) {
		String msg = '';
		List<Prestacion__c> prestaciones = [
				SELECT Id,Alerta__c,Cantidad__c,Nombre_de_Prestacion__c,Prestacion__r.Tipo_Nomenclador__c,
						Prestacion__r.Codigo__c,Prestacion__r.Contexto__c,Prestacion_CA__c, Observaciones__c, Tipo__c,
						Medicamento__r.Codigo_medicamento__c,Grupo_de_Prestaciones__r.Codigo__c, Contexto__c, 
						Importe_cargo_al_socio_auditor__c, Importe_convenio_auditor__c, Importe_plan_auditor__c
				FROM Prestacion__c
				WHERE Ap__c = :caseFromSF.Id
		];

		Map<String,Prestacion__c> prestacionesMap = new Map<String,Prestacion__c>();
		Map<String,Prestacion__c> medicamentosMap = new Map<String,Prestacion__c>();
		Map<String,Prestacion__c> grupoPresMap = new Map<String,Prestacion__c>();
		Evento_medico__c em;
		Segmentos__c segToUpdate;

		for(Prestacion__c prest : prestaciones) {
			switch on prest.Tipo__c{
				when 'M'{
					medicamentosMap.put(prest.Medicamento__r.Codigo_medicamento__c,prest);
				}
				when 'N'{
					prestacionesMap.put(prest.Prestacion__r.Codigo__c,prest);
				}
				when 'G'{
					grupoPresMap.put(prest.Prestacion__r.Codigo__c,prest);
				}
			}
		}

		caseFromSF.Cambio_Manual__c = false;
		caseFromSF.Nro_AP__c = ap.apr_id;
		caseFromSF.Status = ap.estado;
		caseFromSF.Nivel_de_derivacion__c = ap.nivel;
		//caseFromSF.Urgente__c = ap.urgente;
		caseFromSF.Categorizacion_SS__c = ap.clasificacion;
		caseFromSF.Type = ap.tipo_ap_sf;
		caseFromSF.Tiempo_SLA__c = ap.sla;
		//caseFromSF.Ap_Material__c = ap.ap_material == 'V';
		//caseFromSF.Ap_Presupuesto__c = ap.ap_presupuesto == 'V';
		
		if(String.isNotBlank(ap.celula)) {
			caseFromSF.Celula__c = ap.celula;
		}

		Database.SaveResult result = Database.update(caseFromSF);
		System.debug('****resultCasos: ' + result);
		if(!result.isSuccess()){
			for(Database.Error err : result.getErrors()){
				msg = msg + err.getMessage() + '\n';
			}
		}
		List<Prestacion__c> prestacionesToUpdate = new List<Prestacion__c>();
		List<Alerta__c> alertasToUpsert = new List<Alerta__c>();
		Map<String, Nomenclador_de_Prestacion__c> nomencladoresToUpsert = new Map<String, Nomenclador_de_Prestacion__c>();
		Map<String, Medicamento__c> medicamentosToUpsert = new Map<String, Medicamento__c>();
		Map<String, Grupo_de_Prestaciones__c> gruposToUpsert = new Map<String, Grupo_de_Prestaciones__c>();
		for(WSCaseAPGenerarCentroResp.Prestaciones prestWS : ap.prestaciones){
			Prestacion__c prestToUpdate;

			switch on prestWS.tipo_prestacion{
				when 'M'{
					prestToUpdate = medicamentosMap.get(prestWS.prestacion);
				}
				when 'N'{
					prestToUpdate = prestacionesMap.get(prestWS.prestacion);
				}
				when 'G'{
					prestToUpdate = grupoPresMap.get(prestWS.prestacion);
				}
			}

			if(prestToUpdate == null){
				prestToUpdate = new Prestacion__c();

				prestToUpdate.Cantidad__c = Decimal.valueOf(prestWS.cantidad);
				prestToUpdate.Ap__c = caseFromSF.Id;
				prestToUpdate.Tipo__c = prestWS.tipo_prestacion;
				prestToUpdate.Observaciones__c = prestWS.texto_aclarativo;
				switch on prestWS.tipo_prestacion{
					when 'N'{
						prestToUpdate.Prestacion__r = new Nomenclador_de_Prestacion__c(Codigo__c = prestWS.prestacion); 
						if (!nomencladoresToUpsert.containsKey(prestWS.prestacion)) {
							Nomenclador_de_Prestacion__c nomenclador = 
								new Nomenclador_de_Prestacion__c(Codigo__c = prestWS.prestacion);
							nomencladoresToUpsert.put(prestWS.prestacion, nomenclador);
						}
					}
					when 'M'{
						prestToUpdate.Medicamento__r = new Medicamento__c(Codigo_medicamento__c = prestWS.prestacion); 
						if (!medicamentosToUpsert.containsKey(prestWS.prestacion)) {
							Medicamento__c medicamento = 
								new Medicamento__c(Codigo_medicamento__c = prestWS.prestacion);
							medicamentosToUpsert.put(prestWS.prestacion, medicamento);
						}
					}
					when 'G'{
						prestToUpdate.Grupo_de_Prestaciones__r = new Grupo_de_Prestaciones__c(Codigo__c = prestWS.prestacion); 
						if (!gruposToUpsert.containsKey(prestWS.prestacion)) {
							Grupo_de_Prestaciones__c grupo = 
								new Grupo_de_Prestaciones__c(Codigo__c = prestWS.prestacion);
							gruposToUpsert.put(prestWS.prestacion, grupo);
						}
					}
				}
			}
			System.debug('contexto ' + prestWs.contexto);
			prestToUpdate.Contexto__c = prestWs.contexto;
			prestToUpdate.Cambio_automatico__c = true;
			prestToUpdate.Estado__c = prestWS.estado_prestacion;
			prestToUpdate.Prestacion_CA__c = prestWS.pca_id;
			prestToUpdate.Texto_aclarativo_alerta__c = prestWS.texto_aclarativo;
			prestToUpdate.Alerta__c = prestWS.alerta;
			prestToUpdate.Nombre_de_Prestacion__c = prestWS.nombre_prestacion;
			prestToUpdate.Importe_plan_sys__c = prestWS.importe_plan_sys != null 
													? Decimal.valueOf(prestWS.importe_plan_sys) : null;
			prestToUpdate.Importe_plan_auditor__c = prestWS.importe_plan_aud != null 
														? Decimal.valueOf(prestWS.importe_plan_aud) : null;
			prestToUpdate.Importe_convenio_sys__c = prestWS.importe_convenio_sys != null 
														? Decimal.valueOf(prestWS.importe_convenio_sys) : null;
			prestToUpdate.Importe_convenio_auditor__c = prestWS.importe_convenio_aud != null 
														? Decimal.valueOf(prestWS.importe_convenio_aud) : null;
			prestToUpdate.Importe_cargo_al_socio_sys__c = prestWS.importe_cargo_al_socio_sys!= null 
														? Decimal.valueOf(prestWS.importe_cargo_al_socio_sys) : null;
			prestToUpdate.Importe_cargo_al_socio_auditor__c = prestWS.importe_cargo_al_socio_aud!= null 
														? Decimal.valueOf(prestWS.importe_cargo_al_socio_aud) : null;

			prestacionesToUpdate.add(prestToUpdate);

			for(WSCaseAPGenerarCentroResp.Alertas alert : prestWS.alertas){
				Alerta__c alertPres = new Alerta__c();

				alertPres.Prestacion__r = new Prestacion__c(Prestacion_CA__c = prestWS.pca_id);
				alertPres.Control__c = alert.control;
				alertPres.Funcion__c = alert.funcion;
				alertPres.Texto_aclarativo__c = alert.texto_aclarativo;
				alertPres.Nivel_de_auditoria__c = alert.nivel_auditoria == null ? null : Decimal.valueOf(alert.nivel_auditoria);
				alertPres.Fecha_de_generacion_de_Alerta__c = alert.fecha_generacion != null ?
						Date.valueOf(alert.fecha_generacion.substringBefore(' ')) :
						null;
				alertPres.Lectura_de_alerta_auditor__c = alert.auditor_lee;
				alertPres.Resolucion_de_alerta_auditor__c = alert.auditor_resuelve;
				alertPres.Fecha_resolucion_de_Alerta__c = alert.fecha_resolucion != null ?
						Date.valueOf(alert.fecha_resolucion.substringBefore(' ')) :
						null;
				alertPres.idalerta__c = alert.aca_id;
				alertPres.Estado__c = alert.estado_alerta;

				if(ap.evento_medico != null) {
					alertPres.Evento_Medico__r = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = ap.evento_medico);
				}

				alertasToUpsert.add(alertPres);
			}
		}

		if(String.isNotBlank(caseFromSF.Evento_Medico__c) 
			&& ap.estado_em == 'AUTORIZADO' 
			&& caseFromSF.Evento_Medico__r.Estado__c != 'AUTORIZADO'
		) {
			em = new Evento_medico__c();
			em.Cambio_Manual__c = false;
			em.Id = caseFromSF.Evento_Medico__c;
			em.Estado__c = ap.estado_em;

			if(!segmentos.isEmpty()) {
				segToUpdate = segmentos[0];
				segToUpdate.Estado__c = ap.estado_em;
			}
		}

		Database.UpsertResult[] resultNomencladores = Database.upsert(nomencladoresToUpsert.values(),
                Nomenclador_de_Prestacion__c.Codigo__c, false);
        System.debug('****resultNomencladores ' + resultNomencladores);

		Database.UpsertResult[] resultMedicamentos = Database.upsert(medicamentosToUpsert.values(),
                Medicamento__c.Codigo_medicamento__c, false);
        System.debug('****resultMedicamentos ' + resultMedicamentos);

		Database.UpsertResult[] resultGrupos = Database.upsert(gruposToUpsert.values(),
                Grupo_de_Prestaciones__c.Codigo__c, false);
        System.debug('****resultGrupos ' + resultGrupos);

		Database.UpsertResult[] resultPrests = Database.upsert(prestacionesToUpdate, false);
		System.debug('****resultPrests: ' + resultPrests);
		for(Database.UpsertResult res : resultPrests){
			if(!res.isSuccess()){
				for(Database.Error err : res.getErrors()){
					msg = msg + err.getMessage() + '\n';
				}
			}
		}



		Database.UpsertResult[] resultAlerts = Database.upsert(alertasToUpsert, Alerta__c.idalerta__c,false);
		System.debug('****resultAlerts: ' + resultAlerts);
		for(Database.UpsertResult res : resultAlerts){
			if(!res.isSuccess()){
				for(Database.Error err : res.getErrors()){
					msg = msg + err.getMessage() + '\n';
				}
			}
		}

		if(em != null) {
			Database.SaveResult resultEm = Database.update(em);
			System.debug('****resultEm: ' + resultEm);
		}

		if(segToUpdate != null) {
			Database.SaveResult resultSegmento = Database.update(segToUpdate);
			System.debug('****resultSegmento: ' + resultSegmento);
		}

		return msg;

	}

	private static Response sendToSS(Case caseFromSF, Segmentos__c[] segmentos) {
		System.debug('sendToSS');
		List<Prestacion__c> prestaciones = [
				SELECT Id, Alerta__c, Cantidad__c, Nombre_de_Prestacion__c, Prestacion__r.Tipo_Nomenclador__c,
						Prestacion__r.Codigo__c, Prestacion__r.Contexto__c, Observaciones__c, Contexto__c,
						Tipo__c, Grupo_de_Prestaciones__r.Codigo__c, Medicamento__r.Codigo_medicamento__c,
						Importe_cargo_al_socio_auditor__c, Importe_convenio_auditor__c, Importe_plan_auditor__c
				FROM Prestacion__c
				WHERE Ap__c = :caseFromSF.Id
		];

		String strObjPrefix = String.valueOf(caseFromSF.OwnerId).substring(0, 3);

        
        Boolean isUserInqueue = false;
		if(strObjPrefix == Group.sObjectType.getDescribe().getKeyPrefix()){            
			Group cola = [
				SELECT Id 
				FROM Group
				WHERE Type = 'Queue' AND Id = :caseFromSF.OwnerId
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
        User usuario = [
			SELECT CommunityNickname, Profile.Name, UserRole.DeveloperName, Codigo_delegacion__c 
			FROM User 
			WHERE Id = :UserInfo.getUserId()
		];
        
		String nick =  usuario.CommunityNickname != null ? usuario.CommunityNickname.toUppercase() : null;
        System.debug('usuario ' + usuario + ' nombre perfil ' + usuario.Profile.Name);
        System.debug( ADMIN_PROFILES.contains(usuario.Profile.Name) );
		Boolean propietario = ADMIN_PROFILES.contains(usuario.Profile.Name) || (isUserInqueue ? isUserInqueue : caseFromSF.OwnerId == usuario.Id);
		
		
		if(caseFromSF.Nivel_de_derivacion__c == null && !propietario) {
			return new Response(true, 'El usuario no es el propietario');
		}

		//if( !Utils.perteneceALaDelegacionCorrecta(caseFromSf, usuario) ) {	
			//return new Response(true, 'El usuario puede modificar casos de su delegación solamente');
		//}

		String body = generateJSON(caseFromSF, prestaciones,nick);

		WSCasoEnviarASS.Response wsResp = WSCasoEnviarASS.enviarCaso(body);
		Boolean updateSucc = true;
		System.debug('****wsResp.hasError: ' + wsResp.hasError);
		if(wsResp.hasError) {
			return new Response(wsResp.hasError,wsResp.message);
		}
		String msg = '';
		List<String> idContentVersionList = new List<String>(); 
        List<EmailMessage> emailMessagesCase = [
            SELECT Id 
            FROM EmailMessage
            WHERE ParentId = :caseFromSf.Id
        ];
        
		List<ContentDocumentLink> linksList = [
				SELECT LinkedEntityId, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ShareType,
					ContentDocument.FileType, ContentDocument.FileExtension
				FROM ContentDocumentLink
				WHERE LinkedEntityId =: caseFromSf.Id
            	OR LinkedEntityId IN :emailMessagesCase
		];

		for(ContentDocumentLink cdl : linksList) {
			idContentVersionList.add(cdl.ContentDocument.LatestPublishedVersionId);
		}

		List<ContentVersion> cvList = [
			SELECT Id
			FROM ContentVersion 
			WHERE Id IN :idContentVersionList AND Enviado__c = false 
		];
		List<Id> docIds = new List<Id>();
		for(ContentVersion cv : cvList){
			docIds.add(cv.Id);
		}

        for(WSCaseAPGenerarCentroResp.Ap caso : wsResp.result.data.ap){
            if(caso.nro_sf == caseFromSF.Id){
				msg = msg + updateCase(caseFromSF, caso, segmentos);
				System.enqueueJob(new ArchivosCargaQueueable(caso.apr_id, 'autorizacion',nick, docIds));
                /*WSArchivosCarga.Response respuesta = sendFiles(caseFromSF, nick, caso.apr_id);
				if(!respuesta.hasError){
					updateArchivosUrl(caseFromSF);
					
				}*/
                
            }
            else {
                msg = msg + createCase(caso,caseFromSF);
            }
        }
		System.debug('****wsResp.hasError: ' + wsResp.hasError);
		System.debug('****updateSucc: ' + updateSucc);

		return new Response(wsResp.hasError && !updateSucc, updateSucc ? wsResp.message : msg);
	}

	/*private static WSArchivosCarga.Response sendFiles(Case reintegroFromSF, String nick, String apr_id) {	
		Map<String, Object> bodyMap = new Map<String, Object>{
			'tipo_tramite' => 'autorizacion',
			'id' => apr_id,
			'usuario' => nick,
			'archivos' => generateFilesJSON(reintegroFromSF)
		};

		WSArchivosCarga.Response archivosCargaResp = WSArchivosCarga.uploadFiles(JSON.serialize(bodyMap), null);  
		return archivosCargaResp;
	}

	public static List<Map<String, Object>> generateFilesJSON(Case caso) {
		Archivo_url__c[] files = [
			SELECT Id, Link__c, Ruta_relativa__c, Name, Enviado__c
			FROM Archivo_url__c 
			WHERE Caso__c = :caso.Id
					AND Enviado__c = false
		];
		List<Map<String, Object>> filesJSON = new List<Map<String, Object>>();
		for(Archivo_url__c file : files) {
			//System.debug('file.Name: ' + file.Name);
			Map<String, Object> fileJSON = new Map<String, Object> {
				'url_absoluta' => file.Link__c,
				'url' => file.Ruta_relativa__c,
				'nombre' => file.Name.toUpperCase()
			};

			filesJSON.add(fileJSON);
		}

		System.debug('****filesJSON: ' + filesJSON);
		return filesJSON;
	}

	public static void updateArchivosUrl(Case caso) {
		Archivo_url__c[] files = [
			SELECT Id, Enviado__c
			FROM Archivo_url__c 
			WHERE Caso__c = :caso.Id
					AND Enviado__c = false
		];
        
		for(Archivo_url__c file : files) {
			file.Enviado__c = true;
		}

		update files;
	}*/

	private static String createCase(WSCaseAPGenerarCentroResp.Ap ap, Case parentCase) {
		String msg = '';
		Map<String,Prestacion__c> prestacionesMap = new Map<String,Prestacion__c>();
		Map<String,Prestacion__c> medicamentosMap = new Map<String,Prestacion__c>();
		Map<String,Prestacion__c> grupoPresMap = new Map<String,Prestacion__c>();

		Case caseFromSF = new Case();
		if(ap.ap_material == 'V') {
			caseFromSF.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
			caseFromSF.Sub_tipo__c = 'Material';
		} 
		else if(ap.ap_presupuesto == 'V') {
			caseFromSF.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
			caseFromSF.Sub_tipo__c = 'Presupuesto';
		}

		caseFromSF.Cambio_Manual__c = false;
		caseFromSF.Nro_AP__c = ap.apr_id;
		caseFromSF.Status = ap.estado;
		caseFromSF.Nivel_de_derivacion__c = ap.nivel;
		//caseFromSF.Urgente__c = ap.urgente;
		caseFromSF.Categorizacion_SS__c = ap.clasificacion;
		caseFromSF.Type = ap.tipo_ap_sf;
		caseFromSF.ParentId = parentCase.Id;
		caseFromSF.Fecha_probable__c = Date.valueOf(ap.fecha_probable);
		caseFromSF.Fecha__c = Date.valueOf(ap.fecha);
		caseFromSF.Mail__c = ap.mail;
		caseFromSF.Observaciones__c = ap.observaciones;
		caseFromSF.Otros_Mail__c = ap.otros_mail;
		caseFromSF.Delegacion__c = parentCase.Delegacion__c;
		caseFromSF.Prescriptor__c = parentCase.Prescriptor__c;
		caseFromSF.Fecha_prescripcion__c = parentCase.Fecha_prescripcion__c;
		caseFromSF.Evento_Medico__c = parentCase.Evento_Medico__c;
		caseFromSF.Tiempo_SLA__c = ap.sla;
		//caseFromSF.Ap_Material__c = ap.ap_material == 'V';
		//caseFromSF.Ap_Presupuesto__c = ap.ap_presupuesto == 'V';
		caseFromSF.AccountId = parentCase.AccountId;
		caseFromSF.Diagnostico__r = ap.diagnostico != null ? new Diagnostico__c(Codigo_del_Diagnostico__c = ap.diagnostico) : null;

		if(String.isNotBlank(ap.celula)) {
			caseFromSF.Celula__c = ap.celula;
		}
		
		Database.SaveResult result = Database.insert(caseFromSF);
		System.debug('****resultCasos: ' + result);
		
		if(!result.isSuccess()){
			for(Database.Error err : result.getErrors()){
				msg = msg + err.getMessage() + '\n';
			}
		}
		
		List<Prestacion__c> prestacionesToUpdate = new List<Prestacion__c>();
		List<Alerta__c> alertasToUpsert = new List<Alerta__c>();
		Map<String, Nomenclador_de_Prestacion__c> nomencladoresToUpsert = new Map<String, Nomenclador_de_Prestacion__c>();
		Map<String, Medicamento__c> medicamentosToUpsert = new Map<String, Medicamento__c>();
		Map<String, Grupo_de_Prestaciones__c> gruposToUpsert = new Map<String, Grupo_de_Prestaciones__c>();

		for(WSCaseAPGenerarCentroResp.Prestaciones prestWS : ap.prestaciones){
			Prestacion__c prestToUpdate = new Prestacion__c();

			prestToUpdate.Cambio_automatico__c = true;
			prestToUpdate.Cantidad__c = Decimal.valueOf(prestWS.cantidad);
			prestToUpdate.Tipo__c = prestWS.tipo_prestacion;
			prestToUpdate.Ap__r = new Case(Nro_Ap__c = ap.apr_id);
			prestToUpdate.Observaciones__c = prestWS.texto_aclarativo;
			switch on prestWS.tipo_prestacion{
				when 'N'{
					prestToUpdate.Prestacion__r = new Nomenclador_de_Prestacion__c(Codigo__c = prestWS.prestacion); 
					if (!nomencladoresToUpsert.containsKey(prestWS.prestacion)) {
						Nomenclador_de_Prestacion__c nomenclador = 
							new Nomenclador_de_Prestacion__c(Codigo__c = prestWS.prestacion);
						nomencladoresToUpsert.put(prestWS.prestacion, nomenclador);
					}
				}
				when 'M'{
					prestToUpdate.Medicamento__r = new Medicamento__c(Codigo_medicamento__c = prestWS.prestacion); 
					if (!medicamentosToUpsert.containsKey(prestWS.prestacion)) {
						Medicamento__c medicamento = 
							new Medicamento__c(Codigo_medicamento__c = prestWS.prestacion);
						medicamentosToUpsert.put(prestWS.prestacion, medicamento);
					}
				}
				when 'G'{
					prestToUpdate.Grupo_de_Prestaciones__r = new Grupo_de_Prestaciones__c(Codigo__c = prestWS.prestacion); 
					if (!gruposToUpsert.containsKey(prestWS.prestacion)) {
						Grupo_de_Prestaciones__c grupo = 
							new Grupo_de_Prestaciones__c(Codigo__c = prestWS.prestacion);
						gruposToUpsert.put(prestWS.prestacion, grupo);
					}
				}
			}
			prestToUpdate.Estado__c = prestWS.estado_prestacion;
			prestToUpdate.Prestacion_CA__c = prestWS.pca_id;
			prestToUpdate.Texto_aclarativo_alerta__c = prestWS.texto_aclarativo;
			prestToUpdate.Alerta__c = prestWS.alerta;
			prestToUpdate.Nombre_de_Prestacion__c = prestWS.nombre_prestacion;
			prestToUpdate.Importe_plan_sys__c = prestWS.importe_plan_sys != null 
													? Decimal.valueOf(prestWS.importe_plan_sys) : null;
			prestToUpdate.Importe_plan_auditor__c = prestWS.importe_plan_aud != null 
														? Decimal.valueOf(prestWS.importe_plan_aud) : null;
			prestToUpdate.Importe_convenio_sys__c = prestWS.importe_convenio_sys != null 
														? Decimal.valueOf(prestWS.importe_convenio_sys) : null;
			prestToUpdate.Importe_convenio_auditor__c = prestWS.importe_convenio_aud != null 
														? Decimal.valueOf(prestWS.importe_convenio_aud) : null;
			prestToUpdate.Importe_cargo_al_socio_sys__c = prestWS.importe_cargo_al_socio_sys!= null 
														? Decimal.valueOf(prestWS.importe_cargo_al_socio_sys) : null;
			prestToUpdate.Importe_cargo_al_socio_auditor__c = prestWS.importe_cargo_al_socio_aud!= null 
														? Decimal.valueOf(prestWS.importe_cargo_al_socio_aud) : null;

			prestacionesToUpdate.add(prestToUpdate);

			for(WSCaseAPGenerarCentroResp.Alertas alert : prestWS.alertas){
				Alerta__c alertPres = new Alerta__c();

				alertPres.Prestacion__r = new Prestacion__c(Prestacion_CA__c = prestWS.pca_id);
				alertPres.Control__c = alert.control;
				alertPres.Funcion__c = alert.funcion;
				alertPres.Texto_aclarativo__c = alert.texto_aclarativo;
				alertPres.Nivel_de_auditoria__c = alert.nivel_auditoria == null ? null : Decimal.valueOf(alert.nivel_auditoria);
				alertPres.Fecha_de_generacion_de_Alerta__c = alert.fecha_generacion != null ?
						Date.valueOf(alert.fecha_generacion.substringBefore(' ')) :
						null;
				alertPres.Lectura_de_alerta_auditor__c = alert.auditor_lee;
				alertPres.Resolucion_de_alerta_auditor__c = alert.auditor_resuelve;
				alertPres.Fecha_resolucion_de_Alerta__c = alert.fecha_resolucion != null ?
						Date.valueOf(alert.fecha_resolucion.substringBefore(' ')) :
						null;
				alertPres.idalerta__c = alert.aca_id;
				alertPres.Estado__c = alert.estado_alerta;

				if(ap.evento_medico != null) {
					alertPres.Evento_Medico__r = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = ap.evento_medico);
				}

				alertasToUpsert.add(alertPres);
			}
		}

		Database.UpsertResult[] resultNomencladores = Database.upsert(nomencladoresToUpsert.values(),
                Nomenclador_de_Prestacion__c.Codigo__c, false);
        System.debug('****resultNomencladores ' + resultNomencladores);

		Database.UpsertResult[] resultMedicamentos = Database.upsert(medicamentosToUpsert.values(),
                Medicamento__c.Codigo_medicamento__c, false);
        System.debug('****resultMedicamentos ' + resultMedicamentos);

		Database.UpsertResult[] resultGrupos = Database.upsert(gruposToUpsert.values(),
                Grupo_de_Prestaciones__c.Codigo__c, false);
        System.debug('****resultGrupos ' + resultGrupos);

		Database.SaveResult[] resultPrests = Database.insert(prestacionesToUpdate,false);
		System.debug('****resultPrests: ' + resultPrests);
		for(Database.SaveResult res : resultPrests){
			if(!res.isSuccess()){
				for(Database.Error err : res.getErrors()){
					msg = msg + err.getMessage() + '\n';
				}
			}
		}



		Database.UpsertResult[] resultAlerts = Database.upsert(alertasToUpsert, Alerta__c.idalerta__c,false);
		System.debug('****resultAlerts: ' + resultAlerts);
		for(Database.UpsertResult res : resultAlerts){
			if(!res.isSuccess()){
				for(Database.Error err : res.getErrors()){
					msg = msg + err.getMessage() + '\n';
				}
			}
		}
		return msg;

	}

	private static String generateJSON(Case caseFromSF,List<Prestacion__c> prestaciones, String username){
		String jsonS;
		String contextoAP = prestaciones.isEmpty() ? null : prestaciones[0].Contexto__c;
		String chkMaterial = caseFromSF.AP_Material__c ? 'V' : 'F';
		String chkPresupuesto = caseFromSF.AP_Presupuesto__c ? 'V' : 'F';
		List<Object> prestacionesStr = new List<Object>();
		String formaPago = caseFromSF.Orden_de_Compra__r.Estado_OC__c == 'Desestimada' ? 'D' 
							: caseFromSF.Orden_de_Compra__r.forma_de_Pago__c;
		
		for(Prestacion__c prest : prestaciones){
			Map<String, Object> prestJSON = new Map<String, Object> {
					'importe_g_plan_aud' => prest.Importe_plan_auditor__c != null 
											? String.valueOf(prest.Importe_plan_auditor__c) : null,
					'importe_cargo_al_socio_aud' => prest.Importe_cargo_al_socio_auditor__c != null 
											? String.valueOf(prest.Importe_cargo_al_socio_auditor__c) : null,
					'importe_g_convenio_aud' => prest.Importe_convenio_auditor__c != null 
											? String.valueOf(prest.Importe_convenio_auditor__c) : null,
					'cantidad' => prest.Cantidad__c,
					'nom_prestacion_pdh' => codigoPrestacion(prest),
					'tipo_prestacion' => prest.Tipo__c,
					'observaciones' => prest.Observaciones__c,
					'contexto' => prest.Contexto__c,
					'alerta' => prest.Alerta__c
			};
			
			if(prest.Tipo__c == 'G') {
				prestJSON.put('grupo_prestaciones', codigoPrestacion(prest));
				prestJSON.put('nom_prestacion_pdh', null);
			}

			prestacionesStr.add(prestJSON);
		}
		Map<String,Object> jsonMap = new Map<String, Object> {
				'fecha' => String.valueOf(caseFromSF.Fecha__c),
				'forma_pago' => formaPago,
				'fecha_prob' => caseFromSF.Fecha_probable__c == null ? null : String.valueOf(caseFromSF.Fecha_probable__c),
				'agencia_codigo' => caseFromSF.Delegacion__r.Codigo_de_delegacion__c,
				'user_insert' => username,
				'codigo_afiliado' => caseFromSF.Account.Codigo_de_Afiliado__c,
				'evento_medico_id' => caseFromSF.Evento_Medico__r.Nro_de_Evento_Medico_SS__c,
				'fecha_pres' => caseFromSF.Fecha_prescripcion__c == null ? null : String.valueOf(caseFromSF.Fecha_prescripcion__c),
				'codigo_diagnostico' => caseFromSF.Diagnostico__r.Codigo_del_Diagnostico__c,
				'efectores_prestador' => caseFromSF.Prescriptor__r.Codigo_de_efector__c,
				'prestador' => caseFromSF.Prestador__r.Codigo_de_efector__c,
				//'consultorio' => caseFromSF.Consultorio__r.Codigo_externo__c,
				'consultorio' => caseFromSF.Consultorio__r.Secuencia__c != null 
									? String.valueOf(caseFromSF.Consultorio__r.Secuencia__c) : null,
				'observaciones' => caseFromSF.Observaciones__c,
				'mail' => caseFromSF.Mail__c,
				'otros_mail' => caseFromSF.Otros_Mail__c,
				'contexto' => contextoAP,
				'chk_material' => chkMaterial,
				'chk_presupuesto' => chkPresupuesto,
				'numero_sf' => caseFromSF.Id,
				'prestaciones' => prestacionesStr,
				'urgente' => caseFromSF.Urgente__c
			 };
		if(chkPresupuesto == 'V'){
			jsonMap.put('importe_presupuesto',caseFromSF.Importe_presupuesto__c);
		}
		if(caseFromSF.Nro_AP__c != null){
			jsonMap.put('numero_ap',caseFromSF.Nro_AP__c);
		}
		jsonS = JSON.serialize(jsonMap);

		
		return jsonS;
	}

	static String codigoPrestacion(Prestacion__c pres){

		switch on pres.Tipo__c {
			when 'N'{
				return pres.Prestacion__r.Codigo__c;
			}
			when 'G'{
				return pres.Grupo_de_Prestaciones__r.Codigo__c;
			}
			when 'M' {
				return pres.Medicamento__r.Codigo_medicamento__c;
			}
			when else {
				return '';
			}
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