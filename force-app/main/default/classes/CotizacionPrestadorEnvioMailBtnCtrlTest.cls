@isTest
private class CotizacionPrestadorEnvioMailBtnCtrlTest {
	static Orden_de_Compra__c orden;
	static Cotizacion_Prestador__c cotPres;
	static Case caso;
	static Evento_medico__c em;
	static	Account acc;
	static {
		em = new Evento_medico__c();
		insert em;
		caso = new Case();
		caso.Evento_Medico__c = em.Id;
		caso.Type = 'Prestacion';
		insert caso;
		orden = new Orden_de_Compra__c();
		orden.Caso__c = caso.Id;
		insert orden;
		acc = Build.anAccountEfector().build();
		acc.Correo_electronico__c = 'test@gmail.com';
		acc.Es_Prestador__c = true;
		insert acc;
		cotPres = new Cotizacion_Prestador__c();
		cotPres.Mail_prestador__c = 'test@gmail.com';
		cotPres.Orden_de_Compra__c = orden.Id;
		cotPres.Prestador__c = acc.Id;
		insert cotPres;
	}
	@isTest
	private static void testSendEmailWithAttachmentOnCase() {
		ContentVersion version = new ContentVersion();
        version.PathOnClient = '/' + 'PRESCRIP_TEST_COTIZ_EM';
        version.origin = 'H';
        version.Title = 'PRESCRIP_TEST_COTIZ_EM';
        Blob pdfBody;
		pdfBody = Blob.valueOf('Test File');
        version.VersionData = pdfBody;
		insert version;
		ContentVersion updatedContent = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :version.Id FOR UPDATE];
		ContentDocumentLink documentLink = new ContentDocumentLink();
        documentLink.ContentDocumentId = updatedContent.ContentDocumentId;
        documentLink.LinkedEntityId = caso.Id;
        documentLink.ShareType = 'V';
		insert documentLink;
		Test.startTest();
		CotizacionPrestadorEnvioMailBtnCtrl.Response resp = CotizacionPrestadorEnvioMailBtnCtrl.sendAttachmentsToPrest(cotPres.Id);
		Test.stopTest();
		System.assert(!resp.hasError, 'No deben haber errores en el envío');
		System.assertEquals(System.Label.Email_EnvioCorrecto, resp.message, 'El mensaje debe indicar que el mensase se envío correctamente');
	}

	@isTest
	private static void testSendEmailWithAttachmentOnEM() {
		ContentVersion version = new ContentVersion();
        version.PathOnClient = '/' + 'PRESCRIP_TEST_COTIZ_CASE';
        version.origin = 'H';
        version.Title = 'PRESCRIP_TEST_COTIZ_CASE';
        Blob pdfBody;
		pdfBody = Blob.valueOf('Test File');
        version.VersionData = pdfBody;
		insert version;
		ContentVersion updatedContent = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :version.Id FOR UPDATE];
		ContentDocumentLink documentLink = new ContentDocumentLink();
        documentLink.ContentDocumentId = updatedContent.ContentDocumentId;
        documentLink.LinkedEntityId = em.Id;
        documentLink.ShareType = 'V';
		insert documentLink;
		Test.startTest();
		CotizacionPrestadorEnvioMailBtnCtrl.Response resp = CotizacionPrestadorEnvioMailBtnCtrl.sendAttachmentsToPrest(cotPres.Id);
		Test.stopTest();
		System.assert(!resp.hasError, 'No deben haber errores en el envío');
		System.assertEquals(System.Label.Email_EnvioCorrecto, resp.message, 'El mensaje debe indicar que el mensase se envío correctamente');
	}
	@isTest
	private static void testSendEmailWithNoAttachment_ShouldReturnErrorMsg() {
		Test.startTest();
		CotizacionPrestadorEnvioMailBtnCtrl.Response resp = CotizacionPrestadorEnvioMailBtnCtrl.sendAttachmentsToPrest(cotPres.Id);
		Test.stopTest();
		System.assertEquals(resp.hasError, true);
		System.assertEquals(resp.message, 'No se encontro ningun adjunto que contenga PRESCRI');
	}
	@isTest
	private static void testSendEmailWithNoAttachmentWithPRESCRIPPrefix_ShouldReturnErrorMsg() {
		ContentVersion version = new ContentVersion();
        version.PathOnClient = '/' + 'TEST_COTIZ';
        version.origin = 'H';
        version.Title = 'TEST_COTIZ';
        Blob pdfBody;
		pdfBody = Blob.valueOf('Test File');
        version.VersionData = pdfBody;
		insert version;
		ContentVersion updatedContent = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :version.Id FOR UPDATE];
		ContentDocumentLink documentLink = new ContentDocumentLink();
        documentLink.ContentDocumentId = updatedContent.ContentDocumentId;
        documentLink.LinkedEntityId = em.Id;
        documentLink.ShareType = 'V';
		insert documentLink;
		Test.startTest();
		CotizacionPrestadorEnvioMailBtnCtrl.Response resp = CotizacionPrestadorEnvioMailBtnCtrl.sendAttachmentsToPrest(cotPres.Id);
		Test.stopTest();
		System.assertEquals(resp.hasError, true);
		System.assertEquals(resp.message, 'No se encontro ningun adjunto que contenga PRESCRI');
	}
}