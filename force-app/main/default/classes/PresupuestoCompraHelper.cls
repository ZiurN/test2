public class PresupuestoCompraHelper {
    public static void RecalcularCotizacionPrestador(List<Presupuesto_de_Compra__c> pres) {
        Set<ID> cotizToUpdate = new Set<ID>();
        
		for(Presupuesto_de_Compra__c presupuesto :pres){
            cotizToUpdate.add(presupuesto.Cotizacion_Prestador__c);
        }

        Map<ID, Cotizacion_Prestador__c> cotiz = new Map<ID, Cotizacion_Prestador__c>();
        List<Cotizacion_Prestador__c> cotizaciones = [
			SELECT id, Total_Presupuesto__c, Total_mejorado__c, Total_Socio__c, Orden_de_Compra__r.forma_de_Pago__c
			FROM Cotizacion_Prestador__c 
			WHERE Id IN :cotizToUpdate
		];
        List<Presupuesto_de_Compra__c> presupuestos = [
			SELECT id, Cotizacion_Prestador__c, Importe_unitario__c, Importe_mejorado__c, Cargo_al_socio__c 
			FROM Presupuesto_de_Compra__c 
			WHERE Cotizacion_Prestador__c IN :cotizToUpdate
		];
        
		for (Cotizacion_Prestador__c cotizacion : cotizaciones) {
            Integer cantidadDePresupuestosPorCotizacion = 0;
			Boolean pagoPrest = cotizacion.Orden_de_Compra__r.forma_de_Pago__c == 'Prestador';

            for(Presupuesto_de_Compra__c thisPres : presupuestos){
                if(thisPres.Cotizacion_Prestador__c == cotizacion.Id){
                    if(cotiz.containsKey(thisPres.Cotizacion_Prestador__c)) {
                        Cotizacion_Prestador__c thisCotiz = cotiz.get(thisPres.Cotizacion_Prestador__c);

						System.debug('Total: ' + thisCotiz.Total_Presupuesto__c);
						System.debug('Unitario: ' + thisPres.Importe_unitario__c);
                        thisCotiz.Total_Presupuesto__c = ifNullReturnCero(thisCotiz.Total_Presupuesto__c) 
														+ ifNullReturnCero(thisPres.Importe_unitario__c);
                        thisCotiz.Total_Mejorado__c = ifNullReturnCero(thisCotiz.Total_Mejorado__c) 
													+ ifNullReturnCero(thisPres.Importe_mejorado__c);
                        thisCotiz.Total_Socio__c = ifNullReturnCero(thisCotiz.Total_Socio__c) 
													+ ifNullReturnCero(thisPres.Cargo_al_socio__c);
						thisCotiz.Total_a_Pagar__c = !pagoPrest ? ifNullReturnCero(thisCotiz.Total_Mejorado__c) 
							: ifNullReturnCero(thisCotiz.Total_Mejorado__c) - ifNullReturnCero(thisCotiz.Total_Socio__c);

                        cotiz.put(thisPres.Cotizacion_Prestador__c, thisCotiz);
                    } else {
                        cotizacion.Total_Presupuesto__c = ifNullReturnCero(thisPres.Importe_unitario__c);
                        cotizacion.Total_Mejorado__c = ifNullReturnCero(thisPres.Importe_mejorado__c);
                        cotizacion.Total_Socio__c = ifNullReturnCero(thisPres.Cargo_al_socio__c);
						cotizacion.Total_a_Pagar__c = !pagoPrest ? ifNullReturnCero(cotizacion.Total_Mejorado__c)
							: ifNullReturnCero(cotizacion.Total_Mejorado__c) - ifNullReturnCero(cotizacion.Total_Socio__c);
						
                        cotiz.put(thisPres.Cotizacion_Prestador__c, cotizacion);
                    }
                    cantidadDePresupuestosPorCotizacion = cantidadDePresupuestosPorCotizacion + 1;
                } else {
                    break;
                }
            }
            if(cantidadDePresupuestosPorCotizacion == 0 ){
                cotizacion.Total_Presupuesto__c = 0;
                cotizacion.Total_Mejorado__c = 0;
                cotizacion.Total_Socio__c = 0;
				//cotizacion.Total_a_Pagar__c = 0;

                cotiz.put(cotizacion.Id, cotizacion);
            }
        }
        List<Cotizacion_Prestador__c> cotizacionesParaActualizar = new List<Cotizacion_Prestador__c>();
        for (ID thisCotiz :cotiz.keySet()){
            cotizacionesParaActualizar.add(cotiz.get(thisCotiz));
        }
        update cotizacionesParaActualizar;
    }

	private static Decimal ifNullReturnCero(Decimal num) {
		return num != null ? num : 0;
	}
}