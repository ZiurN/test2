public class prestacionReintegroBtnCtrl {
    @AuraEnabled
    public static Response sendUpdateToSS(String presId) {
        List<Prestacion_de_reintegro__c> prestacion = [
            SELECT Id_Externo__c, Caso__r.Codigo_reintegro_SS__c , Importe_Reintegro_auditor__c, Importe_cargo_al_socio_auditor__c
            FROM Prestacion_de_reintegro__c 
            WHERE Id =: presId
        ];

        if(String.isBlank(prestacion[0].Caso__r.Codigo_reintegro_SS__c) 
            || String.isBlank(prestacion[0].Id_Externo__c)
        ) {
            return new Response(false, 'No se pueden actualizar los importes en Salud Soft:'
                + ' revise que el reintegro y la prestacion hayan sido enviados'); 
        }

        String body = generateJson(prestacion[0]);

        System.debug(body);
		WSPrestacionActualizarImporte.Response resp = WSPrestacionActualizarImporte.sendImporteToSS(
            body, prestacion[0].Caso__r.Codigo_reintegro_SS__c, prestacion[0].Id_Externo__c
        );

        System.debug('Respuesta: ' + resp);

		if(!resp.hasError) {
			return new Response(false, 'ok');
		} else {
			return new Response(true, resp.message);
		}
    }
    
    private static String generateJson(Prestacion_de_reintegro__c prestacion) {
		Map<String, Object> prestJSON = new Map<String, Object>();
        System.debug(prestacion);
		if(prestacion.Importe_Reintegro_auditor__c != null) {
			prestJSON.put('importe_reintegro', prestacion.Importe_Reintegro_auditor__c);
		}
		if(prestacion.Importe_cargo_al_socio_auditor__c != null) {
			prestJSON.put('importe_socio', prestacion.Importe_cargo_al_socio_auditor__c);
		}
        
		return JSON.serialize(prestJSON);
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