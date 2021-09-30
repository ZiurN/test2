({
    init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'F. vigencia desde', fieldName: 'fecha_vigencia_desde', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'F. vigencia hasta', fieldName: 'fecha_vigencia_hasta', type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Grado', fieldName: 'grado', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Prioridad', fieldName: 'prioridad', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Importe', fieldName: 'importe', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Importe no reconocido', fieldName: 'importe_no_reconocido', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Porcentaje', fieldName: 'porcentaje', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Porcentaje reconocido', fieldName: 'porcentaje_reconocido', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Agrupación empresa', fieldName: 'agrupacion_empresa', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Grupo empresa', fieldName: 'grupo_empresa', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Empresa', fieldName: 'empresa', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Sucursal', fieldName: 'sucursal', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Obra Social', fieldName: 'obra_social', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Modelo de Plan', fieldName: 'modelo_plan', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Agrupación del plan', fieldName: 'agrupacion_plan', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Plan', fieldName: 'plan', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Categoría de afiliado', fieldName: 'categoria_afiliado', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Agrupación de afiliado 1', fieldName: 'agrupacion_afiliado', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Agrupación de afiliado 2', fieldName: 'agrupacion1_afiliado', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Agrupación de afiliado 3', fieldName: 'agrupacion2_afiliado', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Agrupación de afiliado 4', fieldName: 'agrupacion3_afiliado', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Agrupación de afiliado 5', fieldName: 'agrupacion4_afiliado', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Código de afiliado', fieldName: 'codigo_afiliado', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Apellido del afiliado', fieldName: 'apellidos_afiliado', type: 'text', fixedWidth: 130, cellAttributes: { alignment: 'center'}},
            { label: 'Nombres', fieldName: 'nombres_afiliado', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'}}
        ]);
    }
});