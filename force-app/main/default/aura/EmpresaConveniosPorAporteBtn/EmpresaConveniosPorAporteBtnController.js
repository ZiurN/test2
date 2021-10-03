({
    handleClickBtn: function (component, event, helper) {
        let codEmpresa = component.get('v.accountSimpleRecord').Codigo_de_empresa__c;
        helper.goToApex(component, event, codEmpresa);
    }
});