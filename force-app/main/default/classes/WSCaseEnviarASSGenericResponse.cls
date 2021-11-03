/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase deserializadora para las respuestas  de llamados a SS.
@date			26/10/2021
------------------------------------------------------------------------------------------------------------------------*/
public class WSCaseEnviarASSGenericResponse {
	public Boolean error {get;set;}
	public Integer httpCode {get;set;}
	public String message {get;set;}
	public List<Data> data {get;set;}
	public Meta meta {get;set;}
	/** Objeto Meta */
		public class Meta {
			public List<Notas> allowed_includes {get;set;}
			public List<Notas> default_includes {get;set;}
			public Meta(JSONParser parser) {
				while (parser.nextToken() != System.JSONToken.END_OBJECT) {
					if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
						String text = parser.getText();
						if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
							switch on text {
								when 'allowed_includes' {
									allowed_includes = arrayOfNotas(parser);
								}
								when 'default_includes' {
									default_includes = arrayOfNotas(parser);
								}
								when else {
									System.debug(LoggingLevel.WARN, 'Meta consuming unrecognized property: '+text);
									consumeObject(parser);
								}
							}
						}
					}
				}
			}
		}
	/** Objeto Notas */
		public class Notas {
			public String nota_id {get;set;}
			public String texto_nota {get;set;}
			public String sf_id {get;set;}
			public String texto {get;set;}
			public String usuario_nota {get;set;}
			public Notas(JSONParser parser) {
				while (parser.nextToken() != System.JSONToken.END_OBJECT) {
					if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
						String text = parser.getText();
						if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
							switch on text {
								when 'sf_id' {
									sf_id = parser.getText();
								}
								when 'texto' {
									texto = parser.getText();
								}
								when 'nota_id' {
									nota_id = parser.getText();
								}
								when 'texto_nota' {
									texto_nota = parser.getText();
								}
								when 'usuario_nota' {
									usuario_nota = parser.getText();
								}
								when else {
									System.debug(LoggingLevel.WARN, 'Notas consuming unrecognized property: '+text);
								consumeObject(parser);
								}
							}
						}
					}
				}
			}
		}
	/** Objeto Data */
		public class Data {
			public List<Ap> ap {get;set;}
			public String sf_id {get;set;}
			public String solafi_id {get;set;}
			public String estado_sol {get;set;}
			public String estado_dj {get;set;}
			public String codigo_as {get;set;}
			public String tipo_asoc {get;set;}
			public String afi_id {get;set;}
			public String empresa_codigo {get;set;}
			public String suc_empresa {get;set;}
			public List<Notas> notas {get;set;}
			public Boolean error {get;set;}
			public Map<String, String[]> errors {get;set;}
			public String errorType {get; set;}
			public Integer httpCode {get; set;}
			public String message {get; set;}
			public List<String> debug_message {get; set;}
			public String exception_text {get; set;}
			public Integer line {get; set;}
			public Data(JSONParser parser) {
				while (parser.nextToken() != System.JSONToken.END_OBJECT) {
					System.debug(parser.getText());
					if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
						String text = parser.getText();
						if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
							switch on text {
								when 'sf_id' {
									sf_id = parser.getText();
								}
								when 'solafi_id' {
									solafi_id = parser.getText();
								}
								when 'estado_sol' {
									estado_sol = parser.getText();
								}
								when 'estado_dj' {
									estado_dj = parser.getText();
								}
								when 'codigo_as' {
									codigo_as = parser.getText();
								}
								when 'tipo_asoc' {
									tipo_asoc = parser.getText();
								}
								when 'afi_id' {
									afi_id = parser.getText();
								}
								when 'empresa_codigo' {
									empresa_codigo = parser.getText();
								}
								when 'suc_empresa' {
									suc_empresa = parser.getText();
								}
								when 'notas' {
									notas = arrayOfNotas(parser);
								}
								when 'ap' {
									ap = arrayOfAp(parser);
								}
								when 'error' {
									error = parser.getBooleanValue();
								}
								when 'errors' {
									Map<String, String[]> errMap = (Map<String, String[]>) parser.readValueAs(Map<String, String[]>.class);
									errors = errMap;
								}
								when 'errorType' {
									errorType = parser.getText();
								}
								when 'httpCode' {
									httpCode = parser.getIntegerValue();
								}
								when 'debug_message' {
									List<String> debugList = (List<String>) parser.readValueAs(List<String>.class);
									debug_message = debugList;
								}
								when 'exception' {
									exception_text = parser.getText();
								}
								when 'line' {
									line = parser.getIntegerValue();
								}
								when 'message' {
									message = parser.getText();
								}
								when else {
									System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: ' + text);
									consumeObject(parser);
								}
							}
						}
					}
				}
			}
		}
		/** Objeto AP */
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
				public String ap_material {get;set;}
				public String ap_presupuesto {get;set;}
				public String celula {get;set;}
				public String sla {get;set;}
				public String estado_em {get;set;}
				public List<Prestaciones> prestaciones {get;set;}
				public Ap(JSONParser parser) {
					while (parser.nextToken() != System.JSONToken.END_OBJECT) {
						if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
							String text = parser.getText();
							if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
								switch on text {
									when 'apr_id' {
										apr_id = parser.getText();
									}
									when 'fecha' {
										fecha = parser.getText();
									}
									when 'conexion' {
										conexion = parser.getText();
									}
									when 'nombre_conexion' {
										nombre_conexion = parser.getText();
									}
									when 'delegacion' {
										delegacion = parser.getText();
									}
									when 'nombre_delegacion' {
										nombre_delegacion = parser.getText();
									}
									when 'fecha_probable' {
										fecha_probable = parser.getText();
									}
									when  'estado' {
										estado = parser.getText();
									}
									when 'nombre_estado' {
										nombre_estado = parser.getText();
									}
									when 'user_insert' {
										user_insert = parser.getText();
									}
									when 'fecha_insert' {
										fecha_insert = parser.getText();
									}
									when 'codigo_afiliado' {
										codigo_afiliado = parser.getText();
									}
									when 'apellidos_afiliado' {
										apellidos_afiliado = parser.getText();
									}
									when 'nombres_afiliado' {
										nombres_afiliado = parser.getText();
									}
									when  'doc_afiliado' {
										doc_afiliado = parser.getText();
									}
									when 'evento_medico' {
										evento_medico = parser.getText();
									}
									when 'fecha_prescripcion' {
										fecha_prescripcion = parser.getText();
									}
									when  'diagnostico' {
										diagnostico = parser.getText();
									}
									when 'desc_diagnostico' {
										desc_diagnostico = parser.getText();
									}
									when 'prescriptor' {
										prescriptor = parser.getText();
									}
									when 'nombre_prescriptor' {
										nombre_prescriptor = parser.getText();
									}
									when 'prestador_dirige' {
										prestador_dirige = parser.getText();
									}
									when 'nombre_prestador_dirige' {
										nombre_prestador_dirige = parser.getText();
									}
									when 'prestador' {
										prestador = parser.getText();
									}
									when 'nombre_prestador' {
										nombre_prestador = parser.getText();
									}
									when 'consultorio' {
										consultorio = parser.getText();
									}
									when 'nombre_consultorio' {
										nombre_consultorio = parser.getText();
									}
									when 'observaciones' {
										observaciones = parser.getText();
									}
									when 'mail' {
										mail = parser.getText();
									}
									when 'otros_mail' {
										otros_mail = parser.getText();
									}
									when 'aca_agencia' {
										aca_agencia = parser.getText();
									}
									when 'tran_alta' {
										tran_alta = parser.getText();
									}
									when 'tran_anulacion' {
										tran_anulacion = parser.getText();
									}
									when 'ref_externa' {
										ref_externa = parser.getText();
									}
									when 'urgente' {
										urgente = parser.getText();
									}
									when 'afi_id' {
										afi_id = parser.getText();
									}
									when 'nro_sf' {
										nro_sf = parser.getText();
									}
									when 'nivel' {
										nivel = translateNivel(parser.getText());
									}
									when 'clasificacion' {
										clasificacion = parser.getText();
									}
									when 'tipo_ap_sf' {
										tipo_ap_sf = parser.getText();
									}
									when 'ap_material' {
										ap_material = parser.getText();
									}
									when 'ap_presupuesto' {
										ap_presupuesto = parser.getText();
									}
									when 'celula' {
										celula = parser.getText();
									}
									when 'sla' {
										sla = parser.getText();
									}
									when 'estado_em' {
										estado_em = parser.getText();
									}
									when 'prestaciones' {
										prestaciones = arrayOfPrestaciones(parser);
									}
									when else {
										System.debug(LoggingLevel.WARN, 'Ap consuming unrecognized property: '+text);
										consumeObject(parser);
									}
								}
							}
						}
					}
				}
			}
			/** Objeto Prestaciones */
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
				public String importe_plan_sys {get;set;}
				public String importe_plan_aud {get;set;}
				public String importe_convenio_sys {get;set;}
				public String importe_convenio_aud {get;set;}
				public String importe_cargo_al_socio_sys {get;set;}
				public String importe_cargo_al_socio_aud {get;set;}
				public String importe_rein_sys {get;set;}
				public String importe_rein_aud {get;set;}
				public List<Alertas> alertas {get;set;}
				public Prestaciones(JSONParser parser) {
					while (parser.nextToken() != System.JSONToken.END_OBJECT) {
						if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
							String text = parser.getText();
							if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
								switch on text {
									when 'apr_id' {
										apr_id = parser.getText();
									}
									when 'estado_prestacion' {
										estado_prestacion = parser.getText();
									}
									when 'estado_descripcion' {
										estado_descripcion = parser.getText();
									}
									when 'contexto' {
										contexto = parser.getText();
									}
									when 'cantidad' {
										cantidad = parser.getText();
									}
									when 'prestacion' {
										prestacion = parser.getText();
									}
									when 'nombre_prestacion' {
										nombre_prestacion = parser.getText();
									}
									when 'tipo_prestacion' {
										tipo_prestacion = parser.getText();
									}
									when 'troquel' {
										troquel = parser.getText();
									}
									when 'grupo_prestacion' {
										grupo_prestacion = parser.getText();
									}
									when 'pca_id' {
										pca_id = parser.getText();
									}
									when 'alerta' {
										alerta = parser.getText();
									}
									when 'texto_aclarativo' {
										texto_aclarativo = parser.getText();
									}
									when 'importe_plan_sys' {
										importe_plan_sys = parser.getText();
									}
									when 'importe_plan_aud' {
										importe_plan_aud = parser.getText();
									}
									when 'importe_convenio_sys' {
										importe_convenio_sys = parser.getText();
									}
									when 'importe_convenio_aud' {
										importe_convenio_aud = parser.getText();
									}
									when 'importe_cargo_al_socio_sys' {
										importe_cargo_al_socio_sys = parser.getText();
									}
									when 'importe_cargo_al_socio_aud' {
										importe_cargo_al_socio_aud = parser.getText();
									}
									when 'importe_rein_sys' {
										importe_rein_sys = parser.getText();
									}
									when 'importe_rein_aud' {
										importe_rein_aud = parser.getText();
									}
									when 'alertas' {
										alertas = arrayOfAlertas(parser);
									}
									when else {
										System.debug(LoggingLevel.WARN, 'Prestaciones consuming unrecognized property: '+text);
										consumeObject(parser);
									}
								}
							}
						}
					}
				}
			}
			/** Objeco Alertas */
				public class Alertas {
					public String pca_pca_id {get;set;}
					public String aca_id {get;set;}
					public String cca_cca_id {get;set;}
					public String control {get;set;}
					public String nombre_control {get;set;}
					public String funcion {get;set;}
					public String texto_aclarativo {get;set;}
					public String nivel_auditoria {get;set;}
					public String estado_alerta {get;set;}
					public String descripcion_estado {get;set;}
					public String nota_auditor {get;set;}
					public String observaciones {get;set;}
					public String fecha_generacion {get;set;}
					public String fecha_lectura {get;set;}
					public String auditor_lee {get;set;}
					public String fecha_resolucion {get;set;}
					public String auditor_resuelve {get;set;}
					public Alertas(JSONParser parser) {
						while (parser.nextToken() != System.JSONToken.END_OBJECT) {
							if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
								String text = parser.getText();
								if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
									switch on text {
										when 'pca_pca_id' {
											pca_pca_id = parser.getText();
										}
										when 'aca_id' {
											aca_id = parser.getText();
										}
										when 'cca_cca_id' {
											cca_cca_id = parser.getText();
										}
										when 'control' {
											control = parser.getText();
										}
										when 'nombre_control' {
											nombre_control = parser.getText();
										}
										when 'funcion' {
											funcion = parser.getText();
										}
										when 'texto_aclarativo' {
											texto_aclarativo = parser.getText();
										}
										when 'nivel_auditoria' {
											nivel_auditoria = parser.getText();
										}
										when 'estado_alerta' {
											estado_alerta = parser.getText();
										}
										when 'descripcion_estado' {
											descripcion_estado = parser.getText();
										}
										when 'nota_auditor' {
											nota_auditor = parser.getText();
										}
										when 'observaciones' {
											observaciones = parser.getText();
										}
										when 'fecha_generacion' {
											fecha_generacion = parser.getText();
										}
										when 'fecha_lectura' {
											fecha_lectura = parser.getText();
										}
										when 'auditor_lee' {
											auditor_lee = parser.getText();
										}
										when 'fecha_resolucion' {
											fecha_resolucion = parser.getText();
										}
										when 'auditor_resuelve' {
											auditor_resuelve = parser.getText();
										}
										when else {
											System.debug(LoggingLevel.WARN, 'Alertas consuming unrecognized property: '+text);
											consumeObject(parser);
										}
									}
								}
							}
						}
					}
				}
	/** Constructor */
	public WSCaseEnviarASSGenericResponse (JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					switch on text {
						when 'error' {
							error = parser.getBooleanValue();
						}
						when 'data' {
							System.debug(parser.getCurrentToken());
							if (parser.getCurrentToken() == System.JSONToken.START_ARRAY) {
								data = arrayofDatas(parser);
							} else if (parser.getCurrentToken() == System.JSONToken.START_OBJECT) {
								Data dataToList =  new Data(parser);
								data = new List<Data>{dataToList};
							}
						}
						when 'httpCode' {
							httpCode = parser.getIntegerValue();
						}
						when 'message' {
							message = parser.getText();
						}
						when 'meta' {
							meta = new Meta(parser);
						}
						when else {
							System.debug(LoggingLevel.WARN, 'WSCaseEnviarASSGenericResponse consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/** Métodos de construcción */
	public static WSCaseEnviarASSGenericResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new WSCaseEnviarASSGenericResponse(parser);
	}
	private static List<Data> arrayOfDatas(System.JSONParser p) {
		List<Data> res = new List<Data>();
		if (p.getCurrentToken() == null) p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY) {
			res.add(new Data(p));
		}
		return res;
	}
	private static List<Notas> arrayOfNotas(System.JSONParser p) {
		List<Notas> res = new List<Notas>();
		if (p.getCurrentToken() == null) p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY) {
			res.add(new Notas(p));
		}
		return res;
	}
	private static List<Ap> arrayOfAp(System.JSONParser p) {
		List<Ap> res = new List<Ap>();
		if (p.getCurrentToken() == null) p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY) {
			res.add(new Ap(p));
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
	private static List<Alertas> arrayOfAlertas(System.JSONParser p) {
		List<Alertas> res = new List<Alertas>();
		if (p.getCurrentToken() == null) p.nextToken();
		while (p.nextToken() != System.JSONToken.END_ARRAY) {
			res.add(new Alertas(p));
		}
		return res;
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
	/** Para enviar y determinar el mensaje de error */
	public String processMessage () {
		String message = '';
		if (this.data[0].httpCode > 400 && this.data[0].httpCode <= 500) {
			if (!String.isBlank(this.message) && this.error) {
				message = this.message;
			} else if (!String.isBlank(this.data[0].message) && this.data[0].error) {
				message = this.data[0].message;
			}
		}
		else{
			List<List<String>> errorLists = new List<List<String>>(this.data[0].errors.values());
			for (Integer i = 0; i < errorLists.size(); i++) {
				message += errorLists[0][0] + (i == errorLists.size()-1 ? '' : ', ' );
			}
		}
		return message;
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
}