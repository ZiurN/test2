public class CaseEmitirOrdenBtnCtrl  {
    static final String[] ADMIN_PROFILES = new List<String> {
        'Administrador del sistema', 
        'Administrador de Servicio',
        'CDC'
    };
    public static Id internacionRTId = XappiaHelper.getRecordType('Evento_Medico__c','Evento_medico_de_internacion').Id;
    @AuraEnabled
    public static Response changeStatusToOrdenEmitida(String caseId) {
        Case caso = [
            SELECT Status, RecordTypeId, Nivel_de_derivacion__c, Delegacion__r.Codigo_de_delegacion__c,
                Evento_Medico__c, Ap_autorizada__c, Nro_AP__c, Prestador__r.Correo_electronico__c, Type, 
                CaseNumber, Evento_Medico__r.Tipo__c,Evento_Medico__r.Estado__c, Evento_Medico__r.RecordTypeId,Correo_asociado__c, RecordType.Name, Codigo_Diag__c, 
                Orden_de_Compra__c
            FROM Case 
            WHERE Nro_AP__c =: caseId
        ];
        
        User usuario = [
            SELECT CommunityNickname, Profile.Name, UserRole.DeveloperName, Codigo_delegacion__c 
            FROM User 
            WHERE Id =: UserInfo.getUserId()
        ];
        
        String rtSeguimiento = XappiaHelper.getRecordType('Case', 'Seguimiento').Id;
        String rtInternacion = XappiaHelper.getRecordType('Case', 'Internacion').Id;
        
        Response validation = validatePermissions(usuario, caso);
        if(validation.message != 'ok') {
            return validation;
        }
    
        
        if(caso.RecordTypeId == rtSeguimiento) {
            return emitirOrdenSinEnviar(caso);
        }
        
        String body = JSON.serialize(new Map<String, Object> {'username' => usuario.CommunityNickname.toUpperCase()});
        
        WSCaseAPEmitirOrden.Response resp = WSCaseAPEmitirOrden.emitirOrden(caseId, body);
        if (!resp.hasError) {
            System.debug('****caso.Status: ' + caso.Status);
            System.debug('****resp: ' + resp.result.data);
            if(caso.Status != 'CA-----E' && (caso.Status == 'Autorizada' || caso.Ap_autorizada__c)) {
                List<ContentVersion> versions = new List<ContentVersion>();
                String registroId = caso.RecordTypeId == rtInternacion ? caso.Evento_Medico__c : caso.Id;
                
                caso.Cambio_Manual__c = false;
                //caso.Evento_Medico__r.Estado__c = 'Autorizado';
                caso.Status = 'CA-----E';
                
                
                for(WSCaseAPEmitirOrdenResp.Ordenes orden : resp.result.data.ap.ordenes){
                    versions.add(buildPDF(orden));
                }
                
                insert versions;
                
                List<Id> ids = new List<Id>();
                for(ContentVersion version : versions){
                    ids.add(version.Id);
                }
                
                List<ContentVersion> versionsUpdated = [
                    SELECT ContentDocumentId, VersionData, FileExtension
                    FROM ContentVersion
                    WHERE Id IN :ids
                ];
                
                List<ContentDocumentLink> links = new List<ContentDocumentLink>();
                for(ContentVersion ver : versionsUpdated){
                    links.add(new ContentDocumentLink(LinkedEntityId = registroId,
                                                        ShareType = 'V',
                                                        ContentDocumentId = ver.ContentDocumentId
                                                        ));
                }
                Database.SaveResult resultCaso = Database.update(caso);
                insert links;
                
                EmailUtils.MailResponse emailResp = sendEmail(caso, versionsUpdated);
                
                return new Response(false, 'ok');
            }
            return new Response(false, 'El estado debe ser diferente de orden emitida y debe estar autorizado');
            
        }
        return new Response(true, resp.message);
        
    }
    
    private static EmailUtils.MailResponse sendEmail(Case caso, ContentVersion[] versionsUpdated) {
        Boolean ret = false;
        
        if(isToSendToPrestador(caso) && !versionsUpdated.isEmpty()) {
            EmailUtils.MailResponse emailRespPrestador = EmailUtils.sendMailWithAttachment(
                new List<String>{caso.Prestador__r.Correo_electronico__c}, 
                versionsUpdated[0].VersionData,
                'Orden_' + caso.CaseNumber + '.' +  versionsUpdated[0].FileExtension,
                caso.Id,
                'Orden_emitida_con_adjuntos', 
                null
            ); 
            System.debug('****emailRespPrestador' + emailRespPrestador);
            ret |= emailRespPrestador.hasError;
        }

        if (isToSendToAasociado(caso) && !versionsUpdated.isEmpty()) {
            EmailUtils.MailResponse emailRespAsociado = EmailUtils.sendMailWithAttachment(
                new List<String>{caso.Correo_asociado__c}, 
                versionsUpdated[0].VersionData,
                'Orden_' + caso.CaseNumber + '.' +  versionsUpdated[0].FileExtension,
                caso.Id,
                'Notificacion_Ap_Emitida', 
                null
            ); 
            System.debug('****emailRespAsociado '+ emailRespAsociado);
            ret |= emailRespAsociado.hasError;
        }

        if (!ret) {
            return new EmailUtils.MailResponse(false, 'Mails enviados correctamente');
        }
        else {
            return new EmailUtils.MailResponse(true, 'Hubo un error al enviar los mails');
        }
    }
    
    private static Response validatePermissions(User usuario, Case caso) {
        List<GroupMember> grupo = new List<GroupMember>();
        Boolean hasPermission = ADMIN_PROFILES.contains(usuario.Profile.Name);
        
        if(usuario.CommunityNickname == null) {
            return new Response(false, '- El apodo(CommunityNickname) del usuario está vacío.');
        }
        
        //if( !Utils.perteneceALaDelegacionCorrecta(caso, usuario) ) {	
        //return new Response(false, 'El usuario puede modificar casos de su delegación solamente');
        //}
        
        if(caso.Nivel_de_derivacion__c == 'Nivel 1') {
            grupo = [SELECT Id FROM GroupMember WHERE Group.DeveloperName = 'Front' AND UserOrGroupId =: usuario.Id];
            
            if(grupo.isEmpty() && !hasPermission) {
                return new Response(false, '- El usuario no pertenece a Front');
            }
        } 
        else if(caso.Nivel_de_derivacion__c == 'Nivel 2') {
            grupo = [SELECT Id FROM GroupMember WHERE Group.DeveloperName = 'Mesa_de_ayuda' AND UserOrGroupId =: usuario.Id];
            
            if(grupo.isEmpty() && !hasPermission) {
                return new Response(false, '- El usuario no pertenece a Mesa de Ayuda');
            }
        } 
        else if(caso.Nivel_de_derivacion__c == 'Nivel 3') {
            List<CaseTeamMember> equipo = [
                SELECT MemberId
                FROM CaseTeamMember
                WHERE ParentId =: caso.Id AND MemberId =: usuario.Id
            ];
            
            if(equipo.isEmpty() && !hasPermission) {
                //if(equipo.isEmpty()) {
                return new Response(false, '- El usuario no pertenece al equipo del caso');
            }
        }
        
        return new Response(false, 'ok');
    }
    
    public static ContentVersion buildPDF(WSCaseAPEmitirOrdenResp.Ordenes orden){
        ContentVersion version = new ContentVersion();
        version.PathOnClient = '/' + orden.oca_id + '.pdf';
        version.origin = 'H';
        
        version.Title = 'Orden_' + orden.oca_id + '.pdf';
        String formattedLink = orden.link_orden;
        PageReference pdf = new PageReference(formattedLink);
        Blob pdfBody;
        try {
            pdfBody = pdf.getContentAsPDF();
        } catch (Exception e) {
            pdfBody = Blob.valueOf('No se pudo generar el archivo pdf');
            System.debug(e.getMessage());
        }
        
        version.VersionData = pdfBody;
        return version;
    }
    
    private static Response emitirOrdenSinEnviar(Case caso) {
        if(caso.Status == 'Autorizada' || caso.Ap_autorizada__c) {
            caso.Cambio_Manual__c = false;
            caso.Status = 'CA-----E';

            System.debug('entra aqui');
            Database.SaveResult resultCaso = Database.update(caso);
            
            return new Response(false, 'ok');
            
        } else {
            return new Response(false, 'El estado debe estar autorizado para poder emitir la orden');
        }
    }

    public static Boolean isToSendToAasociado(Case caso) {
        return caso.Evento_Medico__r.Tipo__c != 'COVID' 
                && caso.Evento_Medico__r.Tipo__c != 'Oxigenoterapia'
                //&& caso.Evento_Medico__r.Tipo__c != 'Discapacidad'
                && caso.Evento_Medico__r.RecordTypeId != internacionRTId
                && caso.Status == 'CA-----E' 
                && caso.Codigo_Diag__c != 'U07.1'
                && caso.Codigo_Diag__c != 'U07.2' 
                && caso.Type != 'COVID'
                && String.isBlank(caso.Orden_de_Compra__c) 
                && String.isNotBlank(caso.Correo_asociado__c); 
    }

    public static Boolean isToSendToPrestador(Case caso) {
        return String.isNotBlank(caso.Prestador__r.Correo_electronico__c)
                && (
                    caso.Evento_Medico__r.Tipo__c == 'Oxigenoterapia'
                    || caso.Evento_Medico__r.Tipo__c == 'COVID' 
                );
                //&& caso.Evento_Medico__r.Tipo__c != 'Discapacidad';
    }
    
    public class Response {
        @AuraEnabled public Boolean hasError;
        @AuraEnabled public String message;
        //@AuraEnabled public List<WSAsociadoGetPromotoresResp.Data> asociadoPromotores;
        
        public Response(Boolean hasError, String message){
            this.hasError = hasError;
            this.message = message;
        }
    }  
}