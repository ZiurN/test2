//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class WSAsociadoGetFacturasRespTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"data\": ['+
		'        {'+
		'            \"dat_numero\": \"23433905\",'+
		'            \"ent_codigo\": \"184191\",'+
		'            \"tcp_codigo\": \"FA\",'+
		'            \"letra\": \"B\",'+
		'            \"sucursal\": \"21\",'+
		'            \"numero_fac\": \"811748\",'+
		'            \"fecha_factura\": \"2019-06-21\",'+
		'            \"fecha_vto\": \"2019-07-10\",'+
		'            \"importe\": \"10207.72\",'+
		'            \"saldo\": \"10207.72\",'+
		'            \"link_pdf\": \"http://www.extranet.acasalud.com.ar/SF/23433905.pdf\"'+
		'        },'+
		'        {'+
		'            \"dat_numero\": \"23247476\",'+
		'            \"ent_codigo\": \"184191\",'+
		'            \"tcp_codigo\": \"FA\",'+
		'            \"letra\": \"B\",'+
		'            \"sucursal\": \"21\",'+
		'            \"numero_fac\": \"792575\",'+
		'            \"fecha_factura\": \"2019-05-22\",'+
		'            \"fecha_vto\": \"2019-06-10\",'+
		'            \"importe\": \"8993.74\",'+
		'            \"saldo\": \"0\",'+
		'            \"link_pdf\": \"http://www.extranet.acasalud.com.ar/SF/23247476.pdf\"'+
		'        },'+
		'        {'+
		'            \"dat_numero\": \"23056561\",'+
		'            \"ent_codigo\": \"184191\",'+
		'            \"tcp_codigo\": \"FA\",'+
		'            \"letra\": \"B\",'+
		'            \"sucursal\": \"21\",'+
		'            \"numero_fac\": \"773612\",'+
		'            \"fecha_factura\": \"2019-04-24\",'+
		'            \"fecha_vto\": \"2019-05-10\",'+
		'            \"importe\": \"7025.77\",'+
		'            \"saldo\": \"0\",'+
		'            \"link_pdf\": \"http://www.extranet.acasalud.com.ar/SF/23056561.pdf\"'+
		'        },'+
		'        {'+
		'            \"dat_numero\": \"22884258\",'+
		'            \"ent_codigo\": \"184191\",'+
		'            \"tcp_codigo\": \"FA\",'+
		'            \"letra\": \"B\",'+
		'            \"sucursal\": \"21\",'+
		'            \"numero_fac\": \"754685\",'+
		'            \"fecha_factura\": \"2019-03-21\",'+
		'            \"fecha_vto\": \"2019-04-10\",'+
		'            \"importe\": \"7901.41\",'+
		'            \"saldo\": \"0\",'+
		'            \"link_pdf\": \"http://www.extranet.acasalud.com.ar/SF/22884258.pdf\"'+
		'        },'+
		'        {'+
		'            \"dat_numero\": \"22713704\",'+
		'            \"ent_codigo\": \"184191\",'+
		'            \"tcp_codigo\": \"FA\",'+
		'            \"letra\": \"B\",'+
		'            \"sucursal\": \"21\",'+
		'            \"numero_fac\": \"735855\",'+
		'            \"fecha_factura\": \"2019-02-21\",'+
		'            \"fecha_vto\": \"2019-03-11\",'+
		'            \"importe\": \"7642.9\",'+
		'            \"saldo\": \"0\",'+
		'            \"link_pdf\": \"http://www.extranet.acasalud.com.ar/SF/22713704.pdf\"'+
		'        },'+
		'        {'+
		'            \"dat_numero\": \"22525774\",'+
		'            \"ent_codigo\": \"184191\",'+
		'            \"tcp_codigo\": \"FA\",'+
		'            \"letra\": \"B\",'+
		'            \"sucursal\": \"21\",'+
		'            \"numero_fac\": \"717235\",'+
		'            \"fecha_factura\": \"2019-01-23\",'+
		'            \"fecha_vto\": \"2019-02-11\",'+
		'            \"importe\": \"5535.93\",'+
		'            \"saldo\": \"0\",'+
		'            \"link_pdf\": \"http://www.extranet.acasalud.com.ar/SF/22525774.pdf\"'+
		'        },'+
		'        {'+
		'            \"dat_numero\": \"22309596\",'+
		'            \"ent_codigo\": \"184191\",'+
		'            \"tcp_codigo\": \"FA\",'+
		'            \"letra\": \"B\",'+
		'            \"sucursal\": \"21\",'+
		'            \"numero_fac\": \"698766\",'+
		'            \"fecha_factura\": \"2018-12-21\",'+
		'            \"fecha_vto\": \"2019-01-14\",'+
		'            \"importe\": \"4647.25\",'+
		'            \"saldo\": \"0\",'+
		'            \"link_pdf\": \"http://www.extranet.acasalud.com.ar/SF/22309596.pdf\"'+
		'        },'+
		'        {'+
		'            \"dat_numero\": \"22129210\",'+
		'            \"ent_codigo\": \"184191\",'+
		'            \"tcp_codigo\": \"FA\",'+
		'            \"letra\": \"B\",'+
		'            \"sucursal\": \"21\",'+
		'            \"numero_fac\": \"680444\",'+
		'            \"fecha_factura\": \"2018-11-21\",'+
		'            \"fecha_vto\": \"2018-12-12\",'+
		'            \"importe\": \"6042.02\",'+
		'            \"saldo\": \"0\",'+
		'            \"link_pdf\": \"http://www.extranet.acasalud.com.ar/SF/22129210.pdf\"'+
		'        },'+
		'        {'+
		'            \"dat_numero\": \"21916566\",'+
		'            \"ent_codigo\": \"184191\",'+
		'            \"tcp_codigo\": \"FA\",'+
		'            \"letra\": \"B\",'+
		'            \"sucursal\": \"21\",'+
		'            \"numero_fac\": \"662328\",'+
		'            \"fecha_factura\": \"2018-10-22\",'+
		'            \"fecha_vto\": \"2018-11-12\",'+
		'            \"importe\": \"4064.43\",'+
		'            \"saldo\": \"0\",'+
		'            \"link_pdf\": \"http://www.extranet.acasalud.com.ar/SF/21916566.pdf\"'+
		'        },'+
		'        {'+
		'            \"dat_numero\": \"21735848\",'+
		'            \"ent_codigo\": \"184191\",'+
		'            \"tcp_codigo\": \"FA\",'+
		'            \"letra\": \"B\",'+
		'            \"sucursal\": \"21\",'+
		'            \"numero_fac\": \"629086\",'+
		'            \"fecha_factura\": \"2018-09-21\",'+
		'            \"fecha_vto\": \"2018-10-12\",'+
		'            \"importe\": \"5315.41\",'+
		'            \"saldo\": \"0\",'+
		'            \"link_pdf\": \"http://www.extranet.acasalud.com.ar/SF/21735848.pdf\"'+
		'        },'+
		'        {'+
		'            \"dat_numero\": \"21542704\",'+
		'            \"ent_codigo\": \"184191\",'+
		'            \"tcp_codigo\": \"FA\",'+
		'            \"letra\": \"B\",'+
		'            \"sucursal\": \"21\",'+
		'            \"numero_fac\": \"611240\",'+
		'            \"fecha_factura\": \"2018-08-21\",'+
		'            \"fecha_vto\": \"2018-09-12\",'+
		'            \"importe\": \"5498.17\",'+
		'            \"saldo\": \"0\",'+
		'            \"link_pdf\": \"http://www.extranet.acasalud.com.ar/SF/21542704.pdf\"'+
		'        },'+
		'        {'+
		'            \"dat_numero\": \"21406301\",'+
		'            \"ent_codigo\": \"184191\",'+
		'            \"tcp_codigo\": \"FA\",'+
		'            \"letra\": \"B\",'+
		'            \"sucursal\": \"21\",'+
		'            \"numero_fac\": \"593498\",'+
		'            \"fecha_factura\": \"2018-07-20\",'+
		'            \"fecha_vto\": \"2018-08-13\",'+
		'            \"importe\": \"5198.1\",'+
		'            \"saldo\": \"5198.1\",'+
		'            \"link_pdf\": \"http://www.extranet.acasalud.com.ar/SF/21406301.pdf\"'+
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
		WSAsociadoGetFacturasResp r = WSAsociadoGetFacturasResp.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoGetFacturasResp.Meta objMeta = new WSAsociadoGetFacturasResp.Meta(System.JSON.createParser(json));
		System.assert(objMeta != null);
		System.assert(objMeta.allowed_filters == null);
		System.assert(objMeta.allowed_sorts == null);
		System.assert(objMeta.allowed_appends == null);
		System.assert(objMeta.allowed_fields == null);
		System.assert(objMeta.allowed_includes == null);
		System.assert(objMeta.default_includes == null);
		System.assert(objMeta.optional_get_vars == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoGetFacturasResp.Optional_get_vars objOptional_get_vars = new WSAsociadoGetFacturasResp.Optional_get_vars(System.JSON.createParser(json));
		System.assert(objOptional_get_vars != null);
		System.assert(objOptional_get_vars.sortBy == null);
		System.assert(objOptional_get_vars.sortOrder == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoGetFacturasResp.Data objData = new WSAsociadoGetFacturasResp.Data(System.JSON.createParser(json));
		System.assert(objData != null);
		System.assert(objData.dat_numero == null);
		System.assert(objData.ent_codigo == null);
		System.assert(objData.tcp_codigo == null);
		System.assert(objData.letra == null);
		System.assert(objData.sucursal == null);
		System.assert(objData.numero_fac == null);
		System.assert(objData.fecha_factura == null);
		System.assert(objData.fecha_vto == null);
		System.assert(objData.importe == null);
		System.assert(objData.saldo == null);
		System.assert(objData.link_pdf == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoGetFacturasResp.Allowed_filters objAllowed_filters = new WSAsociadoGetFacturasResp.Allowed_filters(System.JSON.createParser(json));
		System.assert(objAllowed_filters != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoGetFacturasResp objWSAsociadoGetFacturasResp = new WSAsociadoGetFacturasResp(System.JSON.createParser(json));
		System.assert(objWSAsociadoGetFacturasResp != null);
		System.assert(objWSAsociadoGetFacturasResp.data == null);
		System.assert(objWSAsociadoGetFacturasResp.meta == null);
	}
}