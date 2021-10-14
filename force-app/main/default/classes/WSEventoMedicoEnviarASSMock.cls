public class WSEventoMedicoEnviarASSMock  {

	public static String getFound() {
		return 
			'{' +
				'"data": {' +
					'"em": {' +
						'"em_id": "275751",' +
						'"fecha_inicio": "27-09-2019 00:00",' +
						'"estado": "EN AUDITORIA",' +
						'"emitido": "NO EMITIDO",' +
						'"alerta": null,' +
						'"fecha_emision": null,' +
						'"segmento": [' +
							'{' +
								'"em_em_id": "275751",' +
								'"sem_id": "123456",' +
								'"fecha": "2020-02-13 00:00:00",' +
								'"solicitante": "753415",' +
								'"nom_solicitante": "PARDO GUILLERMO MANUEL",' +
								'"fecha_desde_tentativa": "04-09-2019 00:00",' +
								'"fecha_hasta_tentativa": "' + System.now().addDays(2).format('dd-MM-yyyy hh:mm') + '",' +
								'"cant_dias": "90",' +
								'"estado": "EN AUDITORIA",' +
								'"cod_auditor": null,' +
								'"ape_auditor": null,' +
								'"nom_auditor": null,' +
								'"fecha_real_desde": null,' +
								'"fecha_real_hasta": null,' +
								'"orig_fecha_real": "MESA CENSO",' +
								'"cod_audito2": null,' +
								'"ape_auditor2": null,' +
								'"nom_auditor2": null,' +
								'"prestador": null,' +
								'"pres_nombre": " ",' +
								'"presentacion": null,' +
								'"lote": null,' +
								'"obs": null' +
							'},' +
							'{' +
								'"em_em_id": "275751",' +
								'"sem_id": "1234567",' +
								'"fecha": "2020-02-13 00:00:00",' +
								'"solicitante": "753415",' +
								'"nom_solicitante": "PARDO GUILLERMO MANUEL",' +
								'"fecha_desde_tentativa": "04-09-2019 00:00",' +
								'"fecha_hasta_tentativa": "' + System.now().addDays(3).format('dd-MM-yyyy hh:mm') + '",' +
								'"cant_dias": "90",' +
								'"estado": "EN AUDITORIA",' +
								'"cod_auditor": null,' +
								'"ape_auditor": null,' +
								'"nom_auditor": null,' +
								'"fecha_real_desde": null,' +
								'"fecha_real_hasta": null,' +
								'"orig_fecha_real": "MESA CENSO",' +
								'"cod_audito2": null,' +
								'"ape_auditor2": null,' +
								'"nom_auditor2": null,' +
								'"prestador": null,' +
								'"pres_nombre": " ",' +
								'"presentacion": null,' +
								'"lote": null,' +
								'"obs": null' +
							'}' +
						'],' +
						'"efe_codigo_lugar": "700076",' +
						'"cons_lugar": "1",' +
						'"nom_lugar": "SANATORIO AMERICANO",' +
						'"nom_cons": "CONSULTORIO PPAL SANAT AMERICANO",' +
						'"efe_codigo_resp": "753415",' +
						'"nom_resp": "PARDO GUILLERMO MANUEL",' +
						'"efe_codigo_solic": "753415",' +
						'"nom_solic": "PARDO GUILLERMO MANUEL",' +
						'"tem_codigo": "IA",' +
						'"nom_tipo": "INTERNACION",' +
						'"contexto": "INTERNACION",' +
						'"de_seguimiento": "F",' +
						'"recupero": "V",' +
						'"diferido": "F",' +
						'"suspendido": "F",' +
						'"fec_vto_certif": null,' +
						'"cod_motivo": "CLINICO",' +
						'"nom_motivo": "CLINICO",' +
						'"mail": null,' +
						'"diag_codigo": "999",' +
						'"diag_nombre": "DIAGNOSTICO INDETERMINADO",' +
						'"complicaciones": "SIN COMPLICACIONES",' +
						'"grup_pres": null,' +
						'"gpres_nombre": null,' +
						'"nro_prestacion": "02430199",' +
						'"nom_prestacion": "INTERNACION CLINICA (FACTURAR CODIGO PENSION)",' +
						'"aut_previa": "1014009814",' +
						'"feem_codigo": null,' +
						'"feem_nombre": null,' +
						'"domi_entrega": null,' +
						'"agenia": null,' +
						'"otro_domi": null,' +
						'"via_entrega": null,' +
						'"domicilio": null,' +
						'"em_de_seguimiento": null,' +
						'"tipo_seg": null,' +
						'"nom_tipo_seg": null,' +
						'"estado_seg": null,' +
						'"desc_seg": null,' +
						'"cod_regla": "INT_CLI_1D",' +
						'"nom_regla": "INTERNACION CLINICA X 1 DIA",' +
						'"sistema": "ABIERTO",' +
						'"descr_em": "Descripción",' +
						'"nom_delegacion": "650098_ACA SALUD SUC. ROSARIO",' +
						'"obs_em": "Sin observaciones",' +
						'"afi_afi_id": "131224",' +
						'"apr_apr_id": "1014009814",' +
						'"check_mat": "F",' +
						'"check_presu": "V",' +
						'"importe_presu": "150.32",' +
						'"nro_sf": "2005",' +
						'"ap": [' +
							'{' +
								'"apr_id": "1014009814",' +
								'"fecha": "2020-02-05 00:00:00",' +
								'"conexion": "CX--MOST",' +
								'"nombre_conexion": "Mostrador",' +
								'"delegacion": "650098",' +
								'"nombre_delegacion": "650098_ACA SALUD SUC. ROSARIO",' +
								'"fecha_probable": "2020-02-05 00:00:00",' +
								'"estado": "CA-----A",' +
								'"nombre_estado": "CENTRO AUTORIZADOR",' +
								'"user_insert": "MAPPLICS",' +
								'"fecha_insert": "2020-02-05 09:07:34",' +
								'"codigo_afiliado": "51922/12",' +
								'"apellidos_afiliado": "TORRE",' +
								'"nombres_afiliado": " DANIEL JOSE",' +
								'"doc_afiliado": "DNI 13860713",' +
								'"evento_medico": "275751",' +
								'"fecha_prescripcion": "2019-09-27 00:00:00",' +
								'"diagnostico": "999",' +
								'"desc_diagnostico": "DIAGNOSTICO INDETERMINADO",' +
								'"prescriptor": "753415",' +
								'"nombre_prescriptor": "PARDO GUILLERMO MANUEL",' +
								'"prestador_dirige": "700076",' +
								'"nombre_prestador_dirige": "SANATORIO AMERICANO",' +
								'"prestador": "700076",' +
								'"nombre_prestador": "SANATORIO AMERICANO",' +
								'"consultorio": "1",' +
								'"nombre_consultorio": "CONSULTORIO PPAL SANAT AMERICANO",' +
								'"observaciones": "Autorizacion de evento medico 275751",' +
								'"mail": null,' +
								'"otros_mail": null,' +
								'"aca_agencia": null,' +
								'"tran_alta": null,' +
								'"tran_anulacion": null,' +
								'"ref_externa": null,' +
								'"urgente": null,' +
								'"afi_id": "131224",' +
								'"nro_sf": null,' +
								'"nivel": "N1",' +
								'"clasificacion": "BAJA COMPLEJIDAD",' +
								'"tipo_ap_sf": "LECHES",' +
								'"ap_material": "F",' +
								'"ap_presupuesto": "F",' +
								'"imp_presu": "2563.20",' +
								'"celula": "Celula 2",' +
								'"sla": "120",' +
								'"prestaciones": [' +
									'{' +
										'"apr_id": "1014009814",' +
										'"estado_prestacion": "C1-----A",' +
										'"estado_descripcion": "EN AUDITORIA",' +
										'"contexto": "I",' +
										'"cantidad": "1",' +
										'"prestacion": "02430199",' +
										'"nombre_prestacion": "INTERNACION CLINICA (FACTURAR CODIGO PENSION)",' +
										'"tipo_prestacion": "N",' +
										'"troquel": null,' +
										'"grupo_prestacion": null,' +
										'"pca_id": "74042109",' +
										'"alerta": null,' +
										'"texto_aclarativo": null,' +
										'"alertas": [' +
											'{' +
												'"pca_pca_id": "74042109",' +
												'"aca_id": "16460534",' +
												'"cca_cca_id": null,' +
												'"control": "210",' +
												'"nombre_control": "PRESTACION CUBIERTA",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
												'"nivel_auditoria": "120",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:35",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'},' +
											'{' +
												'"pca_pca_id": "74042109",' +
												'"aca_id": "16460536",' +
												'"cca_cca_id": null,' +
												'"control": "424",' +
												'"nombre_control": "PRESCRIPCION VENCIDA",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "La prescripción esta vencida (tiene 60 días de vigencia) ",' +
												'"nivel_auditoria": "120",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:39",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'},' +
											'{' +
												'"pca_pca_id": "74042109",' +
												'"aca_id": "16460537",' +
												'"cca_cca_id": "74104931",' +
												'"control": "210",' +
												'"nombre_control": "PRESTACION CUBIERTA",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
												'"nivel_auditoria": "120",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:39",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'},' +
											'{' +
												'"pca_pca_id": "74042109",' +
												'"aca_id": "16460538",' +
												'"cca_cca_id": "74104932",' +
												'"control": "210",' +
												'"nombre_control": "PRESTACION CUBIERTA",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
												'"nivel_auditoria": "120",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:39",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'}' +
										']' +
									'}' +
								']' +
							'},' +
							'{' +
								'"apr_id": "1014009815",' +
								'"fecha": "2020-02-05 00:00:00",' +
								'"conexion": "CX--MOST",' +
								'"nombre_conexion": "Mostrador",' +
								'"delegacion": "650098",' +
								'"nombre_delegacion": "650098_ACA SALUD SUC. ROSARIO",' +
								'"fecha_probable": "2020-02-05 00:00:00",' +
								'"estado": "CA-----A",' +
								'"nombre_estado": "CENTRO AUTORIZADOR",' +
								'"user_insert": "MAPPLICS",' +
								'"fecha_insert": "2020-02-05 09:07:40",' +
								'"codigo_afiliado": "51922/12",' +
								'"apellidos_afiliado": "TORRE",' +
								'"nombres_afiliado": " DANIEL JOSE",' +
								'"doc_afiliado": "DNI 13860713",' +
								'"evento_medico": "275751",' +
								'"fecha_prescripcion": "2019-09-27 00:00:00",' +
								'"diagnostico": "999",' +
								'"desc_diagnostico": "DIAGNOSTICO INDETERMINADO",' +
								'"prescriptor": "753415",' +
								'"nombre_prescriptor": "PARDO GUILLERMO MANUEL",' +
								'"prestador_dirige": "700076",' +
								'"nombre_prestador_dirige": "SANATORIO AMERICANO",' +
								'"prestador": "700076",' +
								'"nombre_prestador": "SANATORIO AMERICANO",' +
								'"consultorio": "1",' +
								'"nombre_consultorio": "CONSULTORIO PPAL SANAT AMERICANO",' +
								'"observaciones": null,' +
								'"mail": null,' +
								'"otros_mail": null,' +
								'"aca_agencia": null,' +
								'"tran_alta": null,' +
								'"tran_anulacion": null,' +
								'"ref_externa": null,' +
								'"urgente": null,' +
								'"afi_id": "131224",' +
								'"nro_sf": null,' +
								'"nivel": "N1",' +
								'"clasificacion": "BAJA COMPLEJIDAD",' +
								'"tipo_ap_sf": "PRESTACION",' +
								'"ap_material": "F",' +
								'"ap_presupuesto": "V",' +
								'"prestaciones": [' +
									'{' +
										'"apr_id": "1014009815",' +
										'"estado_prestacion": "C1-----A",' +
										'"estado_descripcion": "EN AUDITORIA",' +
										'"contexto": "I",' +
										'"cantidad": "1",' +
										'"prestacion": "02503102",' +
										'"nombre_prestacion": "CODIGO PARA PRESUPUESTOS FRONT",' +
										'"tipo_prestacion": "N",' +
										'"troquel": null,' +
										'"grupo_prestacion": null,' +
										'"pca_id": "74042110",' +
										'"alerta": null,' +
										'"texto_aclarativo": null,' +
										'"alertas": [' +
											'{' +
												'"pca_pca_id": "74042110",' +
												'"aca_id": "16460539",' +
												'"cca_cca_id": null,' +
												'"control": "210",' +
												'"nombre_control": "PRESTACION CUBIERTA",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
												'"nivel_auditoria": "120",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:40",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'},' +
											'{' +
												'"pca_pca_id": "74042110",' +
												'"aca_id": "16460540",' +
												'"cca_cca_id": null,' +
												'"control": "PRESU_F",' +
												'"nombre_control": "CONTROL PRESUPUESTOS FRONT",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "Requiere Presupuesto",' +
												'"nivel_auditoria": "190",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:40",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'},' +
											'{' +
												'"pca_pca_id": "74042110",' +
												'"aca_id": "16460542",' +
												'"cca_cca_id": null,' +
												'"control": "424",' +
												'"nombre_control": "PRESCRIPCION VENCIDA",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "La prescripción esta vencida (tiene 60 días de vigencia) ",' +
												'"nivel_auditoria": "120",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:42",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'},' +
											'{' +
												'"pca_pca_id": "74042110",' +
												'"aca_id": "16460543",' +
												'"cca_cca_id": "74104933",' +
												'"control": "210",' +
												'"nombre_control": "PRESTACION CUBIERTA",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
												'"nivel_auditoria": "120",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:42",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'},' +
											'{' +
												'"pca_pca_id": "74042110",' +
												'"aca_id": "16460544",' +
												'"cca_cca_id": "74104934",' +
												'"control": "210",' +
												'"nombre_control": "PRESTACION CUBIERTA",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
												'"nivel_auditoria": "120",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:42",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'}' +
										']' +
									'}' +
								']' +
							'}' +
						']' +
					'}' +
				'},' +
				'"meta": {' +
					'"allowed_includes": [],' +
					'"default_includes": []' +
				'}' +
			'}';
	}

	public static String getFoundEMI() {
		return 
			'{' +
				'"data": {' +
					'"em": {' +
						'"em_id": "275751",' +
						'"fecha_inicio": "27-09-2019 00:00",' +
						'"estado": "EN AUDITORIA",' +
						'"emitido": "NO EMITIDO",' +
						'"alerta": null,' +
						'"fecha_emision": null,' +
						'"segmento": [' +
							'{' +
								'"em_em_id": "275751",' +
								'"sem_id": "123456",' +
								'"fecha": "2020-02-13 00:00:00",' +
								'"solicitante": "753415",' +
								'"nom_solicitante": "PARDO GUILLERMO MANUEL",' +
								'"fecha_desde_tentativa": "04-09-2019 00:00",' +
								'"fecha_hasta_tentativa": "' + System.now().addDays(2).format('dd-MM-yyyy hh:mm') + '",' +
								'"cant_dias": "90",' +
								'"estado": "EN AUDITORIA",' +
								'"cod_auditor": null,' +
								'"ape_auditor": null,' +
								'"nom_auditor": null,' +
								'"fecha_real_desde": null,' +
								'"fecha_real_hasta": null,' +
								'"orig_fecha_real": "MESA CENSO",' +
								'"cod_audito2": null,' +
								'"ape_auditor2": null,' +
								'"nom_auditor2": null,' +
								'"prestador": null,' +
								'"pres_nombre": " ",' +
								'"presentacion": null,' +
								'"lote": null,' +
								'"obs": null' +
							'}' +
						'],' +
						'"efe_codigo_lugar": "700076",' +
						'"cons_lugar": "1",' +
						'"nom_lugar": "SANATORIO AMERICANO",' +
						'"nom_cons": "CONSULTORIO PPAL SANAT AMERICANO",' +
						'"efe_codigo_resp": "753415",' +
						'"nom_resp": "PARDO GUILLERMO MANUEL",' +
						'"efe_codigo_solic": "753415",' +
						'"nom_solic": "PARDO GUILLERMO MANUEL",' +
						'"tem_codigo": "IA",' +
						'"nom_tipo": "INTERNACION",' +
						'"contexto": "INTERNACION",' +
						'"de_seguimiento": "F",' +
						'"recupero": "V",' +
						'"diferido": "F",' +
						'"suspendido": "F",' +
						'"fec_vto_certif": null,' +
						'"cod_motivo": "CLINICO",' +
						'"nom_motivo": "CLINICO",' +
						'"mail": null,' +
						'"diag_codigo": "999",' +
						'"diag_nombre": "DIAGNOSTICO INDETERMINADO",' +
						'"complicaciones": "SIN COMPLICACIONES",' +
						'"grup_pres": null,' +
						'"gpres_nombre": null,' +
						'"nro_prestacion": "02430199",' +
						'"nom_prestacion": "INTERNACION CLINICA (FACTURAR CODIGO PENSION)",' +
						'"aut_previa": "1014009814",' +
						'"feem_codigo": null,' +
						'"feem_nombre": null,' +
						'"domi_entrega": null,' +
						'"agenia": null,' +
						'"otro_domi": null,' +
						'"via_entrega": null,' +
						'"domicilio": null,' +
						'"em_de_seguimiento": null,' +
						'"tipo_seg": null,' +
						'"nom_tipo_seg": null,' +
						'"estado_seg": null,' +
						'"desc_seg": null,' +
						'"cod_regla": "INT_CLI_1D",' +
						'"nom_regla": "INTERNACION CLINICA X 1 DIA",' +
						'"sistema": "ABIERTO",' +
						'"descr_em": "Descripción",' +
						'"nom_delegacion": "650098_ACA SALUD SUC. ROSARIO",' +
						'"obs_em": "Sin observaciones",' +
						'"afi_afi_id": "131224",' +
						'"apr_apr_id": "1014009814",' +
						'"check_mat": "V",' +
						'"check_presu": "F",' +
						'"importe_presu": "150.32",' +
						'"nro_sf": "2005",' +
						'"ap": [' +
							'{' +
								'"apr_id": "1014009814",' +
								'"fecha": "2020-02-05 00:00:00",' +
								'"conexion": "CX--MOST",' +
								'"nombre_conexion": "Mostrador",' +
								'"delegacion": "650098",' +
								'"nombre_delegacion": "650098_ACA SALUD SUC. ROSARIO",' +
								'"fecha_probable": "2020-02-05 00:00:00",' +
								'"estado": "CA-----A",' +
								'"nombre_estado": "CENTRO AUTORIZADOR",' +
								'"user_insert": "MAPPLICS",' +
								'"fecha_insert": "2020-02-05 09:07:34",' +
								'"codigo_afiliado": "51922/12",' +
								'"apellidos_afiliado": "TORRE",' +
								'"nombres_afiliado": " DANIEL JOSE",' +
								'"doc_afiliado": "DNI 13860713",' +
								'"evento_medico": "275751",' +
								'"fecha_prescripcion": "2019-09-27 00:00:00",' +
								'"diagnostico": "999",' +
								'"desc_diagnostico": "DIAGNOSTICO INDETERMINADO",' +
								'"prescriptor": "753415",' +
								'"nombre_prescriptor": "PARDO GUILLERMO MANUEL",' +
								'"prestador_dirige": "700076",' +
								'"nombre_prestador_dirige": "SANATORIO AMERICANO",' +
								'"prestador": "700076",' +
								'"nombre_prestador": "SANATORIO AMERICANO",' +
								'"consultorio": "1",' +
								'"nombre_consultorio": "CONSULTORIO PPAL SANAT AMERICANO",' +
								'"observaciones": "Autorizacion de evento medico 275751",' +
								'"mail": null,' +
								'"otros_mail": null,' +
								'"aca_agencia": null,' +
								'"tran_alta": null,' +
								'"tran_anulacion": null,' +
								'"ref_externa": null,' +
								'"urgente": null,' +
								'"afi_id": "131224",' +
								'"nro_sf": null,' +
								'"nivel": "N1",' +
								'"clasificacion": "BAJA COMPLEJIDAD",' +
								'"tipo_ap_sf": "CLINICO",' +
								'"ap_material": "F",' +
								'"ap_presupuesto": "F",' +
								'"prestaciones": [' +
									'{' +
										'"apr_id": "1014009814",' +
										'"estado_prestacion": "C1-----A",' +
										'"estado_descripcion": "EN AUDITORIA",' +
										'"contexto": "I",' +
										'"cantidad": "1",' +
										'"prestacion": "02430199",' +
										'"nombre_prestacion": "INTERNACION CLINICA (FACTURAR CODIGO PENSION)",' +
										'"tipo_prestacion": "N",' +
										'"troquel": null,' +
										'"grupo_prestacion": null,' +
										'"pca_id": "74042109",' +
										'"alerta": null,' +
										'"texto_aclarativo": null,' +
										'"alertas": [' +
											'{' +
												'"pca_pca_id": "74042109",' +
												'"aca_id": "16460534",' +
												'"cca_cca_id": null,' +
												'"control": "210",' +
												'"nombre_control": "PRESTACION CUBIERTA",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
												'"nivel_auditoria": "120",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:35",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'},' +
											'{' +
												'"pca_pca_id": "74042109",' +
												'"aca_id": "16460536",' +
												'"cca_cca_id": null,' +
												'"control": "424",' +
												'"nombre_control": "PRESCRIPCION VENCIDA",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "La prescripción esta vencida (tiene 60 días de vigencia) ",' +
												'"nivel_auditoria": "120",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:39",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'},' +
											'{' +
												'"pca_pca_id": "74042109",' +
												'"aca_id": "16460537",' +
												'"cca_cca_id": "74104931",' +
												'"control": "210",' +
												'"nombre_control": "PRESTACION CUBIERTA",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
												'"nivel_auditoria": "120",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:39",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'},' +
											'{' +
												'"pca_pca_id": "74042109",' +
												'"aca_id": "16460538",' +
												'"cca_cca_id": "74104932",' +
												'"control": "210",' +
												'"nombre_control": "PRESTACION CUBIERTA",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
												'"nivel_auditoria": "120",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:39",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'}' +
										']' +
									'}' +
								']' +
							'},' +
							'{' +
								'"apr_id": "1014009815",' +
								'"fecha": "2020-02-05 00:00:00",' +
								'"conexion": "CX--MOST",' +
								'"nombre_conexion": "Mostrador",' +
								'"delegacion": "650098",' +
								'"nombre_delegacion": "650098_ACA SALUD SUC. ROSARIO",' +
								'"fecha_probable": "2020-02-05 00:00:00",' +
								'"estado": "CA-----A",' +
								'"nombre_estado": "CENTRO AUTORIZADOR",' +
								'"user_insert": "MAPPLICS",' +
								'"fecha_insert": "2020-02-05 09:07:40",' +
								'"codigo_afiliado": "51922/12",' +
								'"apellidos_afiliado": "TORRE",' +
								'"nombres_afiliado": " DANIEL JOSE",' +
								'"doc_afiliado": "DNI 13860713",' +
								'"evento_medico": "275751",' +
								'"fecha_prescripcion": "2019-09-27 00:00:00",' +
								'"diagnostico": "999",' +
								'"desc_diagnostico": "DIAGNOSTICO INDETERMINADO",' +
								'"prescriptor": "753415",' +
								'"nombre_prescriptor": "PARDO GUILLERMO MANUEL",' +
								'"prestador_dirige": "700076",' +
								'"nombre_prestador_dirige": "SANATORIO AMERICANO",' +
								'"prestador": "700076",' +
								'"nombre_prestador": "SANATORIO AMERICANO",' +
								'"consultorio": "1",' +
								'"nombre_consultorio": "CONSULTORIO PPAL SANAT AMERICANO",' +
								'"observaciones": null,' +
								'"mail": null,' +
								'"otros_mail": null,' +
								'"aca_agencia": null,' +
								'"tran_alta": null,' +
								'"tran_anulacion": null,' +
								'"ref_externa": null,' +
								'"urgente": null,' +
								'"afi_id": "131224",' +
								'"nro_sf": null,' +
								'"nivel": "N1",' +
								'"clasificacion": "BAJA COMPLEJIDAD",' +
								'"tipo_ap_sf": "PRESTACION",' +
								'"ap_material": "V",' +
								'"ap_presupuesto": "F",' +
								'"prestaciones": [' +
									'{' +
										'"apr_id": "1014009815",' +
										'"estado_prestacion": "C1-----A",' +
										'"estado_descripcion": "EN AUDITORIA",' +
										'"contexto": "I",' +
										'"cantidad": "1",' +
										'"prestacion": "70503102",' +
										'"nombre_prestacion": "CODIGO PARA PRESUPUESTOS FRONT",' +
										'"tipo_prestacion": "N",' +
										'"troquel": null,' +
										'"grupo_prestacion": null,' +
										'"pca_id": "74042110",' +
										'"alerta": null,' +
										'"texto_aclarativo": null,' +
										'"alertas": [' +
											'{' +
												'"pca_pca_id": "74042110",' +
												'"aca_id": "16460539",' +
												'"cca_cca_id": null,' +
												'"control": "210",' +
												'"nombre_control": "PRESTACION CUBIERTA",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
												'"nivel_auditoria": "120",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:40",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'},' +
											'{' +
												'"pca_pca_id": "74042110",' +
												'"aca_id": "16460540",' +
												'"cca_cca_id": null,' +
												'"control": "PRESU_F",' +
												'"nombre_control": "CONTROL PRESUPUESTOS FRONT",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "Requiere Presupuesto",' +
												'"nivel_auditoria": "190",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:40",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'},' +
											'{' +
												'"pca_pca_id": "74042110",' +
												'"aca_id": "16460542",' +
												'"cca_cca_id": null,' +
												'"control": "424",' +
												'"nombre_control": "PRESCRIPCION VENCIDA",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "La prescripción esta vencida (tiene 60 días de vigencia) ",' +
												'"nivel_auditoria": "120",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:42",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'},' +
											'{' +
												'"pca_pca_id": "74042110",' +
												'"aca_id": "16460543",' +
												'"cca_cca_id": "74104933",' +
												'"control": "210",' +
												'"nombre_control": "PRESTACION CUBIERTA",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
												'"nivel_auditoria": "120",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:42",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'},' +
											'{' +
												'"pca_pca_id": "74042110",' +
												'"aca_id": "16460544",' +
												'"cca_cca_id": "74104934",' +
												'"control": "210",' +
												'"nombre_control": "PRESTACION CUBIERTA",' +
												'"funcion": "FCION_FRONT",' +
												'"texto_aclarativo": "La Prestación/Medicamento no está cubierta para el Afiliado",' +
												'"nivel_auditoria": "120",' +
												'"nota_auditor": null,' +
												'"observaciones": null,' +
												'"fecha_generacion": "2020-02-05 09:07:42",' +
												'"fecha_lectura": null,' +
												'"auditor_lee": null,' +
												'"fecha_resolucion": null,' +
												'"auditor_resuelve": null' +
											'}' +
										']' +
									'}' +
								']' +
							'}' +
						']' +
					'}' +
				'},' +
				'"meta": {' +
					'"allowed_includes": [],' +
					'"default_includes": []' +
				'}' +
			'}';
	}

	public static String getError() {
		return 
			'{' +
				'"data": {' +
					'"error": true,' +
					'"errors": {' +
						'"codigo_afiliado": [' +
							'"codigo afiliado es invalido."' +
						']' +
					'},' +
					'"errorType": "exception",' +
					'"httpCode": 422,' +
					'"message": "The given data was invalid.",' +
					'"debug_message": [],' +
					'"exception": "ValidationException",' +
//					'"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Http\\FormRequest.php",' +
					'"line": 126' +
				'}' +
			'}';
	}

	public static String getError500() {
		return
				'{' +
					'"data": {' +
						'"error": true,' +
						'"errors": {' +
							'"message": "Error 500."' +
						'},' +
						'"errorType": "exception",' +
						'"httpCode": 500,' +
						'"message": "Error 500.",' +
						'"debug_message": [],' +
						'"exception": "ValidationException",' +
//						'"file": "C:\\Apache24_64\\htdocs\\aca_salud_test\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Http\\FormRequest.php",' +
						'"line": 126' +
					'}' +
				'}';
	}

}