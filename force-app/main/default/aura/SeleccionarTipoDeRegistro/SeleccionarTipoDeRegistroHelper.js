({
	destroyTab : function(component) {
		var workspaceApi = component.find("workspace");
		
		workspaceApi.getEnclosingTabId().then(function(tabId){
			if(tabId) {
				workspaceApi.closeTab({"tabId": tabId})
			}
		});
	},
    
    isEmptyObject : function(obj) {
        if (typeof obj === 'array') {
            return obj.length === 0;
        } else if (typeof obj === 'string') {
            obj = JSON.parse(obj);
        }
        
        return !obj || Object.keys(obj).length === 0;
	}
})