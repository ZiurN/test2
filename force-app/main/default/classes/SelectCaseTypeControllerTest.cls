@isTest
public class SelectCaseTypeControllerTest {
	@isTest
	private static void itShouldBePosibleToObtainTheCaseTypesInGroups() {
		Set<Id> caseTypeIds = new Set<Id>();
		for (Schema.RecordTypeInfo typeInfo : case.SObjectType.getDescribe().getRecordTypeInfos()) {
			caseTypeIds.add(typeInfo.getRecordTypeId());
		}
		Map<String, Set<Id>> recordTypesByGroupName = new Map<String, Set<Id>>();
		for (Tipo_de_registro_por_grupo__mdt typeForGroup : [
			SELECT Grupo__r.Label, Id_de_tipo_de_registro__c
			FROM Tipo_de_registro_por_grupo__mdt
			WHERE Id_de_tipo_de_registro__c IN :caseTypeIds
			ORDER BY Grupo__c ASC
		]) {
			if(!recordTypesByGroupName.containsKey(typeForGroup.Grupo__r.Label)) {
				recordTypesByGroupName.put(typeForGroup.Grupo__r.Label, new Set<Id>());
			}
			recordTypesByGroupName.get(typeForGroup.Grupo__r.Label).add(typeForGroup.Id_de_tipo_de_registro__c);
		}
		
		List<SelectCaseTypeController.GroupOfTypes> result = SelectCaseTypeController.getRecordTypesByGroup();
		
		System.assertEquals(recordTypesByGroupName.size(), result.size());
		for (SelectCaseTypeController.GroupOfTypes aGroupOfTypes : result) {
			System.assert(
				recordTypesByGroupName.containsKey(aGroupOfTypes.name),
				'The group name "' + aGroupOfTypes.name
					+ '" was not found in the expected names ['
					+ recordTypesByGroupName.keySet() + ']'
			);
			
			Set<Id> expectedTypesForGroup = recordTypesByGroupName.get(aGroupOfTypes.name);
			System.assertEquals(expectedTypesForGroup.size(), aGroupOfTypes.types.size());
			for (RecordType aRecordType : aGroupOfTypes.types) {
				System.assert(
					expectedTypesForGroup.contains(aRecordType.Id),
					'The record type "' + aRecordType.Name + '" was not among the expected for the group.'
				);
			}
		}
	}
}