/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase deserializadora para las solicitudes de llamados a SS.
@date			26/10/2021
------------------------------------------------------------------------------------------------------------------------*/
@SuppressWarnings('PMD.ExcessiveParameterList')
public with sharing class Parser {
	public Case caso {get; set;}
	public String userNick {get; set;}
	public List<ContentVersion> files {get; set;}
	public List<Nota_de_Auditoria__c> notas {get; set;}
	public List<Integrante_caso__c> integrantes {get; set;}
	public User usuario {get; set;}
	/** Constructors */
	public Parser (Case caso,
					String userNick,
					User usuario) {
		this.caso = caso;
		this.userNick = userNick;
		this.usuario = usuario;
	}
	public Parser (Case caso,
					String userNick,
					List<ContentVersion> files,
					List<Nota_de_Auditoria__c> notas,
					User usuario) {
		this.caso = caso;
		this.userNick = userNick;
		this.files = files;
		this.notas = notas;
		this.usuario = usuario;
	}
	public Parser (Case caso,
					String userNick,
					List<ContentVersion> files,
					List<Nota_de_Auditoria__c> notas,
					List<Integrante_caso__c> integrantes,
					User usuario) {
		this.caso = caso;
		this.userNick = userNick;
		this.files = files;
		this.notas = notas;
		this.usuario = usuario;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
 	@author			Jeferson Ruiz
 	@company		Xappia
	@description	Deserializador para solicitudes de SS.
	------------------------------------------------------------------------------------------------------------------------*/
		public class SolicitudSS {
			public List<Notas> notas {get;set;}
			public List<Archivos> archivos {get;set;}
			public List<Encabezado> encabezado {get;set;}
			public List<Familiar> familiares {get;set;}
			public List<Familiar> familiar {get;set;}
			public List<Solicitudes> solicitudes {get;set;}
		}
		/** Encabezado */
			public class Encabezado {
				public String aa_codigo {get;set;}
				public String aa1_codigo {get;set;}
				public String aa2_codigo {get;set;}
				public String aa3_codigo {get;set;}
				public String acti_codigo {get;set;}
				public String afi_codigo {get;set;}
				public String afi_tipo {get;set;}
				public String agencia_codigo {get;set;}
				public String agencia_destino {get;set;}
				public String apellido {get;set;}
				public String apellidos {get;set;}
				public String asoc_inmediata {get;set;}
				public String bebe_sin_doc {get;set;}
				public String cbu_reintegros {get;set;}
				public String civa_codigo {get;set;}
				public String cobro_medio {get;set;}
				public String cobro_numero {get;set;}
				public String codigo_afi_a_familiar {get;set;}
				public String codigo_afi_a_titular {get;set;}
				public String codigo_afi_titular {get;set;}
				public String codigo_empleador {get;set;}
				public String codigo_obrasocial {get;set;}
				public String codigo_obrasocial_ant {get;set;}
				public String codigo_plan {get;set;}
				public String cuit {get;set;}
				public String cuil_cbu {get;set;}
				public String cuit_empleador {get;set;}
				public String deriva_aportes {get;set;}
				public String doc_numero {get;set;}
				public String doc_tipo {get;set;}
				public String dom_calle {get;set;}
				public String dom_dpto {get;set;}
				public String dom_numero {get;set;}
				public String dom_piso {get;set;}
				public String e_civil {get;set;}
				public String email {get;set;}
				public String emergencia {get;set;}
				public String estado_dj {get;set;}
				public String fecha_nac {get;set;}
				public String fecha_vigencia {get;set;}
				public String importe_aportes {get;set;}
				public String localidad {get;set;}
				public String nacionalidad {get;set;}
				public String nombre_empleador {get;set;}
				public String nombres {get;set;}
				public String nuevo_segmento {get;set;}
				public String parentesco {get;set;}
				public String referente_id {get;set;}
				public String referido {get;set;}
				public String sexo {get;set;}
				public String sf_id {get;set;}
				public String solicitud_id {get;set;}
				public String subtipo {get;set;}
				public String tel_elimina {get;set;}
				public String tel_numero {get;set;}
				public String tel_tipo {get;set;}
				public String tipo_despegue {get;set;}
				public String tipo_if {get;set;}
				public String tipo_solicitud {get;set;}
				public String usuario {get;set;}
			}
		/** Notas */
			public class Notas {
				public String sf_id {get;set;}
				public String texto {get;set;}
				public String usuario_nota {get;set;}
			}
		/** Archivos */
			public class Archivos {
				public String descripcion {get;set;}
				public String observaciones {get;set;}
				public String datos {get;set;}
				public String nombre {get;set;}
			}
		/** Familiares */
			public class Familiar {
				public String sf_id {get;set;}
				public String codigo_afi_titular {get;set;}
				public String apellido {get;set;}
				public String nombres {get;set;}
				public String doc_tipo {get;set;}
				public String doc_numero {get;set;}
				public String e_civil {get;set;}
				public String codigo_obrasocial {get;set;}
				public String sexo {get;set;}
				public String discapacitado {get;set;}
				public String fecha_nac {get;set;}
				public String nacionalidad {get;set;}
				public String parentesco {get;set;}
				public String deriva_aportes {get;set;}
				public String importe_aportes {get;set;}
				public String cuit_empleador {get;set;}
				public String nombre_empleador {get;set;}
				public String codigo_empleador {get;set;}
				public String cuit {get;set;}
			}
		/** Solicitudes */
			public class Solicitudes {
				public String sf_id {get;set;}
				public String solicitud_id {get;set;}
				public String codigo_afi {get;set;}
				public String tipo_asociado {get;set;}
				public String motivo_baja {get;set;}
				public List<Notas> notas {get;set;}
			}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@company		Xappia
	@description	Método para entregar el body de la solicitud a la API para una solicitud de alta.
	------------------------------------------------------------------------------------------------------------------------*/
	public String parseAltaBody () {
		SolicitudSS solicitud = new SolicitudSS();
		try {
			Encabezado encabezado = new Encabezado();
				encabezado.sf_id = getValueOf(this.caso.Id);
				encabezado.fecha_vigencia = formatDate(this.caso.Fecha_de_vigencia__c);
				encabezado.agencia_codigo = this.usuario.Codigo_delegacion__c;
				encabezado.usuario = getValueOf(this.userNick);
				encabezado.bebe_sin_doc = (this.caso.Bebe_sin_DNI__c != null) ? (this.caso.Bebe_sin_DNI__c) ? 'V' : 'F' : '';
				if(!String.isBlank(this.caso.Nro_de_solicitud_SS__c)) {
					encabezado.solicitud_id = this.caso.Nro_de_solicitud_SS__c;
					encabezado.estado_dj = this.caso.Estado_DDJJ__c;
				}
			solicitud.encabezado = new List<Encabezado>{encabezado};
			Familiar familiar = new Familiar();
				familiar.codigo_afi_titular = (!String.isBlank(this.caso.Account.Codigo_de_Afiliado__c))
												? getValueOf(this.caso.Account.Codigo_de_Afiliado__c) : '';
				familiar.apellido = getValueOf(this.caso.Apellido__c);
				familiar.nombres =  getValueOf(this.caso.Nombre__c);
				familiar.doc_tipo = getValueOf(this.caso.Tipo_dni__c);
				familiar.doc_numero = getValueOf(this.caso.DNI__c);
				familiar.e_civil = getValueOf(this.caso.Estado_civil__c);
				familiar.codigo_obrasocial = (!String.isBlank(this.caso.Obra_social2__c)) ? this.caso.Obra_social2__r.Codigo_de_obra_social__c : '' ;
				familiar.sexo = (!String.isBlank(this.caso.Sexo__c)) ? this.caso.Sexo__c.left(1).toUppercase() : '';
				familiar.discapacitado = this.caso.Discapacidad__c ? 'V' : 'F';
				familiar.fecha_nac = formatDate(this.caso.Fecha_de_nacimiento__c);
				familiar.nacionalidad = getValueOf(this.caso.Nacionalidad__c);
				familiar.parentesco = getValueOf(this.caso.Tipo_de_parentesco__c);
				familiar.deriva_aportes = this.caso.Deriva_aportes__c ? 'V' : 'F';
				if(this.caso.Deriva_aportes__c) {
					familiar.cuit = getValueOf(this.caso.Cuit__c);
					familiar.importe_aportes = getValueOf(this.caso.Aporte__c);
					familiar.cuit_empleador = (!String.isBlank(this.caso.Empleador__c))
												? this.caso.Empleador__r.Cuit__c
												: (!String.isBlank(this.caso.Cuit_empleador__c)) ? this.caso.Cuit_empleador__c : '';
					familiar.nombre_empleador = (!String.isBlank(this.caso.Empleador__c))
												? this.caso.Empleador__r.Name
												: (!String.isBlank(this.caso.Razon_social__c)) ? this.caso.Razon_social__c : '';
					familiar.codigo_empleador = (!String.isBlank(this.caso.Empleador__c)) ? this.caso.Empleador__r.Codigo_de_empresa__c : '';
				}
			solicitud.familiar = new List<Familiar>{familiar};
			solicitud.archivos = parseFiles();
			solicitud.notas = parseNotas();
		} catch (Exception err) {
			System.debug(err.getMessage());
		}
		return JSON.serialize(solicitud, true);
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@company		Xappia
	@description	Método para entregar el body de la solicitud a la API para una solicitud de Despegue.
	------------------------------------------------------------------------------------------------------------------------*/
	public String parseDespegueBody () {
		SolicitudSS solicitud = new SolicitudSS();
		try {
			Encabezado encabezado = new Encabezado();
				encabezado.sf_id = getValueOf(this.caso.Id);
				encabezado.fecha_vigencia = formatDate(this.caso.Fecha_de_vigencia__c);
				encabezado.agencia_codigo = this.usuario.Codigo_delegacion__c;
				encabezado.usuario = getValueOf(this.userNick);
				encabezado.bebe_sin_doc = (this.caso.Bebe_sin_DNI__c != null) ? (this.caso.Bebe_sin_DNI__c) ? 'V' : 'F' : '';
				encabezado.tipo_despegue = getValueOf(this.caso.Type);
				encabezado.codigo_obrasocial = (!String.isBlank(this.caso.Obra_social2__c)) ? this.caso.Obra_social2__r.Codigo_de_obra_social__c : '';
				encabezado.codigo_plan = getValueOf(this.caso.Plandespegue__c);
				encabezado.aa1_codigo = getValueOf(this.caso.Agrupacion1__c);
				encabezado.aa2_codigo = getValueOf(this.caso.Medio_de_cobro__c);
				encabezado.aa3_codigo = getValueOf(this.caso.Agrupacion3__c);
				encabezado.aa_codigo = getValueOf(this.caso.Segmento_de_grupo_familiar__c);
				encabezado.tel_tipo = 'TEL';
				encabezado.deriva_aportes = ((this.caso.Type == 'FT' || this.caso.Type == 'CT')
											&& this.caso.Segmento_de_grupo_familiar__c.startsWith('OBL'))
												? 'V' : (this.caso.deriva_aportes__c) ? 'V' : 'F';
				encabezado.tel_numero = getValueOf(this.caso.Telefono__c);
				encabezado.email = getValueOf(this.caso.SuppliedEmail);
				encabezado.codigo_empleador = (!String.isBlank(this.caso.Empleador__c)) ? this.caso.Empleador__r.Codigo_de_empresa__c : '';
				encabezado.civa_codigo = XappiaHelper.stringToNumericString(String.valueOf(getValueOf(this.caso.Condicion_IVA__c)));
				Boolean derivaAportes = ((this.caso.Type == 'FT' || this.caso.Type == 'CT')
											&& this.caso.Segmento_de_grupo_familiar__c.startsWith('OBL'))
										|| (this.caso.deriva_aportes__c);
				String civacodigo = XappiaHelper.stringToNumericString(String.valueOf(getValueOf(this.caso.Condicion_IVA__c)));
				if(civacodigo == '1' || civacodigo == '4' || derivaAportes) {
					encabezado.cuit = this.caso.Cuil__c;
				}
				if(derivaAportes) {
					encabezado.cuit_empleador = (!String.isBlank(this.caso.Empleador__c))
												? this.caso.Empleador__r.Cuit__c
													: (!String.isBlank(this.caso.Cuit_empleador__c))
														? this.caso.Cuit_empleador__c : '';
					encabezado.nombre_empleador = (!String.isBlank(this.caso.Empleador__c))
												? this.caso.Empleador__r.Name
													: (!String.isBlank(this.caso.Razon_social__c))
														? this.caso.Razon_social__c : '';
					encabezado.importe_aportes = getValueOf(this.caso.Aporte__c);
				}
				switch on this.caso.Type {
					when 'FT', 'CT' {
						encabezado.codigo_afi_a_titular = (!String.isBlank(this.caso.Account.Codigo_de_Afiliado__c))
															? getValueOf(this.caso.Account.Codigo_de_Afiliado__c) : '';
						encabezado.localidad = (!String.isBlank(this.caso.Localidad__c)) ? getValueOf(this.caso.Localidad__r.Loc_id__c) : '';
						encabezado.dom_calle = getValueOf(this.caso.Calle__c);
						encabezado.dom_numero = getValueOf(this.caso.numero__c);
						encabezado.dom_piso = getValueOf(this.caso.piso__c);
						encabezado.dom_dpto = getValueOf(this.caso.dpto__c);
					}
					when 'FF', 'TF' {
						encabezado.codigo_afi_a_familiar = getValueOf(this.caso.Account.Codigo_de_Afiliado__c);
						encabezado.codigo_afi_titular = (!String.isBlank(this.caso.Titular__c)) ? getValueOf(this.caso.Titular__r.Codigo_de_Afiliado__c) : '';
						encabezado.parentesco = getValueOf(this.caso.Tipo_de_parentesco__c);
					}
				}
				if(!String.isBlank(this.caso.Nro_de_solicitud_SS__c)) {
					encabezado.solicitud_id = this.caso.Nro_de_solicitud_SS__c;
					encabezado.estado_dj = this.caso.Estado_DDJJ__c;
				}
				if(this.caso.Medio_de_cobro__c == 'CBUVOL') {
					encabezado.cobro_medio = this.caso.Tipo_CBU__c;
					encabezado.cobro_numero = this.caso.Numero_CBU_cobro_de_cuota__c;
					encabezado.cuil_cbu = this.caso.CUIL_del_CBU__c;
				} else if(this.caso.Medio_de_cobro__c == 'DEBAUT') {
					encabezado.cobro_medio = (this.caso.Tarjeta_de_credito__c != null)
												? this.caso.Tarjeta_de_credito__c : this.caso.Tipo_de_debito_por_ACA__c;
					encabezado.cobro_numero = (!String.isBlank(this.caso.Numero_de_tarjeta_de_credito__c))
												? this.caso.Numero_de_tarjeta_de_credito__c : this.caso.Cdigo_debito_por_ACA__c;
				}
			solicitud.encabezado = new List<Encabezado>{encabezado};
			List<Familiar> familiares =  new List<Familiar>();
			for(Integrante_caso__c integrante : this.integrantes) {
				Familiar familiar = new Familiar();
					familiar.sf_id = integrante.Id;
					familiar.parentesco = integrante.Tipo_de_relacion_con_titular__c;
					familiar.apellido = integrante.Apellido__c;
					familiar.nombres = integrante.Nombre__c;
					familiar.doc_tipo = integrante.Tipo_de_Documento__c;
					familiar.doc_numero = integrante.Nro_de_documento__c;
					familiar.codigo_obrasocial = (String.isBlank(integrante.Obra_social_actual__c))
												? integrante.Obra_social_actual__r.Codigo_de_obra_social__c : '';
					familiar.e_civil = integrante.Estado_Civil__c;
					familiar.sexo = integrante.Sexo__c;
					familiar.fecha_nac = formatDate(integrante.Fecha_de_Nacimiento__c);
					familiar.discapacitado = (integrante.Discapacitado__c == 'Si') ? 'V' : 'F';
					familiar.nacionalidad = integrante.Nacionalidad__c;
					familiar.deriva_aportes = (integrante.Indicador_de_aporte__c) ? 'V' : 'F';
						if(integrante.Indicador_de_aporte__c) {
						familiar.cuit = getValueOf(integrante.CUIT_Sin_guiones__c);
						familiar.importe_aportes = getValueOf(integrante.Aportes__c);
						familiar.cuit_empleador = (!String.isBlank(integrante.Empleador__c)) ? integrante.Empleador__r.Cuit__c : integrante.Cuit_empleador__c;
						familiar.nombre_empleador = (!String.isBlank(integrante.Empleador__c)) ? integrante.Empleador__r.Name : integrante.Razon_social__c;
						familiar.codigo_empleador = (!String.isBlank(integrante.Empleador__c)) ? integrante.Empleador__r.Codigo_de_empresa__c : '';
					}
				familiares.add(familiar);
			}
			solicitud.familiares = familiares;
			solicitud.archivos = parseFiles();
			solicitud.notas = parseNotas();
		} catch (Exception err) {
			System.debug(err.getMessage());
		}
		return JSON.serialize(solicitud, true);
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@company		Xappia
	@description	Método para entregar el body de la solicitud a la API para una solicitud de Baja Total.
	------------------------------------------------------------------------------------------------------------------------*/
	public String parseBajaTotalBody () {
		SolicitudSS solicitudSS = new SolicitudSS();
		try {
			Encabezado encabezado = new Encabezado();
				encabezado.sf_id = this.caso.Id;
				encabezado.agencia_codigo = this.usuario.Codigo_delegacion__c;
				encabezado.fecha_vigencia = formatDate(this.caso.Fecha_de_vigencia__c);
				encabezado.usuario = this.userNick;
			solicitudSS.encabezado = new List<Encabezado>{encabezado};
			Solicitudes solicitud = new Solicitudes();
				solicitud.sf_id = this.caso.Id;
				solicitud.codigo_afi = (!String.isBlank(this.caso.Account.codigo_de_Afiliado__c)) ? this.caso.Account.Codigo_de_Afiliado__c : '';
				solicitud.tipo_asociado = 'TIT';
				solicitud.motivo_baja = this.caso.Motivo_de_baja__c;
				solicitud.notas = parseNotas();
			if(!String.isBlank(this.caso.Nro_de_solicitud_SS__c)) {
				solicitud.solicitud_id = this.caso.Nro_de_solicitud_SS__c;
			}
			solicitudSS.solicitudes = new List<Solicitudes>{solicitud};
			solicitudSS.archivos = parseFiles();
		} catch (Exception err) {
			System.debug(err.getMessage());
		}
		return JSON.serialize(solicitudSS, true);
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@company		Xappia
	@description	Método para entregar el body de la solicitud a la API para una solicitud de Baja Parcial.
	------------------------------------------------------------------------------------------------------------------------*/
	public String parseBajaParcialBody () {
		SolicitudSS solicitudSS = new SolicitudSS();
		try {
			Encabezado encabezado = new Encabezado();
				encabezado.sf_id = this.caso.Id;
				encabezado.agencia_codigo =  this.usuario.Codigo_delegacion__c;
				encabezado.fecha_vigencia = formatDate(caso.Fecha_de_vigencia__c);
				encabezado.usuario = this.userNick;
				if(!String.isBlank(this.caso.Nro_de_solicitud_SS__c)) {
					encabezado.solicitud_id =caso.Nro_de_solicitud_SS__c;
				}
			solicitudSS.encabezado = new List<Encabezado>{encabezado};
			Map<Id, List<Nota_de_Auditoria__c>> notasByIntegranteId = new Map<Id, List<Nota_de_Auditoria__c>>();
			for(Nota_de_Auditoria__c nota : this.notas){
				if(notasByIntegranteId.containsKey(nota.Integrante__c)) {
					notasByIntegranteId.get(nota.Integrante__c).add(nota);
				} else {
					notasByIntegranteId.put(nota.Integrante__c, new List<Nota_de_Auditoria__c> {nota});
				}
			}
			List<Solicitudes> solicitudes = new List<Solicitudes>();
			for (Integrante_caso__c integrante : this.integrantes){
				List<Nota_de_Auditoria__c> integranteNotas = notasByIntegranteId.containsKey(integrante.Id)
																? notasByIntegranteId.get(integrante.Id)
																: new List<Nota_de_Auditoria__c>();
				Solicitudes solicitud = new Solicitudes();
				solicitud.sf_id = integrante.Id;
				solicitud.codigo_afi = (!String.isBlank(integrante.Familiar__c))
										? integrante.Familiar__r.Codigo_de_Afiliado__c : '';
				solicitud.tipo_asociado = 'FAM';
				solicitud.motivo_baja = integrante.Motivo_de_baja__c;
				solicitud.notas = parseNotas(integranteNotas);
				if(!String.isBlank(integrante.Numero_de_solicitud__c)) {
					solicitud.solicitud_id = integrante.Numero_de_solicitud__c;
				}
				solicitudes.add(solicitud);
			}
			solicitudSS.solicitudes = solicitudes;
			solicitudSS.archivos = parseFiles();
		} catch (Exception err) {
			System.debug(err.getMessage());
		}
		return JSON.serialize(solicitudSS, true);
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@company		Xappia
	@description	Método para entregar el body de la solicitud a la API para una solicitud de Cambio de segmento.
	------------------------------------------------------------------------------------------------------------------------*/
	public String parseCambioDeSegmentoBody () {
		SolicitudSS solicitudSS = new SolicitudSS();
		try {
			Encabezado encabezado = new Encabezado();
				encabezado.sf_id = this.caso.id;
				encabezado.codigo_afi_titular = (!String.isBlank(this.caso.Account.Codigo_de_Afiliado__c))
												? getValueOf(this.caso.Account.Codigo_de_Afiliado__c) : '';
				encabezado.fecha_vigencia = formatDate(caso.Fecha_de_vigencia__c);
				encabezado.agencia_codigo = this.usuario.Codigo_delegacion__c;
				encabezado.usuario = this.userNick;
				encabezado.codigo_obrasocial = (!String.isBlank(caso.Obra_social2__c))
												? this.caso.Obra_social2__r.Codigo_de_obra_social__c : '';
				encabezado.codigo_plan = this.caso.Plandespegue__c;
				encabezado.nuevo_segmento = this.caso.Nuevo_segmento__c;
				encabezado.codigo_empleador = (!String.isBlank(caso.Empleador__c))
												? this.caso.Empleador__r.Codigo_de_empresa__c : '';
				if(!String.isBlank(this.caso.Nro_de_solicitud_SS__c)) {
					encabezado.solicitud_id = this.caso.Nro_de_solicitud_SS__c;
					encabezado.estado_dj = this.caso.Estado_DDJJ__c;
				}
				if(caso.Nuevo_segmento__c.contains('OBL') || this.caso.Nuevo_segmento__c == 'DTCAP') {
					encabezado.importe_aportes = getValueOf(this.caso.Aporte__c);
					encabezado.cuit = this.caso.Cuit__c;
					encabezado.cuit_empleador = (!String.isBlank(this.caso.Empleador__c))
												? this.caso.Empleador__r.Cuit__c
													: (!String.isBlank(this.caso.Cuit_empleador__c)) ? this.caso.Cuit_empleador__c : '';
					encabezado.nombre_empleador = (!String.isBlank(this.caso.Empleador__c))
													? this.caso.Empleador__r.Name
														: (!String.isBlank(this.caso.Razon_social__c)) ? this.caso.Razon_social__c : '';
				}
			solicitudSS.encabezado = new List<Encabezado>{encabezado};
			solicitudSS.archivos = parseFiles();
			solicitudSS.notas = parseNotas();
		} catch (Exception err) {
			System.debug(err.getMessage());
		}
		return JSON.serialize(solicitudSS, true);
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@company		Xappia
	@description	Método para entregar el body de la solicitud a la API para una solicitud de Interfaz financiera.
	------------------------------------------------------------------------------------------------------------------------*/
	public String parseInterfazFinanciera () {
		SolicitudSS solicitudSS = new SolicitudSS();
		try {
			Encabezado encabezado = new Encabezado();
				encabezado.sf_id = this.caso.Id;
				encabezado.fecha_vigencia = formatDate(this.caso.Fecha_de_vigencia__c);
				encabezado.agencia_codigo = this.usuario.Codigo_delegacion__c;
				encabezado.usuario = this.userNick;
				encabezado.tipo_if = this.caso.Type;
				encabezado.afi_codigo = (!String.isBlank(this.caso.Account.Codigo_de_Afiliado__c))
										? getValueOf(this.caso.Account.Codigo_de_Afiliado__c) : '';
				if(!String.isBlank(this.caso.Nro_de_solicitud_SS__c)) {
					encabezado.solicitud_id = caso.Nro_de_solicitud_SS__c;
					encabezado.estado_dj = caso.Estado_DDJJ__c;
				}
				//Reintegros
				if(this.caso.Type == 'T') {
						encabezado.cbu_reintegros = caso.Numero_CBU__c;
						encabezado.cuit = caso.CUIT_CUIL_Titular_CBU__c;
				}
				//Facturacion
				if(this.caso.Type == 'C') {
					encabezado.civa_codigo = XappiaHelper.stringToNumericString(String.valueOf(getValueOf(this.caso.Condicion_IVA__c)));
					if(this.caso.Borrar_tarjeta_debito_o_cobro_por_CBU__c) {
						encabezado.cobro_medio = '';
						encabezado.cobro_numero = '';
					}
					else {
						if(!String.isBlank(this.caso.Tipo_CBU__c) && !String.isBlank(this.caso.CBU__c)) {
							encabezado.cobro_medio = caso.Tipo_CBU__c;
							encabezado.cobro_numero = caso.CBU__c;
							encabezado.cuil_cbu = caso.CUIL_del_CBU__c;
						} else if(!String.isBlank(caso.Tarjeta_de_credito__c) && !String.isBlank(caso.Numero_de_tarjeta_de_credito__c)) {
							encabezado.cobro_medio = caso.Tarjeta_de_credito__c;
							encabezado.cobro_numero = caso.Numero_de_tarjeta_de_credito__c;
						} else if(!String.isBlank(caso.Tipo_de_debito_por_ACA__c) && !String.isBlank(caso.Cdigo_debito_por_ACA__c)) {
							encabezado.cobro_medio = caso.Tipo_de_debito_por_ACA__c;
							encabezado.cobro_numero = caso.Cdigo_debito_por_ACA__c;
						}
					}
					if(XappiaHelper.stringToNumericString(String.valueOf(getValueOf(this.caso.Condicion_IVA__c))) == '1') {
						encabezado.cuit = caso.Cuit__c;
					}
				}
			solicitudSS.encabezado = new List<Encabezado>{encabezado};
			solicitudSS.archivos = parseFiles();
			solicitudSS.notas = parseNotas();
		} catch (Exception err) {
			System.debug(err.getMessage());
		}
		return JSON.serialize(solicitudSS, true);
	}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@company		Xappia
	@description	Método para entregar el body de la solicitud a la API para una solicitud de Datos particulares.
	------------------------------------------------------------------------------------------------------------------------*/
	public String parseDatosParticularesBody () {
		SolicitudSS solicitud = new SolicitudSS();
		try {
			Encabezado encabezado = new Encabezado();
				encabezado.sf_id = this.caso.Id;
				encabezado.fecha_vigencia = formatDate(this.caso.Fecha_de_vigencia__c);
				encabezado.agencia_codigo = this.usuario.Codigo_delegacion__c;
				encabezado.usuario = this.userNick;
				encabezado.afi_codigo = (!String.isBlank(this.caso.Account.Codigo_de_Afiliado__c))
										? getValueOf(this.caso.Account.Codigo_de_Afiliado__c) : '';
				encabezado.tipo_solicitud = this.caso.Type;
				switch on this.caso.Type {
					when 'MODIF_DPART' {
						encabezado.nombres = this.caso.Nombre__c;
						encabezado.apellido = this.caso.Apellido__c;
						encabezado.nacionalidad = getValueOf(this.caso.Nacionalidad__c);
						encabezado.sexo = (!String.isBlank(this.caso.Sexo__c)) ? this.caso.Sexo__c.left(1).toUppercase() : '';
						encabezado.e_civil = getValueOf(this.caso.Estado_civil__c);
						encabezado.fecha_nac = formatDate(this.caso.Fecha_de_nacimiento__c);
						encabezado.codigo_obrasocial = (!String.isBlank(this.caso.Obra_social2__c))
														? this.caso.Obra_social2__r.Codigo_de_obra_social__c : '';
						encabezado.parentesco = getValueOf(this.caso.Tipo_de_parentesco__c);
						encabezado.cuit = this.caso.CUIT__C;
					}
					when 'MODIF_DELEG' {
						encabezado.agencia_destino = (this.caso.Delegacion__c != null)
													? this.caso.Agencia_destino__r.codigo_de_delegacion__c : '';
					}
				}
				if (this.caso.Type != 'MODIF_DELEG') encabezado.afi_tipo = this.caso.Tipo__c;
				if(!String.isBlank(this.caso.Nro_de_solicitud_SS__c)) encabezado.solicitud_id = this.caso.Nro_de_solicitud_SS__c;
			solicitud.encabezado = new List<Encabezado>{encabezado};
		} catch (Exception err) {
			System.debug(err.getMessage());
		}
		return JSON.serialize(solicitud, true);
	}	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@company		Xappia
	@description	Método para entregar el body de la solicitud a la API para una solicitud de Cambio de Plan.
	------------------------------------------------------------------------------------------------------------------------*/
	public String parseCambioPlanBody () {
		SolicitudSS solicitudSS = new SolicitudSS();
		try {
			Encabezado encabezado = new Encabezado();
				encabezado.sf_id = this.caso.Id;
				encabezado.fecha_vigencia = formatDate(this.caso.Fecha_de_vigencia__c);
				encabezado.agencia_codigo = this.usuario.Codigo_delegacion__c;
				encabezado.usuario = this.userNick;
				encabezado.codigo_afi_titular = (!String.isBlank(this.caso.Account.Codigo_de_Afiliado__c))
												? getValueOf(this.caso.Account.Codigo_de_Afiliado__c) : '' ;
				encabezado.codigo_plan = this.caso.Plandespegue__c;
				if (!String.isBlank(this.caso.Nro_de_solicitud_SS__c)) {
					encabezado.solicitud_id = this.caso.Nro_de_solicitud_SS__c;
					encabezado.estado_dj = this.caso.Estado_DDJJ__c;
				}
			solicitudSS.encabezado = new List<Encabezado>{encabezado};
			solicitudSS.archivos = parseFiles();
			solicitudSS.notas = parseNotas();
		} catch (Exception err) {
			System.debug(err.getMessage());
		}
		return JSON.serialize(solicitudSS, true);
	}
	/** Utils */
	private List<Archivos> parseFiles () {
		List<Archivos> archivosToReturn = new List<Archivos>();
		try {
			if(!this.files.isEmpty()) {
				ContentVersion data = this.files[0];
				String title = Utils.getStringAlphanumericOnly(data.Title);
				if(title.length() > 44) {title = title.substring(0, 44);}
				Archivos archivo = new Archivos();
				archivo.datos = 'data:' + Utils.getTypeAndExtension(data.FileExtension) +
								';base64,' + EncodingUtil.base64Encode(data.VersionData);
				archivo.observaciones = null;
				archivo.descripcion = data.Description;
				archivo.nombre = title.contains('.' + data.FileExtension) ? title : title + '.' + data.FileExtension;
				archivosToReturn.add(archivo);
			}
		} catch (Exception err) {
			System.debug(err.getMessage());
		}
		return archivosToReturn;
	}
	private List<Notas> parseNotas () {
		List<Notas> notasToReturn = new List<Notas>();
		try {
			for (Nota_de_Auditoria__c nota : this.notas) {
				Notas notaToReturn = new Notas();
				notaToReturn.sf_id = nota.Id;
				notaToReturn.texto = nota.Nota__c;
				notaToReturn.usuario_nota = nota.CreatedBy.CommunityNickname;
				notasToReturn.add(notaToReturn);
			}
		} catch (Exception err) {
			System.debug(err.getMessage());
		}
		return notasToReturn;
	}
	private List<Notas> parseNotas (List<Nota_de_Auditoria__c> notasToParse) {
		List<Notas> notasToReturn = new List<Notas>();
		try {
			for (Nota_de_Auditoria__c nota : notasToParse) {
				Notas notaToReturn = new Notas();
				notaToReturn.sf_id = nota.Id;
				notaToReturn.texto = nota.Nota__c;
				notaToReturn.usuario_nota = nota.CreatedBy.CommunityNickname;
				notasToReturn.add(notaToReturn);
			}
		} catch (Exception err) {
			System.debug(err.getMessage());
		}
		return notasToReturn;
	}
	private static String formatDate(Date fecha) {
		try {
			Datetime dt = Datetime.newInstance(fecha.year(), fecha.month(), fecha.day(),0,0,0);
			return dt.Format('dd/MM/yyyy');
		} catch(Exception e) {
			return '';
		}
	}
	private static String getValueOf(Object obj) {
		return (obj != null) ? String.valueOf(obj) : '';
	}
}
