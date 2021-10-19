public without sharing class TelefonoHelper {


    public static Boolean isValidPhone(String phone) {
        return Pattern.matches('[0-9(),./\\-]+', phone) && phone.length() == 10 && !TelefonoHelper.have15BeforeValue(phone) &&  !phone.contains('-');      
    }

    public static Boolean have15BeforeValue(String mobilePhone) {
        return mobilePhone.startsWith('15');
    }
}