/**
 * Created by xappia on 13/2/20.
 */

public with sharing class WSCaseAPEmitirOrdenMock {

    public static String getFound(){
        return
		'{' +
		    '"error": false,' +
		    '"data": {' +
		        '"ap": {' +
				    '"apr_id": "1014009998",'+
				    '"fecha": "2020-02-02 00:00:00",'+
				    '"conexion": "CX--MOST",'+
				    '"nombre_conexion": "Mostrador",'+
				    '"delegacion": "650098",'+
				    '"nombre_delegacion": "650098_ACA SALUD SUC. ROSARIO",'+
				    '"fecha_probable": "2019-02-02 00:00:00",'+
				    '"estado": "CA-----E",'+
				    '"nombre_estado": "ORDEN EMITIDA",'+
				    '"user_insert": "CRIOS",'+
				    '"fecha_insert": "2020-02-13 15:45:28",'+
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
		            '"ap_material": "F",' +
		            '"ap_presupuesto": "F",' +
		            '"ordenes": [' +
		                '{' +
		                    '"apr_apr_id": "1014010087",' +
		                    '"oca_id": "3099007",' +
		                    '"link_orden": "http://www.extranet.acasalud.com.ar/SF/3099007.pdf"' +
		                '}' +
		            ']' +
		        '}' +
		    '},' +
		    '"httpCode": 200,' +
		    '"message": "Se generó correctamente la orden.",' +
		    '"meta": {' +
		        '"allowed_includes": [],' +
		        '"default_includes": []' +
		    '}' +
		'}';
    }

    public static String getError(){
        return '{'+
                '    "data": {'+
                '        "error": true,'+
                '        "errors": {'+
                '            "message": "No se pudo generar la orden. Por favor, intente nuevamente. NO SE PUEDE GENERAR UNA ORDEN EN ESTADO ANULADA",'+
                '            "debug_message": ""'+
                '        },'+
                '        "data": null,'+
                '        "httpCode": 500,'+
                '        "message": "No se pudo generar la orden. Por favor, intente nuevamente. NO SE PUEDE GENERAR UNA ORDEN EN ESTADO ANULADA"'+
                '    }'+
                '}';
    }

}