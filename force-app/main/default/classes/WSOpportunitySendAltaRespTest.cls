@IsTest
public class WSOpportunitySendAltaRespTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  \"error\": false,'+
		'  \"data\": [{'+
		'    \"sf_id\": \"sfid12345\",'+
		'    \"solafi_id\": \"724171\",'+
		'    \"estado_sol\": \"COMPLETA\",'+
		'    \"estado_dj\": \"NUEVA\",'+
		'    \"codigo_as\": null,'+
		'    \"tipo_asoc\": \"DSATIT\",'+
		'    \"notas\": ['+
		'      {'+
		'        \"nota_id\": \"128804\",'+
		'        \"texto_nota\": \"Nota de prueba\"'+
		'      }'+
		'    ]'+
		'  }],'+
		'  \"httpCode\": 200,'+
		'  \"message\": \"Se generó satisfactoriamente la solicitud de alta\",'+
		'  \"meta\": {'+
		'    \"allowed_includes\": [],'+
		'    \"default_includes\": []'+
		'  }'+
		'}';
		WSOpportunitySendAltaResp r = WSOpportunitySendAltaResp.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSOpportunitySendAltaResp.Meta objMeta = new WSOpportunitySendAltaResp.Meta(System.JSON.createParser(json));
		System.assert(objMeta != null);
		System.assert(objMeta.allowed_includes == null);
		System.assert(objMeta.default_includes == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSOpportunitySendAltaResp.Allowed_includes objAllowed_includes = new WSOpportunitySendAltaResp.Allowed_includes(System.JSON.createParser(json));
		System.assert(objAllowed_includes != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSOpportunitySendAltaResp objWSOpportunitySendAltaResp = new WSOpportunitySendAltaResp(System.JSON.createParser(json));
		System.assert(objWSOpportunitySendAltaResp != null);
		System.assert(objWSOpportunitySendAltaResp.error == null);
		System.assert(objWSOpportunitySendAltaResp.data == null);
		System.assert(objWSOpportunitySendAltaResp.httpCode == null);
		System.assert(objWSOpportunitySendAltaResp.message == null);
		System.assert(objWSOpportunitySendAltaResp.meta == null);

		//json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		//WSOpportunitySendAltaResp.Notas objNotas = new WSOpportunitySendAltaResp.Notas(System.JSON.createParser(json));
		//System.assert(objNotas != null);
		//System.assert(objNotas.nota_id == null);
		//System.assert(objNotas.texto_nota == null);

		//json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		//WSOpportunitySendAltaResp.Data objData = new WSOpportunitySendAltaResp.Data(System.JSON.createParser(json));
		//System.assert(objData != null);
		//System.assert(objData.sf_id == null);
		//System.assert(objData.solafi_id == null);
		//System.assert(objData.estado_sol == null);
		//System.assert(objData.estado_dj == null);
		//System.assert(objData.codigo_as == null);
		//System.assert(objData.tipo_asoc == null);
		//System.assert(objData.notas == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		OpportunitySolicitudData.Notas objNotas = new OpportunitySolicitudData.Notas(System.JSON.createParser(json));
		System.assert(objNotas != null);
		System.assert(objNotas.nota_id == null);
		System.assert(objNotas.texto_nota == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		OpportunitySolicitudData objData = new OpportunitySolicitudData(System.JSON.createParser(json));
		System.assert(objData != null);
		System.assert(objData.sf_id == null);
		System.assert(objData.solafi_id == null);
		System.assert(objData.estado_sol == null);
		System.assert(objData.estado_dj == null);
		System.assert(objData.codigo_as == null);
		System.assert(objData.tipo_asoc == null);
		System.assert(objData.notas == null);
	}
}