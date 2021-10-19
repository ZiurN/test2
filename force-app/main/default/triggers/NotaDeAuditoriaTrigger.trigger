trigger NotaDeAuditoriaTrigger on Nota_de_Auditoria__c (after insert, after update)  {

	String serviceRTId = XappiaHelper.getRecordType('Nota_de_Auditoria__c', 'Service').Id;
	//String salesRTId = XappiaHelper.getRecordType('Nota_de_Auditoria__c', 'Ventas').Id;

	if(Trigger.isAfter){
		if(Trigger.isInsert) {
			List<Id> casesToChangeDoctor = new List<Id>();
			List<Nota_de_Auditoria__c> notasToSendToSS = new List<Nota_de_Auditoria__c>();

			for (Nota_de_Auditoria__c nota : Trigger.new) {
				if(nota.RecordTypeId == serviceRTId && nota.Nota__c != null) {
					notasToSendToSS.add(nota);
				}

				if(nota.RecordTypeId == serviceRTId && nota.APr_Id__c != null) {
					casesToChangeDoctor.add(nota.APr_Id__c);
				}
			}

			if(!notasToSendToSS.isEmpty()) {
				NotaDeAuditoriaTriggerHelper.enviarASS(notasToSendToSS);
			}

			if(!casesToChangeDoctor.isEmpty()) {
				NotaDeAuditoriaTriggerHelper.changesDoctorAtCases(casesToChangeDoctor);
			}
		}
		if(Trigger.isUpdate) {
			List<Nota_de_Auditoria__c> notasToSendToSS = new List<Nota_de_Auditoria__c>();

			for (Nota_de_Auditoria__c nota : Trigger.new) {
				if(nota.RecordTypeId == serviceRTId && nota.Nota__c != Trigger.oldMap.get(nota.Id).Nota__c) {
					notasToSendToSS.add(nota);
				}
			}
			if(!notasToSendToSS.isEmpty()) {
				NotaDeAuditoriaTriggerHelper.enviarASS(notasToSendToSS);
			}
		}
	}
	
}