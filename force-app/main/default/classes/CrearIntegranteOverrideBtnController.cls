public without sharing class CrearIntegranteOverrideBtnController {

    @AuraEnabled
	public static Response getRecordTypeId(String recordId){
		Response response = new Response();
		if(!String.isBlank(recordId)) {
			try {
                Id solicitudDeBaja = XappiaHelper.getRecordType('Case','Solicitud_de_baja').Id;
                Case caso = [SELECT RecordTypeId, AccountId FROM Case WHERE id = :recordId];
                if (caso.RecordTypeId == solicitudDeBaja) {
                    response.data = XappiaHelper.getRecordType('Integrante_caso__c','Bajas').Id;
                    response.aditionalId = caso.AccountId;
                } else {
                    response.data = XappiaHelper.getRecordType('Integrante_caso__c','Despegues').Id;
                }

                return response;
			} catch (Exception e) {
                response.hasError = true;
                response.message = 'Error procesando.';
				return response;
			}
        }
        response.hasError = true;
        response.message = 'El ID no puede estar vacio.';
		return response;
	}


	public class Response {
		@AuraEnabled public String message {get; set;}
        @AuraEnabled public Boolean hasError {get; set;}
        @AuraEnabled public Object data {get; set;}
        @AuraEnabled public String aditionalId {get; set;}

        public Response() {
            hasError = false;
        }
	}
}