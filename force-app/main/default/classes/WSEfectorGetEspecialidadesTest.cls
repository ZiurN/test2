@IsTest
private class WSEfectorGetEspecialidadesTest {
    @IsTest
    static void whenTheWSIsConsume_GetListOfEspecialidadesFromEfector() {
		insert new Access_Token__c(SetupOwnerId=Userinfo.getOrganizationId());
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        WSEfectorGetEspecialidades.Response responseToAssert = WSEfectorGetEspecialidades.getEfectorEspecialidades(
                '700616');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());

        System.assertEquals(45, responseToAssert.especialidades.data.size());

        System.assertEquals('SANATORIO PARQUE', responseToAssert.especialidades.data[0].nombre);
        System.assertEquals('A', responseToAssert.especialidades.data[0].aca_cartilla);
        System.assertEquals('CIRUGIA PLASTICA Y REPARADORA',
                responseToAssert.especialidades.data[0].descripcion);
        System.assertEquals('538', responseToAssert.especialidades.data[0].especialidad);
        System.assertEquals('700616', responseToAssert.especialidades.data[0].efector);


    }

    @IsTest
    private static void whenTheWSIsConsume_GetEmptyListOfEspecialidades(){
		insert new Access_Token__c(SetupOwnerId=Userinfo.getOrganizationId());

        Test.setMock(HttpCalloutMock.class, getEmptyResponse);
        Test.startTest();
        WSEfectorGetEspecialidades.Response responseToAssert = WSEfectorGetEspecialidades.getEfectorEspecialidades('0');
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());

        System.assertEquals(0, responseToAssert.especialidades.data.size());
    }



    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getEmptyResponse;

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
    }
}