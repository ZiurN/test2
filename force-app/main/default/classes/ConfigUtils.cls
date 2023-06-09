@SuppressWarnings('PMD.ApexCRUDViolation, PMD.ExcessiveParameterList')
public without sharing class ConfigUtils  {
	public static SSResponseEventTriggerHandler eventHandler = new SSResponseEventTriggerHandler();
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
		SSResponseEvent__e errorEvent =  new SSResponseEvent__e(
			isCreationEvent__c = isCreating,
			isErrorEvent__c = isError,
			message__c = message,
			recordId__c = !String.isBlank(recordId) ? recordId : 'NoID'
		);
		List<Database.SaveResult> results = EventBus.publish(new List<SSResponseEvent__e>{errorEvent});
		for (Database.SaveResult result : results) {
			if (!result.isSuccess()) {
				for (Database.Error err : result.getErrors()) {
					System.debug(err.fields);
					System.debug(err.message);
				}
			}
		}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método para manejar eventos tipo SSResponseEvent__e.
	@param			event - Evento a manejar
	------------------------------------------------------------------------------------------------------------------------*/
	public static void handleSSResponseEventFired (SSResponseEvent__e event) {
		eventHandler.handleFiredEvent(event);
	}
}