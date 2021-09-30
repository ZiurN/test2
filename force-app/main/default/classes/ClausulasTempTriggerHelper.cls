public class ClausulasTempTriggerHelper {
    public static void sendToSSAndFillFields(List<Asignacion_de_clausula_temporaria__c> clausulas) {
		  System.enqueueJob(new ClausulaTempQueueable(clausulas));
    }

    public static Asignacion_de_clausula_temporaria__c updateClausula(Asignacion_de_clausula_temporaria__c clausula){
      User usuario = [SELECT Alias, CommunityNickname, Profile.Name FROM User WHERE Id =: clausula.CreatedById];
      String apodo = usuario.CommunityNickname.toUpperCase();
	  String fechaHasta;

	  if(clausula.codigo_ACT_SS__c == null) {
		fechaHasta = clausula.Fecha_de_vigencia_hasta__c != null ? String.valueOf(clausula.Fecha_de_vigencia_hasta__c) : null;
	  } else {
		fechaHasta = clausula.Fecha_de_cierre_de_clausula__c != null 
						? String.valueOf(clausula.Fecha_de_cierre_de_clausula__c) : null;
	  }

      Map<String, Object> jsonMap = new Map<String,Object>{
        'usuario' => apodo,
        'fecha_desde' => clausula.Fecha_desde__c != null ? String.valueOf(clausula.Fecha_desde__c) : null,
        'fecha_hasta' => fechaHasta,
        'codigo_afiliado' => clausula.Codigo_Asociado__c
      };

	  if(clausula.codigo_ACT_SS__c != null) {
		jsonMap.put('acta_id', clausula.codigo_ACT_SS__c);
	  }
	  //else {
		//jsonMap.put('fecha_desde', clausula.Fecha_desde__c != null ? String.valueOf(clausula.Fecha_desde__c) : null);
	  //}

	  String body = JSON.serialize(jsonMap);

      System.debug('body to sendClausula:  ' + body);
      WSClausulaTempEnviarASS.Response resp = WSClausulaTempEnviarASS.sendClausulaTempToSS(body);
      Asignacion_de_clausula_temporaria__c clon = new Asignacion_de_clausula_temporaria__c (Id = clausula.Id);
  
      if(!resp.hasError){
        clon.codigo_ACT_SS__c = resp.clausula.data.acta_id != null ? String.valueOf(resp.clausula.data.acta_id) : null;
        clon.Fallo_en_SS__c = null;
        clon.Fecha_de_fallo__c = null; 
      }
      else{
        clon.Fallo_en_SS__c = resp.message;
        clon.Fecha_de_fallo__c = Datetime.now(); 
      }

      return clon;
    }
}