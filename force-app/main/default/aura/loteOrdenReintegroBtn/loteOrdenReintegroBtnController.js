({
    handleClickBtn: function(component, event, helper) {
        let lot_id = component.get('v.accountSimpleRecord').Id_lote_SS__c;
        helper.goToApex(component, event, lot_id);
    }
})