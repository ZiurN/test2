public class CotizacionPrestadorHelper  {
	public static void createAsManyPresupuestosAsPrestacionesInCaseAc(Map<String, Cotizacion_Prestador__c> ordenIdCotizacionMap) {
		Map<String, Cotizacion_Prestador__c> caseIdCotizacionMap = new Map<String, Cotizacion_Prestador__c>();
		Map<String, String> caseIdDescripcion = new Map<String, String>();

        for(Case caso : [
			SELECT Orden_de_Compra__c, Description FROM Case WHERE Orden_de_Compra__c IN :ordenIdCotizacionMap.keySet()]
		) {
            caseIdCotizacionMap.put(caso.Id, ordenIdCotizacionMap.get(caso.Orden_de_Compra__c));
			caseIdDescripcion.put(caso.Id, caso.Description);
		}
			
		List<Presupuesto_de_Compra__c> presupuestosList = new List<Presupuesto_de_Compra__c>();
			
		for (Prestacion__c prestacion : [SELECT Ap__c FROM Prestacion__c WHERE Ap__c IN :caseIdCotizacionMap.keySet()] ) {
			Presupuesto_de_Compra__c presupuesto = new Presupuesto_de_Compra__c();
			presupuesto.Cotizacion_Prestador__c = caseIdCotizacionMap.get(prestacion.Ap__c).Id;
			presupuesto.Descripcion__c = caseIdDescripcion.get(prestacion.Ap__c);
			presupuesto.Prestacion__c = prestacion.Id;

			presupuestosList.add(presupuesto);
		}
		if (!presupuestosList.isEmpty()) {
			insert presupuestosList;
		}
	}
}