public class SegmentoEnviarASSBtnCtrl  {
@AuraEnabled
	public static BasicResponse enviarASS(String segmentId) {
		Segmentos__c seg = [
            SELECT Semid__c, Evento_Medico__r.Efector_Solicitante__r.Codigo_de_efector__c, Fecha_Inicio_tentativa__c,
				Evento_Medico__r.Nro_de_Evento_Medico_SS__c, Fecha_Fin_tentativa__c, Evento_Medico__c, 
				Evento_Medico__r.RecordTypeId
            FROM Segmentos__c
            WHERE Id =: segmentId
        ];

		if(String.isBlank(seg.Semid__c)) {
			return SegmentoAltaBtnCtrl.createSegmento(segmentId);
			
		}
		else {
			return SegmentoActualizarBtnCtrl.actualizarSegmento(seg.Semid__c);
		}
	}

}