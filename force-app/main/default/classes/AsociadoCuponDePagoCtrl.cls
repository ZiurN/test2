public class AsociadoCuponDePagoCtrl {

    @AuraEnabled
    public static Response getDeudasAsociado(Integer[] idComprobante,Date fecha) {

        WSAsociadoGetDeuda.Response[] responses = new List<WSAsociadoGetDeuda.Response>();
		WSAsociadoGetDeuda.Response firstResponse = WSAsociadoGetDeuda.getAsociadoDeuda(idComprobante.get(0),fecha,'');
		String token = firstResponse.message;
		responses.add(firstResponse);
		idComprobante.remove(0);

        for(Integer id : idComprobante){
            responses.add( WSAsociadoGetDeuda.getAsociadoDeuda(id,fecha,token));
        }

        List<WSAsociadoGetDeudaResp.Data> filterList = new List<WSAsociadoGetDeudaResp.Data>();
        for(WSAsociadoGetDeuda.Response wsResponse : responses){
            if(!wsResponse.hasError){

                filterList.add(wsResponse.asociadoDeuda.data);


            }
            else{
                return new Response(true,
                        'Hubo un error al intentar obtener los datos de las deudas desde SaludSoft',
                        null);
            }
        }

        return new Response(false, token, filterList);

    }

    @AuraEnabled
    public static CuponResponse generateCupones(String[] requests,String token){
        WSAsociadoGetCuponDePago.Response[] responses = new List<WSAsociadoGetCuponDePago.Response>();
        for(String req: requests){
            responses.add(WSAsociadoGetCuponDePago.generateCupon(req,token));
        }
        List<WSAsociadoGetCuponDePagoResp.Data> filterList = new List<WSAsociadoGetCuponDePagoResp.Data>();
        for(WSAsociadoGetCuponDePago.Response wsResponse : responses){
            if(!wsResponse.hasError){
                filterList.add(wsResponse.linkDePago.Data);
            }
            else{
                return new CuponResponse(true,
                        'Hubo un error al intentar generar los cupones de pago desde SaludSoft',
                        null);
            }
        }

        return new CuponResponse(false, '', filterList);
    }

    @AuraEnabled
    public static CuponResponse sendCupones(String[] requests,String address,String token){
		OrgWideEmailAddress[] owa = [
			SELECT id, Address, DisplayName 
			FROM OrgWideEmailAddress 
			WHERE DisplayName = 'AVALIAN'
		];
        WSAsociadoGetCuponDePago.Response[] responses = new List<WSAsociadoGetCuponDePago.Response>();
        List<WSAsociadoGetCuponDePagoResp.Data> filterList = new List<WSAsociadoGetCuponDePagoResp.Data>();

        for(String req: requests){
            responses.add(WSAsociadoGetCuponDePago.generateCupon(req,''));
        }

        for(WSAsociadoGetCuponDePago.Response wsResponse : responses){
            if(!wsResponse.hasError){
                filterList.add(wsResponse.linkDePago.data);
            }
            else{
                return new CuponResponse(true,
                        'Hubo un error al intentar generar los cupones de pago desde SaludSoft' ,
                        null);
            }
        }

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] to = new String[] {address};

        email.setToAddresses(to);
        email.setSubject('Cupones de pago');
        String htmlBody = '<h2>Cupones de pago generados</h2>';
        for(WSAsociadoGetCuponDePagoResp.Data data : filterList){
            htmlBody = htmlBody + '<br><a href="'+data.link+'">Cupon '+ data.link.replace('http://www.extranet.acasalud.com.ar/SF/','') +'</a>';
        }
        email.setHtmlBody(htmlBody);

		if(!owa.isEmpty()) {
			email.setOrgWideEmailAddressId(owa[0].Id);
		}

		Boolean hasError = true;
        if(!Test.isRunningTest()){
            try{
                hasError = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email })[0].isSuccess() ;
            }catch(Exception e){
                return new CuponResponse(true,
                        'Hubo un error al enviar los cupones de pago a su casilla de mail',
                        null);
            }
        }

        return new CuponResponse(!hasError, 'Mail enviado', filterList);
    }


    public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
        @AuraEnabled public List<WSAsociadoGetDeudaResp.Data> datosDeDeudas;

        public Response(Boolean hasError, String message, List<WSAsociadoGetDeudaResp.Data> datosDeDeudas) {
            this.hasError = hasError;
            this.message = message;
            this.datosDeDeudas = datosDeDeudas;
        }
    }

    public class CuponResponse {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
        @AuraEnabled public List<WSAsociadoGetCuponDePagoResp.Data> datosDeCupon;

        public CuponResponse(Boolean hasError, String message, List<WSAsociadoGetCuponDePagoResp.Data> datosDeCupon) {
            this.hasError = hasError;
            this.message = message;
            this.datosDeCupon = datosDeCupon;
        }
    }
}