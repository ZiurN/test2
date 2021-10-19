({
	doInit: function (component, event, helper) {
		helper.changeLeadStatus(component,event,component.get("v.recordId"),'Contactado - Interesado');
	}
})