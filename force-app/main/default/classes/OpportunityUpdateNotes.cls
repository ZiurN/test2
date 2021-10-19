public without sharing class OpportunityUpdateNotes  {

	public static void updateNotesAndIntegrantes(Opportunity oppFromSF,List<Integrante__c> integrantes , List<Nota_de_Auditoria__c> notasUpdate, List<Nota_de_Auditoria__c> notasInsert){
		List<Database.SaveResult> resultInts = Database.update(integrantes);
		System.debug('****resultInt ' + resultInts);
		Database.SaveResult resultOpp = Database.update(oppFromSF);
		System.debug('****resultOpp ' + resultOpp);
		List<Database.SaveResult> resultsNotasInsert = Database.insert(notasInsert);
		System.debug('****resultNotasInsert ' + resultsNotasInsert);
		List<Database.SaveResult> resultsNotas = Database.update(notasUpdate);
		System.debug('****resultNotas ' + resultsNotas);
	}

	public static void updateIntegrantes(List<Integrante__c> integrantes){
		List<Database.SaveResult> resultInts = Database.update(integrantes,false);
		System.debug('****resultInt ' + resultInts);
	}
}