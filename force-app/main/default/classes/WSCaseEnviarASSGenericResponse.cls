/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase deserializadora para las respuestas  de llamados a SS.
@date			26/10/2021
------------------------------------------------------------------------------------------------------------------------*/
public class WSCaseEnviarASSGenericResponse {
	public Boolean error;
	public Integer httpCode;
	public String message;
	public List<Data> data;
	public Meta meta;
	/** Objeto Meta */
		public class Meta {
			public List<Notas> allowed_includes;
			public List<Notas> default_includes;
		}
	/** Objeto Notas */
		public class Notas {
			public String nota_id;
			public String texto_nota;
			public String sf_id;
		}
	/** Objeto Data */
		public class Data {
			public String sf_id;
			public String solafi_id;
			public String estado_sol;
			public String estado_dj;
			public String codigo_as;
			public String tipo_asoc;
			public String afi_id;
			public String empresa_codigo;
			public String suc_empresa;
			public List<Notas> notas;
			public Boolean error;
			public Errors errors;
		}
	/** Object Errors */ /**REVISAR */
		public class Errors {
			public String message;
			public Object debug_message;
		}
	/** Constructor */
	public WSCaseEnviarASSGenericResponse (String json) {
		WSCaseEnviarASSGenericResponse response = parse(json);
		this.error = response?.error;
		this.httpCode = response?.httpCode;
		this.message = response?.message;
		this.data = response?.data;
		this.meta = response?.meta;
	}
	/** Métodos */
	public static WSCaseEnviarASSGenericResponse parse(String json) {
		return (WSCaseEnviarASSGenericResponse) System.JSON.deserialize(json, WSCaseEnviarASSGenericResponse.class);
	}
	/**
	 * Revisar este construcción, por ahora se deja así en lo que se tiene un ejemplo de un mensaje con errores.
	 */
	public String processMessage(String responseBody) {
        Map<String,Object> body = (Map<String,Object>) JSON.deserializeUntyped(responseBody);
        Map<String,Object> data = (Map<String,Object>) body.get('data');
        Map<String,Object> errors;
        try {
            errors = (Map<String,Object>) data.get('errors');
        } catch (Exception e) {
            errors = new Map<String,Object>();
        }
        String message = '';
        if(data.get('httpCode') == 500){
            if(!errors.isEmpty()) {
                message = errors.get('message').toString();
            } else {
                message = data.get('message').toString();
            }
        }
        else{
            message = UtilsDisplayErrorMessageFromWS.showErrorMessage(body).replaceAll('familiar.0.', '').replaceAll('encabezado.0.', '');
        }
        return message;
    }
}