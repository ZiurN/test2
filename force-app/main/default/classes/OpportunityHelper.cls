public class OpportunityHelper  {
	public static void addAccountToOpportunityWithRecordTypeIndividualCorporativo(
		Map<String, List<Opportunity>> opportunityMap
		) {
		for (Opportunity opp : [
				SELECT AccountId 
				FROM Opportunity
				WHERE Id IN :opportunityMap.keySet()
			]) {
			for (Opportunity oportunidad : opportunityMap.get(opp.Id)) {
				oportunidad.AccountId = opp.AccountId;
			}
		}
	}

	public static void checkReintegroIndCorp(List<Opportunity> opps){
		List<String> dnis = new List<String>();
		for(Opportunity opp : opps){
			if(opp.Numero_de_documento__c != null){
				dnis.add(opp.Numero_de_documento__c);
			}
		}
		if(dnis.isEmpty()){
			return;
		}
		List<Account> accounts = [SELECT Id,Numero_de_documento__c,
										Codigo_de_Afiliado__c,
										Estado__c
								FROM Account
								WHERE Numero_de_documento__c IN :dnis];
		Map<String,Account> duplicateDnis = new Map<String,Account>();
		List<String> activeDnis = new List<String>();
		for (Account acc : accounts) {
			if (acc.Estado__c == 'B') {
				duplicateDnis.put(acc.Numero_de_documento__c,acc);
			} else {
				activeDnis.add(acc.Numero_de_documento__c);
			}
		}
		for(Opportunity opp : opps){
			if(activeDnis.contains(opp.Numero_de_documento__c)){
				opp.addError('Ya existe una cuenta activa con el mismo DNI');
			}
			if(duplicateDnis.keySet().contains(opp.Numero_de_documento__c)){
				opp.Tipo_de_Solicitud__c = 'REINGRESO';
				opp.AccountId = duplicateDnis.get(opp.Numero_de_documento__c).Id;
				opp.Nro_de_asociado__c = duplicateDnis.get(opp.Numero_de_documento__c).Codigo_de_Afiliado__c;
			}
		}
	}

	//@Future(callout=true)
	//public static void getNroAsociadoForIntegrantes(List<Id> oppIds){
		//List<Integrante__c> intList = [
			//SELECT Id, Tipo_de_Documento__c, Nro_de_documento__c
			//FROM Integrante__c 
			//WHERE Oportunidad__c IN :oppIds
		//];
		//System.debug(intList);
		//for(Integrante__c inte : intList){
			//WSAfiliadoGetInfo.Response resp = WSAfiliadoGetInfo.getAsociado(inte.Tipo_de_Documento__c,String.valueOf(inte.Nro_de_documento__c));
			//inte.Nro_de_asociado__c = resp.info.data.codigo;
		//}
		//Database.SaveResult[] results = Database.update(intList,false);
		//System.debug(results);

	//}

	public static void createAccWhenOpportunityIndividualCorporativoChangedToClosedWin(List<Opportunity> oppList){
		Map<Id, Account> accMap = new Map<Id, Account> ();
		for (Opportunity opp : oppList) {
			Account newAcc = new Account ();
			newAcc.RecordTypeId = XappiaHelper.getRecordType('Account', 'Cuenta_personal').Id;
			newAcc.FirstName = opp.Nombre_INDCORP__c != null ? opp.Nombre_INDCORP__c : opp.Name.substringAfter(' ');
			newAcc.LastName = opp.Apellido_INDCOR__c != null ? opp.Apellido_INDCOR__c : opp.Name.substringBefore(' ');
			newAcc.PersonBirthdate = opp.Fecha_de_Nacimiento__c;
			newAcc.Tipo_de_documento__c = opp.Tipo_de_Documento__c;
			newAcc.Numero_de_documento__c = opp.Numero_de_documento__c;
			newAcc.CUIT__c = opp.CUIT__c;
			newAcc.Sexo__c = opp.Sexo__c;
			newAcc.Estado_civil__c = opp.Estado_Civil__c;
			newAcc.Type = 'TIT';
			newAcc.Localidad_new__c = opp.Localidad_new__c;
			newAcc.Empresa__c = opp.AccountId;
			if(opp.Fecha_de_vigencia_de_solicitud__c <= Date.today()){
				newAcc.Estado__c = 'A';
			}
			accMap.put(opp.Id, newAcc);
		}
		
		Database.UpsertResult[] results = Database.upsert(accMap.values(), Account.Numero_de_documento__c);
		System.debug('****resultsAccsCreatedFromOppClosedWin: ' + results);

		List<Opportunity> listaClones = new List<Opportunity>();
		List<Id> oppsId = new List<Id>();
		for(Opportunity opp : oppList){
			oppsId.add(opp.Id);
			//Opportunity clon = new Opportunity(Id = opp.Id);
			//clon.AccountId = accMap.get(opp.Id).Id;
			//listaClones.add(clon);
		}
		OpportunityHelper.createGrupoFamiliarWhenOpportunityIndividuosChangedToClosedWin(oppsId,accMap);

		update listaClones;
	}

	public static void createGrupoFamiliarWhenOpportunityIndividuosChangedToClosedWin(List<Id> oppIds,Map<Id, Account> accMap){

		List<Integrante__c> listaIntegrantes = [
			SELECT Id, Oportunidad__c, Oportunidad__r.AccountId, Apellido__c, Nombre__c, Fecha_de_Nacimiento__c, Telfono__c,
					Tipo_de_Documento__c, Nro_de_documento__c, CUIT_Sin_guiones__c, Correo_electronico__c,
					Sexo__c, Obra_social_actual__c, Tipo_de_relacion_con_titular__c, Estado_Civil__c,
					Oportunidad__r.Tipo_de_Solicitud__c,Nro_de_asociado__c,Integrante_de_reingreso__c,
					Oportunidad__r.Reingresa_como__c
			FROM Integrante__c 
			WHERE Oportunidad__c IN :oppIds
		];
		List<Id> integrantesId = new List<Id>();
		Map<Integrante__c, Account> accToInsert = new Map<Integrante__c, Account>();
		for(Integrante__c integrante : listaIntegrantes){
			integrantesId.add(integrante.Id);
			Account newAcc = new Account(
				RecordTypeId = XappiaHelper.getRecordType('Account', 'Cuenta_personal').Id,
				LastName = integrante.Apellido__c,
				FirstName = integrante.Nombre__c,
				Phone = integrante.Telfono__c,
				Correo_electronico__c = integrante.Correo_electronico__c,
				Parentesco__c = integrante.Tipo_de_relacion_con_titular__c,
				CUIT__c = integrante.CUIT_Sin_guiones__c,
				//Estado__c = 'A',
				Type = 'FAM'
			);
			System.debug(newAcc);
			System.debug(integrante.Correo_electronico__c);
			if(integrante.Integrante_de_reingreso__c != null){
				newAcc.Id = integrante.Integrante_de_reingreso__c;
			}
			newAcc.Numero_de_documento__c = integrante.Nro_de_documento__c;
			newAcc.Tipo_de_documento__c = integrante.Tipo_de_Documento__c;
			newAcc.Codigo_de_Afiliado__c = integrante.Nro_de_asociado__c;
			if(integrante.Oportunidad__r.Tipo_de_Solicitud__c != 'REINGRESO') {
				if(accMap == null){
					newAcc.Titular__c = integrante.Oportunidad__r.AccountId;
				}
				else{
					newAcc.Titular__c = accMap.get(integrante.Oportunidad__c).Id;
				}
			}
			else{
				if(integrante.Oportunidad__r.Reingresa_como__c == 'Titular'){
					if(accMap == null){
						newAcc.Titular__c = integrante.Oportunidad__r.AccountId;
					}
				}
			}
			accToInsert.put(integrante, newAcc);
		}
		Database.UpsertResult[] res = Database.upsert(accToInsert.values(),false);
		System.debug(res);

		Map<Id, Grupo_Familiar__c> gFamiliarToInsert = new Map<Id, Grupo_Familiar__c>();
		List<Grupo_Familiar__c> gFamExisting = [
			SELECT Id,Integrante__c,Titular_del_Grupo_Familiar__c
			FROM Grupo_Familiar__c
			WHERE Integrante__c IN :integrantesId
		];

		for(Grupo_Familiar__c gfam : gFamExisting){
			gFamiliarToInsert.put(gfam.Integrante__c,gfam);
		}
		for(Integrante__c integrante : accToInsert.keySet()){
			Id titular;
			if(accMap == null){
				titular = integrante.Oportunidad__r.AccountId;
			}
			else{
				titular = accMap.get(integrante.Oportunidad__c).Id;
			}
			Grupo_Familiar__c newFamiliar = new Grupo_Familiar__c();
			if(gFamiliarToInsert.containsKey(integrante.Id)){
				newFamiliar.Id = gFamiliarToInsert.get(integrante.Id).Id;
			}
			newFamiliar.Integrante__c = accToInsert.get(integrante).Id;
			newFamiliar.Relacion_con_el_titular__c = integrante.Tipo_de_relacion_con_titular__c;
			newFamiliar.Titular_del_Grupo_Familiar__c = titular;

			gFamiliarToInsert.put(integrante.Oportunidad__r.AccountId,newFamiliar);
		}
		List<Account> accCodigoAfiliado = [SELECT Id, Codigo_de_Afiliado__c FROM Account WHERE Id IN :gFamiliarToInsert.keySet()];
		for (Account acc : accCodigoAfiliado) {
			gFamiliarToInsert.get(acc.Id).Nro_de_socio_del_titular__c = acc.Codigo_de_Afiliado__c;
		}
		Database.UpsertResult[] resGFam = Database.upsert(gFamiliarToInsert.values(),false);
		System.debug(resGFam);
	}

	public static void activateThePersonAccounts(List<Opportunity> opps) {
		//Map<Id, Account> accsToActivateMap = new Map<Id, Account>([SELECT Id FROM Account WHERE Opportunities =: opps]);
		List<Account> accsToActivateList = new List<Account>();
		Map<Id, Opportunity> oppsMap = new Map<Id, Opportunity>([SELECT AccountId,Oportunidad_Corporativa__c, Oportunidad_Corporativa__r.AccountId FROM Opportunity WHERE Id =: opps]);
		//for(Opportunity opp : opps) {
			//Account acc = opp.Account;
			//acc.Afi_Id__c = opp.Nro_de_asociado__c;
			//acc.Estado__c = 'Activo';

			//accsToActivateList.add(acc);
		//}

		for(Opportunity opp : opps) {
			Account acc = new Account();
			acc.Id = oppsMap.get(opp.Id).AccountId;
			acc.Codigo_de_Afiliado__c = opp.Nro_de_asociado__c;
			acc.Numero_de_documento__c = opp.Numero_de_documento__c;
			if(opp.Fecha_de_vigencia_de_solicitud__c <= Date.today()){
				acc.Estado__c = 'A';
			}
			//-------------------------------------------------------------
			//acc.Codigo_pais__c = opp.Nacionalidad__c;
			acc.Sexo__c = opp.Sexo__c;
			acc.Obra_social__c = opp.Obra_social_del_titular__c;
			acc.PersonBirthdate = opp.Fecha_de_Nacimiento__c;
			acc.CUIT__c = opp.CUIT__c;
			acc.Delegacion__c = opp.Agencia__c;
			//Map<String, String> fieldProfesion = XappiaHelper.getPicklistLabelAndValues('Opportunity', 'ActividadProfesion_del_titular__c');
			//acc.Actividad_codigo__c = opp.ActividadProfesion_del_titular__c;
			//acc.Actividad_nombre__c = fieldProfesion.get(opp.ActividadProfesion_del_titular__c);
			acc.Estado_civil__c = opp.Estado_Civil__c;
			acc.Localidad_new__c = opp.Localidad_new__c;
			acc.Segmento_de_grupo_familiar__c = opp.Segmento_del_Grupo_Familiar__c;
			acc.Empresa__c = oppsMap.get(opp.Id).Oportunidad_Corporativa__c != null ? 
				oppsMap.get(opp.Id).Oportunidad_Corporativa__r.AccountId : null;
			accsToActivateList.add(acc);
		}

		List<Database.SaveResult> results = Database.update(accsToActivateList);
	}

	public static void copyPasteDataFromAccountToOpportunity(List<Opportunity> opps, Map<String, Id> idOppIdAccMap) {
		Map<String, Account> accs = new Map<String, Account>([
			SELECT Tipo_de_documento__c, Numero_de_documento__c, Type, Obra_social__c, Codigo_pais__c, Sexo__c, Segmento_de_grupo_familiar__c,
				Estado_civil__c, PersonBirthdate, CUIT__c, Delegacion__c, Localidad_new__c, Phone, PersonEmail,
				FirstName, LastName,Localidad_new__r.Organizador_lookup__c
			FROM Account
			WHERE Id IN :idOppIdAccMap.values()
		]);
		Map<Id,Localidad__c> localidades = new Map<Id,Localidad__c>();
		Set<Id> setIdLocalidadFromOpp = new Set<Id>();
		for(Opportunity opp : opps){
			if(opp.Localidad_new__c != null){
				setIdLocalidadFromOpp.add(opp.Localidad_new__c);
			}
			if(accs.containsKey(opp.AccountId)){
				setIdLocalidadFromOpp.add(accs.get(opp.AccountId).Localidad_new__c);
			}
		}
		if(!setIdLocalidadFromOpp.isEmpty()){
			localidades.putAll([
				SELECT Id, Organizador_lookup__c
				FROM Localidad__c
				WHERE Id IN :setIdLocalidadFromOpp
			]);
		}
		
		System.debug('accs ' + accs);

		List<Opportunity> oppsToUpdateList = new List<Opportunity>();

		for(Opportunity opp : opps) {
			List<String> nacionalidades = XappiaHelper.getPicklistFieldValues('Opportunity', 'Nacionalidad__c');
			String accId = idOppIdAccMap.get(opp.Id);
			System.debug('accId ' + accId);
			Account acc = accs.get(accId);
			
			if(acc != null) {
				System.debug('acc ' + acc);
				System.debug('opp ' + opp);
				opp.Agencia__c = opp.Agencia__c != null ? opp.Agencia__c : acc.Delegacion__c;
				opp.Localidad_new__c = opp.Localidad_new__c != null ? opp.Localidad_new__c : acc.Localidad_new__c;
				if(localidades.containsKey(opp.Localidad_new__c)){
				
					opp.Organizador_lookup__c = localidades.get(opp.Localidad_new__c).Organizador_lookup__c;
				
				}else if(localidades.containsKey(acc.Localidad_new__c)){
				
					opp.Organizador_lookup__c = localidades.get(acc.Localidad_new__c).Organizador_lookup__c;
				
				}
				if(acc.Type == 'TIT' && opp.Obra_social_del_titular__c == null) {
					opp.Obra_social_del_titular__c = acc.Obra_social__c;
				}
				opp.Estado_Civil__c = opp.Estado_Civil__c != null ? opp.Estado_Civil__c
										 : acc.Estado_civil__c;
				opp.Nacionalidad__c = opp.Nacionalidad__c != null ? opp.Nacionalidad__c 
										: nacionalidades.contains(acc.Codigo_pais__c) ? acc.Codigo_pais__c 
										: null;
				opp.Sexo__c = acc.Sexo__c;
				opp.Fecha_de_Nacimiento__c = opp.Fecha_de_Nacimiento__c != null ? opp.Fecha_de_Nacimiento__c : acc.PersonBirthdate;

				//opp.Telefono__c = acc.Phone;
				//opp.Correo_Electronico__c = acc.PersonEmail;
				//opp.Tipo_de_Documento__c = acc.Tipo_de_documento__c;
				//opp.Numero_de_documento__c = acc.Numero_de_documento__c;
				//opp.CUIT__c = acc.CUIT__c;
				opp.Telefono__c = fillIfComplete(opp.Telefono__c, acc.Phone);
				opp.Correo_Electronico__c = fillIfComplete(opp.Correo_Electronico__c, acc.PersonEmail);
				opp.Tipo_de_Documento__c = fillIfComplete(opp.Tipo_de_Documento__c, acc.Tipo_de_documento__c);
				opp.Numero_de_documento__c = fillIfComplete(opp.Numero_de_documento__c, acc.Numero_de_documento__c);
				opp.CUIT__c = fillIfComplete(opp.CUIT__c, acc.CUIT__c);
				opp.Nombre_INDCORP__c = acc.FirstName; 
				opp.Apellido_INDCOR__c = acc.LastName;
				//opp.Segmento_del_Grupo_Familiar__c = acc.Segmento_de_grupo_familiar__c;
			}
			
		}

	}




	private static String fillIfComplete(String fieldToFill, String fieldFull) {
		return fieldToFill != null ? fieldToFill : fieldFull;
	}

	//private static String seleccionarEstadoCivil(String inicial){
		//switch on inicial {
			//when 'C' {
				//return 'Casado';
			//}
			//when 'N' {
				//return 'Concubinato';
			//}
			//when 'D' {
				//return 'Divorciado';
			//}
			//when 'P' {
				//return 'Separado';
			//}
			//when 'S' {
				//return 'Soltero';
			//}
			//when 'V' {
				//return 'Viudo';
			//}
		//}
		//return null;
	//}

	//private static String seleccionarSexo(String inicial){
		//if (inicial == 'M') {
			//return 'Masculino';
		//}else{
			//return 'Femenino';
		//}
	//}

	//private static String seleccionarRelacionConTitular(String relacion){
		//if (relacion == 'Hijo/a') {
			//return 'HI';
		//}else{
			//return 'CO';
		//}
	//}
	
    public static void setImporteToOpps(List<Opportunity> opps){
        List<Id> cotIds = new List<Id>();
        for(Opportunity opp : opps){
            cotIds.add(opp.Cotizacion_elegida__c);
        }
        Map<Id,Cotizacion__c> cotMap = new Map<Id,Cotizacion__c>([
            SELECT Id,Diferencia_a_pagar__c
            FROM Cotizacion__c
            WHERE Id IN :cotIds
        ]);
        
        for(Opportunity opp : opps){
            if(cotMap.get(opp.Cotizacion_elegida__c) != null){
                opp.Amount = cotMap.get(opp.Cotizacion_elegida__c).Diferencia_a_pagar__c != null ?
                    Decimal.valueOf(cotMap.get(opp.Cotizacion_elegida__c).Diferencia_a_pagar__c) : null;
            }
        }
    }

	public static void validateRoleInLoc(List<Opportunity> opps){

		List<Id> locIds = new List<Id>();
		for(Opportunity opp : opps){
			locIds.add(opp.Localidad_new__c);
		}
		Map<Id,Localidad__c> locWithOrgMap = new Map<Id,Localidad__c>([
			SELECT Organizador_lookup__r.UserRoleId
			FROM Localidad__c
			WHERE Id IN :locIds
		]);
		System.debug(locWithOrgMap);
		User actualUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		System.debug(actualUser.Profile.Name);
		for(Opportunity opp : opps){
			if(actualUser.Profile.Name != 'Administrador del sistema' && actualUser.Profile.Name != 'System Administrator' 
				&& actualUser.Profile.Name != 'Front' && !opp.Sin_cotizacion__c
			){
				Id orga = locWithOrgMap.get(opp.Localidad_new__c).Organizador_lookup__r.UserRoleId;
				if(orga == null){
					opp.addError('No se puede cambiar a una localidad sin organizador.');
				}
				Set<Id> subRoles = XappiaHelper.getAllSubRoleIds(new Set<Id>{orga});
				Set<Id> upperRoles = XappiaHelper.getParentRoleId(new Set<Id>{orga});
				if(orga != null && (!subRoles.contains(UserInfo.getUserRoleId()) && 
									UserInfo.getUserRoleId() != orga &&
									!upperRoles.contains(UserInfo.getUserRoleId()))){
					opp.Localidad_new__c.addError('No puede cambiar la localidad. No pertenece a esa region');
				}
			}
		}
		
		

	}

	public static void checkNewOwner(List<Opportunity> opps){
		User actualUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		if(actualUser.Profile.Name == 'Administrador del sistema' || actualUser.Profile.Name == 'System Administrator'
          || actualUser.Profile.Name == 'Front'){
			return;
		}
		List<Id> ownerIds = new List<Id>();
		for(Opportunity opp : opps){
			ownerIds.add(opp.OwnerId);
		}
		Set<Id> subRoles = XappiaHelper.getAllSubRoleIds(new Set<Id>{UserInfo.getUserRoleId()});
		Set<Id> parentRoles = XappiaHelper.getParentRoleId(new Set<Id>{UserInfo.getUserRoleId()});
		Map<Id,User> owners = new Map<Id,User>([
			SELECT Id, UserRoleId
			FROM User
			WHERE Id IN :ownerIds	
		]);
		for(Opportunity opp : opps){
			if(!subRoles.contains(owners.get(opp.OwnerId).UserRoleId) &&
				!parentRoles.contains(owners.get(opp.OwnerId).UserRoleId)){
				opp.addError('Solo se puede derivar a un usuario que pertenezca a la misma estructura de funciones.');
			}
		}
	}

	public static void validateSubestadoDDJJ(List<Opportunity> opps, Map<Id, Opportunity> oldMap){
		UserRole[] roles = [SELECT Id,DeveloperName FROM UserRole WHERE Id = :UserInfo.getUserRoleId()];
		UserRole rol = roles.isEmpty() ? null : roles[0];
		System.debug(rol);
		User usr = [SELECT Id,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Opportunity.fields.getMap();
		for(Opportunity opp : opps){
			if(usr.Profile.Name != 'Administrador del sistema' && usr.Profile.Name != 'Front' && opp.Cambio_Manual__c 
			&& opp.Nro_de_asociado__c == null){
				if(oldMap.get(opp.Id).Estado_de_solicitud__c == 'Transformada' && opp.Cambio_Manual__c){
					opp.addError('No puede modificar una Oportunidad en Estado de solicitud = Transformada');
					continue;
				}
				if((oldMap.get(opp.Id).Estado_de_solicitud__c == 'Completa' || oldMap.get(opp.Id).Estado_de_solicitud__c == 'Incompleta')){
					if(oldMap.get(opp.Id).Subestado_de_DDJJ__c == 'FIRMA O.S.' || oldMap.get(opp.Id).Subestado_de_DDJJ__c == 'PEDIDO ESTUDIO' || oldMap.get(opp.Id).Subestado_de_DDJJ__c == 'NUEVA'){
						//if(otherFieldsChanged(opp,oldMap.get(opp.Id), fieldMap)){
							//opp.addError('No puede modificar la oportunidad en Estado de solicitud Completa o Incompleta');
							//continue;
						//}
						if(!isSupOrg(rol.DeveloperName) && !rol.DeveloperName.contains('Comercial')){
							if(oldMap.get(opp.Id).Subestado_de_DDJJ__c != opp.Subestado_de_DDJJ__c){ 
								opp.addError('No puede modificar el subestado de DDJJ si su perfil no es Comercial, Supervisor o Organizador');
								continue;
							}
						}
						if(rol != null && isSupOrg(rol.DeveloperName)){
							if(oldMap.get(opp.Id).Subestado_de_DDJJ__c ==  'FIRMA O.S.'){
								if(opp.Subestado_de_DDJJ__c == 'TRASPASO' || opp.Subestado_de_DDJJ__c == oldMap.get(opp.Id).Subestado_de_DDJJ__c){
									continue;
								}
								else{
									opp.Subestado_de_DDJJ__c.addError('Solo puede cambiar al subestado TRASPASO cuando el subestado actual es FIRMA O.S.');
									continue;
								}
							}
						
						}

						if(rol != null && (rol.DeveloperName.contains('Comercial') || isSupOrg(rol.DeveloperName))){
							if((oldMap.get(opp.Id).Subestado_de_DDJJ__c ==  'PEDIDO ESTUDIO' || oldMap.get(opp.Id).Subestado_de_DDJJ__c ==  'NUEVA')){
								if(opp.Subestado_de_DDJJ__c == 'AUDITORIA' || opp.Subestado_de_DDJJ__c == oldMap.get(opp.Id).Subestado_de_DDJJ__c){
									continue;
								}
								else{
									opp.Subestado_de_DDJJ__c.addError('Solo puede cambiar al subestado AUDITORIA cuando el subestado actual es PEDIDO ESTUDIO/NUEVA.');
									continue;
								}
								
							}
						}

						if(oldMap.get(opp.Id).Subestado_de_DDJJ__c == 'FIRMA O.S.' && !isSupOrg(rol.DeveloperName)){
							if(oldMap.get(opp.Id).Subestado_de_DDJJ__c != opp.Subestado_de_DDJJ__c){ 
								opp.Subestado_de_DDJJ__c.addError('Solo puede cambiar al subestado TRASPASO cuando el subestado actual es FIRMA O.S.');
								continue;
							}
						}


					}
					else{
						if(oldMap.get(opp.Id).Subestado_de_DDJJ__c != opp.Subestado_de_DDJJ__c){
							opp.addError('No puede modificar la oportunidad en Estado de solicitud Completa o Incompleta');
							continue;
						}
					}
				}
			}
		}
	}

	public static void assignDelegacionFromUser(Map<Id, List<Opportunity>> opportunitiesByUserId) {
		List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        Map<String, List<Opportunity>> opportunitiesByCodDelegacion = new Map<String, List<Opportunity>>();
		Profile adminProfile = [
			SELECT Id, Name 
			FROM Profile 
			WHERE (UserType = 'Standard' 
				AND PermissionsCustomizeApplication = true) 
			ORDER BY CreatedDate ASC limit 1
		];
        for (User usuario : [
                SELECT Codigo_delegacion__c, ProfileId, Profile.Name
                FROM User
                WHERE Id IN :opportunitiesByUserId.keySet()
        ]) {
            if (usuario.Codigo_delegacion__c != null &&
					( usuario.Profile.Name == 'Front' ||
						usuario.Profile.Name == 'CDC' ||
						usuario.ProfileId == adminProfile.Id
					)
			) {
                if (!opportunitiesByCodDelegacion.containsKey(usuario.Codigo_delegacion__c)) {
                    opportunitiesByCodDelegacion.put(usuario.Codigo_delegacion__c, new List<Opportunity>());
                }
				opportunitiesByCodDelegacion.get(usuario.Codigo_delegacion__c).addAll(opportunitiesByUserId.get(usuario.Id));
                
            }
        }

		System.debug('****opportunitiesByCodDelegacion ' + opportunitiesByCodDelegacion);
        for(Account delegacion : [
                SELECT Id, Codigo_de_delegacion__c
                FROM Account
                WHERE Codigo_de_delegacion__c IN :opportunitiesByCodDelegacion.keySet()
        ]) {
            for (Opportunity opp : opportunitiesByCodDelegacion.get(delegacion.Codigo_de_delegacion__c)) {
                opp.Delegacion__c = delegacion.Id;
                opportunitiesToUpdate.add(opp);
            }
        }

        if (!opportunitiesToUpdate.isEmpty()) {
			System.debug('****opportunitiesToUpdate ' + opportunitiesToUpdate);
           update opportunitiesToUpdate;
        }
    }

	private static Boolean hasAnyChange(Opportunity opp, Opportunity oldOpp, Map<String, Schema.SObjectField> fieldMap){
		Boolean hasChanged = false;
		for(String field: fieldMap.keySet()){
			hasChanged = hasChanged || (opp.get(field)!= oldOpp.get(field));
		}
		return hasChanged;
	}

	private static Boolean otherFieldsChanged(Opportunity opp, Opportunity oldOpp, Map<String, Schema.SObjectField> fieldMap){
		Boolean hasChanged = false;
		for(String field: fieldMap.keySet()){
			if(field != 'Subestado_de_DDJJ__c'){
				hasChanged = hasChanged || (opp.get(field)!= oldOpp.get(field));
			}
		}
		return hasChanged;
	}

	private static Boolean isSupOrg(String rol){
		List<String> orgs = new List<String>{'Org_AMBA','Org_Buenos_Aires_Centro','Org_Buenos_Aires_Costa_Atlantica',
		'Org_Buenos_Aires_Norte','Org_Buenos_Aires_Sur','Org_Cordoba_Norte','Org_Cordoba_Sur','Org_Litoral','Org_NEA',
		'Org_NOA','Org_Nucleo','Org_Pampeana','Org_Patagonia_Andina','Org_Patagonia_Costa_Atlantica','Org_Rosario','Org_Santa_Fe_Centro'};
		List<String> sups = new List<String>{'Supervisor_AMBA','Supervisor_BAC','Supervisor_BACA','Supervisor_BAN','Supervisor_BAS',
		'Supervisor_CN','Supervisor_CS','Supervisor_L','Supervisor_NEA','Supervisor_NOA','Supervisor_N','Supervisor_P','Supervisor_PA','Supervisor_PCA',
		'Supervisor_Rosario','Supervisor_SFC'};

		return orgs.contains(rol) || sups.contains(rol);
	
	}

	public static void checkIfIsAcceptedByAsociado(List<Opportunity> opps) {
		User actualUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		Id individuosRT = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
		Map<Id, Opportunity> oppsToCheckIfHaveFile = new Map<Id, Opportunity>();
		if(actualUser.Profile.Name == 'Front' || Test.isRunningTest()) {
			for(Opportunity opp :opps) {
				if(opp.Aceptado_por_el_asociado__c && opp.recordTypeId == individuosRT) {
					oppsToCheckIfHaveFile.put(opp.Id, opp);
				}
			}
			Map<Id, List<ContentDocumentLink>> dLinks = new Map<Id, List<ContentDocumentLink>>();
			if(!oppsToCheckIfHaveFile.isEmpty()) {
				for(ContentDocumentLink cDL :[SELECT ContentDocumentId, LinkedEntityId, ContentDocument.Title, Id FROM ContentDocumentLink WHERE LinkedEntityId IN :oppsToCheckIfHaveFile.keySet()]) {
					if(dLinks.containsKey(cDL.LinkedEntityId)) {
						dLinks.get(cDL.LinkedEntityId).add(cDL);
					} else {
						dLinks.put(cDL.LinkedEntityId, new List<ContentDocumentLink> {cDL});
					}
				}
				for(Id opp :oppsToCheckIfHaveFile.keySet()) {
					if(dLinks.containsKey(opp)) {
						Boolean hasFile = false;
						for(ContentDocumentLink cDL :dLinks.get(opp)) {
							if(cDL.ContentDocument.Title.containsIgnoreCase('nota de aceptacion') || cDL.ContentDocument.Title.containsIgnoreCase('nota de aceptación')) {
								hasFile = true;
							}
						}
						if (!hasFile) {
							oppsToCheckIfHaveFile.get(opp).addError('Deberá adjuntar la nota de aceptacion para poder continuar');
						}
					} else {
						oppsToCheckIfHaveFile.get(opp).addError('Deberá adjuntar la nota de aceptacion para poder continuar');
					}
				}
			}
		}
	}

	public static void updateDNIInAccount(List<Opportunity> opps) {
		List<Account> accsToUpdateDNI = new List<Account>();

		for(Opportunity opp : opps) {
			Account acc = new Account();
			
			acc.Id = opp.AccountId;
			acc.Numero_de_documento__c = opp.Numero_de_documento__c;
			
			accsToUpdateDNI.add(acc);
		}

		update accsToUpdateDNI;
	}

	public static void changeOganizadorInOpp(Map<Opportunity, Id> localidadIdsByOpp) {
		Map<Id, Localidad__c> locsWithOrganizador = new Map<Id, Localidad__c>([
			SELECT Id, Organizador_lookup__c FROM Localidad__c WHERE Id IN :localidadIdsByOpp.values()
		]);
		
		for(Opportunity opp : localidadIdsByOpp.keySet()) {
			String organizadorId = locsWithOrganizador.get(opp.Localidad_new__c).Organizador_lookup__c;
			
			if(String.isNotBlank(organizadorId)) {
				opp.Organizador_lookup__c = organizadorId;
				//opp.OwnerId = organizadorId;
			}
		}
	}
}