trigger IntegranteTrigger on Integrante__c (before insert,after update)  {
	if (Trigger.isBefore) {

		if (Trigger.isInsert) {
			Map<String, List<Integrante__c>> opportunityIdIntegrantesToFillContactInformation = new Map<String, List<Integrante__c>>();
            List<Id> oppIds = new List<Id>();
            List<Integrante__c> integrantesToValidate = new List<Integrante__c>();
			for (Integrante__c integrante : Trigger.new) {
                if(integrante.Integrante_accion_rapida__c == null || !integrante.Integrante_accion_rapida__c){
                    integrantesToValidate.add(integrante);
                }

              	oppIds.add(integrante.Oportunidad__c);
				if (opportunityIdIntegrantesToFillContactInformation.keySet().contains(integrante.Oportunidad__c)) {
					List<Integrante__c> integrantesFromMap = opportunityIdIntegrantesToFillContactInformation.get(integrante.Oportunidad__c);
					integrantesFromMap.add(integrante);
					opportunityIdIntegrantesToFillContactInformation.put(integrante.Oportunidad__c, integrantesFromMap);
				} else {
					opportunityIdIntegrantesToFillContactInformation.put(integrante.Oportunidad__c, new List<Integrante__c>{integrante});
				}
			}
            Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([
               SELECT Id, Segmento_del_Grupo_Familiar__c
               FROM Opportunity
               WHERE Id IN :oppIds
            ]);
			if (!opportunityIdIntegrantesToFillContactInformation.isEmpty()) {
				IntegranteHelper.fillContactInformationFromOpp(opportunityIdIntegrantesToFillContactInformation);
			}
            IntegranteHelper.validateFields(integrantesToValidate, oppMap);
		}
	}
	if(Trigger.isAfter){
		if(Trigger.isUpdate){
			Map<String,String> dniAsociados = new Map<String,String>();
			for(Integrante__c integrante : Trigger.new){
				if(!integrante.Integrante_accion_rapida__c && integrante.Nro_de_asociado__c != null && integrante.Nro_de_asociado__c != Trigger.oldMap.get(integrante.Id).Nro_de_asociado__c){
					if(integrante.Nro_de_documento__c != null){
						dniAsociados.put(integrante.Nro_de_documento__c,integrante.Nro_de_asociado__c);
					}
				}
			}
			if(!dniAsociados.keySet().isEmpty()){
				IntegranteHelper.updateRelatedAccounts(dniAsociados);
			}
		}

	}

}