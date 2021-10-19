public class DelegacionProcessor implements IMasterBuilder  {

	public Boolean hasNext = false;
	public Datetime runTime;
	public Datetime lastUpdateForDelegacion;
	public Integer pageSize;
	public Integer currentPage;
	public Integer lastPage;
	public Boolean errorWs = false;

	public DelegacionProcessor(Integer pageSize, Datetime runTime) {
		this(pageSize, 1, 1, runTime, Datetime.now());
	}

	public DelegacionProcessor(Integer pageSize, Datetime runTime, Datetime lastUpdateForDelegacion) {
		this(pageSize, 1, 1, runTime, lastUpdateForDelegacion);
	}

	public DelegacionProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime) {
		this(pageSize, currentPage, lastPage, runTime, Datetime.now());
	}

	public DelegacionProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime, Datetime lastUpdateForDelegacion) {
		this.pageSize = pageSize;
		this.currentPage = currentPage;
		this.lastPage = lastPage;
		this.runTime = runTime;
		this.lastUpdateForDelegacion = lastUpdateForDelegacion;
	}

	public List<WSBatchDelegacionResp.Data> callWebService() {
		List<WSBatchDelegacionResp.Data> wsData = new List<WSBatchDelegacionResp.Data>();
		WSBatchDelegacion.Response result;

		if (currentPage <= lastPage) {
			String fecha = runTime.format('yyyy-MM-dd');
			result = WSBatchDelegacion.getBatchDelegacion(fecha, this.pageSize, this.currentPage);
		}

		if(!result.hasError) {
			hasNext = result.delegacion.links.next != null;
			currentPage = result.delegacion.meta.current_page + 1;
			lastPage = result.delegacion.meta.last_page;
			wsData.addAll(result.delegacion.data);
		} else {
			this.errorWs = true;
		}

		return wsData;
	}

	public void processResponse(List<Object> wsResponses) {
		List<Account> delegacionesList = new List<Account>();
		List<String> externalIds = new List<String>();
		//Map<String, Account> filialesList = new Map<String, Account>();

		for(Object res : wsResponses) {
			WSBatchDelegacionResp.Data delegacionResp = (WSBatchDelegacionResp.Data) res;
			Account delegacion = new Account();
			delegacion.RecordTypeId = XappiaHelper.getRecordType('Account', 'Delegacion').Id;

			delegacion.Name = delegacionResp.nombre;
			delegacion.Nombre_delegacion__c = delegacionResp.nombre;
			delegacion.Codigo_de_delegacion__c = delegacionResp.codigo;
			delegacion.Fecha_de_activacion__c = delegacionResp.fecha_activacion != null 
				? Date.valueOf(delegacionResp.fecha_activacion) : null; 
			delegacion.Correo_electronico__c = Utils.isAValidEmail(delegacionResp.correo_electronico) 
												? delegacionResp.correo_electronico : null;
			delegacion.Porcentaje_de_comision_dateras__c = delegacionResp.pje_comis_dateras != null 
				? Decimal.valueOf(delegacionResp.pje_comis_dateras) : null;
			delegacion.Correo_gerencia_cooperativa__c = Utils.isAValidEmail(delegacionResp.correo_gerencia_coop) 
														? delegacionResp.correo_gerencia_coop : null;
			delegacion.Type = delegacionResp.tipo_delegacion;
			delegacion.Descripcion_delegacion__c = delegacionResp.descripcion;
			delegacion.Observaciones_delegacion__c = delegacionResp.observaciones;
			delegacion.Nivel_de_permiso__c = delegacionResp.nivel_permiso;
			delegacion.Organizacion__c = delegacionResp.organizacion == 'ROS' ? 'Rosario' 
				: delegacionResp.organizacion == 'BUE' ? 'Buenos Aires' 
				: null;
			delegacion.Estado__c = delegacionResp.estado;
			delegacion.Tipo_de_comision_de_venta__c = delegacionResp.tipo_comision_venta;
			delegacion.Delegacion2__r = delegacionResp.filial_depende != null 
				? new Account(Codigo_de_delegacion__c = delegacionResp.filial_depende) : null;
			delegacion.Tipo_delegacion__c = delegacionResp.tipo_real_virtual;

			delegacionesList.add(delegacion);
			externalIds.add(delegacionResp.codigo);
            
		}
		Database.UpsertResult[] results = Database.upsert(
			delegacionesList, Account.Fields.Codigo_de_delegacion__c, false
		);
		System.debug('****results* ' + results);

		//EmailUtils.sendErrorMail(results, null, null, externalIds, 'Delegaciones');

		Utils.insertBatchLogs(results, null, null, externalIds, 'Delegaciones');
	}

	public void updateDate() {

		if (!hasNext) {
			if(!errorWs) {
				MasterConfigs__c lastUpdate = MasterConfigs__c.getOrgDefaults();
				lastUpdate.Delegaciones__c = lastUpdateForDelegacion;
				upsert lastUpdate;
			}
		} else {
			DelegacionProcessor nextProcessor = new DelegacionProcessor(pageSize, currentPage, lastPage, runTime);
			Database.executeBatch(new MasterBatch(nextProcessor));
		}
	}
}