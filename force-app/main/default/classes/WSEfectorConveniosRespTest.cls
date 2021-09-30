//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class WSEfectorConveniosRespTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"data\": ['+
		'        {'+
		'            \"efe_codigo\": \"700047\",'+
		'            \"fecha\": \"2019-01-01\",'+
		'            \"nombre_arch\": \"700047_M_20190101.pdf\",'+
		'            \"modulo\": null,'+
		'            \"arancel\": null,'+
		'            \"anexo\": null,'+
		'            \"descripcion\": \"VALORES ENERO 2019\",'+
		'            \"p_link\": \"http://www.extranet.acasalud.com.ar/SF/700047_M_20190101.pdf\"'+
		'        },'+
		'        {'+
		'            \"efe_codigo\": \"700047\",'+
		'            \"fecha\": \"2018-10-01\",'+
		'            \"nombre_arch\": \"700047_M_20181001.pdf\",'+
		'            \"modulo\": null,'+
		'            \"arancel\": null,'+
		'            \"anexo\": null,'+
		'            \"descripcion\": \"VALORES OCTUBRE 2018\",'+
		'            \"p_link\": \"http://www.extranet.acasalud.com.ar/SF/700047_M_20181001.pdf\"'+
		'        },'+
		'        {'+
		'            \"efe_codigo\": \"700047\",'+
		'            \"fecha\": \"2018-07-01\",'+
		'            \"nombre_arch\": \"700047_M_20180701.pdf\",'+
		'            \"modulo\": null,'+
		'            \"arancel\": null,'+
		'            \"anexo\": null,'+
		'            \"descripcion\": \"VALORES JULIO 2018\",'+
		'            \"p_link\": \"http://www.extranet.acasalud.com.ar/SF/700047_M_20180701.pdf\"'+
		'        },'+
		'        {'+
		'            \"efe_codigo\": \"700047\",'+
		'            \"fecha\": \"2018-02-01\",'+
		'            \"nombre_arch\": \"700047_M_20180201.pdf\",'+
		'            \"modulo\": null,'+
		'            \"arancel\": null,'+
		'            \"anexo\": null,'+
		'            \"descripcion\": \"VALORES FEBRERO 2018\",'+
		'            \"p_link\": \"http://www.extranet.acasalud.com.ar/SF/700047_M_20180201.pdf\"'+
		'        }'+
		'    ],'+
		'    \"meta\": {'+
		'        \"allowed_filters\": [],'+
		'        \"allowed_sorts\": [],'+
		'        \"allowed_appends\": [],'+
		'        \"allowed_fields\": [],'+
		'        \"allowed_includes\": [],'+
		'        \"default_includes\": [],'+
		'        \"optional_get_vars\": {'+
		'            \"sortBy\": [],'+
		'            \"sortOrder\": ['+
		'                \"asc\",'+
		'                \"desc\"'+
		'            ]'+
		'        }'+
		'    }'+
		'}';
		WSEfectorConveniosResp r = WSEfectorConveniosResp.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSEfectorConveniosResp.Meta objMeta = new WSEfectorConveniosResp.Meta(System.JSON.createParser(json));
		System.assert(objMeta != null);
		System.assert(objMeta.allowed_filters == null);
		System.assert(objMeta.allowed_sorts == null);
		System.assert(objMeta.allowed_appends == null);
		System.assert(objMeta.allowed_fields == null);
		System.assert(objMeta.allowed_includes == null);
		System.assert(objMeta.default_includes == null);
		System.assert(objMeta.optional_get_vars == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSEfectorConveniosResp.Optional_get_vars objOptional_get_vars = new WSEfectorConveniosResp.Optional_get_vars(System.JSON.createParser(json));
		System.assert(objOptional_get_vars != null);
		System.assert(objOptional_get_vars.sortBy == null);
		System.assert(objOptional_get_vars.sortOrder == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSEfectorConveniosResp.Data objData = new WSEfectorConveniosResp.Data(System.JSON.createParser(json));
		System.assert(objData != null);
		System.assert(objData.efe_codigo == null);
		System.assert(objData.fecha == null);
		System.assert(objData.nombre_arch == null);
		System.assert(objData.modulo == null);
		System.assert(objData.arancel == null);
		System.assert(objData.anexo == null);
		System.assert(objData.descripcion == null);
		System.assert(objData.p_link == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSEfectorConveniosResp objWSEfectorConveniosResp = new WSEfectorConveniosResp(System.JSON.createParser(json));
		System.assert(objWSEfectorConveniosResp != null);
		System.assert(objWSEfectorConveniosResp.data == null);
		System.assert(objWSEfectorConveniosResp.meta == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSEfectorConveniosResp.Allowed_filters objAllowed_filters = new WSEfectorConveniosResp.Allowed_filters(System.JSON.createParser(json));
		System.assert(objAllowed_filters != null);
	}
}