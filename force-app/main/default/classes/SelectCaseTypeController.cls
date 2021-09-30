public with sharing class SelectCaseTypeController {
	@AuraEnabled
	public static List<GroupOfTypes> getRecordTypesByGroup(){
		Map<Id, RecordType> typesById = new Map<Id, RecordType>();
		for (Schema.RecordTypeInfo typeInfo : case.SObjectType.getDescribe().getRecordTypeInfos()) {
			RecordType temp = new RecordType(
				Id = typeInfo.getRecordTypeId(),
				Name = typeInfo.getName()
			);
			typesById.put(temp.Id, temp);
		}
		
		List<GroupOfTypes> result = new List<GroupOfTypes>();
		GroupOfTypes currentGroup;
		for (Tipo_de_registro_por_grupo__mdt typeForGroup : [
			SELECT Grupo__r.MasterLabel, Id_de_tipo_de_registro__c
			FROM Tipo_de_registro_por_grupo__mdt
			WHERE Id_de_tipo_de_registro__c IN :typesById.keySet()
			ORDER BY Grupo__c ASC
		]) {
			if(currentGroup == null || currentGroup.name != typeForGroup.Grupo__r.MasterLabel) {
				currentGroup = new GroupOfTypes(typeForGroup.Grupo__r.MasterLabel);
				result.add(currentGroup);
			}
			currentGroup.types.add(typesById.get(typeForGroup.Id_de_tipo_de_registro__c));
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
}