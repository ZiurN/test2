public class WSLoteEnviarASSMock  {

	public static String getFound(){
		return '{'+
				'"error": false,'+
				'"data": {'+
					'"lote_id": 5400,'+
					'"estado": "A"'+
				'},'+
				'"httpCode": 201,'+
				'"message": "Se generó el lote correctamente.",'+
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
							'"usuario": ['+
								'"usuario es invalido."'+
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