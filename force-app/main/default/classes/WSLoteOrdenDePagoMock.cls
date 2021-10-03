public class WSLoteOrdenDePagoMock {

	public static String getFound(){
		return
        '{' + 
            '"data": [' + 
                '{' + 
                    '"lote": "5381",' + 
                    '"opr_id": "395011",' + 
                    '"nombre_destinatario": "SEEWALD, NERINA ANAHI",' + 
                    '"estado": "REEF---F",' + 
                    '"nombre_estado": "INTERFACE"' + 
                '},' + 
                '{' + 
                    '"lote": "5381",' + 
                    '"opr_id": "395010",' + 
                    '"nombre_destinatario": "RIOS, ANA CAROLINA",' + 
                    '"estado": "REEF---F",' + 
                    '"nombre_estado": "INTERFACE"' + 
                '},' + 
                '{' + 
                    '"lote": "5381",' + 
                    '"opr_id": "395009",' + 
                    '"nombre_destinatario": "VILLANUEVA, CARLOS",' + 
                    '"estado": "REEF---F",' + 
                    '"nombre_estado": "INTERFACE"' + 
                '},' + 
                '{' + 
                    '"lote": "5381",' + 
                    '"opr_id": "395008",' + 
                    '"nombre_destinatario": "ROBERTS GUILLERMO ROY  ",' + 
                    '"estado": "REEF---F",' + 
                    '"nombre_estado": "INTERFACE"' + 
                '},' + 
                '{' + 
                    '"lote": "5381",' + 
                    '"opr_id": "395007",' + 
                    '"nombre_destinatario": "RIOS, ANA CAROLINA",' + 
                    '"estado": "REEF---F",' + 
                    '"nombre_estado": "INTERFACE"' + 
                '},' + 
                '{' + 
                    '"lote": "5381",' + 
                    '"opr_id": "395006",' + 
                    '"nombre_destinatario": "MOHANA, ISABEL",' + 
                    '"estado": "REEF---F",' + 
                    '"nombre_estado": "INTERFACE"' + 
                '},' + 
                '{' + 
                    '"lote": "5381",' + 
                    '"opr_id": "395005",' + 
                    '"nombre_destinatario": "BIANCHI, ADELA",' + 
                    '"estado": "REEF---F",' + 
                    '"nombre_estado": "INTERFACE"' + 
                '}' + 
            '],' + 
            '"meta": {' + 
                '"allowed_filters": [],' + 
                '"allowed_sorts": [],' + 
                '"allowed_appends": [],' + 
                '"allowed_fields": [],' + 
                '"allowed_includes": [],' + 
                '"default_includes": [],' + 
                '"optional_get_vars": {' + 
                    '"sortBy": [],' + 
                    '"sortOrder": [' + 
                        '"asc",' + 
                        '"desc"' + 
                    '],' + 
                    '"pageSize": {' + 
                        '"0": "?pageSize=0",' + 
                        '"15": "?pageSize=15",' + 
                        '"50": "?pageSize=50",' + 
                        '"100": "?pageSize=100"' + 
                    '}' + 
                '}' + 
            '}' + 
        '}';
	}
	public static String getError() {
		return
        '{' +
            '"data": {'+
                '"error": true,'+
                '"errors": [],'+
                '"errorType": "exception",'+
                '"httpCode": 404,'+
                '"message": "El lote solicitado es inválido.",'+
                '"debug_message": [],'+
                '"exception": "NotFoundHttpException",'+
                '"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php",'+
                '"line": 964'+
            '}' +
        '}';
	}
}