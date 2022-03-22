public class NotaDeAuditoriaTriggerHelper  {

	public static void enviarASS(List<Nota_de_Auditoria__c> notasDeAuditoria){
		List<Id> notaDeAuditoriaIds = new List<Id>();
		for(Nota_de_Auditoria__c nda : notasDeAuditoria){
			if(nda.RecordTypeId == XappiaHelper.getRecordType('Nota_de_Auditoria__c', 'Service').Id) {
				notaDeAuditoriaIds.add(nda.Id);
			}
		}
		enviarASS(notaDeAuditoriaIds);
	}

	@Future(callout=true)
	public static void enviarASS(List<Id> notaDeAuditoriaIds){
		List<Nota_de_Auditoria__c> notasToUpdate = new List<Nota_de_Auditoria__c>();
		List<Nota_de_Auditoria__c> notasDeAuditoria = [
			SELECT Nota__c, Owner.Name, Tipo_nota_de_Auditoria__r.Codigo_tipoNA__c, APr_Id__r.Nro_AP__c,
				Evento_Medico_Id__r.Nro_de_Evento_Medico_SS__c, APr_Id__r.Codigo_reintegro_SS__c, Id_Externo__c
			FROM Nota_de_Auditoria__c
			WHERE Id IN :notaDeAuditoriaIds
		];
		for(Nota_de_Auditoria__c nda : notasDeAuditoria){
			WSNotaDeAuditoriaEnviarASS.SSWSResult resp = WSNotaDeAuditoriaEnviarASS.enviar(nda);
			if(!resp.hasError) {
				nda.Id_Externo__c = resp.responseBody.data.id_nota;

				notasToUpdate.add(nda);
			}
		}

		List<Database.SaveResult> resultNotas = Database.update(notasToUpdate);
		System.debug('***resultNotas: ' + resultNotas);
	}

	public static void changesDoctorAtCases(Id[] caseIds) {
		User usuario = [SELECT Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
		Boolean isDoctor = usuario.Profile.Name == 'Auditor Medico' || usuario.Profile.Name == 'Coordinador de Mesa de Ayuda';
		Case[] casesToUpdate = new List<Case>();

		for(Case aCase : [
			SELECT Id, Nivel_de_derivacion__c, Contiene_alerta_AM__c, Medico_asignado__c, RecordTypeId
			FROM Case 
			WHERE Id IN :caseIds
		]) {
			if(isDoctor && String.isBlank(aCase.Medico_asignado__c) && aCase.Contiene_alerta_AM__c
				&& (aCase.Nivel_de_derivacion__c == 'Nivel 2' || aCase.Nivel_de_derivacion__c == 'Nivel 3')
				&& CaseTriggerHelper.hasARecordTypeWithMedicoAsignado(aCase)
			) {
				aCase.Medico_asignado__c = usuario.Id;

				casesToUpdate.add(aCase);
			}	
		}

		if(!casesToUpdate.isEmpty()) {
			update casesToUpdate;
		}
	}

	//public static Boolean hasARecordTypeWithMedicoAsignado(Case aCase) {
		//Id rtInternacion = XappiaHelper.getRecordType('Case', 'Internacion').Id;
		//Id rtSeguimiento = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
		//Id rtAP = XappiaHelper.getRecordType('Case', 'Autorizacion_previa').Id;
		//Id rtReintegro = XappiaHelper.getRecordType('Case', 'Reintegro').Id;

		//return aCase.RecordTypeId == rtInternacion || aCase.RecordTypeId == rtSeguimiento
				//|| aCase.RecordTypeId == rtAP || aCase.RecordTypeId == rtReintegro;
	//}
}