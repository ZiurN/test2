//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class WSAsociadoScoreResp_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"data\": {'+
		'        \"indice_rentabilidad\": \"-886034.17\",'+
		'        \"edad_maxima\": \"44\",'+
		'        \"evento_medico\": \"F\",'+
		'        \"color\": \"ROJO\"'+
		'    },'+
		'    \"meta\": {'+
		'        \"allowed_includes\": [],'+
		'        \"default_includes\": []'+
		'    }'+
		'}';
		WSAsociadoScoreResp r = WSAsociadoScoreResp.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoScoreResp.Meta objMeta = new WSAsociadoScoreResp.Meta(System.JSON.createParser(json));
		System.assert(objMeta != null);
		System.assert(objMeta.allowed_includes == null);
		System.assert(objMeta.default_includes == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoScoreResp.Allowed_includes objAllowed_includes = new WSAsociadoScoreResp.Allowed_includes(System.JSON.createParser(json));
		System.assert(objAllowed_includes != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoScoreResp objWSAsociadoScoreResp = new WSAsociadoScoreResp(System.JSON.createParser(json));
		System.assert(objWSAsociadoScoreResp != null);
		System.assert(objWSAsociadoScoreResp.data == null);
		System.assert(objWSAsociadoScoreResp.meta == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoScoreResp.Data objData = new WSAsociadoScoreResp.Data(System.JSON.createParser(json));
		System.assert(objData != null);
		System.assert(objData.indice_rentabilidad == null);
		System.assert(objData.edad_maxima == null);
		System.assert(objData.evento_medico == null);
		System.assert(objData.color == null);
	}
}