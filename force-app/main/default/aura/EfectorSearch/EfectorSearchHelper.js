({
	search: function (component, event) {
		let matricula = component.find('matricula').get("v.value");
		let provincia = component.find('provincia').get("v.value");
		let localidad = component.find('localidad').get("v.value");

		component.set('v.isLoading', true);

		LightningUtils.callApex(
        	component,
            "search",
            function(succeed, result, errors) {
                if (succeed) {
					
					if(!result.hasError) {
						if(result.efectores.length) {
							let sections = component.get('v.activeSections');
							let efectores = result.efectores;

							LightningUtils.showToast('Búsqueda finalizada', 'La búsqueda ha sido exitosa', {"type":"success"});
							console.log(result.efectores);
							
							if(!sections.includes('Resultados')) {
								sections.push('Resultados');
								component.set('v.activeSections', sections);
							}

							console.log(sections);
							efectores.forEach(efector => {
								efector.Name = efector.Efector__r.Name;
							});
							
							component.set('v.efectores', efectores);
							//---------------------------------------------------------


							//component.set('v.data', result.efectores);
							//Autonumerico__c
							//----------------------------------------------------------

						}
						else {
							LightningUtils.showToast('Sin resultados', 'No se han encontrado efectores que coincidan con los datos ingresados');

							component.set('v.efectores', result.efectores);
						}

					} else {
						LightningUtils.showToast('Error', 'Hubo un error, inténtelo nuevamente', {'type': 'error'});
					}

                } else {
                    
                }

				component.set('v.isLoading', false);
				
            },
			{ 
				matricula : matricula,
				provincia: provincia,
				localidad: localidad
			} 
        );

	},

	copyToClipboard: function(component, event) {
		//let id = event.getSource().get('v.value');
		//let name = document.getElementById(id).value;
		let name = event.getSource().get('v.value');
		let hiddenInput = document.createElement("input");
        
        hiddenInput.setAttribute("value", name);
        document.body.appendChild(hiddenInput);
        hiddenInput.select();
        document.execCommand("copy");
        document.body.removeChild(hiddenInput); 
        
        event.getSource().set("v.iconName" , 'utility:check');
		event.getSource().set("v.variant" , 'brand');
        
        setTimeout(function() { 
            event.getSource().set("v.iconName" , 'utility:copy');
			event.getSource().set("v.variant" , 'neutral');
        }, 700);
	}
})