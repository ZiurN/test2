({
	updateDocument: function(component,event,documentId,fileName,opId){
        let helper = this;
		var isVentas = component.get('v.isProfileVentas');
        console.log(isVentas);
        component.set('v.isLoading', true);

        LightningUtils.callApex(
            component,
            "changeFileName",
            function(succeed, result, errors) {
                if(succeed) {
                    if(!result.hasError){
                        
                        LightningUtils.showToast("Info", "Archivo "+ fileName+" cargado exitosamente", {"type":"success"});
						$A.get('e.force:refreshView').fire();
						helper.getFiles(component,event,opId);
						component.set('v.isLoading', false);
                    }
                    else{
                        LightningUtils.showToast("Error", result.message, {"type":"error"});
                         component.set('v.isLoading', false);
                    }
                }
                else {
                    LightningUtils.showToast("Error", errors[0].message, {"type":"error"});
                    component.set('v.isLoading', false);
                }
            },
            {
                docId : documentId,
				entityId : opId,
                file : fileName
            }
        );
    },
	getFiles: function(component,event,opId){
        let helper = this;

        component.set('v.isLoading', true);

        LightningUtils.callApex(
            component,
            "getFilesUploaded",
            function(succeed, result, errors) {
                if(succeed) {
                    if(!result.hasError){
						component.set('v.files', result.files);
						component.set('v.isLoading', false);
                        var shouldDisabled = component.get('v.shouldDisabledButton');
						var inputs = component.get('v.inputs');
						var files = component.get('v.files');
                        // En caso de problemas borrar esto
                        let wrapper = new Array();
                        //------------------------------------
                       
						var checks = new Array();

						
						for(var i = 0 ; i < inputs.length; i++){
							var filename = inputs[i]['key'] + '_' + component.get('v.entityId');
                            var name = inputs[i]['value'].toUpperCase();
                            var decla = 'Declaración jurada';
                            var solIng = 'Solicitud de ingreso';
                            
                            var uploaded = files.indexOf(filename) != -1;
                          	let shouldDisabledFromSales = shouldDisabled && (name.includes(decla.toUpperCase()) || name.includes(solIng.toUpperCase())) && component.get('v.isProfileVentas');
                           
                          
                            if(shouldDisabledFromSales){
                				console.log('entro');
                                uploaded = true;	
                            }else{
                                console.log('entra en el else ' + uploaded);
                               checks[i] = uploaded;
                            }
                            
							
                            
                            // En caso de problemas borrar esto
                            wrapper.push({
                                archivo: inputs[i],
                                subido: uploaded
                            });
                            //---------------

						}
                       	// En caso de problemas borrar esto
                        component.set('v.wrapperFile',wrapper);
                        //-------------------------------------
						component.set('v.checks',checks);
                        
                    }
                    else{
                        LightningUtils.showToast("Error", result.message, {"type":"error"});
                         component.set('v.isLoading', false);
                    }
                }
                else {
                    LightningUtils.showToast("Error", errors[0].message, {"type":"error"});
                    component.set('v.isLoading', false);
                }
            },
            {
                oppId: opId
            }
        );
    }
})