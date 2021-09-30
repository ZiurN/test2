({
	init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Fecha desde', fieldName: 'fecha_desde', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Fecha hasta', fieldName: 'fecha_hasta', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Plan', fieldName: 'plan_nombre', type: 'text', fixedWidth: 300, cellAttributes: { alignment: 'center'}}
        ]);
    }
})