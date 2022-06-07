public with sharing class AsyncValidateChangesInAcountInSS implements Queueable, Database.AllowsCallouts {
	private Account updatedAccount {get; set;}
	private Account previewAccount {get; set;}
	private AccountEnviarASSParser parser;
	public AsyncValidateChangesInAcountInSS (Account updatedAccount, Account previewAccount) {
		this.updatedAccount = updatedAccount;
		this.previewAccount = previewAccount;
	}
	public void execute(QueueableContext context) {
		parser = new AccountEnviarASSParser(updatedAccount);
		String body = parser.parseEmailCheckBody();
		WSEnviarASSHelper.SSRequest ssRequest = new WSEnviarASSHelper.SSRequest(body, 'afiliado', 'datos-sf', 'POST', null);
		WSEnviarASSHelper.Response response = WSEnviarASSHelper.enviarASS(ssRequest);
		String message = response.message + '\n';
		Database.SaveResult result;
		if (response.hasError) {
			result = Database.update(previewAccount, false);
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