public class ClausulasTempProcessor implements IMasterBuilder  {
	
	public Boolean hasNext = false;
	public Datetime runTime;
	public Datetime lastUpdateForACT;
	public Integer pageSize;
	public Integer currentPage;
	public Integer lastPage;
	public Boolean errorWs = false;

	public ClausulasTempProcessor(Integer pageSize, Datetime runTime) {
		this(pageSize, 1, 1, runTime, Datetime.now());
	}

	public ClausulasTempProcessor(Integer pageSize, Datetime runTime, Datetime lastUpdateForACT) {
		this(pageSize, 1, 1, runTime, lastUpdateForACT);
	}

	public ClausulasTempProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime) {
		this(pageSize, currentPage, lastPage, runTime, Datetime.now());
	}

	public ClausulasTempProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime, Datetime lastUpdateForACT) {
		this.pageSize = pageSize;
		this.currentPage = currentPage;
		this.lastPage = lastPage;
		this.runTime = runTime;
		this.lastUpdateForACT = lastUpdateForACT;
	}

	public List<WSBatchClausulasTempResp.Data> callWebService() {
		List<WSBatchClausulasTempResp.Data> wsData = new List<WSBatchClausulasTempResp.Data>();
		WSBatchClausulasTemp.Response resp;

		if (currentPage <= lastPage) {
			String fecha = runTime.addDays(-90).format('yyyy-MM-dd');
			resp = WSBatchClausulasTemp.getBatchClausulasTemp(fecha, this.pageSize, this.currentPage);
		}

		if(!resp.hasError) {
			hasNext = resp.result.links.next != null;
			currentPage = resp.result.meta.current_page + 1;
			lastPage = resp.result.meta.last_page;
			wsData.addAll(resp.result.data);
		} else {
			this.errorWs = true;
		}

		return wsData;
	}

	public void processResponse(List<Object> wsResponses) {
		List<Asignacion_de_clausula_temporaria__c> actList = new List<Asignacion_de_clausula_temporaria__c>();
		List<String> externalIds = new List<String>();

		for(Object resp : wsResponses) {
			WSBatchClausulasTempResp.Data actWs = (WSBatchClausulasTempResp.Data) resp;
			Asignacion_de_clausula_temporaria__c act = new Asignacion_de_clausula_temporaria__c();
            
			act.codigo_ACT_SS__c = actWs.acta_id;
			act.Batch__c = true;
			act.Tipo__c = actWs.tacta_codigo;
			act.Descripcion__c = actWs.observaciones;
			act.Fecha_desde__c = actWs.fecha_vigencia_desde != null ? Date.valueOf(actWs.fecha_vigencia_desde) : null;
			act.Fecha_de_vigencia_hasta__c = actWs.fecha_vigencia_hasta != null 
												? Date.valueOf(actWs.fecha_vigencia_hasta) : null;
			act.Fecha_FUM__c = actWs.fecha_fum != null ? Date.valueOf(actWs.fecha_fum) : null;
			act.FPP__c = actWs.fecha_pp != null ? Date.valueOf(actWs.fecha_pp) : null;
			
			if(String.isNotBlank(actWs.diag_codigo)) {
				act.Diagnostico__r = new Diagnostico__c(Codigo_del_Diagnostico__c = actWs.diag_codigo);
			}
			if(String.isNotBlank(actWs.codigo)) {
				act.Asociado__r = new Account(Codigo_de_Afiliado__c = actWs.codigo);
			}
				
			actList.add(act);
			externalIds.add(actWs.acta_id);
		}

		Database.UpsertResult[] results = Database.upsert(
			actList, Asignacion_de_clausula_temporaria__c.codigo_ACT_SS__c, false
		);
		System.debug('****results* ' + results);
		//EmailUtils.sendErrorMail(results, null, null, externalIds, 'Clausulas Temporarias ' + (currentPage - 1) + ' pagina');

		Utils.insertBatchLogs(results, null, null, externalIds, 'Clausulas Temporarias');

	}

	public void updateDate() {

		if (!hasNext) {
			if(!errorWs) {
				MasterConfigs__c lastUpdate = MasterConfigs__c.getOrgDefaults();
				lastUpdate.Clausulas_Temporales__c = lastUpdateForACT;
				upsert lastUpdate;
			}
		} else {
			ClausulasTempProcessor nextProcessor = new ClausulasTempProcessor(pageSize, currentPage, lastPage, runTime);
			Database.executeBatch(new MasterBatch(nextProcessor));
		}
	}
}