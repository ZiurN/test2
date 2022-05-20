@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class ConfigUtils  {
	public static Organization currentOrg;
	public static Boolean isSandboxEnviroment() {
		if (currentOrg == null) {
			currentOrg = [SELECT Id, Name, IsSandbox FROM Organization LIMIT 1];
		}
		return currentOrg.isSandbox;
	}
	public static Batch_Debug_Mail__mdt getDebugEmail(String name){
		List<Batch_Debug_Mail__mdt> result = [SELECT Id, Mail__c FROM Batch_Debug_Mail__mdt WHERE MasterLabel = :name];
		if(!result.isEmpty()) {return result[0];}
		return null;
	}
	public static List<String> getBatchDebugEmails(){
		List<String> mails = new List<String>();
		List<Batch_Debug_Mail__mdt> result = [SELECT Id, Mail__c FROM Batch_Debug_Mail__mdt];
		for(Batch_Debug_Mail__mdt bdm : result) {
			if(String.isNotBlank(bdm.Mail__c)) {mails.add(bdm.Mail__c);}
		}
		return mails;
	}
	public static Webservice_endpoint_setting__mdt getWebServiceConfig(String name) {
		Boolean isProduction = !isSandboxEnviroment();
		List<Webservice_endpoint_setting__mdt> result = [SELECT
															Id,
															URL__c,
															User__c,
															Password__c,
															Client_Secret__c,
															Client_Id__c
														FROM Webservice_endpoint_setting__mdt
														WHERE MasterLabel = :name
														AND Is_Production__c = :isProduction];
		if(!result.isEmpty()) {return result[0];}
		return null;
	}
	public static Access_Token__c getToken(){
		Access_Token__c[] token = [SELECT DueDate__c,
									Encrypting_Key__c,
									Value__c,
									Value_2__c,
									Value_3__c,
									Value_4__c,
									Value_5__c,
									Refresh_Value__c,
									Refresh_Value_2__c,
									Refresh_Value_3__c,
									Refresh_Value_4__c
							FROM Access_Token__c];
		if(token.isEmpty()){return null;}
		else{return token[0];}
	}
	public static AWS_settings__mdt getAWSConfig(String name) {
		List<AWS_settings__mdt> result = [SELECT Name_Credential__c, Bucket__c, File_Directory__c, Region__c
											FROM AWS_settings__mdt
											WHERE DeveloperName = :name
											LIMIT 1];
		if(!result.isEmpty()) {return result[0];}
		return null;
	}
	public static Map<String, Webservice_endpoint__mdt> getEndpointsByTipo (String tipo) {
		List<Webservice_endpoint__mdt> endpoints = [SELECT Label, Endpoint__c FROM Webservice_endpoint__mdt WHERE Tipo__c =: tipo];
		Map<String, Webservice_endpoint__mdt> mapToReturn = new Map<String, Webservice_endpoint__mdt>();
		for (Webservice_endpoint__mdt endpoint : endpoints) {
			mapToReturn.put(endpoint.Label, endpoint);
		}
		return mapToReturn;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método para disparar eventos de respuesta de SS.
	@param			message - El mensaje en texto del evento.
	@param			recordId - El Id de SF del registro sobre el que se quiere disparar el evento.
	@param			isCreating - Booleano para indicar si el evento es de creación o no.
	@param			isError - Booleano que indica si el evento está relacionado a una respuesta de error en SS.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void fireSSResponseEvent (String message, String recordId, Boolean isCreating, Boolean isError) {
		SS_Response_Event__e errorEvent =  new SS_Response_Event__e(
			isDelete__c = isCreating,
			error__c = isError,
			Response_Error__c = message,
			Id_Registro__c = !String.isBlank(recordId) ? recordId : 'NoID'
		);
		List<Database.SaveResult> results = EventBus.publish(new List<SS_Response_Event__e>{errorEvent});
		for (Database.SaveResult result : results) {
			if (!result.isSuccess()) {
				for (Database.Error err : result.getErrors()) {
					System.debug(err.fields);
					System.debug(err.message);
				}
			}
		}
	}
}