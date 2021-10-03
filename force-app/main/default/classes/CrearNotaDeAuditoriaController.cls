public class CrearNotaDeAuditoriaController  {
	
	@AuraEnabled
	public static Response getRecordTypeId(String recordId){
		//Map<String, Schema.RecordTypeInfo> notaDeAuditoriaRecordTypesByDeveloperName = 
			//Schema.SObjectType.Nota_de_Auditoria__c.getRecordTypeInfosByDeveloperName();
		
		Response response = new Response();
		String strObjPrefix = String.isNotBlank(recordId) ? recordId.substring(0, 3) : null;
		
		if(strObjPrefix == Case.sObjectType.getDescribe().getKeyPrefix()) {
			response.data = XappiaHelper.getRecordType('Nota_de_Auditoria__c','Service').Id;
			response.objectType = 'Case';
		}	
		else if(strObjPrefix == Evento_medico__c.sObjectType.getDescribe().getKeyPrefix()) {
			response.data = XappiaHelper.getRecordType('Nota_de_Auditoria__c','Service').Id;
			response.objectType = 'Evento_Medico__c';
		}
		else if(strObjPrefix == Opportunity.sObjectType.getDescribe().getKeyPrefix()) {
			response.data = XappiaHelper.getRecordType('Nota_de_Auditoria__c','Ventas').Id;
			response.objectType = 'Opportunity';
		}
		else if(strObjPrefix == Integrante_caso__c.sObjectType.getDescribe().getKeyPrefix()) {
			response.data = XappiaHelper.getRecordType('Nota_de_Auditoria__c','Integrante').Id;
			response.objectType = 'Integrante_caso__c';
		}
		else {
			response.hasError = true;
			response.message = 'Solo puede crear Notas de auditoria desde un registro de Oportunidad, ' + 
								'Evento Médico, Caso o Integrante';
		}

		if(response.objectType == 'Case') {
			try {
				Case caso = [SELECT RecordTypeId FROM Case WHERE id = :recordId];
				Id solicitudDeAltaFamiliar = XappiaHelper.getRecordType('Case', 'Solicitud_de_alta_familiar').Id;
				Id solicitudDeDespegues = XappiaHelper.getRecordType('Case', 'Solicitud_de_despegues').Id;
				Id solicitudDeBajas = XappiaHelper.getRecordType('Case', 'Solicitud_de_baja').Id;
				Id solicitudCambioSegmento = XappiaHelper.getRecordType('Case', 'Solicitud_de_segmento').Id;
            	Id solicitudInterfazFinanciera = XappiaHelper.getRecordType('Case', 'Interfaz_financiera').Id;
            	Id solicitudCredencial = XappiaHelper.getRecordType('Case', 'Solicitud_de_nueva_credencial').Id;
            	Id solicitudPlan = XappiaHelper.getRecordType('Case', 'Solicitud_de_cambio_de_plan').Id;
            	Id solicitudDatosParticulares = XappiaHelper.getRecordType('Case', 'Solicitud_de_datos_particulares').Id;
				if(caso.RecordTypeId == solicitudDeDespegues
						|| caso.RecordTypeId == solicitudCambioSegmento 
						|| caso.RecordTypeId == solicitudInterfazFinanciera
						|| caso.RecordTypeId == solicitudCredencial
						|| caso.RecordTypeId == solicitudDatosParticulares
						|| caso.RecordTypeId == solicitudPlan
						|| caso.RecordTypeId == solicitudDeBajas
						|| caso.RecordTypeId == solicitudDeAltaFamiliar){
					Tipo_nota_de_auditoria__c tipoDeNota = [SELECT id FROM Tipo_nota_de_auditoria__c WHERE Name = 'NOTA DDJJ - SOLICITUDES' LIMIT 1];
					if(tipoDeNota != null) {
						response.typeOfNota = tipoDeNota.id;
						return response;
					}
				}
			} catch (Exception e) {
				return response;
			}
		}
		return response;
	}


	public class Response {
		@AuraEnabled public String message {get; set;}
        @AuraEnabled public Boolean hasError {get; set;}
        @AuraEnabled public Object data {get; set;}
		@AuraEnabled public Id typeOfNota {get; set;}
		@AuraEnabled public String objectType {get; set;}

        public Response() {
            hasError = false;
        }
	}
}