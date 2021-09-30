public class WSLoteGeneracionDeOrdenMock  {

	public static String getFound(){
		return '{'+
				'"error": false,'+
				'"data": {'+
					'"lote": {'+
					'"lr_id": 5402,'+
					'"estado": "A",'+
					'"prei_id": "38833",'+
					'"procesos": ['+
						'{'+
						'"prei_id": "38833",'+
						'"inicio": "2020-04-13 12:55:03",'+
						'"hubo_errores": "V",'+
						'"fin": "2020-04-13 12:55:03",'+
						'"lr_lr_id": "5402",'+
						'"vda_drv_tipo_proceso": "RETPGEOR",'+
						'"nombre_proc": "GEN. ORDEN REI"'+
						'}'+
					'],'+
					'"logs": ['+
						'{'+
						'"lpr_id": "242448",'+
						'"texto": "CA_REI_0006:El reintegro 553279 tiene prestaciones o conceptos sin pasar por el centro autoirizador o pendientes de auditoría",'+
						'"prei_prei_id": "38833",'+
						'"rei_rei_id": "553279"'+
						'}'+
					']'+
					'}'+
				'},'+
				'"httpCode": 201,'+
				'"message": "Se generó la orden correctamente.",'+
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
						  '"message": "No se pudo generar la orden. No se pueden visualizar los datos en este momento",'+
						  '"debug_message": ""'+
					  '},'+
					  '"data": null,'+
					  '"httpCode": 400,'+
					  '"message": "No se pudo generar la orden. No se pueden visualizar los datos en este momento"'+
				  '}'+
				'}';
	}

	public static String getFoundDeshacer(){
		return '{'+
				  '"error": false,'+
				  '"data": {'+
					  '"lote": {'+
						  '"lr_id": 5404,'+
						  '"estado": "A",'+
						  '"prei_id": "38874",'+
						  '"procesos": ['+
							  '{'+
								  '"prei_id": "38874",'+
								  '"inicio": "2020-04-16 09:58:50",'+
								  '"fin": "2020-04-16 09:58:50",'+
								  '"lr_lr_id": "5404",'+
								  '"vda_drv_tipo_proceso": "RETPELOR",'+
								  '"nombre_proc": "ELIMINA ORD.",'+
								  '"logs": []'+
							  '}'+
						  ']'+
					  '}'+
				  '},'+
				  '"httpCode": 201,'+
				  '"message": "Se deshizo la orden correctamente.",'+
				  '"meta": {'+
					  '"allowed_includes": [],'+
					  '"default_includes": []'+
				  '}'+
				'}';

	}
}