public class CaseValoracionBtnCtrl {
    
    @AuraEnabled
    public static Response getValoracionAfi(String caseId,String afi, String periodo){
        if(String.isBlank(caseId) || String.isBlank(afi) || String.isBlank(periodo)){
            return new Response(true, 'Los valores id de caso, codigo de afiliado y periodo no pueden estar vacios.');
        }
        List<Case> casos = [
          SELECT Cuota_bonificada_sin_iva__c,Valor_de_descuento__c,Otro_valor__c
          FROM Case
          WHERE Id = :caseId
        ];
        if(casos.isEmpty()){
            return new Response(true,'No existe un caso con el id ' + caseId);
        }
        Case casoAModificar = casos[0];
        WSCaseValoracion.Response resp = WSCaseValoracion.getValoracion(afi,periodo);
        Decimal descuento = 0;
       	Decimal porcentaje = 0;
		Decimal total = 0;

        if(!resp.hasError){
            switch on casoAModificar.Valor_de_descuento__c{
                when '5%'{
                    porcentaje = 0.05;
                }
                when '10%'{
                    porcentaje = 0.1;
                }
                when '15%'{
                    porcentaje = 0.15;
                }
                when '20%'{
                    porcentaje = 0.20;
                }
                when 'Otro'{
                    porcentaje = casoAModificar.Otro_valor__c / 100;
                }
                when else{
                    return new Response(true,'Descuento no seleccionado');
                }
            }

			for(WSCaseValoracionResp.Data data : resp.result.data) {
				total += Decimal.valueof(data.Importe);
			}

			casoAModificar.Cuota_actual__c = total;
            descuento = total * porcentaje;
            casoAModificar.Cuota_bonificada_sin_iva__c = total - descuento;

            //casoAModificar.Cuota_actual__c = Decimal.valueof(resp.result.data[0].Importe);
            //descuento = Decimal.valueof(resp.result.data[0].Importe) * porcentaje;
            //casoAModificar.Cuota_bonificada_sin_iva__c = Decimal.valueof(resp.result.data[0].Importe) - descuento;
            update casoAModificar;
            return new Response(false,'Valor de cuota bonificada sin iva actualizado.');
        }
        return new Response(true,resp.message);
    }
    
    public class Response {
		@AuraEnabled public Boolean hasError;
		@AuraEnabled public String message;

		public Response(Boolean hasError, String message){
			this.hasError = hasError;
			this.message = message;
		}
	}  

}