public class AccountEfectorProcessor implements IMasterBuilder {

	public Boolean hasNext = false;
	public String next;
	public String followUpEndpoint;
	public Datetime runTime;
	public Datetime lastUpdateForEfectores;
	public Integer pageSize;
	public Integer currentPage;
	public Integer lastPage;
	public Boolean errorWs = false;

	public List<String> efectoresCod;

	public AccountEfectorProcessor(Integer pageSize, Datetime runTime) {
		this(pageSize, 1, 1, runTime, Datetime.now(),new List<String>());
	}

	public AccountEfectorProcessor(Integer pageSize, Datetime runTime, Datetime lastUpdateForAsociado) {
		this(pageSize, 1, 1, runTime, lastUpdateForAsociado,new List<String>());
	}

	public AccountEfectorProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime,List<String> efectores) {
		this(pageSize, currentPage, lastPage, runTime, Datetime.now(),efectores);
	}

	public AccountEfectorProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime, Datetime lastUpdateForEfectores, List<String> efectores) {
		this.pageSize = pageSize;
		this.currentPage = currentPage;
		this.lastPage = lastPage;
		this.runTime = runTime;
		this.lastUpdateForEfectores = lastUpdateForEfectores;
		this.efectoresCod = efectores;
	}

	public List<WSBatchEfectorResp.Data> callWebService() {
		List<WSBatchEfectorResp.Data> wsData = new List<WSBatchEfectorResp.Data>();
		WSBatchEfector.Response result;


		if (currentPage <= lastPage) {
			String fecha = runTime.format('yyyy-MM-dd');
			result = WSBatchEfector.getBatchEfector(fecha, this.pageSize, this.currentPage);
		}

		System.debug(result);
		if(!result.hasError) {
			hasNext = result.efector.links.next != null;
			currentPage = result.efector.meta.current_page +1;
			lastPage = result.efector.meta.last_page;
		
			wsData = result.efector.data;
		} else {
			this.errorWs = true;
		}
		System.debug(wsData);
		return wsData;
	}

	public void processResponse(List<Object> wsResponses) {
		List<Account> accountList = new List<Account>();
		List<String> efectores = new List<String>();
		System.debug(wsResponses);
		for(Object res : wsResponses) {
			
			WSBatchEfectorResp.Data efector = (WSBatchEfectorResp.Data) res;
			//String matricula = efector.pcia_mat != null ? 'MP ' + efector.pcia_mat + ' ' + efector.matricula : 'MN ' + efector.matricula;
			System.debug('****efector ' + efector);
			
			Account acc = new Account();
			acc.RecordTypeId = XappiaHelper.getRecordType('Account', 'Efector').Id;
			acc.Name = efector.nombre;
			acc.Es_Profesional__c = efector.es_profesional == 'V' ? true : false;
			acc.Codigo_de_efector__c = efector.codigo;
			acc.Clase_efector__c = efector.clase;
			acc.Es_Prestador__c = efector.es_prestador == 'V' ? true : false;
			acc.Categoria_codigo__c = efector.categoria;
			acc.Egresado__c = efector.egresado;
			acc.Fecha_Titulo__c = efector.fecha_titulo != null ? Date.valueOf(efector.fecha_titulo) : null;
			acc.Estado_civil__c = efector.estado_civil;
			acc.Fecha_nacimiento_efector__c = efector.fecha_nacimiento != null ? Date.valueOf(efector.fecha_nacimiento) : null;
			acc.Observaciones__c = efector.observaciones;
			acc.Estado__c = efector.estado;
			acc.Fecha_vigencia__c = efector.fecha_vigencia != null ? Date.valueOf(efector.fecha_vigencia) : null;
			acc.CUIT__c = efector.cuit;
			acc.Observaciones_prestador__c = efector.obs_prestador;
			acc.Estado_Prestador__c = acc.Estado_Prestador__c;
			acc.Fecha_vigencia_prestador__c = efector.fecha_vigencia_prestador != null ? Date.valueOf(efector.fecha_vigencia_prestador) : null;
			acc.Fecha_Alta__c = efector.fecha_alta != null ? Date.valueOf(efector.fecha_alta) : null;
			acc.Fecha_baja_prestador__c = efector.fecha_baja != null ? Date.valueOf(efector.fecha_baja) : null;
			acc.Fecha_alta_prestador__c = efector.fecha_alta != null ? Date.valueOf(efector.fecha_alta) : null;
			acc.Motivo_Baja_Prestador__c = efector.motivo_baja;
			acc.Correo_electronico__c = Utils.isAValidEmail(efector.mail) ? efector.mail : null;

			
			if(efector.matricula_1 != null){
				System.debug('****name ' + efector.nombre );
				if(efector.matricula_1.startsWith('MP')){
					List<String> listPartes = efector.matricula_1.split(' ');
					acc.Matricula_provincial__c = listPartes[2] + ' ' + listPartes[0] + ' ' + listPartes[1];
				}else if(efector.matricula_1 != null){
					List<String> listPartes = efector.matricula_1.split(' ');
					acc.Matricula_nacional__c = listPartes[2] + ' ' + listPartes[0];
				}
			}

			if(efector.matricula_2 != null){
				if(efector.matricula_2.startsWith('MP') && acc.Matricula_provincial__c == null){
					List<String> listPartes = efector.matricula_2.split(' ');
					acc.Matricula_provincial__c = listPartes[2] + ' ' + listPartes[0] + ' ' + listPartes[1];
				}else if(acc.Matricula_provincial__c != null && acc.Matricula_provincial2__c == null && efector.matricula_2.startsWith('MP')){
					List<String> listPartes = efector.matricula_2.split(' ');
					acc.Matricula_provincial2__c = listPartes[2] + ' ' + listPartes[0] + ' ' + listPartes[1];
				}else if(efector.matricula_2.startsWith('MN')){
					List<String> listPartes = efector.matricula_2.split(' ');
					acc.Matricula_nacional__c = listPartes[2] + ' ' + listPartes[0];
				}
			}

			if(efector.matricula_3 != null){
				if(efector.matricula_3.startsWith('MN')){
					List<String> listPartes = efector.matricula_3.split(' ');
					acc.Matricula_nacional__c = listPartes[2] + ' ' + listPartes[0];
				}else{
					List<String> listPartes = efector.matricula_3.split(' ');
					acc.Matricula_provincial__c = listPartes[2] + ' ' + listPartes[0] + ' ' + listPartes[1];
				}
			}
			accountList.add(acc);
			efectores.add(acc.Codigo_de_efector__c);
		}

		efectoresCod.addAll(efectores);


		Database.UpsertResult[] results = Database.upsert(
				accountList, Account.Fields.Codigo_de_efector__c,false
		);
		System.debug('****resultsEfectores: ' + results);
		//EmailUtils.sendErrorMail(results,null,null, efectores, 'Efectores ' + (currentPage - 1) + ' pagina');

		Utils.insertBatchLogs(results,null,null, efectores, 'Efectores');
	}



	public void updateDate() {


		if (!hasNext) {

			ConsultoriosEfectorProcessor nextProcessor = new ConsultoriosEfectorProcessor(100, runTime);
			Database.executeBatch(new MasterBatch(nextProcessor));
			
			if(!errorWs) {
				MasterConfigs__c lastUpdate = MasterConfigs__c.getOrgDefaults();
				lastUpdate.Efectores__c = lastUpdateForEfectores;
				upsert lastUpdate;
			}

		} else {

			AccountEfectorProcessor nextProcessor = new AccountEfectorProcessor(pageSize, currentPage, lastPage, runTime,efectoresCod);
			Database.executeBatch(new MasterBatch(nextProcessor));
		}
	}


}