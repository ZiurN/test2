public class WSAfiliadoGetInfoMock  {

	public static String getFound(){
		return '{'+
					'"data": {'+
						'"afi_id": 272454,'+
						'"codigo": "599997/01",'+
						'"entidad": "599997",'+
						'"apellidos": "SOCIO GENERICO ROSARIO",'+
						'"nombres": "GRAVADO PLANES CERCA",'+
						'"estado": "A",'+
						'"fecha_alta": "2004-11-01",'+
						'"fecha_nacimiento": "1965-06-22",'+
						'"fecha_alta_administrativa": "2004-01-01",'+
						'"edad": "54",'+
						'"sexo": "F",'+
						'"plan": null,'+
						'"credencial": null,'+
						'"tipo_doc": "DNI",'+
						'"nro_doc": "14657",'+
						'"calle": "RIOJA",'+
						'"numero": "1474",'+
						'"piso": "1",'+
						'"dpto": null,'+
						'"provincia": "SANTA FE",'+
						'"provincia_cod": "S",'+
						'"ciudad": "ROSARIO",'+
						'"ciudad_id": "2153",'+
						'"cod_postal": "2000",'+
						'"telefonos": null,'+
						'"celulares": null,'+
						'"email": null,'+
						'"factura_sin_papel": "NO",'+
						'"posee_discapacidad": "F",'+
						'"posee_embarazo": "F",'+
						'"agencia": "650098",'+
						'"adherido_debito_auto": "F",'+
						'"tiene_deuda": "F"'+
					'},'+
					'"meta": {'+
						'"allowed_includes": [],'+
						'"default_includes": []'+
					'}'+
					'}';
	}

	public static String getSecondFound(){
		return '{'+
					'"data": {'+
						'"afi_id": 272454,'+
						'"codigo": "599998/01",'+
						'"entidad": "599997",'+
						'"apellidos": "SOCIO GENERICO ROSARIO",'+
						'"nombres": "GRAVADO PLANES CERCA",'+
						'"estado": "A",'+
						'"fecha_alta": "2004-11-01",'+
						'"fecha_nacimiento": "1965-06-22",'+
						'"fecha_alta_administrativa": "2004-01-01",'+
						'"edad": "54",'+
						'"sexo": "F",'+
						'"plan": null,'+
						'"credencial": null,'+
						'"tipo_doc": "DNI",'+
						'"nro_doc": "14658",'+
						'"calle": "RIOJA",'+
						'"numero": "1474",'+
						'"piso": "1",'+
						'"dpto": null,'+
						'"provincia": "SANTA FE",'+
						'"provincia_cod": "S",'+
						'"ciudad": "ROSARIO",'+
						'"ciudad_id": "2153",'+
						'"cod_postal": "2000",'+
						'"telefonos": null,'+
						'"celulares": null,'+
						'"email": null,'+
						'"factura_sin_papel": "NO",'+
						'"posee_discapacidad": "F",'+
						'"posee_embarazo": "F",'+
						'"agencia": "650098",'+
						'"adherido_debito_auto": "F",'+
						'"tiene_deuda": "F"'+
					'},'+
					'"meta": {'+
						'"allowed_includes": [],'+
						'"default_includes": []'+
					'}'+
					'}';
	}

	public static String notFund(){
		return '{'+
				'"data": {'+
					'"error": true,'+
					'"errors": {'+
						'"message": "El afiliado no se encuentra en la base de datos",'+
						'"debug_message": ""'+
					'},'+
					'"data": null,'+
					'"httpCode": 200,'+
					'"message": "El afiliado no se encuentra en la base de datos"'+
				'}'+
			'}';
	}
}