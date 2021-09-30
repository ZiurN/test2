public class ClausulaTempQueueable implements Queueable, Database.AllowsCallouts{
    public List<Asignacion_de_clausula_temporaria__c> clausulas;

    public ClausulaTempQueueable (List<Asignacion_de_clausula_temporaria__c> clausulasList){
        this.clausulas = clausulasList;
    }
    
    public void execute(QueueableContext context) {
        Asignacion_de_clausula_temporaria__c clausula = clausulas.remove(0);
        Asignacion_de_clausula_temporaria__c clausulaToUpdate = ClausulasTempTriggerHelper.updateClausula(clausula);
       
        update clausulaToUpdate;
        
        if(!clausulas.isEmpty()){
            System.enqueueJob(new ClausulaTempQueueable(clausulas));
        }  
    }
}