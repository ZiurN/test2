@IsTest
private class UtilsDisplayErrorMessageFromWSTest {
    static Map<String, Object> body;
    static Map<String, Object> bodyWithErrorsList;
    static Map<String, Object> bodyWithErrorsEmpty;
    static Map<String, Object> bodyWithErrorMessageInErrorsMap;
	static Map<String, Object> bodyWithErrorsMapAndOtherMapInAField;

    static {
        body = (Map<String, Object>) JSON.deserializeUntyped('{' +
                        '"data": {' +
                        '"error": true,' +
                        '"errors": {' +
                        '"codigo_afiliado": [' +
                        '"codigo afiliado es invalido."' +
                        ']' +
                        '},' +
                        '"errorType": "exception",' +
                        '"httpCode": 422,' +
                        '"message": "The given data was invalid.",' +
                        '"debug_message": [],' +
                        '"exception": "ValidationException",' +
                        '"line": 126' +
                        '}' +
                        '}'
                );

        bodyWithErrorsList = (Map<String, Object>) JSON.deserializeUntyped('{' +
                        '"data": {' +
                        '"error": true,' +
                        '"errors": [' +
                        '"Errors is a list"' +
                        '],' +
                        '"errorType": "exception",' +
                        '"httpCode": 404,' +
                        '"message": "El segmento solicitado es inválido.",' +
                        '"debug_message": [],' +
                        '"exception": "NotFoundHttpException",' +
                        '"line": 964' +
                        '}' +
                        '}');

        bodyWithErrorsEmpty = (Map<String, Object>) JSON.deserializeUntyped('{' +
                        '"data": {' +
                        '"error": true,' +
                        '"errors": [],' +
                        '"errorType": "exception",' +
                        '"httpCode": 404,' +
                        '"message": "Mensaje del data",' +
                        '"debug_message": [],' +
                        '"exception": "NotFoundHttpException",' +
                        '"line": 964' +
                        '}' +
                        '}');

        bodyWithErrorMessageInErrorsMap = (Map<String, Object>) JSON.deserializeUntyped(
                '{' +
                        '"data": {' +
                        '"error": true,' +
                        '"errors": {' +
                        '"message": "Mensaje del ErrorsMap",' +
                        '"debug_message": {' +
                        '"NO SE PUEDE ANULAR EVENTO ORA-20002": [' +
                        ']' +
                        '}' +
                        '},' +
                        '"data": null,' +
                        '"httpCode": 400,' +
                        '"message": "No se pudo anular el evento médico. Por favor, intente nuevamente."' +
                        '}' +
                        '}'
        );

		bodyWithErrorsMapAndOtherMapInAField = (Map<String, Object>) JSON.deserializeUntyped(
			'{' +
				'"data": {' +
					'"error": true,' +
					'"errors": {' +
						'"message": "",' +
						'"debug_message": {' +
							'"Error Code": "6550",' +
							'"Error Message": [' +
								'"ORA-06550: line 12, column 69:",' +
								'"PLS-00306: wrong number or types of arguments in call to ALTA_COBER",' +
								'"ORA-06550: line 12, column 69:",' +
								'"PL/SQL: Statement ignored"' +
							'],' +
							'"Position": "814",' +
							'"Statement": "DECLARE                            V_TABLE_MED C_SF_COBER_ESPECIALES.TABLE_MED;                      BEGIN V_TABLE_MED(1).EM_EM_ID := :P_TABLE_MED_1_EM_EM_ID;             V_TABLE_MED(1).FECHA_DESDE := :P_TABLE_MED_1_FECHA_DESDE;              V_TABLE_MED(1).EFE_CODIGO := :P_TABLE_MED_1_EFE_CODIGO;              V_TABLE_MED(1).NOM_PRESTACION := :P_TABLE_MED_1_NOM_PRESTACION;              V_TABLE_MED(1).TIPO_COPAGO := :P_TABLE_MED_1_TIPO_COPAGO;              V_TABLE_MED(1).INCLUYE_EXCLUYE := :P_TABLE_MED_1_INCLUYE_EXCLUYE;              V_TABLE_MED(1).PRIORIDAD := :P_TABLE_MED_1_PRIORIDAD;              V_TABLE_MED(1).VALOR := :P_TABLE_MED_1_VALOR;              V_TABLE_MED(1).TOPE_MENSUAL := :P_TABLE_MED_1_TOPE_MENSUAL;              V_TABLE_MED(1).TOPE_ANUAL := :P_TABLE_MED_1_TOPE_ANUAL;C_SF_COBER_ESPECIALES.ALTA_COBER(                            :P_USER,                             V_TABLE_MED,                            :P_ERROR,                            :P_RESULTADO);                      END;",' +
							'"Bindings": "[CRIOS,276349,2020-05-19,,,Impuesto Fijo,Incluye,,10,,,,]"' +
						'}' +
					'},' +
					'"data": null,' +
					'"httpCode": 400,' +
					'"message": "No se pudo cargar la cobertura especial."' +
				'}' +
			'}'
		);
    }

    @IsTest
    static void showTheErrorsFromMap() {
        Test.startTest();
        String msg = UtilsDisplayErrorMessageFromWS.showErrorMessage(body);
        Test.stopTest();

        System.assertEquals('codigo afiliado es invalido.\n', msg);
    }

    @IsTest
    static void showTheErrorsFromList() {
        Test.startTest();
        String msg = UtilsDisplayErrorMessageFromWS.showErrorMessage(bodyWithErrorsList);
        Test.stopTest();

        System.assertEquals('Errors is a list\n', msg);
    }

    @IsTest
    static void showTheErrorFromData() {
        Test.startTest();
        String msg = UtilsDisplayErrorMessageFromWS.showErrorMessage(bodyWithErrorsEmpty);
        Test.stopTest();

        System.assertEquals('Mensaje del data', msg);
    }

    @IsTest
	static void showTheErrorFromMessageInErrorsMap() {
        Test.startTest();
        String msg = UtilsDisplayErrorMessageFromWS.showErrorMessage(bodyWithErrorMessageInErrorsMap);
        Test.stopTest();

        System.assertEquals('Mensaje del ErrorsMap', msg);
    }

	@IsTest
	static void test() {

		Test.startTest();
        String msg = UtilsDisplayErrorMessageFromWS.showErrorMessage(bodyWithErrorsMapAndOtherMapInAField);
        Test.stopTest();

		System.assertEquals('No se pudo cargar la cobertura especial.', msg);
	}
}