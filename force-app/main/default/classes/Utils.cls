public without sharing class Utils {
	public static String getTypeAndExtension(String extension) {
		switch on extension {
			when 'png' {
				return 'image/png';
			}
			when 'jpg' {
				return 'image/jpg';
			}
			when 'jpeg' {
				return 'image/jpeg';
			}
			when 'pdf' {
				return 'application/pdf';
			}
			when 'txt' {
				return 'text/plain';
			}
			when 'doc' {
				return 'application/msword';
			}
			when 'xml' {
				return 'application/xml';
			}
			when 'xls' {
				return 'application/vnd.ms-excel';
			}
			when 'csv' {
				return 'text/csv';
			}
			when 'gif' {
				return 'image/gif';
			}
			when 'webp' {
				return 'image/webp';
			}
			when 'docx' {
				return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
			}
			when 'xlsx' {
				return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
			}
			when 'pptx' {
				return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
			}
			when 'zip' {
				return 'application/zip';
			}
		}
		return null;
	}
	public static String translateStateAPToReintegro(String estado) {
		switch on estado {
			when 'CA-----G' {
				return 'CR-----G';
			}
			when 'CA-----A' {
				return 'CR-----A';
			}
			when 'CA-----E' {
				return 'CR-----E';
			}
			when 'CA-----N' {
				return 'CR-----N';
			}
		}
		return null;
	}
	public static String translateStateReintegroToAP(String estado) {
		switch on estado {
			when 'CR-----G' {
				return 'CA-----G';
			}
			when 'CR-----A' {
				return 'CA-----A';
			}
			when 'CR-----E' {
				return 'CA-----E';
			}
			when 'CR-----N' {
				return 'CA-----N';
			}
		}
		return null;
	}
	public static String getEstadoCivilCodFromValue(String valor){
		switch on valor {
			when 'Casado' {
				return 'C';
			}
			when 'Concubinato' {
				return 'N';
			}
			when 'Divorciado' {
				return 'D';
			}
			when 'Separado' {
				return 'P';
			}
			when 'Soltero' {
				return 'S';
			}
			when 'Viudo' {
				return 'V';
			}
		}
		return null;
	}
	public static Boolean perteneceALaDelegacionCorrecta(Case caso, User usuario) {
		Boolean frontUser = usuario.Profile.Name == 'Front';
		List<Region__mdt> regiones = [SELECT Id, Delegaciones__c, DeveloperName FROM Region__mdt];
		List<String> delegacionesBsAsYPampeana = new List<String>();
		List<String> delegacionesAmba = new List<String>();
		List<String> delegacionesBsAsCentro = new List<String>();
		List<String> delegacionesBsAsNorte = new List<String>();
		List<String> delegacionesCordoba = new List<String>();
		List<String> delegacionesLitoral = new List<String>();
		List<String> delegacionesNEA = new List<String>();
		List<String> delegacionesNOA = new List<String>();
		List<String> delegacionesNucleo = new List<String>();
		List<String> delegacionesPatagoniaAnd = new List<String>();
		List<String> delegacionesPatagoniaAtl = new List<String>();
		for(Region__mdt region : regiones) {
			if(region.DeveloperName == 'Bs_As_y_So_Pampeana') {
				delegacionesBsAsYPampeana = region.Delegaciones__c.split(';');
			}
			else if(region.DeveloperName == 'Amba') {
				delegacionesAmba = region.Delegaciones__c.split(';');
			}
			else if(region.DeveloperName == 'Bs_As_Centro') {
				delegacionesBsAsCentro = region.Delegaciones__c.split(';');
			}
			else if(region.DeveloperName == 'Bs_As_Norte') {
				delegacionesBsAsNorte = region.Delegaciones__c.split(';');
			}
			else if(region.DeveloperName == 'Cordoba') {
				delegacionesCordoba = region.Delegaciones__c.split(';');
			}
			else if(region.DeveloperName == 'Litoral') {
				delegacionesLitoral = region.Delegaciones__c.split(';');
			}
			else if(region.DeveloperName == 'NEA') {
				delegacionesNEA = region.Delegaciones__c.split(';');
			}
			else if(region.DeveloperName == 'NOA') {
				delegacionesNOA = region.Delegaciones__c.split(';');
			}
			else if(region.DeveloperName == 'Nucleo') {
				delegacionesNucleo = region.Delegaciones__c.split(';');
			}
			else if(region.DeveloperName == 'Patagonia_Andina') {
				delegacionesPatagoniaAnd = region.Delegaciones__c.split(';');
			}
			else if(region.DeveloperName == 'Patagonia_Atlantica') {
				delegacionesPatagoniaAtl = region.Delegaciones__c.split(';');
			}
		}
		if(frontUser) {
			if(caso.Delegacion__r.Codigo_de_delegacion__c != usuario.Codigo_delegacion__c) {
				if( usuario.UserRole.DeveloperName == null || !usuario.UserRole.DeveloperName.containsIgnoreCase('lider') ) {
					return false;
				}
				else if(usuario.UserRole.DeveloperName == 'Lider_Buenos_Aires_So_y_Pampeana') {
					if( !delegacionesBsAsYPampeana.contains(caso.Delegacion__r.Codigo_de_delegacion__c) ) {
						return false;
					}
				}
				else if(usuario.UserRole.DeveloperName == 'Lider_Amba') {
					if( !delegacionesAmba.contains(caso.Delegacion__r.Codigo_de_delegacion__c) ) {
						return false;
					}
				}
				else if(usuario.UserRole.DeveloperName == 'Lider_Buenos_Aires_Centro') {
					if( !delegacionesBsAsCentro.contains(caso.Delegacion__r.Codigo_de_delegacion__c) ) {
						return false;
					}
				}
				else if(usuario.UserRole.DeveloperName == 'Lider_Buenos_Aires_Norte') {
					if( !delegacionesBsAsNorte.contains(caso.Delegacion__r.Codigo_de_delegacion__c) ) {
						return false;
					}
				}
				//Cordoba
				else if(usuario.UserRole.DeveloperName == 'Lider_Cordoba') {
					if( !delegacionesCordoba.contains(caso.Delegacion__r.Codigo_de_delegacion__c) ) {
						return false;
					}
				}
				//delegacionesLitoral
				else if(usuario.UserRole.DeveloperName == 'Lider_Litoral') {
					if( !delegacionesLitoral.contains(caso.Delegacion__r.Codigo_de_delegacion__c) ) {
						return false;
					}
				}
				//delegacionesNEA
				else if(usuario.UserRole.DeveloperName == 'Lider_NEA') {
					if( !delegacionesNEA.contains(caso.Delegacion__r.Codigo_de_delegacion__c) ) {
						return false;
					}
				}
				//delegacionesNOA
				else if(usuario.UserRole.DeveloperName == 'Lider_NOA') {
					if( !delegacionesNOA.contains(caso.Delegacion__r.Codigo_de_delegacion__c) ) {
						return false;
					}
				}
				//delegacionesNucleo
				else if(usuario.UserRole.DeveloperName == 'Lider_Nucleo') {
					if( !delegacionesNucleo.contains(caso.Delegacion__r.Codigo_de_delegacion__c) ) {
						return false;
					}
				}
				//delegacionesPatagoniaAnd
				else if(usuario.UserRole.DeveloperName == 'Lider_Patagonia_Andina') {
					if( !delegacionesPatagoniaAnd.contains(caso.Delegacion__r.Codigo_de_delegacion__c) ) {
						return false;
					}
				}
				//delegacionesPatagoniaAtl
				else if(usuario.UserRole.DeveloperName == 'Lider_Patagonia_Atlantica') {
					if( !delegacionesPatagoniaAtl.contains(caso.Delegacion__r.Codigo_de_delegacion__c) ) {
						return false;
					}
				}
			}
		}
		return true;
	}
	public static Boolean autoasignarMedico(Id alertId) {
		Case parentCase = new Case();
		Alerta__c alert = [SELECT Estado__c, Prestacion__c, Evento_Medico__c, Funcion__c, Prestacion_de_reintegro__c
							FROM Alerta__c
							WHERE Id =: alertId];
		User usuario = [SELECT Id, Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
		Boolean isDoctor = usuario.Profile.Name == 'Auditor Medico' || usuario.Profile.Name == 'Coordinador de Mesa de Ayuda';
		if(alert.Funcion__c == 'AM' && isDoctor && (alert.Estado__c == 'C1-----A' || alert.Estado__c == 'C1-----G')) {
			if(String.isNotBlank(alert.Prestacion__c)) {
				Prestacion__c prest = [SELECT Id, Ap__c, Ap__r.Medico_asignado__c, Ap__r.Nivel_de_derivacion__c
										FROM Prestacion__c
										WHERE Id =: alert.Prestacion__c];
				String nivel = prest.Ap__r.Nivel_de_derivacion__c;
				if(String.isNotBlank(prest.Ap__c)
					&& String.isBlank(prest.Ap__r.Medico_asignado__c)
					&& (nivel == 'Nivel 2' || nivel == 'Nivel 3')) {
					parentCase = prest.Ap__r;
				}
			}
			else if(String.isNotBlank(alert.Prestacion_de_reintegro__c)) {
				Prestacion_de_reintegro__c pRein = [SELECT Id, Caso__c, Caso__r.Medico_asignado__c, Caso__r.Nivel_de_derivacion__c
													FROM Prestacion_de_reintegro__c
													WHERE Id =: alert.Prestacion_de_reintegro__c];
				String nivel = pRein.Caso__r.Nivel_de_derivacion__c;
				if(String.isNotBlank(pRein.Caso__c)
					&& String.isBlank(pRein.Caso__r.Medico_asignado__c)
					&& (nivel == 'Nivel 2' || nivel == 'Nivel 3')) {
					parentCase = pRein.Caso__r;
				}
			}
			if(String.isNotBlank(parentCase.Id)) {
				parentCase.Medico_asignado__c = usuario.Id;
				update parentCase;
				return true;
			}
		}
		return false;
	}
	public static void insertBatchLogs(List<Database.UpsertResult> upsertResults,
										List<Database.SaveResult> saveResults,
										List<Database.DeleteResult> deleteResults,
										List<String> ids,
										String nombre) {
        Batch_log__c[] logsToInsert = new List<Batch_log__c>();
		Integer index = 0;
		Boolean hasIds = ids != null && !ids.isEmpty();
		if(upsertResults != null) {
			for (Database.UpsertResult ur : upsertResults) {
				if (!ur.isSuccess()) {
					Batch_log__c[] logs = getBatchLogs(ur.getErrors(), ids, hasIds, index, nombre);
					logsToInsert.addAll(logs);
				}
				index++;
			}
		}
		if(saveResults != null){
			for (Database.SaveResult ur : saveResults) {
				if (!ur.isSuccess()) {
					Batch_log__c[] logs = getBatchLogs(ur.getErrors(), ids, hasIds, index, nombre);
					logsToInsert.addAll(logs);
				}
				index++;
			}
		}
		if(deleteResults != null){
			for (Database.DeleteResult ur : deleteResults) {
				if (!ur.isSuccess()) {
					Batch_log__c[] logs = getBatchLogs(ur.getErrors(), ids, hasIds, index, nombre);
					logsToInsert.addAll(logs);
				}
				index++;
			}
		}
        if(!logsToInsert.isEmpty()) {
            Database.SaveResult[] logResults = Database.insert(logsToInsert, false);
        }
    }
	private static Batch_log__c[] getBatchLogs(Database.Error[] errors,
												String[] ids,
												Boolean hasIds,
												Integer index,
												String nombre) {
		Batch_log__c[] logsToReturn = new List<Batch_log__c>();
		for(Database.Error err : errors) {
			Batch_log__c log = new Batch_log__c();
			log.Error__c = err.getStatusCode() + ', ' + err.getFields() + ', ' + err.getMessage();
			log.Name = nombre;
			log.Id_registro_error__c = hasIds ? ids[index] : null;
			logsToReturn.add(log);
		}
		return logsToReturn;
	}
	public static Boolean isAValidEmail(String mail) {
		String EMAIL_REGEX = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
		if(String.isBlank(mail) || mail.contains('@-') || mail.startsWith('.')) {
			return false;
		}
		else {
			return Pattern.matches(EMAIL_REGEX, mail);
		}
	}
	public static ResponseFailedUpserts getAccountsWithFailedUpsert(Database.UpsertResult[] results,
																	Account[] accounts,
																	String[] externalIds) {
		Account[] accountsWithFailedUpsert = new List<Account>();
		String[] externalIdsFromAccountsFailed = new List<String>();
		Integer index = 0;
		for(Database.UpsertResult ur : results) {
			if (!ur.isSuccess()) {
				accountsWithFailedUpsert.add(accounts[index]);
				externalIdsFromAccountsFailed.add(externalIds[index]);
			}
			index ++;
		}
		return new ResponseFailedUpserts(accountsWithFailedUpsert, externalIdsFromAccountsFailed);
	}
	public class ResponseFailedUpserts {
		public Account[] accounts;
		public String[] externalIds;
		public ResponseFailedUpserts(Account[] accounts, String[] externalIds){
			this.accounts = accounts;
			this.externalIds = externalIds;
		}
	}
	public static Boolean isLeader() {
		String[] ADMIN_PROFILES = new List<String> {'System Administrator',
													'Administrador del sistema',
													'Administrador de Servicio',
													'CDC'};
		String[] CellProfiles = new List<String> {'Back CT', 'Back Administrativo', 'Discapacidad Interdisciplinario'};
		String[] leaderProfiles = ADMIN_PROFILES.clone();
		leaderProfiles.add('Coordinador de Mesa de Ayuda');
		User usuario = [SELECT Id, Profile.Name, UserRole.DeveloperName FROM User WHERE Id =: UserInfo.getUserId()];
		GroupMember[] leaders = [SELECT Id, UserOrGroupId, Group.DeveloperName
								FROM GroupMember
								WHERE Group.DeveloperName LIKE 'Celula%' AND UserOrGroupId =: usuario.Id];
		Boolean hasLeaderProfile = leaderProfiles.contains(usuario.Profile.Name);
		Boolean hasLeaderRole = usuario.UserRole.DeveloperName?.toUpperCase().contains('LIDER') != null
								? usuario.UserRole.DeveloperName?.toUpperCase().contains('LIDER') : false;
		Boolean isLeaderOfCell = !leaders.isEmpty() && CellProfiles.contains(usuario.Profile.Name);
		return hasLeaderProfile || hasLeaderRole || isLeaderOfCell;
	}
	public static Boolean isEncargado () {
		User usuario = [SELECT Id, Profile.Name, UserRole.DeveloperName FROM User WHERE Id =: UserInfo.getUserId()];
		Boolean hasEncargadoRole = usuario.UserRole.DeveloperName?.toUpperCase().contains('ENCARGADO') != null
										? usuario.UserRole.DeveloperName?.toUpperCase().contains('ENCARGADO')
										: false;
		return hasEncargadoRole;
	}
	public static String getStringAlphanumericOnly(String text) {
		if (String.isBlank(text)) {
			return '';
		}
		String REGEX = '^[a-zA-Z0-9_ ]*$';
		String alphanumericString = '';
		Integer strLength = text.length();
		for (Integer i = 0; i < text.length(); i++) {
			String s = text.mid(i, 1);
			if (Pattern.matches(REGEX, s)) {
				alphanumericString += s;
			}
		}
		return alphanumericString.replaceAll('\\s{2}', ' ');
	}
}