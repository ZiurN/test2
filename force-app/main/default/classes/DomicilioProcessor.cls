public class DomicilioProcessor implements IMasterBuilder {

	public Boolean hasNext = false;
	public Datetime runTime;
	public Datetime lastUpdateForDomicilios;
	public Integer pageSize;
	public Integer currentPage;
	public Integer lastPage;
	public Boolean errorWs = false;

	public DomicilioProcessor(Integer pageSize, Datetime runTime) {
		this(pageSize, 1, 1, runTime, Datetime.now());
	}

	public DomicilioProcessor(Integer pageSize, Datetime runTime, Datetime lastUpdateForDomicilios) {
		this(pageSize, 1, 1, runTime, lastUpdateForDomicilios);
	}

	public DomicilioProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime) {
		this(pageSize, currentPage, lastPage, runTime, Datetime.now());
	}

	public DomicilioProcessor(
		Integer pageSize, 
		Integer currentPage, 
		Integer lastPage, 
		Datetime runTime, 
		Datetime lastUpdateForDomicilios 
	) {
		this.pageSize = pageSize;
		this.currentPage = currentPage;
		this.lastPage = lastPage;
		this.runTime = runTime;
		this.lastUpdateForDomicilios = lastUpdateForDomicilios;
	}

	public List<WSBatchDomicilioResp.Data> callWebService() {
		List<WSBatchDomicilioResp.Data> wsData = new List<WSBatchDomicilioResp.Data>();
		WSBatchDomicilio.Response result;

		if (currentPage <= lastPage) {
			String fecha = runTime.format('yyyy-MM-dd');
			result = WSBatchDomicilio.getBatchDomicilio(fecha, this.pageSize, this.currentPage);
		}

		if(!result.hasError) {
			hasNext = result.resp.links.next != null;
			currentPage = result.resp.meta.current_page + 1;
			lastPage = result.resp.meta.last_page;
			wsData = result.resp.data;
		} else {
			this.errorWs = true;
		}

		return wsData;
	}

	public void processResponse(List<Object> wsResponses) {
		List<Domicilio__c> domiciliosToUpsert = new List<Domicilio__c>();
		List<String> externarlIds = new List<String>();

		for(Object resp : wsResponses) {
			WSBatchDomicilioResp.Data domicilioWS = (WSBatchDomicilioResp.Data) resp;

			Domicilio__c domicilio = new Domicilio__c();
			domicilio.DOM_ID__c = domicilioWS.domiafi_id;
			domicilio.Calle__c = domicilioWS.calle;
			domicilio.Numero__c = String.isNotBlank(domicilioWS.numero) ? Integer.valueOf(domicilioWS.numero) : null;
			domicilio.Piso__c = domicilioWS.piso;
			domicilio.DPTO__c = domicilioWS.dpto;
			domicilio.Tipo_de_domicilio__c = domicilioWS.td_codigo;

			if(String.isNotBlank(domicilioWS.afi_id)) {
				domicilio.Cuenta__r = new Account(Afi_Id__c = domicilioWS.afi_id);
			} 

			if(String.isNotBlank(domicilioWS.loc_id)) {
				domicilio.Localidad__r = new Localidad__c(Loc_Id__c = domicilioWS.loc_id);
			} 
			
			domiciliosToUpsert.add(domicilio);
			externarlIds.add(domicilioWS.domiafi_id);
		}

		Database.UpsertResult[] results = Database.upsert(
			domiciliosToUpsert, Domicilio__c.Fields.DOM_ID__c, false
		);
		System.debug('*****results ' + results); 

		Utils.insertBatchLogs(results, null, null, externarlIds, 'Domicilios');
	}

	public void updateDate() {

		if (!hasNext) {
			if(!errorWs) {
				MasterConfigs__c lastUpdate = MasterConfigs__c.getOrgDefaults();
				lastUpdate.Domicilios__c = lastUpdateForDomicilios;
				upsert lastUpdate;
			}
			else {
				System.debug('<<** HUBO UN ERROR EN EL WS **>>');
			}
		} 
		else {
			DomicilioProcessor nextProcessor = new DomicilioProcessor(pageSize, currentPage, lastPage, runTime);
			Database.executeBatch(new MasterBatch(nextProcessor));
		}
	}

}