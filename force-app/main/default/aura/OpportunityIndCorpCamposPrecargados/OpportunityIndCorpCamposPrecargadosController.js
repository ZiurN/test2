({
	doInit: function(component, event, helper) {  
		var eventParams = event.getParams();
        
        if(eventParams.changeType === "LOADED") {
			let opp = component.get("v.oppSimpleRecord");
			if(opp.StageName != 'Cerrada ganada'){
				LightningUtils.showToast(
					"Error",
					"Unicamente puede cargar individuos de oportunidad cuando la oportunidad se encuentre en Cerrada Ganada",
					{type: "error"}
				);
				$A.get("e.force:closeQuickAction").fire();
			}else{
				helper.goToApex(component, event);  
			}
		} 
	} 
})