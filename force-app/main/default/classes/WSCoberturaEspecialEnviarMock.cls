public class WSCoberturaEspecialEnviarMock  {
	public static String getFound() {
		return 
			'{' +
				'"error": false,' +
				'"data": {' +
					'"id_cobertura": "191769"' +
				'},' +
				'"httpCode": 201,' +
				'"message": "Se cargó correctamente la cobertura especial.",' +
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
						'"message": "ERROR AL CARGAR COBERTURA. Hay solapamiento de rangos:",' +
						'"debug_message": {' +
							'"ERROR AL CARGAR COBERTURA ORA-20051": [' +
								'"Hay solapamiento de rangos:"' +
							']' +
						'}' +
					'},' +
					'"data": null,' +
					'"httpCode": 400,' +
					'"message": "No se pudo cargar la cobertura especial."' +
				'}' +
			  '}';
	}
}