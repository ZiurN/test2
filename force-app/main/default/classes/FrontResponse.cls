/*------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz
@company		Xappia
@description	Clase padre para generar respuestas al front desde Apex.
------------------------------------------------------------------------------------------------------------------*/
public virtual class FrontResponse {
	@AuraEnabled public Boolean hasError;
	@AuraEnabled public auraMessage auraMessage;
	public class auraMessage {
		@AuraEnabled public String message {get; set;}
		@AuraEnabled public String status {get; set;}
		public auraMessage(String message, String status) {
			this.message = message;
			this.status = status;
		}
	}
}