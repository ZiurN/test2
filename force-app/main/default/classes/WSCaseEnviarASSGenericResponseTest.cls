@isTest
public class WSCaseEnviarASSGenericResponseTest {
    public static String jsonError = '{'+
		'    \"data\": {'+
		'        \"error\": true,'+
		'        \"errors\": {'+
		'            \"familiar.0.nombres\": ['+
		'                \"El campo familiar.0.nombres es obligatorio.\"'+
		'            ]'+
		'        },'+
		'        \"errorType\": \"exception\",'+
		'        \"httpCode\": 422,'+
		'        \"message\": \"The given data was invalid.\",'+
		'        \"debug_message\": [],'+
		'        \"exception\": \"ValidationException\",'+
		'        \"file\": \"C:\\\\Apache24_64\\\\htdocs\\\\aca_salud_test\\\\vendor\\\\laravel\\\\framework\\\\src\\\\Illuminate\\\\Foundation\\\\Http\\\\FormRequest.php\",'+
		'        \"line\": 126'+
		'    }'+
		'}';

	public static String json(String notaId, String caseId) {
		return '{'+
		'  \"error\": false,'+
		'  \"data\": ['+
		'    {'+
		'      \"sf_id\": \"' + caseId + '\",'+
		'      \"solafi_id\": \"725187\",'+
		'      \"estado_sol\": \"INCOMPLETA\",'+
		'      \"estado_dj\": \"NUEVA\",'+
		'      \"codigo_as\": null,'+
		'      \"tipo_asoc\": \"DSAFAM\",'+
		'      \"afi_id\": null,'+
		'      \"empresa_codigo\": \"630001\",'+
		'      \"suc_empresa\": \"4\",'+
		'      \"notas\": ['+
		'        {'+
		'          \"nota_id\": \"129163\",'+
		'          \"texto_nota\": \"nota de prueba1\",'+
		'          \"sf_id\": \"' + notaId + '\"'+
		'        }'+
		'      ]'+
		'    }'+
		'  ],'+
		'  \"httpCode\": 200,'+
		'  \"message\": "Success Message",'+
		'  \"meta\": {'+
		'    \"allowed_includes\": [],'+
		'    \"default_includes\": []'+
		'  }'+
		'}';
	}

	public static String json(String notaId) {
		return json(notaId, '');
	}
	
	public static String jsonUpdate(String validId) {
		return '{'+
		'  \"error\": false,'+
		'  \"data\": ['+
		'    {'+
		'      \"sf_id\": \"\",'+
		'      \"solafi_id\": \"725187\",'+
		'      \"estado_sol\": \"COMPLETA\",'+
		'      \"estado_dj\": \"NUEVA\",'+
		'      \"codigo_as\": null,'+
		'      \"tipo_asoc\": \"DSAFAM\",'+
		'      \"afi_id\": null,'+
		'      \"empresa_codigo\": \"630001\",'+
		'      \"suc_empresa\": \"4\",'+
		'      \"notas\": ['+
		'        {'+
		'          \"nota_id\": \"129163\",'+
		'          \"texto_nota\": \"nota de prueba1\",'+
		'          \"sf_id\": \"' + validId + '\"'+
		'        }' +
		'      ]'+
		'    }'+
		'  ],'+
		'  \"httpCode\": 200,'+
		'  \"message\": "Success update message.",'+
		'  \"meta\": {'+
		'    \"allowed_includes\": [],'+
		'    \"default_includes\": []'+
		'  }'+
		'}';
	}
    
    static testMethod void testParse() {
		WSCaseEnviarASSGenericResponse obj = WSCaseEnviarASSGenericResponse.parse(json('someId'));
		System.assert(obj != null);
	}
}