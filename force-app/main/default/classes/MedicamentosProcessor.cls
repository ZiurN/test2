public class MedicamentosProcessor implements IMasterBuilder  {
	
	public Boolean hasNext = false;
	public Datetime runTime;
	public Datetime lastUpdateForMedicamento;
	public Integer pageSize;
	public Integer currentPage;
	public Integer lastPage;
	public Boolean errorWs = false;

	public MedicamentosProcessor(Integer pageSize, Datetime runTime) {
		this(pageSize, 1, 1, runTime, Datetime.now());
	}

	public MedicamentosProcessor(Integer pageSize, Datetime runTime, Datetime lastUpdateForMedicamento) {
		this(pageSize, 1, 1, runTime, lastUpdateForMedicamento);
	}

	public MedicamentosProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime) {
		this(pageSize, currentPage, lastPage, runTime, Datetime.now());
	}

	public MedicamentosProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime, Datetime lastUpdateForMedicamento) {
		this.pageSize = pageSize;
		this.currentPage = currentPage;
		this.lastPage = lastPage;
		this.runTime = runTime;
		this.lastUpdateForMedicamento = lastUpdateForMedicamento;
	}

	public List<WSBatchMedicamentosResp.Data> callWebService() {
		List<WSBatchMedicamentosResp.Data> wsData = new List<WSBatchMedicamentosResp.Data>();
		WSBatchMedicamentos.Response resp;

		if (currentPage <= lastPage) {
			String fecha = runTime.format('yyyy-MM-dd');
			resp = WSBatchMedicamentos.getBatchMedicamentos(fecha, this.pageSize, this.currentPage);
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
		List<Medicamento__c> medicamentos = new List<Medicamento__c>();
		Set<Monodroga__c> setMonodrogas = new Set<Monodroga__c>();
		List<String> externalIds = new List<String>();

		for(Object resp : wsResponses) {
			WSBatchMedicamentosResp.Data medicamentoWS = (WSBatchMedicamentosResp.Data) resp;
			Medicamento__c medicamento = new Medicamento__c();
            
			
			medicamento.Codigo_medicamento__c = medicamentoWS.codigo;
			medicamento.Accion_Terapeutica__c = medicamentoWS.accion_terapeutica != null 
													? Integer.valueOf(medicamentoWS.accion_terapeutica) : null;
			medicamento.Nombre_de_Producto__c = medicamentoWS.nombre_producto;
            medicamento.Nombre_de_Presentacion__c = medicamentoWS.nombre_presentacion;
			medicamento.Grupo__c = medicamentoWS.grupo;
			medicamento.Nombre_de_Grupo__c = medicamentoWS.nombre_grupo; 
			medicamento.Troquel__c = medicamentoWS.troquel;
			medicamento.Codigo_de_Barras__c = medicamentoWS.codigo_barras;
			medicamento.Codigo_Externo1__c = medicamentoWS.codigo_externo_1;
			medicamento.Codigo_Externo2__c = medicamentoWS.codigo_externo_2;
			medicamento.Codigo_Externo3__c = medicamentoWS.codigo_externo_3;
			medicamento.Codigo_Laboratorio__c = medicamentoWS.medlab_codigo;
			medicamento.Descripcion__c = medicamentoWS.descripcion;
			medicamento.Descripcion_Laboratorio__c = medicamentoWS.nombre_lab;
			medicamento.Tipo_Unidad__c = medicamentoWS.nombre_tipouni;
			medicamento.Descripcion_Via__c = medicamentoWS.descrip_via;
			medicamento.Edad_Maxima__c = medicamentoWS.edad_maxima != null 
											? Integer.valueOf(medicamentoWS.edad_maxima) : null;
			medicamento.Edad_Minima__c = medicamentoWS.edad_minima != null
											? Integer.valueOf(medicamentoWS.edad_minima) : null;
			medicamento.Estado_Informado__c = medicamentoWS.estado_informado;
			medicamento.Estado_Presentacion__c = medicamentoWS.estado_presentacion;
			medicamento.Estado_Vigencia__c = medicamentoWS.estado_vigencia;
			medicamento.Excluye_Vademecum__c = medicamentoWS.excluye_vademecum;
			medicamento.Fecha_Activacion__c = medicamentoWS.fecha_activacion != null ? Date.valueOf(medicamento.Fecha_Activacion__c) : null;
			medicamento.Fecha_Baja__c = medicamentoWS.fecha_baja != null ? Date.valueOf(medicamento.Fecha_Baja__c) : null;
			medicamento.Fecha_Estado__c = medicamentoWS.fecha_estado != null ? Date.valueOf(medicamento.Fecha_Estado__c) : null;
			medicamento.Descripcion_Forma__c = medicamentoWS.nombre_forma;
			medicamento.Forma__c = medicamentoWS.forma != null ? Integer.valueOf(medicamentoWS.forma) : null;
			medicamento.Grupo_Terapeutico__c = medicamentoWS.grupo_terapeutico;
			medicamento.Maxima_Unidades__c = medicamentoWS.max_unidades;
			medicamento.Medicamento_Bonificado__c = medicamentoWS.med_bonificado;
			medicamento.Nacional__c = medicamentoWS.nacional;
			medicamento.Tipo_Unidad__c = medicamentoWS.tipo_uni;
			medicamento.Observaciones__c = medicamentoWS.observaciones;
			medicamento.PMI_Hijo__c = medicamentoWS.pmi_hijo == 'V';
			medicamento.PMI_Madre__c = medicamentoWS.pmi_madre == 'V';
			medicamento.Potencia__c = medicamentoWS.potencia;
			medicamento.Precio_Referencia__c = medicamentoWS.precio_referencia != null 
												? Decimal.valueOf(medicamentoWS.precio_referencia) : null;
			medicamento.Psicofarmaco__c = medicamentoWS.psicofarmaco == 'V';
			medicamento.Referencia2__c = medicamentoWS.referencia_externa_2;
			medicamento.Referencia3__c = medicamentoWS.referencia_externa_3;
			medicamento.Res_310__c = medicamentoWS.resol_310;
			medicamento.Sexo_Permitido__c = medicamentoWS.sexo_permitido;
			medicamento.UnidDivisibles__c = medicamentoWS.unidades_divisibles;
			medicamento.Unidad__c = medicamentoWS.unidad;
			medicamento.Venta_Libre__c = medicamentoWS.venta_libre == 'V';
			medicamento.Estupefaciente__c = medicamentoWS.estupefaciente == 'V';
			medicamento.Tipo_de_Cobertura__c = medicamentoWS.tipo_cober;
			medicamento.Descripcion_Accion_Terapeutica__c = medicamentoWS.medat_nombre;
			medicamento.Tamanio__c = medicamentoWS.tamano != null ? Integer.valueOf(medicamentoWS.tamano) : null;
			medicamento.Descripcion_Tamao__c = medicamentoWS.nombre_tam;
			medicamento.Descripcion_Unidad__c = medicamentoWS.nombre_unidad;
			medicamento.Descripcion_Monodroga__c = medicamentoWS.nombre_monodroga;
			medicamento.UDivisin__c = medicamentoWS.unidades_division; 

			if(medicamentoWS.monodroga != null) {
				medicamento.Monodroga__r = new Monodroga__c(Codigo_de_monodroga__c = medicamentoWS.monodroga);
				Monodroga__c monodroga = new Monodroga__c(Codigo_de_monodroga__c = medicamentoWS.monodroga);
				monodroga.Name = medicamentoWS.nombre_monodroga;

				setMonodrogas.add(monodroga);
			}

			
			medicamentos.add(medicamento);
			externalIds.add(medicamentoWS.codigo);
            
            
		}
		List<Monodroga__c> monodrogas = new List<Monodroga__c>(setMonodrogas);
		Database.UpsertResult[] resultsMonodrogas = Database.upsert(
			monodrogas, Monodroga__c.Fields.Codigo_de_monodroga__c, false
		);
		System.debug('****resultsMonodrogas: ' + resultsMonodrogas);
		Database.UpsertResult[] results = Database.upsert(
			medicamentos, Medicamento__c.Codigo_medicamento__c, false
		);
		System.debug('****results* ' + results);
		//EmailUtils.sendErrorMail(results, null, null, externalIds, 'Medicamentos ' + (currentPage - 1) + ' pagina');

		Utils.insertBatchLogs(results, null, null, externalIds, 'Medicamentos');

	}

	public void updateDate() {

		if (!hasNext) {
			if(!errorWs) {
				MasterConfigs__c lastUpdate = MasterConfigs__c.getOrgDefaults();
				lastUpdate.Medicamentos__c = lastUpdateForMedicamento;
				upsert lastUpdate;
			}
		} else {
			MedicamentosProcessor nextProcessor = new MedicamentosProcessor(pageSize, currentPage, lastPage, runTime);
			Database.executeBatch(new MasterBatch(nextProcessor));
		}
	}

	//private Date parseFecha(String fechaStr) {
		//List<String> fechaList = fechaStr.split('-');
		//return date.newInstance(
				//integer.valueOf(fechaList[0]),
				//integer.valueOf(fechaList[1]),
				//integer.valueOf(fechaList[2]));
	//}
}