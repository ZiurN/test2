public class AccountEmpresaProcessor implements IMasterBuilder {

	public Boolean hasNext = false;
	public Datetime runTime;
	public Datetime lastUpdateForEmpresas;
	public Integer pageSize;
	public Integer currentPage;
	public Integer lastPage;
	public Boolean errorWs = false;

	public AccountEmpresaProcessor(Integer pageSize, Datetime runTime) {
		this(pageSize, 1, 1, runTime, Datetime.now());
	}

	public AccountEmpresaProcessor(Integer pageSize, Datetime runTime, Datetime lastUpdateForAsociado) {
		this(pageSize, 1, 1, runTime, lastUpdateForAsociado);
	}

	public AccountEmpresaProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime) {
		this(pageSize, currentPage, lastPage, runTime, Datetime.now());
	}

	public AccountEmpresaProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime, Datetime lastUpdateForEmpresas) {
		this.pageSize = pageSize;
		this.currentPage = currentPage;
		this.lastPage = lastPage;
		this.runTime = runTime;
		this.lastUpdateForEmpresas = lastUpdateForEmpresas;
	}

	public List<WSBatchEmpresaResp.Data> callWebService() {
		List<WSBatchEmpresaResp.Data> wsData = new List<WSBatchEmpresaResp.Data>();
		WSBatchEmpresa.Response result;

		if (currentPage <= lastPage) {
			String fecha = runTime.format('yyyy-MM-dd');
			result = WSBatchEmpresa.getBatchEmpresa(fecha, this.pageSize, this.currentPage);
		}

		if(!result.hasError) {
			hasNext = result.empresa.links.next != null;
			currentPage = result.empresa.meta.current_page + 1;
			lastPage = result.empresa.meta.last_page;
			//wsData.addAll(result.empresa);
			wsData = result.empresa.data;
		} else {
			this.errorWs = true;
		}

		return wsData;
	}

	public void processResponse(List<Object> wsResponses) {

		List<Account> accountList = new List<Account>();
		List<String> externarlIds = new List<String>();
		Set<Agrupacion__c> agrupacionSet = new Set<Agrupacion__c>();
		List<Cuenta_Agrupacion__c> cuentaAgrupacionList = new List<Cuenta_Agrupacion__c>();
		//Set<Account> agenciasSet = new Set<Account>();

		for(Object res : wsResponses) {
			WSBatchEmpresaResp.Data empresa = (WSBatchEmpresaResp.Data) res;

			Account acc = new Account();
			acc.RecordTypeId = XappiaHelper.getRecordType('Account', 'Empresa').Id;
			acc.Name = empresa.descripcion_empresa;
			acc.Codigo_de_empresa__c = empresa.codigo_empresa;
			acc.Canjes__c = empresa.canje == 'F' ? false : true;
			acc.Porcentaje_de_Limite_de_edad__c = empresa.porcentaje_limite_edad != null ? Decimal.valueOf(empresa.porcentaje_limite_edad) : null;
			acc.Porcentaje_de_canje__c = empresa.porcentaje_canje != null ? Decimal.valueOf(empresa.porcentaje_canje) : null;
			acc.Importe_de_canje__c = empresa.importe_canje != null ? Decimal.valueOf(empresa.importe_canje) : null;
			acc.Afiliados_sujetos_de_facturacion__c = empresa.afiliados_sujetos_facturacion == 'F' ? false : true;
			acc.Identificacion_de_afiliados__c = empresa.identificacion_afiliados;
			acc.Grupos__c = empresa.grupos != null ? Decimal.valueOf(empresa.grupos) : null;
			acc.Motivo_alta_masiva_afiliado__c = empresa.mot_sol_alta_masiva;
			acc.Sujeto_facturacion__c = empresa.es_sujeto_facturacion == 'F' ? false : true;
			acc.Estado__c = empresa.estado_empresa;
			acc.CUIT__c = empresa.cuit;
			acc.Codigo_grupo_empresarial__c= empresa.codigo_grupo_empresarial != null ? Decimal.valueOf(empresa.codigo_grupo_empresarial) : null ;
			acc.Observaciones__c = empresa.observaciones;
			acc.Tipo_de_baja__c = empresa.codigo_tipo_baja;
			acc.Motivo_baja_masiva_de_afiliado__c = empresa.mot_sol_baja_masiva;

			if(empresa.agencia != null) {
				//Account agencia = new Account(Name = empresa.agencia,
						//Codigo_de_delegacion__c = empresa.agencia.substringBefore('_'),
						//Type = 'Agencia');
				//agencia.RecordTypeId = XappiaHelper.getRecordType('Account', 'Delegacion').Id;
				acc.Delegacion__r = new Account(Codigo_de_delegacion__c = empresa.agencia.substringBefore('_'));
				//agenciasSet.add(agencia);
			}

			if(empresa.codigo_agrupacion != null && empresa.descripcion_agrupacion != null) {
				 agrupacionSet.add(new Agrupacion__c(Codigo__c = empresa.codigo_agrupacion, Nombre__c = empresa.descripcion_agrupacion));
				 Cuenta_Agrupacion__c junction = new Cuenta_Agrupacion__c();
				 junction.Id_Externo__c = empresa.codigo_empresa + '-' + empresa.codigo_agrupacion;
				 junction.Cuenta__r = new Account(Codigo_de_empresa__c = empresa.codigo_empresa);
				 junction.Agrupacion__r = new Agrupacion__c(Codigo__c = empresa.codigo_agrupacion);
				 cuentaAgrupacionList.add(junction);
			}
			if(empresa.codigo_agrupacion1 != null && empresa.descripcion_agrupacion1 != null) {
				 agrupacionSet.add(new Agrupacion__c(Codigo__c = empresa.codigo_agrupacion1, Nombre__c = empresa.descripcion_agrupacion1));
				 Cuenta_Agrupacion__c junction = new Cuenta_Agrupacion__c();
				 junction.Id_Externo__c = empresa.codigo_empresa + '-' + empresa.codigo_agrupacion1;
				 junction.Cuenta__r = new Account(Codigo_de_empresa__c = empresa.codigo_empresa);
				 junction.Agrupacion__r = new Agrupacion__c(Codigo__c = empresa.codigo_agrupacion1);
				 cuentaAgrupacionList.add(junction);
			}
			if(empresa.codigo_agrupacion2 != null && empresa.descripcion_agrupacion2 != null) {
				 agrupacionSet.add(new Agrupacion__c(Codigo__c = empresa.codigo_agrupacion2, Nombre__c = empresa.descripcion_agrupacion2));
				 Cuenta_Agrupacion__c junction = new Cuenta_Agrupacion__c();
				 junction.Id_Externo__c = empresa.codigo_empresa + '-' + empresa.codigo_agrupacion2;
				 junction.Cuenta__r = new Account(Codigo_de_empresa__c = empresa.codigo_empresa);
				 junction.Agrupacion__r = new Agrupacion__c(Codigo__c = empresa.codigo_agrupacion2);
				 cuentaAgrupacionList.add(junction);
			}
			if(empresa.codigo_agrupacion3 != null && empresa.descripcion_agrupacion3 != null) {
				 agrupacionSet.add(new Agrupacion__c(Codigo__c = empresa.codigo_agrupacion3, Nombre__c = empresa.descripcion_agrupacion3));
				 Cuenta_Agrupacion__c junction = new Cuenta_Agrupacion__c();
				 junction.Id_Externo__c = empresa.codigo_empresa + '-' + empresa.codigo_agrupacion3;
				 junction.Cuenta__r = new Account(Codigo_de_empresa__c = empresa.codigo_empresa);
				 junction.Agrupacion__r = new Agrupacion__c(Codigo__c = empresa.codigo_agrupacion3);
				 cuentaAgrupacionList.add(junction);
			}
			if(empresa.codigo_agrupacion4 != null && empresa.descripcion_agrupacion4 != null) {
				 agrupacionSet.add(new Agrupacion__c(Codigo__c = empresa.codigo_agrupacion4, Nombre__c = empresa.descripcion_agrupacion4));
				 Cuenta_Agrupacion__c junction = new Cuenta_Agrupacion__c();
				 junction.Id_Externo__c = empresa.codigo_empresa + '-' + empresa.codigo_agrupacion4;
				 junction.Cuenta__r = new Account(Codigo_de_empresa__c = empresa.codigo_empresa);
				 junction.Agrupacion__r = new Agrupacion__c(Codigo__c = empresa.codigo_agrupacion4);
				 cuentaAgrupacionList.add(junction);
			}

			accountList.add(acc);
			externarlIds.add(empresa.codigo_empresa);
		}

		List<Agrupacion__c> agrupacionList = new List<Agrupacion__c>(agrupacionSet);

		Database.UpsertResult[] resultsAgrup = Database.upsert(
			agrupacionList, Agrupacion__c.Fields.Codigo__c, false
		);
		Database.UpsertResult[] results = Database.upsert(
			accountList, Account.Fields.Codigo_de_empresa__c,false
		);
		Database.UpsertResult[] resultsCtaAgrup = Database.upsert(
			cuentaAgrupacionList, Cuenta_Agrupacion__c.Fields.Id_Externo__c, false
		);
		System.debug('*****resultsAgrup ' + resultsAgrup); 
		System.debug('*****results ' + results); 
		System.debug('*****resultsCtaAgrup ' + resultsCtaAgrup); 
		
		//EmailUtils.sendErrorMail(resultsAgrup, null, null, null, 'Empresas(Agrupaciones)');
		//EmailUtils.sendErrorMail(results, null, null, externarlIds, 'Empresas');
		//EmailUtils.sendErrorMail(resultsCtaAgrup, null, null, null, 'Empresas(JunctionCtaAgrup)');

		Utils.insertBatchLogs(results, null, null, externarlIds, 'Empresas');
	}

	public void updateDate() {

		if (!hasNext) {
			SucursalesEmpresaProcessor nextProcessor = new SucursalesEmpresaProcessor(pageSize, runTime);
			Database.executeBatch(new MasterBatch(nextProcessor));
			
			if(!errorWs) {
				MasterConfigs__c lastUpdate = MasterConfigs__c.getOrgDefaults();
				lastUpdate.Empresas__c = lastUpdateForEmpresas;
				upsert lastUpdate;
			}

		} else {

			AccountEmpresaProcessor nextProcessor = new AccountEmpresaProcessor(pageSize, currentPage, lastPage, runTime);
			Database.executeBatch(new MasterBatch(nextProcessor));
		}
	}
}