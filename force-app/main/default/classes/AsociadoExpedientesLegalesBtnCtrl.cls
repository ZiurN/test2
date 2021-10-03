public class AsociadoExpedientesLegalesBtnCtrl {

	@AuraEnabled
	public static Response updateCheckExpediente(String accountId) {
		List<Account> cuentas = [SELECT Id, Afi_Id__c FROM Account WHERE Id =: accountId];

		if(String.isBlank(cuentas[0].Afi_Id__c)) {
			return new Response(false, 'El id del afiliado esta vacío');
		}

		WSAsociadoExpedientesLegales.Response resp = WSAsociadoExpedientesLegales.getExpedientes(cuentas[0].Afi_Id__c);

		if(!resp.hasError) {
			cuentas[0].Contiene_expediente_legal__c = resp.result.data.socio_legal == 'V';
			
			Database.SaveResult resultAsociado = Database.update(cuentas[0]);
			System.debug('****resultAsociado: ' + resultAsociado);
			
			return new Response(false, 'ok');
		}

		return new Response(true, resp.message);
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;

		public Response(Boolean hasError, String message){
			this.hasError = hasError;
			this.message = message;
		}
	}
}