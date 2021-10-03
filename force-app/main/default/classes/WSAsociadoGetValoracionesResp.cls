public class WSAsociadoGetValoracionesResp {

	public String message {get;set;} 
	public List<Data> data {get;set;} 

	public WSAsociadoGetValoracionesResp(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'message') {
						message = parser.getText();
					} else if (text == 'data') {
						data = arrayOfData(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'WSAsociadoGetValoracionesResp consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Data {
		@AuraEnabled public String Tcc_Codigo {get;set;} 
		@AuraEnabled public String Importe {get;set;} 
		@AuraEnabled public String Cantidad {get;set;} 
		@AuraEnabled public String Coeficiente {get;set;} 
		@AuraEnabled public String Coeficiente_General {get;set;} 
		@AuraEnabled public String Cga_Codigo {get;set;} 
		@AuraEnabled public String Rcg_Codigo {get;set;} 
		public String Dca_Dca_Id {get;set;} 
		public String Dca_Dca_Id_Ajuste {get;set;} 
		@AuraEnabled public String Nombre_Clausula {get;set;} 
		@AuraEnabled public String Nombre_Cat_Grupal {get;set;} 
		@AuraEnabled public String Nombre_Regla_Adic {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Tcc_Codigo') {
							Tcc_Codigo = parser.getText();
						} else if (text == 'Importe') {
							Importe = parser.getText();
						} else if (text == 'Cantidad') {
							Cantidad = parser.getText();
						} else if (text == 'Coeficiente') {
							Coeficiente = parser.getText();
						} else if (text == 'Coeficiente_General') {
							Coeficiente_General = parser.getText();
						} else if (text == 'Cga_Codigo') {
							Cga_Codigo = parser.getText();
						} else if (text == 'Rcg_Codigo') {
							Rcg_Codigo = parser.getText();
						} else if (text == 'Dca_Dca_Id') {
							Dca_Dca_Id = parser.getText();
						} else if (text == 'Dca_Dca_Id_Ajuste') {
							Dca_Dca_Id_Ajuste = parser.getText();
						} else if (text == 'Nombre_Clausula') {
							Nombre_Clausula = parser.getText();
						} else if (text == 'Nombre_Cat_Grupal') {
							Nombre_Cat_Grupal = parser.getText();
						} else if (text == 'Nombre_Regla_Adic') {
							Nombre_Regla_Adic = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public static WSAsociadoGetValoracionesResp parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new WSAsociadoGetValoracionesResp(parser);
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