@isTest
public class WSAsociadoFacturaElectronicaMock  {
	public static String getFound() {
		return
			'{' +
				'"error": false,' +
				'"data": null,' +
				'"httpCode": 201,' +
				'"message": "Se actualizó la información de FE del socio.",' +
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
						'"message": "No se pudo actualizar la información de FE del socio. DATO INGRESADO IGUAL AL ACTUAL.",' +
						'"debug_message": ""' +
					'},' +
					'"data": null,' +
					'"httpCode": 400,' +
					'"message": "No se pudo actualizar la información de FE del socio. DATO INGRESADO IGUAL AL ACTUAL."' +
				'}' +
			'}';
	}
}