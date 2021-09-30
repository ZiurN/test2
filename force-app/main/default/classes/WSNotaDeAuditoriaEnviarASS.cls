public class WSNotaDeAuditoriaEnviarASS  {

    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
            ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

    public static SSWSResult enviar(Nota_de_Auditoria__c notaDeAuditoria) {
        RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/notas-auditor',
                'POST',
                null,
                JSON.serialize(generateRequest(notaDeAuditoria)));

        ws.request.setHeader('Accept','application/json"');
        ws.request.setHeader('Content-Type', 'application/json');
		//-------------------------------------------------
        System.debug('body****: ' + ws.bodyParameter.value);
        //-------------------------------------------------
		WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
		SSWSResult res = (SSWSResult) ws.invoke(new SSWSResult());
		WSAuthToken.manageTokenResponse(tokenResp);
		return res;
    }

	public class SSWSResult extends WSResult {
		public ResponseBody responseBody;

		public override void processResponse(HttpResponse response) {
			this.responseBody = (ResponseBody)JSON.deserialize(response.getBody(), ResponseBody.class);
		}

		public override void processError(HttpResponse response) {
            Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
			message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);

        }
	}

	public class ResponseBody {
		public Data data;
		public String message;
		public Integer httpCode;
		public Boolean error;
	}

	public class Data {
		public String id_nota;
	}

	static private Map<String,Object> generateRequest(Nota_de_Auditoria__c nota){
		User usuario = [SELECT CommunityNickname FROM User WHERE Id = :UserInfo.getUserId()];
		String nick = usuario.CommunityNickname.toUppercase();

		Map<String,Object> notaMap = new Map<String,Object>{
			'usuario' => nick,
			'numero_sf' => nota.Id,
			'tipo_nota' => nota.Tipo_nota_de_Auditoria__r.Codigo_tipoNA__c,
			'nota' => nota.Nota__c
		};

		if(nota.APr_Id__c != null){
			if(nota.APr_Id__r.Nro_AP__c != null) {
				notaMap.put('apr_id', nota.APr_Id__r.Nro_AP__c);
			}
			else if(nota.APr_Id__r.Codigo_reintegro_SS__c != null) {
				notaMap.put('rein_id', nota.APr_Id__r.Codigo_reintegro_SS__c);
			}
		}
		if(nota.Evento_Medico_Id__c != null){
			notaMap.put('em_id', nota.Evento_Medico_Id__r.Nro_de_Evento_Medico_SS__c);
		}
		if(nota.Id_Externo__c != null) {
			notaMap.put('nota_id', nota.Id_Externo__c);
		}

		return notaMap;
	}

	//public class RequestBody {
		//public String numero_sf;
		//public String tipo_nota;
		//public String apr_id;
		//public String em_id;
		//public String usuario;
		//public String nota;

		//public RequestBody(Nota_de_Auditoria__c nda){
			//this.numero_sf = nda.Id;
			//this.tipo_nota = nda.Tipo_nota_de_Auditoria__r.Codigo_tipoNA__c;
			//this.apr_id = nda.APr_Id__r.Nro_AP__c;
			//this.em_id = nda.Evento_Medico_Id__r.Nro_de_Evento_Medico_SS__c;
			//this.usuario = 'CRIOS';
			//this.nota = nda.Nota__c;
		//}
	//}
}