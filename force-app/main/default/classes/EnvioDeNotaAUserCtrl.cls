public class EnvioDeNotaAUserCtrl  {
	@AuraEnabled
	public static Response envioNota(Id ap_id){
		List<String> emails = new List<String>();

		if(ap_id == null){
			return new Response(true,'Debe tener un Caso asociado.');
		}

		Case ap = [
			SELECT Id, CreatedById, Evento_Medico__c
			FROM Case 
			WHERE Id = :ap_id
		];

		User propietario = [
			SELECT Id, Email, Codigo_delegacion__c 
			FROM User 
			WHERE Id = :ap.CreatedById
		];

		if(!String.isBlank(propietario.Email)) {
			emails.add(propietario.Email); 
		 }

		List<Account> delegacion = [
			SELECT Id, Codigo_de_delegacion__c, Correo_electronico__c 
			FROM Account 
			WHERE Codigo_de_delegacion__c = :propietario.Codigo_delegacion__c
		];

		if(!delegacion.isEmpty()){
			if (!String.isBlank(delegacion.get(0).Correo_electronico__c)){
				emails.add(delegacion.get(0).Correo_electronico__c);
			}
		}
		System.debug('****ap.Id: ' + ap.Id);
		System.debug('****ap.Evento_Medico__c: ' + ap.Evento_Medico__c);
		List<Nota_de_Auditoria__c> notas = [
			SELECT Id, Nota__c 
			FROM Nota_de_Auditoria__c 
			WHERE Tipo_nota_de_Auditoria__r.Codigo_tipoNA__c = 'NOT_COB_PROT' 
				AND (
					APr_Id__c = :ap.Id
						OR Evento_Medico_Id__c =: ap.Evento_Medico__c
				)
		];

		if(notas.isEmpty()){
			return new Response(true,'Nota de auditoria COB_PROT inexistente');
		}

		Orden_de_Compra__c orden = [
			SELECT Id, Estado_OC__c
			FROM Orden_de_Compra__c
			WHERE Caso__c = :ap_id
		];		

		EmailUtils.MailResponse resp = EmailUtils.sendMailWithTemplate(emails,orden.Id,'Sol_de_preinscripcion');

		orden.Estado_OC__c = 'Diferencia Socio';
		update orden;

		return new Response(resp.hasError,resp.message);
	}

	public class Response{
		@AuraEnabled public String message;
		@AuraEnabled public Boolean hasError;

		public Response(Boolean err,String msg){
			this.message = msg;
			this.hasError = err;
		}
	}
}