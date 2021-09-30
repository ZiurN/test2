({
    init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Nro de Comprobante', fieldName: 'cabcp_id', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Tipo', fieldName: 'tipo', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Comprobante', fieldName: 'comprobante', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Fecha de Emisión', fieldName: 'fecha_emision', type: 'date-local', fixedWidth: 130, cellAttributes: { alignment: 'center'},
				typeAttributes: {day: "2-digit", month: "2-digit", year: "numeric"} },
            { label: 'Fecha Vencimiento', fieldName: 'fecha_vencimiento', type: 'date-local', fixedWidth: 130, cellAttributes: { alignment: 'center'},
				typeAttributes: {day: "2-digit", month: "2-digit", year: "numeric"}},
            { label: 'Total', fieldName: 'total', type: 'currency', fixedWidth: 130},
            { label: 'Proceso Contable', fieldName: 'proceso_contable', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Liquidación', fieldName: 'liquidacion', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'}},
			{ label: 'Fecha Liquidación', fieldName: 'fecha_liquidacion', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
			{ label: 'Nota Ajuste', fieldName: 'nota_ajuste', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
			{ label: 'Fecha Nota', fieldName: 'fecha_nota_ajuste', type: 'date-local', fixedWidth: 130, cellAttributes: { alignment: 'center'},
				typeAttributes: {day: "2-digit", month: "2-digit", year: "numeric"} }
        ]);
    }
})