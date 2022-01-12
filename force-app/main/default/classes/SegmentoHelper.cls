@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class SegmentoHelper {
	public static void checkSegmentoActualInTheLastSegmento(Map<Id, Segmentos__c[]> emIdsSegmentosMap) {
		List<Segmentos__c> segmentosList = new List<Segmentos__c>();
		for(Evento_medico__c em : getEventosMedicos(emIdsSegmentosMap.keySet())) {
			Integer size = em.Segmentos__r.size();
			Integer i = 1;
			Segmentos__c[] segmentosFromMap = emIdsSegmentosMap.get(em.Id);
			for (Segmentos__c segmento : em.Segmentos__r) {
				if (segmento.Segmento_actual__c) {
					segmento.Segmento_actual__c = false;
					segmentosList.add(segmento);
				}
			}
			for(Segmentos__c segFromMap : segmentosFromMap) {
				segFromMap.Numero_del_segmento__c = size + i;
				segFromMap.Segmento_actual__c = segmentosFromMap.size() == i ? true : false;
				i ++;
			}
		}
		if (!segmentosList.isEmpty()) {
			Database.update(segmentosList);
		}
	}
	public static void updatePreviousSegments(Map<Id,Decimal> emNroSegMap){
		List<Evento_medico__c> ems = getEventosMedicos(emNroSegMap.keySet());
		List<Segmentos__c> segsToUpdate = new List<Segmentos__c>();
		for(Evento_medico__c em : ems){
			for (Segmentos__c seg : em.Segmentos__r) {
				if (seg.Numero_del_segmento__c == emNroSegMap.get(em.Id)) {
					seg.Segmento_actual__c = true;
					if(String.isBlank(seg.Error_en_SS__c)) {
						em.Fecha_y_hora_fin_ems__c = seg.Fecha_Fin_real__c;
					}
					segsToUpdate.add(seg);
				}
			}
		}
		Database.update(segsToUpdate);
		Database.update(ems);
	}
	public static Boolean isChangedSomeFieldToSendToSS(Segmentos__c segmento, Segmentos__c oldSegmento) {
		return segmento.Estado__c != oldSegmento.Estado__c
				|| segmento.Numero_del_segmento__c != oldSegmento.Numero_del_segmento__c
				|| segmento.Evento_Medico__c != oldSegmento.Evento_Medico__c
				|| segmento.Fecha_Inicio_tentativa__c != oldSegmento.Fecha_Inicio_tentativa__c
				|| segmento.Fecha_Fin_tentativa__c != oldSegmento.Fecha_Fin_tentativa__c
				|| segmento.Fecha_Inicio_real__c != oldSegmento.Fecha_Inicio_real__c
				|| segmento.Fecha_Fin_real__c != oldSegmento.Fecha_Fin_real__c;
	}
	public static void avoidDeletionOfTheFirstSegmento(List<Segmentos__c> segmentosToDelete) {
		List<Segmentos__c> segmentosCantDelete = new List<Segmentos__c>();
		for (Segmentos__c seg : segmentosToDelete) {
			if(seg.Numero_del_segmento__c == 1) {
				segmentosCantDelete.add(seg);
			}
		}
		for(Segmentos__c seg : segmentosCantDelete) {
			seg.addError(System.Label.Alerta_Segmento_NoBorrarPrimerSeg);
		}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método que verifica que las fechas reales insertadas en el segmento sean consecutivas
	@param			segmentosToCheck - Segmentos para verificar.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void checkFechasReales (List<Segmentos__c> segmentosToCheck) {
		for (Segmentos__c segmento : segmentosToCheck) {
			Boolean fechaInicialNula =  segmento.Fecha_Inicio_real__c == null;
			Boolean fechaFinalNula = segmento.Fecha_Fin_real__c == null;
			if (!fechaInicialNula && !fechaFinalNula && (segmento.Fecha_Inicio_real__c > segmento.Fecha_Fin_real__c)) {
				segmento.addError(System.Label.Alerta_Segmento_FechasNoConsecutivas);
			}
		}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método que verifica que las fechas tentativas insertadas en el segmento sean consecutivas
	@param			segmentosToCheck - Segmentos para verificar.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void checkFechasTentativas (List<Segmentos__c> segmentosToCheck) {
		Set<Id> eventosMedicosIds = new Set<Id>();
		for (Segmentos__c segmento : segmentosToCheck) {
			eventosMedicosIds.add(segmento.Evento_Medico__c);
		}
		System.debug(eventosMedicosIds);
		List<Segmentos__c> lastSegmentos = [SELECT Fecha_Fin_real__c,
												Evento_Medico__c
											FROM Segmentos__c
											WHERE Evento_Medico__c IN: eventosMedicosIds
												AND Segmento_actual__c = true];
		System.debug(lastSegmentos);
		Map<Id, DateTime> fechaFinaRealByEventoMedicoId = new Map<Id, DateTime>();
		if (!lastSegmentos.isEmpty()) {
			for (Segmentos__c segmento : lastSegmentos) {
				if (fechaFinaRealByEventoMedicoId.containsKey(segmento.Evento_Medico__c)) {
					DateTime currentFechaFinal = fechaFinaRealByEventoMedicoId.get(segmento.Evento_Medico__c);
					if (currentFechaFinal < segmento.Fecha_Fin_real__c) {
						fechaFinaRealByEventoMedicoId.put(segmento.Evento_Medico__c, segmento.Fecha_Fin_real__c);
					}
				} else {
					fechaFinaRealByEventoMedicoId.put(segmento.Evento_Medico__c, segmento.Fecha_Fin_real__c);
				}
			}
		}
		for (Segmentos__c segmento : segmentosToCheck) {
			Boolean fechaInicialNula =  segmento.Fecha_Inicio_tentativa__c == null;
			Boolean fechaFinalNula = segmento.Fecha_Fin_tentativa__c == null;
			if (!fechaInicialNula && !fechaFinalNula && (segmento.Fecha_Inicio_tentativa__c > segmento.Fecha_Fin_tentativa__c)) {
				segmento.addError(System.Label.Alerta_Segmento_FechasTentativasNoConsecutivas);
				continue;
			}
			if (!fechaFinaRealByEventoMedicoId.isEmpty()) {
				DateTime lastFechaFinalReal = fechaFinaRealByEventoMedicoId.get(segmento.Evento_Medico__c);
				if (!fechaInicialNula && (segmento.Fecha_Inicio_tentativa__c < lastFechaFinalReal)){
					segmento.addError(System.Label.Alerta_Trigger_Seg_FechaTentInicialInvalida);
				}
			}
		}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método que verifica el estado del evento médico asociado. Si está cerrado, debe evitar cualquier
					actualización.
	@param			segmentosToCheck - Segmentos para verificar.
	------------------------------------------------------------------------------------------------------------------------*/
	public static List<Segmentos__c> checkEventoMedicoStatus (List<Segmentos__c> segmentosToCheck) {
		List<Segmentos__c> segmentosToReturn = new List<Segmentos__c>();
		Map<Id, Segmentos__c> segmentosByEventoMedicoIds = new Map<Id, Segmentos__c>();
		for (Segmentos__c segmento : segmentosToCheck) {
			segmentosByEventoMedicoIds.put(segmento.Evento_Medico__c, segmento);
		}
		for (Evento_medico__c eventoMedico : getEventosMedicos(segmentosByEventoMedicoIds.keySet())) {
			if (eventoMedico.Estado__c == 'Cerrado') {
				segmentosByEventoMedicoIds.get(eventoMedico.Id).addError(System.Label.Alerta_Segmento_EventoMedicoCerrado);
			} else {
				segmentosToReturn.add(segmentosByEventoMedicoIds.get(eventoMedico.Id));
			}
		}
		return segmentosToReturn;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz.
	@description	Método para desmarcar los segmentos que fueron revertidos.
	@param			segmentosToDeFlagRevertedIds - Lista de ids de segmentos.
	------------------------------------------------------------------------------------------------------------------------*/
	public static void deFlagRevertedSegmentos (Set<Id> segmentosToDeFlagRevertedIds) {
		List<Segmentos__c> segmentos = [SELECT Revirtiendo_Segmento__c
										FROM Segmentos__c
										WHERE Id IN: segmentosToDeFlagRevertedIds];
		if (!segmentos.isEmpty()) {
			for (Segmentos__c segmento : segmentos) {
				segmento.Revirtiendo_Segmento__c = false;
			}
		}
		update segmentos;
	}
	/** Utils */
	private static List<Evento_medico__c> getEventosMedicos (Set<Id> eventosMedicosIds) {
		return [SELECT Estado__c,
					(SELECT Segmento_actual__c,
						Numero_del_segmento__c,
						Fecha_Fin_real__c,
						Error_en_SS__c
					FROM Segmentos__r
					)
				FROM Evento_medico__c
				WHERE Id IN :eventosMedicosIds];
	}
}