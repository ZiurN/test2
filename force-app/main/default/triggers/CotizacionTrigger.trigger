trigger CotizacionTrigger on Cotizacion__c (before insert, before update, after update)  {

	if(Trigger.isBefore){
		if(Trigger.isInsert){
			//Map<String,Cotizacion__c> cpCotizacionMap = new Map<String,Cotizacion__c>();
			//for(Cotizacion__c cot : Trigger.new){
				//cpCotizacionMap.put(cot.CP__c,cot);
			//}
			//List<Localidad__c> localidades = [SELECT Loc_Id__c,Codigo_Postal__c,Nombre_de_Localidad__c FROM Localidad__c WHERE Codigo_Postal__c IN :cpCotizacionMap.keySet()];
			//for(Localidad__c loc : localidades){
				//cpCotizacionMap.get(loc.Codigo_Postal__c).LocId__c = loc.Loc_Id__c;
				//cpCotizacionMap.get(loc.Codigo_Postal__c).Localidad__c = loc.Nombre_de_Localidad__c;
			//}

			List<Id> localidadesId = new List<Id>();
			for(Cotizacion__c cot  : Trigger.new){
				if(cot.RecordTypeId == XappiaHelper.getRecordType('Cotizacion__c','Cotizacion_Individual').Id){
					CotizacionTriggerHelper.validateCotizacion(cot);
				}
				if(cot.Localidad_new__c != null){
					
					localidadesId.add(cot.Localidad_new__c);
				}
			}
			Map<Id,Localidad__c> localidadesMap = new Map<Id,Localidad__c>([
				SELECT Id, Codigo_de_Provincia__c, Codigo_Postal__c, Loc_Id__c, Organizador_lookup__c, ZG_Codigo__c
				FROM Localidad__c
				WHERE Id IN : localidadesId
			]);
			Map<String, Lead> locIdLeadsMap = new Map<String, Lead>();
			for(Cotizacion__c cot : Trigger.new){
				Localidad__c loc;
				if(cot.Localidad_new__c != null){
					loc = localidadesMap.get(cot.Localidad_new__c);
					System.debug(loc);
					cot.Provincia_lista__c  = loc.Codigo_de_Provincia__c;
					cot.LocId__c = loc.Loc_Id__c;
				}
			}

		}
		if(Trigger.isUpdate){
			//Map<String,Cotizacion__c> cpCotizacionMap = new Map<String,Cotizacion__c>();
			//for(Cotizacion__c cot : Trigger.new){
				//if(Trigger.oldMap.get(cot.Id).CP__c != cot.CP__c && cot.CP__c != null){
					//cpCotizacionMap.put(cot.CP__c,cot);
				//}
			//}
			//if(!cpCotizacionMap.isEmpty()){
				//List<Localidad__c> localidades = [SELECT Loc_Id__c,Codigo_Postal__c,Nombre_de_Localidad__c FROM Localidad__c WHERE Codigo_Postal__c IN :cpCotizacionMap.keySet()];

				//for(Localidad__c loc : localidades){
					//cpCotizacionMap.get(loc.Codigo_Postal__c).LocId__c = loc.Loc_Id__c;
					//cpCotizacionMap.get(loc.Codigo_Postal__c).Localidad__c = loc.Nombre_de_Localidad__c;

				//}
			//}
			List<Id> localidadesId = new List<Id>();
			for(Cotizacion__c cot  : Trigger.new){
				if(cot.Localidad_new__c != null){
					localidadesId.add(cot.Localidad_new__c);
				}
			}
			Map<Id,Localidad__c> localidadesMap = new Map<Id,Localidad__c>([
				SELECT Id, Codigo_de_Provincia__c, Codigo_Postal__c, Loc_Id__c, Organizador_lookup__c, ZG_Codigo__c
				FROM Localidad__c
				WHERE Id IN : localidadesId
			]);
			Map<String, Lead> locIdLeadsMap = new Map<String, Lead>();
			for(Cotizacion__c cot : Trigger.new){
				Localidad__c loc;
				System.debug(cot.Localidad_new__c);
				System.debug(localidadesMap);
				if(cot.Localidad_new__c != null && cot.Localidad_new__c != Trigger.oldMap.get(cot.Id).Localidad_new__c){
					loc = localidadesMap.get(cot.Localidad_new__c);
					System.debug(loc);
					cot.Provincia_lista__c  = loc.Codigo_de_Provincia__c;
					cot.LocId__c = loc.Loc_Id__c;
				}
			}
		}
	}
	if(Trigger.isAfter){

		if(Trigger.isUpdate){
			Map<Id, Cotizacion__c> cotizaciones = new Map<Id, Cotizacion__c>();
			List<Id> oppsId = new List<Id>();
			for(Cotizacion__c cot : Trigger.new){
				oppsId.add(cot.Oportunidad__c);
			}
			Map<Id,Opportunity> opps = new Map<Id,Opportunity>([
				SELECT Cotizacion_elegida__c,Id
				FROM Opportunity
				WHERE Id IN :oppsId
			]);
			
			for(Cotizacion__c cot : Trigger.new){
				if(cot.Oportunidad__c != null && opps.get(cot.Oportunidad__c).Cotizacion_elegida__c == cot.Id && cot.RecordTypeId == XappiaHelper.getRecordType('Cotizacion__c','Cotizacion_Individual').Id){
					cotizaciones.put(cot.Oportunidad__c, cot);
				}
			}

			List<Opportunity> oportunidades = new List<Opportunity>();

			if(!cotizaciones.isEmpty()){
				oportunidades = [SELECT Id, Amount FROM Opportunity WHERE Id IN :cotizaciones.keySet()];
				for(Opportunity opp : oportunidades){
					opp.Amount = cotizaciones.get(opp.Id).Diferencia_a_pagar__c != null ?Decimal.valueOf(cotizaciones.get(opp.Id).Diferencia_a_pagar__c) : null;
				}
			}
			update oportunidades;
		}
	}
}