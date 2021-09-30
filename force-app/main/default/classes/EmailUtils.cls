public class EmailUtils {

    public static MailResponse sendMailWithAttachment(List<String> address, Blob att, String fileName, Id whatId, String templateName,String replyTo) {
        System.debug('Enviando MAIL CON ATTACHMENT!!! a: ' + address);
        System.debug('adjunto: ' + att);
      
        if(address.isEmpty() || att == null){
			return new MailResponse(true, 'Debe haber al menos una direccion de mail y un archivo para adjuntar');
		}
		EmailTemplate[] template = [
			SELECT Id, Name, Subject, Body
			FROM EmailTemplate
			WHERE DeveloperName = :templateName
		];
		if(template.isEmpty()){
			return new MailResponse(true, 'No se encontro una plantilla para el envio de mail');
		}
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(address);
		email.setTemplateId(template[0].Id);
		email.setTargetObjectId(UserInfo.getUserId());
		email.setWhatId(whatId);
		email.setSaveAsActivity(false);
		email.setPlainTextBody(template[0].Body);
		if(String.isNotBlank(replyTo)){
			email.setReplyTo(replyTo);
			email.setCcAddresses(new List<String>{replyTo});
		}
		email.setSubject(template[0].Subject);
        Messaging.EmailFileAttachment attc = new Messaging.EmailFileAttachment();
        attc.setFileName(fileName);
		attc.setBody(att);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{attc});
        try {
            System.debug('****email: ' + email.getToAddresses() + '**** el file: ' + email.getFileAttachments());
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
			return new MailResponse(false, 'Mail enviado');
        } catch(Exception e) {
            return new MailResponse(true,e.getMessage());
        }

    }

	public static MailResponse sendMailWithTemplate(List<String> address, Id whatId, String templateName) {
        if(address.isEmpty()){
			return new MailResponse(true, 'Debe haber al menos una direccion de mail.');
		}
		EmailTemplate[] template = [
			SELECT Id
			FROM EmailTemplate
			WHERE DeveloperName = :templateName
		];
		if(template.isEmpty()){
			return new MailResponse(true, 'No se encontro una plantilla para el envio de mail');
		}
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(address);
		email.setTemplateId(template[0].Id);
		email.setTargetObjectId(UserInfo.getUserId());
		email.setWhatId(whatId);
		email.setSaveAsActivity(false);

        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
			return new MailResponse(false, 'Mail enviado');
        } catch(Exception e) {
            return new MailResponse(true,e.getMessage());
        }

    }

	public static MailResponse sendSimpleEmail(List<String> address, String body,String subject) {
        if(address.isEmpty() || String.isBlank(body)){
			return new MailResponse(true, 'Debe haber al menos una direccion de mail y un archivo para adjuntar');
		}
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(address);
        email.setSubject(subject);
        String htmlBody = body;
        email.setHtmlBody(htmlBody);
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
			return new MailResponse(false, 'Mails enviados correctamente');
        } catch(Exception e) {
            return new MailResponse(true,e.getMessage());
        }

    }


	public class MailResponse{
		public Boolean hasError;
		public String message;

		public MailResponse(Boolean err,String msg){
			hasError = err;
			message = msg;
		}
	}


    public static void sendErrorMail(
			List<Database.UpsertResult> results,
			List<Database.SaveResult> resultsSave, 
			List<Database.DeleteResult> resultsDelete, 
			List<String> ids,
			String tipoDeCuenta
	) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Boolean send = false;
		List<String> to = ConfigUtils.getBatchDebugEmails();
		Integer index = 0;
		Boolean hasIds = ids != null && !ids.isEmpty();

		if(to.isEmpty()) {
			to.add('salesforce.alerts@xappia.com');
		}

        email.setToAddresses(to);
        email.setSubject('Avalian Errores Batch ' + tipoDeCuenta);
        String header = hasIds ? 'Id, ' : '';
		header += 'Status, Mensaje \n';
        String finalstr = header;
        String htmlBody = '<h3>Se adjuntan los errores: </h3>';

		if(results != null) {
			for (Database.UpsertResult ur : results) {
				if (!ur.isSuccess()) {
					send = true;
					finalstr += getCsvRow(ur.getErrors(), ids, hasIds, index);
				}

				index++;
			}
		}
		if(resultsSave != null){
			for (Database.SaveResult ur : resultsSave) {
				if (!ur.isSuccess()) {
					send = true;
					finalstr += getCsvRow(ur.getErrors(), ids, hasIds, index);
				}

				index++;
			}
		}
		if(resultsDelete != null){
			for (Database.DeleteResult ur : resultsDelete) {
				if (!ur.isSuccess()) {
					send = true;
					finalstr += getCsvRow(ur.getErrors(), ids, hasIds, index);
				}

				index++;
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

	private static String getCsvRow(Database.Error[] errors, String[] ids, Boolean hasIds, Integer index) {
		String finalstr = '';

		for(Database.Error err : errors) {
			String row = '';
						
			if(hasIds) {
				row += ids[index] + ', ';
			}
						
			row += err.getStatusCode() + ', ' + err.getFields() + ', ' + err.getMessage() + '\n';
			finalstr += row;
		}
		
		return finalstr;
	}
}