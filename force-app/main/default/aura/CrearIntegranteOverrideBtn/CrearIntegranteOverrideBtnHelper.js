({
	redirectToNewNota: function (component, event) {
		
		var pageRef = component.get("v.pageReference");
        var state = pageRef.state; 
        var base64Context = state.inContextOfRef;

        if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
        }
		console.log(JSON.parse(window.atob(base64Context)));
        var addressableContext = JSON.parse(window.atob(base64Context));
		var defaultFields = {'Caso__c': addressableContext.attributes.recordId};
		var recordId = addressableContext.attributes.recordId;
		var action = component.get("c.getRecordTypeId");
		action.setParams({
			recordId
		});

		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				let result = response.getReturnValue();
				console.log(result);
				if (result.hasError) {
					component.find("notificationLib").showToast({
						"title": "Error",
						"message": result.message || "Se ha producido un error inesperado, consulte con su administrador de sistema.",
						"variant": "error",
						"mode": "pester"
					});
					return;
				} else {
					
					var createRecordEvent = $A.get("e.force:createRecord");
					var RecTypeID  = result.data;
					defaultFields.Cuenta_de_la_solicitud__c = result.aditionalId;
					createRecordEvent.setParams({
						"entityApiName": 'Integrante_caso__c',
						"recordTypeId": RecTypeID,
						'defaultFieldValues': defaultFields
					});
					createRecordEvent.fire();
				}
			}
		});
		$A.enqueueAction(action);
	}
})