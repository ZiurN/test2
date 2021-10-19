public class WSOpportunityReingresoMock  {
	public static String getFound(String sf_id){
		return 
			'{' +
			  '"error": false,' +
			  '"data": [' +
			    '{' +
			      '"sf_id": "'+sf_id+'",' +
			      '"solafi_id": "723996",' +
			      '"estado_sol": "INCOMPLETA",' +
			      '"estado_dj": "NUEVA",' +
			      '"codigo_as": "210886/18",' +
			      '"tipo_asoc": "DSAFAM",' +
			      '"notas": [' +
			        '{' +
			          '"nota_id": "128788",' +
			          '"texto_nota": "Texto a insertar en notas."' +
			        '}' +
			      ']' +
			    '}' +
			  '],' +
			  '"httpCode": 200,' +
			  '"message": "Se actualizó satisfactoriamente la solicitud de reingreso.",' +
			  '"meta": {' +
			    '"allowed_includes": [],' +
			    '"default_includes": []' +
			  '}' +
			'}';
	}

	public static String getError(){
		return
			'{' +
			    '"data": {' +
			        '"error": true,' +
			        '"errors": {' +
			            '"encabezado.0.codigo_obrasocial": [' +
			                '"El campo encabezado.0.codigo_obrasocial es obligatorio cuando encabezado.0.tipo_reingreso es TIT."' +
			            '],' +
			            '"encabezado.0.civa_codigo": [' +
			                '"El campo encabezado.0.civa_codigo es obligatorio cuando encabezado.0.tipo_reingreso es TIT."' +
			            ']' +
			        '},' +
			        '"errorType": "exception",' +
			        '"httpCode": 422,' +
			        '"message": "The given data was invalid.",' +
			        '"debug_message": [],' +
			        '"exception": "ValidationException",' +
			        '"line": 126' +
			    '}' +
			'}';
	}
}