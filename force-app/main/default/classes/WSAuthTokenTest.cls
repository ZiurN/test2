@IsTest
public class WSAuthTokenTest  {
	
	@IsTest
	private static void whenTheWSIsConsume_GetTokenResponse(){
		Test.setMock(HttpCalloutMock.class, getTokenResponse);
		Test.startTest();
		WSAuthToken.Response responseToAssert = WSAuthToken.getToken();
		Test.stopTest();

		System.assertEquals(false, responseToAssert.hasError);
		System.assertEquals(200, responseToAssert.response.getStatusCode());
		System.assertEquals('OK', responseToAssert.response.getStatus());
		System.assertEquals('Bearer', responseToAssert.token.token_type);
		System.assertEquals(2592000, responseToAssert.token.expires_in);
		System.assertEquals('eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjkzODBiMzhiM2FlMzBlYmQ5ZTY3MjhlY2JjNWFjOWUyMDBhYjFlZjM4OTQwMzhlNDg0ODViMTNmODM4N2UyMDU5NzkwOGEyYzE3ZTBhZTBkIn0.eyJhdWQiOiIyIiwianRpIjoiOTM4MGIzOGIzYWUzMGViZDllNjcyOGVjYmM1YWM5ZTIwMGFiMWVmMzg5NDAzOGU0ODQ4NWIxM2Y4Mzg3ZTIwNTk3OTA4YTJjMTdlMGFlMGQiLCJpYXQiOjE1OTMwOTcxMTEsIm5iZiI6MTU5MzA5NzExMSwiZXhwIjoxNTk1Njg5MTExLCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.eTs01Oe7KQ_-fSjK7nKZyYcAZvplkFQ9qqQ_hHKvk1cmT7zkCRezkmUsC7P50B5FvMdbuSxCRCU9hvU1Tss52-YGbyNyAA2sBABcA-mswoGipf1irH_JAPwifNraCPGNZbmIkmAU4ySoIm4lu_zPX5ycTnPoZnUWpkWx4FJVyPzXWcpsHjJVownvA3rTr1xOtfbbef7_lRABItGZ0MIo6smzknX2MDxOu2Zzt4cAPd86aOGyaTnYEXPeVJmr3_dlZR4xwCca5Jac2UjMomZJya0jeDcscVtxXmRbbXzeSPQW85ZGEp7iVf6VbBAD-N0Isd2qf_FSuDj2EWowiKyy2sVZ15OZuMhnJGxTpFC8RK3cfucgNyWeJ-LR3ivnjzrDe-UdP2vShfu95zcX4WvfX3EGPkBVItWbJEBcaQZUAdszkT9elwW0GswXd1zlxejSydATu47r_garAmq6815MdAV8ImoiuyHic7zlABvfRYPKGeJbh0OcENBPVQ4MBJiM5CgHB_NcXIGkgTqQNarDcpOhIglSF15OX2TFJQIMT5R9q_hO6kjAmRzMhLhL4fSEjf3Tkv3eNGa9SowpOZrzf5-g90ERHtGyXApcuRerEOgZzEwaMqk-CpM0kGP6n6N9mfqNTX_WQgpLTnnQfOE7HNHuf5NWpY6D5CzVG6lNZN4', responseToAssert.token.access_token);
		System.assertEquals('def50200bfb6e07f553cdf4125c5fe9a90fe13fc88eede9b37159d5058ff55a765af4c78346758d7e570356ef907d5d456fae7f7e510716ad3fa0c4e94598465f9af523b3ecefd5001cae72387fe3ba195ff3b7760b44b171796260a5295eb2566fd555d4de38d59b14e12bbf9d99b4662fd4c1e271b30ec9697fb132fc8d1a0c1dc9de41712c1142dc91e61bccfb15f0ec785a697332d0c7332072735e8e8d406b2112291afd650516f41c625d20094017fb20d7cad2af2ed4eaccd60ada74c1d225ad0c6559700070471d0f99be143e8df93663226eaecbaab0a610fa4e1c0da41b71119a6a557499ec983b72b91cb0aefcab8e7a23d0795e0cd61bbc163c388981447dca262c90127ba7196688227a15a28269dc637b8d8f902f340b21d24afb2d7a4352df7003dd890c72e4426eca95ae621ff9b783b1734559773df43dbd93135ac91b987ece4a024d9bc41912f4661fd1fe1956a38c07903489e4e73effa', responseToAssert.token.refresh_token);
	}

	@IsTest
	private static void whenTheWSIsConsume_GetTokenErrorResponse(){
		Test.setMock(HttpCalloutMock.class, getTokenErrorResponse);
		Test.startTest();
		WSAuthToken.Response responseToAssert = WSAuthToken.getToken();
		Test.stopTest();

		System.assertEquals(true, responseToAssert.hasError);
		System.assertEquals(401, responseToAssert.response.getStatusCode());
		System.assertEquals('Unauthorized', responseToAssert.response.getStatus());
		System.assertEquals(null, responseToAssert.token);
	}

	@IsTest
	private static void saveTokenInSF(){
		String accessToken = WSAuthTokenMock.getAccessToken();
		String refreshToken = WSAuthTokenMock.getRefreshToken();
		Integer expires = 2592000;
		Datetime expiresDate = Datetime.now().addSeconds(expires - 60);

		Test.startTest();
		WSAuthToken.storeToken(accessToken, expires, refreshToken);
		Test.stopTest();
		
		Access_Token__c token = ConfigUtils.getToken();

		System.assertEquals(WSAuthTokenMock.getValue1(), token.Value__c);
		System.assertEquals(WSAuthTokenMock.getValue2(), token.Value_2__c);
		System.assertEquals(WSAuthTokenMock.getValue3(), token.Value_3__c);
		System.assertEquals(WSAuthTokenMock.getValue4(), token.Value_4__c);
		System.assertEquals(WSAuthTokenMock.getValue5(), token.Value_5__c);
		System.assertEquals(expiresDate.date(), token.DueDate__c.date());
		System.assertEquals(WSAuthTokenMock.getRefreshValue1(), token.Refresh_Value__c);
		System.assertEquals(WSAuthTokenMock.getRefreshValue2(), token.Refresh_Value_2__c);
		
	}

	static XHttpCalloutMock getTokenResponse;
	static XHttpCalloutMock getTokenErrorResponse;

	static {
		getTokenResponse = new XHttpCalloutMock();
		getTokenResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');

		getTokenErrorResponse = new XHttpCalloutMock();
		getTokenErrorResponse.buildResponse()
			.withStatus('Unauthorized')
			.withStatusCode(401)
			.withBody(WSAuthTokenMock.getInvalidCredentialsError())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
	}
}