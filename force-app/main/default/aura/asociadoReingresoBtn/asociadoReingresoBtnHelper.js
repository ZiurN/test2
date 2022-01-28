({
	goToApex: function (component, event, id) {
		let createRecordEvent = $A.get("e.force:createRecord");
		let acc = component.get('v.accountSimpleRecord');
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"assingTo",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
						let org = acc.Localidad_new__c != null ? acc.Localidad_new__r.Organizador_lookup__c : null;
						let sexo = acc.Sexo__c == 'Masculino' ? 'M' : acc.Sexo__c == 'Femenino' ? 'F' : null;
						let profileOrg = result.profile == 'Front' ? null : org;
						createRecordEvent.setParams({
							'entityApiName': 'Opportunity',
							'recordTypeId' : result.recordTypeIndividuos,
							'defaultFieldValues': {
								'Tipo_de_Solicitud__c' : 'REINGRESO',
								'Name': 'Reingreso de: ' + result.nombre,
								'StageName' : 'Contactado',
								'AccountId' : id,
								'Localidad_new__c': acc.Localidad_new__c,
								'Organizador_lookup__c': profileOrg,
								'Segmento_del_Grupo_Familiar__c': acc.Segmento_de_grupo_familiar__c,
								'Nro_de_asociado__c':acc.Codigo_de_Afiliado__c,
								'Agencia__c' : acc.Delegacion__c,
								'Fecha_de_Nacimiento__c' : acc.PersonBirthdate,
								'Correo_Electronico__c' : acc.PersonEmail,
								'Estado_Civil__c': acc.Estado_civil__c,
								'Tipo_de_Documento__c': acc.Tipo_de_documento__c,
								'Numero_de_documento__c':acc.Numero_de_documento__c,
								'Sexo__c': sexo,
								'Nombre_INDCORP__c': acc.FirstName,
								'Apellido_INDCOR__c': acc.LastName,
								'Telefono__c': acc.Phone,
								'CUIT__c': acc.CUIT__c,
								'Obra_social_del_titular__c': acc.Obra_social__c
							}
						});
						createRecordEvent.fire();
						 component.set('v.isLoading', false);
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				} else {
					LightningUtils.showToast("Error", JSON.stringify(errors), {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				accId : id
			}
		);
	}
})