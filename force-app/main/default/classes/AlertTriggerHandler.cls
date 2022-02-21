/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase manejadora del desencadenador para el objeto Alertas
@date			21/02/2021
------------------------------------------------------------------------------------------------------------------------*/
public with sharing class AlertTriggerHandler extends TriggerHandler {
	List<Alerta__c> lNew = (List<Alerta__c>) Trigger.new;
	List<Alerta__c> lOld = (List<Alerta__c>) Trigger.old;
	Map<Id,Alerta__c> mNew = (Map<Id,Alerta__c>) Trigger.newMap;
	Map<Id,Alerta__c> mOld = (Map<Id,Alerta__c>) Trigger.oldMap;
	public override void beforeInsert() {
		// Nothing
	}
	public override void beforeUpdate() {
		// Nothing
	}
	public override void beforeDelete() {
		// Nothing
	}
	public override void afterInsert() {
		List<Alerta__c> alertsToCheck = new List<Alerta__c>();
		List<Alerta__c> alertsAM = new List<Alerta__c>();
		List<Alerta__c> alertsDisca = new List<Alerta__c>();
		for(Alerta__c alert : lNew) {
			if(AlertasHelper.isRefused(alert.Estado__c) || AlertasHelper.isAuthorized(alert.Estado__c)) {
				alertsToCheck.add(alert);
			}
			if(alert.Funcion__c == 'AM') {
				alertsAM.add(alert);
			}
			if(alert.Funcion__c == 'FCION_DISCA' || alert.Funcion__c == 'FCION_ID') {
				alertsDisca.add(alert);
			}
		}
		if(!alertsToCheck.isEmpty()) {
			AlertasHelper.checkCaseState(alertsToCheck);
		}
		if(!alertsAM.isEmpty()) {
			AlertasHelper.checkCaseNoAlertsAMPending(alertsAM);
		}
		if(!alertsDisca.isEmpty()) {
			AlertasHelper.checkCaseAlertsDiscaPending(alertsDisca);
		}
	}
	public override void afterUpdate() {
		List<Alerta__c> alertsToCheck = new List<Alerta__c>();
		List<Alerta__c> alertsAM = new List<Alerta__c>();
		List<Alerta__c> alertsDisca = new List<Alerta__c>();
		for(Alerta__c alert : lNew) {
			Alerta__c oldAlert = mOld.get(alert.Id);
			if(AlertasHelper.isRefused(alert.Estado__c) || AlertasHelper.isAuthorized(alert.Estado__c)) {
				alertsToCheck.add(alert);
				alertsDisca.add(alert);
			}
			if(alert.Estado__c != oldAlert.Estado__c && alert.Funcion__c == 'AM') {
				alertsAM.add(alert);
			}
		}
		if(!alertsToCheck.isEmpty()) {
			AlertasHelper.checkCaseState(alertsToCheck);
		}
		if(!alertsAM.isEmpty()) {
			AlertasHelper.checkCaseNoAlertsAMPending(alertsAM);
		}
		if(!alertsDisca.isEmpty()) {
			AlertasHelper.checkCaseAlertsDiscaPending(alertsDisca);
		}
	}
	public override void afterDelete() {
		//Nothing
	}
	public override void afterUndelete() {
		//Nothing
	}
}
