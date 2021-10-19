public class WSOpportunityReingresoGFamMock  {

	public static String getFound(){
		return '{'+
    '"error": false,'+
    '"data": ['+
      '{'+
        '"sf_id": "12asd468wxe45",'+
        '"solafi_id": "724402",'+
        '"estado_sol": "COMPLETA",'+
        '"estado_dj": "NUEVA",'+
        '"codigo_as": "223483/17",'+
        '"tipo_asoc": "DSATIT",'+
        '"notas": ['+
          '{'+
            '"nota_id": "128878",'+
            '"texto_nota": "Nota de prueba"'+
          '}'+
        ']'+
      '},'+
      '{'+
        '"sf_id": "34sadt4crw4et5",'+
        '"solafi_id": "724402",'+
        '"estado_sol": "COMPLETA",'+
        '"estado_dj": "NUEVA",'+
        '"codigo_as": "223483/24",'+
        '"tipo_asoc": "DSAFAM"'+
      '}'+
    '],'+
    '"httpCode": 200,'+
    '"message": "Se generó satisfactoriamente la solicitud de reingreso grupo familiar",'+
    '"meta": {'+
      '"allowed_includes": [],'+
      '"default_includes": []'+
    '}'+
'  }';
	}

		public String getFoundWithFamId(String sf_id,String famId){
		return '{'+
    '"error": false,'+
    '"data": ['+
      '{'+
        '"sf_id": "'+sf_id+'",'+
        '"solafi_id": "724402",'+
        '"estado_sol": "COMPLETA",'+
        '"estado_dj": "NUEVA",'+
        '"codigo_as": "223483/17",'+
        '"tipo_asoc": "DSATIT",'+
        '"notas": ['+
          '{'+
            '"nota_id": "128878",'+
            '"texto_nota": "Nota de prueba"'+
          '}'+
        ']'+
      '},'+
      '{'+
        '"sf_id": "' + famId + '",'+
        '"solafi_id": "724402",'+
        '"estado_sol": "COMPLETA",'+
        '"estado_dj": "NUEVA",'+
        '"codigo_as": "223483/24",'+
        '"tipo_asoc": "DSAFAM"'+
      '}'+
    '],'+
    '"httpCode": 200,'+
    '"message": "Se generó satisfactoriamente la solicitud de reingreso grupo familiar",'+
    '"meta": {'+
      '"allowed_includes": [],'+
      '"default_includes": []'+
    '}'+
'  }';
	}

	public static String getError(){
		return '{'+
    '"data": {'+
        '"error": true,'+
        '"errors": {'+
            '"message": "No se pudo cargar la solicitud de reingreso grupo familiar. Existe Una solicitud con los mismos datos, no es posible cargar una nueva, modifique la existente.",'+
            '"debug_message": ""'+
        '},'+
        '"data": {'+
            '"solafi_id": null,'+
            '"estado_sol": null'+
        '},'+
        '"httpCode": 400,'+
        '"message": "No se pudo cargar la solicitud de reingreso grupo familiar. Existe Una solicitud con los mismos datos, no es posible cargar una nueva, modifique la existente."'+
    '}'+
'}';
	}
}