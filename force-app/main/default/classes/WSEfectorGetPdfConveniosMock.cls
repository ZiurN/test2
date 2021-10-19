@isTest
public class WSEfectorGetPdfConveniosMock  {
	public static String getFound() {
		return
            '{' +
                '"error": false,' +
                '"data": [' +
                    '{' +
                        '"efe_codigo": "700125",' +
                        '"fecha": "2019-01-01 00:00:00",' +
                        '"nombre_arch": "GRUGAMMA_M_20190101.pdf",' +
                        '"modulo": null,' +
                        '"arancel": null,' +
                        '"anexo": null,' +
                        '"descripcion": "VALORES ENERO 2019",' +
                        '"base64": "JVBERi0xLjUNCiW1tbW1"' +
                    '},' +
                    '{' +
                        '"efe_codigo": "700125",' +
                        '"fecha": "2018-10-01 00:00:00",' +
                        '"nombre_arch": "GGAMMA_20181001.pdf",' +
                        '"modulo": null,' +
                        '"arancel": null,' +
                        '"anexo": null,' +
                        '"descripcion": "VALORES OCTUBRE Y NOVIEMBRE 2018",' +
                        '"base64": "JVBERi0xLjUNCiW1tbW1"' +
                    '},' +
                    '{' +
                        '"efe_codigo": "700125",' +
                        '"fecha": "2018-08-01 00:00:00",' +
                        '"nombre_arch": "GGAMMA_20180801.pdf",' +
                        '"modulo": null,' +
                        '"arancel": null,' +
                        '"anexo": null,' +
                        '"descripcion": "VALORES AGOSTO 2018",' +
                        '"base64": "JVBERi0xLjcNCiW1tbW1DQoxIDAgb"' +
                    '}' +
                '],' +
                '"httpCode": 201,' +
                '"message": "Se obtuvieron los convenios.",' +
                '"meta": {' +
                    '"allowed_includes": [],' +
                    '"default_includes": []' +
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
                    '"message": "El prestador solicitado es inválido.",' +
                    '"debug_message": [],' +
                    '"exception": "NotFoundHttpException",' +
                    '"line": 964' +
                '}' +
            '}';
	}
}