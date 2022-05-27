/**
 * Created by Ethan Sargent on 27/08/2021.
 */

@IsTest
private class CustomerPortalUserControllerTest
{

    @TestSetup
    static void setup()
    {

    }

    @IsTest
    static void testChangePassword()
    {
        // Arrange
        Profile p = [SELECT Id FROM Profile WHERE UserLicense.Name = 'Guest User License' LIMIT 1];

        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='argo@ordefinancial-portalTest1.com');

        insert u;

        // Act
        Test.startTest();
        CustomerPortalUserController.changePassword('test password', 'test password', null);
        Test.stopTest();
        // Assert

    }

    @IsTest
    static void testGetRequestUrl()
    {
        Test.startTest();
        String baseUrl = CustomerPortalUserController.getCommunityBaseUrl();
        Test.stopTest();
        System.debug(baseUrl);
    }

    @IsTest
    static void testGetPasswordPolicy()
    {
        Test.startTest();

        String passwordPolicy = CustomerPortalUserController.getPasswordPolicy();
        Test.stopTest();
        System.debug(passwordPolicy);
    }

    @IsTest
    static void testIsPasswordExpired()
    {
        Test.startTest();
        Boolean expiredPassword = CustomerPortalUserController.isPasswordExpired();
        Test.stopTest();
        System.assertEquals(false, expiredPassword);
    }

    @IsTest
    static void testGetUserEmail()
    {

        Test.startTest();
        String userEmail = CustomerPortalUserController.getUserEmail();
        Test.stopTest();
        System.assertEquals(UserInfo.getUserEmail(), userEmail);
    }

    @IsTest
    static void testChangePasswordStrongAuth()
    {
        // Arrange
        String securityQuestionAnswer = 'test answer';
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Orde Customer Community Login User' LIMIT 1];
        RecordType personType = [SELECT Id FROM RecordType WHERE IsPersonType = TRUE AND IsPersonType = TRUE LIMIT 1];
        Account acc = new Account(RecordTypeId = personType.Id, FirstName = 'Contact', LastName = 'Test', Secret_Question__pc = 'In what city were you born?', Security_Question_Failure__pc = 0, Portal_Answer_Secret_Next_Login__pc = true, Portal_Secret_Question_Answer__pc = securityQuestionAnswer);
        insert acc;
        acc = [SELECT Id, PersonContactId FROM Account WHERE Id = :acc.Id];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', Username='argo@ordefinancial-portalTest1.com', ContactId = acc.PersonContactId);

        insert u;

        // Act
        Test.startTest();
        System.runAs(u)
        {
            CustomerPortalUserController.changePasswordStrongAuth('test password', 'test password', null, securityQuestionAnswer);
        }

        Test.stopTest();
        // Assert

    }

    @IsTest
    static void testChangePasswordStrongWrongAnswer()
    {
        // Arrange
        String securityQuestionAnswer = 'test answer';
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Orde Customer Community Login User' LIMIT 1];
        RecordType personType = [SELECT Id FROM RecordType WHERE IsPersonType = TRUE AND IsPersonType = TRUE LIMIT 1];
        Account acc = new Account(RecordTypeId = personType.Id, FirstName = 'Contact', LastName = 'Test', Secret_Question__pc = 'In what city were you born?', Security_Question_Failure__pc = 0, Portal_Answer_Secret_Next_Login__pc = true, Portal_Secret_Question_Answer__pc = securityQuestionAnswer);
        insert acc;
        acc = [SELECT Id, PersonContactId FROM Account WHERE Id = :acc.Id];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', Username='argo@ordefinancial-portalTest1.com', ContactId = acc.PersonContactId);

        insert u;

        // Act
        Test.startTest();
        System.runAs(u)
        {
            CustomerPortalUserController.changePasswordStrongAuth('test password', 'test password', null, 'securityQuestionAnswer');
        }

        Test.stopTest();
        // Assert

    }

    @IsTest
    static void testForgotPassword()
    {
        // Arrange
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Orde Customer Community Login User' LIMIT 1];
        RecordType personType = [SELECT Id FROM RecordType WHERE IsPersonType = TRUE AND IsPersonType = TRUE LIMIT 1];
        Account acc = new Account(RecordTypeId = personType.Id, FirstName = 'Contact', LastName = 'Test', Secret_Question__pc = 'In what city were you born?', Security_Question_Failure__pc = 0, Portal_Answer_Secret_Next_Login__pc = true);
        insert acc;
        acc = [SELECT Id, PersonContactId FROM Account WHERE Id = :acc.Id];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', Username='argo@ordefinancial-portalTest1.com', ContactId = acc.PersonContactId);

        insert u;


        // Act
        Test.startTest();
        System.runAs(u)
        {
            CustomerPortalUserController.forgotPassword('argo@ordefinancial-portalTest1.com');
        }
        Test.stopTest();
        // Assert

    }

    @IsTest
    static void testRequireSecretQuestion ()
    {
        // Arrange
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Orde Customer Community Login User' LIMIT 1];
        RecordType personType = [SELECT Id FROM RecordType WHERE IsPersonType = TRUE AND IsPersonType = TRUE LIMIT 1];
        Account acc = new Account(RecordTypeId = personType.Id, FirstName = 'Contact', LastName = 'Test', Secret_Question__pc = 'In what city were you born?', Security_Question_Failure__pc = 0, Portal_Answer_Secret_Next_Login__pc = true);
        insert acc;
        acc = [SELECT Id, PersonContactId FROM Account WHERE Id = :acc.Id];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', Username='argo@ordefinancial-portalTest1.com', ContactId = acc.PersonContactId);

        insert u;

        // Act
        Test.startTest();
        System.runAs(u)
        {
            CustomerPortalUserController.requireSecretQuestion(acc.PersonContactId);
        }
        Test.stopTest();
        // Assert

    }

    @IsTest
    static void testGetSecurityQuestionInfo()
    {
        // Arrange
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Orde Customer Community Login User' LIMIT 1];
        RecordType personType = [SELECT Id FROM RecordType WHERE IsPersonType = TRUE AND IsPersonType = TRUE LIMIT 1];
        Account acc = new Account(RecordTypeId = personType.Id, FirstName = 'Contact', LastName = 'Test', Secret_Question__pc = 'In what city were you born?', Security_Question_Failure__pc = 0, Portal_Answer_Secret_Next_Login__pc = true);
        insert acc;
        acc = [SELECT Id, PersonContactId FROM Account WHERE Id = :acc.Id];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', Username='argo@ordefinancial-portalTest1.com', ContactId = acc.PersonContactId);

        insert u;



        String securityQuestionAnswer = 'test answer';
        // Act
        Test.startTest();
        System.runAs(u)
        {
            CustomerPortalUserController.getSecurityQuestionInfo();
        }
        Test.stopTest();
        // Assert

    }
}