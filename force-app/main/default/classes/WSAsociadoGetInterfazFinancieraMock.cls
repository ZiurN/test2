public class WSAsociadoGetInterfazFinancieraMock{

	public static String getInterfazFinancieraOK(){
		return 
            '{' +
                '"data": [' +
                    '{' +
                        '"entidad": "51989",' +
                        '"nombre_fantasia": "PLATZ AVELINO MARCOS",' +
                        '"razon_social": "PLATZ AVELINO MARCOS",' +
                        '"estado": "A",' +
                        '"solicitud": "F",' +
                        '"replicado": "V",' +
                        '"codigo_ganancias": "998",' +
                        '"secuencia_ganancias": "1",' +
                        '"regimen_ganancias": "No Categorizado Genericos",' +
                        '"inscripto_ganancias": "N",' +
                        '"agente_retencion_ganancias": "F",' +
                        '"porcentaje_exencion_ganancias": "0",' +
                        '"codigo_exencion_ganancias": null,' +
                        '"regimen_exencion_ganancias": null,' +
                        '"resolucion_exencion_ganancias": null,' +
                        '"fecha_desde_exencion_ganancias": null,' +
                        '"fecha_hasta_exencion_ganancias": null,' +
                        '"codigo_condicion_iva": "4",' +
                        '"descripcion_condicion_iva": "CF  - Consumidor Final",' +
                        '"agente_retencion_iva": "F",' +
                        '"codigo_regimen_iva": "99",' +
                        '"descripcion_regimen_iva": "No Retencion - Exento",' +
                        '"comprobante_iva": "F",' +
                        '"porcentaje_exencion_iva": "0",' +
                        '"codigo_exencion_iva": null,' +
                        '"regimen_exencion_iva": null,' +
                        '"resolucion_exencion_iva": null,' +
                        '"fecha_desde_exencion_iva": null,' +
                        '"fecha_hasta_exencion_iva": null,' +
                        '"codigo_ib": "99",' +
                        '"secuencia_ib": "1",' +
                        '"regimen_ib": "No Retención",' +
                        '"convenio_ib": "No Corresponde",' +
                        '"numero_ib": " ",' +
                        '"fecha_vigencia_ib": null,' +
                        '"provincia_ib": null,' +
                        '"agente_retencion_ib": "F",' +
                        '"cuit_cuil_cpte": null,' +
                        '"presenta_cpte": "F",' +
                        '"tipo_cuit_cpte": "NINGUNO",' +
                        '"anses_codigo_cpte": null,' +
                        '"codigo_mco_clientes": "ACABA",' +
                        '"descripcion_mco_clientes": "Débito por ACA Buenos Aires",' +
                        '"nro_mco_clientes": "75",' +
                        '"tipo_doc_mco_clientes": "LE",' +
                        '"nro_doc_mco_clientes": "05481237",' +
                        '"banco_mco_clientes": null,' +
                        '"sucursal_mco_clientes": null,' +
                        '"codigo_moneda_mco_clientes": null,' +
                        '"moneda_mco_clientes": null,' +
                        '"banco_prov": null,' +
                        '"banco_sucursal_prov": null,' +
                        '"banco_moneda_prov": null,' +
                        '"banco_tipo_cta_prov": null,' +
                        '"banco_cuenta_prov": null,' +
                        '"banco_cuenta_descr_prov": null,' +
                        '"orden_cheque_prov": "PLATZ AVELINO MARCOS",' +
                        '"cbu_prov": null,' +
                        '"mpa_codigo_prov": null,' +
                        '"mpa_descripcion_prov": null,' +
                        '"personeria_otros": null,' +
                        '"motivo_inhab_otros": null,' +
                        '"fecha_inicio_otros": "FÍSICA",' +
                        '"codigo_empresa_otros": null,' +
                        '"nombre_empresa_otros": "1997-09-01 00:00:00",' +
                        '"alias_otros": "1",' +
                        '"iva_cumplidor_otros": "AcaSalud TEST2",' +
                        '"mpa_codigo": "PLATZ AVELINO MARCOS",' +
                        '"medio_pago": "F"' +
                    '}' +
                '],' +
                '"meta": {' +
                    '"allowed_filters": [],' +
                    '"allowed_sorts": [],' +
                    '"allowed_appends": [],' +
                    '"allowed_fields": [],' +
                    '"allowed_includes": [],' +
                    '"default_includes": [],' +
                    '"optional_get_vars": {' +
                        '"sortBy": [],' +
                        '"sortOrder": [' +
                            '"asc",' +
                            '"desc"' +
                        '],' +
                        '"pageSize": {' +
                            '"0": "?pageSize=0",' +
                            '"15": "?pageSize=15",' +
                            '"50": "?pageSize=50",' +
                            '"100": "?pageSize=100"' +
                        '}' +
                    '}' +
                '}' +
            '}';
	}

	public static String getInterfazFinancieraERROR(){
		return 
			'{' +
				'"data": {' +
					'"error": true,' +
					'"errors": [],' +
					'"errorType": "exception",' +
					'"httpCode": 404,' +
					'"message": "La entidad ingresada es inválida.",' +
					'"debug_message": [],' +
					'"exception": "NotFoundHttpException",' +
					'"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php",' +
					'"line": 964' +
				'}' +
			'}';
	}
}