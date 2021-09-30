public class WSCasoEnviarASSMock  {

	public static String getFound(){
		return '{'+
				'"data": {'+
				'"ap": {'+
				'"apr_id": "1014010015",'+
				'"fecha": "2020-02-02 00:00:00",'+
				'"conexion": "CX--MOST",'+
				'"nombre_conexion": "Mostrador",'+
				'"delegacion": "650098",'+
				'"nombre_delegacion": "650098_ACA SALUD SUC. ROSARIO",'+
				'"fecha_probable": "2019-02-02 00:00:00",'+
				'"estado": "CA-----A",'+
				'"nombre_estado": "CENTRO AUTORIZADOR",'+
				'"user_insert": "CRIOS",'+
				'"fecha_insert": "2020-02-14 10:13:37",'+
				'"codigo_afiliado": "86712/26",'+
				'"apellidos_afiliado": "FRANCIONI MIGUEL",'+
				'"nombres_afiliado": ".",'+
				'"doc_afiliado": "DNI 11585637",'+
				'"evento_medico": null,'+
				'"fecha_prescripcion": "2020-01-31 00:00:00",'+
				'"diagnostico": "999",'+
				'"desc_diagnostico": "DIAGNOSTICO INDETERMINADO",'+
				'"prescriptor": "758415",'+
				'"nombre_prescriptor": "ZAPATA AGUILA BENJAMIN",'+
				'"prestador_dirige": "700125",'+
				'"nombre_prestador_dirige": "INST. GAMMA",'+
				'"prestador": "700125",'+
				'"nombre_prestador": "INST. GAMMA",'+
				'"consultorio": "1",'+
				'"nombre_consultorio": "CONSULTORIO PPAL PRESTADOR :700125",'+
				'"observaciones": "Prueba AP SF",'+
				'"mail": "test@mapplics.com",'+
				'"otros_mail": null,'+
				'"aca_agencia": null,'+
				'"tran_alta": null,'+
				'"tran_anulacion": null,'+
				'"ref_externa": null,'+
				'"urgente": null,'+
				'"afi_id": "131155",'+
				'"nro_sf": "156151sadas",'+
				'"nivel": "N1",'+
				'"clasificacion": "CUBIERTOS",'+
				'"tipo_ap_sf":"MEDICAMENTO",'+
				'"celula": "Celula 2",' +
				'"sla": "24",' +
				'"prestaciones": ['+
				'{'+
				'"apr_id": "1014010015",'+
				'"estado_prestacion": "C1-----A",'+
				'"estado_descripcion": "EN AUDITORIA",'+
				'"contexto": "Ambulatorio",'+
				'"cantidad": "1",'+
				'"prestacion": "13904",'+
				'"nombre_prestacion": "ILVICO N, COMP.X 20",'+
				'"tipo_prestacion": "N",'+
				'"troquel": "3758671",'+
				'"grupo_prestacion": null,'+
				'"pca_id": "74042384",'+
				'"alerta": null,'+
				'"texto_aclarativo": "NO REQUIERE OBSERV",'+
				'"alertas": ['+
				'{'+
				'"pca_pca_id": "74042384",'+
				'"aca_id": "16461179",'+
				'"cca_cca_id": null,'+
				'"control": "105",'+
				'"nombre_control": "MEDICAMENTO ACTIVO",'+
				'"funcion": "FCION_FRONT",'+
				'"texto_aclarativo": "El medicamento no existe o no está activo",'+
				'"nivel_auditoria": "105",'+
				'"estado_alerta": "C1EA-RAA",' +
				'"descripcion_estado": "RECHAZADO POR EL AUDITOR AL AFILIADO",' +
				'"nota_auditor": null,'+
				'"observaciones": null,'+
				'"fecha_generacion": "2020-02-14 10:13:38",'+
				'"fecha_lectura": null,'+ 
				'"auditor_lee": null,'+
				'"fecha_resolucion": null,'+
				'"auditor_resuelve": null'+
				'}'+
				']'+
				'}'+
				']'+
				'}'+
				'},'+
				'"meta": {'+
				'"allowed_includes": [],'+
				'"default_includes": []'+
				'}'+
				'}';
	}

	public static String getError(){
		return '{'+
				'"data": {'+
					'"error": true,'+
					'"errors": {'+
						'"user_insert": ['+
							'"El campo user insert es obligatorio."'+
						'],'+
						'"chk_material": ['+
							'"El campo chk material debe estar presente."'+
						'],'+
						'"chk_presupuesto": ['+
							'"El campo chk presupuesto debe estar presente."'+
						'],'+
						'"prestaciones.0.observaciones": ['+
							'"El campo prestaciones.0.observaciones debe estar presente."'+
						'],'+
						'"prestaciones.0.contexto": ['+
							'"El campo prestaciones.0.contexto debe estar presente."'+
						'],'+
						'"prestaciones.0.alerta": ['+
							'"El campo prestaciones.0.alerta debe estar presente."'+
						']'+
					'},'+
					'"errorType": "exception",'+
					'"httpCode": 422,'+
					'"message": "The given data was invalid.",'+
					'"debug_message": [],'+
					'"exception": "ValidationException",'+
					'"line": 126'+
				'}'+
			'}';
	}


}