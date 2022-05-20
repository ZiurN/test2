public with sharing class AsyncValidateInSSOppCloseLost implements Queueable, Database.AllowsCallouts{
	private String solafi_id {get; set;}
	private String oppId {get; set;}
	private String userNick {get; set;}
	private Opportunity updatedOpportunity {get; set;}
	private Opportunity previewOpportunity {get; set;}
	public AsyncValidateInSSOppCloseLost(OpportunityTriggerHelper.OpportunityInfo oppInfo, String userNick) {
		this.solafi_id =  oppInfo.updatedOpportunity.Nro_de_solicitud__c;
		this.oppId = oppInfo.oppId;
		this.updatedOpportunity = oppInfo.updatedOpportunity;
		this.previewOpportunity = oppInfo.previewOpportunity;
		this.userNick = userNick;
	}
	public void execute(QueueableContext context) {
		String body = '{"nota_usuario" : "' + userNick + '"}';
		String extraParams = solafi_id + '/incompleta';
		WSEnviarASSHelper.SSRequest ssRequest = new WSEnviarASSHelper.SSRequest(body, 'solicitudes-afiliados', 'solicitudes-afiliados', 'PUT', extraParams);
		WSEnviarASSHelper.Response response = WSEnviarASSHelper.enviarASS(ssRequest);
		String message = response.message + '\n';
		Database.SaveResult result;
		if (response.hasError) {
			result = Database.update(previewOpportunity, false);
			if (!result.isSuccess()) {
				for(Database.Error err : result.getErrors()){
					message += message + '\n';
				}
			}
		}
		try {
			Boolean error = response.hasError || (result != null && !result.isSuccess());
			ConfigUtils.fireSSResponseEvent(response.message, oppId, false, error);
		} catch (Exception e) {
			System.debug(e.getMessage());
		}
	}
}