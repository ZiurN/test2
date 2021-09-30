trigger PresupuestoCompraTrigger on Presupuesto_de_Compra__c (after insert, after update, after delete, after undelete,
                                                                before insert, before update, before delete) {
    if (System.Trigger.isBefore) {
        if (System.Trigger.isInsert) {
            //Before Insert
        }
        else if (System.Trigger.isDelete) {
        }
    }
    else if (System.Trigger.isAfter) {
        if (System.Trigger.isUpdate) {
            PresupuestoCompraHelper.RecalcularCotizacionPrestador(System.Trigger.New);
        }
        else if (System.Trigger.isDelete) {
            PresupuestoCompraHelper.RecalcularCotizacionPrestador(System.Trigger.Old);
        }
    }                          
}