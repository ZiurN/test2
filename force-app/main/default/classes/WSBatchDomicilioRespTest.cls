@isTest 
private class WSBatchDomicilioRespTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"data\": ['+
		'        {'+
		'            \"rn\": \"1\",'+
		'            \"afi_id\": \"130408\",'+
		'            \"domiafi_id\": \"72058\",'+
		'            \"calle\": \"ALBERDI\",'+
		'            \"numero\": \"130\",'+
		'            \"piso\": \"1\",'+
		'            \"dpto\": \"A\",'+
		'            \"loc_id\": \"2870\",'+
		'            \"td_codigo\": \"COM\",'+
		'            \"f_modif\": \"2020-06-30 17:48:12\"'+
		'        },'+
		'        {'+
		'            \"rn\": \"2\",'+
		'            \"afi_id\": \"130591\",'+
		'            \"domiafi_id\": \"72241\",'+
		'            \"calle\": \"AGRELO\",'+
		'            \"numero\": \"873\",'+
		'            \"piso\": null,'+
		'            \"dpto\": null,'+
		'            \"loc_id\": \"2153\",'+
		'            \"td_codigo\": \"COM\",'+
		'            \"f_modif\": \"2020-06-18 01:59:53\"'+
		'        },'+
		'        {'+
		'            \"rn\": \"3\",'+
		'            \"afi_id\": \"131784\",'+
		'            \"domiafi_id\": \"352276\",'+
		'            \"calle\": \"MIGUEL CANE\",'+
		'            \"numero\": \"406\",'+
		'            \"piso\": null,'+
		'            \"dpto\": null,'+
		'            \"loc_id\": \"10055\",'+
		'            \"td_codigo\": \"COM\",'+
		'            \"f_modif\": \"2020-06-05 14:08:17\"'+
		'        },'+
		'        {'+
		'            \"rn\": \"4\",'+
		'            \"afi_id\": \"131811\",'+
		'            \"domiafi_id\": \"73461\",'+
		'            \"calle\": \"7 DE OCTUBRE\",'+
		'            \"numero\": \"229\",'+
		'            \"piso\": null,'+
		'            \"dpto\": null,'+
		'            \"loc_id\": \"3032\",'+
		'            \"td_codigo\": \"COM\",'+
		'            \"f_modif\": \"2020-06-05 14:53:58\"'+
		'        },'+
		'        {'+
		'            \"rn\": \"5\",'+
		'            \"afi_id\": \"130370\",'+
		'            \"domiafi_id\": \"354209\",'+
		'            \"calle\": \"SARMIENTO 728\",'+
		'            \"numero\": null,'+
		'            \"piso\": null,'+
		'            \"dpto\": null,'+
		'            \"loc_id\": \"2197\",'+
		'            \"td_codigo\": \"COM\",'+
		'            \"f_modif\": \"2020-07-08 15:59:22\"'+
		'        }'+
		'    ],'+
		'    \"links\": {'+
		'        \"first\": \"https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/domicilios/2020-06-01?page=1\",'+
		'        \"last\": \"https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/domicilios/2020-06-01?page=632\",'+
		'        \"prev\": \"test\",'+
		'        \"next\": \"https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/domicilios/2020-06-01?page=2\"'+
		'    },'+
		'    \"meta\": {'+
		'        \"current_page\": 1,'+
		'        \"from\": 1,'+
		'        \"last_page\": 632,'+
		'        \"path\": \"https://api-dev.acasalud.com.ar/aca_salud_dev/public/v1/salud/batch/asociados/domicilios/2020-06-01\",'+
		'        \"per_page\": 5,'+
		'        \"to\": 5,'+
		'        \"total\": 3159,'+
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
		WSBatchDomicilioResp r = WSBatchDomicilioResp.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSBatchDomicilioResp.Meta objMeta = new WSBatchDomicilioResp.Meta(System.JSON.createParser(json));
		System.assert(objMeta != null);
		System.assert(objMeta.current_page == null);
		System.assert(objMeta.from_Z == null);
		System.assert(objMeta.last_page == null);
		System.assert(objMeta.path == null);
		System.assert(objMeta.per_page == null);
		System.assert(objMeta.to == null);
		System.assert(objMeta.total == null);
		System.assert(objMeta.allowed_filters == null);
		System.assert(objMeta.allowed_sorts == null);
		System.assert(objMeta.allowed_appends == null);
		System.assert(objMeta.allowed_fields == null);
		System.assert(objMeta.allowed_includes == null);
		System.assert(objMeta.default_includes == null);
		System.assert(objMeta.optional_get_vars == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSBatchDomicilioResp.Optional_get_vars objOptional_get_vars = new WSBatchDomicilioResp.Optional_get_vars(System.JSON.createParser(json));
		System.assert(objOptional_get_vars != null);
		System.assert(objOptional_get_vars.sortBy == null);
		System.assert(objOptional_get_vars.sortOrder == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSBatchDomicilioResp.Links objLinks = new WSBatchDomicilioResp.Links(System.JSON.createParser(json));
		System.assert(objLinks != null);
		System.assert(objLinks.first == null);
		System.assert(objLinks.last == null);
		System.assert(objLinks.prev == null);
		System.assert(objLinks.next == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSBatchDomicilioResp.Data objData = new WSBatchDomicilioResp.Data(System.JSON.createParser(json));
		System.assert(objData != null);
		System.assert(objData.rn == null);
		System.assert(objData.afi_id == null);
		System.assert(objData.domiafi_id == null);
		System.assert(objData.calle == null);
		System.assert(objData.numero == null);
		System.assert(objData.piso == null);
		System.assert(objData.dpto == null);
		System.assert(objData.loc_id == null);
		System.assert(objData.td_codigo == null);
		System.assert(objData.f_modif == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSBatchDomicilioResp.Allowed_filters objAllowed_filters = new WSBatchDomicilioResp.Allowed_filters(System.JSON.createParser(json));
		System.assert(objAllowed_filters != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSBatchDomicilioResp objWSBatchDomicilioResp = new WSBatchDomicilioResp(System.JSON.createParser(json));
		System.assert(objWSBatchDomicilioResp != null);
		System.assert(objWSBatchDomicilioResp.data == null);
		System.assert(objWSBatchDomicilioResp.links == null);
		System.assert(objWSBatchDomicilioResp.meta == null);
	}
}