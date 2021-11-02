@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class CoberturaEspecialTriggerHelper {
	public static void reintentoEnvio(List<Cobertura_Especial__c> coberturas) {
		List<Cobertura_Especial__c> coberturasToUpdate = new List<Cobertura_Especial__c>();
		for(Cobertura_Especial__c cobertura : coberturas) {
			String apodo = cobertura.CreatedBy.CommunityNickname != null
							? cobertura.CreatedBy.CommunityNickname.toUpperCase() : null;
			coberturasToUpdate.add( resendToSS( cobertura.Id, apodo ) );
		}
		update coberturasToUpdate;
	}
	private static Cobertura_Especial__c resendToSS(Id coberturaId, String apodo) {
		List<Cobertura_Especial__c> coberturas = [SELECT Evento_Medico_de_Seguimiento__r.Nro_de_Evento_Medico_SS__c, Fecha_desde__c, Efector__r.Codigo_de_efector__c,
				Tipo_de_Copago__c, Incluye_Excluye__c, Prioridad__c, Valor__c, Tope_Mensual__c, Tope_Anual__c,
				Nomenclador_Prestacion__r.Codigo__c, Fecha_hasta__c, Forma__r.Codigo_de_Forma__c, Potencia__c, Integracion__c,
				Marca_Lunes__c, Marca_Martes__c, Marca_Miercoles__c, Marca_Jueves__c, Marca_Viernes__c, Marca_Sabado__c,
				Marca_Domingo__c, Dependencia__c, Id_externo__c, Prestador__r.Codigo_de_efector__c, Por_comprimido__c,
				Medicamento__r.Codigo_medicamento__c, Grupo_de_Prestaciones__r.Codigo__c, Monodroga__r.Codigo_de_monodroga__c,
				Consultorio__r.Secuencia__c, Accion_Grupo_Terapeutico__r.Codigo_Accion_Grupo_Terapeutico__c, Tipo__c,
				Tope_Semanal__c, Prescriptor__r.Codigo_de_efector__c, Diagnostico__r.Codigo_del_Diagnostico__c
			FROM Cobertura_Especial__c
			WHERE Id =: coberturaId];
		String body = generateJson(coberturas[0], apodo);
		WSCoberturaEspecialEnviar.Response resp = WSCoberturaEspecialEnviar.enviarCobertura(
			coberturas[0].Evento_Medico_de_Seguimiento__r.Nro_de_Evento_Medico_SS__c, body
		);
		if(!resp.hasError) {
			coberturas[0].Id_externo__c = resp.result.data.id_cobertura;
			coberturas[0].Error_en_SS__c = null;
			coberturas[0].Fecha_de_error_en_SS__c = null;
		}
		else {
			coberturas[0].Error_en_SS__c = '<p style="color: rgb(228, 10, 10);">' + resp.message + '</p>';
			coberturas[0].Fecha_de_error_en_SS__c = Datetime.now();
		}
		return coberturas[0];
	}
	public static String generateJson(Cobertura_Especial__c cobertura, String apodo) {
		String body;
		Map<String,Object> jsonMap = new Map<String, Object> {
			'dependencia' => cobertura.Dependencia__c,
			'marca_domingo' => cobertura.Marca_Domingo__c,
			'marca_sabado' => cobertura.Marca_Sabado__c,
			'marca_viernes' => cobertura.Marca_Viernes__c,
			'marca_jueves' => cobertura.Marca_Jueves__c,
			'marca_miercoles' => cobertura.Marca_Miercoles__c,
			'marca_martes' => cobertura.Marca_Martes__c,
			'marca_lunes' => cobertura.Marca_Lunes__c,
			'consultorio' => cobertura.Consultorio__r.Secuencia__c != null ? String.valueOf(cobertura.Consultorio__r.Secuencia__c) : null,
			'prestador' => cobertura.Prestador__r.Codigo_de_efector__c,
			'integracion' => cobertura.Integracion__c,
			'potencia' => cobertura.Potencia__c,
			'por_comprimido' => cobertura.Por_comprimido__c,
			'forma' => cobertura.Forma__r.Codigo_de_Forma__c,
			'fecha_fin_vigencia' => cobertura.Fecha_hasta__c != null ? String.valueOf(cobertura.Fecha_hasta__c) : null,
			'usuario' => apodo,
			'tope_anual' => cobertura.Tope_Anual__c,
			'tope_mensual' => cobertura.Tope_Mensual__c,
			'cant_semanal' => cobertura.Tope_Semanal__c != null ? String.valueOf(cobertura.Tope_Semanal__c) : null,
			'valor' => cobertura.Valor__c,
			'prioridad' => cobertura.Prioridad__c != null ? Integer.valueOf(cobertura.Prioridad__c) : null,
			'incluye_excluye' => cobertura.Incluye_Excluye__c,
			'tipo_copago' => cobertura.Tipo_de_Copago__c,
			'efector_codigo' => cobertura.Prescriptor__r.Codigo_de_efector__c,
			'efector' => cobertura.Efector__r.Codigo_de_efector__c,
			'diag_codigo' => cobertura.Diagnostico__r.Codigo_del_Diagnostico__c,
			'fecha_desde' => cobertura.Fecha_desde__c != null ? String.valueOf(cobertura.Fecha_desde__c) : null
		};
		if(String.isNotBlank(cobertura.Id_externo__c)) {
			jsonMap.put('id_cobertura', cobertura.Id_externo__c);
		}
		switch on cobertura.Tipo__c{
			when 'Nomenclador'{
				jsonMap.put('nom_prestacion', cobertura.Nomenclador_Prestacion__r.Codigo__c);
			}
			when 'Monodroga'{
				jsonMap.put('monodroga', cobertura.Monodroga__r.Codigo_de_monodroga__c);
			}
			when 'Grupo Prestaciones'{
				jsonMap.put('grupo_prestaciones', cobertura.Grupo_de_Prestaciones__r.Grupo__c);
			}
			when 'Medicamento'{
				jsonMap.put('codigo_medicamento', cobertura.Medicamento__r.Codigo_medicamento__c);
			}
			when 'Grupo Terapeutico'{
				jsonMap.put('grupo_terapeutico', cobertura.Accion_Grupo_Terapeutico__r.Codigo_Accion_Grupo_Terapeutico__c);
			}
		}
		body = JSON.serialize(jsonMap);
		return body;
	}
	public static Boolean isChangedSomeFieldToSendToSS(Cobertura_Especial__c cobertura, Cobertura_Especial__c oldCobertura) {
		return cobertura.Dependencia__c != oldCobertura.Dependencia__c
				|| cobertura.Marca_Domingo__c != oldCobertura.Marca_Domingo__c
				|| cobertura.Marca_Sabado__c != oldCobertura.Marca_Sabado__c
				|| cobertura.Marca_Viernes__c != oldCobertura.Marca_Viernes__c
				|| cobertura.Marca_Jueves__c != oldCobertura.Marca_Jueves__c
				|| cobertura.Marca_Miercoles__c != oldCobertura.Marca_Miercoles__c
				|| cobertura.Marca_Martes__c != oldCobertura.Marca_Martes__c
				|| cobertura.Marca_Lunes__c != oldCobertura.Marca_Lunes__c
				|| cobertura.Consultorio__c != oldCobertura.Consultorio__c
				|| cobertura.Prestador__c != oldCobertura.Prestador__c
				|| cobertura.Integracion__c != oldCobertura.Integracion__c
				|| cobertura.Potencia__c != oldCobertura.Potencia__c
				|| cobertura.Por_comprimido__c != oldCobertura.Por_comprimido__c
				|| cobertura.Forma__c != oldCobertura.Forma__c
				|| cobertura.Fecha_hasta__c != oldCobertura.Fecha_hasta__c
				|| cobertura.Tope_Anual__c != oldCobertura.Tope_Anual__c
				|| cobertura.Tope_Mensual__c != oldCobertura.Tope_Mensual__c
				|| cobertura.Tope_Semanal__c != oldCobertura.Tope_Semanal__c
				|| cobertura.Valor__c != oldCobertura.Valor__c
				|| cobertura.Prioridad__c != oldCobertura.Prioridad__c
				|| cobertura.Incluye_Excluye__c != oldCobertura.Incluye_Excluye__c
				|| cobertura.Tipo_de_Copago__c != oldCobertura.Tipo_de_Copago__c
				|| cobertura.Prescriptor__c != oldCobertura.Prescriptor__c
				|| cobertura.Efector__c != oldCobertura.Efector__c
				|| cobertura.Fecha_desde__c != oldCobertura.Fecha_desde__c
				|| cobertura.Medicamento__c != oldCobertura.Medicamento__c
				|| cobertura.Diagnostico__c != oldCobertura.Diagnostico__c;
	}
	public static void avoidDeletionOfSentCoberturas(List<Cobertura_Especial__c> coberturas) {
		List<Cobertura_Especial__c> coberturasInSS = new List<Cobertura_Especial__c>();
		for (Cobertura_Especial__c cobertura : coberturas) {
			if(String.isNotBlank(cobertura.Id_externo__c)) {
				coberturasInSS.add(cobertura);
			}
		}
		for (Cobertura_Especial__c cobertura : coberturasInSS) {
			cobertura.addError(System.Label.Error_NoPuedeEliminarCoberturaEnviadaSS);
		}
	}
}