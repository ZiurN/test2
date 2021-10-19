public class LeadHelper  {

	public static Id perfilFrontId = XappiaHelper.getProfileIdByName('Front');

	//public static void fillFieldsInLeadWhenLocalidadAndCodigoPostalAreFilled(
		//Map<String, Lead> leadsMap, 
		//Set<String> localidadesSet, 
		//Set<String> cpsSet
	//) {
		//for (Localidad__c loc : [
				//SELECT Loc_Id__c, Codigo_de_Provincia__c, Organizador_lookup__c, 
					//OwnerId, Nombre_de_Localidad__c, Codigo_Postal__c,ZG_Codigo__c
				//FROM Localidad__c 
				//WHERE Nombre_de_Localidad__c IN :localidadesSet AND Codigo_Postal__c IN :cpsSet
			//]) 
		//{
			//Lead candidato = leadsMap.get(loc.Codigo_Postal__c + '*-' + loc.Nombre_de_Localidad__c.toUpperCase());
			//candidato.LocId__c = loc.Loc_Id__c;
			//candidato.Provincia__c = loc.Codigo_de_Provincia__c;
			//candidato.Organizador_lookup__c = loc.Organizador_lookup__c;
			//candidato.Zona_Geografica__c = loc.ZG_Codigo__c;
			
			//if (loc.Organizador_lookup__c != null) {
            	//candidato.OwnerId = loc.Organizador_lookup__c;    
            //}
		//}	
	//}

	//public static void fillFieldsInLeadWhenProvinciaAndCodigoPostalAreFilled(
		//Map<String, Lead> leadsMap, 
		//Set<String> provinciasSet, 
		//Set<String> cpsSet
	//) {
		//for (Localidad__c loc : [
				//SELECT Loc_Id__c, Codigo_de_Provincia__c, Organizador_lookup__c, 
					//OwnerId, Nombre_de_Localidad__c, Codigo_Postal__c, ZG_Codigo__c
				//FROM Localidad__c 
				//WHERE Codigo_de_Provincia__c IN :provinciasSet AND Codigo_Postal__c IN :cpsSet
			//]) 
		//{
			//Lead candidato = leadsMap.get(loc.Codigo_Postal__c + '*-' + loc.Codigo_de_Provincia__c);
			//candidato.LocId__c = loc.Loc_Id__c;
			//candidato.Localidad__c = loc.Nombre_de_Localidad__c;
			//candidato.Organizador_lookup__c = loc.Organizador_lookup__c;
			//candidato.Zona_Geografica__c = loc.ZG_Codigo__c;
			
			//if (loc.Organizador_lookup__c != null) {
            	//candidato.OwnerId = loc.Organizador_lookup__c;    
            //}
			//System.debug(candidato);
		//}	
	//}

	public static void fillFieldsInLeadWhenlocIdIsFilled(Map<String, Lead> locIdLeadsMap) {
		for (Localidad__c loc : [
				SELECT Loc_Id__c, Codigo_de_Provincia__c, Organizador_lookup__c, OwnerId,
					Nombre_de_Localidad__c, Codigo_Postal__c,ZG_Codigo__c
				FROM Localidad__c 
				WHERE Loc_Id__c IN :locIdLeadsMap.keySet()
			]) 
		{
			Lead candidato = locIdLeadsMap.get(loc.Loc_Id__c);	
			candidato.LocId__c = loc.Loc_Id__c;
			candidato.Provincia__c = loc.Codigo_de_Provincia__c;
			candidato.Organizador_lookup__c = loc.Organizador_lookup__c;
			candidato.Localidad_new__c = loc.Id;
			candidato.Codigo_postal__c = loc.Codigo_Postal__c;
			candidato.Zona_Geografica__c = loc.ZG_Codigo__c;
			if(candidato.RecordTypeId == XappiaHelper.getRecordType('Lead', 'Individuos').Id){
				if (loc.Organizador_lookup__c != null) {
            		candidato.OwnerId = loc.Organizador_lookup__c;    
				}
			}
		}
	}

	public static String convertLeadsToPersonalAccounts(Set<Id> candidatoIds){
		List<Lead> candidatos = [
			SELECT Id, Email,Company, Conversion_manual__c	,RecordType.Name, MobilePhone,Phone
			FROM Lead 
			WHERE Id IN :candidatoIds 
			AND IsConverted = false 
		];
		System.debug(candidatos);
		List<Account> accountsToCreate = new List<Account>();
		List<Opportunity> oppsToAdd = new List<Opportunity>();
		Map<Id,Account> accsCorp = new Map<Id,Account>();
		Map<Id,Lead> leadMap = new Map<Id, Lead>();
		for(Lead cand : candidatos){
			leadMap.put(cand.Id, cand);
			if(cand.RecordTypeId == XappiaHelper.getRecordType('Lead','Corporativo').Id){
				Account accCorp = new Account(Name = cand.Company);
				accCorp.RecordTypeId = XappiaHelper.getRecordType('Account','Empresa').Id;
				accsCorp.put(cand.Id, accCorp);
			}
		}
		insert accsCorp.values();
		List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
		LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
		for(Lead cand : candidatos){
			Database.LeadConvert lc = new Database.LeadConvert();
			lc.setLeadId(cand.id);
			

			lc.setConvertedStatus(convertStatus.MasterLabel);
			lc.setDoNotCreateOpportunity(false);
			lc.setOwnerId(UserInfo.getUserId());
			if(accsCorp.containsKey(cand.Id)){
				Account corp = accsCorp.get(cand.Id);
				lc.setAccountId(corp.Id);
			}

			leadsToConvert.add(lc);
		}
        Database.LeadConvertResult[] lcr = new List<Database.LeadConvertResult>();
        try{
			lcr = Database.convertLead(leadsToConvert);
        }
        catch (DmlException e){
            if(e.getMessage().contains('DUPLICATES_DETECTED')){
                return 'Error al convertir Candidato: Ya existe una cuenta con el mismo DNI';
            }
            return 'Error al convertir Candidato: ' + e.getMessage();
        }
        System.debug(lcr);
		Map<Id,Lead> accWithLead = new Map<Id, Lead>();
		Map<Id,Lead> oppsWithLead = new Map<Id, Lead>();
		for(Database.LeadConvertResult res : lcr){
			if(res.isSuccess()){
				accWithLead.put(res.getAccountId(),leadMap.get(res.getLeadId()));
				oppsWithLead.put(res.getOpportunityId(),leadMap.get(res.getLeadId()));
			}
		}

		oppsToAdd = [
			SELECT Id, Telefono__c,Tipo_de_Solicitud__c
			FROM Opportunity
			WHERE Id IN :oppsWithLead.keySet()
		];

		accountsToCreate = [
				SELECT Id,RecordTypeId,Correo_electronico__c,Tipo_de_Telefono__c,Type
				FROM Account
				WHERE Id IN :accWithLead.keySet()
		];

		for(Opportunity opp : oppsToAdd){
			Lead cand = oppsWithLead.get(opp.Id);

			if(cand.MobilePhone != null) {
				opp.Telefono__c = cand.MobilePhone;
				opp.Tipo_de_Telefono__c = 'CEL';
			}
			else {
				opp.Telefono__c = cand.Phone;
				opp.Tipo_de_Telefono__c = 'TEL';
			}
			if(opp.Tipo_de_solicitud__c == 'ALTA' && (UserInfo.getProfileId() != LeadHelper.perfilFrontId)){
				opp.Localidad_new__c = cand.Localidad_new__c;
				opp.Organizador_lookup__c = cand.Organizador_lookup__c;
			}		 
		}


		for(Account acc : accountsToCreate){
			if(accWithLead.get(acc.Id).RecordType.Name != 'Corporativo'){
				acc.Correo_electronico__c = accWithLead.get(acc.Id).Email;
				acc.Type = 'Titular';
				String movil = accWithLead.get(acc.Id).MobilePhone;

				if(movil != null){
					acc.Tipo_de_Telefono__c = 'CEL';
					acc.Phone = movil;
				}
				else{
					acc.Tipo_de_Telefono__c = 'TEL';
				}
			}
		}

		List<Database.SaveResult> resOpp = Database.update(oppsToAdd);
		System.debug(resOpp);
		List<Database.SaveResult> resAcc = Database.update(accountsToCreate);
		return null;
	}

	public static void validateRoleInLoc(List<Lead> candidatos){
		String[] profilesWithPermissions = new List<String>{'Administrador del sistema', 'System Administrator', 'CDC'};
		List<Id> locIds = new List<Id>();
		for(Lead candidato : candidatos){
			locIds.add(candidato.Localidad_new__c);
		}
		Map<Id,Localidad__c> locWithOrgMap = new Map<Id,Localidad__c>([
			SELECT Organizador_lookup__r.UserRoleId
			FROM Localidad__c
			WHERE Id IN :locIds
		]);
		User actualUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		System.debug(actualUser.Profile.Name);
		for(Lead candidato : candidatos){
			if(!profilesWithPermissions.contains(actualUser.Profile.Name)) {
				Id orga = locWithOrgMap.get(candidato.Localidad_new__c).Organizador_lookup__r.UserRoleId;
				if(orga == null){
					candidato.addError('No se puede cambiar a una localidad sin organizador.');
				}
				Set<Id> subRoles = XappiaHelper.getAllSubRoleIds(new Set<Id>{orga});
				Set<Id> upperRoles = XappiaHelper.getParentRoleId(new Set<Id>{orga});
				if(orga != null && (!subRoles.contains(UserInfo.getUserRoleId()) && 
									UserInfo.getUserRoleId() != orga &&
									!upperRoles.contains(UserInfo.getUserRoleId()))){
					candidato.Localidad_new__c.addError('No puede cambiar la localidad. No pertenece a esa region');
				}
			}
		}
		
		

	}

	public static void checkNewOwner(List<Lead> candidatos){
		User actualUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		if(actualUser.Profile.Name == 'Administrador del sistema' || actualUser.Profile.Name == 'System Administrator' ||
				actualUser.Profile.Name == 'CDC' || actualUser.Profile.Name == 'Front'){
			return;
		}
		List<Id> ownerIds = new List<Id>();
		for(Lead cand : candidatos){
			ownerIds.add(cand.OwnerId);
		}
		Set<Id> subRoles = XappiaHelper.getAllSubRoleIds(new Set<Id>{UserInfo.getUserRoleId()});
		Set<Id> parentRoles = XappiaHelper.getParentRoleId(new Set<Id>{UserInfo.getUserRoleId()});
		Map<Id,User> owners = new Map<Id,User>([
			SELECT Id, UserRoleId
			FROM User
			WHERE Id IN :ownerIds	
		]);
		for(Lead candidato : candidatos){
			if(!subRoles.contains(owners.get(candidato.OwnerId).UserRoleId) &&
				!parentRoles.contains(owners.get(candidato.OwnerId).UserRoleId)){
				candidato.addError('Solo se puede derivar a un usuario que pertenezca a la misma estructura de funciones.');
			}
		}
	}

	public static void lastModifiedDate(Set<Id> candidatosId) {
		String[] profilesExluded = new List<String>{'Administrador del sistema', 'CDC'};
		User usuario = [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		
		if(profilesExluded.contains(usuario.Profile.Name)) {
			return;
		}

		Lead[] candidatos = [
			SELECT Id,Fecha_modificacion_usuario__c
			FROM Lead
			WHERE Id IN :candidatosId
		];
		
		for(Lead cand : candidatos){
			cand.Fecha_modificacion_usuario__c = Datetime.now();
		}

		update candidatos;
	} 


	//public static void fillFieldsInLeadFromLocalidadWhenLeadSourceIs3(Map<Integer, Lead> leadsMap) {
		//for (Localidad__c loc : [
				//SELECT Loc_Id__c, Codigo_de_Provincia__c, Organizador_lookup__c, OwnerId, Nombre_de_Localidad__c, Codigo_Postal__c
				//FROM Localidad__c 
				//WHERE Loc_Id__c IN :leadsMap.keySet()]) 
		//{
			//Lead candidato = leadsMap.get(Integer.valueOf(loc.Loc_Id__c));	
			////candidato.LocId__c = loc.Loc_Id__c;
			//candidato.Provincia_Texto__c = loc.Codigo_de_Provincia__c;
			//candidato.Organizador_lookup__c = loc.Organizador_lookup__c;
			//candidato.Localidad__c = loc.Nombre_de_Localidad__c;
			//candidato.Cdigo_postal__c = Integer.valueOf(loc.Codigo_Postal__c);
			//if (loc.Organizador_lookup__c != null) {
            	//candidato.OwnerId = loc.Organizador_lookup__c;    
            //}
		//}
	//}

}