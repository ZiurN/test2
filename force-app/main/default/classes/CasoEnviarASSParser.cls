/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase deserializadora para las solicitudes de llamados a SS.
@date			26/10/2021
------------------------------------------------------------------------------------------------------------------------*/
@SuppressWarnings('PMD.ExcessiveParameterList')
public with sharing class CasoEnviarASSParser {
	public Case caso {get; set;}
	public String userNick {get; set;}
	public List<ContentVersion> files {get; set;}
	public List<Nota_de_Auditoria__c> notas {get; set;}
	public List<Integrante_caso__c> integrantes {get; set;}
	public User usuario {get; set;}
	public List<Prestacion__c> prestaciones {get; set;}
	/** Constructors */
	public CasoEnviarASSParser (Case caso,
					String userNick,
					User usuario) {
		this.caso = caso;
		this.userNick = userNick;
		this.usuario = usuario;
	}
	public CasoEnviarASSParser (Case caso,
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
	public CasoEnviarASSParser (Case caso,
					String userNick,
					List<ContentVersion> files,
					List<Nota_de_Auditoria__c> notas,
					List<Integrante_caso__c> integrantes,
					User usuario) {
		this.caso = caso;
		this.userNick = userNick;
		this.files = files;
		this.notas = notas;
		this.integrantes = integrantes;
		this.usuario = usuario;
	}
	public CasoEnviarASSParser (Case caso,
					List<Prestacion__c> prestaciones,
					String userNick) {
		this.caso = caso;
		this.prestaciones = prestaciones;
		this.userNick = userNick;
	}
	public CasoEnviarASSParser (Case caso, String userNick) {
		this.caso = caso;
		this.userNick = userNick;
	}
	/**-----------------------------------------------------------------------------------------------------------------------
 	@author			Jeferson Ruiz
 	@company		Xappia
	@description	Deserializador para solicitudes de SS a las APIS de solicitudes de afiliados.
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
					encabezado.civa_codigo = XappiaHelper.stringToNumericString(getValueOf(getValueOf(this.caso.Condicion_IVA__c)));
					Boolean derivaAportes = ((this.caso.Type == 'FT' || this.caso.Type == 'CT')
												&& this.caso.Segmento_de_grupo_familiar__c.startsWith('OBL'))
											|| (this.caso.deriva_aportes__c);
					String civacodigo = XappiaHelper.stringToNumericString(getValueOf(getValueOf(this.caso.Condicion_IVA__c)));
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
						encabezado.civa_codigo = XappiaHelper.stringToNumericString(getValueOf(getValueOf(this.caso.Condicion_IVA__c)));
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
						if(XappiaHelper.stringToNumericString(getValueOf(getValueOf(this.caso.Condicion_IVA__c))) == '1') {
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
	/**-----------------------------------------------------------------------------------------------------------------------
 	@author			Jeferson Ruiz
 	@company		Xappia
	@description	Deserializador para solicitudes de SS a la API de autorizaciones AP.
	------------------------------------------------------------------------------------------------------------------------*/
		public class AutorizacionAPSS {
			public String numero_ap {get;set;}
			public String fecha {get;set;}
			public String fecha_prob {get;set;}
			public String agencia_codigo {get;set;}
			public String user_insert {get;set;}
			public String codigo_afiliado {get;set;}
			public Object evento_medico_id {get;set;}
			public String fecha_pres {get;set;}
			public String codigo_diagnostico {get;set;}
			public String efectores_prestador {get;set;}
			public String prestador {get;set;}
			public String consultorio {get;set;}
			public String observaciones {get;set;}
			public String mail {get;set;}
			public Object otros_mail {get;set;}
			public String forma_pago {get;set;}
			public String contexto {get;set;}
			public String chk_material {get;set;}
			public String chk_presupuesto {get;set;}
			public String numero_sf {get;set;}
			public List<Prestaciones> prestaciones {get;set;}
			public String urgente {get; set;}
			public Double importe_presupuesto {get;set;}
		}
		/** Objecto Prestaciones */
			public class Prestaciones {
				public Integer cantidad {get;set;}
				public String nom_prestacion_pdh {get;set;}
				public String contexto {get;set;}
				public String tipo_prestacion {get;set;}
				public String observaciones {get;set;}
				public String alerta {get;set;}
				public String importe_g_convenio_aud {get;set;}
				public String importe_g_plan_aud {get;set;}
				public String importe_cargo_al_socio_aud {get;set;}
				public String grupo_prestaciones {get;set;}
				public String numero_sf {get;set;}
				public String nom_prestacion {get;set;}
				public String importe_total {get;set;}
				public String importe_a_pagar {get;set;}
				public String honorarios {get;set;}
				public Object pieza_dental {get;set;}
				public Object cara {get;set;}
				public String fecha {get;set;}
			}
			/**-----------------------------------------------------------------------------------------------------------------------
			@author			Jeferson Ruiz
			@company		Xappia
			@description	Método para entregar el body de la solicitud a la API para una autorización AP.
			------------------------------------------------------------------------------------------------------------------------*/
			public String parseAutorizacionAPBody () {
				AutorizacionAPSS autorizacion = new AutorizacionAPSS();
				try {
					String contextoAP = prestaciones.isEmpty() ? null : prestaciones[0].Contexto__c;
					String chkMaterial = this.caso.AP_Material__c ? 'V' : 'F';
					String chkPresupuesto = this.caso.AP_Presupuesto__c ? 'V' : 'F';
					String formaPago = this.caso.Orden_de_Compra__r.Estado_OC__c == 'Desestimada' ? 'D'
									: this.caso.Orden_de_Compra__r.forma_de_Pago__c;
					autorizacion.fecha = String.valueOf(this.caso.Fecha__c);
					autorizacion.forma_pago = formaPago;
					autorizacion.fecha_prob = this.caso.Fecha_probable__c == null ? '' : String.valueOf(this.caso.Fecha_probable__c);
					autorizacion.agencia_codigo = this.caso.Delegacion__r.Codigo_de_delegacion__c;
					autorizacion.user_insert = this.userNick;
					autorizacion.codigo_afiliado = this.caso.Account.Codigo_de_Afiliado__c;
					autorizacion.evento_medico_id = this.caso.Evento_Medico__r.Nro_de_Evento_Medico_SS__c;
					autorizacion.fecha_pres = this.caso.Fecha_prescripcion__c == null ? '' : String.valueOf(this.caso.Fecha_prescripcion__c);
					autorizacion.codigo_diagnostico = this.caso.Diagnostico__r.Codigo_del_Diagnostico__c;
					autorizacion.efectores_prestador = this.caso.Prescriptor__r.Codigo_de_efector__c;
					autorizacion.prestador = this.caso.Prestador__r.Codigo_de_efector__c;
					autorizacion.consultorio = this.caso.Consultorio__r.Secuencia__c != null
											? getValueOf(this.caso.Consultorio__r.Secuencia__c) : '';
					autorizacion.observaciones = this.caso.Observaciones__c;
					autorizacion.mail = this.caso.Mail__c;
					autorizacion.otros_mail = this.caso.Otros_Mail__c;
					autorizacion.contexto = contextoAP;
					autorizacion.chk_material = chkMaterial;
					autorizacion.chk_presupuesto = chkPresupuesto;
					autorizacion.numero_sf = this.caso.Id;
					autorizacion.urgente = this.caso.Urgente__c;
					if(chkPresupuesto == 'V'){
						autorizacion.importe_presupuesto = this.caso.Importe_presupuesto__c;
					}
					if(this.caso.Nro_AP__c != null){
						autorizacion.numero_ap = this.caso.Nro_AP__c;
					}
					List<Prestaciones> prestacionesList = new List<Prestaciones>();
					for (Prestacion__c prestacion : this.prestaciones) {
						Prestaciones prestacionToSend = new Prestaciones();
							prestacionToSend.importe_g_plan_aud = prestacion.Importe_plan_auditor__c != null
														? getValueOf(prestacion.Importe_plan_auditor__c) : '';
							prestacionToSend.importe_cargo_al_socio_aud = prestacion.Importe_cargo_al_socio_auditor__c != null
														? getValueOf(prestacion.Importe_cargo_al_socio_auditor__c) : '';
							prestacionToSend.importe_g_convenio_aud = prestacion.Importe_convenio_auditor__c != null
														? getValueOf(prestacion.Importe_convenio_auditor__c) : '';
							prestacionToSend.cantidad = Integer.valueOf(prestacion.Cantidad__c);
							prestacionToSend.nom_prestacion_pdh = codigoPrestacion(prestacion);
							prestacionToSend.tipo_prestacion = prestacion.Tipo__c;
							prestacionToSend.observaciones = prestacion.Observaciones__c == null ? '' : prestacion.Observaciones__c;
							prestacionToSend.contexto = prestacion.Contexto__c;
							prestacionToSend.alerta = prestacion.Alerta__c;
							if(prestacion.Tipo__c == 'G') {
								prestacionToSend.grupo_prestaciones = codigoPrestacion(prestacion);
								prestacionToSend.nom_prestacion_pdh = null;
							}
						prestacionesList.add(prestacionToSend);
					}
					autorizacion.prestaciones = prestacionesList;
				} catch (Exception err) {
					System.debug(err.getMessage());
				}
				return JSON.serialize(autorizacion, true);
			}
	/**-----------------------------------------------------------------------------------------------------------------------
	@author			Jeferson Ruiz
	@company		Xappia
	@description	Deserializador para solicitudes de SS a la API Reintegros.
	------------------------------------------------------------------------------------------------------------------------*/
			public class ReintegroSS {
				public String fecha {get;set;}
				public String lote {get;set;}
				public String agencia_codigo {get;set;}
				public String codigo_afiliado {get;set;}
				public String cuit {get;set;}
				public String razon_social {get;set;}
				public String tipo_comprobante {get;set;}
				public String numero_comprobante {get;set;}
				public String fecha_comprobante {get;set;}
				public String importe {get;set;}
				public String observaciones {get;set;}
				public String codigo_diagnostico {get;set;}
				public String fecha_prescripcion {get;set;}
				public String efector_prescriptor {get;set;}
				public String efector_realizador {get;set;}
				public String cobro {get;set;}
				public String em_id {get;set;}
				public String numero_sf {get;set;}
				public String usuario {get;set;}
				public String rein_id {get;set;}
				public List<Prestaciones> prestaciones {get;set;}
			}
			public String parseReintegroBody () {
				String medicamentoRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Medicamento').Id;
				String odontologicaRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Odontologica').Id;
				String prestacionalRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Prestacional').Id;
				String razonSocial60Char = this.caso.Razon_social__c?.length() > 60
								? this.caso.Razon_social__c?.substring(0, 60) : this.caso.Razon_social__c;
				ReintegroSS reintegro = new ReintegroSS();
				try {
					reintegro.usuario = this.userNick;
					reintegro.numero_sf = this.caso.Id;
					reintegro.em_id = this.caso.Evento_Medico__r.Nro_de_Evento_Medico_SS__c;
					reintegro.cobro = this.caso.Cobro_indebido__c ? 'S' : 'N';
					reintegro.efector_realizador = this.caso.Efector_realizador__r.Codigo_de_efector__c;
					reintegro.efector_prescriptor = this.caso.Prescriptor__r.Codigo_de_efector__c;
					reintegro.fecha_prescripcion = this.caso.Fecha_prescripcion__c != null
													? String.valueOf(this.caso.Fecha_prescripcion__c) : '';
					reintegro.codigo_diagnostico = this.caso.Diagnostico__r.Codigo_del_Diagnostico__c;
					reintegro.observaciones = this.caso.Observaciones__c;
					reintegro.importe = this.caso.Importe_reintegro__c != null
										? String.valueOf(this.caso.Importe_reintegro__c) : '';
					reintegro.fecha_comprobante = null;
					reintegro.numero_comprobante = null;
					reintegro.tipo_comprobante = this.caso.Tipo_de_Comprobante__c;
					reintegro.razon_social = razonSocial60Char;
					reintegro.cuit = this.caso.CUIT__c;
					reintegro.codigo_afiliado = this.caso.Account.Codigo_de_Afiliado__c;
					reintegro.agencia_codigo = this.caso.Delegacion__r.Codigo_de_delegacion__c;
					reintegro.lote = this.caso.Lote__r.Id_lote_SS__c;
					reintegro.fecha = this.caso.Fecha__c != null
									? String.valueOf(this.caso.Fecha__c) : '';
					if(this.caso.Codigo_reintegro_SS__c != null) {
						reintegro.rein_id = this.caso.Codigo_reintegro_SS__c;
					}
					List<Prestaciones> prestacionesToSend = new List<Prestaciones>();
					for (Prestacion_de_reintegro__c prestacion : this.caso.Prestaciones_de_reintegros__r) {
						String tipoPrestacion = getTypeCodeFromRT(prestacion);
						String fecha;
						if(tipoPrestacion == 'M') {
							fecha = prestacion.Fecha_de_dispensa__c != null ? String.valueOf(prestacion.Fecha_de_dispensa__c) : '';
						}
						else {
							fecha = prestacion.Fecha_de_realizacion__c != null ? String.valueOf(prestacion.Fecha_de_realizacion__c) : '';
						}
						Prestaciones prestacionToSend = new Prestaciones();
							prestacionToSend.observaciones = prestacion.Observaciones__c;
							prestacionToSend.alerta = prestacion.Alerta__c;
							prestacionToSend.fecha = fecha;
							prestacionToSend.cara = prestacion.Caras__c;
							prestacionToSend.pieza_dental = prestacion.Pieza_dental__c;
							prestacionToSend.honorarios = prestacion.HD__c;
							prestacionToSend.importe_a_pagar = prestacion.Importe_a_pagar__c != null
														? String.valueOf(prestacion.Importe_a_pagar__c) : '';
							prestacionToSend.importe_total = prestacion.Importe_total__c != null
														? String.valueOf(prestacion.Importe_total__c) : '';
							prestacionToSend.tipo_prestacion = getTypeCodeFromRT(prestacion);
							prestacionToSend.cantidad = Integer.valueOf(prestacion.Cantidad__c);
							prestacionToSend.contexto = prestacion.Contexto__c;
							prestacionToSend.nom_prestacion = getCodigoPrestacion(prestacion);
							prestacionToSend.numero_sf = prestacion.Id;
						prestacionesToSend.add(prestacionToSend);
					}
					reintegro.prestaciones = prestacionesToSend;
				}catch (Exception err) {
					System.debug(err.getMessage());
				}
				return JSON.serialize(reintegro, true);
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
				archivo.observaciones = '';
				archivo.descripcion = data.Description == null ? '' : data.Description;
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
		return (obj != null) ? String.ValueOf(obj) : '';
	}
	public static String getTypeCodeFromRT(Prestacion_de_reintegro__c prestacion) {
		String medicamentoRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Medicamento').Id;
		String odontologicaRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Odontologica').Id;
		String prestacionalRTId = XappiaHelper.getRecordType('Prestacion_de_reintegro__c', 'Prestacional').Id;
		if(prestacion.RecordTypeId == medicamentoRTId) {
			return 'M';
		} else if(prestacion.RecordTypeId == odontologicaRTId) {
			return 'O';
		} else if(prestacion.RecordTypeId == prestacionalRTId) {
			return 'N';
		}
		return null;
	}
	public static String getCodigoPrestacion(Prestacion_de_reintegro__c prestacion) {
		String tipo = getTypeCodeFromRT(prestacion);
		switch on tipo {
			when 'N'{
				return prestacion.Prestacional__r.Codigo__c;
			}
			when 'O'{
				return prestacion.Prestacion_odonto__r.Codigo__c;
			}
			when 'M' {
				return prestacion.Medicamento__r.Codigo_medicamento__c;
			}
			when else {
				return null;
			}
		}
	}
	private static String codigoPrestacion(Prestacion__c pres){
		switch on pres.Tipo__c {
			when 'N'{
				return pres.Prestacion__r.Codigo__c;
			}
			when 'G'{
				return pres.Grupo_de_Prestaciones__r.Codigo__c;
			}
			when 'M' {
				return pres.Medicamento__r.Codigo_medicamento__c;
			}
			when else {
				return '';
			}
		}
	}
}
