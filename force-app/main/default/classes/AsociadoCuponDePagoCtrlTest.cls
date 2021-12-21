@IsTest
public class AsociadoCuponDePagoCtrlTest {
    @IsTest
    public static void whenConsumeWSAfiliadoDeudaSucess_returnAListOfDeudaData(){
        Test.setMock(HttpCalloutMock.class, getResponseFound);
        Test.startTest();
        AsociadoCuponDePagoCtrl.Response responseToAssert = AsociadoCuponDePagoCtrl.getDeudasAsociado(new Integer[]{23162069},System.today());
        Test.stopTest();

        System.assertEquals('Ok', responseToAssert.message);

        System.assertEquals(1, responseToAssert.datosDeDeudas.size());
        System.assertEquals('03/12/2019',responseToAssert.datosDeDeudas.get(0).vencimiento);
        System.assertEquals('B',responseToAssert.datosDeDeudas.get(0).p_cpr_letra_act);
        System.assertEquals('1566119',responseToAssert.datosDeDeudas.get(0).p_cpr_numero_act);
        System.assertEquals('22',responseToAssert.datosDeDeudas.get(0).p_cpr_sucursal_act);
        System.assertEquals('23162069',responseToAssert.datosDeDeudas.get(0).p_dat_nro);
        System.assertEquals('1',responseToAssert.datosDeDeudas.get(0).p_det_cuota_act);
        System.assertEquals('163.55',responseToAssert.datosDeDeudas.get(0).p_deuda_act);
        System.assertEquals('FA',responseToAssert.datosDeDeudas.get(0).p_tcp_codigo_act);



    }

    @IsTest
    private static void whenTheWSIsConsume_GetDeudaErrorResponse(){
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        Test.startTest();
        AsociadoCuponDePagoCtrl.Response responseToAssert = AsociadoCuponDePagoCtrl.getDeudasAsociado(new Integer[]{0},System.today());
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals('Hubo un error al intentar obtener los datos de las deudas desde SaludSoft',
                responseToAssert.message);
        System.assertEquals(null,responseToAssert.datosDeDeudas);

    }

    @IsTest
    public static void whenConsumeWSAfiliadoCuponDePagoSucess_returnAListOfCuponLinks(){
        Test.setMock(HttpCalloutMock.class,getResponseFoundCupon);
        String[] requests = new String[]{'{\n\t\"dat_nro\": 21406301,\n\t\"cuota\": 1,\n\t\"deuda\": \"7000.00\"\n}'};
        Test.startTest();
        AsociadoCuponDePagoCtrl.CuponResponse responseToAssert = AsociadoCuponDePagoCtrl.generateCupones(requests,'');
        Test.stopTest();

        System.assertEquals('', responseToAssert.message);

        System.assertEquals(1, responseToAssert.datosDeCupon.size());

    }

    @IsTest
    public static void whenConsumeWSAfiliadoCuponDePagoSendEmailSucess_returnDeliveryMessage(){
        Test.setMock(HttpCalloutMock.class,getResponseFoundCupon);
        String[] requests = new String[]{'{\n\t\"dat_nro\": 21406301,\n\t\"cuota\": 1,\n\t\"deuda\": \"7000.00\"\n}'};
        Test.startTest();
        AsociadoCuponDePagoCtrl.CuponResponse responseToAssert = AsociadoCuponDePagoCtrl.sendCupones(requests,'test@xyz.com','');
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();

        System.assertEquals(false, responseToAssert.hasError);
        System.assertEquals('Mail enviado',responseToAssert.message);


    }

//    @IsTest
//    public static void whenConsumeWSAfiliadoCuponDePagoSendEmailSucess_returnErrorMessage(){
//        Test.setMock(HttpCalloutMock.class,getResponseFoundCupon);
//        String[] requests = new String[]{'{\n\t\"dat_nro\": 21406301,\n\t\"cuota\": 1,\n\t\"deuda\": \"7000.00\"\n}'};
//        Test.startTest();
//        AsociadoCuponDePagoCtrl.CuponResponse responseToAssert = AsociadoCuponDePagoCtrl.sendCupones(requests,'test.com');
//        Test.stopTest();
//
//        System.assertEquals('Hubo un error al enviar los cupones de pago a su casilla de mail', responseToAssert.message);
//
//        System.assertEquals(null, responseToAssert.datosDeCupon);
//
//    }

    @IsTest
    public static void whenConsumeWSAfiliadoCuponDePagoSendEmailError(){
        Test.setMock(HttpCalloutMock.class,getErrorResponseCupon);
        String[] requests = new String[]{'{\n\t\"dat_nro\": 21406301,\n\t\"cuota\": 1,\n}'};
        Test.startTest();
        AsociadoCuponDePagoCtrl.CuponResponse responseToAssert = AsociadoCuponDePagoCtrl.sendCupones(requests,'test@xyz.com','');
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals('Hubo un error al intentar generar los cupones de pago desde SaludSoft' ,
                responseToAssert.message);
        System.assertEquals(null,responseToAssert.datosDeCupon);

    }

    @IsTest
    private static void whenTheWSIsConsume_GetCuponErrorResponse(){
        Test.setMock(HttpCalloutMock.class,getErrorResponseCupon);
        String[] requests = new String[]{'{\n\t\"dat_nro\": 21406301,\n\t\"cuota\": 1\n}'};
        Test.startTest();
        AsociadoCuponDePagoCtrl.CuponResponse responseToAssert = AsociadoCuponDePagoCtrl.generateCupones(requests,'');
        Test.stopTest();

        System.assertEquals(true, responseToAssert.hasError);
        System.assertEquals('Hubo un error al intentar generar los cupones de pago desde SaludSoft',
                responseToAssert.message);
        System.assertEquals(null,responseToAssert.datosDeCupon);

    }

    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorResponse;
    static XHttpCalloutMock getResponseFoundCupon;
    static XHttpCalloutMock getErrorResponseCupon;

    static {
        String today = System.now().format('yyyy-MM-dd');
        getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAsociadoGetDeudaMock.getFound())
                .addForAddress(WSAsociadoGetDeuda.SERVICE_CONFIG.URL__c + '/v1/salud/cuenta-corriente/deuda-actual/23162069/'+ today);

        getErrorResponse = new XHttpCalloutMock();
        getErrorResponse.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponse.buildResponse()
                .withStatus('Not Found')
                .withStatusCode(404)
                .withBody(WSAsociadoGetDeudaMock.getError())
                .addForAddress(WSAsociadoGetDeuda.SERVICE_CONFIG.URL__c + '/v1/salud/cuenta-corriente/deuda-actual/0/' + today);

        getResponseFoundCupon = new XHttpCalloutMock();
        getResponseFoundCupon.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFoundCupon.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAsociadoGetCuponDePagoMock.getFound())
                .addForAddress(WSAsociadoGetCuponDePago.SERVICE_CONFIG.URL__c + '/v1/salud/cupones');

        getErrorResponseCupon = new XHttpCalloutMock();
        getErrorResponseCupon.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getErrorResponseCupon.buildResponse()
                .withStatus('Not Found')
                .withStatusCode(404)
                .withBody(WSAsociadoGetCuponDePagoMock.getError())
                .addForAddress(WSAsociadoGetCuponDePago.SERVICE_CONFIG.URL__c + '/v1/salud/cupones');
    }

}