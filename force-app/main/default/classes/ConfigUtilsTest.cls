@IsTest
public class ConfigUtilsTest {
	@isTest
	static void test() {
        System.assertNotEquals(null, ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST'), 'Debe obtener información');
    }
	@IsTest
	static void getDebugMail() {
		System.assertNotEquals(null, ConfigUtils.getDebugEmail('ACA debug mail'), 'Debe obtener información');
	}
	@IsTest
	static void getBatchDebugEmails() {
		System.assertNotEquals(null, ConfigUtils.getBatchDebugEmails(), 'Debe obtener información');
	}
	@IsTest
	static void getAccessToken(){
		System.assertEquals(null, ConfigUtils.getToken(), 'Debe obtener información');
	}
}