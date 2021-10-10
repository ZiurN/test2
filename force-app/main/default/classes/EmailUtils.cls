/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz
@description	Clase para manejar el envío de correos electrónicos.
------------------------------------------------------------------------------------------------------------------------*/
@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class EmailUtils {
	private static Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
	private static MailResponse mailResponse;
	private static List<EmailTemplate> templates = new List<EmailTemplate>();
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@description	Método para enviar correos electrónicos sencillos con las direcciones, el cuerpo y el asunto.
	@param			addresses - Lista de direcciones a las que se envía el correo.
	@param			body - Cuerpo del correo.
	@param			subject - Asunto del correo.
	@return			Un objeto MailResponse para ver el estado final del envío.
	------------------------------------------------------------------------------------------------------------------------*/
	public static MailResponse sendSimpleEmail(List<String> addresses, String body, String subject) {
		if (!validateInputs(addresses, String.isBlank(body))) {
			return mailResponse;
		}
		setBasicEmail(addresses, subject);
		email.setSubject(subject);
		email.setHtmlBody(body);
		return sendEmail();
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@description	Método para enviar correos electrónicos en base a un template classic existente.
	@param			addresses - Lista de direcciones a las que se envía el correo.
	@param			whatId - Necesario para poder usar el template.
	@param			templateName - Nombre del template que se quiere usar.
	@return			Un objeto MailResponse para ver el estado final del envío.
	------------------------------------------------------------------------------------------------------------------------*/
	public static MailResponse sendMailWithTemplate(List<String> addresses, Id whatId, String templateName) {
		if(!validateInputs(addresses, false, templateName)){
			return mailResponse;
		}
		setBasicEmail(addresses, templates[0].Subject);
		email.setTemplateId(templates[0].Id);
		email.setTargetObjectId(UserInfo.getUserId());
		email.setWhatId(whatId);
		email.setSaveAsActivity(false);
		return sendEmail();
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@description	Métodos para enviar correos electrónicos con archivos adjuntos y con template.
	@param			addresses - Lista de direcciones a las que se envía el correo.
	@param			whatId - Necesario para poder usar el template.
	@param			templateName - Nombre del template que se quiere usar.
	@return			Un objeto MailResponse para ver el estado final del envío.
	------------------------------------------------------------------------------------------------------------------------*/
	public static MailResponse sendMailWithAttachment(List<String> addresses, Blob att, String fileName, Id whatId, String templateName, String replyTo) {
		if(!validateInputs(addresses, att == null, templateName)){
			return mailResponse;
		}
		setBasicEmail(addresses, templates[0].Subject);
		email.setTemplateId(templates[0].Id);
		email.setTargetObjectId(UserInfo.getUserId());
		email.setWhatId(whatId);
		email.setSaveAsActivity(false);
		email.setPlainTextBody(templates[0].Body);
		if(String.isNotBlank(replyTo)){
			email.setReplyTo(replyTo);
			email.setCcAddresses(new List<String>{replyTo});
		}
		Messaging.EmailFileAttachment attc = new Messaging.EmailFileAttachment();
		attc.setFileName(fileName);
		attc.setBody(att);
		email.setFileAttachments(new Messaging.EmailFileAttachment[]{attc});
		return sendEmail();
	}
	public static MailResponse sendMailWithAttachment(List<String> addresses, Blob att, String fileName, Id whatId, String templateName, String replyTo, Boolean setGenericSender) {
		if(setGenericSender) {
			OrgWideEmailAddress[] genericEmail = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'AVALIAN'];
			if(genericEmail.size() > 0) {
				email.setOrgWideEmailAddressId(genericEmail[0].Id);
			}
		}
		return sendMailWithAttachment(addresses, att, fileName, whatId, templateName, replyTo);
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@description	Método para enviar correo con los errores de batches
	@param			addresses - Lista de direcciones a las que se envía el correo.
	@param			whatId - Necesario para poder usar el template.
	@param			templateName - Nombre del template que se quiere usar.
	@return			Un objeto MailResponse para ver el estado final del envío.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void sendErrorMail(List<Database.UpsertResult> results,
									List<Database.SaveResult> resultsSave,
									List<Database.DeleteResult> resultsDelete,
									List<String> ids,
									String tipoDeCuenta) {
		Boolean send = false;
		List<String> to = ConfigUtils.getBatchDebugEmails();
		Integer index = 0;
		Boolean hasIds = ids != null && !ids.isEmpty();
		if(to.isEmpty()) {
			to.add('salesforce.alerts@xappia.com');
		}
		setBasicEmail(to, 'Avalian Errores Batch ' + tipoDeCuenta);
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
				row += ids[index] + ', ';}
			row += err.getStatusCode() + ', ' + err.getFields() + ', ' + err.getMessage() + '\n';
			finalstr += row;}
		return finalstr;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@description	Métodos para validar si los datos ingresados permiten el envío del correo.
	@param			addresses - Lista de direcciones a las que se envía el correo.
	@param			secondValidation - Si es necesaria otra validación, se agrega aqui.
	@return			Un booleano indicando si la validación es correcta o no.
	------------------------------------------------------------------------------------------------------------------------*/
	private static Boolean validateInputs (List<String> addresses, Boolean secondValidation) {
		Boolean validation = true;
		if (addresses.isEmpty() || secondValidation){
			mailResponse = new MailResponse(true, System.Label.Email_NoAddressesNoFiles);
			validation = false;
		}
		return validation;
	}
	private static Boolean validateInputs (List<String> addresses, Boolean secondValidation, String templateName) {
		Boolean validation = true;
		if(validateInputs(addresses, secondValidation)){
			templates = getTemplates (templateName);
			if(templates.isEmpty()){
				mailResponse = new MailResponse(true, System.Label.Email_NoTemplate);
				validation = false;
			}
		} else {
			validation = false;
		}
		return validation;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@description	Métodos para validar si los datos ingresados permiten el envío del correo.
	@param			addresses - Lista de direcciones a las que se envía el correo.
	@param			secondValidation - Si es necesaria otra validación, se agrega aqui.
	@return			Un booleano indicando si la validación es correcta o no.
	------------------------------------------------------------------------------------------------------------------------*/
	private static void setBasicEmail (List<String> addresses, String subject) {
		email.setToAddresses(addresses);
		email.setSubject(subject);
	}
	private static List<EmailTemplate> getTemplates (String templateName) {
		return [SELECT Id, Subject, Body FROM EmailTemplate WHERE DeveloperName = :templateName];
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@description	Método que se invoca una vez configurado el correo a envíar, para validar dicho envío.
	@return			Un objeto MailResponse para ver el estado final del envío.
	------------------------------------------------------------------------------------------------------------------------*/
	private static MailResponse sendEmail () {
		try {
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
			return new MailResponse(false, System.Label.Email_NoAddressesNoFiles);
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
}