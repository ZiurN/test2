public  class AfiliadoEndpointsMockResponses {
    public static String getDatosSFResponseOk () {
		return '{' +
			'"error": false,'+
			'"data": {'+
				'"domiafi_id": null,'+
				'"telafi_id": null'+
			'},'+
			'"httpCode": 200,'+
			'"message": "Se ejecutó el proceso.",'+
			'"meta": {'+
				'"allowed_includes": [],'+
				'"default_includes": []'+
			'}'+
		'}';
	}
	public static String getDatosSFResponseError () {
		return '{'+
			'"data": {'+
				'"error": true,'+
				'"errors": {'+
					'"message": "",'+
					'"debug_message": {'+
						'"Error Code": "6550",'+
						'"Error Message": "ORA-06550: line 2, column 33:",'+
						'"PLS-00201": "identifier \'C_SF_CUENTAS.TELEFONO\' must be declared",'+
						'"ORA-06550": "line 4, column 19:",'+
						'"PL/SQL": "Statement ignored",'+
						'"PLS-00320": "the declaration of the type of this expression is incomplete or malformed",'+
						'"Position": "41",'+
						'"Statement": "DECLARE                 P_ROW_DOM       C_SF_CUENTAS.DOMICILIO;                P_ROW_TEL       C_SF_CUENTAS.TELEFONO;            BEGIN SALUD.C_SF_CUENTAS.MODIF_DAT_PARTICULARES(            :P_AFI_ID,            :P_TIPO_DOC,            :P_NUM_DOC,            :P_NUM_CUIT,            :P_EMAIL,            P_ROW_DOM,            P_ROW_TEL,            :P_RESPUESTA,            :P_ERROR,            :DOMIAFI_ID,            :TELAFI_ID        );        END;",'+
						'"Bindings": "[140510,,,,pruebaactualizacion@email.com,,,0,0]"'+
					'}'+
				'},'+
				'"data": null,'+
				'"httpCode": 400,'+
				'"message": "No se pudieron replicar los datos."'+
			'}'+
		'}';
	}
}