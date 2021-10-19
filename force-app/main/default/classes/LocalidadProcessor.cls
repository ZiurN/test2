public class LocalidadProcessor implements IMasterBuilder {

	public Boolean hasNext = false;
	public String next;
	public Datetime runTime;
	public Datetime lastUpdateForLocalidades;

	public Integer pageSize;
	public Integer currentPage;
	public Integer lastPage;

	public LocalidadProcessor(Integer pageSize, Datetime runTime) {
		this(pageSize, 1, 1, runTime, Datetime.now());
	}

	public LocalidadProcessor(Integer pageSize, Integer currentPage, Integer lastPage, Datetime runTime, Datetime lastUpdateForLocalidades) {
		this.pageSize = pageSize;
		this.currentPage = currentPage;
		this.lastPage = lastPage;
		this.runTime = runTime;
		this.lastUpdateForLocalidades = lastUpdateForLocalidades;
	}

	public List<WSLocalidadResp.Data> callWebService() {
		List<WSLocalidadResp.Data> wsData = new List<WSLocalidadResp.Data>();
		WSLocalidad.Response result;
		
		if (currentPage <= lastPage) {
			String fecha = runTime.format('yyyy-MM-dd');
			result = WSLocalidad.getLocalidadPorFechaModificacion(fecha, this.pageSize, this.currentPage);
		}

		if(!result.hasError) {
			hasNext = result.localidad.links.next != null;
			currentPage = result.localidad.meta.current_page +1;
			lastPage = result.localidad.meta.last_page;
		
			wsData = result.localidad.data;
		}
		return wsData;
	}

	public void processResponse(List<Object> wsResponses) {
		List<Localidad__c> localidadToUpdate = new List<Localidad__c>();
		Map<String, String> organizadores = new Map<String, String>();
		List<String> locIds = new List<String>();

		for(Object res : wsResponses) {
			WSLocalidadResp.Data localidad = (WSLocalidadResp.Data) res;

			Localidad__c loc = new Localidad__c();
			loc.Codigo_de_Provincia__c = localidad.pcia_codigo;
			loc.Codigo_Postal__c = localidad.codigo_postal;
			loc.Loc_Id__c = localidad.loc_loc_id;
			loc.Nombre_de_Localidad__c = localidad.localidad;
			loc.ZG_Codigo__c = localidad.zn_zona;
            loc.Region__c = localidad.or_zona_nombre;
			loc.CIU__c = localidad.ciu_codigo;

			organizadores.put(loc.Loc_Id__c, localidad.organizador);
			locIds.add(localidad.loc_loc_id);
			localidadToUpdate.add(loc);
		}

		List<User> users = [
			SELECT Id, CommunityNickname, User_ID_en_SS__c 
			FROM User 
			WHERE CommunityNickname IN :organizadores.values()
		];

		for(Localidad__c loc : localidadToUpdate){
			for(User user : users){
				if(user.User_ID_en_SS__c == organizadores.get(loc.Loc_Id__c)){
					loc.Organizador_lookup__c = user.Id;
				}
			}
		}
		
		Database.UpsertResult[] results = Database.upsert(localidadToUpdate, Localidad__c.Fields.Loc_Id__c, false);
		System.debug('****results: ' + results);

		//EmailUtils.sendErrorMail(results, null, null, locIds, 'Localidades');

		Utils.insertBatchLogs(results, null, null, locIds, 'Localidades');
	}

	public void updateDate() {

		if (!hasNext) {
			MasterConfigs__c lastUpdate = MasterConfigs__c.getOrgDefaults();
			lastUpdate.Localidades__c = lastUpdateForLocalidades;
			upsert lastUpdate;
		} else {
			LocalidadProcessor nextProcessor = new LocalidadProcessor(pageSize, currentPage, lastPage, runTime, Datetime.now());
			Database.executeBatch(new MasterBatch(nextProcessor));
		}

	}


}