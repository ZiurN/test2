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
	}
	public override void afterDelete() {
		//Nothing
	}
	public override void afterUndelete() {
		//Nothing
	}
}