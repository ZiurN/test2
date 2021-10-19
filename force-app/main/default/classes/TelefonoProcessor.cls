public class TelefonoProcessor implements IMasterBuilder {

	public Boolean hasNext = false;
	public Datetime runTime;
	public Datetime lastUpdateForTelefonos;
	public Integer pageSize;
	public Integer currentPage;
	public Integer lastPage;
	public Boolean errorWs = false;
	public Boolean cargaInicial = false;

	public TelefonoProcessor(Integer pageSize, Datetime runTime) {
		this(pageSize, 1, 1, runTime, Datetime.now(), false);
	}

	public TelefonoProcessor(Integer pageSize, Datetime runTime, Boolean cargaInicial) {
		this(pageSize, 1, 1, runTime, Datetime.now(), cargaInicial);
	}

	public TelefonoProcessor(Integer pageSize, Datetime runTime, Datetime lastUpdateForAsociado) {
		this(pageSize, 1, 1, runTime, lastUpdateForAsociado, false);
	}

	public TelefonoProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime, Boolean cargaInicial) {
		this(pageSize, currentPage, lastPage, runTime, Datetime.now(), cargaInicial);
	}

	public TelefonoProcessor(
		Integer pageSize, 
		Integer currentPage, 
		Integer lastPage, 
		Datetime runTime, 
		Datetime lastUpdateForTelefonos, 
		Boolean cargaInicial
	) {
		this.pageSize = pageSize;
		this.currentPage = currentPage;
		this.lastPage = lastPage;
		this.runTime = runTime;
		this.lastUpdateForTelefonos = lastUpdateForTelefonos;
		this.cargaInicial = cargaInicial;
	}

	public List<WSBatchTelefonoResp.Data> callWebService() {
		List<WSBatchTelefonoResp.Data> wsData = new List<WSBatchTelefonoResp.Data>();
		WSBatchTelefono.Response result;

		if (currentPage <= lastPage) {
			String fecha = runTime.format('yyyy-MM-dd');
			result = WSBatchTelefono.getBatchTelefono(fecha, this.pageSize, this.currentPage, cargaInicial);
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
		List<Telefono__c> telefonosToUpsert = new List<Telefono__c>();
		List<String> externarlIds = new List<String>();

		for(Object resp : wsResponses) {
			WSBatchTelefonoResp.Data telefonoWS = (WSBatchTelefonoResp.Data) resp;

			Telefono__c tel = new Telefono__c();
			tel.TEL_ID__c = telefonoWS.telafi_id;
			tel.Tipo__c = telefonoWS.tipo;
			tel.Telefono__c = telefonoWS.numero;

			if(String.isNotBlank(telefonoWS.ppal)) {
				tel.Telefono_principal__c = telefonoWS.ppal == 'V' ? true : false;
			}

			if(String.isNotBlank(telefonoWS.afi_id)) {
				tel.Cuenta__r = new Account(Afi_Id__c = telefonoWS.afi_id);
			} 
			
			telefonosToUpsert.add(tel);
			externarlIds.add(telefonoWS.telafi_id);
		}

		Database.UpsertResult[] results = Database.upsert(
			telefonosToUpsert, Telefono__c.Fields.TEL_ID__c, false
		);

		System.debug('*****results ' + results); 

		
		//EmailUtils.sendErrorMail(resultsAgrup, null, null, null, 'Empresas(Agrupaciones)');
		//EmailUtils.sendErrorMail(results, null, null, externarlIds, 'Empresas');
		//EmailUtils.sendErrorMail(resultsCtaAgrup, null, null, null, 'Empresas(JunctionCtaAgrup)');

		Utils.insertBatchLogs(results, null, null, externarlIds, 'Telefonos');
	}

	public void updateDate() {

		if (!hasNext) {
			if(!errorWs) {
				MasterConfigs__c lastUpdate = MasterConfigs__c.getOrgDefaults();
				lastUpdate.Telefonos__c = lastUpdateForTelefonos;
				upsert lastUpdate;
			}
		} else {
			TelefonoProcessor nextProcessor = new TelefonoProcessor(pageSize, currentPage, lastPage, runTime, cargaInicial);
			Database.executeBatch(new MasterBatch(nextProcessor));
		}
	}
	
}