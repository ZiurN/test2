({
    destroyTab : function(component) {
		var workspaceApi = component.find("workspace");
		
		workspaceApi.getEnclosingTabId().then(function(tabId){
			if(tabId) {
				workspaceApi.closeTab({"tabId": tabId})
			}
		});
	}
})