public class ObraSocialProcessor implements IMasterBuilder  {

	public Boolean hasNext = false;
	public Datetime runTime;
	public Datetime lastUpdateForObraSocial;
	public Integer pageSize;
	public Integer currentPage;
	public Integer lastPage;

	public ObraSocialProcessor(Integer pageSize, Datetime runTime) {
		this(pageSize, 1, 1, runTime, Datetime.now());
	}

	public ObraSocialProcessor(Integer pageSize, Datetime runTime, Datetime lastUpdateForObraSocial) {
		this(pageSize, 1, 1, runTime, lastUpdateForObraSocial);
	}

	public ObraSocialProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime) {
		this(pageSize, currentPage, lastPage, runTime, Datetime.now());
	}

	public ObraSocialProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime, Datetime lastUpdateForObraSocial) {
		this.pageSize = pageSize;
		this.currentPage = currentPage;
		this.lastPage = lastPage;
		this.runTime = runTime;
		this.lastUpdateForObraSocial = lastUpdateForObraSocial;
	}

	public List<WSBatchObraSocialResp.Data> callWebService() {
		List<WSBatchObraSocialResp.Data> wsData = new List<WSBatchObraSocialResp.Data>();
		WSBatchObraSocial.Response result;

		if (currentPage <= lastPage) {
			String fecha = runTime.format('yyyy-MM-dd');
			result = WSBatchObraSocial.getBatchObrasSociales(fecha, this.pageSize, this.currentPage);
		}

		if(!result.hasError) {
			hasNext = result.obrasSociales.links.next != null;
			currentPage = result.obrasSociales.meta.current_page + 1;
			lastPage = result.obrasSociales.meta.last_page;
			wsData.addAll(result.obrasSociales.data);
		}

		return wsData;
	}

	public void processResponse(List<Object> wsResponses) {
		List<Account> obraSocialList = new List<Account>();
		List<String> externalIds = new List<String>();
        Set<Agrupacion__c> agrupacionSet = new Set<Agrupacion__c>();
		Set<Account> delegacionesSet = new Set<Account>();
		List<Cuenta_Agrupacion__c> cuentaAgrupacionList = new List<Cuenta_Agrupacion__c>();

		for(Object res : wsResponses) {
			WSBatchObraSocialResp.Data obraSocialResp = (WSBatchObraSocialResp.Data) res;
			Account obraSocial = new Account();
			obraSocial.RecordTypeId = XappiaHelper.getRecordType('Account', 'Obra_social').Id;

			obraSocial.Name = obraSocialResp.nombre;
			obraSocial.Codigo_de_obra_social__c = obraSocialResp.codigo;
			obraSocial.Descripcion_obra_social__c= obraSocialResp.descripcion ;
			obraSocial.CUIT__c = obraSocialResp.cuit ;
			obraSocial.Fecha_de_activacion__c = obraSocialResp.fecha_activacion != null ? Date.valueOf(obraSocialResp.fecha_activacion) : null;
			obraSocial.Estado__c = obraSocialResp.estado ;
			obraSocial.Codigo_Agrupacion__c = obraSocialResp.codigo_agrupacion ;
			obraSocial.Clase_obra_social__c = obraSocialResp.clase ;
			obraSocial.Obra_social_nombre__c = obraSocialResp.nombre ;
			obraSocial.Codigo_RNOS__c = obraSocialResp.codigo_rnos;
			obraSocial.Type = obraSocialResp.tipo ;
			obraSocial.Codigo_financiero__c = obraSocialResp.codigo_financiero ;
			obraSocial.Correo_electronico__c = Utils.isAValidEmail(obraSocialResp.email) ? obraSocialResp.email : null;
			obraSocial.descripcion_agrupacion_os__c = obraSocialResp.descripcion_agrupacion;
			
			obraSocialList.add(obraSocial);
			externalIds.add(obraSocialResp.codigo);

			if(obraSocialResp.codigo_agrupacion != null && obraSocialResp.descripcion_agrupacion != null) {
				Agrupacion__c agrupacion = new Agrupacion__c(Codigo__c = obraSocialResp.codigo_agrupacion, Nombre__c = obraSocialResp.descripcion_agrupacion);
				agrupacionSet.add(agrupacion);
				Cuenta_Agrupacion__c junction = new Cuenta_Agrupacion__c();
				junction.Id_Externo__c = obraSocialResp.codigo + '-' + obraSocialResp.codigo_agrupacion;
				junction.Cuenta__r = new Account(Codigo_de_obra_social__c = obraSocialResp.codigo);
				junction.Agrupacion__r = new Agrupacion__c(Codigo__c = obraSocialResp.codigo_agrupacion);
				cuentaAgrupacionList.add(junction);
			}
            
		}

		List<Account> delegacionList = new List<Account>(delegacionesSet);
		Database.UpsertResult[] delegacionRes = Database.upsert(
			delegacionList, Account.Fields.Codigo_de_delegacion__c,false
		);

		Database.UpsertResult[] results = Database.upsert(
			obraSocialList, Account.Fields.Codigo_de_obra_social__c, false
		);
		List<Agrupacion__c> agrupacionList = new List<Agrupacion__c>(agrupacionSet);
		Database.UpsertResult[] resultsAgrup = Database.upsert(
				agrupacionList, Agrupacion__c.Fields.Codigo__c, false
		);
		Database.UpsertResult[] resultsCtaAgrup = Database.upsert(
				cuentaAgrupacionList, Cuenta_Agrupacion__c.Fields.Id_Externo__c, false
		);
		System.debug(delegacionRes);
		System.debug(results);
		//EmailUtils.sendErrorMail(delegacionRes, null, null, null, 'OS(Delegaciones)');
		//EmailUtils.sendErrorMail(results, null, null, externalIds, 'Obras Sociales');
		//EmailUtils.sendErrorMail(resultsAgrup, null, null, null, 'OS(Agrupaciones)');
		//EmailUtils.sendErrorMail(resultsCtaAgrup, null, null, null, 'OS(JunctionCtaAgrup)');

		Utils.insertBatchLogs(results, null, null, externalIds, 'Obras Sociales');

	}

	public void updateDate() {

		if (!hasNext) {
			MasterConfigs__c lastUpdate = MasterConfigs__c.getOrgDefaults();
			lastUpdate.Obras_Sociales__c = lastUpdateForObraSocial;
			upsert lastUpdate;
		} else {
			ObraSocialProcessor nextProcessor = new ObraSocialProcessor(pageSize, currentPage, lastPage, runTime);
			Database.executeBatch(new MasterBatch(nextProcessor));
		}
	}
}