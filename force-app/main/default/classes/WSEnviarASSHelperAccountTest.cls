/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase de pruebas para los envios a SS de información de cuentas.
@date			24/05/2022
------------------------------------------------------------------------------------------------------------------------*/
@isTest
public with sharing class WSEnviarASSHelperAccountTest {
    private static String DATOS_SF_URL = ConfigUtils.getEndpointsByTipo('afiliado').get('datos-sf').Endpoint__c;
	private static XHttpCalloutMock getResponseFound = new XHttpCalloutMock();
}
