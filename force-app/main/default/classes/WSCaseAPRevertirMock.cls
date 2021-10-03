public class WSCaseAPRevertirMock {

    //public static String getFound(){
        //return '{'+
                    //'"error": false,'+
                    //'"data": null,'+
                    //'"httpCode": 200,'+
                    //'"message": "REVIERTE CENTRO AUTORIZADOR OK",'+
                    //'"meta": {'+
                        //'"allowed_includes": [],'+
                        //'"default_includes": []'+
                    //'}'+
                //'}';
    //}

    public static String getError(){
        return '{'+
                    '"data": {'+
                    '"error": true,'+
                    '"errors": {'+
                    '"message": "No se pudo generar el centro autorizador. Intente nuevamente. LA AP NO ESTA EN CENTRO AUTORIZADOR",'+
                    '"debug_message": ""'+
                    '},'+
                    '"data": null,'+
                    '"httpCode": 500,'+
                    '"message": "No se pudo generar el centro autorizador. Intente nuevamente. LA AP NO ESTA EN CENTRO AUTORIZADOR"'+
                    '}'+
                '}';

    }

}