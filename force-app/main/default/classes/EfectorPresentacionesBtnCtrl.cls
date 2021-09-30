public class EfectorPresentacionesBtnCtrl {
    @AuraEnabled
    public static Response getPresentacionesEfector(String codEfector) {
        WSEfectorPresentaciones.Response wsResponse =  WSEfectorPresentaciones.getEfectorPresentaciones(codEfector);

        if(!wsResponse.hasError){
            return new Response(false,
                    '',
                    wsResponse.presentaciones.data);
        }
        else{
            return new Response(true,
                    'Hubo un error al intentar obtener las presentaciones del efector desde SaludSoft',
                    null);
        }
    }

	@AuraEnabled
    public static ResponseDetalles getEfectorDetallesPresentacion(String idComprobante) {
        WSEfectorGetDetallesPresentacion.Response wsResponse =  WSEfectorGetDetallesPresentacion.getEfectorDetallesPresentacion(idComprobante);

        if(!wsResponse.hasError){
            return new ResponseDetalles(false,
                    '',
                    wsResponse.efectorDetallesPresentacion.data);
        }
        else{
            return new ResponseDetalles(true,
                    'Hubo un error al intentar obtener los comprobantes de la presentación desde SaludSoft',
                    null);
        }
    }

    public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
        @AuraEnabled public List<WSEfectorPresentacionesResp.Data> presentaciones;

        public Response(Boolean hasError, String message, List<WSEfectorPresentacionesResp.Data> presentacionesEfector){
            this.hasError = hasError;
            this.message = message;
            this.presentaciones = presentacionesEfector;
        }
    }

    public class ResponseDetalles {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
        @AuraEnabled public List<WSEfectorGetDetallesPresentacionResp.Data> detallesPresentacion;

        public ResponseDetalles(Boolean hasError, String message, List<WSEfectorGetDetallesPresentacionResp.Data> detallesPresentacion){
            this.hasError = hasError;
            this.message = message;
            this.detallesPresentacion = detallesPresentacion;
        }
    }
}