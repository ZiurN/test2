@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class XappiaHelper {
	static Map<String, Map<String, RecordTypeInfo>> mapRecordTypesBySObjectName = new Map<String, Map<String, RecordTypeInfo>>();
	public static Boolean isPlatformUser {get {
		isPlatformUser = isUserValidatedByAlias(isPlatformUser, 'platint');
		return isPlatformUser;
	} set;}
	public static Boolean isIntegracionSSUser {get {
		isIntegracionSSUser = isUserValidatedByAlias(isIntegracionSSUser, 'UsuarioI');
		return isIntegracionSSUser;
	} set;}
	public static Boolean eventFired {get{
		if (eventFired == null) return false;
		else return eventFired;
	} set;}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@description	Método para retornar información del tipo de registro.
	@param			sObjectTypeStr - Nombre del objecto.
	@param			recordTypeName - Nombre del tipo de registro.
	@param			encodedName - Si el objeto y el RT vienen en un String conjunto, se entrega dicho string.
	@return			RecordType - El objeto RT.
	------------------------------------------------------------------------------------------------------------------------*/
	public static RecordType getRecordType(String sObjectTypeStr, String recordTypeName) {
		if(mapRecordTypesBySObjectName.containsKey(sObjectTypeStr)
			&& mapRecordTypesBySObjectName.get(sObjectTypeStr).containsKey(recordTypeName)){
			RecordTypeInfo rtInfo = mapRecordTypesBySObjectName.get(sObjectTypeStr).get(recordTypeName);
			return new RecordType(Id = rtInfo.getRecordTypeId(), DeveloperName = rtInfo.getDeveloperName());
		}
		SObjectType sObjecytType = Schema.getGlobalDescribe().get(sObjectTypeStr);
		if(sObjecytType == null){
			return null;
		}
		mapRecordTypesBySObjectName.put(sObjectTypeStr, sObjecytType.getDescribe().getRecordTypeInfosByDeveloperName());
		RecordTypeInfo rtInfo = mapRecordTypesBySObjectName.get(sObjectTypeStr).get(recordTypeName);
		return new RecordType(Id = rtInfo.getRecordTypeId(), DeveloperName = rtInfo.getDeveloperName());
	}
	public static RecordType getRecordType(String encodedName) {
		List<String> parameters = encodedName.split('-');
		if (parameters.size() == 2) {
			return getRecordType(parameters[0], parameters[1]);
		} else {
			return null;
		}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@description	Método para retornar información del tipos de registro en base al Id.
	@param			sObjectTypeStr - Nombre del objecto.
	@param			recordTypeNames - Lista de nombre de los tipos de registro.
	@return			Map<Id, String> - DeveloperName del RT por Id.
	------------------------------------------------------------------------------------------------------------------------*/
	public static Map<Id, String> getRecordTypeNameById(String sObjectTypeStr, Set<String> recordTypeNames) {
		if(!mapRecordTypesBySObjectName.containsKey(sObjectTypeStr)) {
			SObjectType sObjecytType = Schema.getGlobalDescribe().get(sObjectTypeStr);
			if(sObjecytType == null){
				return null;
			}
			mapRecordTypesBySObjectName.put(
				sObjectTypeStr,
				sObjecytType.getDescribe().getRecordTypeInfosByDeveloperName()
			);
		}
		Map<Id, String> mapRecordTypes = new Map<Id, String> ();
		for(String rtDeveloperName : recordTypeNames) {
			RecordTypeInfo rtInfo = mapRecordTypesBySObjectName.get(sObjectTypeStr).get(rtDeveloperName);
			if(rtInfo == null){
				continue;
			}
			mapRecordTypes.put(rtInfo.getRecordTypeId(), rtInfo.getDeveloperName());
		}
		return mapRecordTypes;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@description	Método para retornar información del tipos de registro de un objeto.
	@param			sObjectTypeStr - Nombre del objecto.
	@return			Map<String, RecordTypeInfo> - Info de los RTs por Objeto.
	------------------------------------------------------------------------------------------------------------------------*/
	public static Map<String, RecordTypeInfo> getRecordTypes(String sObjectTypeStr) {
		if(!mapRecordTypesBySObjectName.containsKey(sObjectTypeStr)) {
			SObjectType sObjecytType = Schema.getGlobalDescribe().get(sObjectTypeStr);
			if(sObjecytType == null){
				return null;
			}
			mapRecordTypesBySObjectName.put(
				sObjectTypeStr,
				sObjecytType.getDescribe().getRecordTypeInfosByDeveloperName()
			);
		}
		return mapRecordTypesBySObjectName.get(sObjectTypeStr);
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@description	return CUIT in format xy-DNI-z. If it's not a valid DNI, return ''. Works only to fisical person.
	@param			DNI - DNI to format.
	@param			isMale - Boolean to indicate the gender of the DNI's owner.
	@return			String - return CUIT in format xy-DNI-z. If it's not a valid DNI, return ''
	------------------------------------------------------------------------------------------------------------------------*/
	public static String generateCUITFromDNI(String DNI, boolean isMale) {
		if (String.isBlank(dni)
				||!dni.isNumeric() || DNI.length() < 7
				|| DNI.length() > 8 || isMale == null) {
			return '';
		}
		if (DNI.length() == 7) {
			DNI = '0' + DNI;
		}
		String XY;
		if (isMale) {
			XY = '20';
		}
		else {
			XY = '27';
		}
		String XYWithDNI = XY + DNI;
		Integer[] serie = new Integer[] { 5, 4, 3, 2, 7, 6, 5, 4, 3, 2 };
		Integer aux = 0;
		for (Integer i = 0; i < 10; i++) {
			String simbol = XYWithDNI.subString(i, i + 1);
			aux += Integer.valueOf(simbol) * serie[i];
		}
		aux = (Math.mod(aux, 11));
		String Z = '';
		if (aux == 0) {
			Z = '0';
		}
		else if (aux == 1)	{
			XY = '23';
			if (isMale)	{
				Z = '9';
			} else	{
				Z = '4';
			}
		}
		else {
			Z = String.valueOf(11 - aux);
		}
		return XY + dni + Z;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@description	Método para validar el CUIT entregado.
	@param			CUIT - Cuit a validar. accept both formats: xx-xxxxxxxx-x and xxxxxxxxxxx
	@return			Boolean - Indicar si el CUIT es válido o no.
	------------------------------------------------------------------------------------------------------------------------*/
	public static Boolean isItValidCUIT(String CUIT) {
		if (String.isBlank(CUIT)) {
			return false;
		}
		String numericCUIT = StringToNumericString(CUIT);
		if (numericCUIT.length() != 11) {
			return false;
		}
		if (CUIT.length() == 13
				&& (CUIT.subString(2,3)!='-'
					|| CUIT.subString(11,12)!='-')) {
			return false;
		}
		CUIT = StringToNumericString(CUIT);
		if (CUIT.subString(0,2)!='34'
				&& CUIT.subString(0,2)!='33'
				&& CUIT.subString(0,2)!='30'
				&& CUIT.subString(0,2)!='27'
				&& CUIT.subString(0,2)!='24'
				&& CUIT.subString(0,2)!='23'
				&& CUIT.subString(0,2)!='20') {
			return false;
		}
		Integer[] serie = new Integer[] { 5, 4, 3, 2, 7, 6, 5, 4, 3, 2 };
		Integer aux = 0;
		for (Integer i = 0; i < 10; i++) {
			String simbol = CUIT.subString(i, i + 1);
			aux += Integer.valueOf(simbol) * serie[i];
		}
		aux = 11 - (Math.mod(aux, 11));
		if (aux == 11) {
			aux = 0;
		}
		return Integer.valueOf(CUIT.subString(10, 11)) == aux;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@description	Método para validar el número de tarjeta de crédito entregado.
	@param			creditCardNumber - Número de tarjeta a validar. its validation for most credit cards and other stuff
	@return			Boolean - Indicar si el número es válido o no.
	------------------------------------------------------------------------------------------------------------------------*/
	public static boolean isItValidLuhnCode(String creditCardNumber) {
		if (String.isBlank(creditCardNumber)) {
			return false;
		}
		Integer sumOfDigits = 0;
		List<String> cardDigits = creditCardNumber.split('');
		Integer checkEven = Math.mod(cardDigits.size(), 2);
		for (Integer i = 0; i < cardDigits.size(); i++) {
			Integer d = Integer.valueOf(cardDigits[i]);
			if (Math.mod(i, 2) == checkEven) {
				d *= 2;
				if (d >= 10) {
					d = d / 10 + Math.mod(d, 10);
				}
			}
			sumOfDigits += d;
		}
		return Math.mod(sumOfDigits, 10) == 0;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@description	Método que retorna los valores númericos encontrados en una cadena de texto.
	@param			str - Cadena para filtrar o limpiar.
	@return			String - La cadena de números encontrada.
	------------------------------------------------------------------------------------------------------------------------*/
	public static String stringToNumericString(String str) {
		if (String.isBlank(str)) {
			return '';
		}
		String numericString = '';
		Integer strLength = str.length();
		for (Integer i = 0; i<str.length(); i++) {
			String s = str.mid(i, 1);
			if (s.isNumeric()) {
				numericString += s;
			}
		}
		return numericString;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@description	validate if CBU is well formed - Validation provided by Mauricio Closa - Adapted by Xappia
	@param			CBU - CBU to validate.
	@return			Boolean - Indicate if the CBU is valid or not.
	------------------------------------------------------------------------------------------------------------------------*/
	public static Boolean isItValidCBU(String CBU) {
		List<Integer> VEC1 = new List<Integer> {7, 1, 3, 9, 7, 1, 3};
		List<Integer> VEC2 = new List<Integer> {3, 9, 7, 1, 3, 9, 7, 1, 3, 9, 7, 1, 3};
		if(String.isBlank(CBU)) {
			return false;
		}
		CBU = CBU.replace('-', '');
		if (CBU.length() == 22 && CBU.isNumeric()) {
			Integer acum = 0;
			for (Integer i = 0; i < 7; i++) {
				acum += Integer.valueOf(CBU.subString(0, 7).subString(i, i + 1)) * VEC1[i];
			}
			Integer verificador2 = Integer.valueOf(CBU.subString(7, 8));
			Integer diferencia1 = math.mod(10 - (math.mod(acum, 10)), 10);
			boolean primerBloqueCbuOk = (verificador2 == diferencia1);
			acum = 0;
			for (Integer i = 0; i < 13; i++) {
				acum += Integer.valueOf(CBU.subString(8, 21).subString(i, i + 1)) * VEC2[i];
			}
			Integer diferencia2 = math.mod(10 - (math.mod(acum, 10)), 10);
			boolean segundoBloqueCbuOk = (Integer.valueOf(CBU.subString(21)) == diferencia2);
			return (primerBloqueCbuOk && segundoBloqueCbuOk);
		}
		else {
			return false;
		}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@description	Método para obtener todos los valores de una picklist
	@param			objectName - Nombre del objeto.
	@param			pickListFieldName - Nombre del campo picklist.
	@return			List<String> - Lista de valores posibles para el campo buscado.
	------------------------------------------------------------------------------------------------------------------------*/
	public static List<String> getPicklistFieldValues(String objectName, String pickListFieldName) {
		List<String> picklistValues = new List<String>();
		SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
		List<Schema.PicklistEntry> pick_list_values = objectType.getDescribe()
													   .fields.getMap()
													   .get(pickListFieldName)
													   .getDescribe().getPickListValues();
		for (Schema.PicklistEntry aPickListValue : pick_list_values) {
			picklistValues.add(aPickListValue.getValue());
		}
		return picklistValues;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@description	Método para obtener todos los valores de una picklist
	@param			objectName - Nombre del objeto.
	@param			pickListFieldName - Nombre del campo picklist.
	@return			Map<String, String> - Lista de Labels posibles para el campo buscado por su valor correspondiente.
	------------------------------------------------------------------------------------------------------------------------*/
	public static Map<String, String> getPicklistLabelAndValues(String objectName, String pickListFieldName) {
		Map<String, String> picklistValues = new Map<String, String>();
		SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
		List<Schema.PicklistEntry> pick_list_values = objectType.getDescribe()
														.fields.getMap()
														.get(pickListFieldName)
														.getDescribe().getPickListValues();
		for (Schema.PicklistEntry aPickListValue : pick_list_values) {
			picklistValues.put(aPickListValue.getValue(), aPickListValue.getLabel());
		}
		return picklistValues;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@description	Método para Todos los roles hijo de un conjunto de roles.
	@param			roleIds - Conjunto de Ids de roles padre para buscar.
	@return			Set<ID>> - Conjunto de Ids de los roles hijos encontrados.
	------------------------------------------------------------------------------------------------------------------------*/
	public static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {
		Set<ID> currentRoleIds = new Set<ID>();
		for(UserRole userRole :[SELECT Id FROM UserRole WHERE ParentRoleId IN :roleIds AND ParentRoleID != null]){
			currentRoleIds.add(userRole.Id);
		}
		if(currentRoleIds.size() > 0) {
			currentRoleIds.addAll(XappiaHelper.getAllSubRoleIds(currentRoleIds));
		}
		return currentRoleIds;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@description	Método para Todos los roles padre de un conjunto de roles.
	@param			roleIds - Conjunto de Ids de roles hijo para buscar.
	@return			Set<ID>> - Conjunto de Ids de los roles padre encontrados.
	------------------------------------------------------------------------------------------------------------------------*/
	public static Set<ID> getParentRoleId(Set<ID> roleIds) {
		Set<ID> currentRoleIds = new Set<ID>();
		for(UserRole ur :[SELECT Id, ParentRoleId FROM UserRole WHERE Id IN: roleIds]) {
			currentRoleIds.add(ur.ParentRoleId);
		}
		// go fetch some more rolls!
		if(currentRoleIds.size() > 0) {
			currentRoleIds.addAll(getParentRoleId(currentRoleIds));
		}
		return currentRoleIds;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Matias Moll.
	@description	Método para obtener el ID de un perfil por su nombre;
	@param			prof - Nombre del perfil a buscar.
	@return			Id - Id encontrado para el perfil.
	------------------------------------------------------------------------------------------------------------------------*/
	public static Id getProfileIdByName(String prof){
		List<Profile> profiles = [SELECT Id FROM Profile WHERE Name = :prof];
		if(!profiles.isEmpty()){
			return profiles[0].Id;
		}
		return null;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método obtener recursos estáticos que puedan ser usados en Apex (JSONs principalmente)
	@param			staticResourceName - Nombre del recurso estático.
	@return			StaticResource - El recurso estático buscado.
	------------------------------------------------------------------------------------------------------------------------*/
	@SuppressWarnings('PMD.ApexCRUDViolation')
	public static StaticResource getStaticResource (String staticResourceName) {
		return [SELECT Body FROM StaticResource WHERE Name =: staticResourceName LIMIT 1];
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método para validar si el usuario ejecutante es un usuario Platint.
	@return			Boolean - Si el usuario es o no un usuario Platint.
	------------------------------------------------------------------------------------------------------------------------*/
	public static Boolean isPlatformUser () {
		return isPlatformUser;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método para validar si el usuario ejecutante es el usuario de Integración de SS.
	@return			Boolean - Si el usuario es o no el usuario de integración de SS.
	------------------------------------------------------------------------------------------------------------------------*/
	public static Boolean isIntegracionSSUser () {
		return isIntegracionSSUser;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método para enviar una notificación personalizada al usuario.
	@param			notificationTypeId - Id de la notificación personalizada.
	@param			targetId - Id del registro al que se debe dirigir el usuario al dar clic en la notificación.
	@param			title - Título de la notificación.
	@param			body - Texto de la notificación.
	@param			setUserIds - Conjunto de Ids a los que se les enviará la notificación.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void sendCustomNotification (String notificationTypeId,
												String targetId,
												String title,
												String body,
												Set<String> setUserIds) {
		Messaging.CustomNotification notification = new Messaging.CustomNotification();
		notification.setNotificationTypeId(notificationTypeId);
		notification.setTargetId(targetId);
		notification.setTitle(title);
		notification.setBody(body);
		notification.send(setUserIds);
	}
	/** Utils */
	private static Boolean isUserValidatedByAlias (Boolean currentValue, String alias) {
		Boolean isValidUser = false;
		if (currentValue == null) {
			for (User userToCheck : [SELECT Id FROM User WHERE Alias =: alias]) {
				if (Userinfo.getUserId() == userToCheck.Id) {
					isValidUser = true;
					currentValue = true;
					break;
				} else if (currentValue == null) {
					currentValue = false;
				}
			}
		}
		return currentValue == null ? isValidUser : currentValue;
	}
}