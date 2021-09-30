public class WSBatchEmpresaMock  {

	public static String getFound(){
		return '{'+
'    "data": ['+
'        {'+
'            "rn": "1",'+
'            "numero_solicitud": "4822",'+
'            "fecha_presentacion": "2002-10-01 00:00:00",'+
'            "agencia": "650098_ACA SALUD SUC. ROSARIO",'+
'            "estado_solicitud": "TRANSFORMADA",'+
'            "codigo_motivo": "ALTA",'+
'            "descripcion_motivo": "ALTA",'+
'            "codigo_empresa": "600011",'+
'            "razon_social": "ACA SALUD COOP.PRESTACION SERV. MEDICO ASIST.LTDA",'+
'            "minimo_grupos": null,'+
'            "maximo_grupos": null,'+
'            "limite_edad": null,'+
'            "porcentaje_limite_edad": null,'+
'            "canje": "F",'+
'            "porcentaje_canje": null,'+
'            "importe_canje": null,'+
'            "afiliados_sujetos_facturacion": "F",'+
'            "identificacion_afiliados": "Empresa",'+
'            "solicitudes_afiliado_auditoria": "Nunca",'+
'            "grupos": null,'+
'            "tipo_sol_alta_masiva": "ALTA",'+
'            "tipo_sol_alta_masiva_desc": "SOLICITUD DE ALTA",'+
'            "mot_sol_alta_masiva": "ALTA",'+
'            "mot_sol_alta_masiva_desc": "ALTA",'+
'            "tipo_sol_baja_masiva": "BAJA",'+
'            "tipo_sol_baja_masiva_desc": "SOLICITUD DE BAJA DE GRUPO FAMILIAR",'+
'            "mot_sol_baja_masiva": "BAJA",'+
'            "mot_sol_baja_masiva_desc": "BAJA",'+
'            "codigo_tipo_baja": "NOSUBS",'+
'            "descripcion_tipo_baja": "BAJA NO SUBVENCIONADA",'+
'            "codigo_agrupacion": "OBLEMP",'+
'            "descripcion_agrupacion": "AFILIADOS OBLIGATORIOS POR EMPRESA",'+
'            "agrupaciones_permitidas": "OBLDIR,OBLEMP,VOLDIR,VOLEMP",'+
'            "codigo_agrupacion1": "CODIGO1",'+
'            "descripcion_agrupacion1": "DESCRIPCION1",'+
'            "agrupaciones_permitidas1": null,'+
'            "codigo_agrupacion2": "CODIGO2",'+
'            "descripcion_agrupacion2": "DESCRIPCION2",'+
'            "agrupaciones_permitidas2": null,'+
'            "codigo_agrupacion3": "CODIGO3",'+
'            "descripcion_agrupacion3": "DESCRIPCION3",'+
'            "agrupaciones_permitidas3": null,'+
'            "codigo_agrupacion4": "CODIGO4",'+
'            "descripcion_agrupacion4": "DESCRIPCION4",'+
'            "agrupaciones_permitidas4": null,'+
'            "tipo_empresa": "EMPRESA",'+
'            "es_sujeto_facturacion": "V",'+
'            "descripcion_empresa": "ACA SALUD CASA ROSARIO",'+
'            "cuit": "30604958640",'+
'            "estado_empresa": "A",'+
'            "email": null,'+
'            "codigo_agrupacion_empresa": "PA2CCTE",'+
'            "descripcion_agrupacion_empresa": "PA2CCTE",'+
'            "codigo_grupo_empresarial": "52",'+
'            "descripcion_grupo_empresarial": "ACA SALUD",'+
'            "observaciones": null,'+
'            "fecha_registracion": "2002-10-01 00:00:00",'+
'            "f_modif": "2019-12-09 00:00:00"'+
'        }'+
'    ],'+
'    "links": {'+
'        "first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/empresas/09-12-2019?page=1",'+
'        "last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/empresas/09-12-2019?page=1",'+
'        "prev": null,'+
'        "next": null'+
'    },'+
'    "meta": {'+
'        "current_page": 1,'+
'        "from": 1,'+
'        "last_page": 1,'+
'        "path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/empresas/09-12-2019",'+
'        "per_page": 15,'+
'        "to": 1,'+
'        "total": 1,'+
'        "allowed_filters": ['+
'            "numero_solicitud",'+
'            "codigo_empresa"'+
'        ],'+
'        "allowed_sorts": [],'+
'        "allowed_appends": [],'+
'        "allowed_fields": [],'+
'        "allowed_includes": [],'+
'        "default_includes": [],'+
'        "optional_get_vars": {'+
'            "sortBy": [],'+
'            "sortOrder": ['+
'                "asc",'+
'                "desc"'+
'            ],'+
'            "pageSize": {'+
'                "0": "?pageSize=0",'+
'                "15": "?pageSize=15",'+
'                "50": "?pageSize=50",'+
'                "100": "?pageSize=100"'+
'            }'+
'        }'+
'    }'+
'}';
	}

	public static String getFoundAndContinue(){
		return '{'+
'    "data": ['+
'        {'+
'            "rn": "1",'+
'            "numero_solicitud": "4822",'+
'            "fecha_presentacion": "2002-10-01 00:00:00",'+
'            "agencia": "650098_ACA SALUD SUC. ROSARIO",'+
'            "estado_solicitud": "TRANSFORMADA",'+
'            "codigo_motivo": "ALTA",'+
'            "descripcion_motivo": "ALTA",'+
'            "codigo_empresa": "600001",'+
'            "razon_social": "ACA SALUD COOP.PRESTACION SERV. MEDICO ASIST.LTDA",'+
'            "minimo_grupos": null,'+
'            "maximo_grupos": null,'+
'            "limite_edad": null,'+
'            "porcentaje_limite_edad": null,'+
'            "canje": "F",'+
'            "porcentaje_canje": null,'+
'            "importe_canje": null,'+
'            "afiliados_sujetos_facturacion": "F",'+
'            "identificacion_afiliados": "Empresa",'+
'            "solicitudes_afiliado_auditoria": "Nunca",'+
'            "grupos": null,'+
'            "tipo_sol_alta_masiva": "ALTA",'+
'            "tipo_sol_alta_masiva_desc": "SOLICITUD DE ALTA",'+
'            "mot_sol_alta_masiva": "ALTA",'+
'            "mot_sol_alta_masiva_desc": "ALTA",'+
'            "tipo_sol_baja_masiva": "BAJA",'+
'            "tipo_sol_baja_masiva_desc": "SOLICITUD DE BAJA DE GRUPO FAMILIAR",'+
'            "mot_sol_baja_masiva": "BAJA",'+
'            "mot_sol_baja_masiva_desc": "BAJA",'+
'            "codigo_tipo_baja": "NOSUBS",'+
'            "descripcion_tipo_baja": "BAJA NO SUBVENCIONADA",'+
'            "codigo_agrupacion": "OBLEMP",'+
'            "descripcion_agrupacion": "AFILIADOS OBLIGATORIOS POR EMPRESA",'+
'            "agrupaciones_permitidas": "OBLDIR,OBLEMP,VOLDIR,VOLEMP",'+
'            "codigo_agrupacion1": null,'+
'            "descripcion_agrupacion1": null,'+
'            "agrupaciones_permitidas1": null,'+
'            "codigo_agrupacion2": null,'+
'            "descripcion_agrupacion2": null,'+
'            "agrupaciones_permitidas2": null,'+
'            "codigo_agrupacion3": null,'+
'            "descripcion_agrupacion3": null,'+
'            "agrupaciones_permitidas3": null,'+
'            "codigo_agrupacion4": null,'+
'            "descripcion_agrupacion4": null,'+
'            "agrupaciones_permitidas4": null,'+
'            "tipo_empresa": "EMPRESA",'+
'            "es_sujeto_facturacion": "V",'+
'            "descripcion_empresa": "ACA SALUD CASA CORDOBA",'+
'            "cuit": "30604958640",'+
'            "estado_empresa": "A",'+
'            "email": null,'+
'            "codigo_agrupacion_empresa": "PA2CCTE",'+
'            "descripcion_agrupacion_empresa": "PA2CCTE",'+
'            "codigo_grupo_empresarial": "52",'+
'            "descripcion_grupo_empresarial": "ACA SALUD",'+
'            "observaciones": null,'+
'            "fecha_registracion": "2002-10-01 00:00:00",'+
'            "f_modif": "2019-12-09 00:00:00"'+
'        }'+
'    ],'+
'    "links": {'+
'        "first": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/empresas/09-12-2019?page=1",'+
'        "last": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/empresas/09-12-2019?page=1",'+
'        "prev": null,'+
'        "next": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/empresas/09-12-2019?page=2"'+
'    },'+
'    "meta": {'+
'        "current_page": 1,'+
'        "from": 1,'+
'        "last_page": 2,'+
'        "path": "https://api-test.acasalud.com.ar/aca_salud_test/public//v1/salud/batch/empresas/09-12-2019",'+
'        "per_page": 15,'+
'        "to": 1,'+
'        "total": 1,'+
'        "allowed_filters": ['+
'            "numero_solicitud",'+
'            "codigo_empresa"'+
'        ],'+
'        "allowed_sorts": [],'+
'        "allowed_appends": [],'+
'        "allowed_fields": [],'+
'        "allowed_includes": [],'+
'        "default_includes": [],'+
'        "optional_get_vars": {'+
'            "sortBy": [],'+
'            "sortOrder": ['+
'                "asc",'+
'                "desc"'+
'            ],'+
'            "pageSize": {'+
'                "0": "?pageSize=0",'+
'                "15": "?pageSize=15",'+
'                "50": "?pageSize=50",'+
'                "100": "?pageSize=100"'+
'            }'+
'        }'+
'    }'+
'}';
	}

	public static String getError(){
		return '{'+
					'"data": {'+
						'"error": true,'+
						'"errors": [],'+
						'"errorType": "exception",'+
						'"httpCode": 404,'+
						'"message": "Formato de fecha inválido. El formato debe ser d-m-Y.",'+
						'"debug_message": [],'+
						'"exception": "NotFoundHttpException",'+
						'"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php",'+
						'"line": 964'+
					'}'+
				'}';
	}
}