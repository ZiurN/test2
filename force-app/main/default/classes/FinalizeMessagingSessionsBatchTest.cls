@isTest 
private class FinalizeMessagingSessionsBatchTest {
	static MessagingChannel mc;
	static MessagingChannel mc2;

	static {
		mc = new MessagingChannel();
		mc.DeveloperName = 'WhatsApp_AR_whatsapp_5491199999999';
		mc.MasterLabel = 'Whatsapp-+5491199999999';
		mc.MessagingPlatformKey = 'whatsapp:+5491199999999';
		mc.MessageType = 'WhatsApp';
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert mc;
		}

		mc2 = new MessagingChannel();
		mc2.DeveloperName = 'WhatsApp_AR_whatsapp_5491100000000';
		mc2.MasterLabel = 'Whatsapp-+5491100000000';
		mc2.MessagingPlatformKey = 'whatsapp:+5491100000000';
		mc2.MessageType = 'WhatsApp';
		System.runAs(new User(Id = UserInfo.getUserId())) {
			insert mc2;
		}

	}

	@isTest
	private static void whenMoreThan24HoursPassUnsuscribeTheMessagingEndUserToFinalizeTheSession() {
		MessagingEndUser meu = new MessagingEndUser();
		meu.MessagingChannelId = mc.Id;
		meu.Name = 'meu test';
		meu.MessagingConsentStatus = 'ImplicitlyOptedIn';
		meu.MessageType = 'WhatsApp';
		meu.MessagingPlatformKey = 'whatsapp:+5491155555555';
		insert meu;

		MessagingEndUser meu2 = new MessagingEndUser();
		meu2.MessagingChannelId = mc.Id;
		meu2.Name = 'meu2 test2';
		meu2.MessagingConsentStatus = 'ImplicitlyOptedIn';
		meu2.MessageType = 'WhatsApp';
		meu2.MessagingPlatformKey = 'whatsapp:+5491155555552';
		insert meu2;

		MessagingEndUser meu3 = new MessagingEndUser();
		meu3.MessagingChannelId = mc.Id;
		meu3.Name = 'meu3 test2';
		meu3.MessagingConsentStatus = 'ImplicitlyOptedIn';
		meu3.MessageType = 'WhatsApp';
		meu3.MessagingPlatformKey = 'whatsapp:+5491155555553';
		insert meu3;

		MessagingSession ms = new MessagingSession(); 
		ms.MessagingEndUserId = meu.Id;
		ms.MessagingChannelId = mc.Id;
		ms.Status = 'Waiting';
		insert ms;
		Test.setCreatedDate(ms.Id, System.now().addHours(-25));

		MessagingSession ms2 = new MessagingSession(); 
		ms2.MessagingEndUserId = meu2.Id;
		ms2.MessagingChannelId = mc.Id;
		ms2.Status = 'Waiting';
		insert ms2;
		Test.setCreatedDate(ms2.Id, System.now().addHours(-23));

		MessagingSession ms3 = new MessagingSession(); 
		ms3.MessagingEndUserId = meu3.Id;
		ms3.MessagingChannelId = mc.Id;
		ms3.Status = 'Waiting';
		insert ms3;
		Test.setCreatedDate(ms3.Id, System.now().addHours(-22));

		MessagingSession[] mss = [SELECT CreatedDate FROM MessagingSession WHERE Id IN (:ms.Id, :ms2.Id, :ms3.Id)];
		System.debug(mss);

		Test.startTest();
		FinalizeMessagingSessionsBatch batch = new FinalizeMessagingSessionsBatch();
        Database.executeBatch(batch);
		Test.stopTest();

		MessagingSession msQ = [SELECT Status FROM MessagingSession WHERE Id = :ms.Id];
		System.debug('msQ.Status ' + msQ.Status);

		MessagingEndUser meuFinalized = [SELECT Id, MessagingConsentStatus FROM MessagingEndUser WHERE Id = :ms.MessagingEndUserId];
		System.assertEquals('OptedOut', meuFinalized.MessagingConsentStatus);

		MessagingEndUser[] meusSubscribed = [SELECT Id, MessagingConsentStatus FROM MessagingEndUser WHERE Id != :ms.MessagingEndUserId];
		
		for(MessagingEndUser meuSubscribed : meusSubscribed) {
			System.assertEquals('ImplicitlyOptedIn', meuSubscribed.MessagingConsentStatus);
		}
		
	}
}