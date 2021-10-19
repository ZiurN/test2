({	
	getInterfazFinancieraFromApex: function (component, event, asociado){
        let helper = this;
		if(!asociado.Codigo_de_Entidad__c) {
            LightningUtils.showToast("Campo incompleto", 'El Código de Entidad no puede estar vacío');
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

							result.proveedorSection = helper.orderByOrderField(result.proveedorSection);
							result.clienteSection = helper.orderByOrderField(result.clienteSection);

							helper.showModal(component, event, result,asociado);
                            window.setTimeout(
                                $A.getCallback(function() {
                                	component.set('v.isLoading', false);
                                }), 1000
                            );
						}
						else{
                            LightningUtils.showToast("No hay datos",
								'No se encontraron datos para este afiliado en SaludSoft',
								{"type":"warning"});
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
				codigoDeEntidad : asociado.Codigo_de_Entidad__c
			}
		);

    },
    
    showModal: function(component, event, interfazFinancieraResponse,asociado){
			let acc = component.get('v.accountSimpleRecord');
			$A.createComponents(
            [["c:asociadoInterfazFinancieraModal",
            {
                accountRecord : acc,
				'gananciasSectionFields': interfazFinancieraResponse.gananciasSection,
                'ivaSectionFields': interfazFinancieraResponse.ivaSection,
                'iibbSectionFields': interfazFinancieraResponse.iibbSection,
                'proveedorSectionFields': interfazFinancieraResponse.proveedorSection,
                'comprobanteSectionFields': interfazFinancieraResponse.comprobanteSection,
                'clienteSectionFields': interfazFinancieraResponse.clienteSection,
           		'otrosSectionFields': interfazFinancieraResponse.otrosSection
            }],
				["lightning:formattedRichText", {
					"value": "<p class='title slds-text-heading--medium slds-hyphenate'>Interfaz Financiera<br/>Titular: "+asociado.Titular_apellidos__c +
						asociado.Titular_nombres__c + "</p>"
				}]],
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp[0];
                    let isFamiliar = asociado.Type === "Familiar" ? cmp[1] : "Interfaz Financiera";
					//==================================================================
					component.find('overlayLib').showCustomModal({
						header: isFamiliar,
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
	},

	orderByOrderField: function(list) {
		list.sort( (a, b) => {
			if (a.order > b.order) {
				return 1;
			}
			if (a.order < b.order) {
				return -1;
			}
			return 0;
		});

		return list;
	}
})