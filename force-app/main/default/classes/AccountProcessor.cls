public without sharing class AccountProcessor implements IMasterBuilder {
	public Boolean hasNext = false;
	public Datetime runTime;
	public Datetime lastUpdateForAsociado;
	public Integer pageSize;
	public Integer currentPage;
	public Integer lastPage;
	public Boolean errorWs = false;
	public AccountProcessor(Integer pageSize, Datetime runTime) {
		this(pageSize, 1, 1, runTime, Datetime.now());
	}
	public AccountProcessor(Integer pageSize, Datetime runTime, Datetime lastUpdateForAsociado) {
		this(pageSize, 1, 1, runTime, lastUpdateForAsociado);
	}
	public AccountProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime) {
		this(pageSize, currentPage, lastPage, runTime, Datetime.now());
	}
	public AccountProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime, Datetime lastUpdateForAsociado) {
		this.pageSize = pageSize;
		this.currentPage = currentPage;
		this.lastPage = lastPage;
		this.runTime = runTime;
		this.lastUpdateForAsociado = lastUpdateForAsociado;
	}
	public List<WSBatchAsociadoResp.Data> callWebService() {
		List<WSBatchAsociadoResp.Data> wsData = new List<WSBatchAsociadoResp.Data>();
		WSBatchAsociado.Response result;
		String fecha = runTime.format('yyyy-MM-dd');
		result = WSBatchAsociado.getBatchAsociado(fecha, this.pageSize, this.currentPage);
		if(!result.hasError) {
			hasNext = result.asociado.links.next != null;
			currentPage = result.asociado.meta.current_page + 1;
			wsData.addAll(result.asociado.data);
		} else {
			System.debug('****Hubo un error en el ws****');
			System.debug('****' + result.message + '****');
			this.errorWs = true;
		}
		return wsData;
	}
	public void processResponse(List<Object> wsResponses) {
		List<String> afiIdTitulares = new List<String>();
		List<String> afiIdFliares = new List<String>();
		List<String> afiIdMenores = new List<String>();
		List<Account> accountList = new List<Account>();
		List<Account> familiares = new List<Account>();
		List<Account> menores = new List<Account>();
		Map<String, Account> titularesRelacionadosAFamiliares = new Map<String, Account>();
		Set<Agrupacion__c> agrupacionSet = new Set<Agrupacion__c>();
		List<Cuenta_Agrupacion__c> cuentaAgrupacionList = new List<Cuenta_Agrupacion__c>();
		for(Object res : wsResponses) {
			WSBatchAsociadoResp.Data asociado = (WSBatchAsociadoResp.Data) res;
			Account acc = new Account();
			acc.RecordTypeId = XappiaHelper.getRecordType('Account', 'Cuenta_personal').Id;
			acc.Afi_Id__c = asociado.afi_id;
			acc.Afi_Id_del_Titular__c = asociado.afi_id_tit != null ? Decimal.valueOf(asociado.afi_id_tit) : null;
			acc.Codigo_de_Entidad__c = asociado.entidad;
			acc.Codigo_de_Afiliado__c = asociado.codigo;
			acc.Titular_codigo__c = asociado.titular_codigo;
			acc.LastName = asociado.nombres;
			acc.FirstName = asociado.apellidos;
			acc.PAM__c = asociado.pam == 'V'? true : false; //F o V
			acc.Type = asociado.tipo_afiliado; //familiar o titutar
			acc.Parentesco__c = asociado.parentesco;
			acc.Tiene_alertas__c = asociado.tiene_alertas == 'F' ? false : true; //F no vi ningun V
			acc.Estado__c = asociado.estado;
			acc.Plan_Codigo__c = asociado.plan_codigo;
			acc.Plan_Nombre__c = asociado.plan_nombre;
			acc.Modelo_Plan_Codigo__c = asociado.modelo_plan_codigo;
			acc.Modelo_Plan_Nombre__c = asociado.modelo_plan_nombre;
			acc.Agencia_codigo__c = asociado.agencia_codigo != null ? Decimal.valueOf(asociado.agencia_codigo) : null;
			acc.Categoria_codigo__c = asociado.categoria_codigo;
			acc.Categoria_Nombre__c = asociado.categoria_nombre;
			acc.Empresa_codigo__c = asociado.empresa_codigo != null ? Decimal.valueOf(asociado.empresa_codigo) : null;
			acc.Empresa_sucursal__c = asociado.empresa_sucursal != null ? Decimal.valueOf(asociado.empresa_sucursal) : null;
			acc.Empresa_nombre__c = asociado.empresa_nombre;
			acc.Empresa_sucursal_nombre__c = asociado.empresa_sucursal_nombre;
			acc.Afiliacion__c = asociado.afiliacion;
			acc.Aporta__c = asociado.aporta == 'Verdadero' ? true : false; //Verdadero o Falso
			acc.Obra_social_codigo__c = asociado.obra_social_codigo != null ? Decimal.valueOf(asociado.obra_social_codigo)
										: null;
			acc.Obra_social_nombre__c = asociado.obra_social_nombre;
			acc.Obra_social_ant_codigo__c = asociado.obra_social_ant_codigo != null
											? Decimal.valueOf(asociado.obra_social_ant_codigo) : null;
			acc.Obra_social_ant_nombre__c = asociado.obra_social_ant_nombre;
			acc.Tipo_de_documento__c = asociado.tipo_documento;
			acc.Numero_de_documento__c = asociado.numero_documento;
			acc.Sexo__c = asociado.sexo;
			acc.PersonBirthdate = asociado.fecha_nacimiento != null ? Date.valueOf(asociado.fecha_nacimiento) : null;
			acc.Estado_civil__c = asociado.estado_civil;
			acc.Gentilicio__c = asociado.gentilicio;
			acc.Actividad_codigo__c = asociado.actividad_codigo;
			acc.Actividad_nombre__c = asociado.actividad_nombre;
			acc.Titular_apellidos__c = asociado.titular_apellidos;
			acc.Titular_nombres__c = asociado.titular_nombres;
			acc.Antiguedad_reconocida__c = asociado.antiguedad_reconocida != null
											? Decimal.valueOf(asociado.antiguedad_reconocida) : null;
			acc.Ultima_alta__c = asociado.ultima_alta != null ? Date.valueOf(asociado.ultima_alta) : null;
			acc.Fecha_alta_Administrativa__c = asociado.fecha_alta_administrativa != null
												? Date.valueOf(asociado.fecha_alta_administrativa) : null;
			acc.Fecha_Alta__c = asociado.fecha_alta != null ? Date.valueOf(asociado.fecha_alta) : null;
			acc.Fecha_vigencia__c = asociado.fecha_vigencia != null ? Date.valueOf(asociado.fecha_vigencia) : null;
			acc.CUIT__c = asociado.cuit;
			acc.Sujeto_facturacion__c = asociado.sujeto_facturacion == 'Verdadero' ? true : false; //Verdadero o Falso
			acc.Adherente__c = asociado.adherente == 'Falso' ? false : true; //Falso no vi Verdadero
			acc.Tipo_de_baja_codigo__c = asociado.tipo_baja_codigo;
			acc.Tipo_de_baja_nombre__c = asociado.tipo_baja_nombre;
			acc.Motivo_de_baja__c = asociado.motivo_de_baja;
			acc.Fecha_de_baja__c = String.isNotBlank(asociado.fecha_baja) ? Datetime.valueOf(asociado.fecha_baja) : null;
			acc.Monto_excedente__c = asociado.excedente != null ? Decimal.valueOf(asociado.excedente) : null;
			acc.Codigo_de_Entidad__c = asociado.entidad_codigo;
			acc.Provincia_lista__c = asociado.provincia;
			acc.Fecha_permanencia_desde__c = String.isEmpty(asociado.permanencia_desde) ? null
											: Date.valueOf(asociado.permanencia_desde);
			acc.Fecha_permanencia_hasta__c = String.isEmpty(asociado.permanencia_hasta) ? null
											: Date.valueOf(asociado.permanencia_hasta);
			acc.Envio_de_recibo__c = asociado.adhiere_fe == 'S' ? 'Factura online'
									: asociado.adhiere_fe == 'N' ? 'Factura papel'
									: null;
			acc.PersonEmail = Utils.isAValidEmail(asociado.mail) ? asociado.mail : null;
			if(asociado.tipo_afiliado == 'TIT') {
				acc.Titular__c = null;
			}
			if(asociado.estado != 'B' && String.isNotBlank(asociado.localidad)) {
				acc.Localidad_new__r = new Localidad__c(Loc_Id__c = asociado.localidad);
			}
			if(String.isNotBlank(asociado.agencia_codigo)) {
				acc.Delegacion__r = new Account(Codigo_de_delegacion__c = asociado.agencia_codigo);
			}
			if(String.isNotBlank(asociado.empresa_codigo)) {
				acc.Empresa__r = new Account(Codigo_de_empresa__c = asociado.empresa_codigo);
			}
			if(String.isNotBlank(asociado.obra_social_codigo)) {
				acc.Obra_social__r = new Account(Codigo_de_obra_social__c = asociado.obra_social_codigo);
			}
			if(String.isNotBlank(asociado.afi_id)){
				if(asociado.agrupacion_codigo != null && asociado.agrupacion_nombre != null) {
					if(XappiaHelper.getPicklistFieldValues('Account','Segmento_de_grupo_familiar__c').contains(asociado.agrupacion_codigo)){
						acc.Segmento_de_grupo_familiar__c = asociado.agrupacion_codigo;
					}
					Agrupacion__c agrupacion = new Agrupacion__c(Codigo__c = asociado.agrupacion_codigo, Nombre__c = asociado.agrupacion_nombre);
					agrupacionSet.add(agrupacion);
					Cuenta_Agrupacion__c junction = new Cuenta_Agrupacion__c();
					junction.Id_Externo__c = asociado.afi_id + '_' + asociado.agrupacion_codigo;
					junction.Cuenta__r = new Account(Afi_Id__c = asociado.afi_id);
					junction.Agrupacion__r = new Agrupacion__c(Codigo__c = asociado.agrupacion_codigo);
					cuentaAgrupacionList.add(junction);
				}
				if(asociado.agrupacion1_codigo != null && asociado.agrupacion1_nombre != null) {
					Agrupacion__c agrupacion = new Agrupacion__c(Codigo__c = asociado.agrupacion1_codigo, Nombre__c = asociado.agrupacion1_nombre);
					agrupacionSet.add(agrupacion);
					Cuenta_Agrupacion__c junction = new Cuenta_Agrupacion__c();
					junction.Id_Externo__c = asociado.afi_id + '_' + asociado.agrupacion1_codigo;
					junction.Cuenta__r = new Account(Afi_Id__c = asociado.afi_id);
					junction.Agrupacion__r = new Agrupacion__c(Codigo__c = asociado.agrupacion1_codigo);
					cuentaAgrupacionList.add(junction);
				}
				if(asociado.agrupacion2_codigo != null && asociado.agrupacion2_nombre != null) {
					Agrupacion__c agrupacion = new Agrupacion__c(Codigo__c = asociado.agrupacion2_codigo, Nombre__c = asociado.agrupacion2_nombre);
					agrupacionSet.add(agrupacion);
					Cuenta_Agrupacion__c junction = new Cuenta_Agrupacion__c();
					junction.Id_Externo__c = asociado.afi_id + '_' + asociado.agrupacion2_codigo;
					junction.Cuenta__r = new Account(Afi_Id__c = asociado.afi_id);
					junction.Agrupacion__r = new Agrupacion__c(Codigo__c = asociado.agrupacion2_codigo);
					cuentaAgrupacionList.add(junction);
				}
				if(asociado.agrupacion3_codigo != null && asociado.agrupacion3_nombre != null) {
					Agrupacion__c agrupacion = new Agrupacion__c(Codigo__c = asociado.agrupacion3_codigo, Nombre__c = asociado.agrupacion3_nombre);
					agrupacionSet.add(agrupacion);
					Cuenta_Agrupacion__c junction = new Cuenta_Agrupacion__c();
					junction.Id_Externo__c = asociado.afi_id + '_' + asociado.agrupacion3_codigo;
					junction.Cuenta__r = new Account(Afi_Id__c = asociado.afi_id);
					junction.Agrupacion__r = new Agrupacion__c(Codigo__c = asociado.agrupacion3_codigo);
					cuentaAgrupacionList.add(junction);
				}
				if(asociado.agrupacion4_codigo != null && asociado.agrupacion4_nombre != null) {
					Agrupacion__c agrupacion = new Agrupacion__c(Codigo__c = asociado.agrupacion4_codigo, Nombre__c = asociado.agrupacion4_nombre);
					agrupacionSet.add(agrupacion);
					Cuenta_Agrupacion__c junction = new Cuenta_Agrupacion__c();
					junction.Id_Externo__c = asociado.afi_id + '_' + asociado.agrupacion4_codigo;
					junction.Cuenta__r = new Account(Afi_Id__c = asociado.afi_id);
					junction.Agrupacion__r = new Agrupacion__c(Codigo__c = asociado.agrupacion4_codigo);
					cuentaAgrupacionList.add(junction);
				}
			}
			if (asociado.afi_id_tit != null) {
				acc.Titular__r = new Account(Afi_Id__c = asociado.afi_id_tit);
				if(asociado.es_menor == 'V') {
					menores.add(acc);
					afiIdMenores.add(asociado.afi_id);
				}
				else {
					familiares.add(acc);
					afiIdFliares.add(asociado.afi_id);
				}
				if(!titularesRelacionadosAFamiliares.keySet().contains(asociado.afi_id_tit)) {
					Account titular = new Account();
					titular.RecordTypeId = XappiaHelper.getRecordType('Account', 'Cuenta_personal').Id;
					titular.Afi_Id__c = asociado.afi_id_tit;
					titular.Codigo_de_Afiliado__c = asociado.titular_codigo;
					titular.LastName = asociado.titular_nombres;
					titular.Type = 'TIT';
					titularesRelacionadosAFamiliares.put(asociado.afi_id_tit, titular);
				}
			} else {
				afiIdTitulares.add(asociado.afi_id);
				accountList.add(acc);
			}
		}
		List<Agrupacion__c> agrupacionList = new List<Agrupacion__c>(agrupacionSet);
		Database.UpsertResult[] resultsAgrup = Database.upsert(
			agrupacionList, Agrupacion__c.Fields.Codigo__c, false
		);
		Database.UpsertResult[] results0 = Database.upsert(
			accountList, Account.Fields.Afi_Id__c, false
		);
		Utils.ResponseFailedUpserts rfuTitulares = Utils.getAccountsWithFailedUpsert(results0, accountList, afiIdTitulares);
		Database.UpsertResult[] results = Database.upsert(
			rfuTitulares.accounts, Account.Fields.Numero_de_documento__c, false
		);
		Database.UpsertResult[] resultsTitularesFamiliares = Database.upsert(
			titularesRelacionadosAFamiliares.values(), Account.Fields.Codigo_de_Afiliado__c, false
		);
		Database.UpsertResult[] resultsFamiliares0 = Database.upsert(
			familiares, Account.Fields.Afi_Id__c, false
		);
		Utils.ResponseFailedUpserts rfuFamiliares = Utils.getAccountsWithFailedUpsert(resultsFamiliares0, familiares, afiIdFliares);
		Database.UpsertResult[] resultsFamiliares = Database.upsert(
			rfuFamiliares.accounts, Account.Fields.Numero_de_documento__c, false
		);
		Database.UpsertResult[] resultsMenores = Database.upsert(
			menores, Account.Fields.Codigo_de_Afiliado__c, false
		);
		Database.UpsertResult[] resultsCtaAgrup = Database.upsert(
			cuentaAgrupacionList, Cuenta_Agrupacion__c.Fields.Id_Externo__c, false
		);
		Utils.insertBatchLogs(results, null, null, rfuTitulares.externalIds, 'Asociados(titulares)');
		Utils.insertBatchLogs(resultsFamiliares, null, null, rfuFamiliares.externalIds, 'Asociados(familiares)');
		Utils.insertBatchLogs(resultsMenores, null, null, afiIdMenores, 'Asociados(menores)');
	}
	public void updateDate() {
		if (!hasNext) {
			if(!errorWs) {
				MasterConfigs__c lastUpdate = MasterConfigs__c.getOrgDefaults();
				lastUpdate.Asociados__c = lastUpdateForAsociado;
				upsert lastUpdate;
			}
			else {
				System.debug('****Hubo un error en el ws****');
			}
		} else {
			AccountProcessor nextProcessor = new AccountProcessor(pageSize, currentPage, lastPage, runTime);
			Database.executeBatch(new MasterBatch(nextProcessor));
		}
	}
}