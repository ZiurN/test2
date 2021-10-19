@isTest
public class WSCotizadorCorporativaPDFMock {
	public static String getFound() {
		return 
			'{'+
			'    \"error\": false,'+
			'    \"data\": {'+
			'        \"base64\": \"data:application/pdf;base64,JVBERi0xL=\"'+
			'    },'+
			'    \"httpCode\": 200,'+
			'    \"message\": \"Se obtuvo el pdf.\"'+
			'}';
	}

	public static String getError() {
		return 
			'{' +
			'    "data": {' +
			'        "error": true,' +
			'        "errors": [],' +
			'        "errorType": "exception",' +
			'        "httpCode": 404,' +
			'        "message": "El número de cotización solicitado es inválido.",' +
			'        "debug_message": [],' +
			'        "exception": "NotFoundHttpException",' +
			'        "line": 964' +
			'    }' +
			'}';
	}
}