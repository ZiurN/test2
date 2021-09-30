public class WSArchivosCargaMock  {

	public static String getFound(){
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

	public static String getError(){
		return '{'+
					'"data": {'+
						'"error": true,'+
						'"errors": {'+
							'"evento_medico.id": ['+
								'"El id ingresado no coincide con un evento medico valido."'+
							']'+
						'},'+
						'"errorType": "exception",'+
						'"httpCode": 422,'+
						'"message": "The given data was invalid.",'+
						'"debug_message": [],'+
						'"exception": "ValidationException",'+
						'"line": 71'+
					'}'+
				'}';
	}
}