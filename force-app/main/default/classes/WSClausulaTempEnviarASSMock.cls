public with sharing class WSClausulaTempEnviarASSMock {
    public static String getFound(){
        return '{'+
                    '"error": false,'+
                    '"data": {'+
                        '"acta_id": 47518'+
                    '},'+
                    '"httpCode": 200,'+
                    '"message": "Se ha asignado correctamente la cláusula temporaria PMI.",'+
                    '"meta": {'+
                        '"allowed_includes": [],'+
                        '"default_includes": []'+
                    '}'+
                '}';
	}

	public static String getError(){
		return '"data": {'+
                    '"error": true,'+
                    '"errors": {'+
                        '"codigo_afiliado": ['+
                            '"codigo afiliado es inválido."'+
                        ']'+
                    '},'+
                    '"errorType": "exception",'+
                    '"httpCode": 422,'+
                    '"message": "The given data was invalid.",'+
                    '"debug_message": [],'+
                    '"exception": "ValidationException",'+
                    '"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Http\\FormRequest.php",'+
                    '"line": 126'+
                '}';
	}
}