public without sharing class CaseReintegroEnviarASSBtnCtrl  {
	static final String[] ADMIN_PROFILES = new List<String> {
		'Administrador del sistema', 
		'System Administrator',
		'Administrador de Servicio'
	};


	@AuraEnabled
    public static Boolean hasAttachments(Id reinId) {

        List<ContentDocumentLink> dbLinks = [
                SELECT LinkedEntityId,ContentDocumentId,ContentDocument.LatestPublishedVersionId
                FROM ContentDocumentLink
                WHERE LinkedEntityId =: reinId
        ];

        return !dbLinks.isEmpty();
    }

	@AuraEnabled
	public static Response sendReintegroToSS(Id idReintegro){
		Case reintegroFromSF = [
			SELECT Id,Fecha__c,Fecha_probable__c,Delegacion__r.Codigo_de_delegacion__c, Consultorio__r.Secuencia__c,
				Account.Codigo_de_Afiliado__c,Fecha_prescripcion__c,Diagnostico__r.Codigo_del_Diagnostico__c,
				Prestador__r.Codigo_de_efector__c,Consultorio__r.Codigo_externo__c,Observaciones__c,Mail__c,
				Otros_Mail__c,Evento_Medico__r.Nro_de_Evento_Medico_SS__c,AP_Material__c,AP_Presupuesto__c,Prescriptor__r.Codigo_de_efector__c,
				Status,Nro_AP__c,Categorizacion_SS__c,Nivel_de_derivacion__c,Importe_presupuesto__c, Cobro_indebido__c,
				Efector_realizador__r.Codigo_de_efector__c, Razon_social__c, Lote__r.Id_lote_SS__c, CUIT__c, Tipo_de_Comprobante__c,
				Codigo_reintegro_SS__c, Importe_reintegro__c, OwnerId,
				(
					SELECT Id, Cantidad__c, Importe_total__c, Importe_a_pagar__c, Fecha_de_realizacion__c, Contexto__c,
						Pieza_dental__c, Caras__c, RecordTypeId, Observaciones__c, Alerta__c, Medicamento__r.Codigo_medicamento__c,
						Prestacion_odonto__r.Codigo__c, Prestacional__r.Codigo__c, Fecha_de_dispensa__c, HD__c
					FROM Prestaciones_de_reintegros__r
				)
			FROM Case
			WHERE Id = :idReintegro
		];
		User usuario = [
			SELECT CommunityNickname, Profile.Name, UserRole.DeveloperName, Codigo_delegacion__c
			FROM User
			WHERE Id = :UserInfo.getUserId()
		];

		Response validation = validations(reintegroFromSF, usuario);
		if(validation.message != 'ok') {
			return validation;
		}

		String nick = usuario.CommunityNickname != null ? usuario.CommunityNickname.toUpperCase() : null;

		String body = generateJson(reintegroFromSF, nick);
		WSCaseReintegroEnviarASS.Response resp = WSCaseReintegroEnviarASS.enviarReintegro(body);
		
		if(!resp.hasError) {
			updateReintegro(reintegroFromSF, resp);
			sendFiles(reintegroFromSF, nick, resp);
			return new Response(false, 'ok');
			/*WSArchivosCarga.Response filesResp = sendFiles(reintegroFromSF, nick, resp);
			if(!filesResp.hasError) {
				updateArchivosUrl(reintegroFromSF);
				CaseReintegroEnviarASSBtnCtrl.Response updateResp = updateReintegro(reintegroFromSF, resp);
				if(!updateResp.hasError) {
					return new Response(false, updateResp.message);
				}
				return new Response(true, updateResp.message);
			}
			//sendFiles(reintegroFromSF, nick, resp);
			return new Response(true, filesResp.message);*/
		}

		return new Response(true, resp.message);
	}

	private static Response validations(Case reintegro, User usuario) {
		String strObjPrefix = String.valueOf(reintegro.OwnerId).substring(0, 3);

        
        Boolean isUserInqueue = false;
		if(strObjPrefix == Group.sObjectType.getDescribe().getKeyPrefix()){            
			Group cola = [
				SELECT Id 
				FROM Group
				WHERE Type = 'Queue' AND Id = :reintegro.OwnerId
			];
			if(cola != null){
				List<GroupMember> gms = [
					SELECT Id,UserOrGroupId
					FROM GroupMember
					WHERE GroupId = :cola.Id
				];
				for(GroupMember gm : gms){
					if(gm.UserOrGroupId == usuario.Id){
						isUserInqueue = true;
                        break;
					}
				}
            }    
        }
     
		
        System.debug('usuario ' + usuario + ' nombre perfil ' + usuario.Profile.Name);
        System.debug( ADMIN_PROFILES.contains(usuario.Profile.Name) );
		Boolean propietario = ADMIN_PROFILES.contains(usuario.Profile.Name) || (isUserInqueue ? isUserInqueue : reintegro.OwnerId == usuario.Id);
		
		if(!hasAttachments(reintegro.Id)) {
			return new Response(false, 'No se puede enviar porque no tiene archivos adjuntos');
		}

		if(reintegro.Nivel_de_derivacion__c == null && !propietario) {
			return new Response(false, 'El usuario no es el propietario');
		}

		//if( !Utils.perteneceALaDelegacionCorrecta(reintegro, usuario) ) {	
			//return new Response(false, 'El usuario puede modificar casos de su delegación solamente');
		//}

		return new Response(false, 'ok');
	}

	/*private static WSArchivosCarga.Response sendFiles(Case reintegroFromSF, String nick, WSCaseReintegroEnviarASS.Response resp) {	
		Map<String, Object> bodyMap = new Map<String, Object>{
			'tipo_tramite' => 'reintegro',
			'id' => resp.result.data.reintegro.rei_id,
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

	private static void sendFiles(Case reintegroFromSF, String nick, WSCaseReintegroEnviarASS.Response resp) {
		List<String> idContentVersionList = new List<String>(); 
		List<ContentDocumentLink> linksList = [
				SELECT LinkedEntityId, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ShareType,
					ContentDocument.FileType, ContentDocument.FileExtension
				FROM ContentDocumentLink
				WHERE LinkedEntityId =: reintegroFromSF.Id
		];
		
		for(ContentDocumentLink cdl : linksList) {
			idContentVersionList.add(cdl.ContentDocument.LatestPublishedVersionId);
		}

		List<ContentVersion> cvList = [
			SELECT Id, VersionData, FileExtension, FileType, ContentUrl, Title, PathOnClient, Description, Enviado__c, ContentDocumentId 
			FROM ContentVersion
			WHERE Id IN :idContentVersionList AND Enviado__c = false 
		];
		List<Id> docsList = new List<Id>();
		for(ContentVersion cv : cvList){
			docsList.add(cv.Id);
		}
		
		System.debug(cvList);
		System.enqueueJob(new ArchivosCargaQueueable(resp.result.data.reintegro.rei_id, 'reintegro', nick, docsList));
	}

	public static String generateJson(Case reintegroFromSF, String username) {
		String medicamentoRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Medicamento').Id;
		String odontologicaRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Odontologica').Id;
		String prestacionalRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Prestacional').Id;

		String jsonS;
		List<Object> prestacionesStr = new List<Object>();
		String razonSocial60Char = reintegroFromSF.Razon_social__c?.length() > 60 
								? reintegroFromSF.Razon_social__c?.substring(0, 60) : reintegroFromSF.Razon_social__c;

		for(Prestacion_de_reintegro__c prest : reintegroFromSF.Prestaciones_de_reintegros__r) {
			String tipoPrest = getTypeCodeFromRT(prest);
			String fecha;
			if(tipoPrest == 'M') {
				fecha = prest.Fecha_de_dispensa__c != null ? String.valueOf(prest.Fecha_de_dispensa__c) : null;
			} 
			else {
				fecha = prest.Fecha_de_realizacion__c != null ? String.valueOf(prest.Fecha_de_realizacion__c) : null;
			}

			Map<String, Object> prestJSON = new Map<String, Object> {
				'observaciones' => prest.Observaciones__c, 
				'alerta' => prest.Alerta__c,
				'fecha' => fecha,
				'cara' => prest.Caras__c,
				'pieza_dental' => prest.Pieza_dental__c,
				'honorarios' => prest.HD__c,
				'importe_a_pagar' => prest.Importe_a_pagar__c != null 
										? String.valueOf(prest.Importe_a_pagar__c) : null,
				'importe_total' => prest.Importe_total__c != null 
										? String.valueOf(prest.Importe_total__c) : null,
				'tipo_prestacion' => getTypeCodeFromRT(prest),
				'cantidad' => prest.Cantidad__c,
				'contexto' => prest.Contexto__c,
				'nom_prestacion' => getCodigoPrestacion(prest),
				'numero_sf' => prest.Id
			};

			prestacionesStr.add(prestJSON);
		}
		
		Map<String,Object> jsonMap = new Map<String, Object> {
			'prestaciones' => prestacionesStr,
			'usuario' => username, 
			'numero_sf' => reintegroFromSF.Id,
			'em_id' => reintegroFromSF.Evento_Medico__r.Nro_de_Evento_Medico_SS__c,
			'cobro' => reintegroFromSF.Cobro_indebido__c ? 'S' : 'N',
			'efector_realizador' => reintegroFromSF.Efector_realizador__r.Codigo_de_efector__c,
			'efector_prescriptor' => reintegroFromSF.Prescriptor__r.Codigo_de_efector__c,
			'fecha_prescripcion' => reintegroFromSF.Fecha_prescripcion__c != null 
										? String.valueOf(reintegroFromSF.Fecha_prescripcion__c) : null,
			'codigo_diagnostico' => reintegroFromSF.Diagnostico__r.Codigo_del_Diagnostico__c,
			'observaciones' => reintegroFromSF.Observaciones__c,
			'importe' => reintegroFromSF.Importe_reintegro__c != null 
							? String.valueOf(reintegroFromSF.Importe_reintegro__c) : null,
			'fecha_comprobante' => null,
			'numero_comprobante' => null,
			'tipo_comprobante' => reintegroFromSF.Tipo_de_Comprobante__c,
			'razon_social' => razonSocial60Char,
			'cuit' => reintegroFromSF.CUIT__c,
			'codigo_afiliado' => reintegroFromSF.Account.Codigo_de_Afiliado__c,
			'agencia_codigo' => reintegroFromSF.Delegacion__r.Codigo_de_delegacion__c,
			'lote' => reintegroFromSF.Lote__r.Id_lote_SS__c,
			'fecha' => reintegroFromSF.Fecha__c != null 
						? String.valueOf(reintegroFromSF.Fecha__c) : null
		};
		
		if(reintegroFromSF.Codigo_reintegro_SS__c != null) {
			jsonMap.put('rein_id', reintegroFromSF.Codigo_reintegro_SS__c);
		}
		
		jsonS = JSON.serialize(jsonMap);
		
		return jsonS;
		
	}

	private static Response updateReintegro(Case reintegroFromSF, WSCaseReintegroEnviarASS.Response resp) {
		WSCaseReintegroEnviarASSResp.Reintegro reintegroWS = resp.result.data.reintegro;
		
		String nivel = reintegroWS.nivel;
		reintegroFromSF.Cambio_Manual__c = false;
		reintegroFromSF.Nivel_de_derivacion__c = nivel == 'N1' ? 'Nivel 1' 
												: nivel == 'N2' ? 'Nivel 2' 
												: nivel == 'N3' ? 'Nivel 3' 
												: null;
		reintegroFromSF.Celula__c = reintegroWS.celula;
		reintegroFromSF.Tiempo_SLA__c = reintegroWS.sla;
		reintegroFromSF.Codigo_reintegro_SS__c = reintegroWS.rei_id;
		reintegroFromSF.Existente_SS__c = true;
		reintegroFromSF.Status = Utils.translateStateReintegroToAP(reintegroWS.vda_drv_estado);
			
		List<Prestacion_de_reintegro__c> prestacionesToUpsert = new List<Prestacion_de_reintegro__c>();
		List<Alerta__c> alertasToUpsert = new List<Alerta__c>();

		for(WSCaseReintegroEnviarASSResp.Prestaciones prestWS : resp.result.data.reintegro.prestaciones) {
			Prestacion_de_reintegro__c pres = new Prestacion_de_reintegro__c();
			
			pres.Id = prestWS.nro_sf;
			pres.Caso__c = reintegroFromSF.Id; 
			pres.Id_Externo__c = prestWS.pca_id;
			pres.Estado__c = prestWS.estado_prestacion;
			pres.Importe_cargo_al_socio_auditor__c = prestWS.importe_cargo_al_socio_aud != null 
														? Decimal.valueOf(prestWS.importe_cargo_al_socio_aud) : null;
			pres.Importe_cargo_al_socio_sys__c = prestWS.importe_cargo_al_socio_sys != null 
													? Decimal.valueOf(prestWS.importe_cargo_al_socio_sys) : null;
			pres.Importe_Reintegro_auditor__c = prestWS.importe_rein_aud != null 
													? Decimal.valueOf(prestWS.importe_rein_aud) : null;
			pres.Importe_Reintegro_sys__c = prestWS.importe_rein_sys != null 
												? Decimal.valueOf(prestWS.importe_rein_sys) : null;

			prestacionesToUpsert.add(pres);

			for(WSCaseReintegroEnviarASSResp.Alertas alert : prestWS.alertas) {
				Alerta__c alertPres = new Alerta__c();

				alertPres.Prestacion_de_reintegro__r = new Prestacion_de_reintegro__c(Id_Externo__c = prestWS.pca_id);
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

				if(reintegroWS.em_em_id != null) {
					alertPres.Evento_Medico__r = new Evento_medico__c(Nro_de_Evento_Medico_SS__c = reintegroWS.em_em_id);
				}

				alertasToUpsert.add(alertPres);
			}


		}

		if(reintegroWS.link_rein != null) {
			attachPDF(reintegroWS, reintegroFromSF.Id);
		}

		Database.SaveResult resReintegro = Database.update(reintegroFromSF);
		System.debug('****resReintegro: ' + resReintegro);
		List<Database.SaveResult> resPrestaciones = Database.update(prestacionesToUpsert);
		System.debug('****resPrestaciones: ' + resPrestaciones);
		List<Database.UpsertResult> resAlertas = Database.upsert(alertasToUpsert, 
				Alerta__c.Fields.idalerta__c);
		System.debug('****resAlertas: ' + resAlertas);

		return new Response(false, 'ok'); 
	}

	private static void attachPDF(WSCaseReintegroEnviarASSResp.Reintegro reintegroWS, Id reiIdSF) {
		List<ContentDocumentLink> links = [
                SELECT LinkedEntityId, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, 
				ShareType, ContentDocument.FileType, ContentDocument.FileExtension
                FROM ContentDocumentLink
                WHERE LinkedEntityId =: reiIdSF AND ContentDocument.Title =: reintegroWS.rei_id
        ];
		
		if(String.isBlank(reintegroWS.link_rein)) {
			return;
		}

		if(!links.isEmpty()) {
			
			ContentVersion version = buildPDF(reintegroWS.link_rein, reintegroWS.rei_id, links[0].ContentDocumentId);
			insert version;

		} else {

			ContentVersion version = buildPDF(reintegroWS.link_rein, reintegroWS.rei_id, null);
			insert version;
		
			List<ContentVersion> versionsUpdated = [
					SELECT ContentDocumentId
					FROM ContentVersion
					WHERE Id = :version.Id
			];

			links.add(new ContentDocumentLink(
				LinkedEntityId = reiIdSF,
				ShareType = 'V',
				ContentDocumentId = versionsUpdated[0].ContentDocumentId
			));

			Database.SaveResult[] resultLinks = Database.insert(links, false);
			System.debug('****resultCDL: ' + resultLinks);
		}

	}

	private static ContentVersion buildPDF(String link, String idRein, String cdId){
		ContentVersion version = new ContentVersion();
		String formattedLink = link;
		PageReference pdf = new PageReference(formattedLink);
		Blob pdfBody;

		if(cdId != null) {
			version.ContentDocumentId = cdId;
		}

		version.PathOnClient = '/REIN_' + idRein + '.pdf';
		version.origin = 'H';
		version.Title = idRein;
		
		try {
			pdfBody = pdf.getContentAsPDF();
		} catch (Exception e) {
			pdfBody = Blob.valueOf('No se pudo generar el archivo pdf');
			System.debug('WTF');
			System.debug(e.getMessage());
		}

		version.VersionData = pdfBody;

		return version;
	}

	public static String getCodigoPrestacion(Prestacion_de_reintegro__c pres) {
		String tipo = getTypeCodeFromRT(pres);

		switch on tipo {
			when 'N'{
				return pres.Prestacional__r.Codigo__c;
			}
			when 'O'{
				return pres.Prestacion_odonto__r.Codigo__c;
			}
			when 'M' {
				return pres.Medicamento__r.Codigo_medicamento__c;
			}
			when else {
				return null;
			}
		}
	}

	public static String getTypeCodeFromRT(Prestacion_de_reintegro__c pres) {
		String medicamentoRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Medicamento').Id;
		String odontologicaRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Odontologica').Id;
		String prestacionalRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Prestacional').Id;

		if(pres.RecordTypeId == medicamentoRTId) {
			return 'M';
		} else if(pres.RecordTypeId == odontologicaRTId) {
			return 'O';
		} else if(pres.RecordTypeId == prestacionalRTId) {
			return 'N';
		}

		return null;
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