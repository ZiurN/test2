public class WSAsociadoGetValoracionesMock  {
	
	public static String getFound(){
		return
			'{' +
				'"message": null,' +
				'"data": [' +
					'{' +
						'"Tcc_Codigo": "BAS",' +
						'"Importe": "2460.33",' +
						'"Cantidad": "1",' +
						'"Coeficiente": "1",' +
						'"Coeficiente_General": "1",' +
						'"Cga_Codigo": "",' +
						'"Rcg_Codigo": "PERSONA",' +
						'"Dca_Dca_Id": "",' +
						'"Dca_Dca_Id_Ajuste": "",' +
						'"Nombre_Clausula": "Cuota Basica",' +
						'"Nombre_Cat_Grupal": "",' +
						'"Nombre_Regla_Adic": "Persona"' +
					'},' +
					'{' +
						'"Tcc_Codigo": "BAS",' +
						'"Importe": "2460.33",' +
						'"Cantidad": "1",' +
						'"Coeficiente": "1",' +
						'"Coeficiente_General": "1",' +
						'"Cga_Codigo": "",' +
						'"Rcg_Codigo": "PERSONA",' +
						'"Dca_Dca_Id": "",' +
						'"Dca_Dca_Id_Ajuste": "",' +
						'"Nombre_Clausula": "Cuota Basica",' +
						'"Nombre_Cat_Grupal": "",' +
						'"Nombre_Regla_Adic": "Persona"' +
					'},' +
					'{' +
						'"Tcc_Codigo": "BAS",' +
						'"Importe": "2460.33",' +
						'"Cantidad": "1",' +
						'"Coeficiente": "1",' +
						'"Coeficiente_General": "1",' +
						'"Cga_Codigo": "",' +
						'"Rcg_Codigo": "PERSONA",' +
						'"Dca_Dca_Id": "",' +
						'"Dca_Dca_Id_Ajuste": "",' +
						'"Nombre_Clausula": "Cuota Basica",' +
						'"Nombre_Cat_Grupal": "",' +
						'"Nombre_Regla_Adic": "Persona"' +
					'},' +
					'{' +
						'"Tcc_Codigo": "BAS",' +
						'"Importe": "2460.33",' +
						'"Cantidad": "1",' +
						'"Coeficiente": "1",' +
						'"Coeficiente_General": "1",' +
						'"Cga_Codigo": "",' +
						'"Rcg_Codigo": "PERSONA",' +
						'"Dca_Dca_Id": "",' +
						'"Dca_Dca_Id_Ajuste": "",' +
						'"Nombre_Clausula": "Cuota Basica",' +
						'"Nombre_Cat_Grupal": "",' +
						'"Nombre_Regla_Adic": "Persona"' +
					'}' +
				']' +
			'}';
	}

	public static String getError(){
		return
			'{' +
				'"data": {' +
					'"error": true,' +
					'"errors": [],' +
					'"errorType": "exception",' +
					'"httpCode": 404,' +
					'"message": "El ID del Afiliado es inválido.",' +
					'"debug_message": [],' +
					'"exception": "NotFoundHttpException",' +
					'"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php",' +
					'"line": 964' +
				'}' +
			'}';
	}
}