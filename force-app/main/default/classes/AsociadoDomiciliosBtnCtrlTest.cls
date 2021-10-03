@IsTest
public class AsociadoDomiciliosBtnCtrlTest  {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static XHttpCalloutMock getEmptyListResponse;
	static XHttpCalloutMock getResponseFoundEmpresa;
	static XHttpCalloutMock getErrorResponseEmpresa;
	static XHttpCalloutMock getResponseFoundObraSocial;
	static XHttpCalloutMock getErrorResponseObraSocial;
	static XHttpCalloutMock getResponseFoundEfector;
	static XHttpCalloutMock getErrorResponseEfector;
	static XHttpCalloutMock getResponseFoundDelegacion;
	static XHttpCalloutMock getErrorResponseDelegacion;

	static {
		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoGetDomiciliosMock.getFound())
			.addForAddress(WSAsociadoGetDomicilios.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/domicilios/191670');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetDomiciliosMock.getError())
			.addForAddress(WSAsociadoGetDomicilios.SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/domicilios/0');

		//EMPRESA
		getResponseFoundEmpresa = new XHttpCalloutMock();
		getResponseFoundEmpresa.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundEmpresa.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoGetDomiciliosMock.getFoundEmpresa())
			.addForAddress(WSAsociadoGetDomicilios.SERVICE_CONFIG.URL__c + '/v1/salud/empresas/601043/domicilios');

		getErrorResponseEmpresa = new XHttpCalloutMock();
		getErrorResponseEmpresa.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponseEmpresa.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetDomiciliosMock.getError())
			.addForAddress(WSAsociadoGetDomicilios.SERVICE_CONFIG.URL__c + '/v1/salud/empresas/0/domicilios');
		
		//OBRA SOCIAL
		getResponseFoundObraSocial = new XHttpCalloutMock();
		getResponseFoundObraSocial.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundObraSocial.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoGetDomiciliosMock.getFoundObraSocial())
			.addForAddress(WSAsociadoGetDomicilios.SERVICE_CONFIG.URL__c + '/v1/salud/obras-sociales/domicilios/640008');

		getErrorResponseObraSocial = new XHttpCalloutMock();
		getErrorResponseObraSocial.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponseObraSocial.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetDomiciliosMock.getError())
			.addForAddress(WSAsociadoGetDomicilios.SERVICE_CONFIG.URL__c + '/v1/salud/obras-sociales/domicilios/0');

		//EFECTOR
		getResponseFoundEfector= new XHttpCalloutMock();
		getResponseFoundEfector.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundEfector.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoGetDomiciliosMock.getFoundEfector())
			.addForAddress(WSAsociadoGetDomicilios.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/domicilios/536787');
		
		getErrorResponseEfector = new XHttpCalloutMock();
		getErrorResponseEfector.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponseEfector.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetDomiciliosMock.getError())
			.addForAddress(WSAsociadoGetDomicilios.SERVICE_CONFIG.URL__c + '/v1/salud/efectores/domicilios/0');

		//DELEGACIONES 
		getResponseFoundDelegacion= new XHttpCalloutMock();
		getResponseFoundDelegacion.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundDelegacion.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAsociadoGetDomiciliosMock.getFoundDelegaciones())
			.addForAddress(WSAsociadoGetDomicilios.SERVICE_CONFIG.URL__c + '/v1/salud/delegaciones/consultar?filter[codigo]=650030');
		
		getErrorResponseDelegacion = new XHttpCalloutMock();
		getErrorResponseDelegacion.buildResponse()
			.withStatus('OK')
			.withStatusCode(200) 
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponseDelegacion.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSAsociadoGetDomiciliosMock.getError())
			.addForAddress(WSAsociadoGetDomicilios.SERVICE_CONFIG.URL__c + '/v1/salud/delegaciones/consultar?filter[codigo]=0');
	}
	
	//AFILIADO
	@IsTest 
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoDomiciliosSucess_returnAListOfDomicilios(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		AsociadoDomiciliosBtnCtrl.Response responseToAssert = AsociadoDomiciliosBtnCtrl.getAsociadoDomicilios('191670');
		Test.stopTest();

		System.assertEquals('', responseToAssert.message);
		System.assertEquals('COM', responseToAssert.asociadoDomicilios[0].tipo_domicilio);
		System.assertEquals('ZONA RURAL', responseToAssert.asociadoDomicilios[0].calle);
		System.assertEquals(null, responseToAssert.asociadoDomicilios[0].piso);
		System.assertEquals(null, responseToAssert.asociadoDomicilios[0].dpto);
		System.assertEquals(null, responseToAssert.asociadoDomicilios[0].numero);
		System.assertEquals('2743ARY', responseToAssert.asociadoDomicilios[0].codigo_postal);
		System.assertEquals('ARROYO DULCE', responseToAssert.asociadoDomicilios[0].localidad);
		System.assertEquals('BUENOS AIRES', responseToAssert.asociadoDomicilios[0].provincia);
		System.assertEquals('ARGENTINA', responseToAssert.asociadoDomicilios[0].pais);
		System.assertEquals(null, responseToAssert.asociadoDomicilios[0].observaciones);
		System.assertEquals('TEL', responseToAssert.asociadoDomicilios[0].telefonos[0].tipo_telefono);
		System.assertEquals('02395-454173', responseToAssert.asociadoDomicilios[0].telefonos[0].numero);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSAfiliadoDomiciliosError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponse);
		
		Test.startTest();
		AsociadoDomiciliosBtnCtrl.Response responseToAssert = AsociadoDomiciliosBtnCtrl.getAsociadoDomicilios('0');
		Test.stopTest();

		System.assertEquals('Hubo un error al intentar obtener los domicilios desde SaludSoft, asegúrese que el Id de afiliado esté completo y sea válido', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoDomicilios);
	}

	//EMPRESA
	@IsTest 
	public static void whenTheBtnIsClickedInTheView_consumeWSEmpresaDomiciliosSucess_returnAListOfDomicilios(){
		Test.setMock(HttpCalloutMock.class, getResponseFoundEmpresa);
		
		Test.startTest();
		AsociadoDomiciliosBtnCtrl.Response responseToAssert = AsociadoDomiciliosBtnCtrl.getEmpresaDomicilios(601043);
		Test.stopTest();

		System.assertEquals('', responseToAssert.message);
		System.assertEquals('COM', responseToAssert.asociadoDomicilios[0].tipo_domicilio);
		System.assertEquals('MORENO', responseToAssert.asociadoDomicilios[0].calle);
		System.assertEquals(null, responseToAssert.asociadoDomicilios[0].piso);
		System.assertEquals(null, responseToAssert.asociadoDomicilios[0].dpto);
		System.assertEquals('467', responseToAssert.asociadoDomicilios[0].numero);
		System.assertEquals('7500TAR', responseToAssert.asociadoDomicilios[0].codigo_postal);
		System.assertEquals('TRES ARROYOS', responseToAssert.asociadoDomicilios[0].localidad);
		System.assertEquals('BUENOS AIRES', responseToAssert.asociadoDomicilios[0].provincia);
		System.assertEquals('ARGENTINA', responseToAssert.asociadoDomicilios[0].pais);
		System.assertEquals(null, responseToAssert.asociadoDomicilios[0].observaciones);
		System.assertEquals('TEL', responseToAssert.asociadoDomicilios[0].telefonos[0].tipo_telefono);
		System.assertEquals('02983-430755', responseToAssert.asociadoDomicilios[0].telefonos[0].numero);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSEmpresaDomiciliosError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponseEmpresa);
		
		Test.startTest();
		AsociadoDomiciliosBtnCtrl.Response responseToAssert = AsociadoDomiciliosBtnCtrl.getEmpresaDomicilios(0);
		Test.stopTest();

		System.assertEquals('Hubo un error al intentar obtener los domicilios desde SaludSoft, asegúrese que el codigo de empresa esté completo y sea válido', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoDomicilios);
	}

	//OBRA SOCIAL
	@IsTest 
	public static void whenTheBtnIsClickedInTheView_consumeWSObraSocialDomiciliosSucess_returnAListOfDomicilios(){
		Test.setMock(HttpCalloutMock.class, getResponseFoundObraSocial);
		
		Test.startTest();
		AsociadoDomiciliosBtnCtrl.Response responseToAssert = AsociadoDomiciliosBtnCtrl.getObraSocialDomicilios(640008);
		Test.stopTest();

		System.assertEquals('', responseToAssert.message);
		System.assertEquals('COM', responseToAssert.asociadoDomicilios[0].tipo_domicilio);
		System.assertEquals('ANCHORENA', responseToAssert.asociadoDomicilios[0].calle);
		System.assertEquals(null, responseToAssert.asociadoDomicilios[0].piso);
		System.assertEquals(null, responseToAssert.asociadoDomicilios[0].dpto);
		System.assertEquals('639', responseToAssert.asociadoDomicilios[0].numero);
		System.assertEquals('1170CFE', responseToAssert.asociadoDomicilios[0].codigo_postal);
		System.assertEquals('CAPITAL FEDERAL', responseToAssert.asociadoDomicilios[0].localidad);
		System.assertEquals('CAPITAL FEDERAL', responseToAssert.asociadoDomicilios[0].provincia);
		System.assertEquals('ARGENTINA', responseToAssert.asociadoDomicilios[0].pais);
		System.assertEquals(null, responseToAssert.asociadoDomicilios[0].observaciones);
		System.assertEquals('TEL', responseToAssert.asociadoDomicilios[0].telefonos[0].tipo_telefono);
		System.assertEquals('011-41064500', responseToAssert.asociadoDomicilios[0].telefonos[0].numero);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSObraSocialDomiciliosError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponseObraSocial);
		
		Test.startTest();
		AsociadoDomiciliosBtnCtrl.Response responseToAssert = AsociadoDomiciliosBtnCtrl.getObraSocialDomicilios(0);
		Test.stopTest();

		System.assertEquals('Hubo un error al intentar obtener los domicilios desde SaludSoft, asegúrese que el codigo de obra social esté completo y sea válido', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoDomicilios);
	}

	//EFECTOR
	@IsTest 
	public static void whenTheBtnIsClickedInTheView_consumeWSEfectorDomiciliosSucess_returnAListOfDomicilios(){
		Test.setMock(HttpCalloutMock.class, getResponseFoundEfector);
		
		Test.startTest();
		AsociadoDomiciliosBtnCtrl.Response responseToAssert = AsociadoDomiciliosBtnCtrl.getEfectorDomicilios(536787);
		Test.stopTest();

		//Los assert estan comentados porque tdv no existen esos campos en el WS
		System.assertEquals('', responseToAssert.message);
		System.assertEquals('COM', responseToAssert.asociadoDomicilios[0].tipo_domicilio);
		System.assertEquals('SAN LORENZO 882 D   ', responseToAssert.asociadoDomicilios[0].domicilio_efector);
		//System.assertEquals(null, responseToAssert.asociadoDomicilios[0].piso);
		//System.assertEquals(null, responseToAssert.asociadoDomicilios[0].dpto);
		//System.assertEquals('639', responseToAssert.asociadoDomicilios[0].numero);
		System.assertEquals('2000ROS', responseToAssert.asociadoDomicilios[0].codigo_postal);
		System.assertEquals('ROSARIO', responseToAssert.asociadoDomicilios[0].localidad);
		System.assertEquals('SANTA FE', responseToAssert.asociadoDomicilios[0].provincia);
		//System.assertEquals('ARGENTINA', responseToAssert.asociadoDomicilios[0].pais);
		//System.assertEquals(null, responseToAssert.asociadoDomicilios[0].observaciones);
		//System.assertEquals('TEL', responseToAssert.asociadoDomicilios[0].telefonos[0].tipo_telefono);
		//System.assertEquals('011-41064500', responseToAssert.asociadoDomicilios[0].telefonos[0].numero);
	}
		
	@IsTest
	public static void whenTheBtnIsClickedInTheView_consumeWSEfectorDomiciliosError_returnErrorMessage(){
		Test.setMock(HttpCalloutMock.class, getErrorResponseEfector);
		
		Test.startTest();
		AsociadoDomiciliosBtnCtrl.Response responseToAssert = AsociadoDomiciliosBtnCtrl.getEfectorDomicilios(0);
		Test.stopTest();

		System.assertEquals('Hubo un error al intentar obtener los domicilios desde SaludSoft, asegúrese que el codigo de efector esté completo y sea válido', responseToAssert.message);
		System.assertEquals(null, responseToAssert.asociadoDomicilios);
	}

	//DELEGACIONES
	@IsTest 
	public static void whenTheBtnIsClickedInTheView_consumeWSDelegacionDomiciliosSucess_returnAListOfDomicilios(){
		Test.setMock(HttpCalloutMock.class, getResponseFoundDelegacion);
		
		Test.startTest();
		AsociadoDomiciliosBtnCtrl.Response responseToAssert = AsociadoDomiciliosBtnCtrl.getDelegacionDomicilios(650030);
		Test.stopTest();

		//Los assert estan comentados porque tdv no existen esos campos en el WS
		System.assertEquals('', responseToAssert.message);
		//System.assertEquals('COM', responseToAssert.asociadoDomicilios[0].tipo_domicilio);
		System.assertEquals('DONADO 320  ', responseToAssert.asociadoDomicilios[0].domicilio);
		//System.assertEquals(null, responseToAssert.asociadoDomicilios[0].piso);
		//System.assertEquals(null, responseToAssert.asociadoDomicilios[0].dpto);
		//System.assertEquals('639', responseToAssert.asociadoDomicilios[0].numero);
		//System.assertEquals('2000ROS', responseToAssert.asociadoDomicilios[0].codigo_postal);
		System.assertEquals('BAHIA BLANCA', responseToAssert.asociadoDomicilios[0].localidad);
		System.assertEquals('BUENOS AIRES', responseToAssert.asociadoDomicilios[0].provincia);
		//System.assertEquals('ARGENTINA', responseToAssert.asociadoDomicilios[0].pais);
		//System.assertEquals(null, responseToAssert.asociadoDomicilios[0].observaciones);
		System.assertEquals('TEL', responseToAssert.asociadoDomicilios[0].telefonos[0].tipo_telefono);
		System.assertEquals('0', responseToAssert.asociadoDomicilios[0].telefonos[0].numero);
	}
	
	//EL WS no me tira error si le pongo un codigo incorrecto, sino que me devuelve todas las delegaciones como si el filtro no existiera
	//@IsTest
	//public static void whenTheBtnIsClickedInTheView_consumeWSDelegacionDomiciliosError_returnErrorMessage(){
		//Test.setMock(HttpCalloutMock.class, getErrorResponseDelegacion);
		
		//Test.startTest();
		//AsociadoDomiciliosBtnCtrl.Response responseToAssert = AsociadoDomiciliosBtnCtrl.getDelegacionDomicilios(0);
		//Test.stopTest();

		//System.assertEquals('Hubo un error al intentar obtener los domicilios desde SaludSoft, asegúrese que el codigo de efector esté completo y sea válido', responseToAssert.message);
		//System.assertEquals(null, responseToAssert.asociadoDomicilios);
	//}
}