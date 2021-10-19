({
	handleRecordUpdated: function (component, event, helper) {
		var eventParams = event.getParams();
		if(eventParams.changeType === "CHANGED") {
        // get the fields that changed for this record
			var changedFields = eventParams.changedFields;
			if(changedFields['Status'] != undefined && changedFields['Status'] != null){
				if(changedFields['Status']['value'] == 'Contactado - Interesado'){
					var navEvt = $A.get("e.force:navigateToSObject");
						navEvt.setParams({
						  "recordId": component.get('v.recordId'),
						  "slideDevName": "related"
						});
						navEvt.fire();
				}
			}
			

		} else if(eventParams.changeType === "LOADED") {

			// record is loaded in the cache
		} else if(eventParams.changeType === "REMOVED") {
			// record is deleted and removed from the cache
		} else if(eventParams.changeType === "ERROR") {
			// there’s an error while loading, saving or deleting the record
		}

	}
})