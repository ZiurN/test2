public class WSCaseBajaResp {

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
	public string message {get;set;}
	public Meta meta {get;set;}

	public WSCaseBajaResp(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'data') {
						data = new Data(parser);
					} else if (text == 'message'){
						message = parser.getText();
					}else if (text == 'meta') {
						meta = new Meta(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'WSCaseBajaResp consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}

	public class Data {
		public string caso_id {get;set;}
        public string origen {get;set;}
        public string tipo {get;set;}
        public string sf_id {get;set;}
        public string nro_caso_sf {get;set;}
        public string estado_sf {get;set;}
        public string fecha_registro {get;set;}

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'caso_id') {
							caso_id = parser.getText();
						}else if (text == 'origen'){
                            origen = parser.getText();
                        }else if (text == 'tipo'){
                            tipo = parser.getText();
                        }else if (text == 'sf_id'){
                            sf_id = parser.getText();
                        }else if (text == 'nro_caso_sf'){
                            nro_caso_sf = parser.getText();
                        }else if (text == 'estado_sf'){
                            estado_sf = parser.getText();
                        }else if (text == 'fecha_registro'){
                            fecha_registro = parser.getText();
                        }else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
    
    public static WSCaseBajaResp parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new WSCaseBajaResp(parser);
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


}