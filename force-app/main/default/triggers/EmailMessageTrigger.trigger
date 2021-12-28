trigger EmailMessageTrigger on EmailMessage (before insert,
												before update,
												before delete,
												after insert,
												after update,
												after delete,
												after undelete) {
	/*System.debug('Trigger');
	//System.debug(Trigger.new[0].HtmlBody);
	String regExp = '(?<=documentforce\\.com\\/sfc\\/servlet\\.shepherd\\/version\\/download\\/).{15,18}(?=\\?)';
	//List<String> results = Trigger.new[0].HtmlBody.split(regExp);
	//System.debug(results);

	Pattern p = Pattern.compile(regExp);
	Matcher m = p.matcher(Trigger.new[0].HtmlBody);
	Set<Id> listIDs = new Set<Id>();
	while(m.find()) {
		System.debug(m.group(0));
		listIDs.add(m.group(0));
	}
	System.debug(Trigger.new[0].ParentId);
	String id1 = Trigger.new[0].ParentId;
	List<ContentVersion> contentVs= [SELECT ContentDocumentId, Titulo_original__c, Enviando_por_email__c FROM ContentVersion WHERE Id IN :listIDs];
	for (ContentVersion cv: contentVs) {
		cv.Enviando_por_email__c = true;
	}
	update contentVs;*/
}
