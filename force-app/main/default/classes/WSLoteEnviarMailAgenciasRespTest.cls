//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class WSLoteEnviarMailAgenciasRespTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  \"error\": false,'+
		'  \"data\": null,'+
		'  \"httpCode\": 201,'+
		'  \"message\": \"Se envió correctamente el mail a las agencias.\",'+
		'  \"meta\": {'+
		'    \"allowed_includes\": [],'+
		'    \"default_includes\": []'+
		'  }'+
		'}';
		WSLoteEnviarMailAgenciasResp r = WSLoteEnviarMailAgenciasResp.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSLoteEnviarMailAgenciasResp.Meta objMeta = new WSLoteEnviarMailAgenciasResp.Meta(System.JSON.createParser(json));
		System.assert(objMeta != null);
		System.assert(objMeta.allowed_includes == null);
		System.assert(objMeta.default_includes == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSLoteEnviarMailAgenciasResp.Allowed_includes objAllowed_includes = new WSLoteEnviarMailAgenciasResp.Allowed_includes(System.JSON.createParser(json));
		System.assert(objAllowed_includes != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSLoteEnviarMailAgenciasResp objWSLoteEnviarMailAgenciasResp = new WSLoteEnviarMailAgenciasResp(System.JSON.createParser(json));
		System.assert(objWSLoteEnviarMailAgenciasResp != null);
		System.assert(objWSLoteEnviarMailAgenciasResp.error == null);
		System.assert(objWSLoteEnviarMailAgenciasResp.data == null);
		System.assert(objWSLoteEnviarMailAgenciasResp.httpCode == null);
		System.assert(objWSLoteEnviarMailAgenciasResp.message == null);
		System.assert(objWSLoteEnviarMailAgenciasResp.meta == null);
	}
}