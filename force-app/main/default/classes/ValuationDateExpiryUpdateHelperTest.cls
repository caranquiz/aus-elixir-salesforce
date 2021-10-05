/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class give coverage to UpdateValueDateTrigger and UpdateValuationDateExpiry and
                ValuationDateExpiryUpdateHelper.
Development Date : 31/08/2021
Last Modified Date : 31/08/2021
****************************************************************************************************/ 

@isTest(SeeAllData=false)
public class ValuationDateExpiryUpdateHelperTest {
    @TestSetup
    static void initialize(){
        //Inserting legal entity
        clcommon__Legal_Entity__c legEntity = GenericUtilityTestHelper.returnLegalEntity();
        System.AssertNotEquals(
            legEntity.Id,
            null,
            ' Legal Entity inserted successfully.'
        );
        
        //Inserting Account
        Account testAccount = GenericUtilityTestHelper.insertDummyAccount();
        testAccount.clcommon__Legal_Entity_Type__c=legEntity.Id;
        update testAccount;
        List<Account> testAccountList=[SELECT id 
                                        FROM Account 
                                        WHERE clcommon__Legal_Entity_Type__r.Name=:ConstantValues.indType 
                                        LIMIT 1];
        System.AssertNotEquals(
         testAccount.Id,
         null,
        ' Account inserted successfully.'
        );
        
        //Inserting Application
        genesis__applications__c testApplication=GenericUtilityTestHelper.returnApplication(testAccount.id);
        System.AssertNotEquals(
            testApplication.Id,
            null,
            'Application inserted successfully'
        );
        //Inserting Collateral
        clcommon__Collateral__c testcollateral=GenericUtilityTestHelper.getCollateral(
            '21',
            '213',
            'Princes',
            'Hwy', 
            'ARNCLIFFE',
            'NSW', 
            '2205'
        );
        testcollateral.Primary_Usage__c='Residential';
        update testcollateral;
        System.AssertNotEquals(
            testcollateral.Id,
            null,
            'Collateral inserted successfully'
        );
        //Inserting Application Collateral
        genesis__Application_Collateral__c testApplicationColl=GenericUtilityTestHelper.insertApplicationCollateral(
            testApplication.id,
            testcollateral.id
        );
        System.AssertNotEquals(
            testApplicationColl.Id,
            null,
            'Application Collateral inserted successfully'
        );
    }
    @isTest
    static void collateralTest(){
        test.startTest();
        clcommon__Collateral__c collateral=[SELECT id,clcommon__Value_Date__c,Primary_Usage__c FROM clcommon__Collateral__c];
        collateral.Primary_Usage__c='Commercial';
        collateral.clcommon__Value_Date__c=Date.newInstance(2020, 12, 12);
        update collateral;
        test.stopTest();
        
    } 
    @IsTest
    static void applicationcollTest(){
        test.startTest();
        List<genesis__Application_Collateral__c> applicationColl=[SELECT id,genesis__Application__c,genesis__Collateral__c FROM genesis__Application_Collateral__c];
        delete applicationColl;
        test.stopTest();
    }
    @isTest
    static void applicationTest(){
        test.startTest();
        genesis__applications__c application=[SELECT id,genesis__Loan_Amount__c FROM genesis__applications__c];
        application.genesis__Loan_Amount__c=650000;
        application.Document_Type__c='Full Doc';
        application.Actual_Security_Value__c=1000000;
        application.Risk_grade_list__c='Specialist';
        update application;
        test.stopTest();
    }
    @isTest
    static void applicationTest1(){
        test.startTest();
        genesis__applications__c application=[SELECT id,genesis__Loan_Amount__c FROM genesis__applications__c];
        application.genesis__Loan_Amount__c=1050000;
        application.Document_Type__c='Full Doc';
        application.Actual_Security_Value__c=140000;
        application.Risk_grade_list__c='Near Prime +';
        update application;
        test.stopTest();
    }
    @isTest
    static void applicationTest2(){
        test.startTest();
        genesis__applications__c application=[SELECT id,genesis__Loan_Amount__c FROM genesis__applications__c];
        application.genesis__Loan_Amount__c=2050000;
        application.Document_Type__c='Alt Doc';
        application.Actual_Security_Value__c=3153846.1;
        application.Risk_grade_list__c='Prime';
        update application;
        test.stopTest();
    }
    @isTest
    static void applicationTest3(){
        test.startTest();
        genesis__applications__c application=[SELECT id,genesis__Loan_Amount__c FROM genesis__applications__c];
        application.genesis__Loan_Amount__c=3400000;
        application.Document_Type__c='Alt Doc';
        application.Actual_Security_Value__c=4533333.33;
        application.Risk_grade_list__c='Near Prime';
        update application;
        test.stopTest();
    }

}