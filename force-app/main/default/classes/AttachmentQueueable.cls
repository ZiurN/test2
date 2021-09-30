public class AttachmentQueueable implements Queueable, Database.AllowsCallouts {

	//public Map<String,Object> bodyMap;
	public List<Id> attachments;
	public Boolean errorOp;
	public Opportunity opp;
	public String errorMsg = '';
	public String nick;
	public String solafi;

	
	public AttachmentQueueable(String username, List<Id> attList, Opportunity oportunidad, String nroSol){
		attachments = attList;
		errorOp = false;
		opp = oportunidad;
		nick = username;
		solafi = nroSol;
	}


	public AttachmentQueueable(String username, List<Id> attList, Opportunity oportunidad, Boolean err, String msg, String nroSol){
		attachments = attList;
		opp = oportunidad;
		errorOp = err;
		nick = username;
		solafi = nroSol;
	}

	public void execute(QueueableContext context) {
		System.debug('Attachment ' + errorOp);
		if(!attachments.isEmpty()){
			Id versionId = attachments.remove(0);
			
			ContentVersion version = [SELECT Id, VersionData, Title,Enviado__c, FileExtension, Description FROM ContentVersion WHERE Id = :versionId];
			User usuario = [SELECT Id, CommunityNickname FROM User WHERE Id = :UserInfo.getUserId()];
			WSResult resp;
			List<Nota_de_Auditoria__c> notas = new List<Nota_de_Auditoria__c>();
			String title = Utils.getStringAlphanumericOnly(version.Title);

			if(title.length() > 44) {
				title = title.substring(0, 44);
			}

			switch on opp.Tipo_de_Solicitud__c{
				when 'ALTA'{
					Map<String,Object> bodyMap = OpportunitySendAltaBtnCtrl.generateJSON(nick,opp,opp.Localidad_new__r.Loc_Id__c,notas);
					bodyMap.put('archivos', new List<Map<String,Object>> {
						new Map<String, Object>{
							'datos' => 'data:' + Utils.getTypeAndExtension(version.FileExtension) + ';base64,' + EncodingUtil.base64Encode(version.VersionData),
							'observaciones' => null,
    						'descripcion' => version.Description,
							'nombre' => title.contains('.' + version.FileExtension) 
											? title.toUpperCase() : (title + '.' + version.FileExtension).toUpperCase()
						}
					});
					if(solafi != null){
						List<Object> encabezado = (List<Object>) bodyMap.get('encabezado');
						Map<String, Object> encabezadoMap = (Map<String, Object>) encabezado.remove(0);
						encabezadoMap.put('solicitud_id', solafi);
						encabezado.add(encabezadoMap);
						bodyMap.put('encabezado',encabezado);
					}
					resp = WSOpportunitySendAlta.sendAlta(JSON.serialize(bodyMap));
				}
				when 'REING_GFAM'{
					Map<String,Object> bodyMap = OpportunitySendAltaBtnCtrl.generateJSON(nick,opp,opp.Localidad_new__r.Loc_Id__c,notas);
					bodyMap.put('archivos', new List<Map<String,Object>> {
						new Map<String, Object>{
							'datos' => 'data:' + Utils.getTypeAndExtension(version.FileExtension) + ';base64,' + EncodingUtil.base64Encode(version.VersionData),
							'observaciones' => null,
    						'descripcion' => version.Description,
							'nombre' => title.contains('.' + version.FileExtension) 
											? title.toUpperCase() : (title + '.' + version.FileExtension).toUpperCase()
						}
					});
					resp = WSOpportunityReingresoGFam.enviarReingresoGrupoFamiliar(JSON.serialize(bodyMap));
				}
				when 'REINGRESO'{
					Map<String,Object> bodyMap = OpportunitySendAltaBtnCtrl.generateReingresoJSON(nick,opp,opp.Localidad_new__r.Loc_Id__c,notas);
					bodyMap.put('archivos', new List<Map<String,Object>> {
						new Map<String, Object>{
							'datos' => 'data:' + Utils.getTypeAndExtension(version.FileExtension) + ';base64,' + EncodingUtil.base64Encode(version.VersionData),
							'observaciones' => null,
    						'descripcion' => version.Description,
							'nombre' => title.contains('.' + version.FileExtension) 
											? title.toUpperCase() : (title + '.' + version.FileExtension).toUpperCase()
						}
					});
					resp = WSOpportunityReingreso.sendReingreso(JSON.serialize(bodyMap));
				}
				when else{
					//should not happen
				}
			}
			
			if(!resp.hasError || Test.isRunningTest()){
				//version.Enviado__c = true;
				//ContentVersion updateVersion = new ContentVersion();
				//updateVersion.Enviado__c = true;
				//updateVersion.VersionData = version.VersionData;
				//updateVersion.ContentDocumentId = version.ContentDocumentId;
				//updateVersion.Title = version.Title;
				//updateVersion.PathOnClient = version.PathOnClient;
				//insert updateVersion;
				ContentVersion updateVersion = new ContentVersion(Id = version.Id, Enviado__c = true);
				update updateVersion;
			}
			else{
				errorOp = true;
				errorMsg = resp.message;
			}
			if(!attachments.isEmpty() && !Test.isRunningTest()){
				System.enqueueJob(new AttachmentQueueable(nick, attachments, opp,errorOp,errorMsg, solafi));
			}
			else{
				if(errorOp){
					opp.Fecha_error_archivos__c = Datetime.now();
					opp.Error_archivos__c = errorMsg;
					if(opp.Usuario_error__c == null){
						opp.Usuario_error__c = usuario.CommunityNickname.toUpperCase();
					}
					//opp.Body_error__c = JSON.serialize(bodyMap);
				}
				else{
					opp.Fecha_error_archivos__c = null;
					opp.Error_archivos__c = null;
					opp.Usuario_error__c = null;
					//opp.Body_error__c = null;
				}
				opp.Cambio_Manual__c = false;
				update opp;
			}
		}
	}
}