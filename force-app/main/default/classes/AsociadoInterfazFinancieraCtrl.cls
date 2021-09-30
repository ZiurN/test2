public with sharing class AsociadoInterfazFinancieraCtrl  {
	
	@AuraEnabled
	public static Response getInterfazFinanciera(String codigoDeEntidad){

		Response resp = new Response();
		
		WSAsociadoGetInterfazFinanciera.Response WSResponse = 
			WSAsociadoGetInterfazFinanciera.getInterfazFinanciera(codigoDeEntidad);

		if(WSResponse.hasError){
			resp.hasError = true;
			resp.message = 'Hubo un error al intentar obtener la interfaz financiera desde SaludSoft';
			return resp;
		}
        
		if(WSResponse.interfazFinanciera.data.size() == 0) {
			resp.hasError = false;
			resp.message = 'No se encontraron datos de la interfaz financiera en SaludSoft';
			return resp;
		}
		// Serealizo para obtener la respuesta JSON en un objeto y 
		// deserializo para convertirlo en la forma 'String, Object'. 
		// Será utilizado las keys para la creación de las secciones
		String fieldsResponse = JSON.serialize(WSResponse.interfazFinanciera.data[0]);
		Map<String, Object> fieldsResponseMap;
        fieldsResponseMap = (Map<String, Object>)JSON.deserializeUntyped(fieldsResponse);

		// Creación de secciones
		for (String APINameFieldsFromWS : fieldsResponseMap.keySet()) {
			
			// Los condicionales evaluan a el los campos que se reciben del servicio contra la clase CreateSections
			// para separarlos según a la sección que pertenencan

			if (resp.sectionsMaps.gananciasFieldsByApiName.containsKey(APINameFieldsFromWS)) {
				resp.sectionsMaps.gananciasFieldsByApiName.get(APINameFieldsFromWS).value = fieldsResponseMap.get(APINameFieldsFromWS);
				//Lista es utilizada para poder utilizar lightning:iterator en el componente
				resp.gananciasSection.add(resp.sectionsMaps.gananciasFieldsByApiName.get(APINameFieldsFromWS));
			} else if (resp.sectionsMaps.ivaFieldsByApiName.containsKey(APINameFieldsFromWS)) {
				resp.sectionsMaps.ivaFieldsByApiName.get(APINameFieldsFromWS).value = fieldsResponseMap.get(APINameFieldsFromWS);
				//Lista es utilizada para poder utilizar lightning:iterator en el componente
				resp.ivaSection.add(resp.sectionsMaps.ivaFieldsByApiName.get(APINameFieldsFromWS));
			} else if (resp.sectionsMaps.iibbFieldsByApiName.containsKey(APINameFieldsFromWS)) {
				resp.sectionsMaps.iibbFieldsByApiName.get(APINameFieldsFromWS).value = fieldsResponseMap.get(APINameFieldsFromWS);
				//Lista es utilizada para poder utilizar lightning:iterator en el componente
				resp.iibbSection.add(resp.sectionsMaps.iibbFieldsByApiName.get(APINameFieldsFromWS));
			} else if (resp.sectionsMaps.comprobanteFieldsByApiName.containsKey(APINameFieldsFromWS)) {
				resp.sectionsMaps.comprobanteFieldsByApiName.get(APINameFieldsFromWS).value = fieldsResponseMap.get(APINameFieldsFromWS);
				//Lista es utilizada para poder utilizar lightning:iterator en el componente
				resp.comprobanteSection.add(resp.sectionsMaps.comprobanteFieldsByApiName.get(APINameFieldsFromWS));
			} else if (resp.sectionsMaps.clienteFieldsByApiName.containsKey(APINameFieldsFromWS)) {
				resp.sectionsMaps.clienteFieldsByApiName.get(APINameFieldsFromWS).value = fieldsResponseMap.get(APINameFieldsFromWS);
				//Lista es utilizada para poder utilizar lightning:iterator en el componente
				resp.clienteSection.add(resp.sectionsMaps.clienteFieldsByApiName.get(APINameFieldsFromWS));
			} else if (resp.sectionsMaps.proveedorFieldsByApiName.containsKey(APINameFieldsFromWS)) {
				resp.sectionsMaps.proveedorFieldsByApiName.get(APINameFieldsFromWS).value = fieldsResponseMap.get(APINameFieldsFromWS);
				//Lista es utilizada para poder utilizar lightning:iterator en el componente
				resp.proveedorSection.add(resp.sectionsMaps.proveedorFieldsByApiName.get(APINameFieldsFromWS));
			} else if (resp.sectionsMaps.otrosFieldsByApiName.containsKey(APINameFieldsFromWS)) {
				resp.sectionsMaps.otrosFieldsByApiName.get(APINameFieldsFromWS).value = fieldsResponseMap.get(APINameFieldsFromWS);
				//Lista es utilizada para poder utilizar lightning:iterator en el componente
				resp.otrosSection.add(resp.sectionsMaps.otrosFieldsByApiName.get(APINameFieldsFromWS));
			}
		}

		resp.interfazFinanciera = WSResponse.interfazFinanciera.data[0];

		return resp;
	}

	public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;
		@AuraEnabled public CreateSections sectionsMaps;
		@AuraEnabled public WSAsociadoGetInterfazFinancieraResp.Data interfazFinanciera;
		@AuraEnabled public List<Field> gananciasSection;
		@AuraEnabled public List<Field> ivaSection;
		@AuraEnabled public List<Field> iibbSection;
		@AuraEnabled public List<Field> proveedorSection;
		@AuraEnabled public List<Field> comprobanteSection;
		@AuraEnabled public List<Field> clienteSection;
		@AuraEnabled public List<Field> otrosSection;

		public Response() {
			this.hasError = false;
			this.message = null;
			this.interfazFinanciera = null;
			this.sectionsMaps = new CreateSections();
			this.gananciasSection = new List<Field>();
			this.ivaSection = new List<Field>();
			this.iibbSection = new List<Field>();
			this.proveedorSection = new List<Field>();
			this.comprobanteSection = new List<Field>();
			this.clienteSection = new List<Field>();
			this.otrosSection = new List<Field>();
		} 
	}


	// Clase creado con los campos de las secciones a mostrar en el componente Interfaz Financiera
	public class CreateSections {
		@AuraEnabled public Map<String, Field> gananciasFieldsByApiName;
		@AuraEnabled public Map<String, Field> ivaFieldsByApiName;
		@AuraEnabled public Map<String, Field> iibbFieldsByApiName;
		@AuraEnabled public Map<String, Field> comprobanteFieldsByApiName;
		@AuraEnabled public Map<String, Field> clienteFieldsByApiName;
		@AuraEnabled public Map<String, Field> proveedorFieldsByApiName;
		@AuraEnabled public Map<String, Field> otrosFieldsByApiName;

		public CreateSections(){
			this.gananciasFieldsByApiName = new Map<String, Field>{
				'regimen_ganancias' => new Field('Regimen'),
				'inscripto_ganancias' => new Field('Inscripto'), 
				'agente_retencion_ganancias'=> new Field('Agente Retención'),
				'porcentaje_exencion_ganancias'=> new Field('Porcentaje Exención'),
				'codigo_exencion_ganancias'=> new Field('Código Exención'),
				'resolucion_exencion_ganancias'=> new Field('Resolución exención'),
				'fecha_desde_exencion_ganancias'=> new Field('Fecha desde exención'),
				'fecha_hasta_exencion_ganancias'=> new Field('Fecha hasta exención')
			};
			this.ivaFieldsByApiName = new Map<String, Field>{
			      'codigo_condicion_iva' => new Field('Código Condición'),
				  'descripcion_condicion_iva' => new Field('Descripción Condición'),
				  'agente_retencion_iva' => new Field('Agente Retención'),
				  'descripcion_regimen_iva' => new Field('Descripción Regimen'),
				  'comprobante_iva' => new Field('Comprobante'),
				  'porcentaje_exencion_iva' => new Field('Porcentaje Exención'),
				  'resolucion_exencion_iva' => new Field('Resolución Exención'),
				  'fecha_desde_exencion_iva' => new Field('Fecha desde Exención'),
				  'fecha_hasta_exencion_iva' => new Field('Fecha hasta Exención')
			};
			this.iibbFieldsByApiName = new Map<String, Field>{
				  'regimen_ib' => new Field('Regimen'),
				  'convenio_ib' => new Field('Convenio'),
				  'numero_ib' => new Field('Número'),
				  'fecha_vigencia_ib' => new Field('Fecha vigencia'),
				  'provincia_ib' => new Field('Provincia'),
				  'agente_retencion_ib' => new Field('Agente Retención')
			};
			this.comprobanteFieldsByApiName = new Map<String, Field>{
				  'cuit_cuil_cpte' => new Field('CUIT/CUIL'),
				  'presenta_cpte' => new Field('PresentaL'),
				  'tipo_cuit_cpte' => new Field('Tipo de CUIT'),
				  'anses_codigo_cpte' => new Field('ANSES código'),
				  'entidad' => new Field('Entidad')
			};
			this.clienteFieldsByApiName = new Map<String, Field>{
				  'descripcion_mco_clientes' => new Field('Medio', 3),
				  'nro_mco_clientes' => new Field('Número', 4),
				  'tipo_doc_mco_clientes' => new Field('Tipo documento', 1),
				  'nro_doc_mco_clientes' => new Field('Número documento', 2),
				  'banco_mco_clientes'=> new Field('Banco', 5),
				  'sucursal_mco_clientes' => new Field('Sucursal', 6),
				  'moneda_mco_clientes' => new Field('Moneda', 7)
			};
			this.proveedorFieldsByApiName = new Map<String, Field>{
				  'banco_prov' => new Field('Banco', 4),
				  'banco_sucursal_prov' => new Field('Banco sucursal', 5),
				  'banco_moneda_prov' => new Field('Banco moneda', 8),
				  'banco_tipo_cta_prov' => new Field('Banco tipo de cuenta', 6),
				  'banco_cuenta_prov' => new Field('Banco cuenta', 7),
				  'cbu_prov' => new Field('CBU', 1),
				  'orden_cheque_prov' => new Field('Orden cheque', 0),
				  'mpa_codigo' => new Field('MPA código', 2),
				  'medio_pago' => new Field('MPA descripción', 3)
			};
			this.otrosFieldsByApiName = new Map<String, Field>{
				  'personeria_otros'=> new Field('Personeria'),
				  'motivo_inhab_otros'=> new Field('Motivo Inhab'),
				  'fecha_inicio_otros'=> new Field('Fecha Inicio'),
				  'nombre_empresa_otros'=> new Field('Nombre Empresa'),
				  'alias_otros'=> new Field('Alias')
			};
		}	
	}

	public class Field {
		@AuraEnabled public String label {get; set;}
		@AuraEnabled public Object value {get; set;}
		@AuraEnabled public Integer order {get; set;}

		public Field(String label) {
			this.label = label;
		}

		public Field(String label, Integer order) {
			this.label = label;
			this.order = order;
		}
	}
}