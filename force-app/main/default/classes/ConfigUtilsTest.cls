@IsTest
public class ConfigUtilsTest  {
	@isTest static void test() {
        System.assertNotEquals(null, ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST'));
    }

	@IsTest static void getDebugMail() {
		System.assertNotEquals(null, ConfigUtils.getDebugEmail('ACA debug mail'));
	}

	@IsTest static void getBatchDebugEmails() {
		System.assertNotEquals(null, ConfigUtils.getBatchDebugEmails());
	}

	@IsTest static void getAccessToken(){
		System.assertEquals(null, ConfigUtils.getToken());
	}
}