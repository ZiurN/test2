public with sharing class WSEstadoDeCuentaMock {
    public static String getFound() {
        return
        '{'+
            '"data": {'+
                '"estado_cuenta": "VERDE"'+
            '},'+
            '"meta": {'+
                '"allowed_includes": [],'+
                '"default_includes": []'+
            '}'+
        '}';
    }

    public static String getError() { 
        return
        '{'+
            '"data": {'+
                '"error": true,'+
                '"errors": [],'+
                '"errorType": "exception",'+
                '"httpCode": 404,'+
                '"message": "El ID del Afiliado es inválido.",'+
                '"debug_message": [],'+
                '"exception": "NotFoundHttpException",'+
                '"line": 964'+
            '}'+
        '}';
    }
    
}