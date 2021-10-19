@isTest
private class TranscriptionChatCloseCasesTest {

    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    @isTest
    private static void WhenBatchExecutesBatchShouldCloseCasesOnlyWhenChatIsOnlyBot() {
        Id casoATipificar = [SELECT idtipoderegistro__c FROM Tipo_de_registro__mdt WHERE DeveloperName = 'caso_a_tipificar'].idtipoderegistro__c;

        Case cs = new Case(
            Subject = 'Test Case',
            RecordTypeId = casoATipificar,
            Status = 'En proceso'
        );

        insert cs;

        LiveChatVisitor visitor = new LiveChatVisitor();

        insert visitor;

        LiveChatTranscript tx = new LiveChatTranscript(
            CaseId = cs.Id,
            liveChatVisitorId = visitor.id
        );

        insert tx;

        LiveChatTranscriptEvent event = new LiveChatTranscriptEvent();
        event.LiveChatTranscriptId = tx.Id;
        event.Time = datetime.now();
        event.Type = 'ChatRequest';

        insert event;

        tx.Status = 'Completed';
        update tx;

        Test.startTest();
        Database.executeBatch(new TranscriptionChatCloseCasesQueueable(),1000);
        Test.stopTest();

        System.assertEquals('Cerrado', [SELECT Status FROM Case WHERE id = :cs.Id LIMIT 1].Status, 'El caso no se esta cerrando!');
    }

    @isTest
    private static void WhenSchedulableExecutesBatchShouldCloseCasesOnlyWhenChatIsOnlyBot() {
        Id casoATipificar = [SELECT idtipoderegistro__c FROM Tipo_de_registro__mdt WHERE DeveloperName = 'caso_a_tipificar'].idtipoderegistro__c;

        Case cs = new Case(
            Subject = 'Test Case',
            RecordTypeId = casoATipificar,
            Status = 'En proceso'
        );

        insert cs;

        LiveChatVisitor visitor = new LiveChatVisitor();

        insert visitor;

        LiveChatTranscript tx = new LiveChatTranscript(
            CaseId = cs.Id,
            liveChatVisitorId = visitor.id
        );

        insert tx;

        LiveChatTranscriptEvent event = new LiveChatTranscriptEvent();
        event.LiveChatTranscriptId = tx.Id;
        event.Time = datetime.now();
        event.Type = 'ChatRequest';

        insert event;

        tx.Status = 'Completed';
        update tx;
        
        TranscriptionChatCloseCasesSchedule TCCCQ = new TranscriptionChatCloseCasesSchedule();

        Test.startTest();
        System.schedule('CloseCases', CRON_EXP, TCCCQ );
        TCCCQ.execute(null);

        Test.stopTest();

        System.assertEquals('Cerrado', [SELECT Status FROM Case WHERE id = :cs.Id LIMIT 1].Status, 'El caso no se esta cerrando!');
    }
}