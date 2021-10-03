@isTest
public class ConsultoriosEfectorProcessorTest  {

    static XHttpCalloutMock getResponseFound;
    static XHttpCalloutMock getResponseFoundSecondPage;
    static XHttpCalloutMock getErrorResponse;

    static {
        String today = System.now().format('yyyy-MM-dd');


        getResponseFound = new XHttpCalloutMock();
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFound.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSBatchConsultoriosMock.getFound())
                .addForAddress(WSBatchConsultorios.SERVICE_CONFIG.URL__c + '/v1/salud/batch/consultorios/' + today + '?pageSize=15&page=1');

        Account efector = new Account(Codigo_de_efector__c = '700047',Name = 'test');
        efector.RecordTypeId = XappiaHelper.getRecordType('Account', 'Efector').Id;
        insert efector;

        getResponseFoundSecondPage = new XHttpCalloutMock();
        getResponseFoundSecondPage.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSAuthTokenMock.getTokenSuccess())
                .addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
        getResponseFoundSecondPage.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSBatchConsultoriosMock.getFoundAndContinue())
                .addForAddress(WSBatchConsultorios.SERVICE_CONFIG.URL__c + '/v1/salud/batch/consultorios/' + today + '?pageSize=15&page=1');
        getResponseFoundSecondPage.buildResponse()
                .withStatus('OK')
                .withStatusCode(200)
                .withBody(WSBatchConsultoriosMock.getFound())
                .addForAddress(WSBatchConsultorios.SERVICE_CONFIG.URL__c + '/v1/salud/batch/consultorios/' + today + '?pageSize=15&page=2');
    }


    @isTest static void externalsConsultoriosEfectorCanBeProcessed() {
        Test.setMock(HttpCalloutMock.class, getResponseFound);

        Test.startTest();
        Database.executeBatch(new MasterBatch(new ConsultoriosEfectorProcessor(15, 1, 1, System.now())));
        Test.stopTest();

        System.assertEquals(3, [SELECT Count() FROM Consultorio__c]);



    }

    @isTest static void aSecondBatchOfAccountsCanBeCalled() {
        Test.setMock(HttpCalloutMock.class, getResponseFoundSecondPage);

        Test.startTest();
        Database.executeBatch(new MasterBatch(new ConsultoriosEfectorProcessor(15, System.now())));
        Test.stopTest();

        System.assertEquals(4, [SELECT Count() FROM Consultorio__c]);

    }



}