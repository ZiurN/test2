/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase de pruebas para la clase CaseSendToSSGenericBtnCtrl y sus métodos.cuenta.
@date:			25/10/2021 (Modificada).
------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class CaseSendToSSGenericBtnCtrlTest {
	/** Constants Variables */
	public static Map<String, Webservice_endpoint__mdt> endpoints = ConfigUtils.getEndpointsByTipo('solicitudes-afiliados');
	public static final String SOLICITUD_DESPEGUE_URL = endpoints.get('despegue').Endpoint__c;
	public static final String SOLICITUD_ALTA_FAMILIAR_URL = endpoints.get('alta-familiar').Endpoint__c;
	public static final String SOLICITUD_CAMBIO_SEGMENTO_URL = endpoints.get('cambio-segmento').Endpoint__c;
	public static final String SOLICITUD_BAJA_URL = endpoints.get('baja').Endpoint__c;
	public static final String INTERFAZ_FINANCIERA_URL = endpoints.get('interfaz-financiera').Endpoint__c;
	public static final String SOLICITUD_NUEVA_CREDENCIAL_URL = endpoints.get('reemision-credencial').Endpoint__c;
	public static final String SOLICITUD_CAMBIO_PLAN_URL = endpoints.get('cambio-plan').Endpoint__c;
	public static final String SOLICITUD_DATOS_PARTICULARES_URL = endpoints.get('datos-particulares').Endpoint__c;
	public static final Date fechaNacimiento = Date.newInstance(1990, 05, 01);
	public static final Date fechaVigencia = Date.newInstance(2020, 08, 01);
	public static final Account delegacion = Build.anAccountDelegacion()
		.withCodigoDeDelegacion('650098')
		.build();
	public static final Account entidad = Build.anAccountEmpresa()
		.withCuit('30676863822')
		.withCodigoEmpresa('639506')
		.build();
	public static final Account cuenta = build.anAccount()
		.withAfiIddelTitular(182701)
		.withType('TIT')
		.withCodigodeAfiliado('70332/34')
		.withLastName('Testing182701')
		.withEstado('A')
		.build();
	public static final Account familiar = build.anAccount()
		.withAfiIddelTitular(182700)
		.withCodigodeAfiliado('70331/34')
		.withLastName('Testingx')
		.withEstado('A')
		.build();
	public static final Account obraSocial = Build.anAccountObrasocial().build();
	public static final Localidad__c loc = new Localidad__c();
	/** Static Variables */
	public static ContentVersion cv = new ContentVersion(Title = 'document',
														VersionData = Blob.valueOf('document'),
														PathOnClient = '/document');
	public static XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
	/**-----------------------------------------------------------------------------------------------------------------------
	 * Casos que no aplican y errores generales
	------------------------------------------------------------------------------------------------------------------------*/
		@isTest
		private static void bad_tryToSubmitInvalidCaseTypeShouldGetError() {
			Case caso = new Case();
			setInitialData(caso);
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_DESPEGUE_URL, WSSSGenericResponseTest.json(''), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(caso.Id,false);
			Test.stopTest();
			System.assertEquals(true, response.hasError, response.auraMessage.message);
		}
		@isTest
		private static void bad_tryToSubmitACaseWithoutFilesShouldReturnError() {
			Case caso = new Case();
			insert caso;
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(caso.Id,false);
			Test.stopTest();
			System.assertEquals(true, response.hasError, response.auraMessage.message);
		}
		@isTest
		private static void bad_tryAddInvalidCaseInButtonShouldReturnError () {
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS('Holis',false);
			Test.stopTest();
			System.assertEquals(true, response.hasError, response.auraMessage.message);
		}
	/**-----------------------------------------------------------------------------------------------------------------------
	 * Casos de Solicitud de Despegue
	------------------------------------------------------------------------------------------------------------------------*/
		@isTest
		private static void Despegue_sendDUpdateToSS_ShouldTransformToComplete() {
			insert new List<SObject> {delegacion, entidad, familiar, obraSocial, loc};
			Case casoSolicitudDespeguesFT = Build.aCaseSolicitudDedespegues(true)
				.withTipoDeParentesco('')
				.withType('FT')
				.withObraSocial2(obraSocial.Id)
				.withLocalidad(loc.Id)
				.withFechaDeNacimiento(fechaNacimiento)
				.withFechaDeVigencia(fechaVigencia)
				.withEmpleador(entidad.Id)
				.withAccountId(familiar.Id)
				.withDelegacionId(delegacion.Id)
				.withMedioDeCobro('CBUVOL')
				.withTipoCBU('CBUFR')
				.withNroCBUCuota('1231231231452345')
				.withNroDeSolicitudSS('725187')
				.withEstadoDeSolicitud('INCOMPLETA')
				.withCuilDelCBU('20123456786')
				.build();
			setInitialData(casoSolicitudDespeguesFT);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudDespeguesFT.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_DESPEGUE_URL, WSSSGenericResponseTest.jsonUpdate(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudDespeguesFT.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
			Case updatedCase = [SELECT Estado_de_solicitud__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudDespeguesFT.Id];
			System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c, 'El número de solicitud debe ser 725197');
			System.assertEquals('COMPLETA', updatedCase.Estado_de_solicitud__c, 'El estado de la solicitud debe ser COMPLETA');
		}
		@isTest
		private static void Despegue_sendTFToSSShouldReturnSuccessAndUpdateCase() {
			insert new List<SObject> {delegacion, entidad, familiar, obraSocial, loc};
			Case casoSolicitudDespeguesFT = Build.aCaseSolicitudDedespegues(true)
				.withTipoDeParentesco('')
				.withType('FT')
				.withObraSocial2(obraSocial.Id)
				.withFechaDeNacimiento(fechaNacimiento)
				.withFechaDeVigencia(fechaVigencia)
				.withEmpleador(entidad.Id)
				.withAccountId(familiar.Id)
				.withDelegacionId(delegacion.Id)
				.withLocalidad(loc.Id)
				.withMedioDeCobro('DEBAUT')
				.withTarjetaDeCredito('TRO04')
				.withNumeroDeTarjetaDeCredito('1234567895464')
				.build();
			setInitialData(casoSolicitudDespeguesFT);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudDespeguesFT.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_DESPEGUE_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudDespeguesFT.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
			Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudDespeguesFT.Id];
			System.assertEquals('NUEVA', updatedCase.Estado_DDJJ__c, 'El estado DDJJ debe ser NUEVA');
			System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c, 'El núermo de la solicitud debe ser 725187');
		}
		@isTest
		private static void Despegue_sendCTToSSShouldReturnSuccessAndUpdateCase() {
			insert new List<SObject> {delegacion, entidad, familiar, obraSocial, loc};
			Case casoSolicitudDespeguesCT = Build.aCaseSolicitudDedespegues(true)
				.withTipoDeParentesco('')
				.withType('CT')
				.withFechaDeNacimiento(fechaNacimiento)
				.withFechaDeVigencia(fechaVigencia)
				.withObraSocial2(obraSocial.Id)
				.withEmpleador(entidad.Id)
				.withAccountId(familiar.Id)
				.withDelegacionId(delegacion.Id)
				.withLocalidad(loc.Id)
				.withCalle('1')
				.withNumero(1)
				.withPiso('1')
				.withDpto('1')
				.withCondicionIva('RI-1')
				.withMedioDeCobro('OTROS')
				.withFacturaSinPapel('Verdadero')
				.build();
			setInitialData(casoSolicitudDespeguesCT);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudDespeguesCT.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_DESPEGUE_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudDespeguesCT.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
			Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudDespeguesCT.Id];
			System.assertEquals('NUEVA', updatedCase.Estado_DDJJ__c, 'El estado DDJJ debe ser NUEVA');
			System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c, 'El número de la solicitud debe ser 725187');
		}
		@isTest
		private static void Despegue_sendWithIntegrantesToSSShouldReturnSuccessAndUpdateCase() {
			insert new List<SObject> {delegacion, entidad, cuenta, obraSocial};
			Case casoSolicitudDespeguesTF = Build.aCaseSolicitudDedespegues(false)
				.withType('TF')
				.withFechaDeNacimiento(fechaNacimiento)
				.withFechaDeVigencia(fechaVigencia)
				.withTipoDeParentesco('CO')
				.withTitular(cuenta.Id)
				.withObraSocial2(obraSocial.Id)
				.withEmpleador(entidad.Id)
				.withAccountId(cuenta.Id)
				.withDelegacionId(delegacion.Id)
				.build();
			setInitialData(casoSolicitudDespeguesTF);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudDespeguesTF.Id);
			insert nota;
			List<Integrante_caso__c> integrantes = new List<Integrante_caso__c> {
				Build.anIntegranteCaso('72096961')
					.withEmpleador(entidad.Id)
					.withCase(casoSolicitudDespeguesTF.Id)
					.build(),
				Build.anIntegranteCaso('71096961')
					.withEmpleador(entidad.Id)
					.withCase(casoSolicitudDespeguesTF.Id)
					.build()
			};
			insert integrantes;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_DESPEGUE_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudDespeguesTF.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
			Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudDespeguesTF.Id];
			System.assertEquals('NUEVA', updatedCase.Estado_DDJJ__c, 'El estado DDJJ debe ser NUEVA');
			System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c, 'El número de la solicitud debe ser 725187');
		}
		@isTest
		private static void Despegue_sendWithNotaDeAuditoriaToSSShouldReturnSuccessAndUpdateCase() {
			insert new List<SObject> {delegacion, entidad, cuenta, obraSocial};
			Case casoSolicitudDespeguesTF = Build.aCaseSolicitudDedespegues()
				.withFechaDeNacimiento(fechaNacimiento)
				.withFechaDeVigencia(fechaVigencia)
				.withTipoDeParentesco('CO')
				.withTitular(cuenta.Id)
				.withObraSocial2(obraSocial.Id)
				.withEmpleador(entidad.Id)
				.withCuil('20414624416')
				.withAccountId(cuenta.Id)
				.withDelegacionId(delegacion.Id)
				.withType('TF')
				.build();
			setInitialData(casoSolicitudDespeguesTF);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudDespeguesTF.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_DESPEGUE_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudDespeguesTF.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
			Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudDespeguesTF.Id];
			System.assertEquals('NUEVA', updatedCase.Estado_DDJJ__c, 'El estado DDJJ debe ser NUEVA');
			System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c, 'El número de la solicitud debe ser 725187');
		}
		@isTest
		private static void Despegue_sendInvalidToSSShouldReturnError() {
			insert new List<SObject> {delegacion, entidad, cuenta, obraSocial};
			Case casoSolicitudDespeguesTF = Build.aCaseSolicitudDedespegues()
				.withFechaDeNacimiento(fechaNacimiento)
				.withFechaDeVigencia(fechaVigencia)
				.withTipoDeParentesco('CO')
				.withTitular(cuenta.Id)
				.withObraSocial2(obraSocial.Id)
				.withEmpleador(entidad.Id)
				.withAccountId(cuenta.Id)
				.withDelegacionId(delegacion.Id)
				.withType('TF')
				.build();
			setInitialData(casoSolicitudDespeguesTF);
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_DESPEGUE_URL, WSSSGenericResponseTest.jsonError, 422, 'Not Found');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudDespeguesTF.Id,false);
			Test.stopTest();
			System.assertEquals(true, response.hasError, response.auraMessage.message);
		}
		@isTest
		private static void Despegue_EmailWithCDL_sendCTToSSShouldReturnSuccessAndUpdateCase() {
			insert new List<SObject> {delegacion, entidad, familiar, obraSocial, loc};
			Case casoSolicitudDespeguesCT = Build.aCaseSolicitudDedespegues(true)
				.withTipoDeParentesco('')
				.withType('CT')
				.withFechaDeNacimiento(fechaNacimiento)
				.withFechaDeVigencia(fechaVigencia)
				.withObraSocial2(obraSocial.Id)
				.withEmpleador(entidad.Id)
				.withAccountId(familiar.Id)
				.withDelegacionId(delegacion.Id)
				.withLocalidad(loc.Id)
				.withCalle('1')
				.withNumero(1)
				.withPiso('1')
				.withDpto('1')
				.withCondicionIva('RI-1')
				.withMedioDeCobro('OTROS')
				.withFacturaSinPapel('Verdadero')
				.build();
			setInitialDataWithEmail(casoSolicitudDespeguesCT);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudDespeguesCT.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_DESPEGUE_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudDespeguesCT.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
			Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudDespeguesCT.Id];
			System.assertEquals('NUEVA', updatedCase.Estado_DDJJ__c, 'El estado DDJJ debe ser NUEVA');
			System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c, 'El número de la solicitud debe ser 725187');
		}
	/**-----------------------------------------------------------------------------------------------------------------------
	 * Casos Alta Familiar
	------------------------------------------------------------------------------------------------------------------------*/
		@isTest
		private static void AltaFamiliar_sendWithAllDataToSSShouldReturnSuccessAndUpdateCase() {
			insert new List<SObject> {delegacion, entidad, cuenta, obraSocial};
			Case casoSolicitudAltaFamiliar = Build.aCaseSolicituddealtafamiliar()
				.withFechaDeNacimiento(fechaNacimiento)
				.withFechaDeVigencia(fechaVigencia)
				.withObraSocial2(obraSocial.Id)
				.withEmpleador(entidad.Id)
				.withAccountId(cuenta.Id)
				.withDelegacionId(delegacion.Id)
				.build();
			setInitialData(casoSolicitudAltaFamiliar);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudAltaFamiliar.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_ALTA_FAMILIAR_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudAltaFamiliar.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
			Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudAltaFamiliar.Id];
			System.assertEquals('NUEVA', updatedCase.Estado_DDJJ__c, 'El estado DDJJ debe ser NUEVA');
			System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c, 'El número de la solicitud debe ser 725187');
		}
		@isTest
		private static void AltaFamiliar_sendUpdateWithAllDataToSSShouldTransformToComplete() {
			insert new List<SObject> {delegacion, entidad, cuenta, obraSocial};
			Case casoSolicitudAltaFamiliar = Build.aCaseSolicituddealtafamiliar()
				.withFechaDeNacimiento(fechaNacimiento)
				.withFechaDeVigencia(fechaVigencia)
				.withObraSocial2(obraSocial.Id)
				.withEmpleador(entidad.Id)
				.withAccountId(cuenta.Id)
				.withDelegacionId(delegacion.Id)
				.withNroDeSolicitudSS('725187')
				.withEstadoDeSolicitud('INCOMPLETA')
				.build();
			setInitialData(casoSolicitudAltaFamiliar);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudAltaFamiliar.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_ALTA_FAMILIAR_URL, WSSSGenericResponseTest.jsonUpdate(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudAltaFamiliar.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
			Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c, Estado_de_solicitud__c  FROM Case WHERE id =:casoSolicitudAltaFamiliar.Id];
			System.assertEquals('NUEVA', updatedCase.Estado_DDJJ__c, 'El estado DDJJ debe ser NUEVA');
			System.assertEquals('COMPLETA', updatedCase.Estado_de_solicitud__c, 'El estado de la solicitud debe ser COMPLETA' );
		}
		@isTest
		private static void AltaFamiliar_sendInvalidToSSShouldReturnError() {
			insert new List<SObject> {delegacion, entidad, cuenta, obraSocial};
			Case casoSolicitudAltaFamiliar = Build.aCaseSolicituddealtafamiliar()
				.withFechaDeNacimiento(fechaNacimiento)
				.withFechaDeVigencia(fechaVigencia)
				.withObraSocial2(obraSocial.Id)
				.withEmpleador(entidad.Id)
				.withAccountId(cuenta.Id)
				.withDelegacionId(delegacion.Id)
				.build();
			setInitialData(casoSolicitudAltaFamiliar);
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_ALTA_FAMILIAR_URL, WSSSGenericResponseTest.jsonError, 422, 'Not Found');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudAltaFamiliar.Id,false);
			Test.stopTest();
			System.assertEquals(true, response.hasError, response.auraMessage.message);
		}
		@isTest
		private static void AltaFamiliar_EmailWithCDL_sendWithAllDataToSSShouldReturnSuccessAndUpdateCase() {
			insert new List<SObject> {delegacion, entidad, cuenta, obraSocial};
			Case casoSolicitudAltaFamiliar = Build.aCaseSolicituddealtafamiliar()
				.withFechaDeNacimiento(fechaNacimiento)
				.withFechaDeVigencia(fechaVigencia)
				.withObraSocial2(obraSocial.Id)
				.withEmpleador(entidad.Id)
				.withAccountId(cuenta.Id)
				.withDelegacionId(delegacion.Id)
				.build();
			setInitialDataWithEmail(casoSolicitudAltaFamiliar);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudAltaFamiliar.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_ALTA_FAMILIAR_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudAltaFamiliar.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
			Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudAltaFamiliar.Id];
			System.assertEquals('NUEVA', updatedCase.Estado_DDJJ__c, 'El estado DDJJ debe ser NUEVA');
			System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c, 'El número de la solicitud debe ser 725187');
		}
	/**-----------------------------------------------------------------------------------------------------------------------
	 * Casos Cambio Segmento
	------------------------------------------------------------------------------------------------------------------------*/
		@isTest
		private static void CambioSegmento_sendWithCorrectDataToSSShouldReturnSuccessAndUpdateCase() {
			insert new List<SObject> {entidad, obraSocial};
			Case casoSolicitudCambioSegmento = Build.aCaseSolicitudDeCambioSegmento()
				.withFechaDeVigencia(Date.newInstance(2020, 05, 01))
				.withObraSocial2(obraSocial.Id)
				.withEmpleador(entidad.Id)
				.build();
			setInitialData(casoSolicitudCambioSegmento);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudCambioSegmento.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_CAMBIO_SEGMENTO_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudCambioSegmento.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
			Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudCambioSegmento.Id];
			System.assertEquals('NUEVA', updatedCase.Estado_DDJJ__c, 'El estado DDJJ debe ser NUEVA');
			System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c, 'El número de la solicitud debe ser 725187');
		}
		@isTest
		private static void CambioSegmento_sendUpdateToSSShouldTransformToComplete() {
			insert new List<SObject> {entidad, obraSocial};
			Case casoSolicitudCambioSegmento = Build.aCaseSolicitudDeCambioSegmento()
				.withFechaDeVigencia(Date.newInstance(2020, 05, 01))
				.withObraSocial2(obraSocial.Id)
				.withEmpleador(entidad.Id)
				.withNroDeSolicitudSS('725187')
				.withEstadoDeSolicitud('INCOMPLETA')
				.build();
			setInitialData(casoSolicitudCambioSegmento);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudCambioSegmento.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_CAMBIO_SEGMENTO_URL, WSSSGenericResponseTest.jsonUpdate(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudCambioSegmento.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
			Case updatedCase = [SELECT Estado_de_solicitud__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudCambioSegmento.Id];
			System.assertEquals('COMPLETA', updatedCase.Estado_de_solicitud__c, 'El estado de la solicitud debe ser COMPLETA');
		}
		@isTest
		private static void CambioSegmento_EmailWithCDL_sendWithCorrectDataToSSShouldReturnSuccessAndUpdateCase() {
			insert new List<SObject> {entidad, obraSocial};
			Case casoSolicitudCambioSegmento = Build.aCaseSolicitudDeCambioSegmento()
				.withFechaDeVigencia(Date.newInstance(2020, 05, 01))
				.withObraSocial2(obraSocial.Id)
				.withEmpleador(entidad.Id)
				.build();
			setInitialDataWithEmail(casoSolicitudCambioSegmento);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudCambioSegmento.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_CAMBIO_SEGMENTO_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudCambioSegmento.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
			Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudCambioSegmento.Id];
			System.assertEquals('NUEVA', updatedCase.Estado_DDJJ__c, 'El estado DDJJ debe ser NUEVA');
			System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c, 'El número de la solicitud debe ser 725187');
		}
	/**-----------------------------------------------------------------------------------------------------------------------
	 * Casos Bajas
	------------------------------------------------------------------------------------------------------------------------*/
		@isTest
		private static void BajaParcial_sendWithCorrectDataShouldUpdateCase() {
			insert new List<SObject>{familiar, cuenta};
			Case casoBajaParcial = Build.aCaseSolicitudDeBajaParcial()
				.withAccountId(cuenta.Id)
				.build();
			setInitialData(casoBajaParcial);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoBajaParcial.Id);
			insert nota;
			Integrante_caso__c integrante = Build.anIntegranteCasoBajas()
				.withFamiliar(familiar.Id)
				.withMotivoDeLaBaja('2')
				.withCase(casoBajaParcial.Id)
				.build();
			insert integrante;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_BAJA_URL, WSSSGenericResponseTest.json(nota.Id, integrante.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoBajaParcial.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
		}
		@isTest
		private static void BajaParcial_sendWithoutIntegranteShouldReturnError() {
			insert new List<SObject> {familiar, cuenta};
			Case casoBajaParcial = Build.aCaseSolicitudDeBajaParcial()
				.withAccountId(cuenta.Id)
				.build();
			setInitialData(casoBajaParcial);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoBajaParcial.Id,false);
			Test.stopTest();
			System.assertEquals(true, response.hasError, response.auraMessage.message);
		}
		@isTest
		private static void BajaParcial_sendThrowBatchWithCorrectDataShouldUpdateCase() {
			insert new List<SObject>{familiar, cuenta};
			Case casoBajaParcial = Build.aCaseSolicitudDeBajaParcial()
				.withAccountId(cuenta.Id)
				.build();
			setInitialData(casoBajaParcial);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoBajaParcial.Id);
			insert nota;
			Integrante_caso__c integrante = Build.anIntegranteCasoBajas()
				.withFamiliar(familiar.Id)
				.withMotivoDeLaBaja('2')
				.withCase(casoBajaParcial.Id)
				.build();
			insert integrante;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_BAJA_URL, WSSSGenericResponseTest.json(nota.Id, integrante.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSAttachmentQueueable queueable = new CaseSendToSSAttachmentQueueable(casoBajaParcial.Id);
			queueable.execute(null);
			Test.stopTest();
		}
		@isTest
		private static void BajaTotal_sendWithCorrectDataShouldUpdateCase() {
			insert new List<SObject> {cuenta};
			Case casoBajaTotal = Build.aCaseSolicitudDeBajaTotal()
				.withAccountId(cuenta.Id)
				.build();
			setInitialData(casoBajaTotal);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoBajaTotal.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_BAJA_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoBajaTotal.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
		}
		@isTest
		private static void BajaTotal_sendUpdateWithCorrectDataShouldTransformToComplete() {
			insert new List<SObject> {cuenta};
			Case casoBajaTotal = Build.aCaseSolicitudDeBajaTotal()
				.withAccountId(cuenta.Id)
				.withNroDeSolicitudSS('725187')
				.withEstadoDeSolicitud('INCOMPLETA')
				.build();
			setInitialData(casoBajaTotal);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoBajaTotal.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_BAJA_URL, WSSSGenericResponseTest.jsonUpdate(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoBajaTotal.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
		}
		@isTest
		private static void BajaParcial_EmailWithCDL_sendWithCorrectDataShouldUpdateCase() {
			insert new List<SObject>{familiar, cuenta};
			Case casoBajaParcial = Build.aCaseSolicitudDeBajaParcial()
				.withAccountId(cuenta.Id)
				.build();
			setInitialDataWithEmail(casoBajaParcial);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoBajaParcial.Id);
			insert nota;
			Integrante_caso__c integrante = Build.anIntegranteCasoBajas()
				.withFamiliar(familiar.Id)
				.withMotivoDeLaBaja('2')
				.withCase(casoBajaParcial.Id)
				.build();
			insert integrante;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_BAJA_URL, WSSSGenericResponseTest.json(nota.Id, integrante.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoBajaParcial.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
		}
	/**-----------------------------------------------------------------------------------------------------------------------
	 * Casos Interfaz Financiera
	------------------------------------------------------------------------------------------------------------------------*/
		@isTest
		private static void InterfazFinanciera_sendType_C_WithCorrectDataShouldUpdateCase() {
			Case caseIF = Build.aCaseSolicitudInterfazFinanciera()
				.withType('C')
				.withCuit('20123456789')
				.withFechaDeVigencia(Date.newInstance(2020, 01, 01))
				.build();
			setInitialData(caseIF);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = caseIF.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, INTERFAZ_FINANCIERA_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(caseIF.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
		}
		@isTest
		private static void InterfazFinanciera_sendUpdateWithCorrectDataShouldTransformCaseToComplete() {
			Case caseIF = Build.aCaseSolicitudInterfazFinanciera()
				.withType('C')
				.withCuit('20123456789')
				.withFechaDeVigencia(Date.newInstance(2020, 01, 01))
				.withNroDeSolicitudSS('725187')
				.withEstadoDeSolicitud('INCOMPLETA')
				.build();
			setInitialData(caseIF);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = caseIF.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, INTERFAZ_FINANCIERA_URL, WSSSGenericResponseTest.jsonUpdate(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(caseIF.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
			caseIF = [SELECT Estado_de_solicitud__c FROM Case WHERE Id = :caseIF.Id];
			System.assertEquals('COMPLETA', caseIF.Estado_de_solicitud__c, 'No se esta completando la actualizacion');
		}
		@isTest
		private static void InterfazFinanciera_sendType_T_WithCorrectDataShouldUpdateCase() {
			Case caseIF = Build.aCaseSolicitudInterfazFinanciera()
				.withType('T')
				.withCuilTitular('20328322529')
				.withCBU('23123123123123')
				.withFechaDeVigencia(Date.newInstance(2020, 01, 01))
				.build();
			setInitialData(caseIF);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = caseIF.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, INTERFAZ_FINANCIERA_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(caseIF.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
		}
		@isTest
		private static void InterfazFinanciera_EmailWithCDL_sendType_C_WithCorrectDataShouldUpdateCase() {
			Case caseIF = Build.aCaseSolicitudInterfazFinanciera()
				.withType('C')
				.withCuit('20123456789')
				.withFechaDeVigencia(Date.newInstance(2020, 01, 01))
				.build();
			setInitialDataWithEmail(caseIF);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = caseIF.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, INTERFAZ_FINANCIERA_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(caseIF.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
		}
	/**-----------------------------------------------------------------------------------------------------------------------
	 * Casos Nueva Credencial
	------------------------------------------------------------------------------------------------------------------------*/
		@isTest
		private static void Credential_sendRequestShouldUpdateCase() {
			insert cuenta;
			Case casoCredencial = Build.aCaseSolicitudDeCredencial()
				.withAccountId(cuenta.Id)
				.build();
			insert casoCredencial;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_NUEVA_CREDENCIAL_URL, WSSSGenericResponseTest.jsonUpdate(''), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoCredencial.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
		}
		@isTest
		private static void Credential_sendRequestShouldToAnInvalidAccountShouldReturnError() {
			insert cuenta;
			Case casoCredencial = Build.aCaseSolicitudDeCredencial()
				.withAccountId(cuenta.Id)
				.build();
			insert casoCredencial;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_NUEVA_CREDENCIAL_URL, WSSSGenericResponseTest.jsonError, 422, 'Not Found');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoCredencial.Id,false);
			Test.stopTest();
			System.assertEquals(true, response.hasError, response.auraMessage.message);
		}
	/**-----------------------------------------------------------------------------------------------------------------------
	 * Casos Cambio de Plan
	------------------------------------------------------------------------------------------------------------------------*/
		@isTest
		private static void SolicitudCambioPlan_sendWithCorrectDataShouldUpdateCase() {
			insert new List<SObject> {delegacion, cuenta};
			Case casoCambioPlan = Build.aCaseSolicitudCambioPlan()
				.withPlanDespegue('AS300')
				.withFechaDeVigencia(Date.newInstance(2020, 01, 01))
				.withAccountId(cuenta.Id)
				.withDelegacionId(delegacion.Id)
				.build();
			setInitialData(casoCambioPlan);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoCambioPlan.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_CAMBIO_PLAN_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoCambioPlan.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
		}
		@isTest
		private static void SolicitudCambioPlan_sendUpdateWithCorrectDataShouldTransformToComplete() {
			insert new List<SObject> {delegacion, cuenta};
			Case casoCambioPlan = Build.aCaseSolicitudCambioPlan()
				.withPlanDespegue('AS300')
				.withFechaDeVigencia(Date.newInstance(2020, 01, 01))
				.withAccountId(cuenta.Id)
				.withNroDeSolicitudSS('725187')
				.withEstadoDeSolicitud('INCOMPLETA')
				.withDelegacionId(delegacion.Id)
				.build();
			setInitialData(casoCambioPlan);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoCambioPlan.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_CAMBIO_PLAN_URL, WSSSGenericResponseTest.jsonUpdate(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoCambioPlan.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
			casoCambioPlan = [SELECT Estado_de_solicitud__c FROM Case WHERE Id = :casoCambioPlan.Id];
			System.assertEquals('COMPLETA', casoCambioPlan.Estado_de_solicitud__c, 'No se esta completando la actualizacion');
		}
		@isTest
		private static void SolicitudCambioPlan_EmailWithCDL_sendWithCorrectDataShouldUpdateCase() {
			insert new List<SObject> {delegacion, cuenta};
			Case casoCambioPlan = Build.aCaseSolicitudCambioPlan()
				.withPlanDespegue('AS300')
				.withFechaDeVigencia(Date.newInstance(2020, 01, 01))
				.withAccountId(cuenta.Id)
				.withDelegacionId(delegacion.Id)
				.build();
			setInitialDataWithEmail(casoCambioPlan);
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoCambioPlan.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_CAMBIO_PLAN_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoCambioPlan.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
		}
	/**-----------------------------------------------------------------------------------------------------------------------
	 * Casos Datos Particulares
	------------------------------------------------------------------------------------------------------------------------*/
		@isTest
		private static void SolicitudCasoDatosParticulares_sendWithCorrectDataAndType_P_ShouldUpdateCase() {
			insert obraSocial;
			Case casoDatosParticulares = Build.aCaseSolicitudDatosParticulares()
				.withFechaDeVigencia(Date.newInstance(2020, 01, 01))
				.withFirstName('test')
				.withLastName('test')
				.withSexo('Masculino')
				.withNacionalidad('Argentina')
				.withFechaDeNacimiento(fechaNacimiento)
				.withObraSocial2(obraSocial.Id)
				.withCuil('20414620716')
				.withTipoDeParentesco('P')
				.withType('Datos particulares')
				.build();
			insert casoDatosParticulares;
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoDatosParticulares.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_DATOS_PARTICULARES_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoDatosParticulares.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
			Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoDatosParticulares.Id];
			System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c, 'El número de la solicitud debe ser 725187');
		}
		@isTest
		private static void SolicitudCasoDatosParticulares_sendDPARTWithCorrectDataShouldUpdateCase() {
			insert new List<SObject> {cuenta, obraSocial};
			Case casoDatosParticulares = Build.aCaseSolicitudDatosParticulares()
				.withFechaDeVigencia(Date.newInstance(2020, 01, 01))
				.withAccountId(cuenta.Id)
				.withFirstName('test')
				.withLastName('test')
				.withSexo('Masculino')
				.withNacionalidad('Argentina')
				.withFechaDeNacimiento(fechaNacimiento)
				.withObraSocial2(obraSocial.Id)
				.withCuil('20414620716')
				.withTipoDeParentesco('P')
				.withType('MODIF_DPART')
				.build();
			insert casoDatosParticulares;
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoDatosParticulares.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_DATOS_PARTICULARES_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoDatosParticulares.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
			Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoDatosParticulares.Id];
			System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c, 'El número de la solicitud debe ser 725187');
		}
		@isTest
		private static void sendSolicitudCasoDatosParticularesDELEGWithCorrectDataShouldUpdateCase() {
			insert new List<SObject> {obraSocial, delegacion, cuenta};
			Case casoDatosParticulares = Build.aCaseSolicitudDatosParticulares()
				.withFechaDeVigencia(Date.newInstance(2020, 01, 01))
				.withAccountId(cuenta.Id)
				.withType('MODIF_DELEG')
				.withAgenciaDestino(delegacion.Id)
				.build();
			insert casoDatosParticulares;
			Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoDatosParticulares.Id);
			insert nota;
			TestUtils.setMockResponse(getResponseFound, SOLICITUD_DATOS_PARTICULARES_URL, WSSSGenericResponseTest.json(nota.Id), 200, 'OK');
			Test.setMock(HttpCalloutMock.class, getResponseFound);
			Test.startTest();
			CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoDatosParticulares.Id,false);
			Test.stopTest();
			System.assertEquals(false, response.hasError, response.auraMessage.message);
			Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoDatosParticulares.Id];
			System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c, 'El número de la solicitud debe ser 725187');
		}
	/** Utils */
	private static void setInitialData (Case caso) {
		insert cv;
		cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
		insert caso;
		ContentDocumentLink contentlink = new ContentDocumentLink(LinkedEntityId = caso.id,
																	ContentDocumentId = cv.contentDocumentId,
																	Visibility = 'AllUsers');
		insert contentlink;
	}
	private static void setInitialDataWithEmail (Case caso) {
		insert cv;
		cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
		insert caso;
		EmailMessage relatedEmail = new EmailMessage();
		relatedEmail.ParentId = caso.Id;
		insert relatedEmail;
		ContentDocumentLink contentlink = new ContentDocumentLink(LinkedEntityId = relatedEmail.id,
																	ContentDocumentId = cv.contentDocumentId,
																	Visibility = 'AllUsers');
		insert contentlink;
	}
}