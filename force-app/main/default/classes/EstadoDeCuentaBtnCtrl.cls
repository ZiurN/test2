public class EstadoDeCuentaBtnCtrl {
    @AuraEnabled
	public static Response sendAccount(String afi){
        WSEstadoDeCuenta.Response resp = WSEstadoDeCuenta.getEstado(afi);
        
        Account acc = [
            SELECT Id, Afi_Id__C, Color_estado_de_cuenta__c
            FROM Account
            WHERE Afi_Id__C =: afi
        ];

        if(!resp.hasError){
            acc.Color_estado_de_cuenta__c = resp.result.data.estado_cuenta;
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