public class WSLoteContabilizarMock  {

	public static String getFoundContabilizar(){
		return '{'+
				  '"error": false,'+
				  '"data": {'+
					'"lote": {'+
					  '"lr_id": 5402,'+
					  '"estado": "O",'+
					  '"prei_id": "38863",'+
					  '"procesos": ['+
						'{'+
						  '"prei_id": "38863",'+
						  '"inicio": "2020-04-13 14:59:23",'+
						  '"fin": "2020-04-13 14:59:23",'+
						  '"lr_lr_id": "5402",'+
						  '"vda_drv_tipo_proceso": "RETPCONT",'+
						  '"nombre_proc": "CONTABILIZACION",'+
						  '"logs": []'+
						'}'+
					  ']'+
					'}'+
				  '},'+
				  '"httpCode": 201,'+
				  '"message": "Se contabilizó correctamente el lote.",'+
				  '"meta": {'+
					'"allowed_includes": [],'+
					'"default_includes": []'+
				  '}'+
				'}';
	}

	public static String getFoundAnular(){
		return '{'+
				  '"error": false,'+
				  '"data": {'+
					'"lote": {'+
					  '"lr_id": 5402,'+
					  '"estado": "C",'+
					  '"prei_id": "38866",'+
					  '"procesos": ['+
						'{'+
						  '"prei_id": "38866",'+
						  '"inicio": "2020-04-13 15:03:34",'+
						  '"fin": "2020-04-13 15:03:34",'+
						  '"lr_lr_id": "5402",'+
						  '"vda_drv_tipo_proceso": "RETPDECO",'+
						  '"nombre_proc": "ANULA CONT.",'+
						  '"logs": []'+
						'}'+
					  ']'+
					'}'+
				  '},'+
				  '"httpCode": 201,'+
				  '"message": "Se anuló correctamente la contabilización del lote.",'+
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
					  '"message": "ERROR AL CONTABILIZAR LOTE. no esta en estado CERRADO",'+
					  '"debug_message": {'+
						  '"ERROR AL CONTABILIZAR LOTE ORA-20002": "El lote 5407 no esta en estado CERRADO"'+
					  '}'+
				  '},'+
				  '"data": null,'+
				  '"httpCode": 400,'+
				  '"message": "No se pudo contabilizar el lote."'+
			  '}'+
			'}';
	}
}