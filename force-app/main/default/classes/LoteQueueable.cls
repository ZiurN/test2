public class LoteQueueable  implements Queueable, Database.AllowsCallouts{
	public List<Lote__c> lotes;

	public LoteQueueable(List<Lote__c> loteList){
		lotes = loteList;
	}

	public void execute(QueueableContext context) {
		User usuario = [SELECT Alias, CommunityNickname, Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
		String apodo = usuario.CommunityNickname.toUpperCase();
		if(!lotes.isEmpty()){
			Lote__c loteOriginal = lotes.remove(0);
			Lote__c lote = loteOriginal.clone(true,true,false,false);
			String body = JSON.serialize(new Map<String,Object>{
			'usuario' => apodo,
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
			lote.Bloqueo__c = false;
			update lote;
			if(!lotes.isEmpty()){
				System.enqueueJob(new LoteQueueable(lotes));
			}
		}
	}
}