public class WSAuthToken {
	
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
		ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');

	public static Response getToken() {
		Response result = new Response();
		String bodyValue = 
			'grant_type=password'
				+ '&username=' + SERVICE_CONFIG.User__c +
				+ '&password=' + SERVICE_CONFIG.Password__c +
				+ '&client_secret=' + SERVICE_CONFIG.Client_Secret__c +
				+ '&client_id=' + SERVICE_CONFIG.Client_Id__c;

		RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/oauth/token', 'POST', null, bodyValue);

		ws.request.setHeader('Content-Type', 'application/x-www-form-urlencoded');

		return (Response) ws.invoke(result);		
	}
	
	public static void setAuth(RestWS ws) {
		Response tokenAuth = getToken();
		if(tokenAuth.token == null) {
			ws.hasError = true;
			ws.errorMessage = 'No pudo autorizarse';
		}
		else {
			ws.request.setHeader('Authorization', 'Bearer ' + tokenAuth.token.access_token);
		}
	}

	public static Response setAuthHeader(RestWS ws){
		Access_Token__c actualToken = ConfigUtils.getToken();

		if(actualToken != null && actualToken.DueDate__c > System.now()) {
			ws.request.setHeader('Authorization', 'Bearer ' + actualToken.Value__c + actualToken.Value_2__c
			+ actualToken.Value_3__c + actualToken.Value_4__c + actualToken.Value_5__c);
			return null;
		}
		else{
			if(actualToken == null){
				Response tokenAuth = getToken();
				if(tokenAuth.token == null) {
					ws.hasError = true;
					ws.errorMessage = 'No pudo autorizarse';
				}
				else {
					ws.request.setHeader('Authorization', 'Bearer ' + tokenAuth.token.access_token);
				}
				return tokenAuth;
			}
			else{
				Response tokenAuth = getToken();
				if(tokenAuth.token == null) {
					ws.hasError = true;
					ws.errorMessage = 'No pudo autorizarse';
				}
				else {
					ws.request.setHeader('Authorization', 'Bearer ' + tokenAuth.token.access_token);
				}
				return tokenAuth;

			}
		}
	}

	
	//private static Response refreshToken(String r_token){
		//Response result = new Response();

		//String bodyValue = 
			//'grant_type=password'
				//+ '&client_secret=' + SERVICE_CONFIG.Client_Secret__c +
				//+ '&client_id=' + SERVICE_CONFIG.Client_Id__c
				//+ '&refresh_token=' + r_token;

		//RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/oauth/token', 'POST', null, bodyValue);

		//ws.request.setHeader('Content-Type', 'application/x-www-form-urlencoded');

		//return (Response) ws.invoke(result);		
	//}

	public static void manageTokenResponse(Response tokenAuth){
		if(tokenAuth != null && !tokenAuth.hasError && !Test.isRunningTest()){
			storeToken(tokenAuth.token.access_token,tokenAuth.token.expires_in,tokenAuth.token.refresh_token);
		}
	}
	
	@TestVisible
	private static void storeToken(String access_token, Integer expires_in, String refresh_token){
		Access_Token__c token = ConfigUtils.getToken();
		if(token == null){
			token = new Access_Token__c();
		}
		token.Value__c = access_token.substring(0,255);
		token.Value_2__c = access_token.substring(255,510);
		token.Value_3__c = access_token.substring(510,765);
		token.Value_4__c = access_token.substring(765,1020);
		token.Value_5__c = access_token.substring(1020,access_token.length());
		token.DueDate__c = Datetime.now().addSeconds(expires_in - 60);
		token.Refresh_Value__c =refresh_token.substring(0,255);
		token.Refresh_Value_2__c = refresh_token.substring(255,510);
		if(refresh_token.length() < 765){
			token.Refresh_Value_3__c = refresh_token.substring(510,refresh_token.length());
		}
		else{
			token.Refresh_Value_3__c = refresh_token.substring(510,765);
			token.Refresh_Value_4__c = refresh_token.substring(765,refresh_token.length());
		}
		upsert token;
		

		
	}
	

	public class Response extends WSResult {
		public WSToken token;
		public override void processResponse(HttpResponse response) {
			System.debug(response.getBody());
			token = (WSToken)
				JSON.deserialize(response.getBody(), WSToken.class);
			System.debug(token);
		}
	}

	public class WSToken {
		public String token_type;
		public Integer expires_in;
		public String access_token;
		public String refresh_token;
	}
}