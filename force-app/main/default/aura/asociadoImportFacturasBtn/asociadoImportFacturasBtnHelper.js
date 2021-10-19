({
	goToApex: function (component, event, idAsociado) {
		let helper = this;
		let id = component.get('v.accountSimpleRecord').Id;
		if(!idAsociado) {
			LightningUtils.showToast("Campo incompleto", 'El Afi Id no puede estar vacío');
			return;
		}
		component.set('v.isLoading', true);
		LightningUtils.callApex(
			component,
			"getAsociadoFacturasAndImportIntoSF",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError){
						if(result.message == '') {
							LightningUtils.showToast( "Datos actualizados", 'Las facturas han sido importadas a Salesforce correctamente', {"type":"success"} );
						} else {
							LightningUtils.showToast("No hay datos", result.message, {"type":"warning"});
						}
					}
					else{
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				}
				else {
					LightningUtils.showToast("Error", "Hubo un error, asegúrese que el Afi Id esté en formato numérico y no esté duplicado", {"type":"error"});
				}
				component.set('v.isLoading', false);
			},
			{
				idAsociado : idAsociado,
				accountId: id
			}
		);
	}
})