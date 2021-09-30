//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class WSAsociadoGetValoracionesRespTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"message\": \"\",'+
		'    \"data\": ['+
		'        {'+
		'            \"Tcc_Codigo\": \"BAS\",'+
		'            \"Importe\": \"2460.33\",'+
		'            \"Cantidad\": \"1\",'+
		'            \"Coeficiente\": \"1\",'+
		'            \"Coeficiente_General\": \"1\",'+
		'            \"Cga_Codigo\": \"\",'+
		'            \"Rcg_Codigo\": \"PERSONA\",'+
		'            \"Dca_Dca_Id\": \"\",'+
		'            \"Dca_Dca_Id_Ajuste\": \"\",'+
		'            \"Nombre_Clausula\": \"Cuota Basica\",'+
		'            \"Nombre_Cat_Grupal\": \"\",'+
		'            \"Nombre_Regla_Adic\": \"Persona\"'+
		'        },'+
		'        {'+
		'            \"Tcc_Codigo\": \"BAS\",'+
		'            \"Importe\": \"2460.33\",'+
		'            \"Cantidad\": \"1\",'+
		'            \"Coeficiente\": \"1\",'+
		'            \"Coeficiente_General\": \"1\",'+
		'            \"Cga_Codigo\": \"\",'+
		'            \"Rcg_Codigo\": \"PERSONA\",'+
		'            \"Dca_Dca_Id\": \"\",'+
		'            \"Dca_Dca_Id_Ajuste\": \"\",'+
		'            \"Nombre_Clausula\": \"Cuota Basica\",'+
		'            \"Nombre_Cat_Grupal\": \"\",'+
		'            \"Nombre_Regla_Adic\": \"Persona\"'+
		'        },'+
		'        {'+
		'            \"Tcc_Codigo\": \"BAS\",'+
		'            \"Importe\": \"2460.33\",'+
		'            \"Cantidad\": \"1\",'+
		'            \"Coeficiente\": \"1\",'+
		'            \"Coeficiente_General\": \"1\",'+
		'            \"Cga_Codigo\": \"\",'+
		'            \"Rcg_Codigo\": \"PERSONA\",'+
		'            \"Dca_Dca_Id\": \"\",'+
		'            \"Dca_Dca_Id_Ajuste\": \"\",'+
		'            \"Nombre_Clausula\": \"Cuota Basica\",'+
		'            \"Nombre_Cat_Grupal\": \"\",'+
		'            \"Nombre_Regla_Adic\": \"Persona\"'+
		'        },'+
		'        {'+
		'            \"Tcc_Codigo\": \"BAS\",'+
		'            \"Importe\": \"2460.33\",'+
		'            \"Cantidad\": \"1\",'+
		'            \"Coeficiente\": \"1\",'+
		'            \"Coeficiente_General\": \"1\",'+
		'            \"Cga_Codigo\": \"\",'+
		'            \"Rcg_Codigo\": \"PERSONA\",'+
		'            \"Dca_Dca_Id\": \"\",'+
		'            \"Dca_Dca_Id_Ajuste\": \"\",'+
		'            \"Nombre_Clausula\": \"Cuota Basica\",'+
		'            \"Nombre_Cat_Grupal\": \"\",'+
		'            \"Nombre_Regla_Adic\": \"Persona\"'+
		'        }'+
		'    ]'+
		'}';
		WSAsociadoGetValoracionesResp r = WSAsociadoGetValoracionesResp.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoGetValoracionesResp objWSAsociadoGetValoracionesResp = new WSAsociadoGetValoracionesResp(System.JSON.createParser(json));
		System.assert(objWSAsociadoGetValoracionesResp != null);
		System.assert(objWSAsociadoGetValoracionesResp.message == null);
		System.assert(objWSAsociadoGetValoracionesResp.data == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WSAsociadoGetValoracionesResp.Data objData = new WSAsociadoGetValoracionesResp.Data(System.JSON.createParser(json));
		System.assert(objData != null);
		System.assert(objData.Tcc_Codigo == null);
		System.assert(objData.Importe == null);
		System.assert(objData.Cantidad == null);
		System.assert(objData.Coeficiente == null);
		System.assert(objData.Coeficiente_General == null);
		System.assert(objData.Cga_Codigo == null);
		System.assert(objData.Rcg_Codigo == null);
		System.assert(objData.Dca_Dca_Id == null);
		System.assert(objData.Dca_Dca_Id_Ajuste == null);
		System.assert(objData.Nombre_Clausula == null);
		System.assert(objData.Nombre_Cat_Grupal == null);
		System.assert(objData.Nombre_Regla_Adic == null);
	}
}