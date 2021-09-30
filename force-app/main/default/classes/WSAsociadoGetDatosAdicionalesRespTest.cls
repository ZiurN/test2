//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class WSAsociadoGetDatosAdicionalesRespTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"data\": ['+
		'        {'+
		'            \"codigo\": \"SC\",'+
		'            \"nombre\": \"SOCIO DE COOPERATIVA\",'+
		'            \"valor\": \"F\",'+
		'            \"observaciones\": null,'+
		'            \"obligatorio\": \"F\"'+
		'        },'+
		'        {'+
		'            \"codigo\": \"EM_S\",'+
		'            \"nombre\": \"DIRECCION DE MAIL DEL SOCIO\",'+
		'            \"valor\": \"MTARTABINI@ACASALUD.COM.AR\",'+
		'            \"observaciones\": null,'+
		'            \"obligatorio\": \"F\"'+
		'        },'+
		'        {'+
		'            \"codigo\": \"FE\",'+
		'            \"nombre\": \"ADHESION FACTURA ELECTRONICA\",'+
		'            \"valor\": \"N\",'+
		'            \"observaciones\": null,'+
		'            \"obligatorio\": \"F\"'+
		'        },'+
		'        {'+
		'            \"codigo\": \"APOR\",'+
		'            \"nombre\": \"APORTES ESTIMADOS OBLDIR\",'+
		'            \"valor\": \"910\",'+
		'            \"observaciones\": null,'+
		'            \"obligatorio\": \"F\"'+
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
		WSAsociadoGetDatosAdicionalesResp r = WSAsociadoGetDatosAdicionalesResp.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoGetDatosAdicionalesResp.Meta objMeta = new WSAsociadoGetDatosAdicionalesResp.Meta(System.JSON.createParser(json));
		System.assert(objMeta != null);
		System.assert(objMeta.allowed_filters == null);
		System.assert(objMeta.allowed_sorts == null);
		System.assert(objMeta.allowed_appends == null);
		System.assert(objMeta.allowed_fields == null);
		System.assert(objMeta.allowed_includes == null);
		System.assert(objMeta.default_includes == null);
		System.assert(objMeta.optional_get_vars == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoGetDatosAdicionalesResp.Optional_get_vars objOptional_get_vars = new WSAsociadoGetDatosAdicionalesResp.Optional_get_vars(System.JSON.createParser(json));
		System.assert(objOptional_get_vars != null);
		System.assert(objOptional_get_vars.sortBy == null);
		System.assert(objOptional_get_vars.sortOrder == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoGetDatosAdicionalesResp objWSAsociadoGetDatosAdicionalesResp = new WSAsociadoGetDatosAdicionalesResp(System.JSON.createParser(json));
		System.assert(objWSAsociadoGetDatosAdicionalesResp != null);
		System.assert(objWSAsociadoGetDatosAdicionalesResp.data == null);
		System.assert(objWSAsociadoGetDatosAdicionalesResp.meta == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoGetDatosAdicionalesResp.Data objData = new WSAsociadoGetDatosAdicionalesResp.Data(System.JSON.createParser(json));
		System.assert(objData != null);
		System.assert(objData.codigo == null);
		System.assert(objData.nombre == null);
		System.assert(objData.valor == null);
		System.assert(objData.observaciones == null);
		System.assert(objData.obligatorio == null);
		System.assert(objData.tipo_dato_adicional == null);
		System.assert(objData.descripcion_dato_adicional == null);
		System.assert(objData.tipo_dato == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoGetDatosAdicionalesResp.Allowed_filters objAllowed_filters = new WSAsociadoGetDatosAdicionalesResp.Allowed_filters(System.JSON.createParser(json));
		System.assert(objAllowed_filters != null);
	}
}