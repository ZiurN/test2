public class CoberturaEspecialQueueable implements Queueable, Database.AllowsCallouts {
	List<Cobertura_Especial__c> coberturas;

	public CoberturaEspecialQueueable(List<Cobertura_Especial__c> coberturasList) {
		coberturas = coberturasList;
	}

	public void execute(QueueableContext context) {
		User usuario = [SELECT Alias, CommunityNickname, Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
		String apodo = usuario.CommunityNickname != null ? usuario.CommunityNickname.toUpperCase() : null;

		if(!coberturas.isEmpty()) {
			Cobertura_Especial__c coberturaOriginal = coberturas.remove(0);
			//Cobertura_Especial__c cobertura = coberturaOriginal.clone(true,true,false,false);
			Cobertura_Especial__c cobertura = [
				SELECT Evento_Medico_de_Seguimiento__r.Nro_de_Evento_Medico_SS__c, Fecha_desde__c, Efector__r.Codigo_de_efector__c,
					Tipo_de_Copago__c, Incluye_Excluye__c, Prioridad__c, Valor__c, Tope_Mensual__c, Tope_Anual__c, 
					Nomenclador_Prestacion__r.Codigo__c, Fecha_hasta__c, Forma__r.Codigo_de_Forma__c, Potencia__c, Integracion__c,
					Marca_Lunes__c, Marca_Martes__c, Marca_Miercoles__c, Marca_Jueves__c, Marca_Viernes__c, Marca_Sabado__c, 
					Marca_Domingo__c, Dependencia__c, Id_externo__c, Prestador__r.Codigo_de_efector__c, Por_comprimido__c,
					Medicamento__r.Codigo_medicamento__c,Grupo_de_Prestaciones__r.Grupo__c, Grupo_de_Prestaciones__r.Codigo__c, Monodroga__r.Codigo_de_monodroga__c,  
					Consultorio__r.Secuencia__c, Accion_Grupo_Terapeutico__r.Codigo_Accion_Grupo_Terapeutico__c, Tipo__c,
					Tope_Semanal__c, Prescriptor__r.Codigo_de_efector__c, Diagnostico__r.Codigo_del_Diagnostico__c
				FROM Cobertura_Especial__c 
				WHERE Id =: coberturaOriginal.Id
			];
			String body = CoberturaEspecialTriggerHelper.generateJson(cobertura, apodo);

			WSCoberturaEspecialEnviar.Response resp = WSCoberturaEspecialEnviar.enviarCobertura(
				cobertura.Evento_Medico_de_Seguimiento__r.Nro_de_Evento_Medico_SS__c, body
			);

			System.debug(resp);
			if(!resp.hasError) {
				cobertura.Id_externo__c = resp.result.data.id_cobertura;
				cobertura.Error_en_SS__c = null;
				cobertura.Fecha_de_error_en_SS__c = null;
			}
			else {
				cobertura.Error_en_SS__c = '<p style="color: rgb(228, 10, 10);">' + resp.message + '</p>';
				cobertura.Fecha_de_error_en_SS__c = Datetime.now(); 
			}

			Database.SaveResult resultCobertura = Database.update(cobertura);
			System.debug('****resultCobertura: ' + resultCobertura);

			if(!coberturas.isEmpty()){
				System.enqueueJob(new CoberturaEspecialQueueable(coberturas));
			}
		}
	}
}