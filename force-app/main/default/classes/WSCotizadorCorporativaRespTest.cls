//
// Generated by WSCotizadorCorporativaResp http://WSCotizadorCorporativaResp.herokuapp.com/
//

@IsTest
public class WSCotizadorCorporativaRespTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  \"error\": false,'+
		'  \"data\": {'+
		'    \"archivo\": \"data:text/plain;base64,cHJ1ZWJhIGRlIGVudmlvIGFyY2hpdm8gYmFzZTY0\",'+
		'    \"idCotizacion\": 310606'+
		'  },'+
		'  \"httpCode\": 200,'+
		'  \"message\": \"La cotización fue realizada con éxito.\",'+
		'  \"meta\": {'+
		'    \"allowed_includes\": [],'+
		'    \"default_includes\": []'+
		'  }'+
		'}';
		WSCotizadorCorporativaResp r = WSCotizadorCorporativaResp.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCotizadorCorporativaResp.Meta objMeta = new WSCotizadorCorporativaResp.Meta(System.JSON.createParser(json));
		System.assert(objMeta != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCotizadorCorporativaResp objWSCotizadorCorporativaResp = new WSCotizadorCorporativaResp(System.JSON.createParser(json));
		System.assert(objWSCotizadorCorporativaResp != null);
		System.assert(objWSCotizadorCorporativaResp.error == null);
		System.assert(objWSCotizadorCorporativaResp.data == null);
		System.assert(objWSCotizadorCorporativaResp.httpCode == null);
		System.assert(objWSCotizadorCorporativaResp.message == null);
		System.assert(objWSCotizadorCorporativaResp.meta == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCotizadorCorporativaResp.Data objData = new WSCotizadorCorporativaResp.Data(System.JSON.createParser(json));
		System.assert(objData != null);
		System.assert(objData.archivo == null);
		System.assert(objData.idCotizacion == null);
	}
}