@IsTest
public class ConfigUtilsTest  {
	@isTest
	static void test() {
        System.assertNotEquals(null, ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST'), 'La respuesta no debe ser nula');
    }
	@IsTest
	static void getDebugMail() {
		System.assertNotEquals(null, ConfigUtils.getDebugEmail('ACA debug mail'), 'La respuesta no debe ser nula');
	}
	@IsTest
	static void getBatchDebugEmails() {
		System.assertNotEquals(null, ConfigUtils.getBatchDebugEmails(), 'La respuesta no debe ser nula');
	}
	@IsTest
	static void getAccessToken(){
		System.assertEquals(null, ConfigUtils.getToken(), 'La respuesta no debe ser nula');
	}
	@IsTest
	static void getEndpointsByTipoTest() {
		Map<String, Webservice_endpoint__mdt> result = ConfigUtils.getEndpointsByTipo('solicitudes-afiliados');
		System.assertEquals(8, result.values().size(), 'Deben haber ocho elementos devueltos');
		System.assertEquals('/v1/salud/solicitudes-afiliados/alta-familiar', result.get('alta-familiar').Endpoint__c, 'El endpoint no es el esperado');
		System.assertEquals('/v1/salud/solicitudes-afiliados/baja', result.get('baja').Endpoint__c, 'El endpoint no es el esperado');
		System.assertEquals('/v1/salud/solicitudes-afiliados/cambio-plan', result.get('cambio-plan').Endpoint__c, 'El endpoint no es el esperado');
		System.assertEquals('/v1/salud/solicitudes-afiliados/cambio-segmento', result.get('cambio-segmento').Endpoint__c, 'El endpoint no es el esperado');
		System.assertEquals('/v1/salud/solicitudes-afiliados/datos-particulares', result.get('datos-particulares').Endpoint__c, 'El endpoint no es el esperado');
		System.assertEquals('/v1/salud/solicitudes-afiliados/despegue', result.get('despegue').Endpoint__c, 'El endpoint no es el esperado');
		System.assertEquals('/v1/salud/solicitudes-afiliados/interfaz-financiera', result.get('interfaz-financiera').Endpoint__c, 'El endpoint no es el esperado');
		System.assertEquals('/v1/salud/solicitudes-afiliados/reemision-credencial', result.get('reemision-credencial').Endpoint__c, 'El endpoint no es el esperado');
		result = ConfigUtils.getEndpointsByTipo('autorizaciones');
		System.assertEquals('/v1/salud/autorizaciones', result.get('autorizaciones').Endpoint__c, 'El endpoint no es el esperado');
	}
}