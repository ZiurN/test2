public class CotizacionPrestadorEnvioMailBtnCtrl  {

	@AuraEnabled
	public static Response sendAttachmentsToPrest(Id cotId){
		Cotizacion_Prestador__c cot = [
			SELECT Id,Prestador__c,Orden_de_Compra__r.Caso__c
			FROM Cotizacion_Prestador__c
			WHERE Id = :cotId
		];
		if(cot.Orden_de_Compra__r.Caso__c == null){
			return new Response(true, 'La orden de compra no tiene un caso asociado');
		}
		Case caso = [
			SELECT Id,Evento_Medico__c, ParentId,Type,Account.Name, Account.Codigo_de_Afiliado__c,
			Evento_Medico__r.Fecha_y_hora_fin_ems__c,Fecha__c	
			FROM Case
			WHERE Id = :cot.Orden_de_Compra__r.Caso__c
		];

		User usuarioActual = [
			SELECT Id, Organizacion__c, Email
			FROM User
			WHERE Id = :UserInfo.getUserId()
		];

        Account prest = [
          SELECT Correo_electronico__c,Localidad_new__r.Nombre_de_Localidad__c
          FROM Account
          WHERE Id = :cot.Prestador__c
        ];
		Id caseToSearch = caso.ParentId != null ? caso.ParentId : caso.Id;
			
		ContentDocumentLink[] linksCaso = [
			SELECT ContentDocumentId
			FROM ContentDocumentLink
			WHERE LinkedEntityId = :caseToSearch
		];


		List<Id> docIdsCaso = new List<Id>();
		List<Id> docIdsEM = new List<Id>();

		for(ContentDocumentLink link : linksCaso){
			docIdsCaso.add(link.ContentDocumentId);
		}

		

		ContentVersion[] versionsCaso = [
			SELECT Id,VersionData,FileExtension
			FROM ContentVersion
			WHERE ContentDocumentId IN :docIdsCaso
			AND Title LIKE '%PRESCRI%'
		];
		ContentVersion[] versionsEM = new List<ContentVersion>();
		if(caso.Evento_Medico__c != null){
			ContentDocumentLink[] linksEM = [
				SELECT ContentDocumentId
				FROM ContentDocumentLink
				WHERE LinkedEntityId = :caso.Evento_Medico__c
			];
			for(ContentDocumentLink link : linksEM){
				docIdsEM.add(link.ContentDocumentId);
			}
			versionsEM = [
			SELECT Id,VersionData,FileExtension
			FROM ContentVersion
			WHERE ContentDocumentId IN :docIdsEM
			AND Title LIKE '%PRESCRI%'
		];
		}

		if(versionsCaso.isEmpty() && versionsEM.isEmpty()){
			return new Response(true, 'No se encontro ningun adjunto que contenga PRESCRI');
		}

		List<String> emailList = new List<String>();

		emailList.add(usuarioActual.Email);
		
		if(prest.Correo_electronico__c != null){
			emailList.add(prest.Correo_electronico__c);
		}

		String replyTo;

		if(caso.Type == 'Prestacion') {
			replyTo = 'cotizaciones_interior@avalian.com';
		}
		if(caso.Type == 'Medicamento') {
			replyTo = 'cotizaciones_medicamentos@avalian.com';
		}

		EmailUtils.MailResponse resp;
		if(!versionsCaso.isEmpty()){
			resp =EmailUtils.sendMailWithAttachment(emailList,versionsCaso[0].VersionData,'Prescripción.' +  versionsCaso[0].FileExtension,cotId,'Solicitud_de_cotizacion', replyTo);
		}
		else{
			resp = EmailUtils.sendMailWithAttachment(emailList,versionsEM[0].VersionData,'Prescripción.' +  versionsEM[0].FileExtension,cotId,'Solicitud_de_cotizacion', replyTo);
		}
		
		
		System.debug(resp);
		return new Response(resp.hasError,resp.message);
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