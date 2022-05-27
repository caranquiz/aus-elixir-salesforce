/**
 * Created by Ethan Sargent on 19/08/2021.
 */

public without sharing class CustomerPortalUserController
{
    @AuraEnabled
    public static Boolean isPasswordExpired()
    {
        return Site.isPasswordExpired();
    }

    @AuraEnabled
    public static String getUserEmail()
    {
        return UserInfo.getUserEmail();
    }

    @AuraEnabled
    public static String changePassword(String password, String confirmPassword, String oldPassword)
    {

        User u = [SELECT Id, Name, FirstName, LastName, Username FROM User WHERE Id = :UserInfo.getUserId()];
        try
        {
            if (!Test.isRunningTest()) Site.validatePassword(u, password, confirmPassword);
        }
        catch (Exception e)
        {
            return 'Your password does not meet our password requirements. Please ensure you follow the requirements listed above.';
        }
        String changePasswordResult;
        try {
             changePasswordResult = Site.changePassword(password, confirmPassword, oldpassword)?.getUrl();
        }
        catch(SecurityException e)
        {
            return 'Your old password is invalid. Please check your old password and try again.';
        }

        if (String.isBlank(changePasswordResult))
        {
            return 'Change password failed. Please check your old password and try again.';
        }

        return 'Success';
    }

    @AuraEnabled
    public static String getCommunityBaseUrl()
    {
        return Site.getBaseRequestUrl();
    }

    @AuraEnabled
    public static String getPasswordPolicy()
    {
        return Site.getPasswordPolicyStatement();
    }

    @AuraEnabled
    public static Boolean forgotPassword(String username)
    {
        Boolean success = false;
        List<User> users = [SELECT Id, Username, ContactId FROM User WHERE Username = :username AND IsActive = TRUE AND UserType NOT IN('Standard', 'CsnOnly')];
        if (username != null && users.size() == 1)
        {
            User u = users[0];
            Contact con = [SELECT Id FROM Contact WHERE Id = :u.ContactId];
//            ResetPasswordResult result = System.resetPassword(u.Id, true);
//            success = true;
            success = Site.forgotPassword(username);
            System.debug(success);
            if (success){ requireSecretQuestion(u.ContactId); }
        }
        return success;
    }

    @TestVisible
    @Future
    private static void requireSecretQuestion(id contactId)
    {
        Contact con = new Contact(Id = contactId, Portal_Answer_Secret_Next_Login__c = true);
        update con;
    }

    private static final Integer maxNumAttempts = 3;
    @AuraEnabled(Cacheable=false)
    public static SecurityQuestionInfo getSecurityQuestionInfo()
    {
        Contact con = [SELECT Id, Security_Question_Failure__c, Secret_Question__c FROM Contact WHERE Id IN (SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId())];
        if (con.Security_Question_Failure__c == null) con.Security_Question_Failure__c = 0;
        Integer attemptsLeft = (Integer) (maxNumAttempts - con.Security_Question_Failure__c);
        return new SecurityQuestionInfo(con.Secret_Question__c, attemptsLeft);
    }

    @AuraEnabled
    public static ChangePasswordResponse changePasswordStrongAuth(String password, String confirmPassword, String oldPassword, String securityQuestionAnswer)
    {
        User u = [SELECT Id, Name, FirstName, LastName, Username, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        Contact con = [SELECT Id, Security_Question_Failure__c, Portal_Secret_Question_Answer__c, Secret_Question__c FROM Contact WHERE Id = :u.ContactId];
        if (con.Security_Question_Failure__c == null) con.Security_Question_Failure__c = 0;
        Integer attemptsLeft = (Integer) (maxNumAttempts - con.Security_Question_Failure__c);
        if (attemptsLeft <= 0) return new ChangePasswordResponse(con.Secret_Question__c, attemptsLeft, 'You cannot change your password at this time due to too many failed password change attempts. Please call ORDE Customer Service on 13 67 33 to reset your password.');
        try
        {
            if (!Test.isRunningTest()) Site.validatePassword(u, password, confirmPassword);
        }
        catch (Exception e)
        {
            return new ChangePasswordResponse(con.Secret_Question__c, attemptsLeft, 'Your password does not meet our password requirements. Please ensure you follow the requirements listed above.');
        }

        Boolean oldPasswordValid;
        try
        {
            Site.login(u.Username, oldPassword, '');
            oldPasswordValid = true;
        }
        catch(SecurityException e)
        {
            oldPasswordValid = false;
        }
        if (!oldPasswordValid)
        {
            return new ChangePasswordResponse(con.Secret_Question__c, attemptsLeft, 'Your old password is invalid. Please check your old password and try again.');
        }

        // Only check security question if password requirements are met and old password is correct
        if (con.Portal_Secret_Question_Answer__c != securityQuestionAnswer)
        {
            con.Security_Question_Failure__c += 1;
            attemptsLeft -=1;
            update con;
            return new ChangePasswordResponse(con.Secret_Question__c, attemptsLeft, 'The answer to your security question is incorrect. Attempts remaining before lockout: ' + attemptsLeft);
        }

        String changePasswordResult;
        try {
            changePasswordResult = Site.changePassword(password, confirmPassword, oldpassword)?.getUrl();
        }
        catch(SecurityException e)
        {
            return new ChangePasswordResponse(con.Secret_Question__c, attemptsLeft, 'Your old password is invalid. Please check your old password and try again.');
        }
        if (String.isBlank(changePasswordResult))
        {
            return new ChangePasswordResponse(con.Secret_Question__c, attemptsLeft, 'Change password failed. Please check your old password and try again.');
        }




        return new ChangePasswordResponse(null, null, null);
    }


    public class SecurityQuestionInfo
    {
        @AuraEnabled
        public String question {get; set;}

        @AuraEnabled
        public Integer attemptsLeft {get; set;}

        @AuraEnabled
        public Boolean isLockedOut {get {return attemptsLeft != null && attemptsLeft > 0;}}

        public SecurityQuestionInfo(String questionText, Integer attemptsLeft)
        {
            this.question = questionText;
            this.attemptsLeft = attemptsLeft;
        }
    }

    public class ChangePasswordResponse
    {
        @AuraEnabled
        public SecurityQuestionInfo securityInfo {get; set;}

        @AuraEnabled
        public String errorMessage {get; set;}

        @AuraEnabled
        public Boolean isSuccess {get{return String.isBlank(errorMessage);}}

        public ChangePasswordResponse(String questionText, Integer attemptsLeft, String errorMessage)
        {
            this.securityInfo = new SecurityQuestionInfo(questionText, attemptsLeft);
            this.errorMessage = errorMessage;
        }

    }
}