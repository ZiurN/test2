({
    getIntegrantes: function(component, event, id) {
        let helper = this;

        component.set('v.isLoading', true);

        LightningUtils.callApex(
            component,
            "getIntegrantesFromOpp",
            function(succeed, result, errors) {
                if (succeed) {
                    if (!result.hasError) {
                        component.set('v.integrantes', result.integrantes);
                        component.set('v.isLoading', false);
                    } else {
                        LightningUtils.showToast("Error", result.message, { "type": "error" });
                        component.set('v.isLoading', false);
                    }
                } else {
                    LightningUtils.showToast("Error", errors[0].message, { "type": "error" });
                    component.set('v.isLoading', false);
                }
            }, {
                oppId: id
            }
        );
    },
    getDocumentIngreso: function(component, event, opId){
        
        LightningUtils.callApex(
            component,
            "getDocumentSolicitudIngreso",
            function(succeed, result, errors) {
                if (succeed) {
                    if (!result.hasError) {
                        component.set('v.contentDocumentEntry', result.hasDocument);
                        component.set('v.isLoading', false);
                    } else {
                        LightningUtils.showToast("Error", result.message, { "type": "error" });
                        component.set('v.isLoading', false);
                    }
                } else {
                    LightningUtils.showToast("Error", errors[0].message, { "type": "error" });
                    component.set('v.isLoading', false);
                }
            },{
                oppId: opId
            }
        );
    },
    getDocumentDDJJ: function(component,event,opId){
        
        LightningUtils.callApex(
            component,
            "getDocumentDDJJ",
            function(succeed, result, errors) {
                if (succeed) {
                    if (!result.hasError) {
                        component.set('v.contentDocumentDDJJ', result.hasDocument);
                        component.set('v.isLoading', false);
                    } else {
                        LightningUtils.showToast("Error", result.message, { "type": "error" });
                        component.set('v.isLoading', false);
                    }
                } else {
                    LightningUtils.showToast("Error", errors[0].message, { "type": "error" });
                    component.set('v.isLoading', false);
                }
            },{
                oppId: opId
            }
        );
    },

    getActivateUploadFiles: function(component, event, opId){
        
        LightningUtils.callApex(
            component,
            "getActivateFilesUpload",
            function(succeed, result, errors) {
                if (succeed) {
                    if (!result.hasError) {
                        component.set('v.activateFilesUpload', !result.checkbox);
                        component.set('v.isLoading', false);
                    } else {
                        LightningUtils.showToast("Error", result.message, { "type": "error" });
                        component.set('v.isLoading', false);
                    }
                } else {
                    LightningUtils.showToast("Error", errors[0].message, { "type": "error" });
                    component.set('v.isLoading', false);
                }
            },{
                oppId: opId
            }
        );
    },
    getFiles: function(component, event, opId) {
        let helper = this;

        component.set('v.isLoading', true);

        LightningUtils.callApex(
            component,
            "getFilesUploaded",
            function(succeed, result, errors) {
                if (succeed) {
                    if (!result.hasError) {
                        component.set('v.files', result.files);
                        component.set('v.isLoading', false);
                    } else {
                        LightningUtils.showToast("Error", result.message, { "type": "error" });
                        component.set('v.isLoading', false);
                    }
                } else {
                    LightningUtils.showToast("Error", errors[0].message, { "type": "error" });
                    component.set('v.isLoading', false);
                }
            }, {
                oppId: opId
            }
        );
    },
    getCreatorsProfile: function(component, event, id) {
        component.set('v.isLoading', true);

        LightningUtils.callApex(
            component,
            "getCreatorsProfile",
            function(succeed, result, errors) {
                if (succeed) {
                    if (!result.hasError) {
                        component.set('v.perfil', result.profile);
                        component.set('v.isLoading', false);
                    } else {
                        LightningUtils.showToast("Error", result.message, { "type": "error" });
                        component.set('v.isLoading', false);
                    }
                } else {
                    LightningUtils.showToast("Error", errors[0].message, { "type": "error" });
                    component.set('v.isLoading', false);
                }
            }, {
                userId: id
            }
        );
    }


});