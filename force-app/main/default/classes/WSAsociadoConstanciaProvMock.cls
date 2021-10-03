public class WSAsociadoConstanciaProvMock  {

	public static String getFound(){
		return '{'+
					'"error": false,'+
					'"data": {'+
						'"link": "http://www.extranet.acasalud.com.ar/SF/CREDENCIAL_PROVISORIA_202637.pdf"'+
					'},'+
					'"httpCode": 201,'+
					'"message": "Se obtuvo la constancia provisoria.",'+
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
						'"errors": [],'+
						'"errorType": "exception",'+
						'"httpCode": 404,'+
						'"message": "Código de Afiliado inválido.",'+
						'"debug_message": [],'+
						'"exception": "NotFoundHttpException",'+
						'"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php",'+
						'"line": 964'+
					'}'+
				'}';
	}
}