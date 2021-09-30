public class EfectorEspecialidadesBtnCtrl {
    @AuraEnabled
    public static Response getEspecialidadesEfector(String codEfector) {
        WSEfectorGetEspecialidades.Response wsResponse =
                WSEfectorGetEspecialidades.getEfectorEspecialidades(codEfector);

        if(!wsResponse.hasError){
            return new Response(false,
                    '',
                    wsResponse.especialidades.data);
        }
        else{
            return new Response(true,
                    'Hubo un error al intentar obtener las especialidades del efector desde SaludSoft',
                    null);
        }
    }

    public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
        @AuraEnabled public List<WSEfectorGetEspecialidadesResp.Data> especialidades;

        public Response(Boolean hasError, String message, List<WSEfectorGetEspecialidadesResp.Data> especialidadesEfector){
            this.hasError = hasError;
            this.message = message;
            this.especialidades = especialidadesEfector;
        }
    }
}