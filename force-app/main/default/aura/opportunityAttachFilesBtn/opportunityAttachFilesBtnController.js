({
    doInit : function(component, event, helper) {
    		       
        var getOpp = component.get("c.getOpp");
        var action = component.get("c.getProfileName");
		let button = component.find('cargarDocumentosButton');
        
        getOpp.setParams({
            IdOpp: component.get("v.recordId")
        });
        getOpp.setCallback(this,function(responseTwo){
            if(responseTwo.getState() === "SUCCESS"){
                component.set('v.previousState',responseTwo.getReturnValue().Activar_seleccionar_archivos__c);
                console.log(component.get('v.previousState'));
                let isVenta = component.get('v.isVentas');
                let nombreEtapa = responseTwo.getReturnValue().StageName;
                let nombreRt =  responseTwo.getReturnValue().RecordType.DeveloperName;
      
                if(
                    (responseTwo.getReturnValue().Nro_de_solicitud__c != null && isVenta) ||
                    (nombreEtapa != 'En tramitación' && !isVentas)
                  ){
                    button.set('v.disabled',true);
                }else{
                    button.set('v.disabled',false);
                }
            }
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
        		let storageResponse = response.getReturnValue();
                let isProfileAgenteventa = storageResponse === 'Agente de Ventas' || storageResponse === 'Lider de Ventas';
          		component.set('v.isVentas',isProfileAgenteventa);
        	}
		});
        $A.enqueueAction(action);
        $A.enqueueAction(getOpp);
       
	
        	
	},
    
    handleClickBtn: function (component, event, helper) {
        let idOpp = component.get('v.accountSimpleRecord').Id;
        helper.goToApex(component, event, idOpp);
    },
    
    handleUpdate: function (component, event, helper) {
     	
        console.log(component.get('v.accountSimpleRecord').Nro_de_solicitud__c);
        let inSS = component.get('v.accountSimpleRecord').Nro_de_solicitud__c != null;
        let nombreEstado = component.get('v.accountSimpleRecord').StageName;
        //let cerrada = component.get('v.accountSimpleRecord').StageName === 'Cerrada';
        let checkCarga = component.get('v.previousState');
          
        let button = component.find('cargarDocumentosButton');
		component.set('v.disabledButton',(!checkCarga && component.get('v.isVentas')));
       	console.log('estado ' + nombreEstado);
        console.log('in ss ' + inSS);
        if(nombreEstado == 'Cerrada' || nombreEstado != 'En tramitación' || (inSS && component.get('v.isVentas'))  ) {
            button.set('v.disabled', true);
        }
        else if(nombreEstado == 'En tramitación' || (!inSS && component.get('v.isVentas')) ){
            button.set('v.disabled', false);
        }/*else if(nombreEstado != 'En tramitación'){
            button.set('v.disabled',true);
        }*/
        
    }
})