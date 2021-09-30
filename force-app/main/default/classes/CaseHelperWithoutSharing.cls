public without sharing class CaseHelperWithoutSharing {
    public static List<String> nombresColas = new List<String>{'Front','CDC'};
    public static Map<Id,Group> namesColas = new Map<Id,Group>([SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue' AND DeveloperName IN :nombresColas]);
    public static Id solicitudDespegueRTId = XappiaHelper.getRecordType('Case','Solicitud_de_despegues').Id;
    public static Id solicitudDatosParticulares = XappiaHelper.getRecordType('Case','Solicitud_de_datos_particulares').Id;
    public static Id delegacionRTId = XappiaHelper.getRecordType('Account','Delegacion').Id;


    public static void changeStateToDefaultPicklist(List<Case> listCasos){
        for(Case caso : listCasos){
            Case dummyCase = (Case)Case.sObjectType.newSObject(caso.RecordTypeId,true);
            caso.Cambio_Manual__c = false;
            caso.Status = dummyCase.Status;
            if(caso.RecordTypeId == solicitudDespegueRTId){
                if(caso.Type != 'FT' && caso.Type != 'CT'){
                    caso.Calle__c = null;
                    caso.Numero__c = null;
                    caso.SuppliedEmail = null;
                    caso.Telefono__c = null;
                    caso.Piso__c = null;
                    caso.Provincia__c = null;
                    caso.Dpto__c = null;
                    caso.Localidad__c = null;
                }   
            }
        }      
    }
    
    public static void cambiarDelegacionCDC(List<Case> listCasos){
        Set<Id> idUserOwner = new Set<Id>();
        Set<Id> idAccountAsociada = new Set<Id>();
        Map<Id,String> mapNombreCola = new Map<Id,String>();

        for(Case caso : listCasos){
            String strObjPrefix = String.valueOf(caso.OwnerId).substring(0, 3);
            if(strObjPrefix == User.sObjectType.getDescribe().getKeyPrefix()){
                System.debug('Entro al usuario ' + caso.OwnerId);
                idUserOwner.add(caso.OwnerId);
            }else if(strObjPrefix == Group.sObjectType.getDescribe().getKeyPrefix()){
                System.debug('Este es el grupo/cola ' + namesColas.get(caso.OwnerId));
                mapNombreCola.put(caso.OwnerId,namesColas.get(caso.OwnerId).DeveloperName);
            }    
        }

       List<User> userRetrieved = [
            SELECT Id, ProfileId
            FROM User
            WHERE Id IN :idUserOwner
        ];

        if(!userRetrieved.isEmpty()){
            Set<Id> setProfileId = new Set<Id>();
            for(User u : userRetrieved){
                setProfileId.add(u.ProfileId);
            }
            Map<Id,Profile> profilesRetrieved = new Map<Id,Profile>([
                SELECT Id,Name
                FROM Profile
                WHERE Id IN :setProfileId
            ]);
            System.debug('perfiles ' + profilesRetrieved);
            for(User u :userRetrieved){
                if(profilesRetrieved.containsKey(u.ProfileId)){
                    Profile p = profilesRetrieved.get(u.ProfileId);
                    mapNombreCola.put(u.Id,p.Name);
                }   
            }
        }

        System.debug('map id user ' + mapNombreCola);
        if(!mapNombreCola.isEmpty()){
            Set<Id> setIdsAccount = new Set<Id>();
            Map<Id,Account> mapAccount = new Map<Id,Account>();

            for(Case caso : listCasos){
                String nombreCola = mapNombreCola.get(caso.OwnerId);
                System.debug('Nombre perfil ' + nombreCola);
                if(nombreCola == 'CDC'){
                    if(caso.AccountId != null){
                        setIdsAccount.add(caso.AccountId);
                    }                    
                }
            }

            if(!setIdsAccount.isEmpty()){
                
                mapAccount.putAll([
                    SELECT Id,Delegacion__c,Delegacion__r.Type,Delegacion__r.Delegacion2__c
                    FROM Account 
                    WHERE Id IN :setIdsAccount
                ]);
                for(Case caso : listCasos){ 
                    if(caso.AccountId != null && mapAccount.containsKey(caso.AccountId)){
                        Account asociado = mapAccount.get(caso.AccountId);
                        if(asociado.Delegacion__r.Type == 'Filial'){
                            caso.Delegacion__c = asociado.Delegacion__c;
                        }else{
                            caso.Delegacion__c = asociado.Delegacion__r.Delegacion2__c;
                        }     
                    }
                }
            }
        }    
    }

    @future    
    public static void cambiarDelegacionFront(List<Id> listCasosId){

   
        Group colaCdc = [
            SELECT Id 
            FROM Group
            WHERE Type = 'Queue'
            AND DeveloperName = 'CDC'
        ];
        
        Map<Id,String> mapNombreCola = new Map<Id,String>();
        List<Case> listCasos = [
            SELECT Id,OwnerId,Delegacion__c,AccountId
            FROM Case
            WHERE Id IN :listCasosId
        ];

        for(Case caso : listCasos){
            String strObjPrefix = String.valueOf(caso.OwnerId).substring(0, 3);
            /*if(strObjPrefix == User.sObjectType.getDescribe().getKeyPrefix()){
                System.debug('Entro al usuario ' + caso.OwnerId);
                idUserOwner.add(caso.OwnerId);
            }else*/if(strObjPrefix == Group.sObjectType.getDescribe().getKeyPrefix()){
                System.debug('Este es el grupo/cola ' + namesColas.get(caso.OwnerId));
                mapNombreCola.put(caso.OwnerId,namesColas.get(caso.OwnerId).DeveloperName);
            }    
        }

        System.debug('map id user ' + mapNombreCola);
        if(!mapNombreCola.isEmpty()){
            
            Set<Id> setIdsAccount = new Set<Id>();
            Set<Id> setIdsCasoToSearchEmail = new Set<Id>();
            List<Case> casesWithoutDelegacion = new List<Case>();
            Map<Id,Account> mapAccount = new Map<Id,Account>();

            for(Case caso : listCasos){
                
                String nombreCola = mapNombreCola.get(caso.OwnerId);
                System.debug(nombreCola);
                if(nombreCola == 'Front'){
                    setIdsAccount.add(caso.AccountId);
                    setIdsCasoToSearchEmail.add(caso.Id);
                }
            }

            if(!setIdsCasoToSearchEmail.isEmpty()){
                Map<Id, List<Case>> userIdCasesMap = new Map<Id, List<Case>>();
                Map<String,Id> mapAccountEmail = new Map<String,Id>();
                Map<Id,String> lstEmailRelacionados = new Map<Id,String>();
                for(EmailMessage em : [SELECT Id, ToAddress, ParentId FROM EmailMessage WHERE ParentId IN :setIdsCasoToSearchEmail]){
                    System.debug(em.ToAddress);
                    if(em.ToAddress != ''){
                        List<String> lstEmail = em.ToAddress.split(';');
                        lstEmailRelacionados.put(em.ParentId,lstEmail.get(0));
                    }else{
                        lstEmailRelacionados.put(em.ParentId,em.ToAddress);
                    }
                }
                for(Account acc : [ 
                    SELECT Id,Correo_electronico__c,Delegacion__c, RecordTypeId,Type
                    FROM Account
                    WHERE Correo_electronico__c IN :lstEmailRelacionados.values() AND RecordTypeId = :delegacionRTId AND Type = 'Filial' 
                    ORDER BY CreatedDate DESC
                ]){
                    
                    mapAccountEmail.put(acc.Correo_electronico__c,acc.Id);
                }
                
                List<Case> casesToUpdate = new List<Case>();
                for(Case caso : listCasos){
                    if(lstEmailRelacionados.containsKey(caso.Id)){
                        String email = lstEmailRelacionados.get(caso.Id);
                        if(mapAccountEmail.containsKey(email)){
                            System.debug(mapAccountEmail.get(email));
                            caso.Delegacion__c = mapAccountEmail.get(email);
                        }else {               
                            
                            caso.OwnerId = colaCdc.Id; 
                                      	
                            if (userIdCasesMap.containsKey(caso.OwnerId)) {
                                List<Case> casesFromMap = userIdCasesMap.get(caso.OwnerId);
                                casesFromMap.add(new Case(Id = caso.Id));
                                userIdCasesMap.put(caso.OwnerId, casesFromMap);
                            } else {
                                userIdCasesMap.put(caso.OwnerId, new List<Case>{new Case(Id = caso.Id)});
                            }
                        }
                        casesToUpdate.add(caso);
                    }
                }
                if(!casesToUpdate.isEmpty()){
                    update casesToUpdate;
                }
                if(!userIdCasesMap.isEmpty()){
                    CaseHelper.assignDelegacionFromUser(userIdCasesMap);
                }  
               
            }
        }    
    }
}