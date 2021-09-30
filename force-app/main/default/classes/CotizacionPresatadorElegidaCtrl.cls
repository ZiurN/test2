public class CotizacionPresatadorElegidaCtrl  {
	public ID ordenId {get; set;}
    public Cotizacion_Prestador__c cotizacion;
	public Orden_de_Compra__c ordenCompra;

    public Cotizacion_Prestador__c getCotizacion() {
        List<Cotizacion_Prestador__c> cotizaciones = [
			SELECT Id,Total_Socio__c, Total_Mejorado__c,Prestador__r.Name,
			Orden_de_Compra__r.Caso__c, (SELECT Id,Prestacion__r.Nombre_de_Prestacion__c FROM Presupuestos_de_Compras__r) 
			FROM Cotizacion_Prestador__c 
			WHERE Elige__c = true  AND Orden_de_Compra__c = :ordenId
		];
        if(!cotizaciones.isEmpty()){
			cotizacion = cotizaciones[0];
		}
		return cotizacion;
    }

	public Orden_de_Compra__c getOrdenCompra() {
        List<Orden_de_Compra__c> ordenes = [
			SELECT Id, forma_de_Pago__c
			FROM Orden_de_Compra__c 
			WHERE Id = :ordenId
		];
        if(!ordenes.isEmpty()){
			ordenCompra = ordenes[0];
		}
		return ordenCompra;
    }
}