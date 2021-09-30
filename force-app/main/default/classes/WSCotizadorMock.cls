public with sharing class WSCotizadorMock {

    public static String getFound(){
        return '{'+
                '"data": {'+
                '"nroCotizacion": "0000046033",'+
                '"precioTitular": 3192.95,'+
                '"precioConyuge": 2313.67,'+
                '"precioPrimerHijoMenor21": null,'+
                '"precioSegundoHijoMenor21": null,'+
                '"precioTercerHijoOMasMenores21": null,'+
                '"precioHijosEntre21y25": 2553.21,'+
                '"precioTotal": 8059.84,'+
                '"deduccionAportes": 32500,'+
                '"deduccionAportesMonotributo": null,'+
                '"bonificacionEspecial6Meses": 805.98,'+
                '"descuentoPorPagoDebitoCBU": 1208.98,'+
                '"descuentoPorPagoTarjeta": null,'+
                '"diferenciaAPagar": 2794.88,'+
                '"totalCapitas": 4,'+
                '"idPersona": "25436"'+
                '},'+
                '"meta": {'+
                '"allowed_includes": [],'+
                '"default_includes": []'+
                '}'+
                '}';
    }

    public static String getFoundCorporativa(){
            return '{'+
                        '"error": false,'+
                            '"data": {'+
                                '"archivo": "data:text/plain;base64,cHJ1ZWJhIGRlIGVudmlvIGFyY2hpdm8gYmFzZTY0",'+
                                '"id_cotizacion": "310606"'+
                            '},'+
                        '"httpCode": 200,'+
                        '"message": "La cotización fue realizada con éxito.",'+
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
                '"errors": {'+
                '"tipoDniId": ['+
                '"El campo tipo dni id es obligatorio."'+
                ']'+
                '},'+
                '"errorType": "exception",'+
                '"httpCode": 422,'+
                '"message": "The given data was invalid.",'+
                '"debug_message": [],'+
                '"exception": "ValidationException",'+
                '"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Http\\FormRequest.php",'+
                '"line": 126'+
                '}'+
                '}';
    }

    public static String getErrorCorporativa(){
       return '{'+
            '"data": {'+
                '"error": true,'+
                '"errors": {'+
                    '"transaccionId": ['+
                        '"transaccion id debe ser numérico."'+
                    ']'+
                '},'+
                '"errorType": "exception",'+
                '"httpCode": 422,'+
                '"message": "The given data was invalid.",'+
                '"debug_message": [],'+
                '"exception": "ValidationException",'+
            '}'+
        '}';
    }

}