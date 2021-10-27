/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase deserializadora para los llamados a SS.
@date			26/10/2021
------------------------------------------------------------------------------------------------------------------------*/
public with sharing class Parser {
/** Solicitud De Despegue */
	public class SolicitudDespegue {
		public List<Notas> notas {get;set;}
		public List<Archivos> archivos {get;set;}
		public List<Encabezado> encabezado {get;set;}
		public List<Familiares> familiares {get;set;}
	}
	/** Encabezado */
		public class Encabezado {
			public String parentesco {get;set;}
			public String codigo_afi_titular {get;set;}
			public String codigo_afi_a_familiar {get;set;}
			public String importe_aportes {get;set;}
			public String nombre_empleador {get;set;}
			public String cuit_empleador {get;set;}
			public String cuit {get;set;}
			public String civa_codigo {get;set;}
			public String codigo_empleador {get;set;}
			public String email {get;set;}
			public String tel_numero {get;set;}
			public String deriva_aportes {get;set;}
			public String tel_tipo {get;set;}
			public String aa_codigo {get;set;}
			public String aa3_codigo {get;set;}
			public String aa2_codigo {get;set;}
			public String aa1_codigo {get;set;}
			public String codigo_plan {get;set;}
			public String codigo_obrasocial {get;set;}
			public String tipo_despegue {get;set;}
			public String bebe_sin_doc {get;set;}
			public String usuario {get;set;}
			public String agencia_codigo {get;set;}
			public String fecha_vigencia {get;set;}
			public String sf_id {get;set;}
			// Para interfaz financiera
			public String estado_dj {get;set;}
			public String solicitud_id {get;set;}
			public String afi_codigo {get;set;}
			public String tipo_if {get;set;}
		}
	/** Notas */
		public class Notas {
			public String usuario_nota {get;set;}
			public String texto {get;set;}
			public String sf_id {get;set;}
		}
	/** Archivos */
		public class Archivos {
			public String nombre {get;set;}
			public Object descripcion {get;set;}
			public Object observaciones {get;set;}
			public String datos {get;set;}
		}
	}
