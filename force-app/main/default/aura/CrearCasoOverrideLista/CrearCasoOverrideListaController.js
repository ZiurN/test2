({
	getParams : function(component, event, helper) {
		var state = component.get("v.pageReference").state;

		var caseParams = {};

		var i = 0;

		while(state["c__field" + i]) {
        	// check that the field has a value, if not salesforce throws a server error
        	// so we skip it
            if (state["c__value" + i]) {
            	caseParams[state["c__field" + i]] = state["c__value" + i];
            }

			i++;
		}

		if (state["c__recordTypes"]) {
			console.log(JSON.stringify(state["c__recordTypes"]));
			let allowedDevNames = state["c__recordTypes"].split('[,]');
			component.set("v.allowedRecordTypes", allowedDevNames);
		}

		component.set("v.caseParams", caseParams);
	}
})