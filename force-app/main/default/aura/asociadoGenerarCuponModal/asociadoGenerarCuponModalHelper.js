({
    getDeudas: function (component, ids,fecha,helper,print,email) {
        component.set('v.isLoading', true);
        console.log(fecha);
        if(!fecha){LightningUtils.showToast("Fecha incompleta", result.message,
            {"type":"warning"});}
        LightningUtils.callApex(
            component,
            "getDeudasAsociado",
            function(succeed, result, errors) {
                if(succeed) {
                    if(!result.hasError){
                        if(result.datosDeDeudas.length > 0) {
                            let ctaData = result.datosDeDeudas.map(dat =>
                                {
                                    return '{"dat_nro":"'+dat.p_dat_nro+
                                    '","cuota":"'+dat.p_det_cuota_act+
                                    '","deuda":"'+dat.p_deuda_act+'' +
                                    '","fecha":"'+dat.vencimiento+''+
                                    '"}';}
                                    );
                            if(print){
                                helper.generarCupones(component,ctaData,result.message);
                            }
                            else{
                                helper.sendCupones(component,ctaData,email,result.message);
                            }

                        } else {
                            LightningUtils.showToast("No hay datos", result.message,
                                {"type":"warning"});
							component.set('v.isLoading', false);

                        }
                    }
                    else{
                        LightningUtils.showToast("Error", result.message,
                            {"type":"error"});
						component.set('v.isLoading', false);

                    }
                }
                else {
                    LightningUtils.showToast("Error",
                        "Hubo un error, asegúrese que el Afi Id esté en formato numérico y no esté duplicado",
                        {"type":"error"});

                }

        },
            {
                idComprobante: ids,
                fecha: fecha
            }
        );
    },
    sendCupones: function (component, ctaDatas,email,tokenStr) {
        LightningUtils.callApex(
            component,
            "sendCupones",
            function(succeed, result, errors) {
                if(succeed) {
                    if(!result.hasError){
                        if(result.datosDeCupon.length > 0) {
                            LightningUtils.showToast("Mail enviado",
                                "Se  han enviado los cupones de pago a " + email,
                                {"type":"success"});
                        } else {
                            LightningUtils.showToast("No hay datos",
                                result.message,
                                {"type":"warning"});

                        }
                    }
                    else{
                        LightningUtils.showToast("Error",
                            result.message,
                            {"type":"error"});

                    }
                }
                else {
                    LightningUtils.showToast("Error",
                        "Hubo un error al generar el cupon de pago",
                        {"type":"error"});

                }
                component.set('v.isLoading', false);
            },
            {
                requests: ctaDatas,
                address: email,
				token: tokenStr
            }
        );
    },
    generarCupones: function(component,ctaDatas,tokenStr){
        LightningUtils.callApex(
            component,
            "generateCupones",
            function(succeed, result, errors) {
                if(succeed) {
                    if(!result.hasError){
                        if(result.datosDeCupon.length > 0) {
                            for(let i = 0; i < result.datosDeCupon.length;i++){
                                var urlEvent = $A.get("e.force:navigateToURL");
                                urlEvent.setParams({
                                    "url": result.datosDeCupon[i].link
                                });
                                urlEvent.fire();
                            }

                        } else {
                            LightningUtils.showToast("No hay datos",
                                result.message,
                                {"type":"warning"});

                        }
                    }
                    else{
                        LightningUtils.showToast("Error",
                            result.message,
                            {"type":"error"});

                    }
                }
                else {
                    LightningUtils.showToast("Error",
                        "Hubo un error al generar el cupon de pago",
                        {"type":"error"});

                }
                component.set('v.isLoading', false);
            },
            {
                requests: ctaDatas,
				token: tokenStr
            }
        );
    }
});