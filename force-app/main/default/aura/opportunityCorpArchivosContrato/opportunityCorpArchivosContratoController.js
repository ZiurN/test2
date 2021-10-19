({
	doInit: function(component, event, helper) {  
		var eventParams = event.getParams();
        
        if(eventParams.changeType === "LOADED") {
			let afiId = component.get("v.recordId");
			helper.goToApex(component, event, afiId);  
		} 
	} 
})