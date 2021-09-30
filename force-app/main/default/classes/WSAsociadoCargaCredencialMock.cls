@IsTest
public class WSAsociadoCargaCredencialMock  {
	public static String getFound() {
		return 
			'{' +
				'"error": false,' +
				'"data": null,' +
				'"httpCode": 201,' +
				'"message": "Se ha cargado la entrega de credencial al socio.",' +
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
						'"id_oca": [' +
							'"id oca es inválido."' +
						']' +
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