public with sharing class UtilsDisplayErrorMessageFromWS {
//    public String msg;

    //public static String showMessagesFromErrorsMap(Map<String, Object> errors) {
        //String msg = '';
        
        //if(errors.containsKey('message') && String.isNotBlank(errors.get('message').toString())) {
            //msg = errors.get('message').toString();
        //} else {
            //for (String key : errors.keySet()) {
                //List<Object> error = (List<Object>) errors.get(key);
                //msg = msg +  error[0].toString() + '\n';
            //}
        //}
        //return msg;
    //}

	public static String showMessagesFromErrorsMap(Map<String, Object> errors) {
        String msg = '';
        
		try {
			if(errors.containsKey('message') && String.isNotBlank(errors.get('message').toString())) {
                msg = errors.get('message').toString();
                try {
                    if(errors.containsKey('debug_message')) {
                        Map<String, Object> debug_msg = (Map<String, Object>) errors.get('debug_message');
                        if(debug_msg.containsKey('Error')) {
                            msg += debug_msg.get('Error').toString();
                        }
                    }
                } catch (Exception e) {

                }                
			} else {
				for (String key : errors.keySet()) {
					List<Object> error = (List<Object>) errors.get(key);
					msg = msg +  error[0].toString() + '\n';
				}
			}
			return msg;
		} 
		catch(Exception e) {
			System.debug(e);
			return null;
		}
    }

    public static String showMessagesFromErrorsList(List<Object> errors) {
        String msg = '';

        for (Object error : errors) {
            msg = msg + error.toString() + '\n';
        }

        return msg;
    }

    public static String showErrorMessage(Map<String,Object> body) {
        String msg = '';
        Map<String,Object> data = (Map<String,Object>) body.get('data');
        Map<String, Object> errorsMap = new Map<String, Object>();
        List<Object> errorsList = new List<Object>();
        Boolean errorsIsAMap = false;

        try {
            errorsMap = (Map<String,Object>) data.get('errors');
            errorsIsAMap = true;
        } catch (Exception ex) {
            System.debug(ex);
        }

        if(errorsIsAMap) {
            errorsMap = (Map<String, Object>) data.get('errors');
        } else {
            errorsList = (List<Object>) data.get('errors');
        }

        if(data.get('httpCode') == 500) {
            msg = data.get('message').toString();
        } else if(errorsIsAMap && !errorsMap.isEmpty()) {
            msg = showMessagesFromErrorsMap(errorsMap);
			
			if(msg == null) {
				msg = data.get('message').toString();
			}

        } else if(!errorsIsAMap && !errorsList.isEmpty()) {
            msg = showMessagesFromErrorsList(errorsList);
        } else {
            msg = data.get('message').toString();
        }

        return msg;
    }
}