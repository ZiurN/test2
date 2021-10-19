trigger SegmentoTrigger on Segmentos__c (
    before insert, before delete,
    after insert, after update, 
    after delete
    )  {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            Map<Id, Segmentos__c[]> eventoMedicoIdSegmentosMap = new Map<Id, Segmentos__c[]>();

            for (Segmentos__c segmento : Trigger.new) {
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

        if(Trigger.isDelete) {
            SegmentoHelper.avoidDeletionOfTheFirstSegmento(Trigger.old);
        }
    }

    if(Trigger.isAfter){
        if(Trigger.isInsert) {
            List<Segmentos__c> segmentos = new List<Segmentos__c>();

            for(Segmentos__c segmento : Trigger.new) {
                if(String.isBlank(segmento.Semid__c)) {
                    segmentos.add(segmento);
                }
            }

            if(!segmentos.isEmpty() && !Test.isRunningTest()) {
				System.enqueueJob(new SegmentoQueueable(segmentos, false));
            }
        }

        if(Trigger.isUpdate) {
            Id profileId = UserInfo.getProfileId();
            String profileName = [
                SELECT Id,Name 
                FROM Profile    
                WHERE Id = :profileId
            ].Name;

            List<Segmentos__c> segmentosToUpdate = new List<Segmentos__c>();
            List<Segmentos__c> segmentosToCreate = new List<Segmentos__c>();

            for(Segmentos__c segmento : Trigger.new) {
                Segmentos__c oldSeg = Trigger.oldMap.get(segmento.Id);
                Boolean shouldUpdateSS = segmento.Fecha_fin_Real__c != null && segmento.Fecha_Inicio_real__c != null && (profileName != 'Administrador de sistema' && profileName != 'System Administrator'); 

                Boolean shouldInsertSS = segmento.Fecha_inicio_tentativa__c != null && segmento.Fecha_fin_Tentativa__c != null;
                if(String.isNotBlank(segmento.Semid__c) 
                    && SegmentoHelper.isChangedSomeFieldToSendToSS(segmento,oldSeg) 
                    && shouldUpdateSS
                ) {
                    segmentosToUpdate.add(segmento);
                }
                else if(String.isBlank(segmento.Semid__c) 
                    && SegmentoHelper.isChangedSomeFieldToSendToSS(segmento, oldSeg) 
                    && shouldInsertSS
                ) {
                    segmentosToCreate.add(segmento);
                }
            }

            if(!segmentosToUpdate.isEmpty() && !Test.isRunningTest()) {
				System.enqueueJob(new SegmentoQueueable(segmentosToUpdate, true));
            }
            else if(!segmentosToCreate.isEmpty() && !Test.isRunningTest()) {
				System.enqueueJob(new SegmentoQueueable(segmentosToCreate, false));
            }
        }
        // CON LLAMADO AL WS
        //----------------------------------------------------------------------------------------
        //if (Trigger.isInsert) {
            //List<String> idsFromSegmentsDontCreatedAutomatically = new List<String>();
            //for (Segmentos__c seg : Trigger.new) {
////                Segmentos__c segOld = Trigger.oldMap.get(seg.Id);
                //if (!seg.Creado_Automaticamente__c) {
                    //idsFromSegmentsDontCreatedAutomatically.add(seg.Id);
                //}
            //}
            //if (!idsFromSegmentsDontCreatedAutomatically.isEmpty()) {
                //SegmentoHelper.sendSegmentToSS(idsFromSegmentsDontCreatedAutomatically);
            //}
        //}

        //if (Trigger.isUpdate) {
            //List<String> idsFromSegmentWithChangesInFechaReal = new List<String>();
            //for (Segmentos__c seg : Trigger.new) {
                //Segmentos__c segOld = Trigger.oldMap.get(seg.Id);
                //if (seg.Fecha_Inicio_real__c != segOld.Fecha_Inicio_real__c
                        //|| seg.Fecha_Fin_real__c != segOld.Fecha_Fin_real__c
                //) {
                    //idsFromSegmentWithChangesInFechaReal.add(seg.Id);
                //}
            //}

			//Boolean isInAsyncProcess = System.isBatch()
				//|| System.isFuture()
				//|| System.isQueueable();

            //if (!idsFromSegmentWithChangesInFechaReal.isEmpty()
				//&& !isInAsyncProcess
			//) {
                //SegmentoHelper.sendUpdatesToSS(idsFromSegmentWithChangesInFechaReal);
            //}
        //}
        //----------------------------------------------------------------------------------------
        if (Trigger.isDelete) {
            Map<Id,Decimal> emNroSegMap = new Map<Id,Decimal>();
            System.debug('^^^^Segmentos Trigger.old: ' + Trigger.old);
            for(Segmentos__c seg : Trigger.old){
                emNroSegMap.put(seg.Evento_Medico__c,seg.Numero_del_segmento__c -1);
            }

            SegmentoHelper.updatePreviousSegments(emNroSegMap);
        }
    }
}