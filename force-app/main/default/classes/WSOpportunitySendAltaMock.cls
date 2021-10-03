public class WSOpportunitySendAltaMock  {

	public static String getFound(String oppId) {
		return 
			'{' +
			  '"error": false,' +
			  '"data": [{' +
				'"sf_id": "'+oppId+'",' +
				'"solafi_id": "724171",' +
				'"estado_sol": "COMPLETA",' +
				'"estado_dj": "NUEVA",' +
				'"codigo_as": null,' +
				'"tipo_asoc": "DSATIT",' +
				'"notas": [' +
				']' +
			  '}],' +
			  '"httpCode": 200,' +
			  '"message": "Se generó satisfactoriamente la solicitud de alta",' +
			  '"meta": {' +
				'"allowed_includes": [],' +
				'"default_includes": []' +
			  '}' +
			'}';
	}

	public String getFoundWithSFIdNota(String idNota, String oppId) {
		return 
			'{' +
			  '"error": false,' +
			  '"data": [{' +
				'"sf_id": "'+oppId+'",' +
				'"solafi_id": "724171",' +
				'"estado_sol": "COMPLETA",' +
				'"estado_dj": "NUEVA",' +
				'"codigo_as": null,' +
				'"tipo_asoc": "DSATIT",' +
				'"notas": [' +
				  '{' +
					'"nota_id": "128805",' +
					'"sf_id": "'+ idNota +'",' +
					'"texto_nota": "Ejemplo"' +
				  '}' +
				']' +
			  '}],' +
			  '"httpCode": 200,' +
			  '"message": "Se generó satisfactoriamente la solicitud de alta",' +
			  '"meta": {' +
				'"allowed_includes": [],' +
				'"default_includes": []' +
			  '}' +
			'}';
	}

	public static String getFoundIncomplete(String oppId) {
		return 
			'{' +
			    '"error": false,' +
			    '"data": [{' +
			        '"sf_id": "'+oppId+'",' +
			        '"solafi_id": "724354",' +
			        '"estado_sol": "INCOMPLETA",' +
			        '"estado_dj": "NUEVA",' +
			        '"codigo_as": null,' +
			        '"tipo_asoc": "DSATIT",' +
			        '"notas": []' +
			    '}],' +
			    '"httpCode": 200,' +
			    '"message": "Se actualizó la solicitud de alta. Error al validar 20012: CUIT/CUIL no se corresponde con el nro. documento",' +
			    '"meta": {' +
			        '"allowed_includes": [],' +
			        '"default_includes": []' +
			    '}' +
			'}';
	}

		public static String getFoundTransformada(String oppId) {
		return 
			'{' +
			    '"error": false,' +
			    '"data": [{' +
			        '"sf_id": "'+oppId+'",' +
			        '"solafi_id": "724354",' +
			        '"estado_sol": "TRANSFORMADA",' +
			        '"estado_dj": "NUEVA",' +
			        '"codigo_as": "123456/12",' +
			        '"tipo_asoc": "DSATIT",' +
			        '"notas": []' +
			    '}],' +
			    '"httpCode": 200,' +
			    '"message": "Se actualizó la solicitud de alta",' +
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
					'"errors": {' +
						'"Avalian - Solicitud de ingreso y DDJJ completa.pdf": [' +
							'"Falta archivo adjunto: Avalian - Solicitud de ingreso y DDJJ completa.pdf"' +
						']'+
					'},' +
					'"errorType": "exception",' +
					'"httpCode": 422,' +
					'"message": "The given data was invalid.",' +
					'"debug_message": [],' +
					'"exception": "ValidationException",' +
					'"line": 126' +
				'}' +
			'}';
	}
}