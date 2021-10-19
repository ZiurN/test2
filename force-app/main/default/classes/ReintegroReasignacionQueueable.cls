public class ReintegroReasignacionQueueable  implements Queueable, Database.AllowsCallouts{

	List<Case> reintegros;

	public ReintegroReasignacionQueueable(List<Case> casos){
		reintegros = casos;
	}

	public void execute(QueueableContext context) {
		if(!reintegros.isEmpty()){
			User usuario = [SELECT CommunityNickname FROM User WHERE Id =:UserInfo.getUserId()];
			String nick = usuario.CommunityNickname.toUpperCase();
			Case reintegro = reintegros.remove(0).clone(true,true,false,false);
			CaseHelper.reasignarLote(reintegro, nick);
			update reintegro;
			if(!reintegros.isEmpty()){
				System.enqueueJob(new ReintegroReasignacionQueueable(reintegros));
			}
		}
	}

}