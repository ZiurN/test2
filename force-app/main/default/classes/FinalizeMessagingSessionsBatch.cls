global class FinalizeMessagingSessionsBatch implements Database.Batchable<SObject> {
	
	global FinalizeMessagingSessionsBatch() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext context) {
		String clausule = 'SELECT Id, MessagingEndUserId, CreatedDate ' +
						'FROM MessagingSession ' +
						'WHERE Status = \'Waiting\'';
		String olderThan = ' AND CreatedDate < ';
		
		DateTime dt = DateTime.now().addHours(-24);
		//DateTime dt = DateTime.now().addMinutes(-5);
		String dtString = dt.formatGmt('yyyy-MM-dd HH:mm:ss');
		String theDate = dtString.substring(0, 10);
		String theHour = dtString.substring(11, 19);


		String query = clausule + olderThan + theDate + 'T' + theHour + 'Z';
		System.debug('la query es: ' + query);
		
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext context, List<MessagingSession> scope) {
		System.debug(scope);
		
		//MessagingSession[] sessionsToUpdate = new List<MessagingSession>();
		Set<MessagingEndUser> endUsersToUpdateSet = new Set<MessagingEndUser>();

		for(MessagingSession ms : scope) {
			MessagingEndUser meu = new MessagingEndUser(Id = ms.MessagingEndUserId);
			meu.MessagingConsentStatus = 'OptedOut';

			//sessionsToUpdate.add(ms);
			endUsersToUpdateSet.add(meu);
		}

		MessagingEndUser[] endUsersToUpdate = new List<MessagingEndUser>(endUsersToUpdateSet);
		//update sessionsToUpdate;
		Database.SaveResult[] results = Database.update(endUsersToUpdate, false);
		System.debug('****results: ' + results);
	}
	
	global void finish(Database.BatchableContext context) {
		
	}
}