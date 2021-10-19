({
	doInit: function(component, event, helper) {  
		var eventParams = event.getParams();
        
        if(eventParams.changeType === "LOADED") {
			let afiId = component.get("v.oppSimpleRecord").Account.Afi_Id__c;
			helper.goToApex(component, event, afiId);  
		} 
	} 
})