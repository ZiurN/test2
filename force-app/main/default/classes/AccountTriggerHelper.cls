public class AccountTriggerHelper {

	
	@Future(callout=true)
	public static void updateFacturaElectronicaOnSS(Id[] accIds) {
		Account[] accs = [SELECT Id, Envio_de_recibo__c, Afi_Id__c FROM Account WHERE Id IN :accIds];
		String body;
		WSAsociadoFacturaElectronica.Response resp;

		for(Account anAcc : accs) {
			
			if(anAcc.Envio_de_recibo__c == 'Factura online') {
				body = '{ "adherido": "S" }';
				resp = WSAsociadoFacturaElectronica.updateFacturaElectronica(anAcc.Afi_Id__c, body);
			} else if (anAcc.Envio_de_recibo__c == 'Factura papel') {
				body = '{ "adherido": "N" }';
				resp = WSAsociadoFacturaElectronica.updateFacturaElectronica(anAcc.Afi_Id__c, body);
			}

			System.debug('****resp ' + resp);
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
						&& !String.isBlank(
								acc.Afi_Id__c
							)
				) {
					asociadosToSend.add(acc.Afi_Id__c);
				}
			}
			if(!asociadosToSend.isEmpty()) {
				WSDatosAfiliados.submitChanges(asociadosToSend);
			}
		}
	}

	

}