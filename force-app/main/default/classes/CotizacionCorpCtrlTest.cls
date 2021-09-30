@isTest 
private class CotizacionCorpCtrlTest {

	@isTest
	private static void cotizacionCorpCtrlShouldBeInitializedWithEmptyCotizacion() {
		Opportunity opp = Build.anOpportunityIndividualCorporativo().build();
		insert opp;
		Cotizacion__c newCotCorp = new Cotizacion__c();
		newCotCorp.Oportunidad__c = opp.Id;
		insert newCotCorp;

		ContentVersion ver = new ContentVersion();
		// PARA CUANDO ESTA SEPARADO POR PUNTO Y COMA
		//ver.VersionData = EncodingUtil.base64Decode('IlBsYW4gYSBDb3RpemFyIjsiQXBlbGxpZG8geSBOb21icmUiCiJBUyAzMDAiOyJSb2JlcnRvIg==');
		// PARA CUANDO ESTA SEPARADO POR COMAS
		ver.VersionData = EncodingUtil.base64Decode('IlBsYW4gYSBDb3RpemFyIiwiQXBlbGxpZG8geSBOb21icmUiCiJBUyAzMDAiLCJSb2JlcnRvIg==');
		ver.Title = 'Cotizacion.csv';
		ver.PathOnClient = '/cotizacion.csv';
		insert ver;
		ver = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :ver.Id];

		ContentDocumentLink link = new ContentDocumentLink();
		link.ContentDocumentId = ver.ContentDocumentId;
		link.LinkedEntityId = newCotCorp.Id;
		link.ShareType = 'V';
		insert link;
		PageReference pref = new PageReference('/apex/cotizacionCorpPDF?id=' + newCotCorp.Id);
		Test.setCurrentPageReference(pref);
		Test.startTest();
		CotizacionCorpCtrl cotCtrl = new CotizacionCorpCtrl();
		Test.stopTest();

		System.assertEquals(newCotCorp.Id,cotCtrl.getCotizacion().Id);
		System.assertEquals(2, cotCtrl.getRows());
		System.assertEquals(2, cotCtrl.getCotTable().size());
	}
}