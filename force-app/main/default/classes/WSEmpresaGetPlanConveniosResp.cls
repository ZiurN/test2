//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class WSEmpresaGetPlanConveniosResp {

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
		@AuraEnabled public String fecha_desde {get;set;} 
		@AuraEnabled public String fecha_hasta {get;set;} 
		public String anulado {get;set;} 
		public String plan_codigo {get;set;} 
		@AuraEnabled public String plan_nombre {get;set;} 
		public String plaperm_id {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'fecha_desde') {
							fecha_desde = parser.getText();
						} else if (text == 'fecha_hasta') {
							fecha_hasta = parser.getText();
						} else if (text == 'anulado') {
							anulado = parser.getText();
						} else if (text == 'plan_codigo') {
							plan_codigo = parser.getText();
						} else if (text == 'plan_nombre') {
							plan_nombre = parser.getText();
						} else if (text == 'plaperm_id') {
							plaperm_id = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
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
	
	public List<Data> data {get;set;} 
	public Meta meta {get;set;} 

	public WSEmpresaGetPlanConveniosResp(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'data') {
						data = arrayOfData(parser);
					} else if (text == 'meta') {
						meta = new Meta(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'WSEmpresaGetPlanConveniosResp consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static WSEmpresaGetPlanConveniosResp parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new WSEmpresaGetPlanConveniosResp(parser);
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
	



    private static List<Data> arrayOfData(System.JSONParser p) {
        List<Data> res = new List<Data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Data(p));
        }
        return res;
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

}