({
	goToApex: function (component, event, idEfector) {
		let helper = this;
		component.set('v.isLoading', true);

		LightningUtils.callApex(
			component,
			"attachPfdConvenios",
			function(succeed, result, errors) {
				if(succeed) {
					if(!result.hasError) {
					    if(result.message == 'ok') {
					        LightningUtils.showToast(
					            "Operación correcta",
					            'Los convenios fueron adjuntados correctamente.',
					            { "type":"success" }
					        );
							$A.get('e.force:refreshView').fire();
							helper.navigateToAttachedFiles(component);
                        }
						else {
							LightningUtils.showToast( "Info", result.message);
						}
					}
					else {
						LightningUtils.showToast("Error", result.message, {"type":"error"});
					}
				} else {
                    LightningUtils.showToast("Error", 'Hubo un error en SF, por favor contacte con su administrador', {"type":"error"});
                }
                component.set('v.isLoading', false);
			},
			{
				idEfector : idEfector
			}
		);
	},

	navigateToAttachedFiles: function(component) {
		let relatedListEvent = $A.get("e.force:navigateToRelatedList");
		relatedListEvent.setParams({
			"relatedListId": "AttachedContentDocuments",
			"parentRecordId": component.get("v.recordId")
		});
		relatedListEvent.fire();
	}

})