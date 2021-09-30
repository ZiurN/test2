public class WSPrestadorGetPresupuestosMock  {
	public static String getFound(){
		return
            '{' +
                '"data": [' +
                    '{' +
                        '"efe_codigo": "700076",' +
                        '"fecha": "2019-01-31",' +
                        '"nombre_arch": "700076_p_20190131.pdf",' +
                        '"descripcion": "Presup. Discectomia y Artrodesis Instrumentada af 39573-10",' +
                        '"p_link": "https://acaiasnew.acasalud.com.ar/dd_convenios/700076_p_20190131.pdf"' +
                    '},' +
                    '{' +
                        '"efe_codigo": "700076",' +
                        '"fecha": "2018-12-19",' +
                        '"nombre_arch": "700076_p_20181219.pdf",' +
                        '"descripcion": "Presup. Honorarios Resección de tumor vaginal af 91550-15",' +
                        '"p_link": "https://acaiasnew.acasalud.com.ar/dd_convenios/700076_p_20181219.pdf"' +
                    '},' +
                    '{' +
                        '"efe_codigo": "700076",' +
                        '"fecha": "2018-12-07",' +
                        '"nombre_arch": "700076_P_20181207.pdf",' +
                        '"descripcion": "Presup. sesion de la funcios deglutoria x5 Af. 207817-23",' +
                        '"p_link": "https://acaiasnew.acasalud.com.ar/dd_convenios/700076_P_20181207.pdf"' +
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