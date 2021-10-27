/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase controladora del botón CaseSendToSSGenericBtn, usado para enviár solicitudes a SS.
@date			26/10/2021
------------------------------------------------------------------------------------------------------------------------*/
@SuppressWarnings('PMD.ApexCRUDViolation, PMD.ExcessiveParameterList')
public without sharing class CaseSendToSSGenericBtnCtrl {
	/** Tipos de registro de solicitudes */
	private static Id solicitudAlta = XappiaHelper.getRecordType('Case', 'Solicitud_de_alta_familiar').Id;
	private static Id solicitudDespegue = XappiaHelper.getRecordType('Case', 'Solicitud_de_despegues').Id;
	private static Id solicitudDeBaja = XappiaHelper.getRecordType('Case', 'Solicitud_de_baja').Id;
	private static Id solicitudCambioSegmento = XappiaHelper.getRecordType('Case', 'Solicitud_de_segmento').Id;
	private static Id solicitudInterfazFinanciera = XappiaHelper.getRecordType('Case', 'Interfaz_financiera').Id;
	private static Id solicitudCredencial = XappiaHelper.getRecordType('Case', 'Solicitud_de_nueva_credencial').Id;
	private static Id solicitudPlan = XappiaHelper.getRecordType('Case', 'Solicitud_de_cambio_de_plan').Id;
	private static Id solicitudDatosParticulares = XappiaHelper.getRecordType('Case', 'Solicitud_de_datos_particulares').Id;
	/** Status de los mensajes al front */
	private static final String SUCCESS = 'success';
	private static final String ERROR = 'error';
	private static final String WARNING = 'warning';
	private static final String INFO = 'info';
	/** Variables estáticas */
	private static Case caso;
	private static List<Nota_de_Auditoria__c> notas;
	private static User usuario = [SELECT CommunityNickname, Profile.Name, UserRole.DeveloperName, Codigo_delegacion__c
									FROM User
									WHERE Id = :UserInfo.getUserId()];
	private static String userNick = usuario.CommunityNickname != null ? usuario.CommunityNickname.toUpperCase() : null;
	private static List<ContentVersion> files = new List<ContentVersion>();
	private static Boolean isAttachmentResend;
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método para envíar la solicitud a SS desde la interfaz del usuario.
	@param			recordId - Id del caso.
	@param			isAttachmentResend - Id del caso.
					sean creadas.
	------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static Response sendToSS(String recordId, Boolean isAttachmentResendFront) {
		isAttachmentResend = isAttachmentResendFront;
		if (isAttachmentResend) {
			caso = [SELECT id, RecordTypeId, Type FROM Case WHERE id = :recordId];
		} else {
			List<Case> casos = [SELECT id, RecordTypeId, Type FROM Case
					WHERE id = :recordId
						AND Estado_de_solicitud__c != 'TRANSFORMADA'
						AND Estado_de_solicitud__c != 'COMPLETA'];
			if (casos.size() > 0) {caso = casos[0];}
		}
		if (caso == null) return new Response(true, System.Label.Alerta_InvalidCaseClosed, '{}');
        Set<Id> dLinks = new Set<Id>();
        for (ContentDocumentLink cDL :[SELECT ContentDocumentId, Id FROM ContentDocumentLink WHERE LinkedEntityId = :recordId]) {
            dLinks.add(cDL.ContentDocumentId);
        }
        List<ContentVersion> generalFiles = [SELECT Id, VersionData, Title,Enviado__c, FileExtension, Description
												FROM ContentVersion
												WHERE ContentDocumentId IN :dLinks AND IsLatest = true];
		files = [SELECT Id, VersionData, Title, Enviado__c, FileExtension, Description
				FROM ContentVersion
				WHERE ContentDocumentId IN :dLinks
					AND IsLatest = true
					AND Enviado__c = false
				LIMIT 1];
		if(files.size() == 0 && isAttachmentResend) {
            return new Response(false, '', ''); // ??
        }
        if (generalFiles.isEmpty()
			&& caso.RecordtypeId != solicitudDatosParticulares
            && caso.RecordtypeId != solicitudCredencial) {
            return new Response(true, System.Label.Alerta_NoEnviarSInAdjuntos, '');
		}
		caso = getCaseInfo(recordId);
		notas = getNotas(recordId);
		if (caso.RecordTypeId == solicitudAlta) {return sendSolicitudAlta(recordId);}
		else if(caso.RecordTypeId == solicitudDespegue) {return sendSolicitudDespegue(recordId);}
		else if(caso.RecordTypeId == SolicitudDeBaja) {return sendSolicitudBaja(recordId);}
		else if(caso.RecordTypeId == solicitudCambioSegmento) {return sendSolicitudCambioSegmento(recordId);}
		else if(caso.RecordTypeId == solicitudInterfazFinanciera) {return sendInterfazFinanciera(recordId);}
		else if(caso.RecordTypeId == solicitudCredencial) {return sendSolicitudCambioCredencial(recordId);}
		else if(caso.RecordTypeId == solicitudPlan) {return sendSolicitudCambioPlan(recordId);}
		else if(caso.RecordTypeId == solicitudDatosParticulares) {return sendSolicitudDatosParticulares();}
		else {return new Response(true, System.Label.Alerta_CasoNoSolicitud, '');}
    }

    //=====================================[ PARSERS ]===========================================\\

    private static String parseDatosParticularesBody (Case caso, String userNick, User usuario) {
        try {
            Map<String, Object> encabezado = new Map<String, Object> {
                'sf_id' => caso.Id,
                'fecha_vigencia' => formatDate(caso.Fecha_de_vigencia__c),
                'agencia_codigo' => usuario.Codigo_delegacion__c,
                'usuario' => userNick,
                'afi_codigo' => (!String.isBlank(caso.Account.Codigo_de_Afiliado__c)) 
                                    ? getValueOf(caso.Account.Codigo_de_Afiliado__c) : '',
                'tipo_solicitud' => caso.Type
            };
            switch on caso.Type {
                when 'MODIF_DPART' {
                    encabezado.put('nombres', caso.Nombre__c);
                    encabezado.put('apellido', caso.Apellido__c);
                    encabezado.put('nacionalidad', getValueOf(caso.Nacionalidad__c));
                    encabezado.put('sexo', (!String.isBlank(caso.Sexo__c)) ? caso.Sexo__c.left(1).toUppercase() : '');
                    encabezado.put('e_civil', getValueOf(caso.Estado_civil__c));
                    encabezado.put('fecha_nac', formatDate(caso.Fecha_de_nacimiento__c));
                    encabezado.put('codigo_obrasocial', (!String.isBlank(caso.Obra_social2__c)) ? caso.Obra_social2__r.Codigo_de_obra_social__c : '');
                    encabezado.put('parentesco', getValueOf(caso.Tipo_de_parentesco__c));
                    encabezado.put('cuit', caso.CUIT__C);
                }
                when 'MODIF_DELEG' {
                    encabezado.put('agencia_destino', (caso.Delegacion__c != null) ? caso.Agencia_destino__r.codigo_de_delegacion__c : '');
                }
            }
            if(caso.Type != 'MODIF_DELEG') encabezado.put('afi_tipo', caso.Tipo__c);

			if(!String.isBlank(caso.Nro_de_solicitud_SS__c)) {
                encabezado.put('solicitud_id', caso.Nro_de_solicitud_SS__c);
            }

            return JSON.serialize(new Map<String,Object> {
                'encabezado' => new List<Object> {encabezado}
            });
        } catch (Exception e) {
            return '';
        }
    }

    private static String parseCambioPlanBody(Case caso, String userNick, List<ContentVersion> files, 
                                                        List<Nota_de_Auditoria__c> notasAuditoria, 
                                                        User usuario) {
        try {
            Map<String, Object> encabezado = new Map<String, Object> {
                'sf_id' => caso.Id,
                'fecha_vigencia' => formatDate(caso.Fecha_de_vigencia__c),
                'agencia_codigo' => usuario.Codigo_delegacion__c,
                'usuario' => userNick,
                'codigo_afi_titular' => (!String.isBlank(caso.Account.Codigo_de_Afiliado__c)) 
                                                ? getValueOf(caso.Account.Codigo_de_Afiliado__c) : '' ,
                'codigo_plan' => caso.Plandespegue__c
            };
            if(!String.isBlank(caso.Nro_de_solicitud_SS__c)) {
                encabezado.put('solicitud_id', caso.Nro_de_solicitud_SS__c);
                encabezado.put('estado_dj', caso.Estado_DDJJ__c);
            }
            
            return JSON.serialize(new Map<String, Object> {
                'encabezado' => new List<Object> {encabezado},
                'archivos' => parseFiles(files),
                'notas' => parseNotas(notasAuditoria)
            });
        } catch (Exception e) {

            return '';
        }
    }

    private static String parseInterfazFinanciera(Case caso, String userNick, List<ContentVersion> files, 
                                                    List<Nota_de_Auditoria__c> notasAuditoria, 
                                                    User usuario) {
        try {
            Map<String, Object> encabezado = new Map<String, Object> {
                'sf_id' => caso.Id,
                'fecha_vigencia' => formatDate(caso.Fecha_de_vigencia__c),
                'agencia_codigo' => usuario.Codigo_delegacion__c,
                'usuario' => userNick,
                'tipo_if' => caso.Type,
                'afi_codigo' => (!String.isBlank(caso.Account.Codigo_de_Afiliado__c))  
                                        ? getValueOf(caso.Account.Codigo_de_Afiliado__c) : ''
            };
            if(!String.isBlank(caso.Nro_de_solicitud_SS__c)) {
                encabezado.put('solicitud_id', caso.Nro_de_solicitud_SS__c);
                encabezado.put('estado_dj', caso.Estado_DDJJ__c);
            }
            //Reintegros
            if(caso.Type == 'T') {
                 encabezado.put('cbu_reintegros', caso.Numero_CBU__c);
                 encabezado.put('cuit', caso.CUIT_CUIL_Titular_CBU__c);
            }
            //Facturacion
            if(caso.Type == 'C') {
                encabezado.put('civa_codigo', XappiaHelper.stringToNumericString(String.valueOf(getValueOf(caso.Condicion_IVA__c))));
				
				if(caso.Borrar_tarjeta_debito_o_cobro_por_CBU__c) {
					encabezado.put('cobro_medio', '');
					encabezado.put('cobro_numero', '');    
				}
				else {
					if(!String.isBlank(caso.Tipo_CBU__c) && !String.isBlank(caso.CBU__c)) {
						encabezado.put('cobro_medio', caso.Tipo_CBU__c);
						encabezado.put('cobro_numero', caso.CBU__c);
                        encabezado.put('cuil_cbu', caso.CUIL_del_CBU__c);
					} else if(!String.isBlank(caso.Tarjeta_de_credito__c) && !String.isBlank(caso.Numero_de_tarjeta_de_credito__c)) {
						encabezado.put('cobro_medio', caso.Tarjeta_de_credito__c);
						encabezado.put('cobro_numero', caso.Numero_de_tarjeta_de_credito__c); 
					} else if(!String.isBlank(caso.Tipo_de_debito_por_ACA__c) && !String.isBlank(caso.Cdigo_debito_por_ACA__c)) {
						encabezado.put('cobro_medio', caso.Tipo_de_debito_por_ACA__c);
						encabezado.put('cobro_numero', caso.Cdigo_debito_por_ACA__c);                
					} 
					//else if(String.isBlank(caso.Tipo_CBU__c) && String.isBlank(caso.Tipo_CBU__c)
								//&& String.isBlank(caso.Tarjeta_de_credito__c) && String.isBlank(caso.Numero_de_tarjeta_de_credito__c)
								//&& String.isBlank(caso.Tipo_de_debito_por_ACA__c) && String.isBlank(caso.Cdigo_debito_por_ACA__c)) {
						//encabezado.put('cobro_medio', '');
						//encabezado.put('cobro_numero', ''); 
					//}
				}
                if(XappiaHelper.stringToNumericString(String.valueOf(getValueOf(caso.Condicion_IVA__c))) == '1') {
                    encabezado.put('cuit', caso.Cuit__c);
                }
            }
            Map<String, Object> bodyMap = new Map<String, Object> {
                'encabezado' => new List<Object> {encabezado},
                'archivos' => parseFiles(files),
                'notas' => parseNotas(notasAuditoria)
            };
            return JSON.serialize(bodyMap);
        } catch (Exception e) {
            return '';
        }
    }

    private static String parseAltaBody (Case caso, String userNick, List<ContentVersion> files, 
                                                List<Nota_de_Auditoria__c> notasAuditoria, 
                                                User usuario) {
        try {
            Map<String, Object> encabezado = new Map<String, Object> {
                'sf_id' => getValueOf(caso.Id),
                'fecha_vigencia' => formatDate(caso.Fecha_de_vigencia__c),
                'agencia_codigo' => usuario.Codigo_delegacion__c,
                'usuario' => getValueOf(userNick),
                'bebe_sin_doc' => (caso.Bebe_sin_DNI__c != null) ? (caso.Bebe_sin_DNI__c) ? 'V' : 'F' : ''                    
            };
            if(!String.isBlank(caso.Nro_de_solicitud_SS__c)) {
                encabezado.put('solicitud_id', caso.Nro_de_solicitud_SS__c);
                encabezado.put('estado_dj', (Object) caso.Estado_DDJJ__c);
            }
            Map<String, Object> familiar = new Map<String, Object> {
                'codigo_afi_titular' => (!String.isBlank(caso.Account.Codigo_de_Afiliado__c))  
                                            ? getValueOf(caso.Account.Codigo_de_Afiliado__c) : '',
                'apellido' => getValueOf(caso.Apellido__c),
                'nombres' => getValueOf(caso.Nombre__c),
                'doc_tipo' => getValueOf(caso.Tipo_dni__c),
                'doc_numero' => getValueOf(caso.DNI__c),
                'e_civil' => getValueOf(caso.Estado_civil__c),
                'codigo_obrasocial' => (!String.isBlank(caso.Obra_social2__c)) ? caso.Obra_social2__r.Codigo_de_obra_social__c : '',
                'sexo' => (!String.isBlank(caso.Sexo__c)) ? caso.Sexo__c.left(1).toUppercase() : '',
                'discapacitado' => caso.Discapacidad__c ? 'V' : 'F',
                'fecha_nac' => formatDate(caso.Fecha_de_nacimiento__c),
                'nacionalidad' => getValueOf(caso.Nacionalidad__c),
                'parentesco' => getValueOf(caso.Tipo_de_parentesco__c),
                'deriva_aportes' => caso.Deriva_aportes__c ? 'V' : 'F'
            };
            if(caso.Deriva_aportes__c) {
                familiar.put('cuit', getValueOf(caso.Cuit__c));
                familiar.put('importe_aportes', getValueOf(caso.Aporte__c));
                familiar.put('cuit_empleador', (!String.isBlank(caso.Empleador__c)) 
                                                    ? caso.Empleador__r.Cuit__c 
                                                        : (!String.isBlank(caso.Cuit_empleador__c)) ? caso.Cuit_empleador__c : '');
                familiar.put('nombre_empleador', (!String.isBlank(caso.Empleador__c))
                                                    ? caso.Empleador__r.Name 
                                                        : (!String.isBlank(caso.Razon_social__c)) ? caso.Razon_social__c : '');
                familiar.put('codigo_empleador', (!String.isBlank(caso.Empleador__c)) 
                                                    ? caso.Empleador__r.Codigo_de_empresa__c : '');
            }
            List<Map<String,Object>> archivos = parseFiles(files);
            List<Map<String, object>> notas = parseNotas(notasAuditoria);
            Map<String, object> body = new Map<String, Object> {
                'encabezado' => new List<Map<String, object>> {encabezado},
                'familiar' => new List<Map<String, object>> {familiar},
                'archivos' => archivos,
                'notas' => notas
            };
            return JSON.serialize(body);
        } catch(Exception e) {

            return '';
        }       
    }

    private static String parseDespegueBody (Case caso, String userNick, List<ContentVersion> files,
                                                     List<Nota_de_Auditoria__c> notasAuditoria, 
                                                     List<Integrante_caso__c> integrantes, 
                                                     User usuario){
        try {
            Map<String, Object> encabezado = new Map<String, Object> {
                'sf_id' => getValueOf(caso.Id),
                'fecha_vigencia' => formatDate(caso.Fecha_de_vigencia__c),
                'agencia_codigo' => usuario.Codigo_delegacion__c,
                'usuario' => getValueOf(userNick),
                'bebe_sin_doc' => (caso.Bebe_sin_DNI__c != null) ? (caso.Bebe_sin_DNI__c) ? 'V' : 'F' : '',
                'tipo_despegue' => getValueOf(caso.Type),
                'codigo_obrasocial' => (!String.isBlank(caso.Obra_social2__c)) ? caso.Obra_social2__r.Codigo_de_obra_social__c : '',
                'codigo_plan' =>  getValueOf(caso.Plandespegue__c),
                'aa1_codigo' =>  getValueOf(caso.Agrupacion1__c),
                'aa2_codigo' =>  getValueOf(caso.Medio_de_cobro__c),         
                'aa3_codigo' =>  getValueOf(caso.Agrupacion3__c),
                'aa_codigo' =>  getValueOf(caso.Segmento_de_grupo_familiar__c),
                'tel_tipo' =>  'TEL',
                'deriva_aportes' => ((caso.Type == 'FT' || caso.Type == 'CT') 
                                        && caso.Segmento_de_grupo_familiar__c.startsWith('OBL')) 
                                                    ? 'V' : (caso.deriva_aportes__c) ? 'V' : 'F',
                'tel_numero' => getValueOf(caso.Telefono__c),
                'email' => getValueOf(caso.SuppliedEmail),
                'codigo_empleador' => (!String.isBlank(caso.Empleador__c)) ? caso.Empleador__r.Codigo_de_empresa__c : '',
                'civa_codigo' => XappiaHelper.stringToNumericString(String.valueOf(getValueOf(caso.Condicion_IVA__c)))                 
            };
            Boolean derivaAportes = ((caso.Type == 'FT' || caso.Type == 'CT') 
                                            && caso.Segmento_de_grupo_familiar__c.startsWith('OBL')) 
                                                    || (caso.deriva_aportes__c);
            String civacodigo = XappiaHelper.stringToNumericString(String.valueOf(getValueOf(caso.Condicion_IVA__c)));
            if(civacodigo == '1' || civacodigo == '4' || derivaAportes) {
                encabezado.put('cuit', caso.Cuil__c);
            }
            if(derivaAportes) {
                encabezado.put('cuit_empleador', (!String.isBlank(caso.Empleador__c)) 
                                        ? caso.Empleador__r.Cuit__c 
                                            : (!String.isBlank(caso.Cuit_empleador__c)) 
                                                ? caso.Cuit_empleador__c : '');
                encabezado.put('nombre_empleador', (!String.isBlank(caso.Empleador__c)) 
                                        ? caso.Empleador__r.Name 
                                            : (!String.isBlank(caso.Razon_social__c)) ? caso.Razon_social__c : '');
                encabezado.put('importe_aportes', getValueOf(caso.Aporte__c));
            }
            switch on caso.Type {
                when 'FT', 'CT' {
                    encabezado.putAll(new map<String, Object> {
                        'codigo_afi_a_titular' => (!String.isBlank(caso.Account.Codigo_de_Afiliado__c)) 
                                                            ? getValueOf(caso.Account.Codigo_de_Afiliado__c) : '',
                        'localidad' =>  (!String.isBlank(caso.Localidad__c)) ? getValueOf(caso.Localidad__r.Loc_id__c) : '',
                        'dom_calle' => getValueOf(caso.Calle__c),
                        'dom_numero' => getValueOf(caso.numero__c),
                        'dom_piso' => getValueOf(caso.piso__c),
                        'dom_dpto' => getValueOf(caso.dpto__c)
                    });
                }
                when 'FF', 'TF' {
                    encabezado.putAll(new map<String, Object> {
                        'codigo_afi_a_familiar' => getValueOf(caso.Account.Codigo_de_Afiliado__c),
                        'codigo_afi_titular' => (!String.isBlank(caso.Titular__c)) ? getValueOf(caso.Titular__r.Codigo_de_Afiliado__c) : '',
                        'parentesco' => getValueOf(caso.Tipo_de_parentesco__c)
                    });
                }
            }
            if(!String.isBlank(caso.Nro_de_solicitud_SS__c)) {
                encabezado.put('solicitud_id', caso.Nro_de_solicitud_SS__c);
                encabezado.put('estado_dj', (Object) caso.Estado_DDJJ__c);
            }
            if(caso.Medio_de_cobro__c == 'CBUVOL') {
                encabezado.put('cobro_medio', caso.Tipo_CBU__c);
                encabezado.put('cobro_numero', caso.Numero_CBU_cobro_de_cuota__c);
                encabezado.put('cuil_cbu', caso.CUIL_del_CBU__c);
            } else if(caso.Medio_de_cobro__c == 'DEBAUT') {
                encabezado.put('cobro_medio', (caso.Tarjeta_de_credito__c != null) 
                                            ? caso.Tarjeta_de_credito__c : caso.Tipo_de_debito_por_ACA__c);
                encabezado.put('cobro_numero', (!String.isBlank(caso.Numero_de_tarjeta_de_credito__c)) 
                                                        ? caso.Numero_de_tarjeta_de_credito__c : caso.Cdigo_debito_por_ACA__c); 
            }
            List<Map<String, Object>> familiares = new List<Map<String, Object>>();
            for(Integrante_caso__c integrante :integrantes) {
                Map<String, Object> familiar = new Map<String, Object> {
                                                   'sf_id' => integrante.Id,
                                                   'parentesco' => integrante.Tipo_de_relacion_con_titular__c,
                                                   'apellido' => integrante.Apellido__c,
                                                   'nombres' => integrante.Nombre__c,
                                                   'doc_tipo' => integrante.Tipo_de_Documento__c,
                                                   'doc_numero' => integrante.Nro_de_documento__c,
                                                   'codigo_obrasocial' => (String.isBlank(integrante.Obra_social_actual__c)) 
                                                                                ? integrante.Obra_social_actual__r.Codigo_de_obra_social__c 
                                                                                    : '',
                                                   'e_civil' => integrante.Estado_Civil__c,
                                                   'sexo' => integrante.Sexo__c,
                                                   'fecha_nac' => formatDate(integrante.Fecha_de_Nacimiento__c),
                                                   'discapacitado' => (integrante.Discapacitado__c == 'Si') ? 'V' : 'F',
                                                   'nacionalidad' => integrante.Nacionalidad__c,
                                                   'deriva_aportes' => (integrante.Indicador_de_aporte__c) ? 'V' : 'F'
                     };
                     if(integrante.Indicador_de_aporte__c) {
                        familiar.put('cuit', getValueOf(integrante.CUIT_Sin_guiones__c));
                        familiar.put('importe_aportes', getValueOf(integrante.Aportes__c));
                        familiar.put('cuit_empleador', (!String.isBlank(integrante.Empleador__c)) ? integrante.Empleador__r.Cuit__c : integrante.Cuit_empleador__c );
                        familiar.put('nombre_empleador', (!String.isBlank(integrante.Empleador__c)) ? integrante.Empleador__r.Name : integrante.Razon_social__c);
                        familiar.put('codigo_empleador', (!String.isBlank(integrante.Empleador__c)) ? integrante.Empleador__r.Codigo_de_empresa__c : '');
                    }
                familiares.add(familiar);
           }
           
            List<Map<String, Object>> archivos = parseFiles(files);
            List<Map<String, object>> notas = parseNotas(notasAuditoria);
            Map<String, object> body = new Map<String, Object> {
                'familiares' => familiares,
                'encabezado' => new List<Map<String, Object>> {encabezado},
                'archivos' => archivos,
                'notas' => notas
            };
            return JSON.serialize(body);
        } catch (Exception e) {

            return null;
        }
    }

    private static String parseBajaPBody(Case caso, String userNick, List<ContentVersion> files,
                                                    Map<Id, List<Nota_de_Auditoria__c>> notasByIntegranteId, 
                                                    Map<Id, Integrante_caso__c> integrantes, 
                                                    User usuario) {
        Map<String, Object> encabezado = new Map<String, Object>{
            'sf_id' => caso.Id,
            'agencia_codigo' => usuario.Codigo_delegacion__c,
            'fecha_vigencia' =>  formatDate(caso.Fecha_de_vigencia__c),
            'usuario' => userNick
        };

		if(!String.isBlank(caso.Nro_de_solicitud_SS__c)) {
            encabezado.put('solicitud_id', caso.Nro_de_solicitud_SS__c);
        }
        
        List<Object> solicitudes = new List<Object>();
        for(Integrante_caso__c integrante : integrantes.values()) {
            List<Nota_de_Auditoria__c> thisIntegranteNotas = notasByIntegranteId.containsKey(integrante.Id)
                                                               ? notasByIntegranteId.get(integrante.Id) 
                                                                    : new List<Nota_de_Auditoria__c>();
            Map<String, Object> integranteMap = new Map<String, Object>{
                'sf_id' => integrante.Id,
                'codigo_afi' => (!String.isBlank(integrante.Familiar__c)) ? integrante.Familiar__r.Codigo_de_Afiliado__c : '',
                'tipo_asociado' => 'FAM',
                'motivo_baja' => integrante.Motivo_de_baja__c,
                'notas' => parseNotas(thisIntegranteNotas)
            };
            if(!String.isBlank(integrante.Numero_de_solicitud__c)) {
                integranteMap.put('solicitud_id', integrante.Numero_de_solicitud__c);
            }
            solicitudes.add(integranteMap);
        }

        Map<String, Object> bodyMap = new Map<String, Object> {
            'archivos' => parseFiles(files),
            'solicitudes' => solicitudes,
            'encabezado' => new List<Object> {encabezado}
        };

        return JSON.serialize(bodyMap);
    }

    private static String parseBajaTBody(Case caso, String userNick, List<ContentVersion> files,
                                                    List<Nota_de_Auditoria__c> notas,
                                                    User usuario) {
        try {
            Map<String, Object> encabezado = new Map<String, Object>{
                'sf_id' => caso.Id,
                'agencia_codigo' => usuario.Codigo_delegacion__c,
                'fecha_vigencia' =>  formatDate(caso.Fecha_de_vigencia__c),
                'usuario' => userNick
            };
            Map<String, Object> solicitud = new Map<String, Object>{
                'sf_id' => caso.Id,
                'codigo_afi' => (!String.isBlank(caso.Account.codigo_de_Afiliado__c)) ? caso.Account.Codigo_de_Afiliado__c : '',
                'tipo_asociado' => 'TIT',
                'motivo_baja' => caso.Motivo_de_baja__c,
                'notas' => parseNotas(notas)
            };
            if(!String.isBlank(caso.Nro_de_solicitud_SS__c)) {
                solicitud.put('solicitud_id', caso.Nro_de_solicitud_SS__c);
            }
            Map<String, Object> bodyMap = new Map<String, Object> {
                'archivos' => parseFiles(files),
                'solicitudes' => new List<Object> {solicitud},
                'encabezado' => new List<Object> {encabezado}
            };

            return JSON.serialize(bodyMap);
        } catch (Exception e) {
            return '';
        }
    }

    private static String parseCambioDeSegmentoBody (Case caso, String userNick, List<ContentVersion> files, 
                                                                List<Nota_de_Auditoria__c> notasAuditoria, 
                                                                User usuario) {
        try {
            Map<String, Object> encabezado = new Map<String, Object> {
                'sf_id' => caso.id,
                'codigo_afi_titular' => (!String.isBlank(caso.Account.Codigo_de_Afiliado__c)) 
                                            ? getValueOf(caso.Account.Codigo_de_Afiliado__c) : '',
                'fecha_vigencia' => formatDate(caso.Fecha_de_vigencia__c), 
                'agencia_codigo' => usuario.Codigo_delegacion__c,
                'usuario' => userNick,
                'codigo_obrasocial' => (!String.isBlank(caso.Obra_social2__c)) ? caso.Obra_social2__r.Codigo_de_obra_social__c : '',
                'codigo_plan' => caso.Plandespegue__c,
                'nuevo_segmento' => caso.Nuevo_segmento__c,
                'codigo_empleador' => (!String.isBlank(caso.Empleador__c)) ? caso.Empleador__r.Codigo_de_empresa__c : ''
            };
            if(!String.isBlank(caso.Nro_de_solicitud_SS__c)) {
                encabezado.put('solicitud_id', caso.Nro_de_solicitud_SS__c);
                encabezado.put('estado_dj', (Object) caso.Estado_DDJJ__c);
            }
            if(caso.Nuevo_segmento__c.contains('OBL') || caso.Nuevo_segmento__c == 'DTCAP') {
                encabezado.put('importe_aportes', caso.Aporte__c);
                encabezado.put('cuit', caso.Cuit__c);
                encabezado.put('cuit_empleador', (!String.isBlank(caso.Empleador__c)) 
                                                    ? caso.Empleador__r.Cuit__c 
                                                        : (!String.isBlank(caso.Cuit_empleador__c)) ? caso.Cuit_empleador__c : '');
                encabezado.put('nombre_empleador', (!String.isBlank(caso.Empleador__c))
                                                    ? caso.Empleador__r.Name 
                                                        : (!String.isBlank(caso.Razon_social__c)) ? caso.Razon_social__c : '');
            }
    
            
            Map<String, Object> bodyMap = new Map<String, Object> {
                'encabezado' => new List<Object> {encabezado},
                'archivos' => parseFiles(files),
                'notas' => parseNotas(notasAuditoria)
            };
    
            return JSON.serialize(bodyMap);
        } catch (Exception e) {

            return '';
        }
    }

    //================================[ FUNCIONES REUTILIZABLES ]===============================\\
    private static void processResponse(
		WSCaseEnviarASSHelper.Response resp, 
		Case caso, List<ContentVersion> files, 
		Boolean switchToInProgress,
		Boolean isAttachmentResend
	) {
		if(!isAttachmentResend) {
			Id solicitudInterfazFinanciera = XappiaHelper.getRecordType('Case', 'Interfaz_financiera').Id;
			WSCaseEnviarASSGenericResponse.Data data =  resp.result.data.get(0);    
			caso.Estado_de_solicitud__c = data.estado_sol;
			caso.Estado_DDJJ__c = data.estado_dj;
			caso.Nro_de_solicitud_SS__c = data.solafi_id;
			if(switchToInProgress) {
				caso.Status = 'En proceso';
			}
			update caso;
			processNotas(data.notas);
		}
        processFiles(files);
    }
    private static List<Map<String, Object>> parseFiles ( List<ContentVersion> files) {
        List<Map<String,Object>> archivos = new List<Map<String,Object>> ();
        try {
			if(!files.isEmpty()) {
				ContentVersion data = files[0];
				String title = Utils.getStringAlphanumericOnly(data.Title);

				if(title.length() > 44) {
					title = title.substring(0, 44);
				}
                    archivos.add(new Map<String, Object>{
                        'datos' => 'data:' + Utils.getTypeAndExtension(data.FileExtension) + 
                                        ';base64,' + EncodingUtil.base64Encode(data.VersionData),
                        'observaciones' => null,
                        'descripcion' => data.Description,
                        'nombre' => title.contains('.' + data.FileExtension) 
                                        ? title : title + '.' + data.FileExtension
                    });
            }
            return archivos;
        } catch (Exception e) {
            return archivos;
        }
    }
    private static void processFiles(List<ContentVersion> files) {
        List<ContentVersion> filesToUpdate = new List<ContentVersion>();
        for(ContentVersion file : files) {
			ContentVersion updateVersion = new ContentVersion(Id = file.Id, Enviado__c = true);
            filesToUpdate.add(updateVersion);
        }
        Database.SaveResult[] results = Database.update(filesToUpdate, false);

    }
    private static void processNotas(List<WSCaseEnviarASSHelper.Notas> notasDeAuditoria) {
        List<Nota_de_Auditoria__c> notasAActualizar = new List<Nota_de_Auditoria__c>();
        for(WSCaseEnviarASSHelper.Notas nota : notasDeAuditoria) {
            notasAActualizar.add(new Nota_de_Auditoria__c(Id = nota.sf_id, Id_externo_solicitudes__c = nota.nota_id, Nota__c = nota.texto_nota));
        }
        Database.upsert(notasAActualizar, false);
    }
    private static String formatDate(Date fecha) {
        try {
            Datetime dt = Datetime.newInstance(fecha.year(), fecha.month(), fecha.day(),0,0,0);
            return dt.Format('dd/MM/yyyy');
        } catch(Exception e) {
            return '';
        }
    }
    private static Object getValueOf(Object obj) {
        return (obj != null) ? String.valueOf(obj) : '';
    }
    private static List<Map<String, Object>> parseNotas (List<Nota_de_Auditoria__c> notasAuditoria) {
        List<Map<String,Object>> notas = new List<Map<String,Object>> ();
        try {
            for(Nota_de_Auditoria__c nota :notasAuditoria) {
                notas.add(new Map<String, Object>{
                    'sf_id' => nota.Id,
                    'texto' => nota.Nota__c,
                    'usuario_nota' => nota.CreatedBy.CommunityNickname
                });
            }
            return notas;
        } catch (Exception e) {

            return notas;
        }
    }
	/** Senders */
	private static Response sendSolicitudAlta (String recordId) {
		String body = parseAltaBody(caso, userNick, files, notas, usuario);
		System.debug(body);
		WSCaseEnviarASSHelper.Response resp = ( WSCaseEnviarASSHelper.Response) WSCaseEnviarASSHelper.enviarASS(body, 'alta-familiar');
		if(!resp.hasError) {
			processResponse(resp, caso, files, false, isAttachmentResend);
		}
		if(files.size() != 0 && !resp.hasError) {
			System.enqueueJob(new CaseSendToSSAttachmentQueueable(recordId));
		}
		return new Response(resp.hasError, (resp.hasError) ? resp.message : resp.result.message, body);
	}
	private static Response sendSolicitudDespegue (String recordId) {
		List<Integrante_caso__c> integrantes = [SELECT Id, Tipo_de_relacion_con_titular__c, Apellido__c, Nombre__c, Tipo_de_Documento__c, Nro_de_documento__c,
													Obra_social_actual__r.Codigo_de_obra_social__c, Estado_Civil__c, Sexo__c, Fecha_de_Nacimiento__c,
													Discapacitado__c, Nacionalidad__c, Indicador_de_aporte__c, CUIT_Sin_guiones__c, Aportes__c,
													Empleador__r.Cuit__c, Empleador__r.Name, Empleador__r.Codigo_de_empresa__c, Cuit_empleador__c, Razon_social__c
												FROM Integrante_caso__c
												WHERE Caso__c = :recordId];
		String body = parseDespegueBody(caso, userNick, files, notas, integrantes, usuario);
		System.debug(body);
		WSCaseEnviarASSHelper.Response resp = ( WSCaseEnviarASSHelper.Response) WSCaseEnviarASSHelper.enviarASS(body, 'despegue');
		if(!resp.hasError) {
		processResponse(resp, caso, files, false, isAttachmentResend);
		}
		if(files.size() != 0 && !resp.hasError) {
		System.enqueueJob(new CaseSendToSSAttachmentQueueable(recordId));
		}
		return new Response(resp.hasError, (resp.hasError) ? resp.message : resp.result.message, body);
	}
	private static Response sendSolicitudBaja (String recordId) {
		String body;
		if(caso.Type == 'Baja Parcial') {
			Map<Id, Integrante_caso__c> integrantes = new Map<Id, Integrante_caso__c>([
					SELECT Id,
						Familiar__r.Codigo_de_Afiliado__c, Integrante_tipo_asociado__c,
						Motivo_de_baja__c, Numero_de_solicitud__c, RecordTypeId
					FROM Integrante_caso__c
					WHERE Caso__c = :caso.Id]);
			if(integrantes.isEmpty()) {
				return new Response(true, 'No puede generar una baja parcial sin integrantes', '');
			}
			Map<Id, List<Nota_de_Auditoria__c>> notasByIntegranteId = new Map<Id, List<Nota_de_Auditoria__c>>();
			for(Nota_de_Auditoria__c nota : [SELECT id, Integrante__c, Nota__c, CreatedBy.CommunityNickname
						FROM Nota_de_Auditoria__c
						WHERE Integrante__c
							IN : integrantes.keySet()
							AND (Id_externo_solicitudes__c = null OR Id_externo_solicitudes__c = '')
						]){
				if(notasByIntegranteId.containsKey(nota.Integrante__c)) {
					notasByIntegranteId.get(nota.Integrante__c).add(nota);
				} else {
					notasByIntegranteId.put(nota.Integrante__c, new List<Nota_de_Auditoria__c> {nota});
				}
			}
			body = parseBajaPBody(caso, userNick, files, notasByIntegranteId, integrantes, usuario);
		} else if(caso.Type == 'Baja Total') {
			body = parseBajaTBody(caso, userNick, files, notas, usuario);
		} else {
			return new Response(true, 'El caso no tiene un tipo de baja valido.', '');
		}
		System.debug(body);
		WSCaseEnviarASSHelper.Response solicitudBaja = ( WSCaseEnviarASSHelper.Response) WSCaseEnviarASSHelper.enviarASS(body, 'baja');
		if(!solicitudBaja.hasError) {
			if(!isAttachmentResend) {
				List<WSCaseEnviarASSHelper.Notas> notasToProcess = new List<WSCaseEnviarASSHelper.Notas>();
				if(caso.Type == 'Baja Parcial') {
					List<Integrante_caso__c> integrantesToUpdate = new List<Integrante_caso__c>();
					String caseNroSolicitud = '';
					for(WSCaseEnviarASSGenericResponse.Data data : solicitudBaja.result.data) {
						integrantesToUpdate.add(new Integrante_caso__c(Id = data.sf_id, Numero_de_solicitud__c = data.solafi_id, Estado_solicitud__c = data.estado_sol));
						caseNroSolicitud += data.solafi_id + ' - ';
						notasToProcess.addAll(data.notas);
					}
					if(String.isBlank(caso.Nro_de_solicitud_SS__c)) {
						caseNroSolicitud = caseNroSolicitud.left(caseNroSolicitud.length() - 3);
						caso.Nro_de_solicitud_SS__c = caseNroSolicitud;
					}
					caso.Status = 'En proceso';
					update caso;
					update integrantesToUpdate;
				} else {
					WSCaseEnviarASSGenericResponse.Data data =  solicitudBaja.result.data.get(0);
					caso.Estado_de_solicitud__c = data.estado_sol;
					caso.Nro_de_solicitud_SS__c = data.solafi_id;
					notasToProcess.addAll(data.notas);
					caso.Status = 'En proceso';
					update caso;
				}
				processNotas(notasToProcess);
			}
			processFiles(files);
		}
		if(files.size() != 0 && !solicitudBaja.hasError) {
			System.enqueueJob(new CaseSendToSSAttachmentQueueable(recordId));
		}
		return new Response(solicitudBaja.hasError, (solicitudBaja.hasError) ? solicitudBaja.message : solicitudBaja.result.message, body);
	}
	private static Response sendSolicitudCambioSegmento (String recordId) {
		String body = parseCambioDeSegmentoBody(caso, userNick, files, notas, usuario);
		System.debug(body);
		WSCaseEnviarASSHelper.Response resp = ( WSCaseEnviarASSHelper.Response) WSCaseEnviarASSHelper.enviarASS(body, 'cambio-segmento');
		if(!resp.hasError) {
			processResponse(resp, caso, files, true, isAttachmentResend);
		}
		if(files.size() != 0 && !resp.hasError) {
			System.enqueueJob(new CaseSendToSSAttachmentQueueable(recordId));
		}
		return new Response(resp.hasError, (resp.hasError) ? resp.message : resp.result.message, body);
	}
	private static Response sendInterfazFinanciera (String recordId) {
		String body = parseInterfazFinanciera(caso, userNick, files, notas, usuario);
		System.debug(body);
		WSCaseEnviarASSHelper.Response resp = ( WSCaseEnviarASSHelper.Response) WSCaseEnviarASSHelper.enviarASS(body, 'interfaz-financiera');
		if(!resp.hasError) {
			processResponse(resp, caso, files, true, isAttachmentResend);
		}
		if(files.size() != 0 && !resp.hasError) {
			System.enqueueJob(new CaseSendToSSAttachmentQueueable(recordId));
		}
		return new Response(resp.hasError, (resp.hasError) ? resp.message : resp.result.message, body);
	}
	private static Response sendSolicitudCambioCredencial (String recordId) {
		Map<String, Object> simpleMap = new Map<String, Object> {
			'afi_codigo' => caso.Codigo_de_asociado__c
		};
		String body = JSON.serialize(simpleMap);
		System.debug(body);
		WSCaseEnviarASSHelper.Response resp = ( WSCaseEnviarASSHelper.Response) WSCaseEnviarASSHelper.enviarASS(body, 'reemision-credencial');
		if(resp.hasError) {
			caso.Error__c = resp.message;
			caso.Status = 'En proceso';
			update caso;
		} else {
			caso.Error__c = '';
			caso.Estado_de_solicitud__c = 'TRANSFORMADA';
			caso.Status = 'En proceso';
			update caso;
		}
		return new Response(resp.hasError, (resp.hasError) ? resp.message : resp.result.message, body);
	}
	private static Response sendSolicitudCambioPlan (String recordId) {
		String body = parseCambioPlanBody(caso, userNick, files, notas, usuario);
		System.debug(body);
		WSCaseEnviarASSHelper.Response resp = ( WSCaseEnviarASSHelper.Response) WSCaseEnviarASSHelper.enviarASS(body, 'cambio-plan');
		if(!resp.hasError) {
			processResponse(resp, caso, files, true, isAttachmentResend);
		}
		if(files.size() != 0 && !resp.hasError) {
			System.enqueueJob(new CaseSendToSSAttachmentQueueable(recordId));
		}
		return new Response(resp.hasError, (resp.hasError) ? resp.message : resp.result.message, body);
	}
	private static Response sendSolicitudDatosParticulares () {
		String body = parseDatosParticularesBody(caso, userNick, usuario);
		System.debug(body);
		WSCaseEnviarASSHelper.Response resp = ( WSCaseEnviarASSHelper.Response) WSCaseEnviarASSHelper.enviarASS(body, 'datos-particulares');
		if(!resp.hasError) {
			processResponse(resp, caso, files, true, isAttachmentResend);
		}
		return new Response(resp.hasError, (resp.hasError) ? resp.message : resp.result.message, body);
	}
	/** Utils */
	private static Case getCaseInfo (String recordId) {
		return [SELECT Account.Afi_Id_del_Titular__c,
					Account.Agencia_codigo__c,
					Account.Codigo_de_Afiliado__c,
					Account.CUIT__c,
					Agencia_destino__r.codigo_de_delegacion__c,
					Agrupacion1__c,
					Agrupacion3__c,
					Apellido__c,
					Aporte__c,
					Bebe_sin_DNI__c,
					Borrar_tarjeta_debito_o_cobro_por_CBU__c,
					Calle__c,
					CBU__c,
					Cdigo_debito_por_ACA__c,
					Codigo_de_asociado__c,
					Codigo_Empleador__c,
					Condicion_IVA__c,
					Cuil__c,
					CUIL_del_CBU__c,
					Cuit__c,
					CUIT_CUIL_Titular_CBU__c,
					Cuit_empleador__c,
					Delegacion__r.Codigo_de_delegacion__c,
					Deriva_aportes__c,
					Discapacidad__c,
					DNI__c,
					Dpto__c,
					Empleador__c,
					Empleador__r.Codigo_de_empresa__c,
					Empleador__r.Cuit__c,
					Empleador__r.Name,
					Envio_de_recibo__c,
					Estado_civil__c,
					Estado_DDJJ__c,
					Fecha_de_nacimiento__c,
					Fecha_de_vigencia__c,
					Id,
					Localidad__r.Loc_id__c,
					Medio_de_cobro__c,
					Motivo_de_baja__c,
					Nacionalidad__c,
					Nombre__c,
					Nro_de_solicitud_SS__c,
					Nuevo_segmento__c,
					Numero__c,
					Numero_CBU__c,
					Numero_CBU_cobro_de_cuota__c,
					Numero_de_tarjeta_de_credito__c,
					Obra_social2__r.Codigo_de_delegacion__c,
					Obra_social2__r.Codigo_de_obra_social__c,
					Piso__c,
					Plandespegue__c,
					Razon_social__c,
					RecordTypeId,
					Segmento_de_grupo_familiar__c,
					Sexo__c,
					SuppliedEmail,
					Tarjeta_de_credito__c,
					Telefono__c,
					Tipo__c,
					Tipo_CBU__c,
					Tipo_de_debito_por_ACA__c,
					Tipo_de_parentesco__c,
					Tipo_dni__c,
					Titular__r.Codigo_de_Afiliado__c,
					Type
				FROM Case WHERE Id =: recordId];
	}
	private static List<Nota_de_Auditoria__c> getNotas (String recordId) {
		return [SELECT id, Nota__c, CreatedBy.CommunityNickname
				FROM Nota_de_Auditoria__c
				WHERE APr_Id__c =:recordId
					AND (Id_externo_solicitudes__c = null
						OR Id_externo_solicitudes__c = '')];
	}
    /**public class Response Extends FrontResponse{
        @AuraEnabled public String generatedBody;
        public Response(Boolean hasError, String message, String status, String generatedBody) {
            this.hasError = hasError;
			this.auraMessage = new auraMessage(message, status);
            this.generatedBody = generatedBody;
        }
	}*/
	public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
        @AuraEnabled public String generatedBody;
        public Response(Boolean hasError, String message, String generatedBody) {
            this.hasError = hasError;
            this.message = message;
            this.generatedBody = generatedBody;
        }
	}
}