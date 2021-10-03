public class WSAsociadoGetCuponDePagoMock {
    public static String getFound(){
        return
                '{'+
                    '"error": false,'+
                    '"data": {'+
                        '"link": "http://www.extranet.acasalud.com.ar/SF/21406301.pdf"'+
                    '},'+
                    '"httpCode": 200,'+
                    '"message": "Se genero satisfactoriamente el cupón",'+
                    '"meta": {'+
                    '"allowed_includes": [],'+
                    '"default_includes": []'+
            '}'+
        '}';
    }

    public static String getError() {
        return '{'+
            '"data": {'+
            '"error": true,'+
            '"errors": {'+
            '"deuda": ['+
            '    "El campo deuda es obligatorio."'+
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
}