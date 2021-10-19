public class AsociadoDatosAdicionalesBtnCtrl  {
	@AuraEnabled
	public static Response getAsociadoDatosAdicionales(String idAsociado) {
		WSAsociadoGetDatosAdicionales.Response wsResponse =  WSAsociadoGetDatosAdicionales.getAsociadoDatosAdicionales(idAsociado);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.asociadoDatosAdicionales.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener los datos adicionales desde SaludSoft, asegúrese que el Id de afiliado esté completo y sea válido', null);
		}
	}

	//-----------------------------------------------------------------------------
	@AuraEnabled
	public static Response getEmpresaDatosAdicionales(Integer codEmpresa) {
		WSAsociadoGetDatosAdicionales.Response wsResponse =  WSAsociadoGetDatosAdicionales.getEmpresaDatosAdicionales(codEmpresa);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.asociadoDatosAdicionales.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener los datos adicionales desde SaludSoft, asegúrese que el código de empresa esté completo y sea válido', null);
		}
	}

	@AuraEnabled
	public static Response getEfectorDatosAdicionales(Integer codEfector) {
		WSAsociadoGetDatosAdicionales.Response wsResponse =  WSAsociadoGetDatosAdicionales.getEfectorDatosAdicionales(codEfector);

		if(!wsResponse.hasError) {
			Integer maxRows = wsResponse.asociadoDatosAdicionales.data.size();
			for(Integer i = 0; i < maxRows; i++){	
				wsResponse.asociadoDatosAdicionales.data[i].tipo_dato_adicional = wsResponse.asociadoDatosAdicionales.data[i].tipo_dato;
				wsResponse.asociadoDatosAdicionales.data[i].descripcion_dato_adicional = wsResponse.asociadoDatosAdicionales.data[i].observaciones;
			}
			return new Response(false, '', wsResponse.asociadoDatosAdicionales.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener los datos adicionales desde SaludSoft, asegúrese que el código de efector esté completo y sea válido', null);
		}
	}
	//------------------------------------------------------------------------------------
	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSAsociadoGetDatosAdicionalesResp.Data> asociadoDatosAdicionales;

		public Response(Boolean hasError, String message, List<WSAsociadoGetDatosAdicionalesResp.Data> asociadoDatosAdicionales){
			this.hasError = hasError;
			this.message = message;
			this.asociadoDatosAdicionales = asociadoDatosAdicionales;
		}
	}  
}