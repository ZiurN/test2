public class WSAsociadoGetCuentaCorrienteMock  {

	public static String getFound(){
		return
            '{' +
                '"data": {' +
                    '"cuenta_corriente": {' +
                        '"afiliado": {' +
                            '"cod_afi": "200686",' +
                            '"nom_afi": "tBUSCEMA PAOLA ROSANA                   ",' +
                            '"medio_pago ": "Cupón bancario"' +
                        '},' +
                        '"detallesAfi": [' +
                            '{' +
                                '"movimiento": "51",' +
                                '"comprobante": "10/05/2019",' +
                                '"vencimiento": "10/06/2019",' +
                                '"tipo": "FA",' +
                                '"letra": "B",' +
                                '"sucursal": "0022",' +
                                '"numero": "01566119",' +
                                '"cuota": "1",' +
                                '"aprobado": " ",' +
                                '"id": "23162069",' +
                                '"importe": "130.86",' +
                                '"saldo": "130.86"' +
                            '}' +
                        '],' +
                        '"empresa": [' +
                            '{' +
                                '"cod_emp": "610728",' +
                                '"descripcion": "GENIAL S.A."' +
                            '}' +
                        '],' +
                        '"detallesEmp": [' +
                            '{' +
                                '"movimiento": "52",' +
                                '"comprobante": "28/06/2019",' +
                                '"vencimiento": "12/08/2019",' +
                                '"tipo": "FA",' +
                                '"letra": "A",' +
                                '"sucursal": "0019",' +
                                '"numero": "00065476",' +
                                '"cuota": "1",' +
                                '"aprobado": " ",' +
                                '"id": "23473519",' +
                                '"importe": "13808.28",' +
                                '"saldo": "13808.28"' +
                            '},' +
                            '{' +
                                '"movimiento": "52",' +
                                '"comprobante": "28/06/2019",' +
                                '"vencimiento": "10/07/2019",' +
                                '"tipo": "NC",' +
                                '"letra": "A",' +
                                '"sucursal": "0019",' +
                                '"numero": "00065389",' +
                                '"cuota": "1",' +
                                '"aprobado": " ",' +
                                '"id": "23478558",' +
                                '"importe": "-5676.66",' +
                                '"saldo": "8131.62"' +
                            '}' +
                        ']' +
                    '}' +
                '},' +
                '"meta": {' +
                    '"allowed_includes": [],' +
                    '"default_includes": []' +
                '}' +
            '}';
	}

	public static String getEmpty() {
		return
			'{' + 
				'"data":{' +
					'"cuenta_corriente":{' +
						'"afiliado":{' +
							'"cod_afi":null,' +
							'"nom_afi":null,' + 
							'"medio_pago ":null' +
						'},' +
						'"detallesAfi":[' +
						'],' +
						'"empresa":[' +
						'],' +
						'"detallesEmp":[' +
						']' +
					'}' +
				'},' +
				'"meta":{' +
					'"allowed_includes":[' +
					'],' +
					'"default_includes":[' +
					']' +
				'}' +
			'}';
	}

	public static String getError() {
		return
			'{' +
				'"data": {' +
					'"error": true,' +
					'"errors": [],' +
					'"errorType": "exception",' +
					'"httpCode": 404,' +
					'"message": "La ruta que está buscando no existe.",' +
					'"debug_message": [],' +
					'"exception": "NotFoundHttpException",' +
					'"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Routing\\RouteCollection.php",' +
					'"line": 179' +
				'}' +
			'}';
	}
}