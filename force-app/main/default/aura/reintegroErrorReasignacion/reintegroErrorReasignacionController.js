({
	handleRecordUpdated: function (component, event, helper) {
		var eventParams = event.getParams();
		if(eventParams.changeType === "CHANGED") {
		} else if(eventParams.changeType === "LOADED") {
			var reintegro = component.get('v.caseSimpleRecord');
			if(reintegro.RecordType.DeveloperName == 'Reintegro' &&
			reintegro.Error_reasignacion__c != null){
				LightningUtils.showToast("Error de reasignacion", "Fecha: " + $A.localizationService.formatDate(reintegro.Fecha_error_reasignacion__c) + '\n' + reintegro.Error_reasignacion__c, {"type":"error"});
			}
			// record is loaded in the cache
		} else if(eventParams.changeType === "REMOVED") {
			// record is deleted and removed from the cache
		} else if(eventParams.changeType === "ERROR") {
			// there’s an error while loading, saving or deleting the record
		}

	}
})