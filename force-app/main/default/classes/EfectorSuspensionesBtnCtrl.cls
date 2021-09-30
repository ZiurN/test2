public class EfectorSuspensionesBtnCtrl {
    @AuraEnabled
    public static Response getSuspensionesEfector(String codEfector) {
        WSEfectorSuspensiones.Response wsResponse =  WSEfectorSuspensiones.getEfectorSuspensiones(codEfector);

        if(!wsResponse.hasError){
            return new Response(false,
                    '',
                    wsResponse.suspensiones.data);
        }
        else{
            return new Response(true,
                    'Hubo un error al intentar obtener las suspensiones del efector desde SaludSoft',
                    null);
        }
    }

    public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
        @AuraEnabled public List<WSEfectorSuspensionesResp.Data> suspensiones;

        public Response(Boolean hasError, String message, List<WSEfectorSuspensionesResp.Data> suspensionesEfector){
            this.hasError = hasError;
            this.message = message;
            this.suspensiones = suspensionesEfector;
        }
    }
}