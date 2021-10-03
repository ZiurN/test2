/**
 * Created by xappia on 12/2/20.
 */

trigger CaseTrigger on Case (before insert, before update, after insert, after update) {
	//Profile pUser = [SELECT Id,Name FROM Profile WHERE Id = :UserInfo.getProfileId()];

	Id casoATipificarRtId = XappiaHelper.getRecordType('Case', 'Caso_a_tipificar').Id;
	Id solicitudDeDatosParticulares = XappiaHelper.getRecordType('Case','Solicitud_de_datos_particulares').Id;
	Id apRtId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
	Id internacionRtId = XappiaHelper.getRecordType('Case', 'Internacion').Id;
	Id reintegroRtId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
	Id seguimientoRtId = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;

	List<Id> casosValidosActualizarStatus = new List<Id>{
		XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id,
		XappiaHelper.getRecordType('Case', 'Reintegro').Id,
		XappiaHelper.getRecordType('Case', 'Internacion').Id,
		XappiaHelper.getRecordType('Case', 'Seguimiento').Id,
		XappiaHelper.getRecordType('Case', 'Solicitud_de_alta_familiar').Id,
		XappiaHelper.getRecordType('Case', 'Solicitud_de_despegues').Id
	};

    if(Trigger.isBefore){
        if(Trigger.isInsert) {
			List<Case> casesToChangeDelegacionFront = new List<Case>();
		
            CaseHelper.checkDuplicateDNIOnAltaFamiliar(Trigger.new);
			caseLiveChatHelper.assignAccounts(Trigger.new);
            SLAUtils.assignEntitlements(Trigger.new);
			CaseHelper.avoidCreationOfReintegroWithALoteThatIsClosed(Trigger.new);
			
		}
        if(Trigger.isUpdate) {
			CaseHelper.checkIfHaveEquipoDeCaso(Trigger.new, Trigger.oldMap);
            CaseHelper.checkDuplicateDNIOnAltaFamiliar(Trigger.new);
            CaseHelper.changeStatusToClosed(Trigger.new, Trigger.oldMap);
			Set<Id> casesIdBaja = new Set<Id>();
			List<Case> casesToUpdateStatus = new List<Case>();
			List<Case> casesToChangeDelegacion = new List<Case>();
            List<Case> updatedCases = new List<Case>();
            List<Case> casesWhereEstadoDeDocumentacionIsChanged = new List<Case>();
			List<Case> casesToCloseSla = new List<Case>();
			List<Case> casesWithMedicoAsignadoChangedAndOldInNull = new List<Case>();
			List<Case> casesWithMedicoAsignadoChangedAndOldNotNull = new List<Case>();
			List<Case> casesWithResponsableChangedAndOldInNull = new List<Case>();
			List<Case> casesWithResponsableChangedAndOldNotNull = new List<Case>();
			List<Case> casesWithResponsablePresuChangedAndOldInNull = new List<Case>();
			List<Case> casesWithResponsablePresuChangedAndOldNotNull = new List<Case>();
			List<Case> casesToUpdateFieldsOnEM = new List<Case>();
			List<Case> casesToChangeLote = new List<Case>();
			Map<Id, Case> casesToReopenSLAById = new Map<Id, Case>();

            for(Case caso : Trigger.new) {
                Case oldCase = Trigger.oldMap.get(caso.Id);
				Boolean rtToValidateResp = caso.RecordTypeId == seguimientoRtId || caso.RecordTypeId == internacionRtId 
											|| caso.RecordTypeId == reintegroRtId || caso.RecordTypeId == apRtId;
				Boolean isFromEM = String.isNotBlank(caso.Evento_Medico__c) 
									&& (caso.RecordTypeId == seguimientoRtId || caso.RecordTypeId == internacionRtId);
				
				/*Boolean rtToDontUpdateStatus = (caso.RecordTypeId == apRtId ||
					caso.RecordTypeId == internacionRtId ||
					caso.RecordTypeId == reintegroRtId ||
					caso.RecordTypeId == seguimientoRtId) && oldCase.RecordTypeId != casoATipificarRtId;*/
				

				if(oldCase.RecordTypeId == casoATipificarRtId && oldCase.RecordTypeId != caso.RecordTypeId){
					caso.Cambio_Manual__c = false;
					caso.Usuario__c = null;
					if(caso.Type == null){
						Case dummyCase = (Case)Case.sObjectType.newSObject(caso.RecordTypeId,true);
						System.debug(caso.Type);
						System.debug(dummyCase.Type);
						
						caso.Type = dummyCase.Type;
					}

					casesToChangeDelegacion.add(caso);
					if(casosValidosActualizarStatus.contains(caso.RecordTypeId)){
						casesToUpdateStatus.add(caso);
					}else if(caso.RecordTypeId == solicitudDeDatosParticulares){
						caso.SuppliedEmail = '';
					}
				}

				if(oldCase.Medico_asignado__c != caso.Medico_asignado__c && rtToValidateResp) {
					if (oldCase.Medico_asignado__c == null) {
						casesWithMedicoAsignadoChangedAndOldInNull.add(caso);
					}
					else {
						casesWithMedicoAsignadoChangedAndOldNotNull.add(caso);
					}
					
				}

				if(oldCase.Responsable_de_presupuesto__c != caso.Responsable_de_presupuesto__c && rtToValidateResp) {
					if (oldCase.Responsable_de_presupuesto__c == null) {
						casesWithResponsablePresuChangedAndOldInNull.add(caso);
					}
					else {
						casesWithResponsablePresuChangedAndOldNotNull.add(caso);
					}
					
				}

				if(oldCase.Usuario__c != caso.Usuario__c && rtToValidateResp && oldCase.RecordTypeId != casoATipificarRtId) {
					if (oldCase.Usuario__c == null) {
						casesWithResponsableChangedAndOldInNull.add(caso);
					}
					else {
						casesWithResponsableChangedAndOldNotNull.add(caso);
					}
				}
				
				if((caso.Status == 'CA-----G' && oldCase.Status == 'Rechazado') 
					|| (!caso.Caso_Rechazado__c && oldCase.Caso_Rechazado__c)
				) {
					casesToReopenSLAById.put(caso.Id, caso);
				}

                if(caso.FormulatiempoSLA__c != oldCase.FormulatiempoSLA__c
					|| (caso.AccountId != oldCase.AccountId && oldCase.AccountId == null)
				) {
                    updatedCases.add(caso);
                }

                if(caso.Estado_de_documentacion__c != oldCase.estado_de_documentacion__c
                  && caso.Estado_de_documentacion__c != 'Documentacion faltante')
                {
                    casesWhereEstadoDeDocumentacionIsChanged.add(caso);
                }

				if(isFromEM && CaseHelper.hasChangesSomeFieldToUpdateEM(caso, oldCase)) {
					casesToUpdateFieldsOnEM.add(caso);
				}

				if((!oldCase.Retencion_lograda__c && caso.Retencion_lograda__c) && caso.Origin == 'Web'){
					casesIdBaja.add(caso.Id);
				}
				System.debug('caso testttt ' + caso);
				if(caso.RecordTypeId == reintegroRTId && caso.Status == 'Rechazado'){
					caso.Derivacion_de_lote__c	= 'Lote Devolucion';
					casesToChangeLote.add(caso);
				}
            }
			if(!casesToChangeLote.isEmpty()){
				if(!Test.isRunningTest()){
					Lote__c lote;
					if(ConfigUtils.isSandboxEnviroment()){
						lote = [
							SELECT Id,Name
							FROM Lote__c
							WHERE Name = 'LOTE-0004'
						];
					}else{
						lote = [
							SELECT Id,Name
							FROM Lote__c
							WHERE Name = 'LOTE-0001' 
						];
					}
					for(Case caso : casesToChangeLote){
						caso.Lote__c = lote.Id;
					}	
				}
			}
			if(!casesToChangeDelegacion.isEmpty()){
				CaseHelperWithoutSharing.cambiarDelegacionCDC(casesToChangeDelegacion);
			}
			if(!casesToUpdateStatus.isEmpty()){
				CaseHelperWithoutSharing.changeStateToDefaultPicklist(casesToUpdateStatus);
			}
			if(!casesIdBaja.isEmpty()){
				CaseHelper.darDeBajaCasos(casesIdBaja);
			}
			if(!casesToReopenSLAById.isEmpty()) {
				SLAUtils.reopenSLA(casesToReopenSLAById);
			}
			if(!updatedCases.isEmpty()) {
				SLAUtils.assignEntitlements(updatedCases);
			}
			
			if(!casesWithMedicoAsignadoChangedAndOldInNull.isEmpty()) {
				CaseHelper.validateMedicoAsignadoOldInNull(casesWithMedicoAsignadoChangedAndOldInNull, 'medico');
			}
			if(!casesWithMedicoAsignadoChangedAndOldNotNull.isEmpty()) {
				CaseHelper.validateMedicoAsignadoOldNotNull(casesWithMedicoAsignadoChangedAndOldNotNull, 'medico');
			}
			if(!casesWithResponsableChangedAndOldInNull.isEmpty()) {
				CaseHelper.validateMedicoAsignadoOldInNull(casesWithResponsableChangedAndOldInNull, 'responsable');
			}
			if(!casesWithResponsableChangedAndOldNotNull.isEmpty()) {
				CaseHelper.validateMedicoAsignadoOldNotNull(casesWithResponsableChangedAndOldNotNull, 'responsable');
			}
			if(!casesWithResponsablePresuChangedAndOldInNull.isEmpty()) {
				CaseHelper.validateMedicoAsignadoOldInNull(casesWithResponsablePresuChangedAndOldInNull, 'presupuesto');
			}
			if(!casesWithResponsablePresuChangedAndOldNotNull.isEmpty()) {
				CaseHelper.validateMedicoAsignadoOldNotNull(casesWithResponsablePresuChangedAndOldNotNull, 'presupuesto');
			}
			
			if(casesWhereEstadoDeDocumentacionIsChanged.size() > 0) {
                CaseHelper.derivaconAlCompletarDocumentacion(casesWhereEstadoDeDocumentacionIsChanged);
            }

			if(!casesToUpdateFieldsOnEM.isEmpty()) {
				CaseHelper.updateFieldsOnEM(casesToUpdateFieldsOnEM);
			}

        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            Map<Id, List<Case>> userIdCasesMap = new Map<Id, List<Case>>();
			List<Id> casesToChangeDelegacionFront = new List<Id>();
            for (Case caso : Trigger.new) {
				
				if(caso.RecordTypeId == casoATipificarRtId){
					System.debug('entro ' + caso);
					casesToChangeDelegacionFront.add(caso.Id);
				}
				
                if (userIdCasesMap.containsKey(caso.OwnerId)) {
                    List<Case> casesFromMap = userIdCasesMap.get(caso.OwnerId);
                    casesFromMap.add(new Case(Id = caso.Id));
                    userIdCasesMap.put(caso.OwnerId, casesFromMap);
                } else {
                    userIdCasesMap.put(caso.OwnerId, new List<Case>{new Case(Id = caso.Id)});
                }
            }
            if (!userIdCasesMap.isEmpty()) {
                CaseHelper.assignDelegacionFromUser(userIdCasesMap);
            }
			if(!casesToChangeDelegacionFront.isEmpty()){
				CaseHelperWithoutSharing.cambiarDelegacionFront(casesToChangeDelegacionFront);
			}
			
        }
        if (Trigger.isUpdate){
            List<Case> reintegrosAReasignar =  new List<Case>();
            Map<Id, String> mapCases = new Map<Id, String>();
			Case[] casesChangeAlertAMPending = new List<Case>();
			Map<Id, Case> casesToReopenSLAById = new Map<Id, Case>();
			Boolean isAsync = System.isFuture() || System.isQueueable();

			for(Case caso : Trigger.new){
				Case oldCase = Trigger.oldMap.get(caso.Id);
				Boolean changeContieneAlertaAM = caso.Contiene_alerta_AM__c != oldCase.Contiene_alerta_AM__c;
				Boolean changeSinAlertaAM = caso.Sin_alertas_AM_pendientes__c != oldCase.Sin_alertas_AM_pendientes__c;

				if(caso.RecordTypeId == reintegroRtId
					&& caso.Lote__c != Trigger.oldMap.get(caso.Id).Lote__c
					&& caso.Codigo_reintegro_SS__c != null
				) {
					reintegrosAReasignar.add(caso);
                }
				
				if(caso.Evento_Medico__c != null && (changeContieneAlertaAM || changeSinAlertaAM)) {
					casesChangeAlertAMPending.add(caso);
				}


                if(caso.RecordTypeId == XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id) {
									   
                    if(caso.Status == 'CA-----N') { 
                        mapCases.put( caso.Orden_de_Compra__c, 'Anulada');
                    }
									   
                    else if(caso.Status == 'CA-----E') {
                        mapCases.put(caso.Orden_de_Compra__c, 'Finalizada');
                    }
                    
                    else if(caso.Status == 'Rechazado' || caso.caso_rechazado__c == true) {
                        mapCases.put(caso.Orden_de_Compra__c, 'Rechazada');
                    }
                }
                
            }
			
            List<Orden_de_Compra__c> ordenes = [
                SELECT Id, Estado_OC__c, (SELECT Id FROM Cotizaciones_Prestadores__r)
                FROM Orden_de_Compra__c
                WHERE Id IN :mapCases.keySet()
            ];

            
            for (Orden_de_Compra__c orden : ordenes) {
                orden.Estado_OC__c = mapCases.get(orden.Id);
                if(orden.Estado_OC__c == 'Finalizada' && orden.Cotizaciones_Prestadores__r.isEmpty()) {
                    orden.Estado_OC__c = 'Desestimada';
                }
            }
            
            update ordenes; 

			if(!reintegrosAReasignar.isEmpty() && !isAsync) {
				System.enqueueJob(new ReintegroReasignacionQueueable(reintegrosAReasignar));
			}

			if(!casesChangeAlertAMPending.isEmpty()) {
				CaseHelper.checkNoAlertsPendingOnEM(casesChangeAlertAMPending);
			}

        }
    }

}