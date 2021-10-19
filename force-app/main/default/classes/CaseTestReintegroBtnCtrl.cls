public class CaseTestReintegroBtnCtrl  {

	@AuraEnabled
	public static String getReintegroRT() {
		return XappiaHelper.getRecordType('Case', 'Reintegro').Id;
	}
	
	@AuraEnabled
	public static Response testReintegro(String data) {
		Data datos = (Data)JSON.deserialize(data, Data.class);
		System.debug(datos.fecha); //yyyy-MM-dd

		List<Account> asociado = [
			SELECT Codigo_de_Afiliado__c, Modelo_Plan_Nombre__c, Plan_Nombre__c FROM Account WHERE Id =: datos.asociado
		];
		List<Medicamento__c> medicamento = [SELECT Codigo_medicamento__c FROM Medicamento__c WHERE Id =: datos.medicamento];
		List<Nomenclador_de_Prestacion__c> prestacion = [
			SELECT Codigo__c FROM Nomenclador_de_Prestacion__c WHERE Id =: datos.prestacion
		];
		
		Response validaciones = validations(datos, asociado, medicamento, prestacion);
		if(validaciones.hasError) {
			return validaciones;
		}

		String body = generateJson(datos, asociado, medicamento, prestacion);
		WSCaseTestReintegro.Response resp = WSCaseTestReintegro.testReintegro(body);

		if(!resp.hasError) {
			return new Response(false, 'ok', resp.result.data, asociado[0].Plan_Nombre__c, asociado[0].Modelo_Plan_Nombre__c);
		}

		return new Response(true, resp.message, null, null, null);
	}

	private static Response validations(
										Data datos, 
										List<Account> asociado, 
										List<Medicamento__c> medicamento, 
										List<Nomenclador_de_Prestacion__c> prestacion
	) {
		String errors = '';

		if(String.isEmpty(datos.asociado)) {
			errors += '- El asociado está vacío.\n';
		}
		if(datos.tipo == 'prestacion' && String.isEmpty(datos.prestacion)) {
			errors += '- La prestacion está vacía.\n';
		}
		if(datos.tipo == 'medicamento' && String.isEmpty(datos.medicamento)) {
			errors += '- El medicamento está vacío.\n';
		}

		if(String.isEmpty(errors)) {
			return new Response(false, null, null, null, null);
		} 

		return new Response(true, errors, null, null, null);
	}

	private static String generateJson(
										Data datos, 
										List<Account> asociado, 
										List<Medicamento__c> medicamento, 
										List<Nomenclador_de_Prestacion__c> prestacion
	) {
		String jsonString;
		Map<String,Object> jsonMap = new Map<String, Object> {
			'contexto' => datos.contexto,
			'codigo_afiliado' => asociado[0].Codigo_de_Afiliado__c	
		};

		if(datos.fecha != null) {
			jsonMap.put('fecha', String.valueOf(datos.fecha));
		}

		if(datos.tipo == 'prestacion') {
			jsonMap.put('prestacion', prestacion[0].Codigo__c);
		} else if(datos.tipo == 'medicamento') {
			jsonMap.put('medicamento', medicamento[0].Codigo_medicamento__c);
		}
		
		jsonString = JSON.serialize(jsonMap);
		
		return jsonString;
	}

	public class Data {
		@AuraEnabled public String prestacion {get;set;} 
		@AuraEnabled public String medicamento {get;set;} 
		@AuraEnabled public String fecha {get;set;} 
		@AuraEnabled public String contexto {get;set;} 
		@AuraEnabled public String asociado {get;set;}
		@AuraEnabled public String tipo {get;set;}
		 
	
		//public Data(String asociado, String medicamento, String prestacion, String fecha, String contexto, String tipo) {
            //this.asociado = asociado;
			//this.medicamento = medicamento;
            //this.prestacion = prestacion;
			//this.fecha = fecha;
			//this.contexto = contexto;
			//this.tipo = tipo;
        //}
	}

	public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
		@AuraEnabled public WSCaseTestReintegroResp.Data data;
		@AuraEnabled public String plan;
		@AuraEnabled public String modeloPlan;

        public Response(Boolean hasError, String message, WSCaseTestReintegroResp.Data data, String plan, String modeloPlan) {
            this.hasError = hasError;
            this.message = message;
			this.data = data;
			this.plan = plan;
			this.modeloPlan = modeloPlan;
        }
	}

}