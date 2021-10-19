public class NotaCOBPROTCtrl  {

	public ID apId {get; set;}
    public Nota_de_Auditoria__c nota;

    public Nota_de_Auditoria__c getNota() {
        List<Nota_de_Auditoria__c> notas = [SELECT Id,Nota__c FROM Nota_de_Auditoria__c WHERE Tipo_nota_de_Auditoria__r.Codigo_tipoNA__c = 'NOT_COB_PROT' AND APr_Id__c = :apId];
        if(!notas.isEmpty()){
			nota = notas[0];
		}
		return nota;
    }

}