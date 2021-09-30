public class SegmentoHelper {
	public static void checkSegmentoActualInTheLastSegmento(Map<Id, Segmentos__c[]> emIdsSegmentosMap) {
		List<Segmentos__c> segmentosList = new List<Segmentos__c>();
		for(Evento_medico__c em : [
			SELECT Id, Estado__c, (
				SELECT Segmento_actual__c, Numero_del_segmento__c
				FROM Segmentos__r
			)
			FROM Evento_medico__c
			WHERE Id IN :emIdsSegmentosMap.keySet()
		]) {
			Integer size = em.Segmentos__r.size();
			Integer i = 1;
			Segmentos__c[] segmentosFromMap = emIdsSegmentosMap.get(em.Id);
			// segmentos existentes
			for (Segmentos__c segmento : em.Segmentos__r) {
				if (segmento.Segmento_actual__c) {
					segmento.Segmento_actual__c = false;
					segmentosList.add(segmento);
				}
			}
			// segmentos nuevos
			for(Segmentos__c segFromMap : segmentosFromMap) {
				segFromMap.Numero_del_segmento__c = size + i;
				segFromMap.Segmento_actual__c = segmentosFromMap.size() == i ? true : false;
				i ++;
			}
			
		}
		if (!segmentosList.isEmpty()) {
			update segmentosList;
		}
	}

	public static void updatePreviousSegments(Map<Id,Decimal> emNroSegMap){
		List<Evento_medico__c> ems = [
			SELECT Estado__c, (
				SELECT Segmento_actual__c, Numero_del_segmento__c, Fecha_Fin_real__c, Error_en_SS__c
				FROM Segmentos__r
			) 
			FROM Evento_medico__c 
			WHERE Id IN :emNroSegMap.keySet()
		];

		List<Segmentos__c> segsToUpdate = new List<Segmentos__c>();
		for(Evento_medico__c em : ems){
//			if(em.Estado__c == 'Autorizado') {
				for (Segmentos__c seg : em.Segmentos__r) {
					if (seg.Numero_del_segmento__c == emNroSegMap.get(em.Id)) {
						seg.Segmento_actual__c = true;
						System.debug('****seg: ' + seg);
						if(String.isBlank(seg.Error_en_SS__c)) {
							em.Fecha_y_hora_fin_ems__c = seg.Fecha_Fin_real__c;
						}						
						segsToUpdate.add(seg);
					}
				}
//			}
		}
		System.debug('****segsToUpdate: ' + segsToUpdate);
		update segsToUpdate;
		update ems;
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
		System.debug('****segmentosToDelete: ' + segmentosToDelete);
		List<Segmentos__c> segmentosCantDelete = new List<Segmentos__c>();
		for (Segmentos__c seg : segmentosToDelete) {
			if(seg.Numero_del_segmento__c == 1) {
				segmentosCantDelete.add(seg);
			}
		}
		System.debug('****segmentosCantDelete: ' + segmentosCantDelete);
		for(Segmentos__c seg : segmentosCantDelete) {
			seg.addError('No se puede eliminar el primer segmento del Evento Médico');
		}
	}

	//@future (callout=true)
	//public static void sendUpdatesToSS(List<String> idsList) {
		//String body;
		//List<Segmentos__c> segToUpdate = new List<Segmentos__c>();
		//List<Segmentos__c> segList = [
				//SELECT Semid__c, Fecha_Inicio_real__c, Fecha_Fin_real__c, Evento_Medico__r.Nro_de_Evento_Medico_SS__c,
						//Evento_Medico__r.Fecha_y_Hora_inicio_EMS__c
				//FROM Segmentos__c
				//WHERE Id IN :idsList
		//];
		//System.debug('****segList: ' + segList);
		//for(Segmentos__c seg : segList) {
			//body = SegmentoActualizarBtnCtrl.generateJSON(seg);
			//WSSegmentoActualizar.Response resp = WSSegmentoActualizar.actualizarSegmento(
					//seg.Evento_Medico__r.Nro_de_Evento_Medico_SS__c,
					//seg.Semid__c,
					//body
			//);

			//seg.Datetime_Update_Trigger__c = System.now();
			//if (!resp.hasError) {
				//for(WSSegmentoEliminarResp.Segmento wsSegmento : resp.result.data.em.segmento) {
					//if(wsSegmento.sem_id == seg.Semid__c) {
						//System.debug('sem_id del WS es == al de SF');
						//seg.Estado__c = wsSegmento.estado;
						//seg.Result_Update_Trigger__c = 'ok';
////						seg.Solicitante__c = wsSegmento.nom_solicitante;
////						seg.Fecha_Inicio_real__c = Datetime.parse(wsSegmento.fecha_real_desde.replace('-', '/'));
////						seg.Fecha_Fin_real__c = Datetime.parse(wsSegmento.fecha_real_hasta.replace('-', '/'));
					//}
				//}
			//} else {
				//seg.Result_Update_Trigger__c = resp.message;
			//}
			//segToUpdate.add(seg);
		//}
		//List<Database.SaveResult> results = Database.update(segToUpdate);
		//System.debug('****results: ' + results);
	//}

	//@future (callout=true)
	//public static void sendSegmentToSS(List<String> idsList) {
		//String body;
		//List<Segmentos__c> segsToUpdate = new List<Segmentos__c>();
		//List<Segmentos__c> segsList = [
				//SELECT Semid__c, Evento_Medico__r.Efector_Solicitante__r.Codigo_de_efector__c, Fecha_Inicio_tentativa__c,
						//Evento_Medico__r.Nro_de_Evento_Medico_SS__c, Fecha_Fin_tentativa__c
				//FROM Segmentos__c
				//WHERE Id IN :idsList
		//];
		//for(Segmentos__c seg : segsList) {
			//body = SegmentoAltaBtnCtrl.generateJSON(seg);
			//WSSegmentoAlta.Response resp = WSSegmentoAlta.crearSegmento(
					//seg.Evento_Medico__r.Nro_de_Evento_Medico_SS__c,
					//body
			//); 

			//seg.Datetime_Insert_Trigger__c = System.now();
			//System.debug(resp);
			//if (!resp.hasError) {
				//for(WSSegmentoEliminarResp.Segmento segWs : resp.result.data.em.segmento) {
					//String segId = seg.Id;
					//if(segId == segWs.aca_nro_sf) {
						//seg.Semid__c = segWs.sem_id;
						//seg.Fecha_Inicio_real__c = segWs.fecha_real_desde != null
								//? Datetime.parse(segWs.fecha_real_desde.replace('-', '/')) : null;
						//seg.Fecha_Fin_real__c = segWs.fecha_real_hasta != null
								//? Datetime.parse(segWs.fecha_real_hasta.replace('-', '/')) : null;
						//seg.Result_Insert_Trigger__c = 'ok';
					//}
				//}
			//} else {
				//seg.Result_Insert_Trigger__c = resp.message;
			//}
			//segsToUpdate.add(seg);
		//}
		//List<Database.SaveResult> results = Database.update(segsToUpdate);
		//System.debug('****results: ' + results);

	//}
}