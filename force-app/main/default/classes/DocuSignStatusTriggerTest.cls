@isTest 
public class DocuSignStatusTriggerTest {
    @TestSetup
    static void setup(){
        Date closeDate = System.TODAY(); 
        closeDate = closeDate.addMonths(2);
        
        Opportunity opportunityToTest = Build.anOpportunity()
            .withName('Test')
            .withStageName('Contactado')
            .withCloseDate(closeDate)
            .build();
        insert opportunityToTest;

        dsfs__DocuSign_Status__c statusDocuSign = new dsfs__DocuSign_Status__c(
            dsfs__Opportunity__c = opportunityToTest.Id,
            dsfs__Completed_Date_Time__c = System.TODAY(),
            dsfs__Envelope_Status__c = 'Completed'
        );
        insert statusDocuSign;
    }

    @isTest
    static void whenIChangeStatusDocuSignToComplete_OverwriteTheDocumentInOpportunity() {
        Opportunity opportunityToTest = [
            SELECT Id, Name
            FROM Opportunity
            WHERE Name = 'Test'
            LIMIT 1
        ];
        dsfs__DocuSign_Status__c statusDocuSignTest = [
            SELECT Id, dsfs__Envelope_Status__c, dsfs__Completed_Date_Time__c
            FROM dsfs__DocuSign_Status__c
            WHERE dsfs__Opportunity__c =: opportunityToTest.Id
            LIMIT 1
        ];
        String yourFiles = 'Solicitud de ingreso y DDJJ completa';

        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        conVer.PathOnClient = System.Label.PDFIngresoYDDJJ; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = System.Label.PDFIngresoYDDJJ; // Display name of the files
        conVer.VersionData = EncodingUtil.base64Decode(yourFiles); // converting your binary string to Blog
        insert conVer;

        // First get the content document Id from ContentVersion
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        
        //Create ContentDocumentLink in StatusDocuSign
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = statusDocuSignTest.Id; 
        cDe.ShareType = 'I'; 
        cDe.Visibility = 'AllUsers';
        insert cDe;

        ContentDocumentLink prueba = [
            SELECT Id, LinkedEntityId, ContentDocument.Title
            FROM ContentDocumentLink
            WHERE LinkedEntityId =: opportunityToTest.Id
        ];

        //NEW SIGN = NEW STATUS
        dsfs__DocuSign_Status__c newStatusDocuSign = new dsfs__DocuSign_Status__c(
            dsfs__Opportunity__c = opportunityToTest.Id,
            dsfs__Completed_Date_Time__c = System.TODAY(),
            dsfs__Envelope_Status__c = 'Completed'
        );
        insert newStatusDocuSign;
        
        ContentVersion conVerNew = new ContentVersion();
        conVerNew.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        conVerNew.PathOnClient = System.Label.PDFIngresoYDDJJ; // The files name, extension is very important here which will help the file in preview.
        conVerNew.Title = System.Label.PDFIngresoYDDJJ; // Display name of the files
        conVerNew.VersionData = EncodingUtil.base64Decode(yourFiles); // converting your binary string to Blog
        insert conVerNew;

        // First get the content document Id from ContentVersion
        Id conDocNew = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVerNew.Id].ContentDocumentId;

        //Create ContentDocumentLink in StatusDocuSign
        ContentDocumentLink cDe3 = new ContentDocumentLink();
        cDe3.ContentDocumentId = conDocNew;
        cDe3.LinkedEntityId = newStatusDocuSign.Id; // you can use objectId,GroupId etc
        cDe3.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        cDe3.Visibility = 'AllUsers';

        Test.startTest();
        System.DEBUG('---------------------START TEST ------------------------------------');
        Database.SaveResult result = Database.insert(cDe3);
        Test.stopTest();

        ContentDocumentLink checkIfOverwrittenOpp = [
            SELECT Id, ContentDocument.title, ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId =: opportunityToTest.Id
            LIMIT 1
        ];

        dsfs__DocuSign_Status__c checkStatus = [
            SELECT Id, dsfs__Envelope_Status__c, dsfs__Opportunity__c
            FROM dsfs__DocuSign_Status__c
            WHERE Id =: newStatusDocuSign.Id
        ];

        System.assert(result.isSuccess(), 'Falló al actualizar el estado de DocuSign');
        System.assertEquals(conDocNew, checkIfOverwrittenOpp.ContentDocumentId, 'El archivo no es el correcto');
        System.assertEquals(System.Label.PDFIngresoYDDJJ, checkIfOverwrittenOpp.ContentDocument.Title, 'El archivo no se sobreescribió');
        System.assertEquals(opportunityToTest.Id, checkStatus.dsfs__Opportunity__c, 'El estado del docu sign no está relacionado con la oportunidad');
    }

    @isTest
    static void whenIChangeStatusDocuSignToComplete_AndIsTheFirstTimeOnlyUploadTheFile() {
        Date closeDate = System.TODAY(); 
        closeDate = closeDate.addMonths(2);
        Opportunity opportunityToTest = Build.anOpportunity()
            .withName('Test 123')
            .withStageName('Contactado')
            .withCloseDate(closeDate)
            .build();
        insert opportunityToTest;
        dsfs__DocuSign_Status__c statusDocuSign = new dsfs__DocuSign_Status__c(
            dsfs__Opportunity__c = opportunityToTest.Id,
            dsfs__Completed_Date_Time__c = System.TODAY(),
            dsfs__Envelope_Status__c = 'Completed'
        );
        insert statusDocuSign;

        String yourFiles = 'Solicitud de ingreso y DDJJ completa';

        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        conVer.PathOnClient = System.Label.PDFIngresoYDDJJ; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = System.Label.PDFIngresoYDDJJ; // Display name of the files
        conVer.VersionData = EncodingUtil.base64Decode(yourFiles); // converting your binary string to Blog
        insert conVer;

        // First get the content document Id from ContentVersion
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        
        //Create ContentDocumentLink in StatusDocuSign
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = statusDocuSign.Id; // you can use objectId,GroupId etc
        cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        cDe.Visibility = 'AllUsers';


        Test.startTest();
        Database.SaveResult result = Database.insert(cDe);
        Test.stopTest();

        ContentDocumentLink checkDocument = [
            SELECT Id, ContentDocument.title, ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId =: opportunityToTest.Id
        ];

        System.assert(result.isSuccess(), 'Falló al actualizar el estado de DocuSign');
        System.assertEquals(System.Label.PDFIngresoYDDJJ, checkDocument.ContentDocument.Title, 'La oportunidad no recibió el documento esperado');
    }
}