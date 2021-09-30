({
    goToApex: function (component, event, idInt) {
        $A.createComponent(
            "c:integranteAttachFilesModal",
            {
                "recordId" : idInt
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