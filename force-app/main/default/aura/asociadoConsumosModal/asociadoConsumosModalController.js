({
	init: function (component, event, helper) {
		let id = component.get('v.codigo');
		helper.getConsumosHelper(component, event, helper);
        component.set('v.mycolumns', [
            { label: 'Fecha', fieldName: 'fecha_prestacion', type: 'date', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
            { label: 'Tipo', fieldName: 'tipo', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
            { label: 'Tipo de Prestación', fieldName: 'tipo_prestacion', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
            { label: 'Origen', fieldName: 'origen', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'} },
            { label: 'Prestación', fieldName: 'prestacion', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'} },
			{ label: 'Cantidad', fieldName: 'cantidad', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
            { label: 'Descripción', fieldName: 'desc_prestacion', type: 'text', fixedWidth: 300, cellAttributes: { alignment: 'center'} },
			{ label: 'Total', fieldName: 'total', type: 'currency', fixedWidth: 130, cellAttributes: { alignment: 'center'} },
        ]);
    },

	onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
		helper.getConsumosHelper(component, event, helper);

    },
    
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
		helper.getConsumosHelper(component, event, helper);
    },
    
    processMe : function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
		helper.getConsumosHelper(component, event, helper);
    },
    
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
		helper.getConsumosHelper(component, event, helper);
    },
    
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
		helper.getConsumosHelper(component, event, helper);
    }

})