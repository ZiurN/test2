public with sharing class WSAsociadoScoreMock {
    public static String getFound() {
        return
        '{'+
            '"data": {'+
                '"indice_rentabilidad": "-886034.17",'+
                '"edad_maxima": "44",'+
                '"evento_medico": "F",'+
                '"color": "ROJO"'+
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
                '"message": "Código de Afiliado inválido.",'+
                '"debug_message": [],'+
                '"exception": "NotFoundHttpException",'+
                '"line": 964'+
            '}'+
        '}';
    }
    
}