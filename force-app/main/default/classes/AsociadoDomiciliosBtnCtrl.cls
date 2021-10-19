public class AsociadoDomiciliosBtnCtrl  {
	@AuraEnabled
	public static Response getAsociadoDomicilios(String idAsociado) {
		WSAsociadoGetDomicilios.Response wsResponse =  WSAsociadoGetDomicilios.getAsociadoDomicilios(idAsociado);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.asociadoDomicilios.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener los domicilios desde SaludSoft, asegúrese que el Id de afiliado esté completo y sea válido', null);
		}
	}

	//Agregado-----------------------------------------------------------
	@AuraEnabled
	public static Response getEmpresaDomicilios(Integer codEmpresa) {
		WSAsociadoGetDomicilios.Response wsResponse =  WSAsociadoGetDomicilios.getEmpresaDomicilios(codEmpresa);

		if(!wsResponse.hasError){
			Integer maxRows = wsResponse.asociadoDomicilios.data.size();
			for(Integer i = 0; i < maxRows; i++){
				for(Integer j = 0; j < wsResponse.asociadoDomicilios.data[i].telefonos.size(); j++) {
					wsResponse.asociadoDomicilios.data[i].telefonos[j].tipo_telefono = wsResponse.asociadoDomicilios.data[i].telefonos[j].tipo; 
				}
			}
			return new Response(false, '', wsResponse.asociadoDomicilios.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener los domicilios desde SaludSoft, asegúrese que el codigo de empresa esté completo y sea válido', null);
		}
	}

	@AuraEnabled
	public static Response getObraSocialDomicilios(Integer codOS) {
		WSAsociadoGetDomicilios.Response wsResponse =  WSAsociadoGetDomicilios.getObraSocialDomicilios(codOS);

		if(!wsResponse.hasError){
			Integer maxRows = wsResponse.asociadoDomicilios.data.size();
			for(Integer i = 0; i < maxRows; i++){
				for(Integer j = 0; j < wsResponse.asociadoDomicilios.data[i].telefonos.size(); j++) {
					wsResponse.asociadoDomicilios.data[i].telefonos[j].tipo_telefono = wsResponse.asociadoDomicilios.data[i].telefonos[j].tipo; 
				}
			}
			return new Response(false, '', wsResponse.asociadoDomicilios.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener los domicilios desde SaludSoft, asegúrese que el codigo de obra social esté completo y sea válido', null);
		}
	}

	@AuraEnabled
	public static Response getEfectorDomicilios(Integer codEfector) {
		WSAsociadoGetDomicilios.Response wsResponse =  WSAsociadoGetDomicilios.getEfectorDomicilios(codEfector);

		if(!wsResponse.hasError){
			return new Response(false, '', wsResponse.asociadoDomicilios.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener los domicilios desde SaludSoft, asegúrese que el codigo de efector esté completo y sea válido', null);
		}
	}

	@AuraEnabled
	public static Response getDelegacionDomicilios(Integer codDelegacion) {
		WSAsociadoGetDomicilios.Response wsResponse =  WSAsociadoGetDomicilios.getDelegacionDomicilios(codDelegacion);

		if(!wsResponse.hasError){
			Integer maxRows = wsResponse.asociadoDomicilios.data.size();
			for(Integer i = 0; i < maxRows; i++){
				for(Integer j = 0; j < wsResponse.asociadoDomicilios.data[i].telefonos.size(); j++) {
					wsResponse.asociadoDomicilios.data[i].telefonos[j].tipo_telefono = wsResponse.asociadoDomicilios.data[i].telefonos[j].tipo; 
				}
			}
			return new Response(false, '', wsResponse.asociadoDomicilios.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener los domicilios desde SaludSoft, asegúrese que el codigo de delegacion esté completo y sea válido', null);
		}
	}

	//-------------------------------------------------------------------
	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSAsociadoGetDomiciliosResp.Data> asociadoDomicilios;

		public Response(Boolean hasError, String message, List<WSAsociadoGetDomiciliosResp.Data> asociadoDomicilios){
			this.hasError = hasError;
			this.message = message;
			this.asociadoDomicilios = asociadoDomicilios;
		}
	}  
}