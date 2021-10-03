public class WSLoteImprimirIFMock  {

	public static String getFound(){
		return '{'+
				'"error": false,'+
				'"data": {'+
				  '"lote": {'+
					'"lr_id": 5397,'+
					'"estado": "A",'+
					'"link_preliq": "http://www.extranet.acasalud.com.ar/SF/PRELIQ_5397.pdf"'+
				  '}'+
				'},'+
				'"httpCode": 201,'+
				'"message": "Se generó el reporte de la preliquidación correctamente.",'+
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
					  '"message": "El lote solicitado es invalido.",'+
					  '"debug_message": [],'+
					  '"exception": "NotFoundHttpException",'+
					  '"line": 964'+
				  '}'+
				'}';
	}

}