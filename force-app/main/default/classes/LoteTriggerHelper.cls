public class LoteTriggerHelper {

	public static void reintentoEnvio(List<Lote__c> lotes) {
		List<Lote__c> lotesToUpdate = new List<Lote__c>();

		for(Lote__c lote : lotes){
			lotesToUpdate.add(resendToSS(lote.Id,lote.CreatedBy.CommunityNickname.toUpperCase()));
		}
		update lotesToUpdate;
	}

	private static Lote__c resendToSS(Id loteId, String username){
		Lote__c lote = [
			SELECT Id, Observaciones__c, Emision__c, Fecha__c
			FROM Lote__c
			WHERE Id = :loteId
		];
		String body = JSON.serialize(new Map<String,Object>{
			'usuario' => username,
			'observaciones' => lote.Observaciones__c,
			'emision' => lote.Emision__c,
			'fecha' => lote.Fecha__c != null ? String.valueOf(lote.Fecha__c) : null
		});
		System.debug('body to sendLote:  ' + body);
		WSLoteEnviarASS.Response resp = WSLoteEnviarASS.sendLoteToSS(body);

		if(!resp.hasError){
			lote.Id_lote_SS__c = resp.lote.data.lote_id != null ? String.valueOf(resp.lote.data.lote_id) : null;
			lote.Estado__c = resp.lote.data.estado;
			lote.Fallo_en_SS__c = null;
			lote.Fecha_de_fallo__c = null; 
		}
		else{
			lote.Fallo_en_SS__c = resp.message;
			lote.Fecha_de_fallo__c = Datetime.now(); 
		}
		System.debug(lote);
		return lote;

	}
}