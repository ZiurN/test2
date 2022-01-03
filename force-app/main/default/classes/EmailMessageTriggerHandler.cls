/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase manejadora del desencadenador para el objeto EmailMessage
@date			23/12/2021
------------------------------------------------------------------------------------------------------------------------*/
public with sharing class EmailMessageTriggerHandler extends TriggerHandler {
	List<EmailMessage> lNew = (List<EmailMessage>) Trigger.new;
	List<EmailMessage> lOld = (List<EmailMessage>) Trigger.old;
	Map<Id,EmailMessage> mNew = (Map<Id,EmailMessage>) Trigger.newMap;
	Map<Id,EmailMessage> mOld = (Map<Id,EmailMessage>) Trigger.oldMap;
	public override void beforeInsert() {
		// Nothing to do
	}
	public override void beforeUpdate() {
		// Nothing to do
	}
	public override void beforeDelete() {
		// Nothing to do
	}
	public override void afterInsert() {
		EmailMessageTriggerHelper.ifEmailHaveFilesDeleteCDLinksIfParentHasTheSame(lNew);
	}
	public override void afterUpdate() {
		EmailMessageTriggerHelper.ifEmailHaveFilesDeleteCDLinksIfParentHasTheSame(lNew);
	}
	public override void afterDelete() {
		// Nothing to do
	}
	public override void afterUndelete() {
		// Nothing to do
	}
}
