/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase deserializadora para las solicitudes de llamados a SS para Eventos Médicos.
@date			06/12/2021
------------------------------------------------------------------------------------------------------------------------*/
@SuppressWarnings('PMD.ExcessiveParameterList')
public with sharing class EventoMedicoEnviarASSParser {
	public Evento_medico__c eventoMedico {get; set;}
	public String userNick {get; set;}
	private String rTSeguimientoID = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_seguimiento').Id;
	private String rTInternacionID = XappiaHelper.getRecordType('Evento_medico__c', 'Evento_medico_de_internacion').Id;
	public EventoMedicoEnviarASSParser(Evento_medico__c eventoMedico, String userNick) {
		this.eventoMedico = eventoMedico;
		this.userNick = userNick;
	}
	public class EventoMedicoASS {
		public String em_id {get; set;}
		public String codigo_afiliado {get; set;}
		public String agencia_codigo {get; set;}
		public String fecha_inicio {get; set;}
		public String codigo_lugar {get; set;}
		public Integer consultorio {get; set;}
		public String responsable {get; set;}
		public String solicitante {get; set;}
		public String tipo_em {get; set;}
		public String subtipo_em {get; set;}
		public String recupero {get; set;}
		public String anestesia {get; set;}
		public String codigo_diagnostico {get; set;}
		public Integer nivel_complicacion {get; set;}
		public String codigo_prestacion {get; set;}
		public String descripcion {get; set;}
		public String observaciones {get; set;}
		public String suspendido {get; set;}
		public String usuario {get; set;}
		public String numero_sf {get; set;}
		public String chk_material {get; set;}
		public String chk_presupuesto {get; set;}
		public String importe_presupuesto {get; set;}
		public String forma_egreso {get; set;}
		public String fecha_vto_certificado {get; set;}
		public String mail {get; set;}
		public String dom_entrega {get; set;}
		public String agen_entrega {get; set;}
		public String otro_entrega {get; set;}
		public String resul {get; set;}
		public String via_entrega {get; set;}
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@company		Xappia
	@description	Método para entregar el body de la solicitud a la API para un evento médico.
	------------------------------------------------------------------------------------------------------------------------*/
	public String parseCargarEventoMedicoSS () {
		EventoMedicoASS solicitud = new EventoMedicoASS();
		try {
			Integer consultorio = this.eventoMedico.Consultorio__r.Secuencia__c != null ? Integer.valueOf(this.eventoMedico.Consultorio__r.Secuencia__c) : null;
			Integer complicaciones = this.eventoMedico.Sin_complicaciones__c != null ? Integer.valueOf(this.eventoMedico.Sin_complicaciones__c) : null;
			// Construcción de la solicitud
			solicitud.usuario = this.userNick;
			solicitud.numero_sf = this.eventoMedico.Id;
			solicitud.consultorio = consultorio;
			solicitud.nivel_complicacion = complicaciones;
			solicitud.em_id = this.eventoMedico.Nro_de_Evento_Medico_SS__c;
			solicitud.codigo_afiliado = this.eventoMedico.Asociado__r.Codigo_de_Afiliado__c;
			solicitud.fecha_inicio = this.eventoMedico.Fecha_y_Hora_inicio_EMS__c == null
										? null : this.eventoMedico.Fecha_y_Hora_inicio_EMS__c.format('dd/MM/yyyy');
			solicitud.tipo_em = this.eventoMedico.Tipo__c != null ? this.eventoMedico.Tipo__c.toUpperCase() : null;
			solicitud.codigo_diagnostico = this.eventoMedico.Diagnostico__r.Codigo_del_Diagnostico__c;
			solicitud.descripcion = this.eventoMedico.Descripcion__c;
			solicitud.observaciones = this.eventoMedico.Observaciones__c;
			solicitud.chk_presupuesto = this.eventoMedico.AP_presupuesto__c ? 'V' : 'F';
			solicitud.importe_presupuesto = this.eventoMedico.AP_presupuesto__c ? String.valueOf(this.eventoMedico.Importe_presupuesto__c) : '0';
			solicitud.agencia_codigo = this.eventoMedico.Delegacion__r.Codigo_de_delegacion__c;
			solicitud.solicitante = this.eventoMedico.Efector_Solicitante__r.Codigo_de_efector__c;
			solicitud.forma_egreso = this.eventoMedico.Forma_de_egreso__c;
			solicitud.codigo_lugar = this.eventoMedico.Prestador__r.Codigo_de_efector__c;
			if (this.eventoMedico.RecordTypeId == rTSeguimientoID) {
				solicitud.fecha_vto_certificado = this.eventoMedico.Fecha_de_Vencimiento_Certificado__c == null
				? null : this.eventoMedico.Fecha_de_Vencimiento_Certificado__c.format();
				solicitud.mail = this.eventoMedico.Mail__c;
				solicitud.dom_entrega = this.eventoMedico.Domicilio_Entrega__c;
				solicitud.agen_entrega = this.eventoMedico.Domicilio_Entrega__c == 'Agencia'
											? this.eventoMedico.Domicilio__c : null;
				solicitud.otro_entrega = this.eventoMedico.Domicilio_Entrega__c == 'Otros'
											? this.eventoMedico.Otro_domicilio__c : null;
				solicitud.via_entrega = this.eventoMedico.Via_Entrega__c;
				solicitud.resul = this.eventoMedico.Resultado__c;
			} else if (this.eventoMedico.RecordTypeId == rTInternacionID) {
				solicitud.responsable = this.eventoMedico.Responsable__r.Codigo_de_efector__c;
				solicitud.subtipo_em = this.eventoMedico.Subtipo__c != null ? this.eventoMedico.Subtipo__c.toUpperCase() : null;
				solicitud.recupero = this.eventoMedico.Recupero__c == 'V' ? 'V' : 'F';
				solicitud.anestesia = this.eventoMedico.Ap_Anestesia__c == 'V' ? 'S' : 'N';
				solicitud.codigo_prestacion = this.eventoMedico.Codigo_Nomenclador__r.Codigo__c;
				solicitud.suspendido = this.eventoMedico.Suspendido__c == 'Si' ? 'V' : 'F';
				solicitud.chk_material = this.eventoMedico.AP_material__c ? 'V' : 'F';
			}
		} catch (Exception err) {
			System.debug(err.getMessage());
		}
		return JSON.serialize(solicitud, true);
	}
}
