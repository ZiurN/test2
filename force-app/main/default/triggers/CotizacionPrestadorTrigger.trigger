trigger CotizacionPrestadorTrigger on Cotizacion_Prestador__c (after insert)  { 
	if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			Map<String, Cotizacion_Prestador__c> caseIdCotizacionMap = new Map<String, Cotizacion_Prestador__c>();
            //------------------------ Hago esto porque no funciona la doble relacion con __r ------------------------
            Map<String, Cotizacion_Prestador__c> ordenIdCotizacionMap = new Map<String, Cotizacion_Prestador__c>();
            //--------------------------------------------------------------------------------------------------------
			for (Cotizacion_Prestador__c cp : Trigger.new) {
				//if (cp.Orden_de_Compra__r.Ap_orden__c != null) {
					//caseIdCotizacionMap.put(cp.Orden_de_Compra__r.Ap_orden__c, cp);
				//}
                //------------------------ Hago esto porque no funciona la doble relacion con __r ------------------------
				if (cp.Orden_de_Compra__c != null) {
                	ordenIdCotizacionMap.put(cp.Orden_de_Compra__c, cp);
                }
				//--------------------------------------------------------------------------------------------------------
			}
			if (!ordenIdCotizacionMap.isEmpty()) {
				CotizacionPrestadorHelper.createAsManyPresupuestosAsPrestacionesInCaseAc(ordenIdCotizacionMap);
			}
			
		}
	}
}