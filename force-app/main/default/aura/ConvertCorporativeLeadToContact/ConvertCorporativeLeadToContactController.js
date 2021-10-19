({
	handleSelect : function(component, event, helper) {
		var selectedState = event.getParam("detail").value;
		if(component.get("v.leadRecord").Status == selectedState) {
			//Make it revert to force the conversion as with the standard component.
			selectedState = "converted";
		}
		component.set("v.selectedState", selectedState);
	},
	
	changeState : function(component, event, helper) {
		var selectedState = component.get("v.selectedState");
		if(selectedState === "converted") {
			//Force a proper state
			selectedState = component.get("v.convertedState");
		}
		helper.changeLeadStatus(component,event,component.get("v.recordId"),selectedState);

	}
})