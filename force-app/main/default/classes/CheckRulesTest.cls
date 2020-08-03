/**********************************************************************************************************************************************************
Description : This class the Test class for CheckRules Apex Class.
Scenarios Tested : 1) Method calling with application id
                   2) Method calling without application id
***********************************************************************************************************************************************************/
@isTest
private class CheckRulesTest {
    @testSetup
    static void setup() {
        List<genesis__Rule__c> ruleList = GenericUtilityTestHelper.returnRule();
        List<genesis__Rule__c> getRuleList = [SELECT Id, Name FROM genesis__Rule__c WHERE genesis__Enabled__c = true LIMIT 3];
        System.assert(ruleList[0].Name == 'Rule One', 'Rule was not inserted.');

        clcommon__Legal_Entity__c legalEntity = GenericUtilityTestHelper.returnLegalEntity();
        List<clcommon__Legal_Entity__c> legalEntityList = [SELECT Id, Name FROM clcommon__Legal_Entity__c WHERE Name = 'Individual' LIMIT 1];
        System.assert(legalEntityList[0].Name == 'Individual','Legal Entity was not inserted.');

        Account accountDetails = GenericUtilityTestHelper.returnBorrowerAccount(legalEntity.Id);
        List<Account> accountDetailsList = [SELECT Id, Name FROM Account WHERE Name = 'Dummy Account' LIMIT 1];
        System.assert(accountDetailsList[0].Name == 'Dummy Account','Borrower Account was not inserted.');

        clcommon__CL_Product__c clProduct = GenericUtilityTestHelper.returnClProduct();
        List<clcommon__CL_Product__c> clProductList = [SELECT Id, clcommon__Product_Name__c FROM clcommon__CL_Product__c WHERE clcommon__Product_Name__c = 'Residential' LIMIT 1];
        System.assert(clProductList[0].clcommon__Product_Name__c == 'Residential','CL Product was not inserted.');

        genesis__Applications__c applicationDetails = GenericUtilityTestHelper.insertApplication(accountDetails.Id,clProduct.Id);
        List<genesis__Applications__c> applicationDetailsList = [SELECT Id, genesis__Loan_Amount__c FROM genesis__Applications__c WHERE genesis__Loan_Amount__c = 150000 LIMIT 1];
        System.assert(applicationDetailsList[0].genesis__Loan_Amount__c == 150000,'Application was not inserted.');
    }

    //This method is for when the application id is not equal to null
    @isTest
    static void testMethod1() {
        List<genesis__Applications__c> applicationDetailsList = [SELECT Id, genesis__Loan_Amount__c FROM genesis__Applications__c LIMIT 1];
        System.assert(applicationDetailsList[0].genesis__Loan_Amount__c == 150000,'Application was not inserted.');

        Test.startTest();
        String returnValue = CheckRules.callCheckRulesWS(
        applicationDetailsList[0].Id
        );
        Test.stopTest();
        System.assertEquals(ConstantValues.Success,returnValue,'Success');
    }

    //This method is for when the application id is equal to null
    @isTest
    static void testMethod2() {
        Test.startTest();
        String returnValue = CheckRules.callCheckRulesWS(null);
        Test.stopTest();
        System.assertEquals(ConstantValues.CHECKRULES_APPLICATION_ID_NULL,returnValue,'Success');
    }
}
