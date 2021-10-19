@isTest
public class WSAsociadoEstadoCredencialesMock  {

	public static String getFound() {
		return
			'{' +
				'"data": [' +
					'{' +
						'"codigo": "88501/19",' +
						'"apellido_nombre": "TORRES GUSTAVO FABIAN",' +
						'"secuencia": "5",' +
						'"fecha_emision": "2014-09-01",' +
						'"fecha_vigencia": "2014-09-01",' +
						'"fecha_baja": "2019-04-09",' +
						'"fecha_anulacion": "2019-04-09",' +
						'"id_oca": "167607213",' +
						'"estado": "Entregado Ag"' +
					'},' +
					'{' +
						'"codigo": "88501/19",' +
						'"apellido_nombre": "TORRES GUSTAVO FABIAN",' +
						'"secuencia": "4",' +
						'"fecha_emision": "2011-08-19",' +
						'"fecha_vigencia": "2011-08-01",' +
						'"fecha_baja": "2014-08-31",' +
						'"fecha_anulacion": "2019-04-09",' +
						'"id_oca": null,' +
						'"estado": "Sin Seguimiento"' +
					'},' +
					'{' +
						'"codigo": "88501/19",' +
						'"apellido_nombre": "TORRES GUSTAVO FABIAN",' +
						'"secuencia": "3",' +
						'"fecha_emision": "2010-11-24",' +
						'"fecha_vigencia": "2011-01-01",' +
						'"fecha_baja": "2011-07-31",' +
						'"fecha_anulacion": "2019-04-09",' +
						'"id_oca": null,' +
						'"estado": "Sin Seguimiento"' +
					'}' +
				'],' +
				'"meta": {' +
					'"available_includes": [],' +
					'"default_includes": [],' +
					'"optional_get_vars": {' +
						'"sortBy": [],' +
						'"sortOrder": [' +
							'"asc",' +
							'"desc"' +
						'],' +
						'"pageSize": 0' +
					'}' +
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
					'"message": "Código de Afiliado inválido.",' +
					'"exception": "NotFoundHttpException"' +
				'}' +
			'}';
	}
}