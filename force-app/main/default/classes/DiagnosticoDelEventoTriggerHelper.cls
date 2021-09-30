public class DiagnosticoDelEventoTriggerHelper {
    public static String generateJson(Diagnostico_del_Evento__c diagnostico, String apodo) {
		String body;

		Map<String,Object> jsonMap = new Map<String, Object> {
			'usuario' => apodo,
            'fecha' => diagnostico.Fecha__c != null ? diagnostico.Fecha__c.format() : '',
            'diagnostico' => diagnostico.Diagnostico__r.Codigo_del_Diagnostico__c,
            'tipo_diagnostico' => diagnostico.Tipo__c
		};
		body = JSON.serialize(jsonMap);

		return body;
	}
}