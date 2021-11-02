@isTest
private class CoberturaEspecialTriggerTest {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseError;
	static Cobertura_Especial__c cobertura;
	static Evento_medico__c em;
	static {
		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSCoberturaEspecialEnviarMock.getFound())
			.addForAddress(WSCoberturaEspecialEnviar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/276349/coberturas-especiales');
		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
			.withStatus('Error')
			.withStatusCode(422)
			.withBody(WSCoberturaEspecialEnviarMock.getError())
			.addForAddress(WSCoberturaEspecialEnviar.SERVICE_CONFIG.URL__c + '/v1/salud/eventos-medicos/276349/coberturas-especiales');
		em = new Evento_medico__c();
		em.RecordTypeId = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
		em.Nro_de_Evento_Medico_SS__c = '276349';
		insert em;
		cobertura = new Cobertura_Especial__c();
		cobertura.Evento_Medico_de_Seguimiento__c = em.Id;
		cobertura.Fecha_desde__c = Date.today().addDays(-7);
	}
	@isTest
	private static void whenACoberturaIsCreatedWithValidFields_ItShouldSendToSSAndFillTheCorrespondingFields() {
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		insert cobertura;
		Test.stopTest();
		cobertura = [SELECT Error_en_SS__c, Fecha_de_error_en_SS__c, Id_externo__c FROM Cobertura_Especial__c WHERE Id =: cobertura.Id];
		System.assertEquals('191769', cobertura.Id_externo__c, 'El id externo debe ser 191769');
		System.assertEquals(null, cobertura.Error_en_SS__c, 'El error debe ser null');
		System.assertEquals(null, cobertura.Fecha_de_error_en_SS__c, 'La fecha del error debe ser null');
	}
	@isTest
	private static void whenACoberturaIsCreatedWithInvalidFields_ItShouldFailsSendToSSAndFillTheCorrespondingFields() {
		Test.setMock(HttpCalloutMock.class, getResponseError);
		Test.startTest();
		insert cobertura;
		Test.stopTest();
		cobertura = [SELECT Error_en_SS__c, Fecha_de_error_en_SS__c, Id_externo__c
					FROM Cobertura_Especial__c
					WHERE Id = :cobertura.Id];
		String msg = 'ERROR AL CARGAR COBERTURA. Hay solapamiento de rangos:';
		System.assertEquals(null, cobertura.Id_externo__c, 'No se debio generar id externo');
		System.assert(cobertura.Error_en_SS__c.contains(msg), 'El mensaje debe indicar el error');
		System.assertNotEquals(null, cobertura.Fecha_de_error_en_SS__c, 'La fecha del error no puede ser nula');
	}
	@isTest
	private static void whenACoberturaIsUpdatedAndIdExternoIsEmpty_ItShouldSendToSSAndFillTheCorrespondingFields() {
		cobertura.Tipo__c = 'Monodroga';
		insert cobertura;
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		cobertura.Id_externo__c = null;
		update cobertura;
		Test.stopTest();
		cobertura = [SELECT Error_en_SS__c, Fecha_de_error_en_SS__c, Id_externo__c FROM Cobertura_Especial__c WHERE Id =: cobertura.Id];
		System.assertEquals('191769', cobertura.Id_externo__c, 'El id externo debe ser 191769');
		System.assertEquals(null, cobertura.Error_en_SS__c, 'El error debe ser null');
		System.assertEquals(null, cobertura.Fecha_de_error_en_SS__c, 'La fecha del error debe ser null');
	}
	@isTest
	private static void whenACoberturaIsUpdatedWithValidFields_ItShouldSendToSSAndFillTheCorrespondingFields() {
		Consultorio__c consultorio = new Consultorio__c();
		insert consultorio;
		Forma__c forma = new Forma__c();
		insert forma;
		Account prestadorProfesional = Build.anAccountEfector().build();
		prestadorProfesional.Es_Prestador__c = true;
		prestadorProfesional.Es_Profesional__c = true;
		prestadorProfesional.Estado__c = 'A';
		insert prestadorProfesional;
		cobertura.Id_externo__c = '191769';
		insert cobertura;
		cobertura.Dependencia__c = 'V';
		cobertura.Marca_Domingo__c =  'V';
		cobertura.Marca_Sabado__c = 'V';
		cobertura.Marca_Viernes__c = 'V';
		cobertura.Marca_Jueves__c = 'V';
		cobertura.Marca_Miercoles__c = 'V';
		cobertura.Marca_Martes__c = 'V';
		cobertura.Marca_Lunes__c = 'V';
		cobertura.Consultorio__c = consultorio.Id;
		cobertura.Prestador__c = prestadorProfesional.Id;
		cobertura.Integracion__c = 'V';
		cobertura.Potencia__c = 'test';
		cobertura.Por_comprimido__c = '5';
		cobertura.Forma__c = forma.Id;
		cobertura.Fecha_hasta__c = Date.today();
		cobertura.Tope_Anual__c = 5;
		cobertura.Tope_Mensual__c = 5;
		cobertura.Tope_Semanal__c = 5;
		cobertura.Valor__c = 5;
		cobertura.Prioridad__c = '5';
		cobertura.Incluye_Excluye__c = 'I';
		cobertura.Tipo_de_Copago__c = 'F';
		cobertura.Prescriptor__c = prestadorProfesional.Id;
		cobertura.Efector__c = prestadorProfesional.Id;
		cobertura.Fecha_desde__c = Date.today();
		cobertura.tipo__c = 'Nomenclador';
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		Test.startTest();
		update cobertura;
		Test.stopTest();
		cobertura = [SELECT Error_en_SS__c, Fecha_de_error_en_SS__c, Id_externo__c FROM Cobertura_Especial__c WHERE Id =: cobertura.Id];
		System.assertEquals('191769', cobertura.Id_externo__c, 'El id externo debe ser 191769');
		System.assertEquals(null, cobertura.Error_en_SS__c, 'El error debe ser null');
		System.assertEquals(null, cobertura.Fecha_de_error_en_SS__c, 'La fecha del error debe ser null');
		System.assertEquals(2, getResponseFound.callsMade, 'Deben haber dos llamados hechos');
	}
	@isTest
	private static void whenACoberturaIsAlreadyInSS_ItCantBeDeletedOnSF() {
        cobertura.Id_externo__c = '191769';
		insert cobertura;
        Test.startTest();
        Database.DeleteResult result = Database.delete(cobertura, false);
        Test.stopTest();
		System.assert(!result.isSuccess(), 'El resultado no debe ser exitoso');
		System.assertEquals(System.Label.Error_NoPuedeEliminarCoberturaEnviadaSS, result.getErrors()[0].getMessage(), 'El mensaje debe indicar que la cobertura no se puede eliminar');
    }
}