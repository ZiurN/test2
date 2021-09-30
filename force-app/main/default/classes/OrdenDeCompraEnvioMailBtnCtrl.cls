public class OrdenDeCompraEnvioMailBtnCtrl  {
	
	@AuraEnabled
	public static Response sendAttachmentsToAllPrest(Id ocId){
		List<Cotizacion_Prestador__c> cotizaciones = [
			SELECT Id, Prestador__r.Correo_electronico__c, Prestador__r.Localidad_new__r.Nombre_de_Localidad__c
			FROM Cotizacion_Prestador__c
			WHERE  Orden_de_Compra__c = :ocId
		];

		User usuarioActual = [
			SELECT Id, Organizacion__c, Email
			FROM User
			WHERE Id = :UserInfo.getUserId()
		];

		Orden_de_Compra__c orden = [
			SELECT Id, Caso__c, Caso__r.Evento_Medico__c, Caso__r.ParentId, Estado_OC__c,Caso__r.Account.Codigo_de_Afiliado__c,
			Caso__r.Account.Name,Caso__r.Evento_Medico__r.Fecha_y_Hora_inicio_EMS__c,Caso__r.Fecha__c,Caso__r.Type
			FROM Orden_de_Compra__c
			WHERE Id = :ocId
		];

		if(cotizaciones.isEmpty()){
			return new Response(true, 'La orden de compra no tiene ninguna cotización');
		}

		orden.Estado_OC__c = 'Pedido Cotizacion';
		update orden;
		Id caseId = orden.Caso__r.ParentId != null ? orden.Caso__r.ParentId : orden.Caso__c;
		ContentDocumentLink[] linksCaso = [
			SELECT ContentDocumentId
			FROM ContentDocumentLink
			WHERE LinkedEntityId = :caseId
		];


		List<Id> docIdsCaso = new List<Id>();
		List<Id> docIdsEM = new List<Id>();

		for(ContentDocumentLink link : linksCaso){
			docIdsCaso.add(link.ContentDocumentId);
		}

		

		ContentVersion[] versionsCaso = [
			SELECT Id,VersionData, FileExtension
			FROM ContentVersion
			WHERE ContentDocumentId IN :docIdsCaso
			AND Title LIKE '%PRESCRI%'
		];
		ContentVersion[] versionsEM = new List<ContentVersion>();
		if(orden.Caso__r.Evento_Medico__c != null){
			ContentDocumentLink[] linksEM = [
				SELECT ContentDocumentId
				FROM ContentDocumentLink
				WHERE LinkedEntityId = :orden.Caso__r.Evento_Medico__c
			];
			for(ContentDocumentLink link : linksEM){
				docIdsEM.add(link.ContentDocumentId);
			}
			versionsEM = [
			SELECT Id,VersionData, FileExtension
			FROM ContentVersion
			WHERE ContentDocumentId IN :docIdsEM
			AND Title LIKE '%PRESCRI%'
		];
		}

		if(versionsCaso.isEmpty() && versionsEM.isEmpty()){
			return new Response(true, 'No se encontro ningun adjunto que contenga PRESCRI');
		}

		EmailUtils.MailResponse resp;
		List<String> errores = new List<String>();

		for(Cotizacion_Prestador__c cot : cotizaciones){
			
			String replyTo;
			String subject;
			String fecha;
			List<String> emailList = new List<String>();

			emailList.add(usuarioActual.Email);
			emailList.add(cot.Prestador__r.Correo_electronico__c);

			if(orden.Caso__r.Evento_Medico__c != null){
                System.debug('Entra al em ' + orden.Caso__r.Evento_Medico__r.Fecha_y_Hora_inicio_EMS__c);
				fecha = String.valueOf(orden.Caso__r.Evento_Medico__r.Fecha_y_Hora_inicio_EMS__c);
			}else{
				fecha = String.valueOf(orden.Caso__r.Fecha__c);
			}

			if(orden.Caso__r.Type == 'Prestacion'){
				replyTo = 'cotizaciones_interior@avalian.com';
				subject = 'Avalian - Cotizar - '+ orden.Caso__r.Account.Name +' - CX - '+ fecha + cot.Prestador__r.Localidad_new__r.Nombre_de_Localidad__c;
			}
			if(orden.Caso__r.Type == 'Medicamento'){
				replyTo = 'cotizaciones_medicamentos@avalian.com';
				subject = 'Avalian - Cotizar - '+ orden.Caso__r.Account.Name +' - ' + orden.Caso__r.Account.Codigo_de_Afiliado__c;
			}
			if(!versionsCaso.isEmpty()){
				resp = EmailUtils.sendMailWithAttachment(emailList,
				versionsCaso[0].VersionData,'Prescripcion.' + versionsCaso[0].FileExtension,cot.Id,'Solicitud_de_cotizacion',replyTo);
				if(resp.hasError){
					errores.add(resp.message);
				}
			}
			else{
				resp =EmailUtils.sendMailWithAttachment(emailList,
				versionsEM[0].VersionData,'Prescripcion.' + versionsEM[0].FileExtension,cot.Id,'Solicitud_de_cotizacion',replyTo);
			}
		}
		if(errores.size() == cotizaciones.size()){
			return new Response(true,'Falló el envio de mails.');
		}
		else if(errores.size() > 0 && errores.size() > cotizaciones.size()){
			return new Response(false,'Falló el envio de' + errores.size() + ' mails.');
		}
		else{
			return new Response(false, 'Se realizó el envío de mails');
		}
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;

		public Response(Boolean hasError, String message){
			this.hasError = hasError;
			this.message = message;
		}
	}  
}