@isTest 
private class CrearNotaDeAuditoriaControllerTest {
	private static final Id NOTA_SERVICES_RT_ID = XappiaHelper.getRecordType('Nota_de_Auditoria__c', 'Service').Id;
	private static final Id NOTA_INTEGRANTE_RT_ID = XappiaHelper.getRecordType('Nota_de_Auditoria__c', 'Integrante').Id;
	private static final Id NOTA_VENTAS_RT_ID = XappiaHelper.getRecordType('Nota_de_Auditoria__c', 'Ventas').Id;
	@isTest
	private static void whenCallingFromCaseReturnCorrectRecordType() {
		Case aCase = new Case();
		aCase.RecordTypeId = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		insert aCase;
		CrearNotaDeAuditoriaController.Response response;
		Test.startTest();
		response = CrearNotaDeAuditoriaController.getRecordTypeId(aCase.Id);
		Test.stopTest();
		System.assert(!response.hasError, 'No debe haber algún error');
		System.assertEquals(NOTA_SERVICES_RT_ID, ((Id)response.data), 'El tipo de registro no es el esperado');
	}
	@isTest
	private static void whenCallingFromEMReturnCorrectRecordType() {
		Evento_medico__c em = new Evento_medico__c();
		insert em;
		CrearNotaDeAuditoriaController.Response response;
		Test.startTest();
		response = CrearNotaDeAuditoriaController.getRecordTypeId(em.Id);
		Test.stopTest();
		System.assert(!response.hasError, 'No debe haber algún error');
		System.assertEquals(NOTA_SERVICES_RT_ID, ((Id)response.data), 'El tipo de registro no es el esperado');
	}
	@isTest
	private static void whenCallingFromIntegranteReturnCorrectRecordType() {
		Integrante_caso__c integrante = Build.anIntegranteCaso().build();
		integrante.Razon_Social__c = 'Test';
		integrante.Cuit_empleador__c = '20414624416';
		insert integrante;
		CrearNotaDeAuditoriaController.Response response;
		Test.startTest();
		response = CrearNotaDeAuditoriaController.getRecordTypeId(integrante.Id);
		Test.stopTest();
		System.assert(!response.hasError, 'No debe haber algún error');
		System.assertEquals(NOTA_INTEGRANTE_RT_ID, ((Id)response.data), 'El tipo de registro no es el esperado');
	}
	@isTest
	private static void whenCallingFromOpportunityReturnCorrectRecordType() {
		Opportunity opp = Build.anOpportunityIndividuos().build();
		insert opp;
		CrearNotaDeAuditoriaController.Response response;
		Test.startTest();
		response = CrearNotaDeAuditoriaController.getRecordTypeId(opp.Id);
		Test.stopTest();
		System.assert(!response.hasError, 'No debe haber algún error');
		System.assertEquals(NOTA_VENTAS_RT_ID, ((Id)response.data), 'El tipo de registro no es el esperado');
	}
	@isTest
	private static void ifObjectNameIsNullReturnError() {
		CrearNotaDeAuditoriaController.Response response;
		Test.startTest();
		response = CrearNotaDeAuditoriaController.getRecordTypeId(null);
		Test.stopTest();
		System.assert(response.hasError, 'Debe haber un error');
		System.assertEquals(null, ((Id)response.data), 'El id debe ser nulo');
	}
	@isTest
	private static void ifCreateNewNotaFromCaseOfTypeAltaFamiliarShouldReturnTypeOfNotaToo (){
		Account delegacion = Build.anAccountDelegacion().withCodigoDeDelegacion('868663').build();
		insert delegacion;
		Account entidad = Build.anAccountEmpresa().build();
		entidad.CUIT__c = '30676863822';
		entidad.Codigo_de_empresa__c = '639506';
		insert entidad;
		Account cuenta = build.anAccount()
			.withAfiIddelTitular(182701)
			.withType('TIT')
			.withCodigodeAfiliado('70332/34')
			.withLastName('Testing182701')
			.withEstado('A')
			.build();
		insert cuenta;
		Account obraSocial = Build.anAccountObrasocial().build();
		insert obraSocial;
		Date fechaNacimiento = Date.newInstance(1990, 05, 01);
		Date fechaVigencia = Date.newInstance(2020, 08, 01);
		Case casoSolicitudAltaFamiliar = Build.aCaseSolicituddealtafamiliar()
			.withDerivaAportes(true)
			.withAporte(5000)
			.withBebeSinDNI(true)
			.withInformacionCompleta(false)
			.withBebeNacidoEnElSistema(true)
			.withInformacionAlAsociado('info')
			.withEstadoDeSolicitud('TRANSFORMADA')
			.withNroDeSolicitudSS('868663')
			.withCuit('20414624416')
			.withCuitEmpleador('20434624726')
			.withDiscapacidad(false)
			.withDNI('')
			.withEstadoCivil('N')
			.withFechaDeNacimiento(fechaNacimiento)
			.withFechaDeVigencia(fechaVigencia)
			.withFirstName('Santiago')
			.withLastName('Test')
			.withNacionalidad('Argentina')
			.withSexo('Masculino')
			.withTipodedocumento('ND')
			.withTipoDeParentesco('CO')
			.withObraSocial2(obraSocial.Id)
			.withEmpleador(entidad.Id)
			.withCuil('20414624416')
			.withAccountId(cuenta.Id)
			.withDelegacionId(delegacion.Id)
			.build();
		insert casoSolicitudAltaFamiliar;
		Tipo_nota_de_auditoria__c typeOfNota = new Tipo_nota_de_auditoria__c(Name= 'NOTA DDJJ - SOLICITUDES');
		insert typeOfNota;
		CrearNotaDeAuditoriaController.Response response;
		Test.startTest();
		response = CrearNotaDeAuditoriaController.getRecordTypeId(casoSolicitudAltaFamiliar.Id);
		Test.stopTest();
		System.assert(!response.hasError, 'No debe haber algún error');
		System.assertEquals(typeOfNota.Id, ((Id) response.typeOfNota), 'La nota no es la esperada');
	}
}