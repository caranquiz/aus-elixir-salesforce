/*******************************************************************************
Description: This class contains regular expression for different fields 
Developer: Deep Bhattacharjee

*******************************************************************************/

public class ValidationUtilClass{
    public static Boolean firstNameValidate(String firstName){
        String firstNameRegex = '^[A-Za-z\'-]+$';
        return Pattern.compile(firstNameRegex).matcher(firstName).matches();
    } 
    public static Boolean lastNameValidate(String lastName){
        String lastNameRegex = '^[A-Za-z\'-]+$';
        return Pattern.compile(lastNameRegex).matcher(lastName).matches();
    } 
    public static Boolean middleNameValidate(String middleName){
        String middleNameRegex = '^[A-Za-z\'-]+$';
        return Pattern.compile(middleNameRegex).matcher(middleName).matches();
    } 
    public static Boolean emailValidate(String email){
        String emailRegex = '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[a-zA-Z]{2,4}+$';
        return Pattern.compile(emailRegex).matcher(email).matches();
    }
    public static Boolean passValidate(String pass){
        String passRegex = '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[#$@!%&*?])[A-Za-z0-9#$@!%&*?]{6,14}+$';
        return Pattern.compile(passRegex).matcher(pass).matches();
    }
    public static Boolean mobileValidate(String mobile){
        String mobileRegex = '^[0-9]{10}+$';
        return Pattern.compile(mobileRegex).matcher(mobile).matches();
    }    
}