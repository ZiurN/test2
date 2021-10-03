public class AsociadoScoreBtnCtrl {
    @AuraEnabled
	public static Response sendAccount(String afi){
        WSAsociadoScore.Response resp = WSAsociadoScore.enviarCuenta(afi);
        System.debug('Debug -->' + resp + ' Afi -->' + afi);
        
        Account acc = [
            SELECT Id, Codigo_de_Afiliado__c, Indice_de_Rentabilidad__c, Color_scoring__c
            FROM Account
            WHERE Codigo_de_Afiliado__c =: afi
        ];

        if(!resp.hasError){
            acc.Indice_de_Rentabilidad__c = resp.result.data.indice_rentabilidad;
            acc.Color_scoring__c = resp.result.data.color;
            update acc;
        }

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