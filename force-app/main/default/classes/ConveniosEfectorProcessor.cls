public class ConveniosEfectorProcessor implements IMasterBuilder{
	public Boolean hasNext = false;
	public Datetime runTime;
	public Datetime lastUpdateForConvenio;
	public Integer pageSize;
	public Integer currentPage;
	public Integer lastPage;

	public Set<String> codEfectores;

	public ConveniosEfectorProcessor(Integer pageSize, Datetime runTime) {
		this(pageSize, 1, 1, runTime, Datetime.now(), new Set<String>());
	}

	public ConveniosEfectorProcessor(Integer pageSize, Datetime runTime, Datetime lastUpdateForConvenio) {
		this(pageSize, 1, 1, runTime, lastUpdateForConvenio, new Set<String>());
	}

	public ConveniosEfectorProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime, Set<String> codigos) {
		this(pageSize, currentPage, lastPage, runTime, Datetime.now(), codigos);
	}

	public ConveniosEfectorProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime, Datetime lastUpdateForConvenio,Set<String> codigos) {
		this.pageSize = pageSize;
		this.currentPage = currentPage;
		this.lastPage = lastPage;
		this.runTime = runTime;
		this.lastUpdateForConvenio = lastUpdateForConvenio;
		this.codEfectores = codigos;
	}

	public List<WSBatchConvenioResp.Data> callWebService() {
		List<WSBatchConvenioResp.Data> wsData = new List<WSBatchConvenioResp.Data>();
		WSBatchConvenio.Response result;

		if (currentPage <= lastPage) {
			String fecha = runTime.format('yyyy-MM-dd');
			result = WSBatchConvenio.getBatchConvenio(fecha, this.pageSize, this.currentPage);
		}

		if(!result.hasError) {
			hasNext = result.Convenio.links.next != null;
			currentPage = result.Convenio.meta.current_page + 1;
			lastPage = result.Convenio.meta.last_page;
			wsData.addAll(result.Convenio.data);
		}

		return wsData;
	}

    public void processResponse(List<Object> wsResponses) {
		List<Convenio__c> conveniosList = new List<Convenio__c>();
		List<String> ids = new List<String>();

		for(Object res : wsResponses) {
			WSBatchConvenioResp.Data convenioResp = (WSBatchConvenioResp.Data) res;
			Convenio__c convenio = new Convenio__c();

            convenio.Id_Externo__c = convenioResp.convenio;
            convenio.Fecha_desde__c = convenioResp.fecha_desde != null ? Date.valueOf(convenioResp.fecha_desde) : null;
            convenio.Fecha_hasta__c = convenioResp.fecha_hasta != null ? Date.valueOf(convenioResp.fecha_hasta) : null;
            convenio.Prestador__r = new Account(Codigo_de_efector__c = convenioResp.prestador); 
            if(convenioResp.cons_secuencia != null){
				convenio.Consultorio__r = new Consultorio__c(Id_Externo__c = convenioResp.prestador + '-' + convenioResp.cons_secuencia);
			}
            convenio.Modelo_convenio__c = convenioResp.modconv_codigo;
            convenio.Coeficiente_modelo__c = convenioResp.coeficiente_modelo != null ? Decimal.valueOf(convenioResp.coeficiente_modelo) : null;
            //convenio. = convenioResp.an_codigo;
            convenio.Estado__c = convenioResp.estado;
            convenio.Fecha_de_activacion__c = convenioResp.fecha_activacion != null ? Date.valueOf(convenioResp.fecha_activacion) : null;
            convenio.Fecha_de_baja__c = convenioResp.fecha_baja != null ? Date.valueOf(convenioResp.fecha_baja) : null;
            convenio.Observaciones__c = convenioResp.observaciones;

			conveniosList.add(convenio);
			ids.add(convenioResp.convenio);
			codEfectores.add(convenioResp.prestador);
		}
		Database.UpsertResult[] results = Database.upsert(
			conveniosList, Convenio__c.Fields.Id_Externo__c, false
		);
		System.debug('******** results * ' + results);
		//EmailUtils.sendErrorMail(results, null, null, ids, 'Convenios');

		Utils.insertBatchLogs(results, null, null, ids, 'Convenios');
    }

    public void updateDate() {

		if (hasNext) {
			ConveniosEfectorProcessor nextProcessor = new ConveniosEfectorProcessor(pageSize, currentPage, lastPage, runTime,codEfectores);
			Database.executeBatch(new MasterBatch(nextProcessor));
		}
		else{
			if(!codEfectores.isEmpty()){
				ConveniosProcessor pdfProcessor = new ConveniosProcessor(new List<String>(codEfectores),runTime);
				Database.executeBatch(new MasterBatch(pdfProcessor));
			}
		}
			
	}
}