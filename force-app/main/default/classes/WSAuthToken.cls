/**-----------------------------------------------------------------------------------------------------------------------
@author			Matias Molly.
@description	Clase para manejar la obtención y use del token de SS.
@date			19/05/2022
------------------------------------------------------------------------------------------------------------------------*/
public with sharing class WSAuthToken {
	@TestVisible
	public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG {get {
		if (SERVICE_CONFIG == null) {
			SERVICE_CONFIG = ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
			return SERVICE_CONFIG;
		} else {return SERVICE_CONFIG;}
	} set;}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método para realizar el llamado a SS para obtener el token de autorización.
					(Revisar borrar versión del método sin argumentos)
	@param			SERVICE_CONFIG - Metadata con la información para obtener el token.
	------------------------------------------------------------------------------------------------------------------------*/
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
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método para iniciar la construcción del header de un llamado a SS una vez obtenido el token
					(Revisar borrar versión del método sin argumentos)
	@param			ws - Metadata con la información para obtener el token.
	@param			SERVICE_CONFIG - Metadata con la información para obtener el token.
	------------------------------------------------------------------------------------------------------------------------*/
	public static Response setAuth (RestWS ws) {
		Response tokenAuth = getToken();
		setWSRequestAccordingToTokenAuthResult(tokenAuth, ws);
		return tokenAuth;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método para iniciar la construcción del header de un llamado a SS una vez obtenido el token
					(Revisar borrar versión del método sin argumentos)
	@param			ws - Metadata con la información para obtener el token.
	@param			SERVICE_CONFIG - Metadata con la información para obtener el token.
	------------------------------------------------------------------------------------------------------------------------*/
	public static Response setAuthHeader (RestWS ws) {
		Access_Token__c actualToken = getAccessToken();
		if (actualToken != null && actualToken.DueDate__c > System.now()) {
			ws.request.setHeader('Authorization', 'Bearer ' +
				actualToken.Value__c +
				actualToken.Value_2__c +
				actualToken.Value_3__c +
				actualToken.Value_4__c +
				actualToken.Value_5__c);
			return null;
		} else {
			Response tokenAuth = getToken();
			setWSRequestAccordingToTokenAuthResult(tokenAuth, ws);
			return tokenAuth;
		}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método para almacenar el token obtenido en SF.
	@param			tokenAuth - Respuesta de SS con el token de autorización.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void manageTokenResponse(Response tokenAuth){
		if (tokenAuth != null && !tokenAuth.hasError && !Test.isRunningTest()) {
			storeToken(tokenAuth.token.access_token,tokenAuth.token.expires_in,tokenAuth.token.refresh_token);
		}
	}
	/** Utils */
	@TestVisible
	private static void storeToken(String access_token, Integer expires_in, String refresh_token){
		Access_Token__c token = getAccessToken();
		if (token == null) {
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
		if (refresh_token.length() < 765) {
			token.Refresh_Value_3__c = refresh_token.substring(510,refresh_token.length());
		} else {
			token.Refresh_Value_3__c = refresh_token.substring(510,765);
			token.Refresh_Value_4__c = refresh_token.substring(765,refresh_token.length());
		}
		upsert token;
	}
	private static void setWSRequestAccordingToTokenAuthResult (Response tokenAuth, RestWS ws) {
		if (tokenAuth.token == null) {
			ws.hasError = true;
			ws.errorMessage = 'No pudo autorizarse';
		} else {
			ws.request.setHeader('Authorization', 'Bearer ' + tokenAuth.token.access_token);
		}
	}
	public static Access_Token__c getAccessToken(){
		Access_Token__c[] token = [SELECT DueDate__c,
									Encrypting_Key__c,
									Value__c,
									Value_2__c,
									Value_3__c,
									Value_4__c,
									Value_5__c,
									Refresh_Value__c,
									Refresh_Value_2__c,
									Refresh_Value_3__c,
									Refresh_Value_4__c
							FROM Access_Token__c];
		if (token.isEmpty()) {return null;}
		else {return token[0];}
	}
	public class Response extends WSResult {
		public WSToken token;
		public override void processResponse(HttpResponse response) {
			token = (WSToken) JSON.deserialize(response.getBody(), WSToken.class);
		}
	}
	public class WSToken {
		public String token_type;
		public Integer expires_in;
		public String access_token;
		public String refresh_token;
	}
}