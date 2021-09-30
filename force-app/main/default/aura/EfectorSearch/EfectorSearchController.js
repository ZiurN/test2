({
	init: function (cmp, event, helper) {
		cmp.set('v.columns', [
			{label: 'Nombre', fieldName: 'Name', type: 'text'},
			{label: 'Provincia', fieldName: 'Provincia_nombre__c', type: 'text'},
			{label: 'Matricula', fieldName: 'Matricula__c', type: 'text'},
			{label: 'Copiar', type: 'button', typeAttributes: {label: { fieldName: 'actionLabel'}, name: 'copy', iconName: 'utility:copy'}}
		]);
	},

	handleClickBtn: function (component, event, helper) {	
		helper.search(component, event);
	},

	copyText: function(component, event, helper) {
		helper.copyToClipboard(component, event);
    },

	copyTextTable: function(component, event, helper) {
		let action = event.getParam('action');
        let selectedRow = event.getParam('row');
        if(action.name === 'copy') {
			let autonum = selectedRow.Efector__r.Autonumerico__c;
			let hiddenInput = document.createElement("input");
        
			hiddenInput.setAttribute("value", autonum);
			document.body.appendChild(hiddenInput);
			hiddenInput.select();
			document.execCommand("copy");
			document.body.removeChild(hiddenInput); 
		}
	}


})