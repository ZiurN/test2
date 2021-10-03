@isTest
public class WSCaseBajaRespTest {
  
    @isTest
    public static void testParse(){
        String json = '{'+
            '   \"data\": {'+
            '       \"caso_id\": \"79\",'+
            '       \"origen\": \"W\",'+
            '       \"tipo\": \"APREVIA\",'+
            '       \"codigo\": \"234428/65\",'+
            '       \"sf_id\": \"5008A000008A8qcQAC\",'+
            '       \"nro_caso_sf\": \"00011999\",'+
            '       \"estado_sf\": \"Pendiente\",'+
            '       \"fecha_registro\": null'+
            '   },'+
            '   \"message\": \"Se generó el caso 00011999.\",'+
            '    \"meta\": {'+
            '        \"allowed_includes\": [],'+
            '        \"default_includes\": []'+
            '    }'+
            '}';

        WSCaseBajaResp r = WSCaseBajaResp.parse(json);
        System.assert(r != null);

        
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCaseBajaResp.Meta objMeta = new WSCaseBajaResp.Meta(System.JSON.createParser(json));
		System.assert(objMeta != null);
		System.assert(objMeta.allowed_includes == null);
		System.assert(objMeta.default_includes == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCaseBajaResp.Allowed_includes objAllowed_includes = new WSCaseBajaResp.Allowed_includes(System.JSON.createParser(json));
		System.assert(objAllowed_includes != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSCaseBajaResp objWSCaseBajaResp = new WSCaseBajaResp(System.JSON.createParser(json));
		System.assert(objWSCaseBajaResp != null);
		System.assert(objWSCaseBajaResp.data == null);
		System.assert(objWSCaseBajaResp.meta == null);
    }
}