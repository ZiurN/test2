public class WSEfectorConveniosMock  {

	public static String getFound(){
		return '{'+
					'"data": ['+
						'{'+
							'"efe_codigo": "700047",'+
							'"fecha": "2019-01-01",'+
							'"nombre_arch": "700047_M_20190101.pdf",'+
							'"modulo": null,'+
							'"arancel": null,'+
							'"anexo": null,'+
							'"descripcion": "VALORES ENERO 2019",'+
							'"p_link": "http://www.extranet.acasalud.com.ar/SF/700047_M_20190101.pdf"'+
						'},'+
						'{'+
							'"efe_codigo": "700047",'+
							'"fecha": "2018-10-01",'+
							'"nombre_arch": "700047_M_20181001.pdf",'+
							'"modulo": null,'+
							'"arancel": null,'+
							'"anexo": null,'+
							'"descripcion": "VALORES OCTUBRE 2018",'+
							'"p_link": "http://www.extranet.acasalud.com.ar/SF/700047_M_20181001.pdf"'+
						'},'+
						'{'+
							'"efe_codigo": "700047",'+
							'"fecha": "2018-07-01",'+
							'"nombre_arch": "700047_M_20180701.pdf",'+
							'"modulo": null,'+
							'"arancel": null,'+
							'"anexo": null,'+
							'"descripcion": "VALORES JULIO 2018",'+
							'"p_link": "http://www.extranet.acasalud.com.ar/SF/700047_M_20180701.pdf"'+
						'},'+
						'{'+
							'"efe_codigo": "700047",'+
							'"fecha": "2018-02-01",'+
							'"nombre_arch": "700047_M_20180201.pdf",'+
							'"modulo": null,'+
							'"arancel": null,'+
							'"anexo": null,'+
							'"descripcion": "VALORES FEBRERO 2018",'+
							'"p_link": "http://www.extranet.acasalud.com.ar/SF/700047_M_20180201.pdf"'+
						'}'+
					'],'+
					'"meta": {'+
						'"allowed_filters": [],'+
						'"allowed_sorts": [],'+
						'"allowed_appends": [],'+
						'"allowed_fields": [],'+
						'"allowed_includes": [],'+
						'"default_includes": [],'+
						'"optional_get_vars": {'+
							'"sortBy": [],'+
							'"sortOrder": ['+
								'"asc",'+
								'"desc"'+
							'],'+
							'"pageSize": {'+
								'"0": "?pageSize=0",'+
								'"15": "?pageSize=15",'+
								'"50": "?pageSize=50",'+
								'"100": "?pageSize=100"'+
							'}'+
						'}'+
					'}'+
				'}';

	}

	public static String getFound2(){
		return '{'+
				'"data": ['+
				'{'+
				'"efe_codigo": "700050",'+
				'"fecha": "2019-01-01",'+
				'"nombre_arch": "700050_M_20190101.pdf",'+
				'"modulo": null,'+
				'"arancel": null,'+
				'"anexo": null,'+
				'"descripcion": "VALORES ENERO 2019",'+
				'"p_link": "http://www.extranet.acasalud.com.ar/SF/700050_M_20190101.pdf"'+
				'}'+

				'],'+
				'"meta": {'+
				'"allowed_filters": [],'+
				'"allowed_sorts": [],'+
				'"allowed_appends": [],'+
				'"allowed_fields": [],'+
				'"allowed_includes": [],'+
				'"default_includes": [],'+
				'"optional_get_vars": {'+
				'"sortBy": [],'+
				'"sortOrder": ['+
				'"asc",'+
				'"desc"'+
				'],'+
				'"pageSize": {'+
				'"0": "?pageSize=0",'+
				'"15": "?pageSize=15",'+
				'"50": "?pageSize=50",'+
				'"100": "?pageSize=100"'+
				'}'+
				'}'+
				'}'+
				'}';

	}

	public static String getEmpty(){
		return '{'+
				'"data": [],'+
				'"meta": {'+
					'"allowed_filters": [],'+
					'"allowed_sorts": [],'+
					'"allowed_appends": [],'+
					'"allowed_fields": [],'+
					'"allowed_includes": [],'+
					'"default_includes": [],'+
					'"optional_get_vars": {'+
						'"sortBy": [],'+
						'"sortOrder": ['+
							'"asc",'+
							'"desc"'+
						'],'+
						'"pageSize": {'+
							'"0": "?pageSize=0",'+
							'"15": "?pageSize=15",'+
							'"50": "?pageSize=50",'+
							'"100": "?pageSize=100"'+
						'}'+
					'}'+
				'}'+
			'}';
	}

	public static String getError(){
		return '{'+
					'"data": {'+
						'"error": true,'+
						'"errors": [],'+
						'"errorType": "exception",'+
						'"httpCode": 404,'+
						'"message": "La ruta que está buscando no existe.",'+
						'"debug_message": [],'+
						'"exception": "NotFoundHttpException",'+
						'"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Routing\\RouteCollection.php",'+
						'"line": 179'+
					'}'+
				'}';
	}

}