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
        clcommon__Collateral__c collateral=[SELECT id,clcommon__Value_Date__c FROM clcommon__Collateral__c];
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
}