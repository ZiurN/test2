({
    doInit : function(component, event, helper) {
		  helper.goToApex(component, event);
    }, 

	handleRecordUpdated: function (component, event, helper) {
		var eventParams = event.getParams();
       	
		if(eventParams.changeType === "CHANGED") {
		} else if(eventParams.changeType === "LOADED") {
			var reintegro = component.get('v.caseSimpleRecord');
			if(reintegro.Fallo_en_SS__c != null){
                
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Falló envio a SS",
                        "message": reintegro.Fallo_en_SS__c,
                        "type": 'warning'
                    });
                    toastEvent.fire();
                
			}
			// record is loaded in the cache
		} else if(eventParams.changeType === "REMOVED") {
			// record is deleted and removed from the cache
		} else if(eventParams.changeType === "ERROR") {
			// there’s an error while loading, saving or deleting the record
		}

	}
})