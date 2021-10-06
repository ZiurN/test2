
private Class objectToUpdate {
	attributes attributes;
	String ApexClassId;
	String ApexTestSuiteId;
}
private Class attributes {
	String type;
	String referenceId;
	public attributes(String type, String referenceId) {
		this.type = type;
		this.referenceId = referenceId;
	}
}
ApexTestSuite ts = [SELECT Id FROM ApexTestSuite WHERE TestSuiteName = 'LocalTests'];
List<TestSuiteMembership> testsInSuite = [SELECT Id, ApexTestSuiteId, ApexClassId FROM TestSuiteMembership WHERE ApexTestSuiteId =: ts.Id];
List<Id> ApexTestsIdsInSuite = new List<Id>();
for (TestSuiteMembership testSuiteMember : testsInSuite) {
	ApexTestsIdsInSuite.add(testSuiteMember.ApexClassId);
}

List<ApexClass> ac = [SELECT Id, Name, Body FROM ApexClass WHERE NamespacePrefix = ''];
List<ApexClass> testClasses = new List<ApexClass>();
List<objectToUpdate> testSuiteMembershipList = new List<objectToUpdate>();

objectToUpdate objectToUpdate;
Integer contador = 0;
for(ApexClass a : ac){
    if(((a.Body.containsIgnoreCase('@istest') || a.Body.contains('static testmethod'))) && !ApexTestsIdsInSuite.contains(a.Id)){
		contador  += 1;
        objectToUpdate = new objectToUpdate();
        objectToUpdate.ApexClassId = a.Id;
        objectToUpdate.ApexTestSuiteId = ts.Id;
		attributes att = new attributes('TestSuiteMembership', 'ref' + contador);
		objectToUpdate.attributes = att;
        testSuiteMembershipList.add(objectToUpdate);
    }
	if(contador == 200){
		break;
	}
}
String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
String endpoint = baseURL + '/services/data/v51.0/composite/tree/TestSuiteMembership';
HttpRequest req = new HttpRequest();
req.setEndpoint(endpoint);
req.setMethod('POST');
req.setHeader('Content-Type', 'application/json;charset=UTF-8');
req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
String bodyText = '{"records" :' + json.serializePretty(testSuiteMembershipList) + '}';
System.debug(bodyText);
req.setBody(bodyText);
Http http = new Http();
HttpResponse res = http.send(req);
System.debug('Response Code > ' + res.getStatusCode());
System.debug(' Response > ' + res.getBody());