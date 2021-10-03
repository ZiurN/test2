public class WSCaseValoracionMock {

    public static String getFound(){
        return '{'+
                  '"message": null,'+
                  '"data": ['+
                    '{'+
                      '"Tcc_Codigo": "BAS",'+
                      '"Importe": "10000",'+
                      '"Cantidad": "1",'+
                      '"Coeficiente": "1",'+
                      '"Coeficiente_General": "1",'+
                      '"Cga_Codigo": "",'+
                      '"Rcg_Codigo": "IND>31",'+
                      '"Dca_Dca_Id": "",'+
                      '"Dca_Dca_Id_Ajuste": "",'+
                      '"Nombre_Clausula": "Cuota Basica",'+
                      '"Nombre_Cat_Grupal": "",'+
                      '"Nombre_Regla_Adic": "Individuo Entre 26 Y 30 Años"'+
                    '},'+
					'{'+
                      '"Tcc_Codigo": "BAS",'+
                      '"Importe": "2500",'+
                      '"Cantidad": "1",'+
                      '"Coeficiente": "1",'+
                      '"Coeficiente_General": "1",'+
                      '"Cga_Codigo": "",'+
                      '"Rcg_Codigo": "IND>31",'+
                      '"Dca_Dca_Id": "",'+
                      '"Dca_Dca_Id_Ajuste": "",'+
                      '"Nombre_Clausula": "Cuota Basica",'+
                      '"Nombre_Cat_Grupal": "",'+
                      '"Nombre_Regla_Adic": "Individuo Entre 26 Y 30 Años"'+
                    '}'+
                  '],'+
                  '"meta": {'+
                    '"allowed_includes": [],'+
                    '"default_includes": []'+
                  '}'+
                '}';
    }
    
    public static String getErrorInvalidDate(){
        return '{'+
                    '"data": {'+
                        '"error": true,'+
                        '"errors": [],'+
                        '"errorType": "exception",'+
                        '"httpCode": 404,'+
                        '"message": "Formato de fecha hasta invalido",'+
                        '"debug_message": [],'+
                        '"exception": "NotFoundHttpException",'+
                        '"line": 964'+
                    '}'+
                '}';
    }
    
    public static String getErrorInvalidAfi(){
        return '{'+
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