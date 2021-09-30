public class WSCaseReintegroReasignarMock  {

	public static String getFound(){
		return '{'+
				  '"error": false,'+
				  '"data": {'+
					'"id_reintegro": 553276,'+
					'"id_lote": 999999'+
				  '},'+
				  '"httpCode": 200,'+
				  '"message": "Se ha reasignado correctamente el reintegro.",'+
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
					'"message": "El reintegro solicitado es inválido.",'+
					'"debug_message": [],'+
					'"exception": "NotFoundHttpException",'+
					'"line": 964'+
				'}'+
			'}';
	}

}