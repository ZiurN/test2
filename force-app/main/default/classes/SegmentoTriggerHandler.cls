/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase manejadora del desencadenador para el objeto Segmentos__c
@date			08/12/2021
------------------------------------------------------------------------------------------------------------------------*/
public with sharing class SegmentoTriggerHandler extends TriggerHandler {
	List<Segmentos__c> lNew = (List<Segmentos__c>) Trigger.new;
	List<Segmentos__c> lOld = (List<Segmentos__c>) Trigger.old;
	Map<Id,Segmentos__c> mNew = (Map<Id,Segmentos__c>) Trigger.newMap;
	Map<Id,Segmentos__c> mOld = (Map<Id,Segmentos__c>) Trigger.oldMap;
	public override void beforeInsert() {
		Map<Id, Segmentos__c[]> eventoMedicoIdSegmentosMap = new Map<Id, Segmentos__c[]>();
		for (Segmentos__c segmento : lNew) {
			if(eventoMedicoIdSegmentosMap.containsKey(segmento.Evento_Medico__c)) {
				Segmentos__c[] segmentosFromMap = eventoMedicoIdSegmentosMap.get(segmento.Evento_Medico__c);
				segmentosFromMap.add(segmento);

				eventoMedicoIdSegmentosMap.put(segmento.Evento_Medico__c, segmentosFromMap);
			}
			else {
				eventoMedicoIdSegmentosMap.put(segmento.Evento_Medico__c, new List<Segmentos__c>{segmento});
			}
		}
		if (!eventoMedicoIdSegmentosMap.isEmpty()) {
			SegmentoHelper.checkSegmentoActualInTheLastSegmento(eventoMedicoIdSegmentosMap);
		}
	}
	public override void beforeUpdate() {
		List<Segmentos__c> editableSegmentos = SegmentoHelper.checkEventoMedicoStatus(lNew);
		if (!editableSegmentos.isEmpty()) {
			List<Segmentos__c> segmentosToCheck = new List<Segmentos__c>();
			List<Segmentos__c> revertedSegmentos = new List<Segmentos__c>();
			for (Segmentos__c segmento : editableSegmentos) {
				Segmentos__c oldSeg = mOld.get(segmento.Id);
				if (mOld.containsKey(segmento.Id)
					&& (mOld.get(segmento.Id).Fecha_Inicio_real__c != segmento.Fecha_Inicio_real__c
						|| mOld.get(segmento.Id).Fecha_Fin_real__c != segmento.Fecha_Fin_real__c)) {
					segmentosToCheck.add(segmento);
				}
			}
			if (!segmentosToCheck.isEmpty()) {
				SegmentoHelper.checkFechasReales(segmentosToCheck);
			}
		}
	}
	public override void beforeDelete() {
		SegmentoHelper.avoidDeletionOfTheFirstSegmento(lOld);
	}
	public override void afterInsert() {
		List<Segmentos__c> segmentos = new List<Segmentos__c>();
		for(Segmentos__c segmento : lNew) {
			Boolean dontQueue = Test.isRunningTest() && segmento.Solicitante__c == 'NO ENCOLAR';
			if(String.isBlank(segmento.Semid__c) && !dontQueue) {
				segmentos.add(segmento);
			}
		}
		if(!segmentos.isEmpty()) {
			System.enqueueJob(new SegmentoQueueable(segmentos, false));
		}
	}
	public override void afterUpdate() {
		Id profileId = UserInfo.getProfileId();
		String profileName = [SELECT Id,Name FROM Profile WHERE Id = :profileId].Name;
		Map<Id, Segmentos__c> oldSegmentosMap = new Map<Id, Segmentos__c>();
		List<Segmentos__c> segmentosToUpdate = new List<Segmentos__c>();
		List<Segmentos__c> segmentosToCreate = new List<Segmentos__c>();
		Set<Id> segmentosToDeFlagRevertedIds = new Set<Id>();
		for(Segmentos__c segmento : lNew) {
			Segmentos__c oldSeg = mOld.get(segmento.Id);
			Boolean shouldUpdateSS = segmento.Fecha_fin_Real__c != null
										&& segmento.Fecha_Inicio_real__c != null
										&& (profileName != 'Administrador de sistema' && profileName != 'System Administrator');
			Boolean shouldInsertSS = segmento.Fecha_inicio_tentativa__c != null && segmento.Fecha_fin_Tentativa__c != null;
			Boolean isReverting = oldSeg.Revirtiendo_Segmento__c == false && segmento.Revirtiendo_Segmento__c == true;
			Boolean hasBeenReverted = oldSeg.Revirtiendo_Segmento__c == true && segmento.Revirtiendo_Segmento__c == false;
			Boolean dontQueue = Test.isRunningTest() && segmento.Solicitante__c == 'NO ENCOLAR';
			if(String.isNotBlank(segmento.Semid__c)
				&& SegmentoHelper.isChangedSomeFieldToSendToSS(segmento, oldSeg)
				&& shouldUpdateSS
				&& !(isReverting || hasBeenReverted)
				&& !dontQueue) {
				segmentosToUpdate.add(segmento);
				oldSegmentosMap.put(segmento.Id, mOld.get(segmento.Id));
			} else if (isReverting) {
				segmentosToDeFlagRevertedIds.add(segmento.Id);
			}else if(String.isBlank(segmento.Semid__c)
				&& SegmentoHelper.isChangedSomeFieldToSendToSS(segmento, oldSeg)
				&& shouldInsertSS) {
				segmentosToCreate.add(segmento);
			}
		}
		if (!segmentosToDeFlagRevertedIds.isEmpty()) {
			SegmentoHelper.deFlagRevertedSegmentos(segmentosToDeFlagRevertedIds);
		}
		if(!segmentosToUpdate.isEmpty()) {
			System.enqueueJob(new SegmentoQueueable(segmentosToUpdate, oldSegmentosMap, true));
		}
		else if(!segmentosToCreate.isEmpty()) {
			System.enqueueJob(new SegmentoQueueable(segmentosToCreate, false));
		}
	}
	public override void afterDelete() {
		Map<Id,Decimal> emNroSegMap = new Map<Id,Decimal>();
		for(Segmentos__c seg : lOld){
			emNroSegMap.put(seg.Evento_Medico__c,seg.Numero_del_segmento__c -1);
		}
		SegmentoHelper.updatePreviousSegments(emNroSegMap);
	}
	public override void afterUndelete() {
		//Nothing
	}
}
