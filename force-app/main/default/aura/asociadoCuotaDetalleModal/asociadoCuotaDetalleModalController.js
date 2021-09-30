({
    init: function (component, event, helper) {
        component.set('v.mycolumns', [
            {
                label: 'Cláusula', fieldName: 'clausula', type: 'text',
                fixedWidth: 150, cellAttributes: {alignment: 'center'}
            },
            {
                label: 'Categoría Grupal', fieldName: 'categoria_grupal', type: 'text',
                fixedWidth: 150, cellAttributes: {alignment: 'center'}
            },
            {
                label: 'Apellidos', fieldName: 'apellidos', type: 'text',
                fixedWidth: 110, cellAttributes: {alignment: 'center'}
            },
            {
                label: 'Nombres', fieldName: 'nombres', type: 'text',
                fixedWidth: 110, cellAttributes: {alignment: 'center'}
            },
            {
                label: 'Regla/Adicional', fieldName: 'regla_adicional', type: 'text',
                fixedWidth: 150, cellAttributes: {alignment: 'center'}
            },
            {
                label: 'Cantidad', fieldName: 'cantidad', type: 'text',
                fixedWidth: 90, cellAttributes: {alignment: 'center'}
            },
            {
                label: 'Importe final', fieldName: 'importe_final',
                fixedWidth: 110, cellAttributes: {alignment: 'center'} ,type: 'currency',
                typeAttributes: { currencyCode: 'ARS', maximumSignificantDigits: 7}
            },
            {
                label: 'Importe regla adicional', fieldName: 'importe_regla_adicional', type: 'text',
                fixedWidth: 110, cellAttributes: {alignment: 'center'}
            },
            {
                label: 'Cuadro de costo', fieldName: 'importe_cuadro_costo', type: 'text',
                fixedWidth: 110, cellAttributes: {alignment: 'center'}
            },
            {
                label: 'Bonificación/Recargo', fieldName: 'importe_bonif_recargo', type: 'text',
                fixedWidth: 110, cellAttributes: {alignment: 'center'}
            },
            {
                label: 'Coeficiente', fieldName: 'coeficiente', type: 'text',
                fixedWidth: 110, cellAttributes: {alignment: 'center'}
            },
            {
                label: 'Coeficiente General', fieldName: 'coeficiente_general', type: 'text',
                fixedWidth: 110, cellAttributes: {alignment: 'center'}
            },
            {
                label: 'Coeficiente B/R', fieldName: 'coeficiente_b_r', type: 'text',
                fixedWidth: 110, cellAttributes: {alignment: 'center'}
            },
            {
                label: 'Codigo Afiliado', fieldName: 'codigo_afiliado', type: 'text',
                fixedWidth: 110, cellAttributes: {alignment: 'center'}
            }
        ]);
    }
});