public class SucursalesEmpresaProcessor implements IMasterBuilder  {

	public Boolean hasNext = false;
	public Datetime runTime;
	public Datetime lastUpdateForSucursal;
	public Integer pageSize;
	public Integer currentPage;
	public Integer lastPage;

	public SucursalesEmpresaProcessor(Integer pageSize, Datetime runTime) {
		this(pageSize, 1, 1, runTime, Datetime.now());
	}

	public SucursalesEmpresaProcessor(Integer pageSize, Datetime runTime, Datetime lastUpdateForSucursal) {
		this(pageSize, 1, 1, runTime, lastUpdateForSucursal);
	}

	public SucursalesEmpresaProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime) {
		this(pageSize, currentPage, lastPage, runTime, Datetime.now());
	}

	public SucursalesEmpresaProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime, Datetime lastUpdateForSucursal) {
		this.pageSize = pageSize;
		this.currentPage = currentPage;
		this.lastPage = lastPage;
		this.runTime = runTime;
		this.lastUpdateForSucursal = lastUpdateForSucursal;
	}

	public List<WSBatchSucursalResp.Data> callWebService() {
		List<WSBatchSucursalResp.Data> wsData = new List<WSBatchSucursalResp.Data>();
		WSBatchSucursal.Response result;

		if (currentPage <= lastPage) {
			String fecha = runTime.format('yyyy-MM-dd');
			result = WSBatchSucursal.getBatchSucursal(fecha, this.pageSize, this.currentPage);
		}

		if(!result.hasError) {
			hasNext = result.sucursal.links.next != null;
			currentPage = result.sucursal.meta.current_page + 1;
			lastPage = result.sucursal.meta.last_page;
			wsData.addAll(result.sucursal.data);
		}

		return wsData;
	}
	
	public void processResponse(List<Object> wsResponses) {
		List<Sucursal__c> sucursalList = new List<Sucursal__c>();
		List<String> externalIds = new List<String>();

		for(Object res : wsResponses) {
			WSBatchSucursalResp.Data sucursalResp = (WSBatchSucursalResp.Data) res;
			Sucursal__c sucursal = new Sucursal__c();

			sucursal.Id_externo__c = sucursalResp.empl_empl_id + '-' + sucursalResp.codigo_suc;
			sucursal.Empresa__r = new Account(Codigo_de_empresa__c = sucursalResp.empl_empl_id); 
			sucursal.Name = sucursalResp.nombre;
			sucursal.Codigo__c = sucursalResp.codigo_suc;
			sucursal.Descripcion__c = sucursalResp.descripcion;
			sucursal.Fecha_de_Activacion__c = Date.valueOf(sucursalResp.fecha_activacion);
			sucursal.Estado__c = sucursalResp.estado_sucursal;
			sucursal.Mail__c = Utils.isAValidEmail(sucursalResp.email) ? sucursalResp.email : null;
			sucursal.Observaciones__c = sucursalResp.observaciones;
			sucursal.Es_sujeto_de_facturacion__c = sucursalResp.es_sujeto_facturacion != null 
				? sucursalResp.es_sujeto_facturacion == 'V' 
				? true : false 
				: null;
			sucursal.Referencia_externa__c = sucursalResp.referencia_externa;

			sucursalList.add(sucursal);
			externalIds.add(sucursal.Id_externo__c);
		}
		Database.UpsertResult[] results = Database.upsert(
			sucursalList, Sucursal__c.Fields.Id_externo__c, false
		);
		System.debug('****results* ' + results);
		//EmailUtils.sendErrorMail(results, null, null, externalIds, 'Sucursales');
		
		Utils.insertBatchLogs(results, null, null, externalIds, 'Sucursales');
	}

	public void updateDate() {

		if (hasNext) {	
			SucursalesEmpresaProcessor nextProcessor = new SucursalesEmpresaProcessor(pageSize, currentPage, lastPage, runTime);
			Database.executeBatch(new MasterBatch(nextProcessor));
		} 
		
	}
}