public with sharing class AsyncValidateChangesInAcountInSS implements Queueable, Database.AllowsCallouts {
	private Account updatedAccount {get; set;}
	private Account previewAccount {get; set;}
	private Boolean emailHasChanged {get;set;}
	private Boolean documentHasChanged {get;set;}
	private AccountEnviarASSParser parser;
	public AsyncValidateChangesInAcountInSS (AccountTriggerHelper.AccountInfo accInfo) {
		this.updatedAccount = accInfo.updatedAccount;
		this.previewAccount = accInfo.previewAccount;
		this.emailHasChanged = accInfo.emailHasChanged;
		this.documentHasChanged = accInfo.documentHasChanged;
	}
	public void execute(QueueableContext context) {
		parser = new AccountEnviarASSParser(updatedAccount);
		String body = parser.parseRequesBody(emailHasChanged, documentHasChanged);
		WSEnviarASSHelper.SSRequest ssRequest = new WSEnviarASSHelper.SSRequest(body, 'afiliado', 'datos-sf', 'POST', null);
		WSEnviarASSHelper.Response response = WSEnviarASSHelper.enviarASS(ssRequest);
		String message = response.message + '\n';
		Database.SaveResult result;
		if (response.hasError) {
			Account revertedAccount = previewAccount.clone(true, true, true, true);
			revertedAccount.PersonEmail = String.isBlank(previewAccount.PersonEmail) ? null : previewAccount.PersonEmail;
			revertedAccount.Tipo_de_documento__c = String.isBlank(previewAccount.Tipo_de_documento__c) ? null : previewAccount.Tipo_de_documento__c;
			revertedAccount.Numero_de_documento__c = String.isBlank(previewAccount.Numero_de_documento__c) ? null : previewAccount.Numero_de_documento__c;
			revertedAccount.CUIT__c = String.isBlank(previewAccount.CUIT__c) ? null : previewAccount.CUIT__c;
			result = Database.update(revertedAccount, false);
			if (!result.isSuccess()) {
				for (Database.Error err : result.getErrors()) {
					message += message + '\n';
				}
			}
		}
		try {
			Boolean error = response.hasError || (result != null && !result.isSuccess());
			ConfigUtils.fireSSResponseEvent(response.message, updatedAccount.Id, false, error);
		} catch (Exception e) {
			System.debug(e.getMessage());
		}
	}
}