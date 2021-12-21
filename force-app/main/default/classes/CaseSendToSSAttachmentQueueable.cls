public class CaseSendToSSAttachmentQueueable implements Queueable, Database.AllowsCallouts {
    String recordId;
    public CaseSendToSSAttachmentQueueable(String recordId) {
        this.recordId = recordId;
    }
    public void execute(QueueableContext context) {
        CaseSendToSSGenericBtnCtrl.Response res = CaseSendToSSGenericBtnCtrl.sendToSS(recordId, true);
    }
}