public class EmpresaConveniosBtnCtrl {
    @AuraEnabled
    public static Response getConvenios(String codigoEmpresa) {
        WSEmpresaConvenios.Response wsResponse =  WSEmpresaConvenios.getConvenios(codigoEmpresa);

        if(!wsResponse.hasError){
            return new Response(false,
                    '',
                    wsResponse.convenios.data);
        }
        else{
            return new Response(true,
                    'Hubo un error al intentar obtener los convenios desde SaludSoft',
                    null);
        }
    }

    public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
        @AuraEnabled public WSEmpresaConveniosResp.Data data;

        public Response(Boolean hasError, String message, WSEmpresaConveniosResp.Data convPorAportes){
            this.hasError = hasError;
            this.message = message;
            this.data = convPorAportes;
        }
    }

    @AuraEnabled
    public static ResponsePlanConvenios getEmpresaPlanConvenios(Integer planId) {
        WSEmpresaGetPlanConvenios.Response wsResponse =  WSEmpresaGetPlanConvenios.getEmpresaPlanConvenios(planId);

        if(!wsResponse.hasError) {
            return new ResponsePlanConvenios(false,
                    '',
                    wsResponse.empresaPlanConvenios.data);
        }
        else {
            return new ResponsePlanConvenios(true,
                    'Hubo un error al intentar obtener los planes del convenio desde SaludSoft',
                    null);
        }
    }

    public class ResponsePlanConvenios {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
        @AuraEnabled public List<WSEmpresaGetPlanConveniosResp.Data> empresaPlanConvenios;

        public ResponsePlanConvenios(Boolean hasError, String message, List<WSEmpresaGetPlanConveniosResp.Data> empresaPlanConvenios){
            this.hasError = hasError;
            this.message = message;
            this.empresaPlanConvenios = empresaPlanConvenios;
        }
    }
}