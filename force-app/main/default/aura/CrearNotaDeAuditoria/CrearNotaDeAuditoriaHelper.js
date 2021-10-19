({
	redirectToNewNota: function (component, event) {
		let helper = this;
        var recordId;
		var pageRef = component.get("v.pageReference");
		var state = pageRef.state;
		var base64Context = state.inContextOfRef;
		
		if(base64Context) {

			if (base64Context.startsWith("1\.")) {
				base64Context = base64Context.substring(2);
			}

			console.log(JSON.parse(window.atob(base64Context)));
			var addressableContext = JSON.parse(window.atob(base64Context));
			//var objectName =  addressableContext.attributes.objectApiName;

			recordId = addressableContext.attributes.recordId;
		} 
		else {
			recordId = state.c__recordId;
		}

		var action = component.get("c.getRecordTypeId");
		action.setParams({
			recordId
		});

		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				let result = response.getReturnValue();
				//console.log(result);
				if (result.hasError) {
					component.find("notificationLib").showToast({
						"title": "Error",
						"message": result.message || "Se ha producido un error inesperado, consulte con su administrador de sistema.",
						"variant": "error",
						"mode": "pester"
					});
					return;
				} else {

					helper.createRecord(recordId, result);
					helper.closeTab(component);
					
				}
			}
		});
		$A.enqueueAction(action);	
	},

	createRecord: function(recordId, result) {
		let defaultFields;
		let objectName = result.objectType;

		switch(objectName){
			case 'Case':
				defaultFields = {'APr_Id__c': recordId};
				break;
			case 'Opportunity':
				defaultFields = {'Oportunidad__c': recordId};
				break;
			case 'Integrante_caso__c':
				defaultFields = {'Integrante__c': recordId};
				break;
			case 'Evento_Medico__c':
				defaultFields = {'Evento_Medico_Id__c': recordId};
				break;
			default:
				break;
		}
					
		var createRecordEvent = $A.get("e.force:createRecord");
		var RecTypeID  = result.data;
		var typeOfNota = result.typeOfNota;

		if(typeOfNota != null && typeOfNota != undefined) {
			defaultFields.Tipo_nota_de_Auditoria__c = typeOfNota;
		}

		createRecordEvent.setParams({
			"entityApiName": 'Nota_de_Auditoria__c',
			"recordTypeId": RecTypeID,
			'defaultFieldValues': defaultFields
		});
		createRecordEvent.fire();
	},

	closeTab: function(component) {
		let workspaceApi = component.find("workspace");
					
		if(workspaceApi) {
			workspaceApi.getEnclosingTabId().then(function(tabId){
				if(tabId) {
					workspaceApi.closeTab({"tabId": tabId})
				}
			});
		}
	}
})