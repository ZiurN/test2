@isTest 
public class WSCaseAPRevertirOrdenMock {

	public static String getFound() {
		return
			'{' +
			  '"error": false,' +
			  '"data": {' +
				'"ap": {' +
				  '"apr_id": "1017985413",' +
				  '"fecha": "2020-10-21 00:00:00",' +
				  '"conexion": "CX--MOST",' +
				  '"nombre_conexion": "Mostrador",' +
				  '"delegacion": "650078",' +
				  '"nombre_delegacion": "650078_ AG. CENTRO DE CONTACTO",' +
				  '"fecha_probable": "2020-10-21 00:00:00",' +
				  '"estado": "CA-----G",' +
				  '"nombre_estado": "GENERADA",' +
				  '"user_insert": "CRIOS",' +
				  '"fecha_insert": "2020-10-21 15:07:56",' +
				  '"codigo_afiliado": "100075/16",' +
				  '"apellidos_afiliado": "ALDECOA",' +
				  '"nombres_afiliado": "EMILIANO",' +
				  '"doc_afiliado": "DNI 33123547",' +
				  '"evento_medico": null,' +
				  '"fecha_prescripcion": "2020-10-15 00:00:00",' +
				  '"diagnostico": "K08",' +
				  '"desc_diagnostico": "OTROS TRASTORNOS DE LOS DIENTES Y DE SUS ESTRUCTURAS DE SOST",' +
				  '"prescriptor": "707595",' +
				  '"nombre_prescriptor": "ALBICORO DALMACIO ANGEL",' +
				  '"prestador_dirige": "797465",' +
				  '"nombre_prestador_dirige": "KAIAL MARIA CRISTINA",' +
				  '"prestador": "797465",' +
				  '"nombre_prestador": "KAIAL MARIA CRISTINA",' +
				  '"consultorio": "1",' +
				  '"nombre_consultorio": "KAIAL MARIA CRISTINA - IN OUT MEDICAL",' +
				  '"observaciones": "material",' +
				  '"mail": null,' +
				  '"otros_mail": null,' +
				  '"aca_agencia": null,' +
				  '"tran_alta": null,' +
				  '"tran_anulacion": null,' +
				  '"ref_externa": null,' +
				  '"urgente": null,' +
				  '"afi_id": "153415",' +
				  '"aca_nro_sf": "5008A000006yhzgQAA",' +
				  '"nro_sf": "5008A000006yhzgQAA",' +
				  '"nivel": "N3",' +
				  '"clasificacion": "ALTA COMPLEJIDAD",' +
				  '"tipo_ap_sf": "PRESTACION",' +
				  '"ap_material": "V",' +
				  '"ap_presupuesto": "F",' +
				  '"imp_presu": null,' +
				  '"celula": null,' +
				  '"sla": "16",' +
				  '"prestaciones": [' +
					'{' +
					  '"apr_id": "1017985413",' +
					  '"estado_prestacion": "C1-----G",' +
					  '"estado_descripcion": "GENERADO",' +
					  '"contexto": "A",' +
					  '"cantidad": "1",' +
					  '"prestacion": "707008150",' +
					  '"nombre_prestacion": "PRODUCTO SIN CODIFICAR CIRUGIA GENERAL (NACIONAL)",' +
					  '"tipo_prestacion": "N",' +
					  '"troquel": null,' +
					  '"grupo_prestacion": null,' +
					  '"pca_id": "90968106",' +
					  '"alerta": null,' +
					  '"texto_aclarativo": null,' +
					  '"importe_plan_sys": "0",' +
					  '"importe_plan_aud": null,' +
					  '"importe_convenio_sys": "0",' +
					  '"importe_convenio_aud": null,' +
					  '"importe_cargo_al_socio_sys": "0",' +
					  '"importe_cargo_al_socio_aud": null,' +
					  '"importe_rein_sys": "0",' +
					  '"importe_rein_aud": null' +
					'}' +
				  ']' +
				'}' +
			  '},' +
			  '"httpCode": 200,' +
			  '"message": "La orden fue revertida exitosamente.",' +
			  '"meta": {' +
				'"allowed_includes": [],' +
				'"default_includes": []' +
			  '}' +
			'}';
	}

	public static String getError() {
		return
			'{' +
				'"data": {' +
					'"error": true,' +
					'"errors": [],' +
					'"errorType": "exception",' +
					'"httpCode": 404,' +
					'"message": "La autorización solicitada es inválida.",' +
					'"debug_message": [],' +
					'"exception": "NotFoundHttpException",' +
					'"line": 964' +
				'}' +
			'}';
	}
}