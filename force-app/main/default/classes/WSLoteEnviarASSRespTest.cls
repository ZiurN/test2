//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class WSLoteEnviarASSRespTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"error\": false,'+
		'    \"data\": {'+
		'        \"lote_id\": 5400,'+
		'        \"estado\": \"A\"'+
		'    },'+
		'    \"httpCode\": 201,'+
		'    \"message\": \"Se generó el lote correctamente.\",'+
		'    \"meta\": {'+
		'        \"allowed_includes\": [],'+
		'        \"default_includes\": []'+
		'    }'+
		'}';
		WSLoteEnviarASSResp r = WSLoteEnviarASSResp.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSLoteEnviarASSResp.Meta objMeta = new WSLoteEnviarASSResp.Meta(System.JSON.createParser(json));
		System.assert(objMeta != null);
		System.assert(objMeta.allowed_includes == null);
		System.assert(objMeta.default_includes == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSLoteEnviarASSResp.Allowed_includes objAllowed_includes = new WSLoteEnviarASSResp.Allowed_includes(System.JSON.createParser(json));
		System.assert(objAllowed_includes != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSLoteEnviarASSResp objWSLoteEnviarASSResp = new WSLoteEnviarASSResp(System.JSON.createParser(json));
		System.assert(objWSLoteEnviarASSResp != null);
		System.assert(objWSLoteEnviarASSResp.error == null);
		System.assert(objWSLoteEnviarASSResp.data == null);
		System.assert(objWSLoteEnviarASSResp.httpCode == null);
		System.assert(objWSLoteEnviarASSResp.message == null);
		System.assert(objWSLoteEnviarASSResp.meta == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSLoteEnviarASSResp.Data objData = new WSLoteEnviarASSResp.Data(System.JSON.createParser(json));
		System.assert(objData != null);
		System.assert(objData.lote_id == null);
		System.assert(objData.estado == null);
	}
}