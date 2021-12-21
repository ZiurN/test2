public class MasterBatch implements Database.Batchable<Object>, Database.AllowsCallouts, Database.Stateful {
	public IMasterBuilder master {get; set;}
	public  MasterBatch(IMasterBuilder master) {
		this.master = master;
	}
	public Iterable<Object> start(Database.BatchableContext context) {
		List<Object> objects = master.callWebService();
		return objects;
	}
	public void execute(Database.BatchableContext context, List<Object> scope) {
		master.processResponse(scope);
	}
	public void finish(Database.BatchableContext context) {
		master.updateDate();
	}
}