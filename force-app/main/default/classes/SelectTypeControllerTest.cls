@isTest
public class SelectTypeControllerTest {
	@isTest
	private static void itShouldBePosibleToObtainTheCaseTypesInGroups() {

        Test.startTest();
		List<SelectTypeController.GroupOfTypes> result = SelectTypeController.getRecordTypesByGroup('Case', null);
		Test.stopTest();

		System.assertEquals(recordTypesDevNamesByGroupName.size(), result.size());
		for (SelectTypeController.GroupOfTypes aGroupOfTypes : result) {
			System.assert(
				recordTypesDevNamesByGroupName.containsKey(aGroupOfTypes.name),
				'The group name "' + aGroupOfTypes.name
					+ '" was not found in the expected names ['
					+ recordTypesDevNamesByGroupName.keySet() + ']'
			);

			Set<String> expectedTypesForGroup = recordTypesDevNamesByGroupName.get(aGroupOfTypes.name);
			System.assertEquals(expectedTypesForGroup.size(), aGroupOfTypes.types.size());
			for (RecordType aRecordType : aGroupOfTypes.types) {
				System.assert(
					expectedTypesForGroup.contains(aRecordType.DeveloperName),
					'The record type "' + aRecordType.Name + '" was not among the expected for the group.'
				);
			}
		}
	}

	@isTest
	private static void itShouldBePosibleToFilterSomeRecordTypesByTheirDevName() {

		String allowedDevName = new List<String>(caseTypeDevNames)[0];

        Test.startTest();
		List<SelectTypeController.GroupOfTypes> result = SelectTypeController.getRecordTypesByGroup('Case', new String[] { allowedDevName });
		Test.stopTest();

		System.assertEquals(recordTypesDevNamesByGroupName.size(), result.size());
		for (SelectTypeController.GroupOfTypes aGroupOfTypes : result) {
			System.assert(
				recordTypesDevNamesByGroupName.containsKey(aGroupOfTypes.name),
				'The group name "' + aGroupOfTypes.name
					+ '" was not found in the expected names ['
					+ recordTypesDevNamesByGroupName.keySet() + ']'
			);

			Set<String> expectedTypesForGroup = recordTypesDevNamesByGroupName.get(aGroupOfTypes.name);
			System.assertEquals(1, aGroupOfTypes.types.size(), 'should only return the allowed record type');
			System.assertEquals(
				allowedDevName,
				aGroupOfTypes.types[0].DeveloperName,
				'The record type "' + aGroupOfTypes.types[0].Name + '" was not among the expected for the group.'
			);
		}
	}

	static Set<String> caseTypeDevNames;
	static Map<String, Set<String>> recordTypesDevNamesByGroupName;
	static {
		caseTypeDevNames = new Set<String>();
		for (Schema.RecordTypeInfo typeInfo : case.SObjectType.getDescribe().getRecordTypeInfos()) {
			caseTypeDevNames.add(typeInfo.getDeveloperName());
		}

		recordTypesDevNamesByGroupName = new Map<String, Set<String>>();
		for (Tipo_de_registro_por_grupo__mdt typeForGroup : [
			SELECT Grupo__r.Label, Id_de_tipo_de_registro__c, DeveloperName
			FROM Tipo_de_registro_por_grupo__mdt
			WHERE DeveloperName IN :caseTypeDevNames
			ORDER BY Grupo__c ASC
		]) {
			if(!recordTypesDevNamesByGroupName.containsKey(typeForGroup.Grupo__r.Label)) {
				recordTypesDevNamesByGroupName.put(typeForGroup.Grupo__r.Label, new Set<String>());
			}
			recordTypesDevNamesByGroupName.get(typeForGroup.Grupo__r.Label).add(typeForGroup.DeveloperName);
		}
	}
}