public class BasicResponse  {
	@AuraEnabled public Boolean hasError;
    @AuraEnabled public String message;

    public BasicResponse(Boolean hasError, String message){
        this.hasError = hasError;
        this.message = message;
    }
}