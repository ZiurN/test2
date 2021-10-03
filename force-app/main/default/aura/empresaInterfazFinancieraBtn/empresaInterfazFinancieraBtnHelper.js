({	
	getInterfazFinancieraFromApex: function (component, event, codigoDeEntidad){
        let helper = this;
        
		if(!codigoDeEntidad) {
            LightningUtils.showToast("Campo incompleto", 'El código de empresa no puede estar vacío');
            return;
        }  
    	component.set('v.isLoading', true);
        
        LightningUtils.callApex(
			component,
			"getInterfazFinanciera",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.interfazFinanciera != null){
							result.otrosSection = result.otrosSection.map(field => {
								if(field.label === "Fecha Inicio" && field.value != null){
									let dateList = field.value.substring(0,10).split('-');
									field.value = dateList[2] + '/' + dateList[1] + '/' + dateList[0];
								}
								return field;
							});
							result.ivaSection = result.ivaSection.map(field => {
								if((field.label === "Fecha hasta Exención" || field.label === "Fecha desde Exención" )
									&& field.value != null){
									let dateList = field.value.substring(0,10).split('-');
									field.value = dateList[2] + '/' + dateList[1] + '/' + dateList[0];
								}
								return field;
							});
							result.iibbSection = result.iibbSection.map(field => {
								if(field.label === "Fecha vigencia" && field.value != null){
									let dateList = field.value.substring(0,10).split('-');
									field.value = dateList[2] + '/' + dateList[1] + '/' + dateList[0];
								}
								return field;
							});
							helper.showModal(component, event, result);
                            window.setTimeout(
                                $A.getCallback(function() {
                                	component.set('v.isLoading', false);
                                }), 1000
                            );
						}
						else{
                            LightningUtils.showToast("No hay datos", 'No se encontraron datos para esta empresa en SaludSoft', {"type":"warning"});
                            component.set('v.isLoading', false);
						}
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
				codigoDeEntidad : codigoDeEntidad
			}
		);

    },
    
    showModal: function(component, event, interfazFinancieraResponse){
			let acc = component.get('v.accountSimpleRecord');
			$A.createComponent(
            "c:asociadoInterfazFinancieraModal",
            {
                accountRecord : acc,
				'gananciasSectionFields': interfazFinancieraResponse.gananciasSection,
                'ivaSectionFields': interfazFinancieraResponse.ivaSection,
                'iibbSectionFields': interfazFinancieraResponse.iibbSection,
                'proveedorSectionFields': interfazFinancieraResponse.proveedorSection,
                'comprobanteSectionFields': interfazFinancieraResponse.comprobanteSection,
                'clienteSectionFields': interfazFinancieraResponse.clienteSection,
           		'otrosSectionFields': interfazFinancieraResponse.otrosSection
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: "Interfaz Financiera",
						body: modalBody,
						showCloseButton: true
					});
					//==================================================================
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
            }
        );
	}
})