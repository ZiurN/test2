//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class WSAsociadoGetAportesTransferidosRespTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"data\": ['+
		'        {'+
		'            \"dnat_id\": \"602\",'+
		'            \"periodo\": \"2002-12-01\",'+
		'            \"cuit\": \"33533717999\",'+
		'            \"empleador\": \"600055\",'+
		'            \"nombre_empleador\": \"COOP. AGROP. DE ARMSTRONG LTDA.\",'+
		'            \"obra_social\": \"101604\",'+
		'            \"cod_ooss\": \"640008\",'+
		'            \"nombre_ooss\": \"O.S.P.ACA\",'+
		'            \"cuil\": \"20162477782\",'+
		'            \"origen_aporte\": \"MAN\",'+
		'            \"aporte\": \"504.33\",'+
		'            \"aporte_reconocido\": \"0\",'+
		'            \"aporte_derivado\": \"0\",'+
		'            \"subsidio\": \"0\",'+
		'            \"secuencia\": \"0\",'+
		'            \"constribucion\": \"0\",'+
		'            \"adherentes\": \"0\",'+
		'            \"remuneracion\": \"0\",'+
		'            \"familiares\": \"0\",'+
		'            \"ooss_cargada\": \"101604\",'+
		'            \"at_id\": 1903,'+
		'            \"secuencia_at\": \"1903\",'+
		'            \"origen_aporte_at\": \"N/A\",'+
		'            \"secuencia_nominal\": \"0\",'+
		'            \"origen_aporte_nomi\": \"MAN\",'+
		'            \"total_aportes\": \"0\",'+
		'            \"total_aportes_reconocidos\": null,'+
		'            \"total_familiares\": \"0\",'+
		'            \"total_remuneraciones\": \"0\",'+
		'            \"total_aportes_derivados\": null,'+
		'            \"total_constribucion\": \"0\",'+
		'            \"total_adherentes\": \"0\",'+
		'            \"total_aportes_nomi\": \"1738.64\",'+
		'            \"total_aportes_reconocidos_nomi\": \"0\",'+
		'            \"total_familiares_nomi\": \"0\",'+
		'            \"total_remuneracines_nomi\": \"0\",'+
		'            \"total_aportes_derivados_nomi\": \"0\",'+
		'            \"total_contribucion_nom\": \"0\",'+
		'            \"total_adherentes_nomi\": \"0\"'+
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
		WSAsociadoGetAportesTransferidosResp r = WSAsociadoGetAportesTransferidosResp.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoGetAportesTransferidosResp.Meta objMeta = new WSAsociadoGetAportesTransferidosResp.Meta(System.JSON.createParser(json));
		System.assert(objMeta != null);
		System.assert(objMeta.allowed_filters == null);
		System.assert(objMeta.allowed_sorts == null);
		System.assert(objMeta.allowed_appends == null);
		System.assert(objMeta.allowed_fields == null);
		System.assert(objMeta.allowed_includes == null);
		System.assert(objMeta.default_includes == null);
		System.assert(objMeta.optional_get_vars == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoGetAportesTransferidosResp.Optional_get_vars objOptional_get_vars = new WSAsociadoGetAportesTransferidosResp.Optional_get_vars(System.JSON.createParser(json));
		System.assert(objOptional_get_vars != null);
		System.assert(objOptional_get_vars.sortBy == null);
		System.assert(objOptional_get_vars.sortOrder == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoGetAportesTransferidosResp.Data objData = new WSAsociadoGetAportesTransferidosResp.Data(System.JSON.createParser(json));
		System.assert(objData != null);
		System.assert(objData.dnat_id == null);
		System.assert(objData.periodo == null);
		System.assert(objData.cuit == null);
		System.assert(objData.empleador == null);
		System.assert(objData.nombre_empleador == null);
		System.assert(objData.obra_social == null);
		System.assert(objData.cod_ooss == null);
		System.assert(objData.nombre_ooss == null);
		System.assert(objData.cuil == null);
		System.assert(objData.origen_aporte == null);
		System.assert(objData.aporte == null);
		System.assert(objData.aporte_reconocido == null);
		System.assert(objData.aporte_derivado == null);
		System.assert(objData.subsidio == null);
		System.assert(objData.secuencia == null);
		System.assert(objData.constribucion == null);
		System.assert(objData.adherentes == null);
		System.assert(objData.remuneracion == null);
		System.assert(objData.familiares == null);
		System.assert(objData.ooss_cargada == null);
		System.assert(objData.at_id == null);
		System.assert(objData.secuencia_at == null);
		System.assert(objData.origen_aporte_at == null);
		System.assert(objData.secuencia_nominal == null);
		System.assert(objData.origen_aporte_nomi == null);
		System.assert(objData.total_aportes == null);
		System.assert(objData.total_aportes_reconocidos == null);
		System.assert(objData.total_familiares == null);
		System.assert(objData.total_remuneraciones == null);
		System.assert(objData.total_aportes_derivados == null);
		System.assert(objData.total_constribucion == null);
		System.assert(objData.total_adherentes == null);
		System.assert(objData.total_aportes_nomi == null);
		System.assert(objData.total_aportes_reconocidos_nomi == null);
		System.assert(objData.total_familiares_nomi == null);
		System.assert(objData.total_remuneracines_nomi == null);
		System.assert(objData.total_aportes_derivados_nomi == null);
		System.assert(objData.total_contribucion_nom == null);
		System.assert(objData.total_adherentes_nomi == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoGetAportesTransferidosResp objWSAsociadoGetAportesTransferidosResp = new WSAsociadoGetAportesTransferidosResp(System.JSON.createParser(json));
		System.assert(objWSAsociadoGetAportesTransferidosResp != null);
		System.assert(objWSAsociadoGetAportesTransferidosResp.data == null);
		System.assert(objWSAsociadoGetAportesTransferidosResp.meta == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoGetAportesTransferidosResp.Allowed_filters objAllowed_filters = new WSAsociadoGetAportesTransferidosResp.Allowed_filters(System.JSON.createParser(json));
		System.assert(objAllowed_filters != null);
	}
}