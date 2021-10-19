public with sharing class SelectTypeController {

	@AuraEnabled
	public static List<GroupOfTypes> getRecordTypesByGroup(String sObjectType, String[] allowedDevNames) {
		//Generics to allow the class to work for multiple sobject types
		sObject sobj = (sObject)Type.forName('', sObjectType).newInstance();

		Set<String> allowedDeveloperNames;
		if (allowedDevNames != null) {
			allowedDeveloperNames = new Set<String>(allowedDevNames);
		}

		Map<String, RecordType> typesByDevName = new Map<String, RecordType>();
        Set<String> typesDevNames = new Set<String>();
		for (Schema.RecordTypeInfo typeInfo : sobj.getSobjectType().getDescribe().getRecordTypeInfos()) {

			if (!typeInfo.isAvailable()
				|| (allowedDeveloperNames != null
					&& !allowedDeveloperNames.isEmpty()
					&& !allowedDeveloperNames.contains(typeInfo.getDeveloperName())
				)
			) {
				continue;
            }

			RecordType temp = new RecordType(
				Id = typeInfo.getRecordTypeId(),
				Name = typeInfo.getName(),
                DeveloperName = typeInfo.getDeveloperName()
			);
			typesByDevName.put(temp.DeveloperName, temp);
		}

		List<GroupOfTypes> result = new List<GroupOfTypes>();
		GroupOfTypes currentGroup;
		for (Tipo_de_registro_por_grupo__mdt typeForGroup : [
			SELECT Grupo__r.MasterLabel, Id_de_tipo_de_registro__c, DeveloperName
			FROM Tipo_de_registro_por_grupo__mdt
			WHERE DeveloperName IN :typesByDevName.keySet()
			ORDER BY Grupo__c ASC
		]) {
			if(currentGroup == null || currentGroup.name != typeForGroup.Grupo__r.MasterLabel) {
				currentGroup = new GroupOfTypes(typeForGroup.Grupo__r.MasterLabel);
				result.add(currentGroup);
			}
			currentGroup.types.add(typesByDevName.get(typeForGroup.DeveloperName));
		}

		return result;
	}


	public class GroupOfTypes {
		@AuraEnabled
		public String name;
		@AuraEnabled
		public List<RecordType> types;

		public GroupOfTypes(String name) {
			this.name = name;
			types = new List<RecordType>();
		}
	}
	@AuraEnabled
	public static ID getRecordTypeIdByDevName(String sObjectType, String devName){
		return XappiaHelper.getRecordType(sObjectType, devName).Id;
	}
}