public class WSLotePasajeAIFMock  {

	public static String getFound(){
		return '{'+
				  '"error": false,'+
				  '"data": {'+
					  '"lote": {'+
						  '"lr_id": 5406,'+
						  '"estado": "F",'+
						  '"link_if": "http://www.extranet.acasalud.com.ar/SF/IF_5406.pdf"'+
					  '}'+
				  '},'+
				  '"httpCode": 201,'+
				  '"message": "Se realizó correctamente el pasaje If.",'+
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
					  '"message": "El lote solicitado es inválido.",'+
					  '"debug_message": [],'+
					  '"exception": "NotFoundHttpException",'+
					  '"line": 964'+
				  '}'+
				'}';
	}
}