({
    goToApex: function (component, event) {
	    let ide = component.get('v.recordId');
        var action = component.get('c.hasAttachmentsErrorMsg');
        action.setParams({
            "id" : ide
        });
        action.setCallback(this, function(a){
            var state = a.getState();
            var response = a.getReturnValue();
            if(state == 'SUCCESS') {
                this.showToast(component, event, response.message);
            } else {
                this.showToast(component, event, 'ERROR');
            }
        });
        $A.enqueueAction(action);
    },

    showToast : function(component, event, message) {
        var toastEvent = $A.get("e.force:showToast");
        if(message != 'ok'){
            toastEvent.setParams({
                "message": message,
                "mode": 'sticky'
            });
            toastEvent.fire();
        }
    }
})