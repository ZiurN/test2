/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase auxiliar para el trigger de Accounts.
@date			01/06/2022.
------------------------------------------------------------------------------------------------------------------------*/
public with sharing class AccountTriggerHelper {
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@description	Método asíncrono para adjuntar factura Electrónica de la cuenta a SS.
	@param			accIds - Id de las cuentas a validar.
	------------------------------------------------------------------------------------------------------------------------*/
	@Future(callout=true)
	public static void updateFacturaElectronicaOnSS(Id[] accIds) {
		Account[] accs = [SELECT Id, Envio_de_recibo__c, Afi_Id__c FROM Account WHERE Id IN :accIds];
		for(Account anAcc : accs) {
			String extraParams = anAcc.Afi_Id__c + '/factura-electronica';
			WSEnviarASSHelper.SSRequest ssRequest;
			if(anAcc.Envio_de_recibo__c == 'Factura online') {
				ssRequest = new WSEnviarASSHelper.SSRequest('{"adherido":"S"}', 'afiliado', 'afiliado', 'PUT', extraParams);
			} else if (anAcc.Envio_de_recibo__c == 'Factura papel') {
				ssRequest = new WSEnviarASSHelper.SSRequest('{"adherido":"N"}', 'afiliado', 'afiliado', 'PUT', extraParams);
			}
			WSEnviarASSHelper.enviarASS(ssRequest);
		}
	}
	//Este metodo es para enviar flag de actualizacion al WS
	public static void updateAccountDetailsToWS(List<Account> accounts, Map<Id, Account> oldMap) {
		if(!System.isBatch()) {
			Set<String> asociadosToSend = new Set<String>();
			for(Account acc : accounts) {
				Account oldAcc = oldMap.get(acc.id);
				if((acc.Tipo_de_documento__c != oldAcc.Tipo_de_documento__c
						|| acc.Numero_de_documento__c != oldAcc.Numero_de_documento__c
						|| acc.PersonEmail != oldAcc.PersonEmail
						|| acc.Tipo_de_Telefono__c != oldAcc.Tipo_de_Telefono__c
						|| acc.Phone != oldAcc.Phone)
					&& !String.isBlank(acc.Afi_Id__c)) {
					asociadosToSend.add(acc.Afi_Id__c);
				}
			}
			if(!asociadosToSend.isEmpty()) {
				WSDatosAfiliados.submitChanges(asociadosToSend);
			}
		}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@description	Método para validar en SS los campos modificados en SF.
	@param			oppsInfoList - Lista de las oportunidades a validar.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void validateAccountsFieldsInSS (List<AccountInfo> accountsToValidate) {
		for (AccountInfo accInfo : accountsToValidate) {
			System.enqueueJob(new AsyncValidateChangesInAcountInSS(accInfo));
		}
	}
	public class AccountInfo {
		public Account updatedAccount {get; set;}
		public Account previewAccount {get; set;}
	}
}