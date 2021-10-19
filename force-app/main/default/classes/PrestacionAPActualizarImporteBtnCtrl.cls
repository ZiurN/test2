public class PrestacionAPActualizarImporteBtnCtrl  {
	@AuraEnabled
	public static Response updateImporte(String presId) {
		List<Prestacion__c> prestacion = [
			SELECT Id, Prestacion_CA__c, Importe_cargo_al_socio_auditor__c, Importe_convenio_auditor__c, 
				Importe_plan_auditor__c
			FROM Prestacion__c 
			WHERE Id =: presId
		]; 

		String body = generateJson(prestacion[0]);

		WSPrestacionAPActualizarImporte.Response resp = WSPrestacionAPActualizarImporte.updateImporte(
			prestacion[0].Prestacion_CA__c, body
		);

		if(!resp.hasError) {
			return new Response(false, 'ok');
		} else {
			return new Response(true, resp.message);
		}
	}

	private static String generateJson(Prestacion__c prestacion) {
		Map<String, Object> prestJSON = new Map<String, Object>();
		if(prestacion.Importe_cargo_al_socio_auditor__c != null) {
			prestJSON.put('importe_socio', prestacion.Importe_cargo_al_socio_auditor__c);
		}
		if(prestacion.Importe_convenio_auditor__c != null) {
			prestJSON.put('importe_conv', prestacion.Importe_convenio_auditor__c);
		}
		if(prestacion.Importe_plan_auditor__c != null) {
			prestJSON.put('importe_plan', prestacion.Importe_plan_auditor__c);
		}

		return JSON.serialize(prestJSON);
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