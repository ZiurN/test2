({
    init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Tipo de Matrícula', fieldName: 'tipo_matricula', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'}},
            { label: 'Código', fieldName: 'codigo', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'}},
            { label: 'Provincia', fieldName: 'nombre_pcia', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'}},
            { label: 'Matrícula', fieldName: 'matricula', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'}}
        ]);
    }
})