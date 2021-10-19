({
    handleClickBtn: function (component, event, helper) {

		var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
			let id = component.get('v.recordId');
			
			helper.goToApex(component, event, id);
		} 
    }
});