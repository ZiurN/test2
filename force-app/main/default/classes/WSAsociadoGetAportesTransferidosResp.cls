//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class WSAsociadoGetAportesTransferidosResp {

	public class Meta {
		public List<Allowed_filters> allowed_filters {get;set;} 
		public List<Allowed_filters> allowed_sorts {get;set;} 
		public List<Allowed_filters> allowed_appends {get;set;} 
		public List<Allowed_filters> allowed_fields {get;set;} 
		public List<Allowed_filters> allowed_includes {get;set;} 
		public List<Allowed_filters> default_includes {get;set;} 
		public Optional_get_vars optional_get_vars {get;set;} 

		public Meta(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'allowed_filters') {
							allowed_filters = arrayOfAllowed_filters(parser);
						} else if (text == 'allowed_sorts') {
							allowed_sorts = arrayOfAllowed_filters(parser);
						} else if (text == 'allowed_appends') {
							allowed_appends = arrayOfAllowed_filters(parser);
						} else if (text == 'allowed_fields') {
							allowed_fields = arrayOfAllowed_filters(parser);
						} else if (text == 'allowed_includes') {
							allowed_includes = arrayOfAllowed_filters(parser);
						} else if (text == 'default_includes') {
							default_includes = arrayOfAllowed_filters(parser);
						} else if (text == 'optional_get_vars') {
							optional_get_vars = new Optional_get_vars(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Meta consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Optional_get_vars {
		public List<Allowed_filters> sortBy {get;set;} 
		public List<String> sortOrder {get;set;} 

		public Optional_get_vars(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'sortBy') {
							sortBy = arrayOfAllowed_filters(parser);
						} else if (text == 'sortOrder') {
							sortOrder = arrayOfString(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Optional_get_vars consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Data {
		public String dnat_id {get;set;} 
		@AuraEnabled public String periodo {get;set;} 
		@AuraEnabled public String cuit {get;set;} 
		@AuraEnabled public String empleador {get;set;} 
		@AuraEnabled public String nombre_empleador {get;set;} 
		public String obra_social {get;set;} 
		@AuraEnabled public String cod_ooss {get;set;} 
		@AuraEnabled public String nombre_ooss {get;set;} 
		public String cuil {get;set;} 
		@AuraEnabled public String origen_aporte {get;set;} 
		@AuraEnabled public String aporte {get;set;} 
		@AuraEnabled public String aporte_reconocido {get;set;} 
		@AuraEnabled public String aporte_derivado {get;set;} 
		@AuraEnabled public String subsidio {get;set;} 
		@AuraEnabled public String secuencia {get;set;} 
		public String constribucion {get;set;} 
		public String adherentes {get;set;} 
		public String remuneracion {get;set;} 
		public String familiares {get;set;} 
		public String ooss_cargada {get;set;} 
		public Integer at_id {get;set;} 
		public String secuencia_at {get;set;} 
		public String origen_aporte_at {get;set;} 
		public String secuencia_nominal {get;set;} 
		public String origen_aporte_nomi {get;set;} 
		public String total_aportes {get;set;} 
		public String total_aportes_reconocidos {get;set;} 
		public String total_familiares {get;set;} 
		public String total_remuneraciones {get;set;} 
		public String total_aportes_derivados {get;set;} 
		public String total_constribucion {get;set;} 
		public String total_adherentes {get;set;} 
		public String total_aportes_nomi {get;set;} 
		public String total_aportes_reconocidos_nomi {get;set;} 
		public String total_familiares_nomi {get;set;} 
		public String total_remuneracines_nomi {get;set;} 
		public String total_aportes_derivados_nomi {get;set;} 
		public String total_contribucion_nom {get;set;} 
		public String total_adherentes_nomi {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'dnat_id') {
							dnat_id = parser.getText();
						} else if (text == 'periodo') {
							periodo = parser.getText();
						} else if (text == 'cuit') {
							cuit = parser.getText();
						} else if (text == 'empleador') {
							empleador = parser.getText();
						} else if (text == 'nombre_empleador') {
							nombre_empleador = parser.getText();
						} else if (text == 'obra_social') {
							obra_social = parser.getText();
						} else if (text == 'cod_ooss') {
							cod_ooss = parser.getText();
						} else if (text == 'nombre_ooss') {
							nombre_ooss = parser.getText();
						} else if (text == 'cuil') {
							cuil = parser.getText();
						} else if (text == 'origen_aporte') {
							origen_aporte = parser.getText();
						} else if (text == 'aporte') {
							aporte = parser.getText();
						} else if (text == 'aporte_reconocido') {
							aporte_reconocido = parser.getText();
						} else if (text == 'aporte_derivado') {
							aporte_derivado = parser.getText();
						} else if (text == 'subsidio') {
							subsidio = parser.getText();
						} else if (text == 'secuencia') {
							secuencia = parser.getText();
						} else if (text == 'constribucion') {
							constribucion = parser.getText();
						} else if (text == 'adherentes') {
							adherentes = parser.getText();
						} else if (text == 'remuneracion') {
							remuneracion = parser.getText();
						} else if (text == 'familiares') {
							familiares = parser.getText();
						} else if (text == 'ooss_cargada') {
							ooss_cargada = parser.getText();
						} else if (text == 'at_id') {
							at_id = parser.getIntegerValue();
						} else if (text == 'secuencia_at') {
							secuencia_at = parser.getText();
						} else if (text == 'origen_aporte_at') {
							origen_aporte_at = parser.getText();
						} else if (text == 'secuencia_nominal') {
							secuencia_nominal = parser.getText();
						} else if (text == 'origen_aporte_nomi') {
							origen_aporte_nomi = parser.getText();
						} else if (text == 'total_aportes') {
							total_aportes = parser.getText();
						} else if (text == 'total_aportes_reconocidos') {
							total_aportes_reconocidos = parser.getText();
						} else if (text == 'total_familiares') {
							total_familiares = parser.getText();
						} else if (text == 'total_remuneraciones') {
							total_remuneraciones = parser.getText();
						} else if (text == 'total_aportes_derivados') {
							total_aportes_derivados = parser.getText();
						} else if (text == 'total_constribucion') {
							total_constribucion = parser.getText();
						} else if (text == 'total_adherentes') {
							total_adherentes = parser.getText();
						} else if (text == 'total_aportes_nomi') {
							total_aportes_nomi = parser.getText();
						} else if (text == 'total_aportes_reconocidos_nomi') {
							total_aportes_reconocidos_nomi = parser.getText();
						} else if (text == 'total_familiares_nomi') {
							total_familiares_nomi = parser.getText();
						} else if (text == 'total_remuneracines_nomi') {
							total_remuneracines_nomi = parser.getText();
						} else if (text == 'total_aportes_derivados_nomi') {
							total_aportes_derivados_nomi = parser.getText();
						} else if (text == 'total_contribucion_nom') {
							total_contribucion_nom = parser.getText();
						} else if (text == 'total_adherentes_nomi') {
							total_adherentes_nomi = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public List<Data> data {get;set;} 
	public Meta meta {get;set;} 

	public WSAsociadoGetAportesTransferidosResp(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'data') {
						data = arrayOfData(parser);
					} else if (text == 'meta') {
						meta = new Meta(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'WSAsociadoGetAportesTransferidos consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Allowed_filters {

		public Allowed_filters(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'Allowed_filters consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static WSAsociadoGetAportesTransferidosResp parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new WSAsociadoGetAportesTransferidosResp(parser);
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
	




    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }

    private static List<Allowed_filters> arrayOfAllowed_filters(System.JSONParser p) {
        List<Allowed_filters> res = new List<Allowed_filters>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Allowed_filters(p));
        }
        return res;
    }

    private static List<Data> arrayOfData(System.JSONParser p) {
        List<Data> res = new List<Data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Data(p));
        }
        return res;
    }



}