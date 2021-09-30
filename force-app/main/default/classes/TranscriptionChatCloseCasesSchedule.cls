global class TranscriptionChatCloseCasesSchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new TranscriptionChatCloseCasesQueueable(), 1000);
    }
}