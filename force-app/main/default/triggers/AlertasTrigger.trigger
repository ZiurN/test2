trigger AlertasTrigger on Alerta__c (after insert, after update)  {

	if(Trigger.isAfter){

		if(Trigger.isInsert){
			List<Alerta__c> alertsToCheck = new List<Alerta__c>();
			List<Alerta__c> alertsAM = new List<Alerta__c>();
			List<Alerta__c> alertsDisca = new List<Alerta__c>();
			
			for(Alerta__c alert : Trigger.new) {
				// EN AUDITORIA	=> C1-----A; GENERADO => C1-----G; 
				//Boolean refused = alert.Estado__c == 'C1---RSA' || alert.Estado__c == 'C1---RSP' 
									//|| alert.Estado__c == 'C1EA-RAA' || alert.Estado__c == 'C1EA-RAP';
				//Boolean authorized = alert.Estado__c == 'C1EA--AA' || alert.Estado__c == 'C1----AS';
	
				//if(alert.Estado__c == 'C1EA--AA' || alert.Estado__c == 'C1EA-RAA' || alert.Estado__c == 'C1EA-RAP'
					//|| alert.Estado__c == 'C1-AS'|| alert.Estado__c == 'C1-RSA'|| alert.Estado__c == 'C1-RSP'
				//) {
				if(isRefused(alert.Estado__c) || isAuthorized(alert.Estado__c)) {
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

		if(Trigger.isUpdate) {
			List<Alerta__c> alertsToCheck = new List<Alerta__c>();
			List<Alerta__c> alertsAM = new List<Alerta__c>();
			List<Alerta__c> alertsDisca = new List<Alerta__c>();

			for(Alerta__c alert : Trigger.new) {
				Alerta__c oldAlert = Trigger.oldMap.get(alert.Id);
	
				if(isRefused(alert.Estado__c) || isAuthorized(alert.Estado__c)) {
					alertsToCheck.add(alert);
					alertsDisca.add(alert);
				}

				if(alert.Estado__c != oldAlert.Estado__c && alert.Funcion__c == 'AM') {
					alertsAM.add(alert);
				}

				// if(alert.Estado__c != oldAlert.Estado__c 
				// 	&& (alert.Funcion__c == 'FCION_DISCA' || alert.Funcion__c == 'FCION_ID')
				// ) {
				// 	alertsDisca.add(alert);
				// }

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
	}

	private static Boolean isRefused(String estado) {
		return estado == 'C1---RSA' || estado == 'C1---RSP' || estado == 'C1EA-RAA' || estado == 'C1EA-RAP';
	}

	private static Boolean isAuthorized(String estado) {
		return estado == 'C1EA--AA' || estado == 'C1----AS';
	}

}