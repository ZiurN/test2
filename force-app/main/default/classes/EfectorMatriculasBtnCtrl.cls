public class EfectorMatriculasBtnCtrl {
    @AuraEnabled
    public static Response getMatriculasEfector(String codigoEfector) {
        WSEfectorMatriculas.Response wsResponse =  WSEfectorMatriculas.getEfectorMatriculas(codigoEfector);

        if(!wsResponse.hasError){
            return new Response(false,
                    '',
                    wsResponse.matriculas.data);
        }
        else{
            return new Response(true,
                    'Hubo un error al intentar obtener las matriculas del efector desde SaludSoft',
                    null);
        }
    }

    public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
        @AuraEnabled public List<WSEfectorMatriculasResp.Data> matriculas;

        public Response(Boolean hasError, String message, List<WSEfectorMatriculasResp.Data> matriculasEfector){
            this.hasError = hasError;
            this.message = message;
            this.matriculas = matriculasEfector;
        }
    }
}