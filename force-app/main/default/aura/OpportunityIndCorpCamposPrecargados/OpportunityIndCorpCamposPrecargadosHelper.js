({
	goToApex: function (component, event, idAsociado) {
		let helper = this;
		let createRecordEvent = $A.get("e.force:createRecord");

		component.set('v.isLoading', true);
		//helper.completarCampos(component,createRecordEvent);
		component.set('v.isLoading',false);
		LightningUtils.callApex(
			component,
			"getRecordTypeIdByDevName",
			function(success, typeId, errors) {
				if(success) {
					helper.completarCampos(component,createRecordEvent,typeId);
				}
				else {
					LightningUtils.showToast(
						"Error",
						"Ha ocurrido un error inesperado, comunique a su administrador el error! (DevNameNULL)",
						{type: "error"}
					);
					
				}
			},
			{sObjectType: "Opportunity", devName: "Individual_Corporativo"}
		);
	},

	completarCampos: function(component, createRecordEvent,typeId) {		
		let loc = component.get("v.oppSimpleRecord").Localidad_new__c;
		let prov = component.get("v.oppSimpleRecord").Provincia_lista__c;
		let accId = component.get("v.oppSimpleRecord").AccountId;
		let oppId = component.get("v.recordId");

		createRecordEvent.setParams({
			"entityApiName": "Opportunity",
			"recordTypeId": typeId,
			"defaultFieldValues": {
				'Oportunidad_Corporativa__c' : oppId,
				'Localidad_new__c' : loc,
				'Provincia_lista__c' : prov,
				'AccountId': accId

			}
		});

		createRecordEvent.fire(); 
	}
})