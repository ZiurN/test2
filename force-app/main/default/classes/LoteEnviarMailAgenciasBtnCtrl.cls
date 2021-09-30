public class LoteEnviarMailAgenciasBtnCtrl {
    @AuraEnabled
	public static Response sendEmailToAgencias(String idLote){
        WSLoteEnviarMailAgencias.Response resp = WSLoteEnviarMailAgencias.enviarIdLote(idLote);
        return new Response (resp.hasError, resp.message);
    }

    public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;

        public Response(Boolean hasError, String message) {
            this.hasError = hasError;
            this.message = message;
        }
	}
}