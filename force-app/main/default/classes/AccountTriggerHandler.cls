/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase manejadora del desencadenador para el objeto Account
@date			08/12/2021
------------------------------------------------------------------------------------------------------------------------*/
public with sharing class AccountTriggerHandler extends TriggerHandler {
	List<Account> lNew = (List<Account>) Trigger.new;
	List<Account> lOld = (List<Account>) Trigger.old;
	Map<Id,Account> mNew = (Map<Id,Account>) Trigger.newMap;
	Map<Id,Account> mOld = (Map<Id,Account>) Trigger.oldMap;
	public override void beforeInsert() {
		// Nothing
	}
	public override void beforeUpdate() {
		WSDatosAfiliados.updateAccountDetailsToWS(lNew, mOld);
	}
	public override void beforeDelete() {
		// Nothing
	}
	public override void afterInsert() {
		// Nothing
	}
	public override void afterUpdate() {
		Id[] accsToUpdateFacturaElectronicaInSS = new List<Id>();
		List<AccountTriggerHelper.AccountInfo> accountsToValidate = new List<AccountTriggerHelper.AccountInfo>();
		for (Account acc : lNew) {
			Account oldAcc = mOld.get(acc.Id);
			Boolean isAsync = System.isBatch() || System.isFuture() || System.isQueueable() || System.isScheduled();
			if (acc.Envio_de_recibo__c != oldAcc.Envio_de_recibo__c && !isAsync) {
				accsToUpdateFacturaElectronicaInSS.add(acc.Id);
			}
		}
		if (!accsToUpdateFacturaElectronicaInSS.isEmpty()) {
			AccountTriggerHelper.updateFacturaElectronicaOnSS(accsToUpdateFacturaElectronicaInSS);
		}
		if(!System.isBatch() && !System.isQueueable() && !XappiaHelper.isIntegracionSSUser()) {
			for (Account acc : lNew) {
				Account oldAcc = mOld.get(acc.id);
				Boolean emailHasChanged = acc.PersonEmail != oldAcc.PersonEmail;
				Boolean documentHasChanged = acc.CUIT__c != oldAcc.CUIT__c
					|| acc.Numero_de_documento__c != oldAcc.Numero_de_documento__c
					|| acc.Tipo_de_documento__c != oldAcc.Tipo_de_documento__c;
				if (!String.isBlank(acc.Afi_Id__c) && (emailHasChanged || documentHasChanged)) {
					AccountTriggerHelper.AccountInfo accInfo = new AccountTriggerHelper.AccountInfo();
					accInfo.documentHasChanged = documentHasChanged;
					accInfo.emailHasChanged = emailHasChanged;
					accInfo.previewAccount = oldAcc;
					accInfo.updatedAccount = acc;
					accountsToValidate.add(accInfo);
				}
			}
			if (!accountsToValidate.isEmpty()) {
				AccountTriggerHelper.validateAccountsFieldsInSS(accountsToValidate);
			}
		}
	}
	public override void afterDelete() {
		//Nothing
	}
	public override void afterUndelete() {
		//Nothing
	}
}