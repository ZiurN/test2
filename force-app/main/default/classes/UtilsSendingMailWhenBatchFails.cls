public class UtilsSendingMailWhenBatchFails  {
	public static void sendMail(List<Database.UpsertResult> results, String tipoDeCuenta) {
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		Boolean send = false;
        List<String> to = new List<String>();
		Batch_Debug_Mail__mdt debug_mail = ConfigUtils.getDebugEmail('ACA debug mail');
		String mail = debug_mail != null ? debug_mail.Mail__c : 'salesforce.alerts@xappia.com';
		to.add(mail);
        email.setToAddresses(to);
        email.setSubject('ACA Salud Errores Batch ' + tipoDeCuenta);
		String header = 'Status, Mensaje \n';
		String finalstr = header ;
        String htmlBody = '<h3>Se adjuntan los errores: </h3>';
		for (Database.UpsertResult ur : results) {
			if (!ur.isSuccess()) {
				send = true;
				for(Database.Error err : ur.getErrors()) {
					String column = err.getStatusCode() + ', ' + err.getMessage() + '\n';
					finalstr += column;
				}
			}
		}
		Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
		blob csvBlob = Blob.valueOf(finalstr);
		string csvname= 'Errors.csv';
		csvAttc.setFileName(csvname);
		csvAttc.setBody(csvBlob);
		email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        email.setHtmlBody(htmlBody);
		if(send) {
			try {
                //hasError = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email })[0].isSuccess();
				Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            } catch(Exception e) {
				return;
            }
		}
	}
}