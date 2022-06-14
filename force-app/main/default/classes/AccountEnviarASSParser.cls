/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase deserializadora para las solicitudes de llamados a SS.
@date			07/06/2022
------------------------------------------------------------------------------------------------------------------------*/
public with sharing class AccountEnviarASSParser {
	public Account cuenta {get; set;}
	public AccountEnviarASSParser (Account cuenta) {
		this.cuenta = cuenta;
	}
	public class SolicitudSS {
		public String afi_id {get; set;}
		public String email {get; set;}
		public String doc_tipo {get; set;}
		public String doc_numero {get; set;}
		public String cuit {get; set;}
		public List<Domicilio> domicilio {get; set;}
		public List<Telefono> telefono {get; set;}
	}
	/** Domicilio */
		public class Domicilio {
			public String id {get; set;}
			public String tipo {get; set;}
			public String localidad_id {get; set;}
			public String calle {get; set;}
			public String numero {get; set;}
			public String piso {get; set;}
			public String dpto {get; set;}
			public String borrar {get; set;}
		}
	/** Teléfono */
		public class Telefono {
			public String id {get; set;}
			public String tipo {get; set;}
			public String numero {get; set;}
			public String borrar {get; set;}
		}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@company		Xappia
	@description	Método para entregar el body de la solicitud a la API para validar el email.
	------------------------------------------------------------------------------------------------------------------------*/
	public String parseRequesBody (Boolean emailHasChanged, Boolean documentHasChanged) {
		SolicitudSS solicitud;
		try {
			solicitud = new SolicitudSS();
			solicitud.afi_id = cuenta.Afi_Id__c;
			if (emailHasChanged) solicitud.email = String.isBlank(cuenta.PersonEmail) ? '' : cuenta.PersonEmail;
			if (documentHasChanged) {
				solicitud.doc_tipo = String.isBlank(cuenta.Tipo_de_documento__c) ? '' : cuenta.Tipo_de_documento__c;
				solicitud.doc_numero = String.isBlank(cuenta.Numero_de_documento__c) ? '' : cuenta.Numero_de_documento__c;
				solicitud.cuit = String.isBlank(cuenta.CUIT__c) ? '' : cuenta.CUIT__c;
			}
		} catch (Exception err) {
			System.debug(err.getMessage());
		}
		if (solicitud == null) {return null;}
		else {return JSON.serialize(solicitud, true);}
	}
}
