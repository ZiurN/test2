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
	@param			oldSegmentosToCheck - Mapa de los segmentos previos por su Id.
	@param			newSegmentosToCheck - Mapa de los segmentos modificados por su Id.
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