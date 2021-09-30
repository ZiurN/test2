({
    init: function (component, event, helper) {
        component.find('dateDeuda').set('v.value',new Date().toISOString());
        component.set('v.mycolumns', [
            { label: 'Comprobante', fieldName: 'comprobante', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"},
                fixedWidth: 120, cellAttributes: { alignment: 'center'}},
            { label: 'Vencimiento', fieldName: 'vencimiento', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"},
                fixedWidth: 120, cellAttributes: { alignment: 'center'}},
            { label: 'Cuota', fieldName: 'cuota', type: 'text',
                fixedWidth: 80, cellAttributes: { alignment: 'center'}},
            { label: 'Importe', fieldName: 'importe', type: 'currency',
                fixedWidth: 120},
            { label: 'Saldo', fieldName: 'saldo', type: 'currency',
                fixedWidth: 120},
        ]);
    },

    sendInvoices: function (component, event, helper){
        let data= component.find("table").getSelectedRows();
        let ids = data.map( d => d.id);
        let email = component.find("sendEmail").get("v.value");
        let fecha = component.find("dateDeuda").get("v.value");
        if(!email) {
            LightningUtils.showToast('Campo vacío',
                'Por favor, complete el campo Email',
                {"type":"info"});
            return;
        }
        if(ids.length >0){
            helper.getDeudas(component,ids,fecha,helper,false,email);
        }
        else{
            LightningUtils.showToast('Error',
                'Por favor elija al menos una factura para generar cupon de pago',
                {"type":"warning"});
        }
    },

    printInvoices: function (component, event, helper) {
        var data= component.find("table").getSelectedRows();
        let ids = data.map( d => d.id);
        let fecha = component.find("dateDeuda").get("v.value");
        
        if(ids.length >0){
            if(fecha != null){
                helper.getDeudas(component,ids,fecha,helper,true,'');
            }
            else {
                LightningUtils.showToast('Error',
                    'Por favor elija la fecha de vencimiento de la deuda',
                    {"type":"warning"})
            }
        }
        else{
            LightningUtils.showToast('Error',
                'Por favor elija al menos una factura para generar cupon de pago',
                {"type":"warning"})
        }
    }
});