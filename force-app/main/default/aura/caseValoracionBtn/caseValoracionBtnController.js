({
    doInit: function (component,event,helper){
        let d = new Date();
        let date = d. getDate();
        let month = d. getMonth() + 1; // Since getMonth() returns month from 0-11 not 1-12.
        let year = d. getFullYear(); 
        let formattedMonth = ("0" + month).slice(-2);

        component.find('period').set("v.value",formattedMonth + "-"+year);
    },
    handleClickBtn: function (component, event, helper) {
        let id = component.get('v.recordId');
        let period = component.find('period').get("v.value");
        let record = component.get('v.caseSimpleRecord');
        let afiId = record.Account.Afi_Id__c;
        
        helper.getValoracion(component,event,id,afiId,period);
    },
    periodCheck: function(component,event,helper){
    	let inputField = component.find('period');
        let period = component.find('period').get("v.value");
        let regex = /^(((0)[0-9])|((1)[0-2]))(\-)\d{4}$/i;
        let valid = period.match(regex);
        component.set('v.validPeriod',valid != null);
        if(valid == null){
            inputField.setCustomValidity("Formato incorrecto");
        }
        else{
            inputField.setCustomValidity("");
        }
        inputField.reportValidity();
	}
})