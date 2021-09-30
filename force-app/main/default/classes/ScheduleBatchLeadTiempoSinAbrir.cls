global class ScheduleBatchLeadTiempoSinAbrir implements Schedulable {
    global void execute(SchedulableContext sc) {

        Database.executeBatch(new LeadTiempoSinAbrirBatch());
    }
}