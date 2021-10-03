@isTest
public class prestacionReintegroBtnCtrlTest {
	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getErrorResponse;
	static String body;
    static Prestacion_de_reintegro__c prest;
    static Case reintegro;

	static {
		getResponseFound = new XHttpCalloutMock();
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFound.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSPrestacionActualizarImporteMock.getFound())
			.addForAddress(WSPrestacionActualizarImporte.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/' + 553277 + '/prestaciones/' + 74043157 + '/importe');

		getErrorResponse = new XHttpCalloutMock();
		getErrorResponse.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getErrorResponse.buildResponse()
			.withStatus('Not Found')
			.withStatusCode(404)
			.withBody(WSPrestacionActualizarImporteMock.getError())
            .addForAddress(WSPrestacionActualizarImporte.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/' + 0 + '/prestaciones/' + 0 + '/importe');
            
        reintegro = new Case();
        reintegro.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reintegro').Id;
        reintegro.Status = 'Generada';
        reintegro.Type = 'Prestacion';
        reintegro.Importe_reintegro__c = 0;
        reintegro.AccountId = Build.anAccount().withLastName('Test').build().Id;
        reintegro.CBU__c = '123123123';
        reintegro.Efector_realizador__c = Build.anAccountEfector().withLastName('Efector').build().Id;
        reintegro.Codigo_reintegro_SS__c = '553277';
        insert reintegro;

		Nomenclador_de_Prestacion__c nom = new Nomenclador_de_Prestacion__c();
		nom.Estado__c = 'A';
		nom.Codigo__c = '2222';
		insert nom;

		prest = new Prestacion_de_reintegro__c();
		prest.RecordTypeId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Prestacional').Id;
		prest.Id_Externo__c = '74043157';
        prest.Caso__c = reintegro.Id;
		prest.Importe_Reintegro_auditor__c = 1000;
		prest.Importe_cargo_al_socio_auditor__c = 999.50;
		prest.Prestacional__c = nom.Id;
		insert prest;

		
	}
	
	@IsTest
	private static void whenTheWSIsConsume_getPrestaciones(){
		Test.setMock(HttpCalloutMock.class, getResponseFound);
		
		Test.startTest();
		prestacionReintegroBtnCtrl.Response resp = prestacionReintegroBtnCtrl.sendUpdateToSS(prest.Id);
		Test.stopTest();

		System.assertEquals(false, resp.hasError);
		System.assertEquals('ok', resp.message);
		
	}

	@IsTest
	private static void whenTheWSIsConsume_GetErrorResponse(){
        Test.setMock(HttpCalloutMock.class, getErrorResponse);
        reintegro.Codigo_reintegro_SS__c = '0';
        update reintegro;
        prest.Id_Externo__c = '0';
        update prest;
		
		Test.startTest();
		prestacionReintegroBtnCtrl.Response resp = prestacionReintegroBtnCtrl.sendUpdateToSS(prest.Id);
		Test.stopTest();

		System.assertEquals(true, resp.hasError);
		System.debug(resp.message);
		System.assertEquals('El reintegro solicitado es inválido.', resp.message);
	}

	@IsTest
	private static void whenTheReintegroHasntExternalId_showErrorMsj() {
		reintegro.Codigo_reintegro_SS__c = null;
		update reintegro;
		
		Test.startTest();
		prestacionReintegroBtnCtrl.Response resp = prestacionReintegroBtnCtrl.sendUpdateToSS(prest.Id);
		Test.stopTest();
		
		String info = 'No se pueden actualizar los importes en Salud Soft:'
						+ ' revise que el reintegro y la prestacion hayan sido enviados';
		System.assertEquals(false, resp.hasError);
		System.assertEquals(info, resp.message);
	}
}