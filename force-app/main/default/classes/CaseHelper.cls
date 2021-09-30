public with sharing class CaseHelper {

	@TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
			ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
			
    public static void assignDelegacionFromUser(Map<Id, List<Case>> userIdCasesMap) {
        //Set<Case> casesToUpdate = new Set<Case>();
		List<Case> casesToUpdate = new List<Case>();
        Map<String, List<Case>> codDelegacionCasesMap = new Map<String, List<Case>>();
		//Map<String, Set<Case>> codDelegacionCasesMap = new Map<String, Set<Case>>();
		//usuario = [SELECT Codigo_delegacion__c FROM User WHERE Id  = userIdCasesMap.keyset()[0]];
		Group[] cdc = [SELECT id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'CDC'];
				Account[] delegacionCdc = [SELECT Id, Codigo_de_delegacion__c
					FROM Account
					WHERE Codigo_de_delegacion__c = '650078'
		];


        for (User usuario : [
                SELECT Codigo_delegacion__c
                FROM User
                WHERE Id IN :userIdCasesMap.keySet()
        ]) {
			if (usuario.Codigo_delegacion__c != null) {
                List<Case> casesFromUserMap = userIdCasesMap.get(usuario.Id);
				//Set<Case> casesFromUserMapS = new Set<Case>(casesFromUserMap);
                if (codDelegacionCasesMap.containsKey(usuario.Codigo_delegacion__c)) {
                    List<Case> casesFromDelegacionMap = codDelegacionCasesMap.get(usuario.Codigo_delegacion__c);
					//Set<Case> casesFromDelegacionMap = codDelegacionCasesMap.get(usuario.Codigo_delegacion__c);
                    casesFromDelegacionMap.addAll(casesFromUserMap);
                    codDelegacionCasesMap.put(usuario.Codigo_delegacion__c, casesFromDelegacionMap);
                } else {
                    codDelegacionCasesMap.put(usuario.Codigo_delegacion__c, casesFromUserMap);
                }
            }

        }

		if(!cdc.isEmpty()) {
			if(userIdCasesMap.containsKey(cdc[0].Id)) { 
				List<Case> casesFromUserMap = userIdCasesMap.get(cdc[0].Id);

				for(Case aCase : casesFromUserMap) {
					aCase.Delegacion__c = delegacionCdc[0].Id;

					casesToUpdate.add(aCase);
				}
			}
		}

		System.debug('****codDelegacionCasesMap ' + codDelegacionCasesMap);
        for(Account delegacion : [
                SELECT Id, Codigo_de_delegacion__c
                FROM Account
                WHERE Codigo_de_delegacion__c IN :codDelegacionCasesMap.keySet()
        ]) {
            for (Case caso : codDelegacionCasesMap.get(delegacion.Codigo_de_delegacion__c)) {
				//caso.Cambio_Manual__c = false;
                caso.Delegacion__c = delegacion.Id;
                casesToUpdate.add(caso);
            }
        }

		List<Case> casos = new List<Case>(casesToUpdate);
        if (!casesToUpdate.isEmpty()) {
			System.debug('****casesToUpdate ' + casesToUpdate);
			System.debug('****setToUpdate ' + casos);
           update casesToUpdate;
		   //update casos;
        }
    }
    
    public static void derivaconAlCompletarDocumentacion(List<Case> casesToUpdate){
        system.debug('casos que vinieron en la lista: ' + casesToUpdate.size());
		
		//List<User> usuarioIntegracion = [SELECT Id FROM User WHERE CommunityNickname = 'UsuarioIntegracion'];
		//String usuarioIntegracionId = usuarioIntegracion.isEmpty() ? null : usuarioIntegracion[0].Id;
		User usuario = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		Boolean isDoctor = usuario.Profile.Name == 'Auditor Medico' || usuario.Profile.Name == 'Coordinador de Mesa de Ayuda';

        Map<Id,Case> cases = new Map<Id,Case>();
        for(Case caso : casesToUpdate){
        	cases.put(caso.Id,caso);
        }
        system.debug('casos que quedaron en el mapa: ' + cases.size());
        for(Case caso : cases.values()){
            if(caso.Estado_de_documentacion__c == 'Solicitar documentacion'){
                //Se necesita saber el ultimo usuario que modifico el caso,
                //Como se está en el trigger.isBefore el LastModifiedById
                //Todavía no surgió efecto, así que en su lugar se usa el
                //UserInfo.getUserId() que es el usuario que está ejecutando esto.
				
                caso.Correo_electronico_responsable__c = UserInfo.getUserEmail();
                caso.id_usuario_solicitante__c = usuario.Id;
                //caso.Usuario__c = caso.id_usuario_solicitante__c;
                if(String.isBlank(caso.Celula__c)){
					caso.id_celula_solicitante__c = null;
                }else{
                    caso.id_celula_solicitante__c = caso.Celula__c;
                }
                if(String.isBlank(caso.Nivel_de_derivacion__c)){
                    caso.id_equipo_solicitante__c = caso.OwnerId;
            	}else{
                    caso.id_equipo_solicitante__c = caso.Nivel_de_derivacion__c;
            	}
				
				if(String.isBlank(caso.Medico_asignado__c) && isDoctor && caso.Contiene_alerta_AM__c) {
					caso.Medico_asignado__c = usuario.Id;
				}

				System.debug('****: id_equipo_solicitante__c' + caso.id_equipo_solicitante__c);

				caso.Nivel_de_derivacion__c = 'Nivel 1';									
				//if(caso.CreatedById == usuarioIntegracionId) {
					//caso.Nivel_de_derivacion__c = 'Nivel 1';
				//} else {
					//caso.Nivel_de_derivacion__c = null;
					//caso.OwnerId = caso.CreatedById;
				//}
            }else if(caso.Estado_de_documentacion__c == 'Documentacion finalizada'){
                system.debug('caso documentacion finalizada');
                system.debug(caso);
                system.debug(caso.Nivel_de_derivacion__c);
                system.debug(caso.OwnerId);
                system.debug(caso.Celula__c);
                if(caso.id_equipo_solicitante__c != null && caso.id_equipo_solicitante__c.contains('Nivel')) {
                	caso.Nivel_de_derivacion__c  = caso.id_equipo_solicitante__c;
                }else{
                    caso.OwnerId = caso.id_equipo_solicitante__c;
                }
               /* if(String.isBlank(caso.id_celula_solicitante__c)){
                    caso.Celula__c = null;
                }else{
                    caso.Celula__c = caso.id_celula_solicitante__c;
                }*/
                system.debug(caso);
                system.debug(caso.Nivel_de_derivacion__c);
                system.debug(caso.OwnerId);
                system.debug(caso.Celula__c);
            }
        }
    }

	public static void reasignarLote(Case reintegro, String username){
		List<Lote__c> lote = [SELECT Id_lote_SS__c FROM Lote__c WHERE Id = :reintegro.Lote__c];
		if(!lote.isEmpty()) {	
			Map<String, Object> bodyMap = new Map<String, Object>{
				'accion' => 'REASIGNAR',
				'numero_lote' => lote[0].Id_lote_SS__c,
				'usuario' => username
			};
			WSCaseReintegroReasignar.Response resp = WSCaseReintegroReasignar.reasignarReintegro(reintegro.Codigo_reintegro_SS__c, JSON.serialize(bodyMap));
			if(!resp.hasError){
				reintegro.Cambio_Manual__c = false;
				reintegro.Error_reasignacion__c = null;
				reintegro.Fecha_error_reasignacion__c = null;
				reintegro.Usuario_error_reasignar__c = null;
			}
			else{
				reintegro.Cambio_Manual__c = false;
				reintegro.Error_reasignacion__c = resp.message;
				reintegro.Fecha_error_reasignacion__c = Datetime.now();
				reintegro.Usuario_error_reasignar__c = username;
			}
		}
		
	}

	public static void validateMedicoAsignadoOldInNull(Case[] cases, String fieldToValidate) {
		String[] profiles = new List<String>{'Administrador del sistema'};
		
		if(fieldToValidate == 'medico') {
			profiles.add('Auditor Medico');
			profiles.add('Coordinador de Mesa de Ayuda');
		}
		//String[] profiles = new List<String>{'Auditor Medico'};

		validateMedicoAsignadoByNamesOfQueues(cases, profiles, fieldToValidate, true);
	}

	public static void validateMedicoAsignadoOldNotNull(Case[] cases, String fieldToValidate) {
		String[] profiles = new List<String>{'Administrador del sistema'};
		//String[] profiles = new List<String>();

		validateMedicoAsignadoByNamesOfQueues(cases, profiles, fieldToValidate, false);

	}

	private static void validateMedicoAsignadoByNamesOfQueues(
		Case[] cases, 
		String[] profiles, 
		String fieldToValidate, 
		Boolean oldNull
	) {
		Map<String, GroupMember[]> membersByGroupName = getMapMembersByCelulaName();
		User usuario = [
			SELECT CommunityNickname, Profile.Name, UserRole.DeveloperName, Codigo_delegacion__c 
			FROM User 
			WHERE Id =: UserInfo.getUserId()
		];

		for(Case aCase : cases) {
			String queueName = null;

			if(aCase.Nivel_de_derivacion__c != 'Nivel 3' && aCase.Nivel_de_derivacion__c != 'Nivel 2') {
				if(fieldToValidate == 'medico') {
					aCase.addError('El caso debe estar en nivel 2 o 3 para poder asignar/desasignar un médico');
				}
				else if(fieldToValidate == 'responsable') {
					aCase.addError('El caso debe estar en nivel 2 o 3 para poder asignar/desasignar al Responsable');
				}
				else if(fieldToValidate == 'presupuesto') {
					aCase.addError('El caso debe estar en nivel 2 o 3 para poder asignar/desasignar al Responsable de Presupuesto');
				}
			}
			else {
				queueName = getQueueName(aCase);
			}
			
			if(!aCase.Contiene_alerta_AM__c && fieldToValidate == 'medico') {
				aCase.Medico_asignado__c.addError(
					'El Caso debe tener alertas AM para poder modificar el médico asignado'
				);
			}
			else {
				GroupMember[] members = membersByGroupName.get(queueName);
				//Boolean hasPermission = false;
				Boolean isLeader = isLeaderOfCelula(members, usuario);
				Boolean isResponsable = usuario.Id == aCase.Usuario__c;
				Boolean isResponsablePresupuesto = usuario.Id == aCase.Responsable_de_presupuesto__c;
				Boolean isDoctor = usuario.Profile.Name == 'Auditor Medico' || usuario.Profile.Name == 'Coordinador de Mesa de Ayuda';
				
				Boolean hasPermission = hasTheCorrectProfile(profiles, usuario) || isLeader;
				
				if(fieldToValidate == 'medico') {
						
					if(oldNull && isDoctor && aCase.Medico_asignado__c != usuario.Id) {
						//if(aCase.Medico_asignado__c == usuario.Id) {
							//hasPermission = false;
						//}
						//else if(!isResponsable && !isLeader) {
							//aCase.Medico_asignado__c.addError('No puede asignar otro médico');
						//}
						hasPermission = false;
					}

					Boolean hasCustomPermission = FeatureManagement.checkPermission('Modificar_medico_asignado');
					hasPermission = hasPermission || isResponsable || isLeader || hasCustomPermission;
				}
				else if(fieldToValidate == 'responsable' && oldNull && isResponsable) {
					hasPermission = true;
				}
				else if(fieldToValidate == 'presupuesto' && oldNull && isResponsablePresupuesto) {
					hasPermission = true;
				}


				if(!hasPermission) {
					if(fieldToValidate == 'medico') {
						aCase.Medico_asignado__c.addError('No tiene los permisos necesarios para modificar este campo');
					} 
					else if(fieldToValidate == 'responsable') {
						aCase.Usuario__c.addError('No tiene los permisos necesarios para modificar este campo');
					}
					else if(fieldToValidate == 'presupuesto') {
						aCase.Responsable_de_presupuesto__c.addError('No tiene los permisos necesarios para modificar este campo');
					}
				}
			}
			

		}
	
	}

	private static String getQueueName(Case aCase) {
		String queueName = null;

		if(aCase.Nivel_de_derivacion__c == 'Nivel 3') {
			String celula = aCase.Celula__c;
			queueName = String.isNotBlank(celula) ? celula.replace(' ', '_') : null;
		} 
		else if(aCase.Nivel_de_derivacion__c == 'Nivel 2') {
			queueName = 'Mesa_de_ayuda';
		}

		return queueName;
	}

	private static Map<String, GroupMember[]> getMapMembersByCelulaName() {
		Map<String, GroupMember[]> membersByGroupName = new Map<String, GroupMember[]>();
		GroupMember[] members = [
			SELECT Id, UserOrGroupId, Group.DeveloperName 
			FROM GroupMember 
			WHERE Group.DeveloperName LIKE 'Celula%' OR Group.DeveloperName = 'Mesa_de_ayuda'
		]; 
		
		for(GroupMember member : members) {
			//System.debug(member);
			//System.debug(member.Group.DeveloperName);
			if(membersByGroupName.keySet().contains(member.Group.DeveloperName)) {
				GroupMember[] membersFromMap= membersByGroupName.get(member.Group.DeveloperName);
				membersFromMap.add(member);

				membersByGroupName.put(member.Group.DeveloperName, membersFromMap);
			}
			else {
				membersByGroupName.put(member.Group.DeveloperName, new List<GroupMember>{member});
			}
		}

		return membersByGroupName;
	}

	private static Boolean hasTheCorrectProfile(String[] profiles, User usuario) {
		Boolean match = false;
		
		for(String profile : profiles) {
			match = match || usuario.Profile.Name == profile;
		}

		return match;
	}

	private static Boolean isLeaderOfCelula(GroupMember[] members, User usuario) {
		Boolean isMember = false;
		
		if(members != null) {
			for(GroupMember member : members) {
				if(member.UserOrGroupId == UserInfo.getUserId()) {
					isMember = true;
				}
			}
		}

		return isMember;
	}

	public static void checkNoAlertsPendingOnEM(Case[] cases) {
		Set<Id> emIds = new Set<Id>();
		Evento_medico__c[] emsToUpdate = new List<Evento_medico__c>();

		for(Case aCase : cases) {
			if(String.isNotBlank(aCase.Evento_Medico__c)) {
				emIds.add(aCase.Evento_Medico__c);
			}
		}

		Evento_medico__c[] emsWithCaseWithAlertsAM = [
			SELECT Id, Alertas_AM_pendientes__c,
				(SELECT Contiene_alerta_AM__c, Sin_alertas_AM_pendientes__c FROM Casos__r)
			FROM Evento_Medico__c
			WHERE Id IN :emIds
		];

		for(Evento_medico__c em : emsWithCaseWithAlertsAM) {
			Boolean alertsAMPending = false;
			
			for(Case aCase : em.Casos__r) {
				if(aCase.Contiene_alerta_AM__c && !aCase.Sin_alertas_AM_pendientes__c) {
					alertsAMPending = true;
				}
			}

			if(em.Alertas_AM_pendientes__c != alertsAMPending) {
				em.Alertas_AM_pendientes__c = alertsAMPending;
				em.Cambio_Manual__c = false;

				emsToUpdate.add(em);
			}
		}

		update emsToUpdate;
	}

	public static void changeStatusToClosed (List<Case> newCases, Map<Id, Case> oldCases){
		Id solicitudAlta =XappiaHelper.getRecordType('Case', 'Solicitud_de_alta_familiar').Id;
        Id solicitudDespegue = XappiaHelper.getRecordType('Case', 'Solicitud_de_despegues').Id;
		Id solicitudDeBaja = XappiaHelper.getRecordType('Case', 'Solicitud_de_baja').Id;
		Id solicitudCambioSegmento = XappiaHelper.getRecordType('Case', 'Solicitud_de_segmento').Id;
		Id solicitudInterfazFinanciera = XappiaHelper.getRecordType('Case', 'Interfaz_financiera').Id;
		Id solicitudCredencial = XappiaHelper.getRecordType('Case', 'Solicitud_de_nueva_credencial').Id;
		Id solicitudPlan = XappiaHelper.getRecordType('Case', 'Solicitud_de_cambio_de_plan').Id;
		Id solicitudDatosParticulares = XappiaHelper.getRecordType('Case', 'Solicitud_de_datos_particulares').Id;

		Set<Id> casesToSendToServiceFile = new Set<Id>();
		for(Case caso :newCases) {
			Case oldCase = oldCases.get(caso.Id);
			if(caso.RecordTypeId == solicitudAlta) {
				if(caso.Estado_de_solicitud__c == 'TRANSFORMADA' 
												&& oldCase.Estado_de_solicitud__c != 'TRANSFORMADA' 
												&& caso.Bebe_nacido_en_sistema__c && !caso.Informacion_completa__c ) {
					caso.Status = 'Cerrado con documentacion pendiente';
				} else if(caso.Estado_de_solicitud__c == 'TRANSFORMADA' 
												&& oldCase.Estado_de_solicitud__c != 'TRANSFORMADA' 
												&& !caso.Bebe_nacido_en_sistema__c) {
					caso.Status = 'Cerrado';
				} else if(caso.Estado_de_solicitud__c == 'TRANSFORMADA' 
													&& caso.Informacion_completa__c 
													&& !oldCase.Informacion_completa__c 
													&& caso.Bebe_nacido_en_sistema__c 
													&& !String.isBlank(caso.Nro_de_solicitud_SS__c)) {
					casesToSendToServiceFile.add(caso.Id);
					if(casesToSendToServiceFile.size() == 100) {
						sendCasesToFilesService(casesToSendToServiceFile);
						casesToSendToServiceFile.clear();
					}
				}
			} else if(caso.RecordTypeId == solicitudDeBaja){
				if(caso.Estado_de_solicitud__c == 'TRANSFORMADA' 
												&& oldCase.Estado_de_solicitud__c != 'TRANSFORMADA') {
					caso.Motivo_de_cierre_solicitudes__c = 'Baja procesada';
					caso.Status = 'Cerrado';
				}
			} else if(caso.RecordTypeId == solicitudCambioSegmento 
										|| caso.RecordTypeId == solicitudInterfazFinanciera
										|| caso.RecordTypeId == solicitudCredencial 
										|| caso.RecordTypeId == solicitudDespegue
										|| caso.RecordTypeId == solicitudDatosParticulares
										|| caso.RecordTypeId == solicitudPlan) {
				if(caso.Estado_de_solicitud__c == 'TRANSFORMADA' 
												&& oldCase.Estado_de_solicitud__c != 'TRANSFORMADA') {
					caso.Status = 'Cerrado';
				}
			}
		}
		if(!casesToSendToServiceFile.isEmpty()) {
			sendCasesToFilesService(casesToSendToServiceFile);
		}
	}

	@Future(callout=true)
	private static void sendCasesToFilesService(Set<Id> cases) {
		List<Case> casesToSend = [SELECT id, Nro_de_solicitud_SS__c FROM Case WHERE id in :cases];
		List<Case> casesToUncheck = new List<Case>();
		for(Case caso :casesToSend) {
			WSParameter[] parameters = new List<WSParameter> {
				new WSParameter('solafiId', caso.Nro_de_solicitud_SS__c, true)
			};
			RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/{0}/proceso-archivos', //REVISAR ENDPOINT
					'POST',
					parameters);
	
			ws.request.setHeader('Accept','application/json"');
			ws.request.setHeader('Content-Type', 'application/json');
			WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
			ResponseFileService res = (ResponseFileService) ws.invoke(new ResponseFileService());
			WSAuthToken.manageTokenResponse(tokenResp);

			if(!res.isSuccess) {
				//Nothing to do (?
			}
		}
	}
	
	private class ResponseFileService extends WSResult {
		public boolean isSuccess = false;
        public override void processResponse(HttpResponse response) {
			this.isSuccess = true;
        }

    }

	public static void checkDuplicateDNIOnAltaFamiliar(List<Case> cases) {
		Id rtAltaFamiliar = XappiaHelper.getRecordType('Case', 'Solicitud_de_alta_familiar').Id;
		Map<String, Case> casosPorDNI = new Map<String, Case>();
		for(Case caso :cases) {
			if(caso.RecordTypeId == rTAltaFamiliar && !String.isBlank(caso.DNI__c) && !caso.Bebe_sin_DNI__c && !caso.Informacion_completa__c
				&& caso.Status != 'Cerrado con documentacion pendiente' && caso.Estado_DDJJ__c != 'DDJJ OK' 
				&& caso.Estado_de_solicitud__c != 'TRANSFORMADA'
			) {
				casosPorDNI.put(caso.DNI__c, caso);
			}
		}
		for(Account cuenta :[SELECT Numero_de_documento__c FROM Account WHERE Numero_de_documento__c IN :casosPorDNI.keySet()]) {
			if(casosPorDNI.containsKey(cuenta.Numero_de_documento__c)) {
				Case caso = casosPorDNI.get(cuenta.Numero_de_documento__c);
				caso.addError('El numero de DNI ya se encuentra registrado.');
			}
		}
	}

	public static Boolean hasARecordTypeWithMedicoAsignado(Case aCase) {
		Id rtInternacion = XappiaHelper.getRecordType('Case', 'Internacion').Id;
		Id rtSeguimiento = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		Id rtAP = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		Id rtReintegro = XappiaHelper.getRecordType('Case', 'Reintegro').Id;

		return aCase.RecordTypeId == rtInternacion || aCase.RecordTypeId == rtSeguimiento
				|| aCase.RecordTypeId == rtAP || aCase.RecordTypeId == rtReintegro;
	}

	public static Boolean hasChangesSomeFieldToUpdateEM(Case newCase, Case oldCase) {
		return newCase.Prestador__c != oldCase.Prestador__c
				|| newCase.Prescriptor__c != oldCase.Prescriptor__c	
				|| newCase.Consultorio__c != oldCase.Consultorio__c
				|| newCase.Observaciones__c != oldCase.Observaciones__c
				|| newCase.Diagnostico__c != oldCase.Diagnostico__c;
	}

	public static void updateFieldsOnEM(Case[] casos) {
		//Case[] casesQuery = [
			//SELECT Id, Evento_Medico__c
			//FROM Case
			//WHERE Id IN :casos
		//];
		Set<Evento_medico__c> eventosSet = new Set<Evento_medico__c>();
		Evento_medico__c[] eventosToUpdate;

		for(Case aCase : casos) {
			Evento_medico__c em = new Evento_medico__c(Id = aCase.Evento_medico__c);

			em.Cambio_Manual__c = false;
			
			if(String.isNotBlank(aCase.Prestador__c)) {
				em.Prestador__c = aCase.Prestador__c;
			}
			if(String.isNotBlank(aCase.Prescriptor__c)) {
				em.Efector_Solicitante__c = aCase.Prescriptor__c;
				em.Responsable__c = aCase.Prescriptor__c;
			}
			if(String.isNotBlank(aCase.Consultorio__c)) {
				em.Consultorio__c = aCase.Consultorio__c;
			}
			if(String.isNotBlank(aCase.Observaciones__c)) {
				em.Observaciones__c = aCase.Observaciones__c;
			}
			if(String.isNotBlank(aCase.Diagnostico__c)) {
				em.Diagnostico__c = aCase.Diagnostico__c;
			}
			
			eventosSet.add(em);
		}

		eventosToUpdate = new List<Evento_medico__c>(eventosSet);
		update eventosToUpdate;
	}

	public static void checkIfHaveEquipoDeCaso (List<Case> cases, Map<Id, Case> oldCaseMap){
		Id rtReclamos = XappiaHelper.getRecordType('Case', 'Reclamos').Id;
		Id rtConsultas = XappiaHelper.getRecordType('Case', 'Consultas').Id;
		Set<String> groupsNames = new Set<String>{
			'Emi sin material', 'Falseamiento de DDJJ', 'Fertilidad', 'IDOM', 'Medicación alto costo', 'Oxigenoterapia',
			'Programas', 'Reintegros', 'Trámites con material'
		};
		Map<Id, Case> casesToCheck = new Map<Id, Case>();
		Map<Id, Group> groups = new Map<Id, Group>([SELECT Id FROM Group WHERE Name IN :groupsNames AND Type = 'Queue']);
		for(Case caso : cases){
			if(caso.RecordTypeId == rtReclamos || caso.RecordTypeId == rtConsultas) {
				Case thisOldCalse = oldCaseMap.get(caso.Id);
				if(!groups.containsKey(thisOldCalse.OwnerId) && groups.containsKey(caso.OwnerId)) {
					casesToCheck.put(caso.Id, caso);
				} 
			}
		}
		if(!casesToCheck.isEmpty()) {
			Map<Id, List<CaseTeamTemplateRecord>> listOfTeamsByCaseId = new Map<Id, List<CaseTeamTemplateRecord>>();
			for(CaseTeamTemplateRecord team :[SELECT Id, ParentId FROM CaseTeamTemplateRecord WHERE ParentId IN :casesToCheck.keySet()]) {
				if(listOfTeamsByCaseId.containsKey(team.ParentId)) {
					listOfTeamsByCaseId.get(team.ParentId).add(team);
				} else {
					listOfTeamsByCaseId.put(team.ParentId, new List<CaseTeamTemplateRecord> {team});
				}
			}
			for(Case caso : casesToCheck.values()) {
				if(!listOfTeamsByCaseId.containsKey(caso.Id)) {
					caso.addError('Es necesario agregar un Equipo de caso, para poder derivar a una célula');
				}	
			}
		}
	}

	public static void avoidCreationOfReintegroWithALoteThatIsClosed(List<Case> cases) {
		Set<Id> lotesIds = new Set<Id>();
		for (Case caso : cases) {
			if(caso.RecordTypeId == XappiaHelper.getRecordType('Case', 'Reintegro').Id
				&& String.isNotBlank(caso.Lote__c)) {
				lotesIds.add(caso.Lote__c);
			}
		}

		Map<Id, Lote__c> loteById = new Map<Id, Lote__c>([
			SELECT Id, Estado__c
			FROM Lote__c
			WHERE Id IN :lotesIds
		]);

		for (Case caso : cases) {
			if(caso.RecordTypeId == XappiaHelper.getRecordType('Case', 'Reintegro').Id
				&& String.isNotBlank(caso.Lote__c) && loteById.get(caso.Lote__c).Estado__c == 'C') {
				caso.addError('No puede asignar un Lote cerrado a un Reintegro');
			}
		}
	}

	@Future(callout=true)
	public static void darDeBajaCasos(Set<Id> idCases){
		List<Case> cases = [
			SELECT Id, Type,Error__c
			FROM Case
			WHERE Id IN :idCases
		];

		List<Case> casosToUpdate = new List<Case>();

		for(Case caso : cases){
			String body = generateBajaJSON(caso);
			System.debug('***body case: '+ body);
			WSCaseBaja.Response wsResp = WSCaseBaja.darDeBajaCaso(body);
			if(wsResp.hasError){
				caso.Error__c = 'Ha ocurrido el siguiente error al dar de baja el caso: ' + wsResp.message;
			}else{
				caso.Status = 'CA-----N';
			}
			casosToUpdate.add(caso);
		}
		if(!casosToUpdate.isEmpty()){
			update casosToUpdate;
		}

	}

	public static string generateBajaJSON(Case caso){
		String tipoBaja = caso.Type == 'Baja total' ? 'BAJA_T' : 'BAJA_P';

		List<Map<String,Object>> caseJson = new List<Map<String,Object>>{new Map<String,Object>{
				'tipo' => tipoBaja,
				'sf_id' => caso.Id,
				'origen' => 'W',
				'anulado' => 'V' 
			}
		};

		
		Map<String,Object> bodyJson = new Map<String,Object>{
			'caso' => caseJson 
		};

		return JSON.serialize(bodyJson);
	}
}