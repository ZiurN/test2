public class WSLoteReabrirMock  {

	public static String getFound(){
		return '{'+
				  '"error": false,'+
				  '"data": {'+
					'"lote": {'+
					  '"lr_id": 5397,'+
					  '"estado": "A",'+
					  '"prei_id": "38855",'+
					  '"procesos": ['+
						'{'+
						  '"prei_id": "38855",'+
						  '"inicio": "2020-04-13 14:43:45",'+
						  '"fin": "2020-04-13 14:43:45",'+
						  '"lr_lr_id": "5397",'+
						  '"vda_drv_tipo_proceso": "RETPREAP",'+
						  '"nombre_proc": "REAPERTURA",'+
						  '"logs": []'+
						'}'+
					  ']'+
					'}'+
				  '},'+
				  '"httpCode": 201,'+
				  '"message": "Se reabrió correctamente el lote.",'+
				  '"meta": {'+
					'"allowed_includes": [],'+
					'"default_includes": []'+
				  '}'+
				'}';
	}


	public static String getError(){
		return '{'+
				  '"data": {'+
					  '"error": true,'+
					  '"errors": {'+
						  '"message": "ERROR AL ABRIR LOTE. ERR Reabriendo el lote:. no esta en estado CERRADO",'+
						  '"debug_message": {'+
							  '"ERROR AL ABRIR LOTE ORA-20999": "[REI1Z212PRC] ERR Reabriendo el lote: ORA-20002: El lote 5397 no esta en estado CERRADO"'+
						  '}'+
					  '},'+
					  '"data": null,'+
					  '"httpCode": 400,'+
					  '"message": "No se pudo reabrir el lote."'+
				  '}'+
				'}';

	}

}