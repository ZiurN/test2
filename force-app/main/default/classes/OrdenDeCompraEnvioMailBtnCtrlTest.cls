@isTest 
private class OrdenDeCompraEnvioMailBtnCtrlTest {

	static Orden_de_Compra__c orden;
	static Cotizacion_Prestador__c cotPres;
	static Case caso;
	static Evento_medico__c em;

	static {
		em = new Evento_medico__c();
		insert em;

		caso = new Case();
		caso.Evento_Medico__c = em.Id;
		insert caso;

		orden = new Orden_de_Compra__c();
		orden.Caso__c = caso.Id;
		insert orden;

		Account acc = Build.anAccountEfector().build();
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
	private static void testSendEmailWithAttachment() {
		ContentVersion version = new ContentVersion();
        version.PathOnClient = '/' + 'PRESCRIP_TEST';
        version.origin = 'H';
        version.Title = 'PRESCRIP_TEST';
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
		OrdenDeCompraEnvioMailBtnCtrl.Response resp = OrdenDeCompraEnvioMailBtnCtrl.sendAttachmentsToAllPrest(orden.Id);
		Test.stopTest();

		Orden_de_Compra__c orden = [
			SELECT Id, Estado_OC__c
			FROM Orden_de_Compra__c
			WHERE Id = :orden.Id
		];

		System.assertEquals(false,resp.hasError);
		System.assertEquals('Se realizó el envío de mails',resp.message);
		System.assertEquals('Pedido Cotizacion', orden.Estado_OC__c);

	}

	

	@isTest
	private static void testSendEmailWithNoAttachment_ShouldReturnErrorMsg() {
		Test.startTest();
		OrdenDeCompraEnvioMailBtnCtrl.Response resp = OrdenDeCompraEnvioMailBtnCtrl.sendAttachmentsToAllPrest(orden.Id);
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.assertEquals('No se encontro ningun adjunto que contenga PRESCRI',resp.message);

	}

		@isTest
	private static void testSendEmailWithNoAttachmentWithPRESCRIPPrefix_ShouldReturnErrorMsg() {

		ContentVersion version = new ContentVersion();
        version.PathOnClient = '/' + 'TEST';
        version.origin = 'H';
        version.Title = 'TEST';
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
		OrdenDeCompraEnvioMailBtnCtrl.Response resp = OrdenDeCompraEnvioMailBtnCtrl.sendAttachmentsToAllPrest(orden.Id);
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.assertEquals('No se encontro ningun adjunto que contenga PRESCRI', resp.message);

	}


		@isTest
	private static void testSendEmailWithNoCotizacionAssociated_ShouldReturnErrorMsg() {

		Orden_de_Compra__c sOrden = new Orden_de_Compra__c();
		insert sOrden;

		Test.startTest();
		OrdenDeCompraEnvioMailBtnCtrl.Response resp = OrdenDeCompraEnvioMailBtnCtrl.sendAttachmentsToAllPrest(sOrden.Id);
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.assertEquals('La orden de compra no tiene ninguna cotización', resp.message);

	}
}