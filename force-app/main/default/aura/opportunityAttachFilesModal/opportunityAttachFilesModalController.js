({

    init: function (cmp, event,helper) {
		var oppId = cmp.get('v.recordId');        
		//helper.getFiles(cmp,event,cmp.get('v.recordId'));

        helper.getIntegrantes(cmp,event,oppId);
		helper.getActivateUploadFiles(cmp,event,oppId);
		helper.getDocumentDDJJ(cmp,event, oppId);
		helper.getDocumentIngreso(cmp,event,oppId);
    },
	setTipo: function(component, event, helper){
		var eventParams = event.getParams();

        if(eventParams.changeType === "LOADED") {
			var opp = component.get('v.accountSimpleRecord');
            helper.getCreatorsProfile(component,event,opp.CreatedById);

			if(opp.RecordType.DeveloperName == 'Individual_Corporativo' || opp.Sin_cotizacion__c){
				component.set('v.tipo_afiliado', opp.Tipo_de_Asociado__c);
			} 
			else{
				if(opp.Cotizacion_elegida__c != null){
					component.set('v.tipo_afiliado', opp.Cotizacion_elegida__r.Tipo_de_afiliado__c);
				}
			}
		}
	}

});