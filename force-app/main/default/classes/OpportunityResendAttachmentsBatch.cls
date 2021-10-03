global class OpportunityResendAttachmentsBatch implements Database.Batchable<sObject> {


	global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
			SELECT Id, Medio_de_cobro__c, Fecha_de_vigencia_de_solicitud__c, Plan_del_grupo_familiar__c, Segmento_del_Grupo_Familiar__c,
				Tipo_de_Solicitud__c, Agencia__r.Codigo_de_delegacion__c, Obra_social_del_titular__r.Codigo_de_obra_social__c, Estado_Civil__c,
				Sexo__c, Fecha_de_Nacimiento__c, Nacionalidad__c, Localidad__c, Calle__c, Numero_de_documento__c, Piso__c, Tipo_de_Documento__c,
				Nmero_de_tarjeta_de_credito__c, Indicador_de_contratacion_de_emergencia__c, Indicador_de_Afiliacion_de_Inmediata__c, Account.Type,
				Account.LastName, Account.FirstName, Account.PersonEmail, Account.Phone, Account.PersonDepartment, Account.Actividad_codigo__c,
				Account.Tipo_de_Telefono__c, Account.Referido__c, Account.Codigo_de_Afiliado__c, Account.Parentesco__c, Nro_CBU_para_cobro_de_cuota__c, 
				Aportes_del_titular__c, Nro_de_solicitud__c, ActividadProfesion_del_titular__c, RecordTypeId, Description, CUIT__c,Codigo_de_empresa__c,
				Condicion_IVA__c, Numero__c, Codigo_Postal__c, Cotizacion_elegida__r.CP__c, Cotizacion_elegida__r.Provincia__c, Tipo_CBU__c,
				Cotizacion_elegida__r.Telfono__c, Cotizacion_elegida__r.Tipo_de_Telefono__c, Cotizacion_elegida__r.Correo_electronico__c,
				Usuario_error__c,
				Nro_asociado_titular_anterior__c, Amount, StageName, Tarjeta_de_credito__c, Reingresa_como__c, Cotizacion_elegida__c,Cobertura_anterior__c,
				Cotizacion_elegida__r.Plan_a_cotizar__c, Localidad_new__c, Localidad_new__r.Codigo_Postal__c, Localidad_new__r.Loc_Id__c, 
				Localidad_new__r.Organizador_lookup__c, Dpto__c, Telefono__c, Correo_Electronico__c, LeadSource, Edad__c, Tipo_de_Asociado__c,Name,
				Apellido_INDCOR__c, Nombre_INDCORP__c,Cotizacion_elegida__r.Tipo_de_afiliado__c,Subestado_de_DDJJ__c,Cobertura_anterior__r.Codigo_de_obra_social__c,
				(
					SELECT Apellido__c, Nombre__c, Indicador_de_aporte__c, Tipo_de_relacion_con_titular__c, Nacionalidad__c, Integrante_tipo_asociado__c,
						Fecha_de_Nacimiento__c, Sexo__c, Estado_Civil__c, Nro_de_documento__c, Tipo_de_Documento__c, Aportes__c, Edad__c,
						CUIT_Sin_guiones__c, Nro_de_asociado__c,Obra_social_actual__r.Codigo_de_obra_social__c,Discapacitado__c
					FROM Integrantes__r
				)
			FROM Opportunity
			WHERE Error_archivos__c != null
		]
        );
    }
    global void execute(Database.BatchableContext bc, List<Opportunity> records){
		Opportunity opp = records.remove(0);
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
			

		System.enqueueJob(new OpportunityAttachmentQueueable(records,opp,versionIds,false));

		//List<Id> oppIds = new List<Id>();
		//for(Opportunity opp : records){
			//oppIds.add(opp.Id);
		//}
		//List<ContentDocumentLink> links = [SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN :oppIds];
		//Map<Id,Id> oppDocMap = new Map<Id, Id>();
		//for(ContentDocumentLink link : links){
			//oppDocMap.put(link.ContentDocumentId,link.LinkedEntityId);
		//}
		//List<ContentVersion> documents = [SELECT Id, VersionData, ContentDocumentId, Description, Title, FileExtension,PathOnClient FROM ContentVersion WHERE ContentDocumentId IN :oppDocMap.keySet() AND Enviado__c = false AND IsLatest = true];
		//Map<Id,List<Id>> oppAttachmentsMap = new Map<Id,List<Id>>();

		//for(ContentVersion ver : documents){
			//if(oppAttachmentsMap.containsKey(oppDocMap.get(ver.ContentDocumentId))){
				//List<Id> docs = oppAttachmentsMap.get(oppDocMap.get(ver.ContentDocumentId));
				//docs.add(ver.Id);
				//oppAttachmentsMap.put(oppDocMap.get(ver.ContentDocumentId),docs);
			//}
			//else{
				//List<Id> docs = new List<Id>{ver.Id};
				//oppAttachmentsMap.put(oppDocMap.get(ver.ContentDocumentId),docs);
			//}
		//}

        //for(Opportunity opp : records){
			
			//System.enqueueJob(new AttachmentQueueable(opp.Usuario_error__c, oppAttachmentsMap.get(opp.Id), opp,null));
		//}
    }    
    global void finish(Database.BatchableContext bc){
    }   
}