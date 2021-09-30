public class ConvertLeadController  {

	@AuraEnabled
	public static Id convertLead(Id leadId,String newStatus){
		Lead theLead = [SELECT Id, Company, Conversion_manual__c,MobilePhone,Phone,Email, RecordType.Name ,Status FROM Lead WHERE Id = :leadId];
		theLead.Status = newStatus;
		if(theLead.Status == 'Contactado - Interesado'){
			theLead.Conversion_manual__c = true;
		}
		System.debug(theLead);
		Account corp;
		if(theLead.RecordType.Name == 'Corporativo'){
			theLead.Es_corporativo__c = true;
			corp = new Account(Name = theLead.Company);
			corp.RecordTypeId = XappiaHelper.getRecordType('Account','Empresa').Id;
			insert corp;
		}
		update theLead;
		if(theLead.Status == 'Contactado - Interesado'){
			LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];

			Database.LeadConvert lc = new Database.LeadConvert();
			lc.setLeadId(theLead.id);
			lc.setOwnerId(UserInfo.getUserId());
			lc.setConvertedStatus(convertStatus.MasterLabel);
			lc.setDoNotCreateOpportunity(false);
			if(theLead.RecordType.Name == 'Corporativo'){
				lc.setAccountId(corp.Id);
			}
			
			Database.LeadConvertResult res =  Database.convertLead(lc);
			System.debug(res);

			if(res.isSuccess()){
				List<Opportunity> oppCreated = [SELECT Id,Telefono__c FROM Opportunity WHERE Id = :res.getOpportunityId()];
				if(!oppCreated.isEmpty()){
					Opportunity opp = oppCreated.get(0);
					
					//if(String.isNotBlank(theLead.MobilePhone)) {
						opp.Telefono__c = String.isNotBlank(theLead.MobilePhone) ? theLead.MobilePhone : theLead.Phone;
						opp.Tipo_de_Telefono__c = String.isNotBlank(theLead.MobilePhone) ? 'CEL' : 'TEL';
					//}
					//else {
						//opp.Telefono__c = theLead.Phone;
						//opp.Tipo_de_Telefono__c = 'CEL';
					//}
					update opp;
				}
				if(theLead.RecordType.Name != 'Corporativo'){
					List<Account> accountCreated = [SELECT Id,Correo_electronico__c,Tipo_de_Telefono__c,Type FROM Account WHERE Id = :res.getAccountId()];
					if(!accountCreated.isEmpty()){
						Account accToUpdate = accountCreated.get(0);
						accToUpdate.Correo_electronico__c = theLead.Email;
						accToUpdate.Type = 'Titular';
						
						if(theLead.MobilePhone != null) {
							accToUpdate.Tipo_de_Telefono__c = 'CEL';
							accToUpdate.Phone = theLead.MobilePhone;
						}
						else{
							accToUpdate.Tipo_de_Telefono__c = 'TEL';
						}

						update accToUpdate;
					}
					return res.getAccountId();
				}
				return res.getContactId();
				
			}else{
				throw new LeadConvertionException();
			}

		}
		return null;
	}

	public class LeadConvertionException extends Exception{
	}

}