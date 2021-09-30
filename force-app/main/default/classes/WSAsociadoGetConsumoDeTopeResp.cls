//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class WSAsociadoGetConsumoDeTopeResp {

	public class Data {
		@AuraEnabled public String pca_id {get;set;} 
		@AuraEnabled public String tipo {get;set;} 
		@AuraEnabled public String prestacion_grupo {get;set;} 
		@AuraEnabled public String nombre_prestacion {get;set;} 
		@AuraEnabled public String cantidad {get;set;} 
		@AuraEnabled public String honorarios {get;set;} 
		@AuraEnabled public String gastos {get;set;} 
		@AuraEnabled public String copago {get;set;} 
		@AuraEnabled public String fecha_prestacion {get;set;} 
		@AuraEnabled public String origen {get;set;} 
		@AuraEnabled public String es_modulo {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'pca_id') {
							pca_id = parser.getText();
						} else if (text == 'tipo') {
							tipo = parser.getText();
						} else if (text == 'prestacion_grupo') {
							prestacion_grupo = parser.getText();
						} else if (text == 'nombre_prestacion') {
							nombre_prestacion = parser.getText();
						} else if (text == 'cantidad') {
							cantidad = parser.getText();
						} else if (text == 'honorarios') {
							honorarios = parser.getText();
						} else if (text == 'gastos') {
							gastos = parser.getText();
						} else if (text == 'copago') {
							copago = parser.getText();
						} else if (text == 'fecha_prestacion') {
							fecha_prestacion = parser.getText();
						} else if (text == 'origen') {
							origen = parser.getText();
						} else if (text == 'es_modulo') {
							es_modulo = parser.getText();
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

	public WSAsociadoGetConsumoDeTopeResp(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'data') {
						data = arrayOfData(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'WSAsociadoGetConsumoDeTopeResp consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public static WSAsociadoGetConsumoDeTopeResp parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new WSAsociadoGetConsumoDeTopeResp(parser);
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
}