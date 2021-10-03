({
	handleRecordUpdated: function (component, event, helper) {
		var eventParams = event.getParams();
		if(eventParams.changeType === "CHANGED") {
		} else if(eventParams.changeType === "LOADED") {
			var reintegro = component.get('v.caseSimpleRecord');
			if(reintegro.Fallo_en_SS__c != null){
				LightningUtils.showToast("Falló el envio a SS", "Fecha: " + $A.localizationService.formatDate(reintegro.Fecha_de_fallo__c) + '\n' + reintegro.Fallo_en_SS__c, {"type":"warning"});
			}
			// record is loaded in the cache
		} else if(eventParams.changeType === "REMOVED") {
			// record is deleted and removed from the cache
		} else if(eventParams.changeType === "ERROR") {
			// there’s an error while loading, saving or deleting the record
		}

	}
})