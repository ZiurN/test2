@isTest
private class CrearIntegranteOverrideBtnControllerTest {
	@isTest
	private static void whenCallingFromCaseOfType_SolicitudDeBaja_ShouldReturnIntegrante_Caso_BajasRT() {
		CrearIntegranteOverrideBtnController.Response response;
		Account acc = build.anAccount()
			.withAfiIddelTitular(182701)
			.withType('TIT')
			.withCodigodeAfiliado('70332/34')
			.withLastName('Testing182701')
			.withEstado('A')
			.build();
		insert acc;
		Case casoSolicitudDeBajas = Build.aCaseSolicitudDeBaja()
			.withType('Baja total')
			.withStatus('Pendiente')
			.withAccountId(acc.Id)
			.withFechaDeVigencia(Date.newInstance(2020, 01, 01))
			.withMotivoDeLaBaja('BAJA POR PROBLEMAS ECONÓMICOS')
			.build();
		insert casoSolicitudDeBajas;
		Test.startTest();
		response = CrearIntegranteOverrideBtnController.getRecordTypeId(casoSolicitudDeBajas.Id);
		Test.stopTest();
		RecordType bajasRecordType = [
			SELECT Id, DeveloperName, SobjectType
			FROM RecordType
			WHERE SobjectType = 'Integrante_caso__c'
				AND DeveloperName = 'Bajas'
		];
		System.assertEquals(false, response.hasError);
		System.assertEquals(bajasRecordType.Id, ((Id)response.data));
	}
	@isTest
	private static void whenCallingFromCaseOfType_Despegues_ShouldReturnIntegrante_Caso_DespeguesRT() {
		CrearIntegranteOverrideBtnController.Response response;
		Date fechaNacimiento = Date.newInstance(1990, 05, 01);
		Date fechaVigencia = Date.newInstance(2020, 08, 01);
		Account delegacion = Build.anAccountDelegacion()
			.withCodigoDeDelegacion('650098')
			.build();
		Account entidad = Build.anAccountEmpresa()
			.withCuit('30676863822')
			.withCodigoEmpresa('639506')
			.build();
		Account familiar = build.anAccount()
			.withAfiIddelTitular(182700)
			.withCodigodeAfiliado('70331/34')
			.withLastName('Testingx')
			.withEstado('A')
			.build();
		Account obraSocial = Build.anAccountObrasocial().build();
		Localidad__c loc = new Localidad__c();
		insert new List<SObject> {delegacion, entidad, familiar, obraSocial, loc};
		Case casoSolicitudDespeguesFT = Build.aCaseSolicitudDedespegues(true)
			.withTipoDeParentesco('')
			.withBebeSinDNI(true)
			.withLocalidad(loc.Id)
			.withFechaDeNacimiento(fechaNacimiento)
			.withFechaDeVigencia(fechaVigencia)
			.withEmpleador(entidad.Id)
			.withObraSocial2(obraSocial.Id)
			.withMedioDeCobro('CBUVOL')
			.withTipoCBU('CBUFR')
			.withNroCBUCuota('1231231231452345')
			.withAccountId(familiar.Id)
			.withDelegacionId(delegacion.Id)
			.withNroDeSolicitudSS('725187')
			.withEstadoDeSolicitud('INCOMPLETA')
			.withType('FT')
			.withSegmentoGrupoFamiliar('OBLDIR')
			.withPlanDespegue('AS100')
			.build();
		casoSolicitudDespeguesFT.CUIL_del_CBU__c = '20123456786';
		insert casoSolicitudDespeguesFT;
		Test.startTest();
		response = CrearIntegranteOverrideBtnController.getRecordTypeId(casoSolicitudDespeguesFT.Id);
		Test.stopTest();
		RecordType despeguesRecordType = [
			SELECT Id, DeveloperName, SobjectType
			FROM RecordType
			WHERE SobjectType = 'Integrante_caso__c'
				AND DeveloperName = 'Despegues'
		];
		System.assertEquals(false, response.hasError);
		System.assertEquals(despeguesRecordType.Id, ((Id)response.data));
	}
	@isTest
	private static void whenCallingFromInvalidCaseShouldReturnError() {
		CrearIntegranteOverrideBtnController.Response response;
		Test.startTest();
		response = CrearIntegranteOverrideBtnController.getRecordTypeId('SomethingInvalid');
		Test.stopTest();
		System.assertEquals(true, response.hasError);
	}
	@isTest
	private static void whenCallingWithNoIdShouldReturnError() {
		CrearIntegranteOverrideBtnController.Response response;
		Test.startTest();
		response = CrearIntegranteOverrideBtnController.getRecordTypeId('');
		Test.stopTest();
		System.assertEquals(true, response.hasError);
	}
}