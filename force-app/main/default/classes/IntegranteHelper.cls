global class IntegranteHelper  {
	public static void fillContactInformationFromOpp(Map<String, List<Integrante__c>> opportunityIdIntegrantesMap) {
		List<Integrante__c> integrantesToUpdate = new List<Integrante__c>();
		for (Opportunity opp : [
			SELECT Account.Phone, Account.Prefijo__c, Account.Correo_electronico__c, Codigo_Postal__c, Telefono__c, 
				Correo_Electronico__c, Localidad_new__r.Codigo_Postal__c, Localidad_new__r.Prefijo__c
			FROM Opportunity 
			WHERE Id IN :opportunityIdIntegrantesMap.keySet()]) 
			{
			for (Integrante__c integrante : opportunityIdIntegrantesMap.get(opp.Id)) {
				
				integrante.Telfono__c = integrante.Telfono__c != null ? integrante.Telfono__c : opp.Telefono__c;
				integrante.Prefijo__c = integrante.Prefijo__c != null ? integrante.Prefijo__c 
										: opp.Account.Prefijo__c != null ? Integer.valueOf(opp.Account.Prefijo__c) : 0;
				integrante.Correo_electronico__c = integrante.Correo_electronico__c != null 
													? integrante.Correo_electronico__c : opp.Correo_Electronico__c;
				integrante.Codigo_Postal__c = integrante.Codigo_Postal__c != null 
												? integrante.Codigo_Postal__c : opp.Localidad_new__r.Codigo_Postal__c;

				//integrante.Telfono__c = integrante.Telfono__c != null ? integrante.Telfono__c : opp.Account.Phone;
				//integrante.Prefijo__c = integrante.Prefijo__c != null ? integrante.Prefijo__c 
										//: opp.Account.Prefijo__c != null ? Integer.valueOf(opp.Account.Prefijo__c) : null;
				//integrante.Correo_electronico__c = integrante.Correo_electronico__c != null 
													//? integrante.Correo_electronico__c : opp.Account.Correo_electronico__c;
				//System.debug(integrante.Codigo_Postal__c);
				//integrante.Codigo_Postal__c = integrante.Codigo_Postal__c != null 
												//? integrante.Codigo_Postal__c : opp.Localidad_new__r.Codigo_Postal__c;
				//System.debug('CPHelper ' + opp.Localidad_new__r.Codigo_Postal__c);
				//System.debug(integrante.Codigo_Postal__c);
                //integrantesToUpdate.add(integrante);
			}				
		}
	}
    
    public static void validateFields(List<Integrante__c> integrantes,Map<Id,Opportunity> oppMap){
        for(Integrante__c integrante : integrantes){
        	Opportunity opp = oppMap.get(integrante.Oportunidad__c);
			Boolean obligatorio = opp.Segmento_del_Grupo_Familiar__c == 'OBLDIR'
									|| opp.Segmento_del_Grupo_Familiar__c == 'OBLEMP';

            if(integrante.Apellido__c == null){
                integrante.Apellido__c.addError('Campo Apellido obligatorio');
            }
            if(integrante.Nombre__c == null){
                integrante.Nombre__c.addError('Campo Nombre obligatorio');
            }
            if(integrante.Fecha_de_Nacimiento__c == null){
                integrante.Fecha_de_Nacimiento__c.addError('Campo Fecha de Nacimiento obligatorio');
            }        
            if(integrante.Nacionalidad__c == null){
                integrante.Nacionalidad__c.addError('Campo Nacionalidad obligatorio');
            }
            if(integrante.Discapacitado__c == null){
                integrante.Discapacitado__c.addError('Campo Discapacitado obligatorio');
            }
            if(integrante.Prefijo__c == null){
                integrante.Prefijo__c.addError('Campo Prefijo obligatorio');
            }
            if(integrante.Tipo_de_Documento__c == null){
                integrante.Tipo_de_Documento__c.addError('Campo Tipo de Documento obligatorio');
            }
            if(integrante.Nro_de_documento__c == null){
                integrante.Nro_de_documento__c.addError('Campo Documento obligatorio');
            }
            if(integrante.CUIT_Sin_guiones__c == null && obligatorio && integrante.Indicador_de_aporte__c){
                integrante.CUIT_Sin_guiones__c.addError('Campo CUIT obligatorio con segmento OBLDIR/OBLEMP');
            }
            if(integrante.Edad__c == null){
                integrante.Edad__c.addError('Campo Edad obligatorio');
            }
            if(integrante.Sexo__c == null){
                integrante.Sexo__c.addError('Campo Sexo obligatorio');
            }
			// No puede estar en null porque es tipo check
            //if(integrante.Indicador_de_aporte__c == null && obligatorio){
                //integrante.Indicador_de_aporte__c.addError('Campo obligatorio');
            //}
            if(integrante.Aportes__c == null && integrante.Indicador_de_aporte__c && obligatorio){
                integrante.Aportes__c.addError('Campo Aportes obligatorio');
            }
            if(integrante.Cobertura_anterior__c == null &&
               (opp.Segmento_del_Grupo_Familiar__c == 'VOLDIR' ||
               opp.Segmento_del_Grupo_Familiar__c == 'VOLEMP' ||
               opp.Segmento_del_Grupo_Familiar__c == 'DTCAP')){
                integrante.Cobertura_anterior__c.addError('Campo Cobertura Anterior obligatorio con segmento VOLDIR/VOLEMP/DTCAP');
            }
            if(integrante.Obra_social_actual__c == null &&
              (opp.Segmento_del_Grupo_Familiar__c == 'VOLDIR' ||
               opp.Segmento_del_Grupo_Familiar__c == 'VOLEMP')){
                   integrante.Obra_social_actual__c.addError('Campo Obra Social obligatorio con segmento VOLDIR/VOLEMP');
               }
            if(integrante.Estado_Civil__c == null){
                integrante.Estado_Civil__c.addError('Campo Estado Civil obligatorio');
            }
            if(integrante.Tipo_de_relacion_con_titular__c == null){
                integrante.Tipo_de_relacion_con_titular__c.addError('Campo Tipo de relacion con titular obligatorio');
            }
        }
        
    }

	public static void updateRelatedAccounts(Map<String,String> dniAsociados){
		List<Account> asociados = [
			SELECT Codigo_de_Afiliado__c, Numero_de_documento__c
			FROM Account
			WHERE Numero_de_documento__c IN :dniAsociados.keySet()
		];
		List<Account> accsToUpdate = new List<Account>();
		for(Account asociado : asociados){
			System.debug(asociado.Codigo_de_Afiliado__c);
			if(asociado.Codigo_de_Afiliado__c == null){
				asociado.Codigo_de_Afiliado__c = dniAsociados.get(asociado.Numero_de_documento__c);
				accsToUpdate.add(asociado);
			}
		}
		System.debug(accsToUpdate);
		update accsToUpdate;
	}
}