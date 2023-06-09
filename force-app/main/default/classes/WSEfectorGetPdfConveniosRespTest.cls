//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class WSEfectorGetPdfConveniosRespTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"error\": false,'+
		'    \"data\": ['+
		'        {'+
		'            \"efe_codigo\": \"700125\",'+
		'            \"fecha\": \"2019-01-01 00:00:00\",'+
		'            \"nombre_arch\": \"GRUGAMMA_M_20190101.pdf\",'+
		'            \"modulo\": null,'+
		'            \"arancel\": null,'+
		'            \"anexo\": null,'+
		'            \"descripcion\": \"VALORES ENERO 2019\",'+
		'            \"base64\": \"JVBERi0xLjUNCiW1tbW1\"'+
		'        },'+
		'        {'+
		'            \"efe_codigo\": \"700125\",'+
		'            \"fecha\": \"2018-10-01 00:00:00\",'+
		'            \"nombre_arch\": \"GGAMMA_20181001.pdf\",'+
		'            \"modulo\": null,'+
		'            \"arancel\": null,'+
		'            \"anexo\": null,'+
		'            \"descripcion\": \"VALORES OCTUBRE Y NOVIEMBRE 2018\",'+
		'            \"base64\": \"JVBERi0xLjUNCiW1tbW1\"'+
		'        },'+
		'        {'+
		'            \"efe_codigo\": \"700125\",'+
		'            \"fecha\": \"2018-08-01 00:00:00\",'+
		'            \"nombre_arch\": \"GGAMMA_20180801.pdf\",'+
		'            \"modulo\": null,'+
		'            \"arancel\": null,'+
		'            \"anexo\": null,'+
		'            \"descripcion\": \"VALORES AGOSTO 2018\",'+
		'            \"base64\": \"JVBERi0xLjcNCiW1tbW1DQoxIDAgb\"'+
		'        }'+
		'    ],'+
		'    \"httpCode\": 201,'+
		'    \"message\": \"Se obtuvieron los convenios.\",'+
		'    \"meta\": {'+
		'        \"allowed_includes\": [],'+
		'        \"default_includes\": []'+
		'    }'+
		'}';
		WSEfectorGetPdfConveniosResp r = WSEfectorGetPdfConveniosResp.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSEfectorGetPdfConveniosResp.Meta objMeta = new WSEfectorGetPdfConveniosResp.Meta(System.JSON.createParser(json));
		System.assert(objMeta != null);
		System.assert(objMeta.allowed_includes == null);
		System.assert(objMeta.default_includes == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSEfectorGetPdfConveniosResp.Allowed_includes objAllowed_includes = new WSEfectorGetPdfConveniosResp.Allowed_includes(System.JSON.createParser(json));
		System.assert(objAllowed_includes != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSEfectorGetPdfConveniosResp.Data objData = new WSEfectorGetPdfConveniosResp.Data(System.JSON.createParser(json));
		System.assert(objData != null);
		System.assert(objData.efe_codigo == null);
		System.assert(objData.fecha == null);
		System.assert(objData.nombre_arch == null);
		System.assert(objData.modulo == null);
		System.assert(objData.arancel == null);
		System.assert(objData.anexo == null);
		System.assert(objData.descripcion == null);
		System.assert(objData.base64 == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSEfectorGetPdfConveniosResp objWSEfectorGetPdfConveniosResp = new WSEfectorGetPdfConveniosResp(System.JSON.createParser(json));
		System.assert(objWSEfectorGetPdfConveniosResp != null);
		System.assert(objWSEfectorGetPdfConveniosResp.error == null);
		System.assert(objWSEfectorGetPdfConveniosResp.data == null);
		System.assert(objWSEfectorGetPdfConveniosResp.httpCode == null);
		System.assert(objWSEfectorGetPdfConveniosResp.message == null);
		System.assert(objWSEfectorGetPdfConveniosResp.meta == null);
	}
}