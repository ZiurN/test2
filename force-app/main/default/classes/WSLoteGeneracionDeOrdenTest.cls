@IsTest
public class WSLoteGeneracionDeOrdenTest  {

	static XHttpCalloutMock getResponseFound;
	static XHttpCalloutMock getResponseFoundDeshacer;
	static XHttpCalloutMock getResponseError;

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
			.withBody(WSLoteGeneracionDeOrdenMock.getFound())
			.addForAddress(WSLoteGeneracionDeOrden.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5402/orden');

		getResponseFoundDeshacer = new XHttpCalloutMock();
		getResponseFoundDeshacer.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseFoundDeshacer.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSLoteGeneracionDeOrdenMock.getFoundDeshacer())
			.addForAddress(WSLoteGeneracionDeOrden.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5404/orden');

		getResponseError = new XHttpCalloutMock();
		getResponseError.buildResponse()
			.withStatus('OK')
			.withStatusCode(200)
			.withBody(WSAuthTokenMock.getTokenSuccess())
			.addForAddress(WSAuthToken.SERVICE_CONFIG.URL__c + '/oauth/token');
		getResponseError.buildResponse()
			.withStatus('Error')
			.withStatusCode(422)
			.withBody(WSLoteGeneracionDeOrdenMock.getError())
			.addForAddress(WSLoteGeneracionDeOrden.SERVICE_CONFIG.URL__c + '/v1/salud/reintegros/lotes/5600/orden');
		
	}

	@isTest
	private static void generateOrdenLoteSS() {
		String body = JSON.serialize(new Map<String,Object>{
			'usuario' => 'CRIOS',
			'accion' => 'GENERAR'
		});
		Test.setMock(HttpCalloutMock.class,getResponseFound);
		Test.startTest();
		WSLoteGeneracionDeOrden.Response resp = WSLoteGeneracionDeOrden.generacionDeOrden('5402',body);
		Test.stopTest();

		System.assertEquals(false, resp.hasError);
		System.assertEquals('Ok', resp.message);
		System.assertEquals(5402, resp.lote.data.lote.lr_id);
		System.assertEquals('A', resp.lote.data.lote.estado);
		System.assertEquals(1, resp.lote.data.lote.logs.size());
		System.assertEquals('Se generó la orden correctamente.',resp.lote.message);
	}

	@isTest
	private static void undoOrdenLoteSS() {
		String body = JSON.serialize(new Map<String,Object>{
			'usuario' => 'CRIOS',
			'accion' => 'DESHACER'
		});
		Test.setMock(HttpCalloutMock.class,getResponseFoundDeshacer);
		Test.startTest();
		WSLoteGeneracionDeOrden.Response resp = WSLoteGeneracionDeOrden.generacionDeOrden('5404',body);
		Test.stopTest();

		System.assertEquals(false, resp.hasError);
		System.assertEquals('Ok', resp.message);
		System.assertEquals(5404, resp.lote.data.lote.lr_id);
		System.assertEquals('A', resp.lote.data.lote.estado);
		System.assertEquals(null, resp.lote.data.lote.logs);
		System.assertEquals('Se deshizo la orden correctamente.',resp.lote.message);
	}

	@isTest
	private static void generateOrdenLoteWithInvalidId() {
		String body = JSON.serialize(new Map<String,Object>{
			'usuario' => 'asdf',
			'accion' => 'GENERAR'
		});
		Test.setMock(HttpCalloutMock.class,getResponseError);
		Test.startTest();
		WSLoteGeneracionDeOrden.Response resp = WSLoteGeneracionDeOrden.generacionDeOrden('5600',body);
		Test.stopTest();

		System.assertEquals(true,resp.hasError);
		System.assertEquals('No se pudo generar la orden. No se pueden visualizar los datos en este momento',resp.message);
	}

}