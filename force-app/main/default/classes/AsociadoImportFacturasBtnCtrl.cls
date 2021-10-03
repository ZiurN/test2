public without sharing class AsociadoImportFacturasBtnCtrl  {
	@AuraEnabled
	public static Response getAsociadoFacturasAndImportIntoSF(String idAsociado, Id accountId) {
		WSAsociadoGetFacturas.Response wsResponse =  WSAsociadoGetFacturas.getAsociadoFacturas(idAsociado);
		if(!wsResponse.hasError){
            List<WSAsociadoGetFacturasResp.Data> filterList = new List<WSAsociadoGetFacturasResp.Data>();
			Integer maxRows = wsResponse.asociadoFacturas.data.size() >= 12 ? 12 : wsResponse.asociadoFacturas.data.size();
			System.debug('***** maxRows *****:' + maxRows);
			if(maxRows == 0) {
				return new Response(false, 'No se encontraron facturas para este afiliado en SaludSoft');
			}
			for(Integer i = 0; i < maxRows; i++) {
				filterList.add(wsResponse.asociadoFacturas.data[i]);
			}            
			fillFacturasInSF(filterList, accountId);
			return new Response(false, '');
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener las facturas desde SaludSoft, asegúrese que el Id de afiliado esté completo y sea válido');
		}
	}

	private static void fillFacturasInSF(List<WSAsociadoGetFacturasResp.Data> listFacturas, Id accountId) {

		List<Factura__c> listToUpsert = new List<Factura__c>();
		for(WSAsociadoGetFacturasResp.Data facturaWs : listFacturas){
			Factura__c newFactura = new Factura__c();
			newFactura.Cuenta_personal__c = accountId;
			List<String> fechaFacturaList = facturaWs.fecha_factura.split('-');
			Date fechaFactura = date.newInstance(integer.valueOf(fechaFacturaList[0]), integer.valueOf(fechaFacturaList[1]), integer.valueOf(fechaFacturaList[2]));
			List<String> fechaVtoList = facturaWs.fecha_vto.split('-');
			Date fechaVto = date.newInstance(integer.valueOf(fechaVtoList[0]), integer.valueOf(fechaVtoList[1]), integer.valueOf(fechaVtoList[2]));
			newFactura.Name = facturaWs.numero_fac;
			newFactura.idfactura__c = facturaWs.dat_numero;
			newFactura.Fecha_de_Emision__c = fechaFactura;
			newFactura.Fecha_de_Vencimiento__c = fechaVto;
			newFactura.Importe__c = facturaWs.importe != null ? Decimal.valueOf(facturaWs.importe) : null;
			newFactura.Letra__c = facturaWs.letra; 
			newFactura.Factura_PDF__c = facturaWs.link_pdf;
            newFactura.Saldo__c = facturaWs.saldo != null ? Decimal.valueOf(facturaWs.saldo) : null;
			listToUpsert.add(newFactura);
		}
		upsert listToUpsert idfactura__c;
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
        //@AuraEnabled public List<WSAsociadoGetFacturasResp.Data> asociadoFacturas;

		public Response(Boolean hasError, String message) {
		//public Response(Boolean hasError, String message, List<WSAsociadoGetFacturasResp.Data> asociadoFacturas){
			this.hasError = hasError;
			this.message = message;
            //this.asociadoFacturas = asociadoFacturas;
		}
	} 
}