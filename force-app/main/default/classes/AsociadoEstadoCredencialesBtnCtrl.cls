public class AsociadoEstadoCredencialesBtnCtrl  {
	@AuraEnabled
	public static Response getEstadoCredenciales(String codAsociado) {
		codAsociado = codAsociado.replace('/', '-');
		WSAsociadoEstadoCredenciales.Response wsResponse =  WSAsociadoEstadoCredenciales.getEstadoCredenciales(codAsociado);
		System.debug('****resp ' + wsResponse);

		if(!wsResponse.hasError) {
			return new Response(false, '', wsResponse.result.data);
		}
		else{
			return new Response(true, 'Hubo un error al intentar obtener el estado de las credenciales desde SS', null);
		}
	}

	@AuraEnabled
	public static ResponseDetalle getEstadoCredencialesDetalle(String codAsociado, String idOca) {
		codAsociado = codAsociado.replace('/', '-');
		WSAsociadoEstadoCredenciales.ResponseDetalle wsResponse = 
				WSAsociadoEstadoCredenciales.getEstadoCredencialesDetalle(codAsociado, idOca);
		System.debug('****resp ' + wsResponse);

		if(!wsResponse.hasError) {
			return new ResponseDetalle(false, '', wsResponse.result.data);
		}
		else{
			return new ResponseDetalle(true, 'Hubo un error al intentar obtener el detalle desde SS', null);
		}
	}

	@AuraEnabled
	public static ResponseCarga cargaCredencial(String codAsociado, String idOca) {
		User usuario = [SELECT CommunityNickname FROM User WHERE Id = :UserInfo.getUserId()];
		String nick = String.isNotEmpty(usuario.CommunityNickname) ? usuario.CommunityNickname.toUpperCase() : null;

		if(String.isBlank(codAsociado) || String.isBlank(idOca)) {
			return new ResponseCarga(false, 'El id de Oca y el Código deben estar completos.');
		}

		String body = generateJSONCarga(codAsociado, idOca, nick);

		WSAsociadoEstadoCredenciales.ResponseCarga resp = WSAsociadoEstadoCredenciales.cargaCredencial(body);

		if(!resp.hasError) {
			return new ResponseCarga(false, 'ok');
		}
		else{
			return new ResponseCarga(true, resp.message);
		}
	}

	private static String generateJSONCarga(String codAsociado, String idOca, String nick) {
		
		Map<String, Object> jsonMap = new Map<String, Object> {
			'codigo_afiliado' => codAsociado,
			'id_oca' => idOca,
			'usuario' => nick
		};

		return JSON.serialize(jsonMap);
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSAsociadoEstadoCredencialesResp.Data> data;

		public Response(Boolean hasError, String message, List<WSAsociadoEstadoCredencialesResp.Data> estadoCredendiales) {
			this.hasError = hasError;
			this.message = message;
			this.data = estadoCredendiales;
		}
	}
	
	public class ResponseDetalle {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public List<WSAsociadoCredencialDetalleResp.Data> data;

		public ResponseDetalle(
								Boolean hasError, 
								String message, 
								List<WSAsociadoCredencialDetalleResp.Data> detalleCredendiales
		){
			this.hasError = hasError;
			this.message = message;
			this.data = detalleCredendiales;
		}
	}  

	public class ResponseCarga {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;

		public ResponseCarga(Boolean hasError, String message) {
			this.hasError = hasError;
			this.message = message;
		}
	}
}