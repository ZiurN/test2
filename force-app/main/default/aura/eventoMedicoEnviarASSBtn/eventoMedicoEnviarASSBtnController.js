({
    update: function (component, event, helper) {

    },

	handleClickBtn: function (component, event, helper) {
        let hasMissingFields = helper.showMissingFields(component, event);
        if(hasMissingFields) {
            return;
        }
        helper.goToApex(component, event);
	}
})