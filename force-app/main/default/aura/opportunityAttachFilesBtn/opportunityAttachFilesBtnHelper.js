({
    goToApex: function (component, event, idOpp) {
        var  isVentas = component.get('v.isVentas');
        var disabledButton =  !component.get('v.previousState');
        console.log('disabled ' + disabledButton);
        $A.createComponent(
            "c:opportunityAttachFilesModal",
            {
                "recordId" : idOpp,
                "isProfileVentas" : isVentas,
                "shouldDisabledButton": disabledButton
            },
            function(cmp, status, errorMessage){
                if (status === "SUCCESS") {
                    let modalBody = cmp;
                    //==================================================================
                    component.find('overlayLib').showCustomModal({
                        header: "Carga de documentos",
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
});