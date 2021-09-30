public class WSCaseTestReintegroMock  {

	public static String getFoundMed() {
		return
			'{' +
				'"error": false,' +
				'"data": {' +
					'"medicamento": "48896",' +
					'"precio_vta": "66441.35",' +
					'"precio_vta_20": "53153.08",' +
					'"porc_cob": "40",' +
					'"total": "21261.23"' +
				'},' +
				'"httpCode": 200,' +
				'"message": "El test de reintegro fue realizado satisfactoriamente.",' +
				'"meta": {' +
					'"allowed_includes": [],' +
					'"default_includes": []' +
				'}' +
			'}';
	}

	public static String getFoundPres() {
		return
			'{' +
			  '"error": false,' +
			  '"data": {' +
				'"prestacion": "02146003",' +
				'"honorario": "257",' +
				'"gastos": "257",' +
				'"copago": "100.66",' +
				'"total": "413.34"' +
			  '},' +
			  '"httpCode": 200,' +
			  '"message": "El test de reintegro fue realizado satisfactoriamente.",' +
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
					'"errors": {' +
						'"test": [' +
							'"Debe cargar un medicamente o una prestación."' +
						']' +
					'},' +
					'"errorType": "exception",' +
					'"httpCode": 422,' +
					'"message": "The given data was invalid.",' +
					'"debug_message": [],' +
					'"exception": "ValidationException",' +
					'"line": 71' +
				'}' +
			'}';
	}
}