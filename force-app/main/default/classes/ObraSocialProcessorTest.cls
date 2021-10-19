@isTest
public class ObraSocialProcessorTest  {

    static MasterConfigs__c config;
    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getErrorResponse;
    static XHttpCalloutMock getEmptyListResponse;
    static XHttpCalloutMock getResponseFoundSecondPageOnly;

    static {
        String today = System.now().format('yyyy-MM-dd').substringBefore(' ');

        getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSBatchObraSocialMock.getFound())
                .addForAddress(WSBatchObraSocial.SERVICE_CONFIG.URL__c + '/v1/salud/batch/obras-sociales/' + today + '?pageSize=15&page=1');
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSBatchObraSocialMock.getFoundSecondPage())
                .addForAddress(WSBatchObraSocial.SERVICE_CONFIG.URL__c + '/v1/salud/batch/obras-sociales/' + today + '?pageSize=15&page=2');

        getResponseFoundSecondPageOnly = new XHttpCalloutMock();
        getResponseFoundSecondPageOnly.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFoundSecondPageOnly.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSBatchObraSocialMock.getFoundSecondPage())
                .addForAddress(WSBatchObraSocial.SERVICE_CONFIG.URL__c + '/v1/salud/batch/obras-sociales/' + today + '?pageSize=15&page=2');
    }

    static {
        config = Build.aMasterConfigs().build();
        insert config;
    }

    @isTest static void externalsOSCanBeProcessed() {
        Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPageOnly);

        Test.startTest();
        Database.executeBatch(new MasterBatch(new ObraSocialProcessor(15, 2, 2, System.now())));
        Test.stopTest();

        //System.assertEquals(3, [SELECT Count() FROM Account]);
		// Sin delegaciones son 2, los 2 registros del mock
		System.assertEquals(2, [SELECT Count() FROM Account]);
    }

    @isTest static void aSecondBatchOfAccountsCanBeCalled() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);

        Test.startTest();
        Database.executeBatch(new MasterBatch(new ObraSocialProcessor(15, System.now())));
        Test.stopTest();
		
		// Ya no se insertan las delegaciones
        //System.assertEquals(1, [SELECT Count() FROM Account WHERE Codigo_de_delegacion__c = '650098']);
        System.assertEquals(3, [SELECT Count() FROM Account]);
        System.assertEquals(2, [SELECT Count() FROM Agrupacion__c]);
        System.assertEquals(3, [SELECT Count() FROM Cuenta_Agrupacion__c]);
    }

    @isTest static void atTheLastBatchTheLastUpdatedDateIsUpdated() {
        Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPageOnly);

        Datetime now = System.now();

        Datetime yesterday = Datetime.now().addDays(-1);

        Test.startTest();
        Database.executeBatch(new MasterBatch(new ObraSocialProcessor(15, yesterday, now)));
        Test.stopTest();

        System.debug(MasterConfigs__c.getOrgDefaults().Obras_Sociales__c);

        System.assertEquals(now, MasterConfigs__c.getOrgDefaults().Obras_Sociales__c);
    }

}