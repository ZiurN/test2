public class OpportunitySolicitudData  {
	public String sf_id {get;set;} 
	public String solafi_id {get;set;} 
	public String estado_sol {get;set;} 
	public String estado_dj {get;set;} 
	public String codigo_as {get;set;} 
	public String tipo_asoc {get;set;} 
	public String empresa_codigo {get;set;}
	public List<Notas> notas {get;set;} 

	public OpportunitySolicitudData(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'sf_id') {
						sf_id = parser.getText();
					} else if (text == 'solafi_id') {
						solafi_id = parser.getText();
					} else if (text == 'estado_sol') {
						estado_sol = parser.getText();
					} else if (text == 'estado_dj') {
						estado_dj = parser.getText();
					} else if (text == 'codigo_as') {
						codigo_as = parser.getText();
					} else if (text == 'tipo_asoc') {
						tipo_asoc = parser.getText();
					} else if (text == 'empresa_codigo') {
						empresa_codigo = parser.getText();
					} else if (text == 'notas') {
						notas = arrayOfNotas(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}

	public class Notas  {

		public String nota_id {get;set;}
		public String sf_id {get;set;} 
		public String texto_nota {get;set;} 

		public Notas(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'nota_id') {
							nota_id = parser.getText();
						} else if (text == 'sf_id') {
							sf_id = parser.getText();
						} else if (text == 'texto_nota') {
							texto_nota = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Notas consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

    private static List<Notas> arrayOfNotas(System.JSONParser p) {
        List<Notas> res = new List<Notas>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Notas(p));
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
}