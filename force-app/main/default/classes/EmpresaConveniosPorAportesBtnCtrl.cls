public class EmpresaConveniosPorAportesBtnCtrl {
    @AuraEnabled
    public static Response getConveniosPorAporte(String codigoEmpresa) {
        WSEmpresaConveniosPorAporte.Response wsResponse =  WSEmpresaConveniosPorAporte.getConveniosAportes(codigoEmpresa);

        if(!wsResponse.hasError){
            return new Response(false,
                    '',
                    wsResponse.conveniosPorAporte.data);
        }
        else{
            return new Response(true,
                    'Hubo un error al intentar obtener los convenios por aporte desde SaludSoft',
                    null);
        }
    }

    public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
        @AuraEnabled public List<WSEmpresaConveniosPorAporteResp.Data> convenios;

        public Response(Boolean hasError, String message, List<WSEmpresaConveniosPorAporteResp.Data> convPorAportes){
            this.hasError = hasError;
            this.message = message;
            this.convenios = convPorAportes;
        }
    }
}