public class WSCasoEnviarASSResp {

	public class Meta {
		public List<Allowed_includes> allowed_includes {get;set;}
		public List<Allowed_includes> default_includes {get;set;}

		public Meta(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'allowed_includes') {
							allowed_includes = arrayOfAllowed_includes(parser);
						} else if (text == 'default_includes') {
							default_includes = arrayOfAllowed_includes(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Meta consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Allowed_includes {

		public Allowed_includes(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'Allowed_includes consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public Data data {get;set;}
	public Meta meta {get;set;}

	public WSCasoEnviarASSResp(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'data') {
						data = new Data(parser);
					} else if (text == 'meta') {
						meta = new Meta(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'WSCasoEnviarASSResp consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}

	public class Prestaciones {
		public String apr_id {get;set;}
		public String estado_prestacion {get;set;}
		public String estado_descripcion {get;set;}
		public String contexto {get;set;}
		public String cantidad {get;set;}
		public String prestacion {get;set;}
		public String nombre_prestacion {get;set;}
		public String tipo_prestacion {get;set;}
		public String troquel {get;set;}
		public String grupo_prestacion {get;set;}
		public String pca_id {get;set;}
		public String alerta {get;set;}
		public String texto_aclarativo {get;set;}
		public List<Alertas> alertas {get;set;}

		public Prestaciones(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'apr_id') {
							apr_id = parser.getText();
						} else if (text == 'estado_prestacion') {
							estado_prestacion = parser.getText();
						} else if (text == 'estado_descripcion') {
							estado_descripcion = parser.getText();
						} else if (text == 'contexto') {
							contexto = parser.getText();
						} else if (text == 'cantidad') {
							cantidad = parser.getText();
						} else if (text == 'prestacion') {
							prestacion = parser.getText();
						} else if (text == 'nombre_prestacion') {
							nombre_prestacion = parser.getText();
						} else if (text == 'tipo_prestacion') {
							tipo_prestacion = parser.getText();
						} else if (text == 'troquel') {
							troquel = parser.getText();
						} else if (text == 'grupo_prestacion') {
							grupo_prestacion = parser.getText();
						} else if (text == 'pca_id') {
							pca_id = parser.getText();
						} else if (text == 'alerta') {
							alerta = parser.getText();
						} else if (text == 'texto_aclarativo') {
							texto_aclarativo = parser.getText();
						} else if (text == 'alertas') {
							alertas = arrayOfAlertas(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Prestaciones consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Data {
		public Ap ap {get;set;}

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ap') {
							ap = new Ap(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Alertas {
		public String pca_pca_id {get;set;}
		public String aca_id {get;set;}
		public String cca_cca_id {get;set;}
		public String control {get;set;}
		public String nombre_control {get;set;}
		public String funcion {get;set;}
		public String texto_aclarativo {get;set;}
		public String nivel_auditoria {get;set;}
		public String nota_auditor {get;set;}
		public String observaciones {get;set;}
		public String fecha_generacion {get;set;}
		public String fecha_lectura {get;set;}
		public String auditor_lee {get;set;}
		public String fecha_resolucion {get;set;}
		public String auditor_resuelve {get;set;}
		public String estado_alerta {get;set;}
		public String descripcion_estado {get;set;}

		public Alertas(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'pca_pca_id') {
							pca_pca_id = parser.getText();
						} else if (text == 'aca_id') {
							aca_id = parser.getText();
						} else if (text == 'cca_cca_id') {
							cca_cca_id = parser.getText();
						} else if (text == 'control') {
							control = parser.getText();
						} else if (text == 'nombre_control') {
							nombre_control = parser.getText();
						} else if (text == 'funcion') {
							funcion = parser.getText();
						} else if (text == 'texto_aclarativo') {
							texto_aclarativo = parser.getText();
						} else if (text == 'nivel_auditoria') {
							nivel_auditoria = parser.getText();
						} else if (text == 'nota_auditor') {
							nota_auditor = parser.getText();
						} else if (text == 'observaciones') {
							observaciones = parser.getText();
						} else if (text == 'fecha_generacion') {
							fecha_generacion = parser.getText();
						} else if (text == 'fecha_lectura') {
							fecha_lectura = parser.getText();
						} else if (text == 'auditor_lee') {
							auditor_lee = parser.getText();
						} else if (text == 'fecha_resolucion') {
							fecha_resolucion = parser.getText();
						} else if (text == 'auditor_resuelve') {
							auditor_resuelve = parser.getText();
						} else if (text == 'estado_alerta') {
							estado_alerta = parser.getText();
						} else if (text == 'descripcion_estado') {
							descripcion_estado = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Alertas consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Ap {
		public String apr_id {get;set;}
		public String fecha {get;set;}
		public String conexion {get;set;}
		public String nombre_conexion {get;set;}
		public String delegacion {get;set;}
		public String nombre_delegacion {get;set;}
		public String fecha_probable {get;set;}
		public String estado {get;set;}
		public String nombre_estado {get;set;}
		public String user_insert {get;set;}
		public String fecha_insert {get;set;}
		public String codigo_afiliado {get;set;}
		public String apellidos_afiliado {get;set;}
		public String nombres_afiliado {get;set;}
		public String doc_afiliado {get;set;}
		public String evento_medico {get;set;}
		public String fecha_prescripcion {get;set;}
		public String diagnostico {get;set;}
		public String desc_diagnostico {get;set;}
		public String prescriptor {get;set;}
		public String nombre_prescriptor {get;set;}
		public String prestador_dirige {get;set;}
		public String nombre_prestador_dirige {get;set;}
		public String prestador {get;set;}
		public String nombre_prestador {get;set;}
		public String consultorio {get;set;}
		public String nombre_consultorio {get;set;}
		public String observaciones {get;set;}
		public String mail {get;set;}
		public String otros_mail {get;set;}
		public String aca_agencia {get;set;}
		public String tran_alta {get;set;}
		public String tran_anulacion {get;set;}
		public String ref_externa {get;set;}
		public String urgente {get;set;}
		public String afi_id {get;set;}
		public String nro_sf {get;set;}
		public String nivel {get;set;}
		public String clasificacion {get;set;}
		public String tipo_ap_sf {get;set;}
		public String celula {get;set;}
		public String sla {get;set;}
		public List<Prestaciones> prestaciones {get;set;}

		public Ap(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'apr_id') {
							apr_id = parser.getText();
						} else if (text == 'fecha') {
							fecha = parser.getText();
						} else if (text == 'conexion') {
							conexion = parser.getText();
						} else if (text == 'nombre_conexion') {
							nombre_conexion = parser.getText();
						} else if (text == 'delegacion') {
							delegacion = parser.getText();
						} else if (text == 'nombre_delegacion') {
							nombre_delegacion = parser.getText();
						} else if (text == 'fecha_probable') {
							fecha_probable = parser.getText();
						} else if (text == 'estado') {
							estado = parser.getText();
						} else if (text == 'nombre_estado') {
							nombre_estado = parser.getText();
						} else if (text == 'user_insert') {
							user_insert = parser.getText();
						} else if (text == 'fecha_insert') {
							fecha_insert = parser.getText();
						} else if (text == 'codigo_afiliado') {
							codigo_afiliado = parser.getText();
						} else if (text == 'apellidos_afiliado') {
							apellidos_afiliado = parser.getText();
						} else if (text == 'nombres_afiliado') {
							nombres_afiliado = parser.getText();
						} else if (text == 'doc_afiliado') {
							doc_afiliado = parser.getText();
						} else if (text == 'evento_medico') {
							evento_medico = parser.getText();
						} else if (text == 'fecha_prescripcion') {
							fecha_prescripcion = parser.getText();
						} else if (text == 'diagnostico') {
							diagnostico = parser.getText();
						} else if (text == 'desc_diagnostico') {
							desc_diagnostico = parser.getText();
						} else if (text == 'prescriptor') {
							prescriptor = parser.getText();
						} else if (text == 'nombre_prescriptor') {
							nombre_prescriptor = parser.getText();
						} else if (text == 'prestador_dirige') {
							prestador_dirige = parser.getText();
						} else if (text == 'nombre_prestador_dirige') {
							nombre_prestador_dirige = parser.getText();
						} else if (text == 'prestador') {
							prestador = parser.getText();
						} else if (text == 'nombre_prestador') {
							nombre_prestador = parser.getText();
						} else if (text == 'consultorio') {
							consultorio = parser.getText();
						} else if (text == 'nombre_consultorio') {
							nombre_consultorio = parser.getText();
						} else if (text == 'observaciones') {
							observaciones = parser.getText();
						} else if (text == 'mail') {
							mail = parser.getText();
						} else if (text == 'otros_mail') {
							otros_mail = parser.getText();
						} else if (text == 'aca_agencia') {
							aca_agencia = parser.getText();
						} else if (text == 'tran_alta') {
							tran_alta = parser.getText();
						} else if (text == 'tran_anulacion') {
							tran_anulacion = parser.getText();
						} else if (text == 'ref_externa') {
							ref_externa = parser.getText();
						} else if (text == 'urgente') {
							urgente = parser.getText();
						} else if (text == 'afi_id') {
							afi_id = parser.getText();
						} else if (text == 'nro_sf') {
							nro_sf = parser.getText();
						} else if (text == 'nivel') {
							nivel = translateNivel(parser.getText());
						} else if (text == 'clasificacion') {
							clasificacion = parser.getText();
						} else if (text == 'tipo_ap_sf') {
							tipo_ap_sf = parser.getText();
						} else if (text == 'celula') {
							celula = parser.getText();
						} else if (text == 'sla') {
							sla = parser.getText();
						} else if (text == 'prestaciones') {
							prestaciones = arrayOfPrestaciones(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Ap consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public static String translateNivel(String lvl){
		switch on lvl{
			when 'N1'{
				return 'Nivel 1';
			}
			when 'N2'{
				return 'Nivel 2';
			}
			when 'N3'{
				return 'Nivel 3';
			}
			when else{
				return 'Nivel 1';
			}
		}
	}


	public static WSCasoEnviarASSResp parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new WSCasoEnviarASSResp(parser);
	}

	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT ||
					curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
					curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}








	private static List<Allowed_includes> arrayOfAllowed_includes(System.JSONParser p) {
		List<Allowed_includes> res = new List<Allowed_includes>();
		if (p.getCurrentToken() == null) p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY) {
			res.add(new Allowed_includes(p));
		}
		return res;
	}


	private static List<Alertas> arrayOfAlertas(System.JSONParser p) {
		List<Alertas> res = new List<Alertas>();
		if (p.getCurrentToken() == null) p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY) {
			res.add(new Alertas(p));
		}
		return res;
	}


	private static List<Prestaciones> arrayOfPrestaciones(System.JSONParser p) {
		List<Prestaciones> res = new List<Prestaciones>();
		if (p.getCurrentToken() == null) p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY) {
			res.add(new Prestaciones(p));
		}
		return res;
	}

//	//-------------------------------------------------------------------------------------------------
//	public class Errors {
//		public String message {get;set;}
//		public String debug_message {get;set;}
//
//		public Errors(JSONParser parser) {
//			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
//				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
//					String text = parser.getText();
//					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
//						if (text == 'message') {
//							message = parser.getText();
//						} else if (text == 'debug_message') {
//							debug_message = parser.getText();
//						} else {
//							System.debug(LoggingLevel.WARN, 'Errors consuming unrecognized property: '+text);
//							consumeObject(parser);
//						}
//					}
//				}
//			}
//		}
//	}
//
//	public class Data {
//		public Ap ap {get;set;}
//		public Boolean error {get;set;}
//		public Errors errors {get;set;}
////		public Object data {get;set;}
//		public Integer httpCode {get;set;}
//		public String message {get;set;}
//
//		public Data(JSONParser parser) {
//			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
//				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
//					String text = parser.getText();
//					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
//						if (text == 'ap') {
//							ap = new Ap(parser);
//						} else if (text == 'error') {
//							error = parser.getBooleanValue();
//						} else if (text == 'errors') {
//							errors = new Errors(parser);
////						} else if (text == 'data') {
////							data = parser.readValueAs(Object.class);
//						} else if (text == 'httpCode') {
//							httpCode = parser.getIntegerValue();
//						} else if (text == 'message') {
//							message = parser.getText();
//						} else {
//							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
//							consumeObject(parser);
//						}
//					}
//				}
//			}
//		}
//	}
//
//	//-------------------------------------------------------------------------------------------------




}