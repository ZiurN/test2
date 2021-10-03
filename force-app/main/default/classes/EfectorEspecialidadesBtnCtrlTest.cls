@IsTest
private class EfectorEspecialidadesBtnCtrlTest {
    @IsTest
    static void whenTheBtnIsClickedInTheView_consumeWSEfectorGetEspecialidadesSucess_returnAListOfEspecialidades() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        EfectorEspecialidadesBtnCtrl.Response responseToAssert = EfectorEspecialidadesBtnCtrl.getEspecialidadesEfector(
                '700616');
        Test.stopTest();

        System.assertEquals(false,responseToAssert.hasError);
        System.assertEquals('',responseToAssert.message);
        System.assertEquals(45,responseToAssert.especialidades.size());
        System.assertEquals('SANATORIO PARQUE', responseToAssert.especialidades[0].nombre);
        System.assertEquals('A', responseToAssert.especialidades[0].aca_cartilla);
        System.assertEquals('CIRUGIA PLASTICA Y REPARADORA',
                responseToAssert.especialidades[0].descripcion);
        System.assertEquals('538', responseToAssert.especialidades[0].especialidad);
        System.assertEquals('700616', responseToAssert.especialidades[0].efector);
    }

    @IsTest
    static void whenTheWSIsConsume_GetEspecialidadesErrorResponse() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Test.startTest();
        EfectorEspecialidadesBtnCtrl.Response responseToAssert = EfectorEspecialidadesBtnCtrl.getEspecialidadesEfector('0');
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals('Hubo un error al intentar obtener las especialidades del efector desde SaludSoft',
                responseToAssert.message);
        System.assertEquals(null, responseToAssert.especialidades);
    }

    @IsTest
    static void whenTheWSIsConsume_GetEspecialidadesEfectorEmptyResponse() {
        Test.setMock(HttpCalloutMock.class, getEmptyResponse);
        Test.startTest();
        EfectorEspecialidadesBtnCtrl.Response responseToAssert = EfectorEspecialidadesBtnCtrl.getEspecialidadesEfector('0');
        Test.stopTest();

        System.assertEquals(false,responseToAssert.hasError);
        System.assertEquals('',responseToAssert.message);
        System.assertEquals(0,responseToAssert.especialidades.size());
    }

    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getEmptyResponse;
	static XHttpCalloutMock getErrorResponse;

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
                .withBody(WSEfectorGetEspecialidadesMock.getFound())
                .addForAddress(WSEfectorGetEspecialidades.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/especialidades?' +
                'filter[codigo_efector]=700616');

        getEmptyResponse = new XHttpCalloutMock();
        getEmptyResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getEmptyResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSEfectorGetEspecialidadesMock.getEmpty())
                .addForAddress(WSEfectorGetEspecialidades.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/especialidades?' +
                'filter[codigo_efector]=0');

        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSEfectorGetEspecialidadesMock.getError())
                .addForAddress(WSEfectorGetEspecialidades.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/especialidades?' +
                'filter[codigo_efector]=0');
    }
}