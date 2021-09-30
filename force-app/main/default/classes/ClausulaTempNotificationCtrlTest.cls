@isTest
public with sharing class ClausulaTempNotificationCtrlTest {
    @isTest
    private static void whenCheckIfHaveAnAttachmentAndFindIt_ShowAnAlertMessage() {
        Date today = Date.today();
        Date tomorrow = Date.today().addDays(1);
        Date yesterday = Date.Today().addDays(-1);

        Account acc = Build.anAccount().withLastName('AccountTest').build();
        acc.Codigo_de_Afiliado__c = '123';
        acc.Sexo__c = 'F';
        insert acc;

		Asignacion_de_clausula_temporaria__c clausula = new Asignacion_de_clausula_temporaria__c(
            Fecha_desde__c = today,
            Fecha_de_vigencia_hasta__c = yesterday,
            Asociado__c = acc.Id,
            Fecha_FUM__c = yesterday
        );
        insert clausula;

        ContentVersion contentVersion = new ContentVersion(
			Title = 'Test',
			PathOnClient = 'test.pdf',
			VersionData = Blob.valueOf('Test Content'),
			IsMajorVersion = true
		);
        insert contentVersion;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
		ContentDocumentLink cdl = New ContentDocumentLink();
		cdl.LinkedEntityId = clausula.Id;
		cdl.ContentDocumentId = documents[0].Id;
		cdl.shareType = 'V';
        insert cdl;
        
        Test.startTest();
        ClausulaTempNotificationCtrl.Response alertMsg = ClausulaTempNotificationCtrl.hasAttachmentsErrorMsg(clausula.Id);
        Test.stopTest();

        System.assertEquals('ok', alertMsg.message);
    }

    @isTest
    private static void whenCheckIfHaveAnAttachmentAndDontFindIt_ShowAnAlertMessage() {
        Date today = Date.today();
        Date tomorrow = Date.today().addDays(1);
        Date yesterday = Date.Today().addDays(-1);

        Account acc = Build.anAccount().withLastName('AccountTest').build();
        acc.Codigo_de_Afiliado__c = '123';
        acc.Sexo__c = 'F';
        insert acc;

		Asignacion_de_clausula_temporaria__c clausula = new Asignacion_de_clausula_temporaria__c(
            Fecha_desde__c = today,
            Fecha_de_vigencia_hasta__c = yesterday,
            Asociado__c = acc.Id,
            Fecha_FUM__c = yesterday
        );
        insert clausula;
        
        
        Test.startTest();
        ClausulaTempNotificationCtrl.Response alertMsg = ClausulaTempNotificationCtrl.hasAttachmentsErrorMsg(clausula.Id);
        Test.stopTest();

        System.assertEquals('Recuerde adjuntar el Certificado de Embarazo', alertMsg.message);
    }

}