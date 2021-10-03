public class PrestacionTriggerHelper  {
	public static void authorizeCases(Set<String> idCases) {
		//Set<Id> idCases = new Set<Id>();
		Case[] casesToAuthorize = new List<Case>();

		//for(Prestacion_de_reintegro__c prest : prestaciones) {
			//idCases.add(prest.Caso__c);
		//}
		  
		Case[] cases = [
			SELECT Id, Status, RecordTypeId,
				(SELECT Id, Estado__c FROM Prestaciones__r)
			FROM Case
			WHERE Id IN :idCases
		];

		for(Case aCase : cases) {
			Boolean authorize = true;
			
			for(Prestacion__c prest : aCase.Prestaciones__r) {
				if(prest.Estado__c != 'C1----AS' && prest.Estado__c != 'C1EA--AA') {
					authorize = false;
				}
			}

			if(authorize) {
				if(aCase.Status != 'Autorizada') {
					aCase.Cambio_Manual__c = false;
					aCase.Ap_autorizada__c = true;
				
					if(aCase.Status != 'CA-----E' && aCase.Status != 'CA-----N') {
						aCase.Status = 'Autorizada';
					}

					casesToAuthorize.add(aCase);
				}
			}
		}

		update casesToAuthorize;
		
	}

	public static void validateDuplicateNomencladorOrMedicamento(Prestacion__c[] prestaciones) {
		Set<Id> idCases = new Set<Id>();

		for(Prestacion__c prest : prestaciones) {
			if(prest.Ap__c != null) {
				idCases.add(prest.Ap__c);
			}
		}

		Map<Id, Case> casesById = new Map<Id, Case>([
			SELECT Id, Status, RecordTypeId,
				(SELECT Id, Estado__c, Prestacion__c, Medicamento__c FROM Prestaciones__r)
			FROM Case
			WHERE Id IN :idCases
		]);


		for(Prestacion__c prestToValidate : prestaciones) {
			
			for(Prestacion__c prestFromQuery : casesById.get(prestToValidate.Ap__c).Prestaciones__r) {
				if(prestToValidate.Id != prestFromQuery.Id 
					&& prestToValidate.Prestacion__c == prestFromQuery.Prestacion__c
					&& prestToValidate.Prestacion__c != null
				) {
					prestToValidate.addError('No se permite cargar dos prestaciones con el mismo nomenclador al mismo caso');
				}

				if(prestToValidate.Id != prestFromQuery.Id 
					&& prestToValidate.Medicamento__c == prestFromQuery.Medicamento__c
					&& prestToValidate.Medicamento__c != null
				) {
					prestToValidate.addError('No se permite cargar dos prestaciones con el mismo medicamento al mismo caso');
				}	
			} 
			
		}

	}

	public static void deleteWhenCasesStatusIsNotCentroAutorizador(Map<Id, Prestacion__c> prestacionesById) {
		Prestacion__c[] prestacionesWithCaseStatus = [
			SELECT Id, Ap__r.Status FROM Prestacion__c 
			WHERE Id IN :prestacionesById.values()
		];
		User usuario = [SELECT Id, Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
		Boolean isAdmin = usuario.Profile.Name == 'Administrador del sistema';

		if(!isAdmin) {
			for(Prestacion__c prest : prestacionesWithCaseStatus) {
				if(prest.Ap__r.Status != 'CA-----G') {
					Prestacion__c prestToAddError = prestacionesById.get(prest.Id);
					prestToAddError.addError('El caso debe estar en estado "Generada" para poder eliminar prestaciones');
				}
			}
		}
	}
}