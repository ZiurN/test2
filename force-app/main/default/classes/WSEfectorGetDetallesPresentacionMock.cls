public class WSEfectorGetDetallesPresentacionMock  {
	public static String getFound() {
		return
			'{' +
                '"data": [' +
                    '{' +
                        '"pp_pp_id": "218020757",' +
                        '"cabcp_id": "772573",' +
                        '"tipo": "FACA",' +
                        '"comprobante": "A-0018-00000301",' +
                        '"fecha_emision": "2018-02-19",' +
                        '"fecha_vencimiento": null,' +
                        '"total": "333009.69",' +
                        '"proceso_contable": "IF",' +
                        '"liquidacion": "IF",' +
                        '"fecha_liquidacion": "2018-03-23",' +
                        '"nota_ajuste": "IF",' +
                        '"fecha_nota_ajuste": "2018-03-23"' +
                    '},' +
                    '{' +
                        '"pp_pp_id": "218020757",' +
                        '"cabcp_id": "772574",' +
                        '"tipo": "FACA",' +
                        '"comprobante": "A-0018-00000303",' +
                        '"fecha_emision": "2018-02-19",' +
                        '"fecha_vencimiento": null,' +
                        '"total": "218151.99",' +
                        '"proceso_contable": "IF",' +
                        '"liquidacion": "IF",' +
                        '"fecha_liquidacion": "2018-03-23",' +
                        '"nota_ajuste": "IF",' +
                        '"fecha_nota_ajuste": "2018-03-23"' +
                    '}' +
                '],' +
                '"meta": {' +
                    '"allowed_filters": [],' +
                    '"allowed_sorts": [],' +
                    '"allowed_appends": [],' +
                    '"allowed_fields": [],' +
                    '"allowed_includes": [],' +
                    '"default_includes": [],' +
                    '"optional_get_vars": {' +
                        '"sortBy": [],' +
                        '"sortOrder": [' +
                            '"asc",' +
                            '"desc"' +
                        '],' +
                        '"pageSize": {' +
                            '"0": "?pageSize=0",' +
                            '"15": "?pageSize=15",' +
                            '"50": "?pageSize=50",' +
                            '"100": "?pageSize=100"' +
                        '}' +
                    '}' +
                '}' +
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
					'"message": "Código de Afiliado inválido.",' +
					'"debug_message": [],' +
					'"exception": "NotFoundHttpException",' +
					'"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php",' +
					'"line": 964' +
				'}' +
			'}';
	}
}