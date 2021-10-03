({
	doInit : function(component, event, helper) {
		component.set("v.isLoading", true);
		LightningUtils.callApex(
			component,
			"getRecordTypesByGroup",
			function(success, groups, errors) {
				if(success) {
					component.set("v.typesByGroup", groups);
					if(groups.length == 1) {
						//If there is only one group, open the accordion.
						setTimeout(function() {
							component.find("accordion").set('v.activeSectionName', 'acc-0');
						}, 1);
					}
				}
				else {
					LightningUtils.showToast(
						"Error",
						"Ha ocurrido un error al obtener los tipos de caso",
						{type: "error"}
					);
					
				}
				component.set("v.isLoading", false);
			},
			{sObjectType: component.get("v.sObjectType"), allowedDevNames: component.get("v.allowedRecordTypes")}
		);
	},

	createRecord: function(component, event, helper) {
		var createRecordEvent = $A.get("e.force:createRecord");
	 	let params = {
			entityApiName: component.get("v.sObjectType"),
			recordTypeId: event.getSource().get("v.name")
		};

        let defaultFieldValues = component.get("v.defaultFieldValues");
        
        if (!helper.isEmptyObject(defaultFieldValues)) {
            params.defaultFieldValues = defaultFieldValues;
        }
        createRecordEvent.setParams(params);
        createRecordEvent.fire();
	},

	cancelCreation: function(component, event, helper) {
		helper.destroyTab(component);
	}
})