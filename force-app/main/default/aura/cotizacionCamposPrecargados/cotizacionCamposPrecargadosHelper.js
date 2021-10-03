({
	goToApex: function (component, event, idAsociado) {
		let helper = this;
		let createRecordEvent = $A.get("e.force:createRecord");

		component.set('v.isLoading', true);
		helper.completarCampos(component,createRecordEvent);
		component.set('v.isLoading',false);
	},

	completarCampos: function(component, createRecordEvent) {
		let accId = component.get("v.oppSimpleRecord").AccountId;
		let nombre = component.get("v.oppSimpleRecord").Account.Name;
		let docNro = component.get("v.oppSimpleRecord").Numero_de_documento__c;
		let docTipo = component.get("v.oppSimpleRecord").Account.Tipo_de_documento__c;
		let tel = component.get("v.oppSimpleRecord").Telefono__c;
		let tipoTel = component.get("v.oppSimpleRecord").Account.Tipo_de_Telefono__c;
		let mail = component.get("v.oppSimpleRecord").Correo_Electronico__c;
		let edad = component.get("v.oppSimpleRecord").Edad__c;
		let loc = component.get("v.oppSimpleRecord").Localidad_new__c;
		let prov = component.get("v.oppSimpleRecord").Provincia_lista__c;
		let oppId = component.get("v.recordId");
		let eCivil = component.get("v.oppSimpleRecord").Estado_Civil__c;
		
		createRecordEvent.setParams({
			"entityApiName": "Cotizacion__c",
			"defaultFieldValues": {
				'Oportunidad__c' : oppId,
				'Nombre_y_Apellido__c' : nombre,
				'Nro_de_Documento__c' : docNro,
				'Tipo_de_Documento__c' : docTipo,
				'Telfono__c' : tel,
				'Tipo_de_Telefono__c' : tipoTel,
				'Correo_electronico__c' : mail,
				'Localidad_new__c' : loc,
				'Provincia_lista__c' : prov,
				'Edad__c' : edad,
				'Estado_Civil__c': eCivil
			}
		});

		createRecordEvent.fire(); 
	}
})