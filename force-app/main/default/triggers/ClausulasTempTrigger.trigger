trigger ClausulasTempTrigger on Asignacion_de_clausula_temporaria__c (after update)  { 
	
	if(Trigger.isAfter){
		if(Trigger.isUpdate){
			List<Asignacion_de_clausula_temporaria__c> clausulas = new List<Asignacion_de_clausula_temporaria__c>();

			for(Asignacion_de_clausula_temporaria__c clausula : Trigger.new){
				Asignacion_de_clausula_temporaria__c clausulaOld = Trigger.oldMap.get(clausula.Id);
				Boolean sendClausulaToSS = clausula.enviar_a_ss__c == true && clausula.codigo_ACT_SS__c == null
								&& clausula.Fecha_de_vigencia_hasta__c != clausulaOld.Fecha_de_vigencia_hasta__c;
				Boolean updateClausulaToSS = clausula.enviar_a_ss__c == true && clausula.codigo_ACT_SS__c != null
								&& clausula.Fecha_de_cierre_de_clausula__c != clausulaOld.Fecha_de_cierre_de_clausula__c;
				System.debug('clausula: ' + clausula);
				if(sendClausulaToSS || updateClausulaToSS) {
					clausulas.add(clausula);
				}
			}

			Boolean isInAsyncProcess = System.isBatch() || System.isFuture() || System.isQueueable();
			
			if(!clausulas.isEmpty() && !isInAsyncProcess){
				System.debug('****lista: ' + clausulas);
				ClausulasTempTriggerHelper.sendToSSAndFillFields(clausulas);
			}
		}

	}
}