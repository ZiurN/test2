@IsTest
private class WSCotizadorTest {

    static XHttpCalloutMock getResponseFound;
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
                .withBody(WSCotizadorMock.getFound())
                .addForAddress(WSCotizador.SERVICE_CONFIG.URL__c + '/v1/cotizador/cotizaciones');


        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Invalid data')
                .withStatusCode(404)
                .withBody(WSCotizadorMock.getError())
                .addForAddress(WSCotizador.SERVICE_CONFIG.URL__c + '/v1/cotizador/cotizaciones');
    }

    @IsTest
    static void whenWSCotizadorIsConsumedWithValidDataItShouldReturnACotizacion() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        String body = '{'+
                '"nombrePersona": "Julian Germano",'+
                '"edad": 119,'+
                '"tipoDniId": 1,'+
                '"numeroDni": 34576890,'+
                '"domicilio": {'+
                '"direccion": "a",'+
                '"localidadId": 1366,'+
                '"piso": 180'+
                '},'+
                '"estadoCivilId": 2, '+
                '"edadConyuge" : 82,'+
                '"nroTelefono": "03537-413369",'+
                '"tipoAfiliadoId": 2,'+
                '"sueldoBruto": 50000,'+
                '"tipoContactoId": 2, '+
                '"cantHijosHasta20": 0,'+
                '"cantHijosEntre21y25": 2,'+
                '"email": "jgermano@gmail.com",'+
                '"conyugeMonotributista": false,'+
                '"formaDePagoId": 1,'+
                '"planId": 2 '+
                '}';
        Test.startTest();
        WSCotizador.Response responseToAssert = WSCotizador.cotizar(body);
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals(200, responseToAssert.response.getStatusCode());
        System.assertEquals('OK', responseToAssert.response.getStatus());
        System.assertEquals('0000046033', responseToAssert.cotizacion.data.nroCotizacion);
        System.assertEquals(3192.95, responseToAssert.cotizacion.data.precioTitular);
        System.assertEquals(2313.67, responseToAssert.cotizacion.data.precioConyuge);
        System.assertEquals(null, responseToAssert.cotizacion.data.precioPrimerHijoMenor21);
        System.assertEquals(null, responseToAssert.cotizacion.data.precioSegundoHijoMenor21);
        System.assertEquals(null, responseToAssert.cotizacion.data.precioTercerHijoOMasMenores21);
        System.assertEquals(2553.21, responseToAssert.cotizacion.data.precioHijosEntre21y25);
        System.assertEquals(8059.84, responseToAssert.cotizacion.data.precioTotal);
        System.assertEquals(32500, responseToAssert.cotizacion.data.deduccionAportes);
        System.assertEquals(null, responseToAssert.cotizacion.data.deduccionAportesMonotributo);
        System.assertEquals(805.98, responseToAssert.cotizacion.data.bonificacionEspecial6Meses);
        System.assertEquals(1208.98, responseToAssert.cotizacion.data.descuentoPorPagoDebitoCBU);
        System.assertEquals(null, responseToAssert.cotizacion.data.descuentoPorPagoTarjeta);
        System.assertEquals(2794.88, responseToAssert.cotizacion.data.diferenciaAPagar);
        System.assertEquals(4, responseToAssert.cotizacion.data.totalCapitas);
        System.assertEquals('25436', responseToAssert.cotizacion.data.idPersona);

    }

    @IsTest
    static void whenWSCotizadorIsConsumedWithInvalidDataItShouldReturnAnError() {
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        String body = '{'+
                '"nombrePersona": "Julian Germano",'+
                '"edad": 119,'+
                '"tipoDniId": 1,'+
                '"domicilio": {'+
                '"direccion": "a",'+
                '"localidadId": 1366,'+
                '"piso": 180'+
                '},'+
                '"estadoCivilId": 2, '+
                '"edadConyuge" : 82,'+
                '"nroTelefono": "03537-413369",'+
                '"tipoAfiliadoId": 2,'+
                '"sueldoBruto": 50000,'+
                '"tipoContactoId": 2, '+
                '"cantHijosHasta20": 0,'+
                '"cantHijosEntre21y25": 2,'+
                '"email": "jgermano@gmail.com",'+
                '"conyugeMonotributista": false,'+
                '"formaDePagoId": 1,'+
                '"planId": 2 '+
                '}';
        Test.startTest();
        WSCotizador.Response responseToAssert = WSCotizador.cotizar(body);
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals(404, responseToAssert.response.getStatusCode());
        System.assertEquals('Invalid data', responseToAssert.response.getStatus());

    }
}