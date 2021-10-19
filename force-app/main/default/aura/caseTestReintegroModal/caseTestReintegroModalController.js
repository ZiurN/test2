({
	handleClickBtn: function (component, event, helper) {	
		helper.callTestReintegro(component, event);
	},

	openReintegroLayoutNew: function (component, event, helper) {
		helper.getReintegroRT(component, event);
	}
})