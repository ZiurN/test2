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
        
        component.set("v.caseParams", caseParams);
        /*if(component.get("v.thisOpportunity").StageName != 'Cerrada ganada'){
            helper.destroyTab(component);
        }
        helper.createRecord(component, caseParams);*/
	}
})