//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class WSPrestadorGetPresupuestosRespTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"data\": ['+
		'        {'+
		'            \"efe_codigo\": \"700076\",'+
		'            \"fecha\": \"2019-01-31\",'+
		'            \"nombre_arch\": \"700076_p_20190131.pdf\",'+
		'            \"descripcion\": \"Presup. Discectomia y Artrodesis Instrumentada af 39573-10\",'+
		'            \"p_link\": \"https://acaiasnew.acasalud.com.ar/dd_convenios/700076_p_20190131.pdf\"'+
		'        },'+
		'        {'+
		'            \"efe_codigo\": \"700076\",'+
		'            \"fecha\": \"2018-12-19\",'+
		'            \"nombre_arch\": \"700076_p_20181219.pdf\",'+
		'            \"descripcion\": \"Presup. Honorarios Resección de tumor vaginal af 91550-15\",'+
		'            \"p_link\": \"https://acaiasnew.acasalud.com.ar/dd_convenios/700076_p_20181219.pdf\"'+
		'        },'+
		'        {'+
		'            \"efe_codigo\": \"700076\",'+
		'            \"fecha\": \"2018-12-07\",'+
		'            \"nombre_arch\": \"700076_P_20181207.pdf\",'+
		'            \"descripcion\": \"Presup. sesion de la funcios deglutoria x5 Af. 207817-23\",'+
		'            \"p_link\": \"https://acaiasnew.acasalud.com.ar/dd_convenios/700076_P_20181207.pdf\"'+
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
		'            ],'+
		'            \"pageSize\": {'+
		'                \"0\": \"?pageSize=0\",'+
		'                \"15\": \"?pageSize=15\",'+
		'                \"50\": \"?pageSize=50\",'+
		'                \"100\": \"?pageSize=100\"'+
		'            }'+
		'        }'+
		'    }'+
		'}';
		WSPrestadorGetPresupuestosResp r = WSPrestadorGetPresupuestosResp.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSPrestadorGetPresupuestosResp.Meta objMeta = new WSPrestadorGetPresupuestosResp.Meta(System.JSON.createParser(json));
		System.assert(objMeta != null);
		System.assert(objMeta.allowed_filters == null);
		System.assert(objMeta.allowed_sorts == null);
		System.assert(objMeta.allowed_appends == null);
		System.assert(objMeta.allowed_fields == null);
		System.assert(objMeta.allowed_includes == null);
		System.assert(objMeta.default_includes == null);
		System.assert(objMeta.optional_get_vars == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSPrestadorGetPresupuestosResp.Optional_get_vars objOptional_get_vars = new WSPrestadorGetPresupuestosResp.Optional_get_vars(System.JSON.createParser(json));
		System.assert(objOptional_get_vars != null);
		System.assert(objOptional_get_vars.sortBy == null);
		System.assert(objOptional_get_vars.sortOrder == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSPrestadorGetPresupuestosResp objWSPrestadorGetPresupuestosResp = new WSPrestadorGetPresupuestosResp(System.JSON.createParser(json));
		System.assert(objWSPrestadorGetPresupuestosResp != null);
		System.assert(objWSPrestadorGetPresupuestosResp.data == null);
		System.assert(objWSPrestadorGetPresupuestosResp.meta == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSPrestadorGetPresupuestosResp.Data objData = new WSPrestadorGetPresupuestosResp.Data(System.JSON.createParser(json));
		System.assert(objData != null);
		System.assert(objData.efe_codigo == null);
		System.assert(objData.fecha == null);
		System.assert(objData.nombre_arch == null);
		System.assert(objData.descripcion == null);
		System.assert(objData.p_link == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSPrestadorGetPresupuestosResp.Allowed_filters objAllowed_filters = new WSPrestadorGetPresupuestosResp.Allowed_filters(System.JSON.createParser(json));
		System.assert(objAllowed_filters != null);
	}
}