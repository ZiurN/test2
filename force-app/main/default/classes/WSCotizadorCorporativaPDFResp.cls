//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//
public class WSCotizadorCorporativaPDFResp {


	public Boolean error {get;set;} 
	public Data data {get;set;} 
	public Integer httpCode {get;set;} 
	public String message {get;set;} 

	public WSCotizadorCorporativaPDFResp(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'error') {
						error = parser.getBooleanValue();
					} else if (text == 'data') {
						data = new Data(parser);
					} else if (text == 'httpCode') {
						httpCode = parser.getIntegerValue();
					} else if (text == 'message') {
						message = parser.getText();
					} else {
						//System.debug(LoggingLevel.WARN, 'WSCotizadorCorporativaPDFResp consuming unrecognized property: '+text);
						//consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Data {
		public String base64 {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'base64') {
							base64 = parser.getText();
						} else {
							//System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							//consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static WSCotizadorCorporativaPDFResp parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new WSCotizadorCorporativaPDFResp(parser);
	}
	
	//public static void consumeObject(System.JSONParser parser) {
		//Integer depth = 0;
		//do {
			//System.JSONToken curr = parser.getCurrentToken();
			//if (curr == System.JSONToken.START_OBJECT || 
				//curr == System.JSONToken.START_ARRAY) {
				//depth++;
			//} else if (curr == System.JSONToken.END_OBJECT ||
				//curr == System.JSONToken.END_ARRAY) {
				//depth--;
			//}
		//} while (depth > 0 && parser.nextToken() != null);
	//}
	

}