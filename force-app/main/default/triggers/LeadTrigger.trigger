trigger LeadTrigger on Lead (before insert,after update , before update)  {

	public static Map<Id,Lead> leadsShouldnotConvert = new Map<Id,Lead>();
	
	if (Trigger.isBefore) {
		UserRole role = [SELECT Id,Name FROM UserRole WHERE DeveloperName = 'Jefe_Canal_Empresa'];
		User[] jefe_canal_empresa = [
			SELECT Id
			FROM User
			WHERE UserRoleId = :role.Id
		];

		if (Trigger.isInsert) {
			List<Lead> leadsLocChanged = new List<Lead>();
			List<Id> localidadesId = new List<Id>();
			for(Lead candidato : Trigger.new){
				candidato.Fecha_modificacion_usuario__c = DateTime.now();
				if(candidato.Localidad_new__c != null &&
					candidato.RecordTypeId == XappiaHelper.getRecordType('Lead','Individuos').Id){
					leadsLocChanged.add(candidato);
				}
				if(candidato.Localidad_new__c != null){
					localidadesId.add(candidato.Localidad_new__c);
				}
			}
			Map<Id,Localidad__c> localidadesMap = new Map<Id,Localidad__c>([
				SELECT Id, Codigo_de_Provincia__c, Codigo_Postal__c, Loc_Id__c, Organizador_lookup__c, ZG_Codigo__c
				FROM Localidad__c
				WHERE Id IN : localidadesId
			]);
			Map<String, Lead> locIdLeadsMap = new Map<String, Lead>();
			for(Lead candidato : Trigger.new){
				Localidad__c loc;
				if(candidato.Localidad_new__c != null){
					loc = localidadesMap.get(candidato.Localidad_new__c);
					System.debug(loc);
					candidato.Provincia__c = loc.Codigo_de_Provincia__c;
					candidato.Codigo_postal__c = loc.Codigo_Postal__c;
                    candidato.Organizador_lookup__c = loc.Organizador_lookup__c;
                    candidato.Zona_Geografica__c = loc.ZG_Codigo__c;
				}
				if(!UserInfo.getName().contains('Integracion') || candidato.LeadSource != '24'){
					if(candidato.RecordTypeId == XappiaHelper.getRecordType('Lead','Individuos').Id){
						if(candidato.LeadSource != '5' && candidato.LeadSource != '4' && candidato.LeadSource != '15' && candidato.LeadSource != '1' && candidato.LeadSource != '6'){
							if (candidato.Localidad_new__c != null && loc.Organizador_lookup__c != null) {
								candidato.OwnerId = loc.Organizador_lookup__c;
							} else if (candidato.LocId__c != null) {
								locIdLeadsMap.put(candidato.LocId__c, candidato);
							}
						}
					}
					System.debug(candidato.RecordTypeId);
					if(candidato.RecordTypeId == XappiaHelper.getRecordType('Lead','Corporativo').Id){
						if(candidato.LocId__c != null){
							locIdLeadsMap.put(candidato.LocId__c, candidato);
							if(!jefe_canal_empresa.isEmpty()){
								candidato.OwnerId = jefe_canal_empresa[0].Id;
							}
						}
					}
				}
				
				
			}

			if (!locIdLeadsMap.isEmpty()) {
				LeadHelper.fillFieldsInLeadWhenlocIdIsFilled(locIdLeadsMap);
			}
			if(!leadsLocChanged.isEmpty()){
				LeadHelper.validateRoleInLoc(leadsLocChanged);
			}
		}

		if(Trigger.isUpdate){
            List<Id> localidadesId = new List<Id>();
			List<Lead> leadsLocChanged = new List<Lead>();
			List<Lead> leadsOwnerChanged = new List<Lead>();
			for(Lead candidato : Trigger.new){
				if(candidato.Localidad_new__c != null){
					localidadesId.add(candidato.Localidad_new__c);
				}
				System.debug(candidato.OwnerId);
				System.debug(Trigger.oldMap.get(candidato.Id).OwnerId);
				if(candidato.RecordTypeId == XappiaHelper.getRecordType('Lead','Individuos').Id &&
					candidato.OwnerId != Trigger.oldMap.get(candidato.Id).OwnerId){
					leadsOwnerChanged.add(candidato);
				}
			}
			Map<Id,Localidad__c> localidadesMap = new Map<Id,Localidad__c>([
				SELECT Id, Codigo_de_Provincia__c, Codigo_Postal__c, Loc_Id__c, Organizador_lookup__c, ZG_Codigo__c
				FROM Localidad__c
				WHERE Id IN : localidadesId
			]);
			Map<String, Lead> locIdLeadsMap = new Map<String, Lead>();
			for(Lead candidato : Trigger.new){
				System.debug('ID RECORD');  
				System.debug(XappiaHelper.getRecordType('Lead','Individuos').Id);
				System.debug(candidato.RecordTypeId);
				if(candidato.Localidad_new__c != Trigger.oldMap.get(candidato.Id).Localidad_new__c &&
					candidato.RecordTypeId == XappiaHelper.getRecordType('Lead','Individuos').Id){
					leadsLocChanged.add(candidato);
				}
				if(candidato.Status == 'Contactado - Interesado' &&
				!candidato.Conversion_manual__c	 &&
				!candidato.IsConverted &&
				candidato.RecordTypeId == XappiaHelper.getRecordType('Lead','Corporativo').Id){
					candidato.Es_corporativo__c = true;
				}
                
				Localidad__c loc;
				if(candidato.Localidad_new__c != null){
					loc = localidadesMap.get(candidato.Localidad_new__c);
					System.debug(loc);
					candidato.Provincia__c = loc.Codigo_de_Provincia__c;
					candidato.Codigo_postal__c = loc.Codigo_Postal__c;
					//candidato.LocId__c = loc.Loc_Id__c;
                    candidato.Organizador_lookup__c = loc.Organizador_lookup__c;
                    candidato.Zona_Geografica__c = loc.ZG_Codigo__c;
				}
				if(candidato.RecordTypeId == XappiaHelper.getRecordType('Lead','Individuos').Id){
					String[] sourcesNotChangeLoc = new List<String>{'1', '4', '5', '6', '15'};
					Boolean isQueueOwner = String.valueOf(candidato.OwnerId).substring(0, 3) 
											!= User.sObjectType.getDescribe().getKeyPrefix();

                    if(isQueueOwner || !sourcesNotChangeLoc.contains(candidato.LeadSource)){
						if (candidato.Localidad_new__c != null &&
						 candidato.Localidad_new__c != Trigger.oldMap.get(candidato.Id).Localidad_new__c &&
						 loc.Organizador_lookup__c != null) {
							candidato.OwnerId = loc.Organizador_lookup__c;
						} else if (candidato.LocId__c != null && candidato.LocId__c != Trigger.oldMap.get(candidato.Id).LocId__c) {
							locIdLeadsMap.put(candidato.LocId__c, candidato);
						}
					}
				}

				System.debug(candidato.RecordTypeId);
				if(candidato.RecordTypeId == XappiaHelper.getRecordType('Lead','Corporativo').Id){
					System.debug('Es corpo');
					if(candidato.LocId__c != null){
						locIdLeadsMap.put(candidato.LocId__c, candidato);
						System.debug(jefe_canal_empresa);
						if(!jefe_canal_empresa.isEmpty()){
							System.debug('Entro al update');
							candidato.OwnerId = jefe_canal_empresa[0].Id;
						}
					}
				}
				System.debug(candidato.OwnerId);
				//if(candidato.RecordTypeId == XappiaHelper.getRecordType('Lead','Corporativo').Id){
					//if(candidato.Localidad_new__c != null){
						//if((candidato.LeadSource == '5' || candidato.LeadSource == '15' || candidato.LeadSource == '21' ||
						//candidato.LeadSource == '4'  || candidato.LeadSource == '1') && loc.Organizador_lookup__c != null){
							//candidato.OwnerId = loc.Organizador_lookup__c;
						//}
					//}
					//else{
						//if(candidato.LocId__c != null){
							//locIdLeadsMap.put(candidato.LocId__c, candidato);
						//}
					//}
				//}
			}

			System.debug(leadsLocChanged);
			if(!leadsLocChanged.isEmpty()){
				LeadHelper.validateRoleInLoc(leadsLocChanged);
			}

			if (!locIdLeadsMap.isEmpty()) {
				LeadHelper.fillFieldsInLeadWhenlocIdIsFilled(locIdLeadsMap);
			}

			if(!leadsOwnerChanged.isEmpty()){
				LeadHelper.checkNewOwner(leadsOwnerChanged);
			}
				

		}

	}
	if(Trigger.isAfter){
		

		if(Trigger.isUpdate){
			Set<Id> candidatosModificados = new Set<Id>();

			Set<Id> candidatosAConvertir = new Set<Id>();
			for (Lead candidato : Trigger.new) {
				if(Trigger.oldMap.get(candidato.Id).Fecha_modificacion_usuario__c == candidato.Fecha_modificacion_usuario__c 
					&& candidato.Status == 'Nuevo'
				) {
					candidatosModificados.add(candidato.Id);
				}
                //System.debug(candidato.OwnerId);
				//if(candidato.RecordTypeId == XappiaHelper.getRecordType('Lead','Corporativo').Id){
					//candidato.Es_corporativo__c = true;
				//}
                
				if(candidato.Status == 'Contactado - Interesado' &&
						!candidato.Conversion_manual__c	 &&
						!candidato.IsConverted){

					candidatosAConvertir.add(candidato.Id);
				}
			}

			String result;

			if(!candidatosAConvertir.isEmpty()) {
				result = LeadHelper.convertLeadsToPersonalAccounts(candidatosAConvertir);
			}

            if(result != null){
                for (Lead candidato : Trigger.new) {
                
                
                    if(candidato.Status == 'Contactado - Interesado' &&
                            !candidato.Conversion_manual__c	 &&
                            !candidato.IsConverted){
    
                        candidato.addError(result);
                    }
				}
            }

			if(!candidatosModificados.isEmpty()){
				LeadHelper.lastModifiedDate(candidatosModificados);
			}
            
		}
	}
}