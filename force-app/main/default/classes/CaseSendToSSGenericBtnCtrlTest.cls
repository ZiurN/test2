@isTest
public class CaseSendToSSGenericBtnCtrlTest {
    
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
    public static final Date fechaNacimiento = Date.newInstance(1990, 05, 01);
    public static final Date fechaVigencia = Date.newInstance(2020, 08, 01);
    public static ContentVersion cv = new ContentVersion(
                            Title = 'document', 
                            VersionData = Blob.valueOf('document'), 
                            PathOnClient = '/document');
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

    @isTest
    private static void sendDespegueUpdateToSS_ShouldTransformToComplete() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        insert new List<SObject> {delegacion, entidad, familiar, obraSocial, loc};
        
        Case casoSolicitudDespeguesFT = Build.aCaseSolicituddedespegues()
                                    .withDerivaAportes(true)
                                    .withAporte(5000)
                                    .withBebeSinDNI(true)
                                    .withCuit('20414624416')
                                    .withCuitEmpleador('20434624726')
                                    .withDiscapacidad(false)
                                    .withDNI('41462441')
                                    .withLocalidad(loc.Id)
                                    .withSupliedEmail('test@example.com')
                                    .withCalle('25')
                                    .withCondicionIva('CF-4')
                                    .withFacturaSinPapel('Verdadero')
                                    .withPlanDespegue('AS300')
                                    .withSegmentoGrupoFamiliar('OBLDIR')
                                    .withObraSocial2(obraSocial.Id)
                                    .withNumero(1548)
                                    .withTelefono('123456784')
                                    .withProvincia('Buenos Aires')
                                    .withEstadoCivil('N')
                                    .withFechaDeNacimiento(fechaNacimiento)
                                    .withFechaDeVigencia(fechaVigencia)
                                    .withFirstName('Santiago')
                                    .withLastName('Test')
                                    .withNacionalidad('Argentina')
                                    .withSexo('Masculino')
                                    .withTipodedocumento('DNI')
                                    .withEmpleador(entidad.Id)
                                    .withCuil('20414624416')
                                    .withMedioDeCobro('CBUVOL')
                                    .withTipoCBU('CBUFR')
                                    .withNroCBUCuota('1231231231452345')
                                    .withAccountId(familiar.Id)
                                    .withDelegacionId(delegacion.Id)
                                    .withNroDeSolicitudSS('725187')
                                    .withEstadoDeSolicitud('INCOMPLETA')
                                    .withType('FT')
                                    .build();
        casoSolicitudDespeguesFT.CUIL_del_CBU__c = '20123456786';
        insert casoSolicitudDespeguesFT;
        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudDespeguesFT.Id);
        insert nota;
        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = casoSolicitudDespeguesFT.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                            .withStatusCode(200).withBody(WSCaseEnviarASSGenericResponseTest.jsonUpdate(nota.Id))
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/despegue');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudDespeguesFT.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
        Case updatedCase = [SELECT Estado_de_solicitud__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudDespeguesFT.Id];
        System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c);
        System.assertEquals('COMPLETA', updatedCase.Estado_de_solicitud__c);
    }
    //SE COMENTAN SOLO PARA NO CORRER TEST QUE YA FUNCIONAN

    @isTest
    private static void sendAltaFamiliarWithAllDataToSSShouldReturnSuccessAndUpdateCase() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        insert new List<SObject> {delegacion, entidad, cuenta, obraSocial};

        Case casoSolicitudAltaFamiliar = Build.aCaseSolicituddealtafamiliar()
                                .withDerivaAportes(true)
                                .withAporte(5000)
                                .withBebeNacidoEnElSistema(true)
                                .withBebeSinDNI(true)
                                .withCuit('20414624416')
                                .withInformacionAlAsociado('Sin DNI')
                                .withInformacionCompleta(true)
                                .withCuitEmpleador('20434624726')
                                .withDiscapacidad(false)
                                .withDNI('41462441')
                                .withEstadoCivil('N')
                                .withFechaDeNacimiento(fechaNacimiento)
                                .withFechaDeVigencia(fechaVigencia)
                                .withFirstName('Santiago')
                                .withLastName('Test')
                                .withNacionalidad('Argentina')
                                .withSexo('Masculino')
                                .withTipodedocumento('DNI')
                                .withTipoDeParentesco('CO')
                                .withObraSocial2(obraSocial.Id)
                                .withEmpleador(entidad.Id)
                                .withCuil('20414624416')
                                .withAccountId(cuenta.Id)
                                .withDelegacionId(delegacion.Id)
                                .build();
        insert casoSolicitudAltaFamiliar;

        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudAltaFamiliar.Id);
        insert nota;

        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = casoSolicitudAltaFamiliar.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;
        
        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                            .withStatusCode(200).withBody(WSCaseEnviarASSGenericResponseTest.json(nota.Id))
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/alta-familiar');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudAltaFamiliar.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
        Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudAltaFamiliar.Id];
        System.assertEquals('NUEVA', updatedCase.Estado_DDJJ__c);
        System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c);
    }

    @isTest
    private static void sendAltaFamiliarUpdateWithAllDataToSSShouldTransformToComplete() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        insert new List<SObject> {delegacion, entidad, cuenta, obraSocial};

        Case casoSolicitudAltaFamiliar = Build.aCaseSolicituddealtafamiliar()
                                .withDerivaAportes(true)
                                .withAporte(5000)
                                .withBebeNacidoEnElSistema(true)
                                .withBebeSinDNI(true)
                                .withCuit('20414624416')
                                .withInformacionAlAsociado('Sin DNI')
                                .withInformacionCompleta(true)
                                .withCuitEmpleador('20434624726')
                                .withDiscapacidad(false)
                                .withDNI('41462441')
                                .withEstadoCivil('N')
                                .withFechaDeNacimiento(fechaNacimiento)
                                .withFechaDeVigencia(fechaVigencia)
                                .withFirstName('Santiago')
                                .withLastName('Test')
                                .withNacionalidad('Argentina')
                                .withSexo('Masculino')
                                .withTipodedocumento('DNI')
                                .withTipoDeParentesco('CO')
                                .withObraSocial2(obraSocial.Id)
                                .withEmpleador(entidad.Id)
                                .withCuil('20414624416')
                                .withAccountId(cuenta.Id)
                                .withDelegacionId(delegacion.Id)
                                .withNroDeSolicitudSS('725187')
                                .withEstadoDeSolicitud('INCOMPLETA')
                                .build();
        insert casoSolicitudAltaFamiliar;
        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudAltaFamiliar.Id);
        insert nota;
        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = casoSolicitudAltaFamiliar.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;
        
        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                            .withStatusCode(200).withBody(WSCaseEnviarASSGenericResponseTest.jsonUpdate(nota.Id))
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/alta-familiar');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudAltaFamiliar.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
        Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c, Estado_de_solicitud__c  FROM Case WHERE id =:casoSolicitudAltaFamiliar.Id];
        System.assertEquals('NUEVA', updatedCase.Estado_DDJJ__c);
        System.assertEquals('COMPLETA', updatedCase.Estado_de_solicitud__c);
    }

    @isTest
    private static void sendDespegueTFToSSShouldReturnSuccessAndUpdateCase() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        insert new List<SObject> {delegacion, entidad, familiar, obraSocial, loc};
        
        Case casoSolicitudDespeguesFT = Build.aCaseSolicituddedespegues()
                                    .withDerivaAportes(true)
                                    .withAporte(5000)
                                    .withBebeSinDNI(true)
                                    .withCuit('20414624416')
                                    .withCuitEmpleador('20434624726')
                                    .withDiscapacidad(false)
                                    .withDNI('41462441')
                                    .withLocalidad(loc.Id)
                                    .withSupliedEmail('test@example.com')
                                    .withCalle('25')
                                    .withCondicionIva('CF-4')
                                    .withFacturaSinPapel('Verdadero')
                                    .withPlanDespegue('AS300')
                                    .withMedioDeCobro('DEBAUT')
                                    .withSegmentoGrupoFamiliar('OBLDIR')
                                    .withObraSocial2(obraSocial.Id)
                                    .withNumero(1548)
                                    .withTelefono('123456784')
                                    .withProvincia('Buenos Aires')
                                    .withEstadoCivil('N')
                                    .withFechaDeNacimiento(fechaNacimiento)
                                    .withFechaDeVigencia(fechaVigencia)
                                    .withFirstName('Santiago')
                                    .withLastName('Test')
                                    .withNacionalidad('Argentina')
                                    .withSexo('Masculino')
                                    .withTipodedocumento('DNI')
                                    .withEmpleador(entidad.Id)
                                    .withCuil('20414624416')
                                    .withTarjetaDeCredito('TRO04')
                                    .withNumeroDeTarjetaDeCredito('1234567895464')
                                    .withAccountId(familiar.Id)
                                    .withDelegacionId(delegacion.Id)
                                    .withType('FT')
                                    .build();
        insert casoSolicitudDespeguesFT;
        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudDespeguesFT.Id);
        insert nota;
        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = casoSolicitudDespeguesFT.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                            .withStatusCode(200).withBody(WSCaseEnviarASSGenericResponseTest.json(nota.Id))
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/despegue');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudDespeguesFT.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
        Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudDespeguesFT.Id];
        System.assertEquals('NUEVA', updatedCase.Estado_DDJJ__c);
        System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c);
    }

    @isTest
    private static void sendDespegueCTToSSShouldReturnSuccessAndUpdateCase() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        insert new List<SObject> {delegacion, entidad, familiar, obraSocial, loc};

        Case casoSolicitudDespeguesCT = Build.aCaseSolicituddedespegues()
                                    .withDerivaAportes(true)
                                    .withAporte(5000)
                                    .withBebeSinDNI(true)
                                    .withCuit('20414624416')
                                    .withCuitEmpleador('20434624726')
                                    .withDiscapacidad(false)
                                    .withDNI('41462441')
                                    .withEstadoCivil('N')
                                    .withFechaDeNacimiento(fechaNacimiento)
                                    .withFechaDeVigencia(fechaVigencia)
                                    .withFirstName('Santiago')
                                    .withLastName('Test')
                                    .withNacionalidad('Argentina')
                                    .withSexo('Masculino')
                                    .withTipodedocumento('DNI')
                                    .withObraSocial2(obraSocial.Id)
                                    .withEmpleador(entidad.Id)
                                    .withCuil('20414624416')
                                    .withAccountId(familiar.Id)
                                    .withDelegacionId(delegacion.Id)
                                    .withType('CT')
                                    .withCalle('1')
                                    .withNumero(1)
                                    .withPiso('1')
                                    .withDpto('1')
                                    .withPlanDespegue('AS300')
                                    .withSupliedEmail('email@test.com')
                                    .withTelefono('1234567891')
                                    .withCondicionIva('RI-1')
                                    .withMedioDeCobro('OTROS')
                                    .withFacturaSinPapel('Verdadero')
                                    .withSegmentoGrupoFamiliar('OBLDIR')
                                    .withProvincia('Buenos Aires')
                                    .withLocalidad(loc.Id)
                                    .build();
        insert casoSolicitudDespeguesCT;
        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudDespeguesCT.Id);
        insert nota;
        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = casoSolicitudDespeguesCT.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                        .withStatusCode(200).withBody(WSCaseEnviarASSGenericResponseTest.json(nota.Id))
                        .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/despegue');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudDespeguesCT.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
        Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudDespeguesCT.Id];
        System.assertEquals('NUEVA', updatedCase.Estado_DDJJ__c);
        System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c);
    }

    @isTest
    private static void sendDespegueWithIntegrantesToSSShouldReturnSuccessAndUpdateCase() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        insert new List<SObject> {delegacion, entidad, cuenta, obraSocial};

        Case casoSolicitudDespeguesTF = Build.aCaseSolicituddedespegues()
                                    .withDerivaAportes(true)
                                    .withAporte(5000)
                                    .withBebeSinDNI(true)
                                    .withCuit('20414624416')
                                    .withCuitEmpleador('20434624726')
                                    .withDiscapacidad(false)
                                    .withDNI('41462441')
                                    .withEstadoCivil('N')
                                    .withFechaDeNacimiento(fechaNacimiento)
                                    .withFechaDeVigencia(fechaVigencia)
                                    .withFirstName('Santiago')
                                    .withLastName('Test')
                                    .withNacionalidad('Argentina')
                                    .withSexo('Masculino')
                                    .withTipodedocumento('DNI')
                                    .withTipoDeParentesco('CO')
                                    .withTitular(cuenta.Id)
                                    .withObraSocial2(obraSocial.Id)
                                    .withEmpleador(entidad.Id)
                                    .withCuil('20414624416')
                                    .withAccountId(cuenta.Id)
                                    .withDelegacionId(delegacion.Id)
                                    .withType('TF')
                                    .build();
        insert casoSolicitudDespeguesTF;
        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudDespeguesTF.Id);
        insert nota;
        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = casoSolicitudDespeguesTF.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;
        List<Integrante_caso__c> integrantes = new List<Integrante_caso__c> {
            Build.anIntegranteCaso()
                    .withApellido('test')
                    .withNombre('tesst')
                    .withTipoDocumento('DNI')
                    .withNroDocumento('72096961')
                    .withEstadoCivil('CO')
                    .withSexo('F')
                    .withFechaNacimiento(Date.newInstance(1970, 07, 20))
                    .withDiscapacidad('Si')
                    .withNacionalidad('054')
                    .withIndicadorDeAporte(true)
                    .withAporte(5000)
                    .withCuit('30720969617')
                    .withEmpleador(entidad.Id)
                    .withTipoDeRelacionConTitular('CO')
                    .withCase(casoSolicitudDespeguesTF.Id)
                    .build(),

            Build.anIntegranteCaso()
                    .withApellido('test')
                    .withNombre('tesst')
                    .withTipoDocumento('DNI')
                    .withNroDocumento('71096961')
                    .withEstadoCivil('CO')
                    .withSexo('F')
                    .withFechaNacimiento(Date.newInstance(1970, 07, 20))
                    .withDiscapacidad('Si')
                    .withNacionalidad('054')
                    .withIndicadorDeAporte(true)
                    .withAporte(5000)
                    .withCuit('30710969619')
                    .withEmpleador(entidad.Id)
                    .withTipoDeRelacionConTitular('CO')
                    .withCase(casoSolicitudDespeguesTF.Id)
                    .build()
        };
        
        insert integrantes;
        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK').withStatusCode(200)
                                .withBody(WSCaseEnviarASSGenericResponseTest.json(nota.Id))
                                .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/despegue');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudDespeguesTF.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
        Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudDespeguesTF.Id];
        System.assertEquals('NUEVA', updatedCase.Estado_DDJJ__c);
        System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c);
    }

    @isTest
    private static void sendDespegueWithNotaDeAuditoriaToSSShouldReturnSuccessAndUpdateCase() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        insert new List<SObject> {delegacion, entidad, cuenta, obraSocial};
        
        Case casoSolicitudDespeguesTF = Build.aCaseSolicituddedespegues()
                                    .withDerivaAportes(true)
                                    .withAporte(5000)
                                    .withBebeSinDNI(true)
                                    .withCuit('20414624416')
                                    .withCuitEmpleador('20434624726')
                                    .withDiscapacidad(false)
                                    .withDNI('41462441')
                                    .withEstadoCivil('N')
                                    .withFechaDeNacimiento(fechaNacimiento)
                                    .withFechaDeVigencia(fechaVigencia)
                                    .withFirstName('Santiago')
                                    .withLastName('Test')
                                    .withNacionalidad('Argentina')
                                    .withSexo('Masculino')
                                    .withTipodedocumento('DNI')
                                    .withTipoDeParentesco('CO')
                                    .withTitular(cuenta.Id)
                                    .withObraSocial2(obraSocial.Id)
                                    .withEmpleador(entidad.Id)
                                    .withCuil('20414624416')
                                    .withAccountId(cuenta.Id)
                                    .withDelegacionId(delegacion.Id)
                                    .withType('TF')
                                    .build();
        insert casoSolicitudDespeguesTF;

        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudDespeguesTF.Id);
        insert nota;

        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = casoSolicitudDespeguesTF.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK').withStatusCode(200)
                        .withBody(WSCaseEnviarASSGenericResponseTest.json(nota.Id))
                        .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/despegue');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudDespeguesTF.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
        Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudDespeguesTF.Id];
        System.assertEquals('NUEVA', updatedCase.Estado_DDJJ__c);
        System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c);
    }

    @isTest
    private static void sendCambioSegmentoWithCorrectDataToSSShouldReturnSuccessAndUpdateCase() {
        insert cv;
        insert entidad;
        insert obraSocial;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

        Case casoSolicitudCambioSegmento = Build.aCaseSolicitudDeCambioSegmento()
                                .withStatus('Pendiente')
                                .withType('Pregunta')
                                .withCuitEmpleador('20434624726')
                                .withRazonSocial('Empresa falsa 123')
                                .withFechaDeVigencia(Date.newInstance(2020, 05, 01))
                                .withNuevoSegmento('OBLDIR')
                                .withAporte(5000)
                                .withCuit('2041462477')
                                .withObraSocial2(obraSocial.Id)
                                .withEmpleador(entidad.Id)
                                .build();
        insert casoSolicitudCambioSegmento;
        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudCambioSegmento.Id);
        insert nota;
        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = casoSolicitudCambioSegmento.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK').withStatusCode(200)
                            .withBody(WSCaseEnviarASSGenericResponseTest.json(nota.Id))
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/cambio-segmento');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudCambioSegmento.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
        Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudCambioSegmento.Id];
        System.assertEquals('NUEVA', updatedCase.Estado_DDJJ__c);
        System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c);
    }

    @isTest
    private static void sendCambioSegmentoUpdateToSSShouldTransformToComplete() {
        insert new List<SObject> {cv, entidad, obraSocial};
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

        Case casoSolicitudCambioSegmento = Build.aCaseSolicitudDeCambioSegmento()
                                .withStatus('Pendiente')
                                .withType('Pregunta')
                                .withCuitEmpleador('20434624726')
                                .withRazonSocial('Empresa falsa 123')
                                .withFechaDeVigencia(Date.newInstance(2020, 05, 01))
                                .withNuevoSegmento('OBLDIR')
                                .withAporte(5000)
                                .withCuit('2041462477')
                                .withObraSocial2(obraSocial.Id)
                                .withEmpleador(entidad.Id)
                                .withNroDeSolicitudSS('725187')
                                .withEstadoDeSolicitud('INCOMPLETA')
                                .build();
        insert casoSolicitudCambioSegmento;
        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoSolicitudCambioSegmento.Id);
        insert nota;
        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = casoSolicitudCambioSegmento.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK').withStatusCode(200)
                            .withBody(WSCaseEnviarASSGenericResponseTest.jsonUpdate(nota.Id))
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/cambio-segmento');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudCambioSegmento.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
        Case updatedCase = [SELECT Estado_de_solicitud__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoSolicitudCambioSegmento.Id];
        System.assertEquals('COMPLETA', updatedCase.Estado_de_solicitud__c);
    }

    @isTest
    private static void sendInvalidDespegueToSSShouldReturnError() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        insert delegacion;
        insert entidad;
        insert cuenta;
        insert obraSocial;
        
        Case casoSolicitudDespeguesTF = Build.aCaseSolicituddedespegues()
                                    .withDerivaAportes(true)
                                    .withAporte(5000)
                                    .withBebeSinDNI(true)
                                    .withCuit('20414624416')
                                    .withCuitEmpleador('20434624726')
                                    .withDiscapacidad(false)
                                    .withDNI('41462441')
                                    .withEstadoCivil('N')
                                    .withFechaDeNacimiento(fechaNacimiento)
                                    .withFechaDeVigencia(fechaVigencia)
                                    .withFirstName('Santiago')
                                    .withLastName('Test')
                                    .withNacionalidad('Argentina')
                                    .withSexo('Masculino')
                                    .withTipodedocumento('DNI')
                                    .withTipoDeParentesco('CO')
                                    .withTitular(cuenta.Id)
                                    .withObraSocial2(obraSocial.Id)
                                    .withEmpleador(entidad.Id)
                                    .withCuil('20414624416')
                                    .withAccountId(cuenta.Id)
                                    .withDelegacionId(delegacion.Id)
                                    .withType('TF')
                                    .build();
        insert casoSolicitudDespeguesTF;

        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = casoSolicitudDespeguesTF.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers'); 
        insert contentlink;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                        .withStatusCode(422).withBody(WSCaseEnviarASSGenericResponseTest.jsonError)
                        .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/despegue');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudDespeguesTF.Id,false);
        Test.stopTest();
        System.assertEquals(true, response.hasError, response.message);
    }

    @isTest
    private static void sendInvalidAltaFamiliarToSSShouldReturnError() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        insert delegacion;
        insert entidad;
        insert cuenta;
        insert obraSocial;
        
        Case casoSolicitudAltaFamiliar = Build.aCaseSolicituddealtafamiliar()
                                .withDerivaAportes(true)
                                .withAporte(5000)
                                .withBebeNacidoEnElSistema(true)
                                .withBebeSinDNI(true)
                                .withCuit('20414624416')
                                .withInformacionAlAsociado('Sin DNI')
                                .withInformacionCompleta(true)
                                .withCuitEmpleador('20434624726')
                                .withDiscapacidad(false)
                                .withDNI('41462441')
                                .withEstadoCivil('N')
                                .withFechaDeNacimiento(fechaNacimiento)
                                .withFechaDeVigencia(fechaVigencia)
                                .withFirstName('Santiago')
                                .withLastName('Test')
                                .withNacionalidad('Argentina')
                                .withSexo('Masculino')
                                .withTipodedocumento('DNI')
                                .withTipoDeParentesco('CO')
                                .withObraSocial2(obraSocial.Id)
                                .withEmpleador(entidad.Id)
                                .withCuil('20414624416')
                                .withAccountId(cuenta.Id)
                                .withDelegacionId(delegacion.Id)
                                .build();
        insert casoSolicitudAltaFamiliar;

        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = casoSolicitudAltaFamiliar.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                            .withStatusCode(422).withBody(WSCaseEnviarASSGenericResponseTest.jsonError)
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/alta-familiar');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoSolicitudAltaFamiliar.Id,false);
        Test.stopTest();
        System.assertEquals(true, response.hasError, response.message);
    }


    @isTest
    private static void tryToSubmitInvalidCaseTypeShouldGetError() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        Case caso = new Case();
        insert caso;
        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = caso.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                    .withStatusCode(200).withBody(WSCaseEnviarASSGenericResponseTest.json(''))
                    .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/despegue');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(caso.Id,false);
        Test.stopTest();
        System.assertEquals(true, response.hasError, response.message);
    }

    @isTest
    private static void tryToSubmitACaseWithoutFilesShouldReturnError() {
        Case caso = new Case();
        insert caso;

        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(caso.Id,false);
        Test.stopTest();
        System.assertEquals(true, response.hasError, response.message);
    }

    @isTest
    private static void sendBajaParcialWithCorrectDataShouldUpdateCase() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        insert new List<SObject>{familiar, cuenta};
        Case casoBajaParcial = Build.aCaseSolicitudDeBaja()
                                        .withAccountId(cuenta.Id)
                                        .withType('Baja parcial')
                                        .withFechaDeVigencia(Date.newInstance(2020, 01, 01))
                                        .withMotivoDeLaBaja('2')
                                        .build();
        insert casoBajaParcial;
        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoBajaParcial.Id);
        insert nota;
        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = casoBajaParcial.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;

        Integrante_caso__c integrante = Build.anIntegranteCasoBajas()
                                                .withFamiliar(familiar.Id)
                                                .withMotivoDeLaBaja('2')
                                                .withCase(casoBajaParcial.Id)
                                                .build();
        
        insert integrante;
        
        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                            .withStatusCode(200).withBody(WSCaseEnviarASSGenericResponseTest.json(nota.Id, integrante.Id))
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/baja');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoBajaParcial.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
    }

    @isTest
    private static void sendBajaParcialWithoutIntegranteShouldReturnError() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        insert new List<SObject> {familiar, cuenta};
        Case casoBajaParcial = Build.aCaseSolicitudDeBaja()
                                        .withType('Baja parcial')
                                        .withAccountId(cuenta.Id)
                                        .withFechaDeVigencia(Date.newInstance(2020, 01, 01))
                                        .withMotivoDeLaBaja('2')
                                        .build();
        insert casoBajaParcial;

        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = casoBajaParcial.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;

        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoBajaParcial.Id,false);
        Test.stopTest();
        System.assertEquals(true, response.hasError, response.message);
    }

    @isTest
    private static void tryAddInvalidCaseInButtonShouldReturnError () {
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS('Holis',false);
        Test.stopTest();
        System.assertEquals(true, response.hasError, response.message);
    }
    

    @isTest
    private static void sendBajaTotalWithCorrectDataShouldUpdateCase() {
        insert new List<SObject> {cv, cuenta};
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

        Case casoBajaTotal = Build.aCaseSolicitudDeBaja()
                                        .withType('Baja total')
                                        .withAccountId(cuenta.Id)
                                        .withFechaDeVigencia(Date.newInstance(2020, 01, 01))
                                        .withMotivoDeLaBaja('2')
                                        .build();
        insert casoBajaTotal;
        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoBajaTotal.Id);
        insert nota;
        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = casoBajaTotal.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                    .withStatusCode(200).withBody(WSCaseEnviarASSGenericResponseTest.json(nota.Id))
                    .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/baja');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoBajaTotal.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
    }

    @isTest
    private static void sendInterfazFinancieraType_C_WithCorrectDataShouldUpdateCase() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

        Case caseIF = Build.aCaseSolicitudInterfazFinanciera()
                                        .withType('C')
                                        .withFechaDeVigencia(Date.newInstance(2020, 01, 01))
                                        .build();
        caseIF.CUIT__c = '20123456789';
        insert caseIF;
        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = caseIF.Id);
        insert nota;
        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = caseIF.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                    .withStatusCode(200).withBody(WSCaseEnviarASSGenericResponseTest.json(nota.Id))
                    .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/interfaz-financiera');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(caseIF.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
    }

    @isTest
    private static void sendInterfazFinancieraUpdateWithCorrectDataShouldTransformCaseToComplete() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

        Case caseIF = Build.aCaseSolicitudInterfazFinanciera()
                                        .withType('C')
                                        .withFechaDeVigencia(Date.newInstance(2020, 01, 01))
                                        .withNroDeSolicitudSS('725187')
                                        .withEstadoDeSolicitud('INCOMPLETA')
                                        .build();
        caseIF.CUIT__c = '20123456789';
        insert caseIF;
        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = caseIF.Id);
        insert nota;
        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = caseIF.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers'
                                                                );
        insert contentlink;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                    .withStatusCode(200).withBody(WSCaseEnviarASSGenericResponseTest.jsonUpdate(nota.Id))
                    .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/interfaz-financiera');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(caseIF.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
        caseIF = [SELECT Estado_de_solicitud__c FROM Case WHERE Id = :caseIF.Id];
        System.assertEquals('COMPLETA', caseIF.Estado_de_solicitud__c, 'No se esta completando la actualizacion');
    }
    
    
    @isTest
    private static void sendInterfazFinancieraType_T_WithCorrectDataShouldUpdateCase() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

        Case caseIF = Build.aCaseSolicitudInterfazFinanciera()
                                        .withType('T')
                                        .withCuilTitular('20328322529')
                                        .withCBU('23123123123123')
                                        .withFechaDeVigencia(Date.newInstance(2020, 01, 01))
                                        .build();
        insert caseIF;
        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = caseIF.Id);
        insert nota;
        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = caseIF.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                    .withStatusCode(200).withBody(WSCaseEnviarASSGenericResponseTest.json(nota.Id))
                    .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/interfaz-financiera');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(caseIF.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
    }

    @isTest
    private static void sendBajaTotalUpdateWithCorrectDataShouldTransformToComplete() {
        insert new List<SObject> {cv, cuenta};
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        
        Case casoBajaTotal = Build.aCaseSolicitudDeBaja()
                                        .withType('Baja total')
                                        .withAccountId(cuenta.Id)
                                        .withFechaDeVigencia(Date.newInstance(2020, 01, 01))
                                        .withMotivoDeLaBaja('2')
                                        .withNroDeSolicitudSS('725187')
                                        .withEstadoDeSolicitud('INCOMPLETA')
                                        .build();
        insert casoBajaTotal;
        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoBajaTotal.Id);
        insert nota;
        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = casoBajaTotal.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                    .withStatusCode(200).withBody(WSCaseEnviarASSGenericResponseTest.jsonUpdate(nota.Id))
                    .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/baja');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoBajaTotal.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
    }

    @isTest
    private static void sendCredentialRequestShouldUpdateCase() {
        insert cuenta;
        Case casoCredencial = Build.aCaseSolicitudDeCredencial()
                                        .withAccountId(cuenta.Id)
                                        .build();
        insert casoCredencial;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                    .withStatusCode(200).withBody(WSCaseEnviarASSGenericResponseTest.jsonUpdate(''))
                    .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/reemision-credencial');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoCredencial.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
    }

    @isTest
    private static void sendCredentialRequestShouldToAnInvalidAccountShouldReturnError() {
        insert cuenta;
        Case casoCredencial = Build.aCaseSolicitudDeCredencial()
                                        .withAccountId(cuenta.Id)
                                        .build();
        insert casoCredencial;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse()
                    .withStatusCode(422)
                    .withBody(WSCaseEnviarASSGenericResponseTest.jsonError)
                    .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/reemision-credencial');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoCredencial.Id,false);
        Test.stopTest();
        System.assertEquals(true, response.hasError, response.message);
    }

    @isTest
    private static void sendSolicitudCambioPlanWithCorrectDataShouldUpdateCase() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        insert new List<SObject> {delegacion, cuenta};
        Case casoCambioPlan = Build.aCaseSolicitudCambioPlan()
                                        .withPlanDespegue('AS300')
                                        .withFechaDeVigencia(Date.newInstance(2020, 01, 01))
                                        .withAccountId(cuenta.Id)
                                        .withDelegacionId(delegacion.Id)
                                        .build();
        insert casoCambioPlan;
        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoCambioPlan.Id);
        insert nota;
        ContentDocumentLink contentlink = new ContentDocumentLink(
                LinkedEntityId = casoCambioPlan.id,
                ContentDocumentId = cv.contentDocumentId, 
                Visibility = 'AllUsers');
        insert contentlink;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse()
                    .withStatusCode(200)
                    .withStatus('OK')
                    .withBody(WSCaseEnviarASSGenericResponseTest.json(nota.Id))
                    .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/cambio-plan');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoCambioPlan.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
    }

    @isTest
    private static void sendSolicitudCambioPlanUpdateWithCorrectDataShouldTransformToComplete() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        insert new List<SObject> {delegacion, cuenta};
        Case casoCambioPlan = Build.aCaseSolicitudCambioPlan()
                                        .withPlanDespegue('AS300')
                                        .withFechaDeVigencia(Date.newInstance(2020, 01, 01))
                                        .withAccountId(cuenta.Id)
                                        .withNroDeSolicitudSS('725187')
                                        .withEstadoDeSolicitud('INCOMPLETA')
                                        .withDelegacionId(delegacion.Id)
                                        .build();
        insert casoCambioPlan;
        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoCambioPlan.Id);
        insert nota;
        ContentDocumentLink contentlink = new ContentDocumentLink(
                LinkedEntityId = casoCambioPlan.id,
                ContentDocumentId = cv.contentDocumentId, 
                Visibility = 'AllUsers');
        insert contentlink;

        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse()
                    .withStatusCode(200)
                    .withStatus('OK')
                    .withBody(WSCaseEnviarASSGenericResponseTest.jsonUpdate(nota.Id))
                    .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/cambio-plan');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoCambioPlan.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
        casoCambioPlan = [SELECT Estado_de_solicitud__c FROM Case WHERE Id = :casoCambioPlan.Id];
        System.assertEquals('COMPLETA', casoCambioPlan.Estado_de_solicitud__c, 'No se esta completando la actualizacion');
    }

    @isTest
    private static void sendSolicitudCasoDatosParticularesWithCorrectDataAndType_P_ShouldUpdateCase() {
        insert cv;
        insert obraSocial;
        Case casoDatosParticulares = Build.anCaseSolicitudDatosParticulares()
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
        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse()
                    .withStatusCode(200)
                    .withStatus('OK')
                    .withBody(WSCaseEnviarASSGenericResponseTest.json(nota.Id))
                    .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/datos-particulares');

        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoDatosParticulares.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
        Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoDatosParticulares.Id];
        System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c);
    }

    @isTest
    private static void sendSolicitudCasoDatosParticularesDPARTWithCorrectDataShouldUpdateCase() {
        insert cv;
        insert cuenta;
        insert obraSocial;
        Case casoDatosParticulares = Build.anCaseSolicitudDatosParticulares()
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
        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse()
                    .withStatusCode(200)
                    .withStatus('OK')
                    .withBody(WSCaseEnviarASSGenericResponseTest.json(nota.Id))
                    .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/datos-particulares');

        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoDatosParticulares.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
        Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoDatosParticulares.Id];
        System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c);
    } 
    
    @isTest
    private static void sendSolicitudCasoDatosParticularesDELEGWithCorrectDataShouldUpdateCase() {
        insert cv;
        insert obraSocial;
        insert delegacion;
        insert cuenta;
        Case casoDatosParticulares = Build.anCaseSolicitudDatosParticulares()
                                            .withFechaDeVigencia(Date.newInstance(2020, 01, 01))
                                            .withAccountId(cuenta.Id)
                                            .withType('MODIF_DELEG')
                                            .withAgenciaDestino(delegacion.Id)
                                            .build();
        insert casoDatosParticulares;
        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoDatosParticulares.Id);
        insert nota;
        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
            .withStatus('OK')
            .withStatusCode(200)
            .withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse()
                    .withStatusCode(200)
                    .withStatus('OK')
                    .withBody(WSCaseEnviarASSGenericResponseTest.json(nota.Id))
                    .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/datos-particulares');

        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        CaseSendToSSGenericBtnCtrl.Response response = CaseSendToSSGenericBtnCtrl.sendToSS(casoDatosParticulares.Id,false);
        Test.stopTest();
        System.assertEquals(false, response.hasError, response.message);
        Case updatedCase = [SELECT Estado_DDJJ__c, Nro_de_solicitud_SS__c  FROM Case WHERE id =:casoDatosParticulares.Id];
        System.assertEquals('725187', updatedCase.Nro_de_solicitud_SS__c);
    }

    
    @isTest
    private static void sendBajaParcialThrowBatchWithCorrectDataShouldUpdateCase() {
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        insert new List<SObject>{familiar, cuenta};
        Case casoBajaParcial = Build.aCaseSolicitudDeBaja()
                                        .withAccountId(cuenta.Id)
                                        .withType('Baja parcial')
                                        .withFechaDeVigencia(Date.newInstance(2020, 01, 01))
                                        .withMotivoDeLaBaja('2')
                                        .build();
        insert casoBajaParcial;
        Nota_de_Auditoria__c nota = new Nota_de_Auditoria__c(Nota__c = 'Nota de auditoria', APr_Id__c = casoBajaParcial.Id);
        insert nota;
        ContentDocumentLink contentlink = new ContentDocumentLink(
                                                                        LinkedEntityId = casoBajaParcial.id,
                                                                        ContentDocumentId = cv.contentDocumentId, 
                                                                        Visibility = 'AllUsers');
        insert contentlink;

        Integrante_caso__c integrante = Build.anIntegranteCasoBajas()
                                                .withFamiliar(familiar.Id)
                                                .withMotivoDeLaBaja('2')
                                                .withCase(casoBajaParcial.Id)
                                                .build();
        
        insert integrante;
        
        XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
            .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

        getResponseFound.buildResponse().withStatus('OK')
                            .withStatusCode(200).withBody(WSCaseEnviarASSGenericResponseTest.json(nota.Id, integrante.Id))
                            .addForAddress(SERVICE_CONFIG.URL__c + '/v1/salud/solicitudes-afiliados/baja');

        Test.setMock(HttpCalloutMock.class, getResponseFound); 
        Test.startTest();
        CaseSendToSSAttachmentQueueable queueable = new CaseSendToSSAttachmentQueueable(casoBajaParcial.Id);
        queueable.execute(null);
        Test.stopTest();
    }

}