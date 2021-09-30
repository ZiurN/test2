public class WSCaseReintegroRevertirMock  {

	public static String getFound() {
		return 
			'{' +
			  '"error": false,' +
			  '"data": {' +
				'"reintegro": [' +
				  '{' +
					'"lote": "5392",' +
					'"lote_original": null,' +
					'"rei_id": "553276",' +
					'"orei_orei_id": null,' +
					'"fecha": "2020-02-20 00:00:00",' +
					'"del_os_codigo": "650098",' +
					'"afi_afi_id": "140978",' +
					'"codigo": "69794/14",' +
					'"asociado_nombre": "RIOS ANA CAROLINA",' +
					'"em_em_id": null,' +
					'"efe_codigo_realizador": "758415",' +
					'"efe_codigo_prescriptor": "758415",' +
					'"fecha_prescripcion": "2020-02-01 00:00:00",' +
					'"diag_codigo": "999",' +
					'"cobro_indeb": "N",' +
					'"razon_social": "PRUEBA REINT",' +
					'"cuit": "27169355865",' +
					'"tipo_comprobante": "RXC",' +
					'"nro_comprobante": "0001-005953",' +
					'"fecha_comprobante": "2020-02-10 00:00:00",' +
					'"importe": "1000",' +
					'"vda_drv_estado": "CR-----G",' +
					'"nombre_estado": "GENERADO",' +
					'"nro_sf": "dasdsa0003"' +
				  '}' +
				']' +
			  '},' +
			  '"httpCode": 200,' +
			  '"message": "Se ha revertido correctamente el reintegro.",' +
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
						'"usuario": [' +
							'"usuario es inválido."' +
						']' +
					'},' +
					'"errorType": "exception",' +
					'"httpCode": 422,' +
					'"message": "The given data was invalid.",' +
					'"debug_message": [],' +
					'"exception": "ValidationException",' +
					'"line": 126' +
				'}' +
			'}';
	}
}