public class WSLoteEnviarMailAgenciasMock  {

	public static String getFound(){
        return '{' + 
                    '"error": false,' + 
                    '"data": null,' + 
                    '"httpCode": 201,' + 
                    '"message": "Se envió correctamente el mail a las agencias.",' + 
                    '"meta": {' + 
                        '"allowed_includes": [],' + 
                        '"default_includes": []' + 
                    '}' + 
                '}';
	}

	public static String getError(){
        return '{' + 
                    '"data": {' + 
                        '"error": true,' + 
                        '"errors": [],' + 
                        '"errorType": "exception",' + 
                        '"httpCode": 404,' + 
                        '"message": "El lote solicitado es inválido.",' + 
                        '"debug_message": [],' + 
                        '"exception": "NotFoundHttpException",' + 
                        '"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php",' + 
                        '"line": 964' + 
                    '}' + 
                '}';
	}
}