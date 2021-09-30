({
    doInit : function(component, event, helper) {
        LightningUtils.callApex(
			component,
			"getRecordTypeIdByDevName",
			function(success, typeId, errors) {
				if(success) {
					component.set("v.typeId", typeId);
				}
				else {
					LightningUtils.showToast(
						"Error",
						"Ha ocurrido un error inesperado, comunique a su administrador el error! (DevNameNULL)",
						{type: "error"}
					);
					
				}
			},
			{sObjectType: "Opportunity", devName: "Individual_Corporativo"}
		);
        setTimeout(function(){
            component.find("recordData").reloadRecord(true);
            setTimeout(function(){
                component.set("v.loaded",true);
            },500);
        },500);
        setTimeout(function(){
            component.set("v.error",true);
        },5000);
        },
    createRecord: function(component, event, helper){
        var fields = component.get("v.state");
        var Opportunity = component.get("v.thisOpportunity");
        var typeId = component.get("v.typeId");
        if(Opportunity.StageName != 'Cerrada ganada'){
            LightningUtils.showToast(
                "Error",
                "Unicamente puede cargar individuos de oportunidad cuando la oportunidad se encuentre en Cerrada Ganada",
                {type: "error"}
            );
			var navEvt = $A.get("e.force:navigateToSObject");
			navEvt.setParams({
			  "recordId": Opportunity.Id,
			  "slideDevName": "Detail"
			});
			navEvt.fire();
            
        } else {
            if(typeId){
            fields.StageName = '';
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                entityApiName: "Opportunity",
                recordTypeId: typeId,
                defaultFieldValues: fields
            });
            createRecordEvent.fire();
            } 
        }
        setTimeout(function(){
            helper.destroyTab(component); 
        },1);
            
    },
    error: function(component, event, helper){
        LightningUtils.showToast(
            "Error",
            "Error cargando el formulario, intenta nuevamente!",
            {type: "warning"}
        );
        setTimeout(function(){
            helper.destroyTab(component); 
        },1);
    }
})