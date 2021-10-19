public without sharing class AsociadoCuentaCorrienteBtnCtrl  {
	//@AuraEnabled
	//public static Response getAsociadoCuentaCorriente(Integer idAsociado, Id accountId) {

		//WSAsociadoGetCuentaCorriente.Response wsResponse =  WSAsociadoGetCuentaCorriente.getAsociadoCuentaCorriente(idAsociado);

		//if(!wsResponse.hasError){            
            //List<WSAsociadoGetCuentaCorrienteResp.DetallesAfi> filterList = new List<WSAsociadoGetCuentaCorrienteResp.DetallesAfi>();
			//Integer maxRows = wsResponse.asociadoCuentaCorriente.data.cuenta_corriente.detallesAfi.size();
			//if(maxRows == 0) {
				//return new Response(false, 'No se encontraron datos de cuenta corriente para este afiliado en SaludSoft', filterList);
			//}
			//for(Integer i = 0; i < maxRows; i++){
				//WSAsociadoGetCuentaCorrienteResp.DetallesAfi cuentaCorriente = wsResponse.asociadoCuentaCorriente.data.cuenta_corriente.detallesAfi[i];
				//filterList.add(cuentaCorriente);
			//}
			//return new Response(false, '', filterList);
		//}
		//else{
			//return new Response(true, 'Hubo un error al intentar obtener los datos de la cuenta corriente desde SaludSoft, asegúrese que el Id de afiliado esté completo y sea válido', null);
		//}
	//}

	@AuraEnabled
	public static Response getAsociadoCuentaCorriente(String idAsociado) {
		WSAsociadoGetCuentaCorriente.Response wsResponse =  WSAsociadoGetCuentaCorriente.getAsociadoCuentaCorriente(idAsociado);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.asociadoCuentaCorriente.data.cuenta_corriente.detallesAfi);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener las cuentas corrientes desde SaludSoft, asegúrese que el Id de afiliado esté completo y sea válido', null);
		}
	}

	//@AuraEnabled
	//public static void fillCuentasCorrientesWithTheDataOfTheWS(List<WSAsociadoGetCuentaCorrienteResp.DetallesAfi> listCuentaCorriente, Id accountId) {
	//	List<Cuenta_Corriente__c> listToUpsert = new List<Cuenta_Corriente__c>();

	//	for(WSAsociadoGetCuentaCorrienteResp.DetallesAfi cuentaCorrienteWs : listCuentaCorriente){
	//		Cuenta_Corriente__c newCuenta = new Cuenta_Corriente__c();
	//		String idMasCuota = cuentaCorrienteWs.id + '-' + cuentaCorrienteWs.cuota;
	//		newCuenta.Cuenta_personal__c = accountId;
	//		newCuenta.CtaCteDetalleId__c = idMasCuota;
	//		newCuenta.Comprobante__c = Date.parse(cuentaCorrienteWs.comprobante);
	//		newCuenta.Cuota__c = decimal.valueOf(cuentaCorrienteWs.cuota);
	//		newCuenta.Importe__c = decimal.valueOf(cuentaCorrienteWs.importe);
	//		newCuenta.Letra__c = cuentaCorrienteWs.letra;
	//		newCuenta.Movimiento__c = decimal.valueOf(cuentaCorrienteWs.movimiento);
	//		newCuenta.Numero__c = decimal.valueOf(cuentaCorrienteWs.numero);
	//		newCuenta.Saldo__c = decimal.valueOf(cuentaCorrienteWs.saldo);
	//		newCuenta.Sucursal__c = cuentaCorrienteWs.sucursal;
	//		newCuenta.Tipo__c = cuentaCorrienteWs.tipo;
	//		newCuenta.Vencimiento__c = Date.parse(cuentaCorrienteWs.vencimiento);
	//		listToUpsert.add(newCuenta);
	//	}
	//	upsert listToUpsert CtaCteDetalleId__c;
	//}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
        @AuraEnabled public List<WSAsociadoGetCuentaCorrienteResp.DetallesAfi> asociadoCuentaCorriente;

		public Response(Boolean hasError, String message, List<WSAsociadoGetCuentaCorrienteResp.DetallesAfi> asociadoCuentaCorriente) {
			this.hasError = hasError;
			this.message = message;
            this.asociadoCuentaCorriente = asociadoCuentaCorriente;
		}
	} 
}