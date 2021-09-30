public class caseLiveChatHelper  {
	public static void assignAccounts (List<Case> tCases) {
		Map<String, Case> cases = new Map<String, Case>();
        for(Case caso : tCases) {
            if(caso.DNI_liveagent__c != null) {
                cases.put(caso.DNI_liveagent__c, caso);
            }
        }
		if(cases.size() > 0) {
			List<Account> accounts = [SELECT Id, Numero_de_documento__c, PersonContactId, Tipo_de_documento__c FROM Account WHERE Numero_de_documento__c IN :cases.keySet() AND Tipo_de_documento__c = 'DNI'];
			Map<String, Account> accountsByDNI = new Map<String, Account>();
			for(Account acc : accounts) {
				accountsByDNI.put(acc.Numero_de_documento__c, acc);
			}
			for(Case caso :cases.values()){
				if(accountsByDNI.containsKey(caso.DNI_liveagent__c)) {
					Account acc = accountsByDNI.get(caso.DNI_liveagent__c);	
					caso.AccountId = acc.Id;
					if(acc.PersonContactId != null) {
						caso.contactId = acc.PersonContactId;
					}
				}
			}
		}
	}
}