@isTest
public class WSCaseAPGenerarCentroMock {

    public static String getFound(Id caseId){
		return '{'+
				'"data": {'+
				'"ap": [{'+
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
				'"nro_sf": "'+caseId+'",'+
				'"nivel": "N1",'+
				'"celula": "Celula 2",' +
				'"clasificacion": "CUBIERTOS",'+
				'"tipo_ap_sf":"MEDICAMENTO",'+
				'"prestaciones": ['+
				'{'+
				'"apr_id": "1014010015",'+
				'"estado_prestacion": "C1-----A",'+
				'"estado_descripcion": "EN AUDITORIA",'+
				'"contexto": "A",'+
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
				'}]'+
				'},'+
				'"meta": {'+
				'"allowed_includes": [],'+
				'"default_includes": []'+
				'}'+
				'}';
	}

	    public static String getFoundWithEM(Id caseId){
		return '{'+
				'"data": {'+
				'"ap": [{'+
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
				'"nro_sf": "'+caseId+'",'+
				'"nivel": "N1",'+
				'"celula": "Celula 2",' +
				'"clasificacion": "CUBIERTOS",'+
				'"tipo_ap_sf":"MEDICAMENTO",'+
				'"estado_em":"AUTORIZADO",'+
				'"prestaciones": ['+
				'{'+
				'"apr_id": "1014010015",'+
				'"estado_prestacion": "C1-----A",'+
				'"estado_descripcion": "EN AUDITORIA",'+
				'"contexto": "A",'+
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
				'}]'+
				'},'+
				'"meta": {'+
				'"allowed_includes": [],'+
				'"default_includes": []'+
				'}'+
				'}';
	}


	    public static String getFoundPresupuesto(Id caseId){
		return '{'+
				'"data": {'+
				'"ap": [{'+
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
				'"nro_sf": "'+caseId+'",'+
				'"nivel": "N1",'+
				'"celula": "Celula 2",' +
				'"clasificacion": "CUBIERTOS",'+
				'"tipo_ap_sf":"MEDICAMENTO",'+
				'"prestaciones": ['+
				'{'+
				'"apr_id": "1014010015",'+
				'"estado_prestacion": "C1-----A",'+
				'"estado_descripcion": "EN AUDITORIA",'+
				'"contexto": "A",'+
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
				'},'+
				'{'+
  '"apr_id": "1014010015",'+
  '"estado_prestacion": "C1-----A",'+
  '"estado_descripcion": "EN AUDITORIA",'+
  '"contexto": "A",'+
  '"cantidad": "1",'+
  '"prestacion": "02503102",'+
  '"nombre_prestacion": "CODIGO PARA PRESUPUESTOS FRONT",'+
  '"tipo_prestacion": "N",'+
  '"troquel": null,'+
  '"grupo_prestacion": null,'+
  '"pca_id": "74042957",'+
  '"alerta": null,'+
  '"texto_aclarativo": "ALERTA SAM",'+
  '"importe_plan_sys": "0",'+
  '"importe_plan_aud": "0",'+
  '"importe_convenio_sys": "0",'+
  '"importe_convenio_aud": "0",'+
  '"importe_cargo_al_socio_sys": "0",'+
  '"importe_cargo_al_socio_aud": "0",'+
  '"importe_rein_sys": "0",'+
  '"importe_rein_aud": "0",'+
  '"alertas": ['+
      '{'+
          '"pca_pca_id": "74042957",'+
          '"aca_id": "16463926",'+
          '"cca_cca_id": null,'+
          '"control": "210",'+
          '"nombre_control": "PRESTACION CUBIERTA",'+
          '"funcion": "FCION_FRONT",'+
          '"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",'+
          '"nivel_auditoria": "120",'+
          '"estado_alerta": "C1-----A",'+
          '"descripcion_estado": "EN AUDITORIA",'+
          '"nota_auditor": null,'+
          '"observaciones": null,'+
          '"fecha_generacion": "2020-03-26 16:58:41",'+
          '"fecha_lectura": null,'+
          '"auditor_lee": null,'+
          '"fecha_resolucion": null,'+
          '"auditor_resuelve": null'+
      '},'+
      '{'+
          '"pca_pca_id": "74042957",'+
          '"aca_id": "16463927",'+
          '"cca_cca_id": null,'+
          '"control": "PRESU_F",'+
          '"nombre_control": "CONTROL PRESUPUESTOS FRONT",'+
          '"funcion": "FCION_FRONT",'+
          '"texto_aclarativo": "Requiere Presupuesto",'+
          '"nivel_auditoria": "190",'+
          '"estado_alerta": "C1-----A",'+
          '"descripcion_estado": "EN AUDITORIA",'+
          '"nota_auditor": null,'+
          '"observaciones": null,'+
          '"fecha_generacion": "2020-03-26 16:58:41",'+
          '"fecha_lectura": null,'+
          '"auditor_lee": null,'+
          '"fecha_resolucion": null,'+
          '"auditor_resuelve": null'+
      '},'+
      '{'+
          '"pca_pca_id": "74042957",'+
          '"aca_id": "16463929",'+
          '"cca_cca_id": "74105985",'+
          '"control": "210",'+
          '"nombre_control": "PRESTACION CUBIERTA",'+
          '"funcion": "FCION_FRONT",'+
          '"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",'+
          '"nivel_auditoria": "120",'+
          '"estado_alerta": "C1-----A",'+
          '"descripcion_estado": "EN AUDITORIA",'+
          '"nota_auditor": null,'+
          '"observaciones": null,'+
          '"fecha_generacion": "2020-03-26 16:58:42",'+
          '"fecha_lectura": null,'+
          '"auditor_lee": null,'+
          '"fecha_resolucion": null,'+
          '"auditor_resuelve": null'+
      '}'+
  ']'+
'}'+
				']'+
				'}]'+
				'},'+
				'"meta": {'+
				'"allowed_includes": [],'+
				'"default_includes": []'+
				'}'+
				'}';
	}

	public static String getFoundMaterial(Id caseId){
		return '{'+
				'"data": {'+
				'"ap": [{'+
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
				'"nro_sf": "'+caseId+'",'+
				'"nivel": "N1",'+
				'"celula": "Celula 2",' +
				'"sla": "24",' +
				'"clasificacion": "CUBIERTOS",'+
				'"tipo_ap_sf":"MEDICAMENTO",'+
				'"prestaciones": ['+
				'{'+
				'"apr_id": "1014010015",'+
				'"estado_prestacion": "C1-----A",'+
				'"estado_descripcion": "EN AUDITORIA",'+
				'"contexto": "A",'+
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
				'},'+
				'{'+
'  "apr_id": "1014010632",'+
'  "fecha": "2020-03-02 00:00:00",'+
'  "conexion": "CX--MOST",'+
'  "nombre_conexion": "Mostrador",'+
'  "delegacion": "650098",'+
'  "nombre_delegacion": "650098_ACA SALUD SUC. ROSARIO",'+
'  "fecha_probable": "2020-03-02 00:00:00",'+
'  "estado": "CA-----A",'+
'  "nombre_estado": "CENTRO AUTORIZADOR",'+
'  "user_insert": "CRIOS",'+
'  "fecha_insert": "2020-03-26 16:17:45",'+
'  "codigo_afiliado": "2722/12",'+
'  "apellidos_afiliado": "PUSSETTO CELESTINO",'+
'  "nombres_afiliado": ".",'+
'  "doc_afiliado": "DNI 06583495",'+
'  "evento_medico": null,'+
'  "fecha_prescripcion": "2020-01-31 00:00:00",'+
'  "diagnostico": "999",'+
'  "desc_diagnostico": "DIAGNOSTICO INDETERMINADO",'+
'  "prescriptor": "758415",'+
'  "nombre_prescriptor": "ZAPATA AGUILA BENJAMIN",'+
'  "prestador_dirige": null,'+
'  "nombre_prestador_dirige": null,'+
'  "prestador": null,'+
'  "nombre_prestador": null,'+
'  "consultorio": null,'+
'  "nombre_consultorio": null,'+
'  "observaciones": null,'+
'  "mail": null,'+
'  "otros_mail": null,'+
'  "aca_agencia": null,'+
'  "tran_alta": null,'+
'  "tran_anulacion": null,'+
'  "ref_externa": null,'+
'  "urgente": null,'+
'  "afi_id": "133234",'+
'  "nro_sf": null,'+
'  "nivel": "N1",'+
'  "celula": "Celula 1",' +
'  "sla": "48",' +
'  "clasificacion": "ALTA COMPLEJIDAD",'+
'  "tipo_ap_sf": "PRESTACION",'+
'  "ap_material": "V",'+
'  "ap_presupuesto": "F",'+
'  "prestaciones": ['+
'      {'+
'          "apr_id": "1014010632",'+
'          "estado_prestacion": "C1-----A",'+
'          "estado_descripcion": "EN AUDITORIA",'+
'          "contexto": "A",'+
'          "cantidad": "1",'+
'          "prestacion": "707008150",'+
'          "nombre_prestacion": "PRODUCTO SIN CODIFICAR CIRUGIA GENERAL (NACIONAL)",'+
'          "tipo_prestacion": "N",'+
'          "troquel": null,'+
'          "grupo_prestacion": null,'+
'          "pca_id": "74042955",'+
'          "alerta": null,'+
'          "texto_aclarativo": null,'+
'          "importe_plan_sys": "0",'+
'          "importe_plan_aud": "0",'+
'          "importe_convenio_sys": "0",'+
'          "importe_convenio_aud": "0",'+
'          "importe_cargo_al_socio_sys": "0",'+
'          "importe_cargo_al_socio_aud": "0",'+
'          "importe_rein_sys": "0",'+
'          "importe_rein_aud": "0",'+
'          "alertas": ['+
'              {'+
'                  "pca_pca_id": "74042955",'+
'                  "aca_id": "16463917",'+
'                  "cca_cca_id": null,'+
'                  "control": "210",'+
'                  "nombre_control": "PRESTACION CUBIERTA",'+
'                  "funcion": "FCION_FRONT",'+
'                  "texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",'+
'                  "nivel_auditoria": "120",'+
'                  "estado_alerta": "C1-----A",'+
'                  "descripcion_estado": "EN AUDITORIA",'+
'                  "nota_auditor": null,'+
'                  "observaciones": null,'+
'                  "fecha_generacion": "2020-03-26 16:17:45",'+
'                  "fecha_lectura": null,'+
'                  "auditor_lee": null,'+
'                  "fecha_resolucion": null,'+
'                  "auditor_resuelve": null'+
'              },'+
'              {'+
'                  "pca_pca_id": "74042955",'+
'                  "aca_id": "16463918",'+
'                  "cca_cca_id": null,'+
'                  "control": "CPRA",'+
'                  "nombre_control": "REQUIERE AUDITORIA COMPRAS TECNICAS",'+
'                  "funcion": "CPRAS_TECNI",'+
'                  "texto_aclarativo": "PENDIENTE COMPRAS TECNICAS",'+
'                  "nivel_auditoria": "204",'+
'                  "estado_alerta": "C1-----A",'+
'                  "descripcion_estado": "EN AUDITORIA",'+
'                  "nota_auditor": null,'+
'                  "observaciones": null,'+
'                  "fecha_generacion": "2020-03-26 16:17:45",'+
'                  "fecha_lectura": null,'+
'                  "auditor_lee": null,'+
'                  "fecha_resolucion": null,'+
'                  "auditor_resuelve": null'+
'              },'+
'              {'+
'                  "pca_pca_id": "74042955",'+
'                  "aca_id": "16463919",'+
'                  "cca_cca_id": null,'+
'                  "control": "AUM",'+
'                  "nombre_control": "REQUIERE AUDITORIA MEDICA",'+
'                  "funcion": "AM",'+
'                  "texto_aclarativo": "REQUIERE AUDITORIA MEDICA",'+
'                  "nivel_auditoria": "199",'+
'                  "estado_alerta": "C1-----A",'+
'                  "descripcion_estado": "EN AUDITORIA",'+
'                  "nota_auditor": null,'+
'                  "observaciones": null,'+
'                  "fecha_generacion": "2020-03-26 16:17:45",'+
'                  "fecha_lectura": null,'+
'                  "auditor_lee": null,'+
'                  "fecha_resolucion": null,'+
'                  "auditor_resuelve": null'+
'              },'+
'              {'+
'                  "pca_pca_id": "74042955",'+
'                  "aca_id": "16463921",'+
'                  "cca_cca_id": "74105982",'+
'                  "control": "210",'+
'                  "nombre_control": "PRESTACION CUBIERTA",'+
'                  "funcion": "FCION_FRONT",'+
'                  "texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",'+
'                  "nivel_auditoria": "120",'+
'                  "estado_alerta": "C1-----A",'+
'                  "descripcion_estado": "EN AUDITORIA",'+
'                  "nota_auditor": null,'+
'                  "observaciones": null,'+
'                  "fecha_generacion": "2020-03-26 16:17:46",'+
'                  "fecha_lectura": null,'+
'                  "auditor_lee": null,'+
'                  "fecha_resolucion": null,'+
'                  "auditor_resuelve": null'+
'              }'+
'          ]'+
'      }'+
'  ]'+
'}'+
				']'+
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

	public static string getArchivos(){
		return '{'+
			'"error": false,'+
			'"data": null,'+
			'"httpCode": 200,'+
			'"message": "El archivo fue cargado satisfactoriamente.",'+
			'"meta": {'+
			'"allowed_includes": [],'+
			'"default_includes": []'+
			'}'+
			'}';
	}
}