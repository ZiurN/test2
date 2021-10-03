public class ReingresoBtnCtrl  {
	@AuraEnabled
	public static Response assingTo(String accId) {
	// LLamar al WS domicilios de asociado, obtener el codigo postal y con eso obtener el codigo de localidad de otro WS que 
	// aun no esta, al obtener la localidad, buscar el organizador asociado a ella(custom field) y
	// Al crear la oportunindad asignarle el organizador al OwnerId
		Account acc = [
			SELECT Estado__c, Fecha_vigencia__c, Edad__c, Afi_Id__c, Name, Empresa__c
			FROM Account
			WHERE Id =: accId
		];
		//User usuario = [SELECT Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
		String recordTypeIndividuos = XappiaHelper.getRecordType('Opportunity', 'Individuos').Id;
		//String recordTypeIndCorp = XappiaHelper.getRecordType('Opportunity', 'Individual_Corporativo').Id;
		//// llamar al WS para saber si tiene deuda o no -------------------
		////WSAsociadoGetCuentaCorrienteResp 
		//WSAsociadoGetCuentaCorriente.Response resp = WSAsociadoGetCuentaCorriente.getAsociadoCuentaCorriente(
			//acc.Afi_Id__c);
		//if(resp.hasError) {
			//return new Response(true, 'No se puede obtener la deuda del asociado', recordTypeIndividuos, null, null);
		//}
		//Boolean hasNotDeuda = resp.asociadoCuentaCorriente.data.cuenta_corriente.detallesAfi.size() == 0; 

		//WSAsociadoGetDomicilios.Response respDomicilio = WSAsociadoGetDomicilios.getAsociadoDomicilios(
			//acc.Afi_Id__c);
		//if(respDomicilio.hasError) {
			//return new Response(true, 'No se puede obtener el domicilio del asociado', recordTypeIndividuos, null, null);
		//}
		
		//List<Localidad__c> localidadesList = new List<Localidad__c>();
		
		//if(respDomicilio.asociadoDomicilios.data.size() >= 1) {
			//localidadesList = [
				//SELECT Id, Codigo_Postal__c, Organizador_lookup__c 
				//FROM Localidad__c 
				//WHERE Codigo_Postal__c =: respDomicilio.asociadoDomicilios.data[0].codigo_postal
			//];
		//}
		//String organizador = localidadesList.size() >= 1 ? localidadesList[0].Organizador_lookup__c : null;
		//----------------------------------------------------------------
		//Boolean salesProfile = usuario.Profile.Name == 'Agente de Ventas' || usuario.Profile.Name == 'Lider de Ventas';
		//Boolean assignToSales = salesProfile
				//|| (
						//acc.Estado__c == 'Dado de baja' 
						//&& (System.today().daysBetween(acc.Fecha_vigencia__c) <= -335) 
						//&& hasNotDeuda 
						//&& acc.Edad__c < 61
					//);

		//if(assignToSales) {
			//return new Response(false, 'Ventas', recordTypeIndividuos, organizador, acc.Name);
		//}
		
		String profileId = UserInfo.getProfileId();
    	Profile profile = [SELECT Id, Name FROM Profile WHERE Id =:profileId];

		return new Response(false, 'Servicio', recordTypeIndividuos, null, acc.Name,profile.Name);
		
		
	}

	 public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
		@AuraEnabled public String recordTypeIndividuos;
		@AuraEnabled public String organizador;
		@AuraEnabled public String nombre;
        @AuraEnabled public String profile;

        public Response(Boolean hasError, String message, String recordTypeIndividuos, String organizador, String nombre,String profile) {
            this.hasError = hasError;
            this.message = message;
			this.recordTypeIndividuos = recordTypeIndividuos;
			this.organizador = organizador;
			this.nombre = nombre;
            this.profile = profile;
        }
    }
}