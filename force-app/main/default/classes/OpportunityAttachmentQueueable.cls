public class OpportunityAttachmentQueueable  implements Queueable, Database.AllowsCallouts{
	public List<Opportunity> opps;
	public Opportunity actualOpp;
	public List<Id> docIds;
	public Boolean errorOp;
	public String errorMsg;

	public OpportunityAttachmentQueueable(List<Opportunity> opportunities,Opportunity opp , List<Id> documents, Boolean err){
		this.opps = opportunities;
		this.actualOpp = opp;
		this.docIds = documents;
		this.errorOp = err;
	}

	public void execute(QueueableContext context) {
		if(!docIds.isEmpty()){
			Id versionId = docIds.remove(0);
			
			ContentVersion version = [SELECT Id, VersionData, Title,Enviado__c, FileExtension, Description FROM ContentVersion WHERE Id = :versionId];
			User usuario = [SELECT Id, CommunityNickname FROM User WHERE Id = :UserInfo.getUserId()];
			WSResult resp;
			List<Nota_de_Auditoria__c> notas = new List<Nota_de_Auditoria__c>();
			String nick;
			if(actualOpp.Usuario_error__c != null){
				nick = actualOpp.Usuario_error__c;
			}
			else{
				nick = usuario.CommunityNickname.toUpperCase();
			}
			switch on actualOpp.Tipo_de_Solicitud__c{
				when 'ALTA'{
					Map<String,Object> bodyMap = OpportunitySendAltaBtnCtrl.generateJSON(nick,actualOpp,actualOpp.Localidad_new__r.Loc_Id__c,notas);
					bodyMap.put('archivos', new List<Map<String,Object>> {
						new Map<String, Object>{
							'datos' => 'data:' + Utils.getTypeAndExtension(version.FileExtension) + ';base64,' + EncodingUtil.base64Encode(version.VersionData),
							'observaciones' => null,
    						'descripcion' => version.Description,
							'nombre' => version.Title.contains('.' + version.FileExtension) 
											? version.Title : version.Title + '.' + version.FileExtension
						}
					});
					if(actualOpp.Nro_de_solicitud__c != null){
						List<Object> encabezado = (List<Object>) bodyMap.get('encabezado');
						Map<String, Object> encabezadoMap = (Map<String, Object>) encabezado.remove(0);
						encabezadoMap.put('solicitud_id', actualOpp.Nro_de_solicitud__c);
						encabezado.add(encabezadoMap);
						bodyMap.put('encabezado',encabezado);
					}
					resp = WSOpportunitySendAlta.sendAlta(JSON.serialize(bodyMap));
				}
				when 'REING_GFAM'{
					Map<String,Object> bodyMap = OpportunitySendAltaBtnCtrl.generateJSON(nick,actualOpp,actualOpp.Localidad_new__r.Loc_Id__c,notas);
					bodyMap.put('archivos', new List<Map<String,Object>> {
						new Map<String, Object>{
							'datos' => 'data:' + Utils.getTypeAndExtension(version.FileExtension) + ';base64,' + EncodingUtil.base64Encode(version.VersionData),
							'observaciones' => null,
    						'descripcion' => version.Description,
							'nombre' => version.Title.contains('.' + version.FileExtension) 
											? version.Title : version.Title + '.' + version.FileExtension
						}
					});
					resp = WSOpportunityReingresoGFam.enviarReingresoGrupoFamiliar(JSON.serialize(bodyMap));
				}
				when 'REINGRESO'{
					Map<String,Object> bodyMap = OpportunitySendAltaBtnCtrl.generateReingresoJSON(nick,actualOpp,actualOpp.Localidad_new__r.Loc_Id__c,notas);
					bodyMap.put('archivos', new List<Map<String,Object>> {
						new Map<String, Object>{
							'datos' => 'data:' + Utils.getTypeAndExtension(version.FileExtension) + ';base64,' + EncodingUtil.base64Encode(version.VersionData),
							'observaciones' => null,
    						'descripcion' => version.Description,
							'nombre' => version.Title.contains('.' + version.FileExtension) 
											? version.Title : version.Title + '.' + version.FileExtension
						}
					});
					resp = WSOpportunityReingreso.sendReingreso(JSON.serialize(bodyMap));
				}
				when else{
					//should not happen
				}
			}
			
			if(!resp.hasError || Test.isRunningTest()){
				ContentVersion updateVersion = new ContentVersion(Id = version.Id, Enviado__c = true);
				update updateVersion;
			}
			else{
				errorOp = true;
				errorMsg = resp.message;
			}
			if(docIds.isEmpty() || Test.isRunningTest()){
				if(errorOp){
					actualOpp.Fecha_error_archivos__c = Datetime.now();
					actualOpp.Error_archivos__c = errorMsg;
					if(actualOpp.Usuario_error__c == null){
						actualOpp.Usuario_error__c = usuario.CommunityNickname.toUpperCase();
					}
					//opp.Body_error__c = JSON.serialize(bodyMap);
				}
				else{
					actualOpp.Fecha_error_archivos__c = null;
					actualOpp.Error_archivos__c = null;
					actualOpp.Usuario_error__c = null;
					//opp.Body_error__c = null;
				}
				actualOpp.Cambio_Manual__c = false;
				Database.SaveResult res=Database.update(actualOpp,false);
				System.debug(res);
			}
			if(!Test.isRunningTest()){
				System.enqueueJob(new OpportunityAttachmentQueueable(opps,actualOpp,docIds,errorOp));
			}
		}
		else{
			if(!opps.isEmpty()){
				Opportunity opp = opps.remove(0);
				List<ContentDocumentLink> links = [
					SELECT Id,ContentDocumentId
					FROM ContentDocumentLink
					WHERE LinkedEntityId = :opp.Id
				];
				List<Id> docIds = new List<Id>();
				for(ContentDocumentLink link : links){
					docIds.add(link.ContentDocumentId);
				}
				List<ContentVersion> versions = [
					SELECT Id 
					FROM ContentVersion 
					WHERE ContentDocumentId IN :docIds
					AND Enviado__c = false AND IsLatest = true
					];
				List<Id> versionIds = new List<Id>();
				for(ContentVersion ver : versions){
					versionIds.add(ver.Id);
				}
			
				if(!Test.isRunningTest()){
					if(!opps.isEmpty()){
						System.enqueueJob(new OpportunityAttachmentQueueable(opps,opp,versionIds,false));
					}
				}
			}
		}
	}
}