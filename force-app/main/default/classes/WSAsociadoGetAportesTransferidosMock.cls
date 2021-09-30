public class WSAsociadoGetAportesTransferidosMock  {
	public static String getFound(){
		return
			'{' +
				'"data": [' +
					'{' +
						'"dnat_id": "602",' +
						'"periodo": "2002-12-01",' +
						'"cuit": "33533717999",' +
						'"empleador": "600055",' +
						'"nombre_empleador": "COOP. AGROP. DE ARMSTRONG LTDA.",' +
						'"obra_social": "101604",' +
						'"cod_ooss": "640008",' +
						'"nombre_ooss": "O.S.P.ACA",' +
						'"cuil": "20162477782",' +
						'"origen_aporte": "MAN",' +
						'"aporte": "504.33",' +
						'"aporte_reconocido": "0",' +
						'"aporte_derivado": "0",' +
						'"subsidio": "0",' +
						'"secuencia": "0",' +
						'"constribucion": "0",' +
						'"adherentes": "0",' +
						'"remuneracion": "0",' +
						'"familiares": "0",' +
						'"ooss_cargada": "101604",' +
						'"at_id": 1903,' +
						'"secuencia_at": "1903",' +
						'"origen_aporte_at": "N/A",' +
						'"secuencia_nominal": "0",' +
						'"origen_aporte_nomi": "MAN",' +
						'"total_aportes": "0",' +
						'"total_aportes_reconocidos": null,' +
						'"total_familiares": "0",' +
						'"total_remuneraciones": "0",' +
						'"total_aportes_derivados": null,' +
						'"total_constribucion": "0",' +
						'"total_adherentes": "0",' +
						'"total_aportes_nomi": "1738.64",' +
						'"total_aportes_reconocidos_nomi": "0",' +
						'"total_familiares_nomi": "0",' +
						'"total_remuneracines_nomi": "0",' +
						'"total_aportes_derivados_nomi": "0",' +
						'"total_contribucion_nom": "0",' +
						'"total_adherentes_nomi": "0"' +
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