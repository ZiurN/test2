public class WSDiagnosticoDelEventoEnviarMock {
	public static String getFound() {
		return 
			'{' +
				'"error": false,' +
				'"data": null,' +
				'"httpCode": 201,' +
				'"message": "Se cargó el diagnóstico.",' +
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
						'"fecha":[' +
                            '"El campo fecha es obligatorio."' +
                        ']' +
					'},' +
					'"errorType":"exception",' +
					'"httpCode": 422,' +
					'"message": "The given data was invalid."' +
				'}' +
			'}';
	}
}