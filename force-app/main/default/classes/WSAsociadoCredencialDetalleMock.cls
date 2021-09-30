@isTest 
public class WSAsociadoCredencialDetalleMock {

	public static String getFound() {
		return
			'{' +
				'"error": false,' +
				'"data": [' +
					'{' +
						'"fecha": "02/05/2018 15:40",' +
						'"descripcion": "Entregada",' +
						'"estado": "Enviada a Digitalizadora",'+
						'"motivo": "Entregada",'+
						'"nombre": "650792_AG. CNEL. DOMINGUEZ-MARICEL VIVIANA POLLACCHI",' +
						'"rendicion": "6143735"' +
					'},' +
					'{' +
						'"fecha": "02/05/2018 15:31",' +
						'"descripcion": "Sin motivo",' +
						'"estado": "Enviada a Digitalizadora",'+
						'"motivo": "Entregada",'+
						'"nombre": "650792_AG. CNEL. DOMINGUEZ-MARICEL VIVIANA POLLACCHI",' +
						'"rendicion": "6143735"' +
					'},' +
					'{' +
						'"fecha": "02/05/2018 15:31",' +
						'"descripcion": "Entregada",' +
						'"estado": "Enviada a Digitalizadora",'+
						'"motivo": "Entregada",'+
						'"nombre": "650792_AG. CNEL. DOMINGUEZ-MARICEL VIVIANA POLLACCHI",' +
						'"rendicion": "6143735"' +
					'}' +
				'],' +
				'"httpCode": 201,' +
				'"message": "Se obtuvo el detalle de seguimientos.",' +
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
					'"message": "El id de credencial esinválido.",' +
					'"debug_message": [],' +
					'"exception": "NotFoundHttpException",' +
					'"line": 964' +
				'}' +
			'}';
	}
}