public class SLAUtils{

	static Map<Id, Account> mapAccount;
	static Map<Id, String> processNameCSMap;
	static Map<Id, Group> ownersMap;

	/**
	* @description Si no existen, inserta Entitlements (asignacion de SLA) a los casos segun
	* configuracion personalizada SlaProcessByCase__c
	* @param cases 
	*/ 
	public static void assignEntitlements(List<Case> cases) {
		mapAccount = new Map<Id, Account>();
		processNameCSMap = new Map<Id, String>();
		Set<Id> ownerIds = new Set<Id>();
		String casoATipificarRtId = XappiaHelper.getRecordType('Case', 'Caso_a_tipificar').Id;

		for (Case aCase : cases) {
			ownerIds.add(aCase.OwnerId);
		}
		// hago la query sobre Group especificamente ya que la query sobre Case no me trae el Owner.Name
		ownersMap = new Map<Id, Group>([
			SELECT Id, DeveloperName
			FROM Group
			WHERE Id IN :ownerIds
		]);
		// guardo la configuracion personalizada correspondiente a cada Caso en un mapa
		for (Case aCase : cases) {
			if(aCase.RecordTypeId != casoATipificarRtId) {
				processNameCSMap.put(aCase.Id, aCase.FormulatiempoSLA__c);
			}
			else {
				processNameCSMap.put(aCase.Id, 'Asignación del caso');
			}
		}

		Set<Id> idsAccounts = new Set<Id>();
		Set<String> nameSlaProcesses = new Set<String>();

		for (Case aCase : cases) {
			//SlaProcessByCase__c config = processNameCSMap.get(aCase.Id);
			String config = processNameCSMap.get(aCase.Id);

			// si el caso no tiene cuenta, no se le puede setear proceso de asignacion (SLA)
			if (config == null || String.isBlank(aCase.AccountId)) {
				continue;
			}
			idsAccounts.add(aCase.AccountId);
			nameSlaProcesses.add(config);
		}

		Map<Id, List<Entitlement>> entitlementsByAccount = new Map<Id, List<Entitlement>>();
		for (Entitlement accountEntitlement : [
				SELECT Id, AccountId, SLAProcessId, SlaProcess.Name
				FROM Entitlement
				WHERE AccountId IN: idsAccounts
				AND SlaProcess.Name IN :nameSlaProcesses
		]) {
			if (!entitlementsByAccount.containsKey(accountEntitlement.AccountId)) {
				entitlementsByAccount.put(accountEntitlement.AccountId, new Entitlement[] {});
			}
			entitlementsByAccount.get(accountEntitlement.AccountId).add(accountEntitlement);
		}

		List<Case> casesToCreateEntitlement = new List<Case>();
		for (Case aCase : cases) {
			String config = processNameCSMap.get(aCase.Id);

			if (config == null || String.isBlank(aCase.AccountId)) {
				aCase.EntitlementId = null;
				continue;
			}
			List<Entitlement> entitlements = entitlementsByAccount.get(aCase.AccountId);
			if (entitlements == null) {
				casesToCreateEntitlement.add(aCase);
				continue;
			}

			for (Entitlement accountEntitlement : entitlements) {
				if (accountEntitlement.SlaProcess.Name == config
					&& aCase.EntitlementId != accountEntitlement.Id
				) {
					aCase.EntitlementId = accountEntitlement.Id;
					break;
				}
			}

			if (String.isBlank(aCase.EntitlementId)) {
				casesToCreateEntitlement.add(aCase);
			}
		}

		if (!casesToCreateEntitlement.isEmpty()) {
			for (Account cuenta : [
				SELECT Id, LastName
				FROM Account
				WHERE Id IN :idsAccounts
			]) {
				mapAccount.put(cuenta.Id, cuenta);
			}
			createAndAssignEntitlements(casesToCreateEntitlement);
		}
	}

	/**
	* @description Inserta un Entitlement para cada caso y actualiza el caso
	* @param cases 
	*/ 
	public static void createAndAssignEntitlements(List<Case> cases) {
		Map<String, SlaProcess> SlaProcessMap = new Map<String, SlaProcess>();
		for (SlaProcess slap : [
									SELECT Id, Name
									FROM SlaProcess
										WHERE SobjectType = 'Case'
										AND IsActive = true
								]){			
			SlaProcessMap.put(slap.Name, slap);
		}

		List<Entitlement> newEntitlements = new List<Entitlement>();
		Map<String, Entitlement> entitlementsByAccountAndSLA = new Map<String, Entitlement>();

		for (Case aCase : cases) {
			String config = processNameCSMap.get(aCase.Id);

			String newEntitlementKey = aCase.AccountId + '-' + config;

			if (entitlementsByAccountAndSLA.containsKey(newEntitlementKey)) {
				continue;
			}

			if(SlaProcessMap.get(config) != null){
				Entitlement newEntitlement = new Entitlement();
				newEntitlement.AccountId = aCase.AccountId;
				newEntitlement.SlaProcessId = SlaProcessMap.get(config).Id;
				newEntitlement.Name = config + ' ' + mapAccount.get(aCase.AccountId).LastName;
				newEntitlement.StartDate = Date.today();
				newEntitlements.add(newEntitlement);
				entitlementsByAccountAndSLA.put(newEntitlementKey, newEntitlement);
			}
		}
		insert newEntitlements;

		for(Case aCase : cases){
			String config = processNameCSMap.get(aCase.Id);
			String newEntitlementKey = aCase.AccountId + '-' + config;
			if(entitlementsByAccountAndSLA.get(newEntitlementKey) != null){
				aCase.EntitlementId = entitlementsByAccountAndSLA.get(newEntitlementKey).Id;
			}
		}
	}

	//public static void reopenSLA(List<Case> cases) {
	public static void reopenSLA(Map<Id, Case> cases) {
		CaseMilestone[] milestonesToUpdate = new List<CaseMilestone>();

		for(Case aCase : [
			SELECT Id, (
				SELECT Id, IsCompleted, CompletionDate, MilestoneType.Name 
				FROM CaseMilestones 
				ORDER BY CreatedDate DESC
			)
			FROM Case 
			WHERE Id IN : cases.keySet()
		]) {
			//se podria usar el MilestoneType.Name para saber si coincide con FormulatiempoSLA__c y reabrir ese
			if(!aCase.CaseMilestones.isEmpty() && aCase.CaseMilestones[0].IsCompleted) {
				aCase.CaseMilestones[0].CompletionDate = null;
				Case caseFromMap = cases.get(aCase.Id);
				caseFromMap.SLAcerrado__c = false;

				milestonesToUpdate.add(aCase.CaseMilestones[0]);
			}
		}

		update milestonesToUpdate;
	}

}