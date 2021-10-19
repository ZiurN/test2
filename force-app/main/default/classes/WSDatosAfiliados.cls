public without sharing class WSDatosAfiliados {
    @TestVisible
    public static final Webservice_endpoint_setting__mdt SERVICE_CONFIG =
			ConfigUtils.getWebServiceConfig('SALUDSOFT.TEST');
            
	public static void updateAccountDetailsToWS(List<Account> accounts, Map<Id, Account> oldMap) {
		if(!System.isBatch() && checkIsNotIntegrationUser()) {
			Set<String> asociadosToSend = new Set<String>();
			for(Account acc : accounts) {
				Account oldAcc = oldMap.get(acc.id);
				if((acc.Tipo_de_documento__c != oldAcc.Tipo_de_documento__c 
							|| acc.Numero_de_documento__c != oldAcc.Numero_de_documento__c
							|| acc.PersonEmail != oldAcc.PersonEmail) 
						&& !String.isBlank(
								acc.Afi_Id__c
							)
				) {
					asociadosToSend.add(acc.Afi_Id__c);
				}
			}
			if(!asociadosToSend.isEmpty()) {
				submitChanges(asociadosToSend);
			}
		}
	}
    
    public static void updateDomiciliosDetailsToWS(List<Domicilio__c> domicilios, Map<Id, Domicilio__c> oldMap) {
		if(!System.isBatch() && checkIsNotIntegrationUser()) {
			Map<Id, List<Domicilio__c>> newDomiciliosByAccount = new Map<Id, List<Domicilio__c>>();
			Map<Id, List<Domicilio__c>> oldDomiciliosByAccount = new Map<Id, List<Domicilio__c>>();
			Set<String> asociadosToSend = new Set<String>();

            for(Domicilio__c dom : domicilios) {
				Boolean hasError = false;
				if(oldMap != null){
					Domicilio__c oldDom = oldMap.get(dom.Id);
					if(oldDom.Tipo_de_domicilio__c == 'COM' && dom.Tipo_de_domicilio__c != 'COM') {
						dom.addError('No puede cambiar el tipo de domicilio a un domicilio COM');
						hasError = true;
					}
				}
				if(!hasError) {
					if(newDomiciliosByAccount.containsKey(dom.Cuenta__c)) {
						newDomiciliosByAccount.get(dom.Cuenta__c).add(dom);
					} else {
						newDomiciliosByAccount.put(dom.Cuenta__c, new List<Domicilio__c>{dom});
					}
				}
			}
			Map<Id, Account> accountsIds = new Map<Id, Account>([SELECT Afi_Id__c FROM Account WHERE Id IN :newDomiciliosByAccount.keySet()]);
			for(Domicilio__c dom : [SELECT Tipo_de_domicilio__c, DOM_ID__c, Cuenta__c FROM Domicilio__c WHERE Cuenta__c IN :accountsIds.keySet()]) {
                if(oldDomiciliosByAccount.containsKey(dom.Cuenta__c)) {
					oldDomiciliosByAccount.get(dom.Cuenta__c).add(dom);
				} else {
					oldDomiciliosByAccount.put(dom.Cuenta__c, new List<Domicilio__c>{dom});
				}       
			}
			for(Domicilio__c dom :domicilios) {
				if(oldDomiciliosByAccount.containsKey(dom.Cuenta__c)) {
					Boolean hasError = false;
					for(Domicilio__c oldDom :oldDomiciliosByAccount.get(dom.Cuenta__c)) {
						if(dom.Tipo_de_domicilio__c == oldDom.Tipo_de_domicilio__c && dom.Id != oldDom.Id) {
							dom.addError('Ya existe un registro con este tipo de domicilio, por favor modifique el existente');
							hasError = true;
						}
					}
					if(!hasError) {
						asociadosToSend.add(accountsIds.get(dom.Cuenta__c).Afi_Id__c);
					}
				} else {
					asociadosToSend.add(accountsIds.get(dom.Cuenta__c).Afi_Id__c);
				}
			}
            if(!asociadosToSend.isEmpty()) {
				submitChanges(asociadosToSend);
			}
        }
    }

	public static void updateTelefonosDetailsToWS(List<Telefono__c> telefonos, Map<Id, Telefono__c> oldMap) {
		if(!System.isBatch() && checkIsNotIntegrationUser()) {
			Map<Id, List<Telefono__c>> newTelefonosByAccount = new Map<Id, List<Telefono__c>>();
			Map<Id, List<Telefono__c>> oldTelefonosByAccount = new Map<Id, List<Telefono__c>>();
			Set<Id> accountsToSend = new Set<Id>();
			Set<String> asociadosToSend = new Set<String>();
			for(Telefono__c tel :telefonos) {
				if(oldMap != null) {
					Telefono__c oldTel = oldMap.get(tel.Id);
					if(tel.Telefono__c != oldTel.Telefono__c 
							|| tel.Tipo__c != oldTel.Tipo__c 

					) {
						accountsToSend.add(tel.Cuenta__c);
					}
				} else {
					accountsToSend.add(tel.Cuenta__c);
				}
				if(tel.Telefono_principal__c) {
					if(newTelefonosByAccount.containsKey(tel.Cuenta__c)) {
						newTelefonosByAccount.get(tel.Cuenta__c).add(tel);
					} else {
						newTelefonosByAccount.put(tel.Cuenta__c, new List<Telefono__c>{tel});
					}
				}
			}
			// THIS CHECK IF IS DUPLICATED ACTIVE CHECK
			if(!newTelefonosByAccount.isEmpty()){
				Map<Id, Account> accountsIds = new Map<Id, Account>(
														[SELECT Afi_Id__c 
															FROM Account 
															WHERE Id IN :newTelefonosByAccount.keySet()]);
				for(Telefono__c tel : [SELECT Telefono_principal__c, Cuenta__c FROM Telefono__c WHERE Cuenta__c IN :accountsIds.keySet()]) {
	                if(oldTelefonosByAccount.containsKey(tel.Cuenta__c)) {
						oldTelefonosByAccount.get(tel.Cuenta__c).add(tel);
					} else {
						oldTelefonosByAccount.put(tel.Cuenta__c, new List<Telefono__c>{tel});
					}       
				}
				List<Telefono__c> telefonosToDeactive = new List<Telefono__c>();
				for(Telefono__c tel :telefonos) {
					if(oldTelefonosByAccount.containsKey(tel.Cuenta__c)) {
						Boolean hasOneActive = tel.Telefono_principal__c;
						for(Telefono__c oldTel :oldTelefonosByAccount.get(tel.Cuenta__c)) {
							if(hasOneActive && oldTel.Id != tel.Id) {
								oldTel.Telefono_principal__c = false;
								telefonosToDeactive.add(oldTel);
							}
						}
					}
				}
				if(!telefonosToDeactive.isEmpty()) {
					update telefonosToDeactive;
				}
			}
			
			for(Account acc : [SELECT Afi_Id__c FROM Account WHERE Id IN :accountsToSend]) {
                asociadosToSend.add(acc.Afi_Id__c);           
            }

            if(!asociadosToSend.isEmpty()) {
				submitChanges(asociadosToSend);
			}
        }
    }
	
	
	public static void deleteDomiciliosDetailsToWS(List<Domicilio__c> domicilios) {
		if(!System.isBatch() && checkIsNotIntegrationUser()) {
			Map<Id, List<Domicilio__c>> domiciliosByAccount = new Map<Id, List<Domicilio__c>>();
            for(Domicilio__c dom : domicilios) {
				if(dom.Tipo_de_domicilio__c == 'COM'){
					dom.addError('No se pueden borrar los domicilios de tipo COM');
				} else if(domiciliosByAccount.containsKey(dom.Cuenta__c)) {
					domiciliosByAccount.get(dom.Cuenta__c).add(dom);
				} else {
					domiciliosByAccount.put(dom.Cuenta__c, new List<Domicilio__c>{dom});
				}
			}
			List<ItemWrapper> itemsToSend = new List<ItemWrapper>();
			for(Account acc : [SELECT Afi_Id__c FROM Account WHERE Id IN :domiciliosByAccount.keySet()]) {
                for(Domicilio__c dom :domiciliosByAccount.get(acc.Id)){
					itemsToSend.add(new ItemWrapper(acc.Afi_Id__c, dom.DOM_ID__c, 'dom_id'));
				}           
            }
            if(!itemsToSend.isEmpty()) {
				submitDeletesOfObject(Json.serialize(itemsToSend));
			}
        }
	}
	
	public static void deleteTelefonosDetailsToWS(List<Telefono__c> telefonos) {
		if(!System.isBatch() && checkIsNotIntegrationUser()) {
			Map<Id, List<Telefono__c>> telefonosByAccount = new Map<Id, List<Telefono__c>>();
            for(Telefono__c tel : telefonos) {
				if(!tel.Telefono_principal__c) {
					if(telefonosByAccount.containsKey(tel.Cuenta__c)) {
						telefonosByAccount.get(tel.Cuenta__c).add(tel);
					} else {
						telefonosByAccount.put(tel.Cuenta__c, new List<Telefono__c>{tel});
					}
				} else {
					tel.addError('No puede borrar un telefono principal!');
				}
			}
			List<ItemWrapper> itemsToSend = new List<ItemWrapper>();
			for(Account acc : [SELECT Afi_Id__c FROM Account WHERE Id IN :telefonosByAccount.keySet()]) {
                for(Telefono__c tel :telefonosByAccount.get(acc.Id)){
					itemsToSend.add(new ItemWrapper(acc.Afi_Id__c, tel.TEL_ID__c, 'tel_id'));
				}           
            }
            if(!itemsToSend.isEmpty()) {
				submitDeletesOfObject(Json.serialize(itemsToSend));
			}
        }
    }
    @Future(callout=true)
	public static void submitChanges (Set<String> asociados) {
		
		for(String codigoDeAsociado : asociados) {
			RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/datos-sf',
                'POST',
                null,
                JSON.serialize(new Map<String, Object> {
					'afi_id' => codigoDeAsociado
				}));
			ws.request.setHeader('Accept','application/json"');
			ws.request.setHeader('Content-Type', 'application/json');
			System.debug('****body: ' + ws.bodyParameter.value);
			WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
			Response res = (Response) ws.invoke(new Response());
			System.debug('****RESPONSE' + res.response.getBody());
			WSAuthToken.manageTokenResponse(tokenResp);
		}
	}

	@Future(callout=true)
	public static void submitDeletesOfObject (String itemsToSubmit) {
		List<ItemWrapper> items = (List<ItemWrapper>) JSON.deserialize(itemsToSubmit, List<ItemWrapper>.class);
		for(ItemWrapper item : items) {
			RestWS ws = new RestWS(SERVICE_CONFIG.URL__c + '/v1/salud/afiliado/datos-sf',
                'POST',
                null,
                JSON.serialize(new Map<String, Object> {
					'afi_id' => item.afi_id,
					item.objectType => item.objectId
				}));
			ws.request.setHeader('Accept','application/json"');
			ws.request.setHeader('Content-Type', 'application/json');
			System.debug('****body: ' + ws.bodyParameter.value);
			WSAuthToken.Response tokenResp = WSAuthToken.setAuthHeader(ws);
			Response res = (Response) ws.invoke(new Response());
			System.debug('****RESPONSE' + res.response.getBody());
			WSAuthToken.manageTokenResponse(tokenResp);
		}
	}

	public class ItemWrapper {
		public String afi_id;
		public String objectId;
		public String objectType;

		public ItemWrapper(String afi_id, String objectId, String objectType) {
			this.afi_id = afi_id;
			this.objectId = objectId;
			this.objectType = objectType;
		}
	}

	public class Response extends WSResult {
        public override void processResponse(HttpResponse response) {
			//Do Nothing
        }
	}
	
	private static Boolean checkIsNotIntegrationUser () {
		User usuario = [
			SELECT Id, LastName
			FROM User
			WHERE Id = :UserInfo.getUserId()
		];
		return usuario.LastName != 'Integraciones' && usuario.LastName != 'Integracion';
	}
}