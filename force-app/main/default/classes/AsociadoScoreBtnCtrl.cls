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
			acc.Tiene_evento_de_exclusion__c = resp.result.data.evento_medico == 'V' ? true : false;
			acc.Edad_maxima__c = String.isNotBlank(resp.result.data.edad_maxima) 
									? Integer.valueOf(resp.result.data.edad_maxima) : null;

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