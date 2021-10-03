({
	callTestReintegro: function (component, event) {
		let objeto = {
			medicamento: component.find('medicamento').get("v.value"),
			prestacion: component.find('prestacion').get("v.value"),
			fecha: component.find('fecha').get("v.value"),
			contexto: component.find('contexto').get("v.value"), 
			asociado: component.find('asociado').get("v.value"),
			tipo: event.getSource().get("v.name")
		}

		component.set('v.isLoading', true);

		LightningUtils.callApex(
        	component,
            "testReintegro",
            function(succeed, result, errors) {
                if (succeed) {
					
					if(!result.hasError) {
						LightningUtils.showToast('Test exitoso', 'El test de reintegro fue realizado satisfactoriamente.', {"type":"success"});
						component.find("plan").set("v.value", result.plan);
						component.find("modeloPlan").set("v.value", result.modeloPlan);
						if(objeto.tipo == 'prestacion') {
							component.find("honorario").set("v.value", result.data.honorario);
							component.find("copago").set("v.value", result.data.copago);
							component.find("gastos").set("v.value", result.data.gastos);
							component.find("totalPres").set("v.value", result.data.total);
						} else if(objeto.tipo == 'medicamento') {
							component.find("venta").set("v.value", result.data.precio_vta);
							component.find("venta20").set("v.value", result.data.precio_vta_20);
							component.find("cobertura").set("v.value", result.data.porc_cob);
							component.find("totalMed").set("v.value", result.data.total);
						}
					} else {
						LightningUtils.showToast('Info', result.message);
					}

                } else {
                    
                }

				component.set('v.isLoading', false);
				
                
            },
			{ 
				data : JSON.stringify(objeto)
			} 
        );

	},

	getReintegroRT: function (component, event) {
		component.set('v.isLoading', true);
		LightningUtils.callApex(
        	component,
            "getReintegroRT",
            function(succeed, result, errors) {
				if (succeed) {
					let createRecordEvent = $A.get("e.force:createRecord");
					createRecordEvent.setParams({
						"entityApiName": "Case",
						"recordTypeId": result
					});
					createRecordEvent.fire();
				}
				component.set('v.isLoading', false);
			} 
        );
		
	}


							
})