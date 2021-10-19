({
	init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Tipo de Cláusula', fieldName: 'tipo_clausula', type: 'text', fixedWidth: 130 },
            { label: 'Descripción Tipo de Cláusula', fieldName: 'tipo_clausula_descripcion', type: 'text', fixedWidth: 200, cellAttributes: { alignment: 'center'} },
            { label: 'Fecha Vigencia Desde', fieldName: 'fecha_vigencia_desde',  type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'} },
            { label: 'Fecha Vigencia Hasta', fieldName: 'fecha_vigencia_hasta',  type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'} },
			{ label: 'Fecha de Carga', fieldName: 'fecha_carga', type: 'date',typeAttributes:{minute:"2-digit",hour:"2-digit",day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 130, cellAttributes: { alignment: 'center'} },
			{ label: 'Usuario de Carga', fieldName: 'user_carga', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'} },
			{ label: 'Tipo de Asignación', fieldName: 'tipo_asignacion', type: 'text', fixedWidth: 120, cellAttributes: { alignment: 'center'} },
            { label: 'Descripción Tipo de Asignación', fieldName: 'tipo_asignacion_descripcion', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'} },
			{ label: 'Nivel de Aprobación', fieldName: 'nivel_aprobacion', type: 'text', fixedWidth: 110, cellAttributes: { alignment: 'center'} },
			{ label: 'Requiere Evento', fieldName: 'requiere_evento', type: 'text', fixedWidth: 110, cellAttributes: { alignment: 'center'} },
			{ label: 'Requiere Patología', fieldName: 'requiere_patologia', type: 'text', fixedWidth: 110, cellAttributes: { alignment: 'center'} },
			{ label: 'Código de Diagnóstico', fieldName: 'diag_codigo', type: 'text', fixedWidth: 110, cellAttributes: { alignment: 'center'} },
			{ label: 'Descripción de Diagnóstico', fieldName: 'diag_descripcion', type: 'text', fixedWidth: 200, cellAttributes: { alignment: 'center'} },
			{ label: 'Fecha de Diagnóstico', fieldName: 'diag_fecha',  type: 'date-local',typeAttributes:{day:"2-digit",month:"2-digit",year:"numeric"}, fixedWidth: 110, cellAttributes: { alignment: 'center'} },
			{ label: 'Número de Evento', fieldName: 'numero_evento', type: 'text', fixedWidth: 110, cellAttributes: { alignment: 'center'} },
			{ label: 'Descripción del Evento', fieldName: 'descripcion_evento', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'} },
			{ label: 'Observaciones', fieldName: 'observaciones', type: 'text', fixedWidth: 150, cellAttributes: { alignment: 'center'} }
        ]);
    }
})