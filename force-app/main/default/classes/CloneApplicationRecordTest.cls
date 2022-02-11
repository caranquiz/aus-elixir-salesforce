/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class give coverage to CloneApplicationRecord apex classes.
Development Date : 10/02/2022
Last Modified Date : 10/02/2022
****************************************************************************************************/

@isTest(SeeAllData=false)
public class CloneApplicationRecordTest {
	@TestSetup
    static void initialize() {

        Clone_Record_Configuration__c cloneRecordConfig=GenericUtilityTestHelper.returnCloneRecord();
        System.AssertNotEquals(
          cloneRecordConfig.Id,
          null,
          'Clone Record Configuration inserted successfully.'
        );

        clcommon__Legal_Entity__c legalEntity = GenericUtilityTestHelper.returnLegalEntity();
        System.AssertNotEquals(
          legalEntity.Id,
          null,
          'Individual Legal Entity inserted successfully.'
        );
        //Inserting Account
        Account borrowerAccount = GenericUtilityTestHelper.returnBorrowerAccount(
          legalEntity.Id
        );
        System.AssertNotEquals(
          borrowerAccount.Id,
          null,
          'Borrower Account inserted successfully.'
        );
        //Inserting CLProduct
        clcommon__CL_Product__c clProd = GenericUtilityTestHelper.returnClProduct();
        System.assertEquals(
          clProd.clcommon__Product_Name__c,
          'Residential',
          'Product insertion is successful'
        );
        //Inserting CLProduct
        clcommon__CL_Product__c clProd2 = GenericUtilityTestHelper.returnClProduct();
        clProd2.clcommon__Product_Name__c='Commercial';
        update clProd2;
        List<clcommon__CL_Product__c> clProductList=[SELECT id FROM clcommon__CL_Product__c WHERE clcommon__Product_Name__c='Commercial'];
        System.assertEquals(
          clProductList.size(),
          1,
          'Product insertion is successful'
        );
        //Insert Application
        genesis__Applications__c app = GenericUtilityTestHelper.insertApplication(
          borrowerAccount.Id,
          clProd.Id
        );
        System.assertNotEquals(
          app.Id,
          null,
          'Origination Application insertion is successful'
        );
        //Insert Application
        genesis__Applications__c cloneapp = GenericUtilityTestHelper.insertApplication(
          borrowerAccount.Id,
          clProd2.Id
        );
        cloneapp.genesis__Loan_Amount__c=200000;
        update cloneapp;
        List<genesis__Applications__c> cloneApplicationList=[SELECT id FROM genesis__Applications__c WHERE genesis__Loan_Amount__c=200000];
        System.assertEquals(
          cloneApplicationList.size(),
          1,
          'Application insertion is successful'
        );
        //Insert Borrower Party Type
        clcommon__Party_Type__c partyType = GenericUtilityTestHelper.insertPartyType(
          'Borrower'
        );
        System.assertNotEquals(
          partyType.Id,
          null,
          'Party type insertion is successful'
        );
        //Inserting Borrower Party
        clcommon__Party__c party = GenericUtilityTestHelper.createBorowerParty(
          borrowerAccount,
          partyType.Id,
          app.Id
        );
        System.AssertNotEquals(
          party.Id,
          null,
          'Party inserted successfully!'
        );
        //Inserting Borrower Party
        clcommon__Party__c cloneparty = GenericUtilityTestHelper.createBorowerParty(
          borrowerAccount,
          partyType.Id,
          cloneapp.Id
        );
        System.AssertNotEquals(
          cloneparty.Id,
          null,
          'Party inserted successfully!'
        );
        //Inserting Document Category
        clcommon__Document_Category__c docCategory = GenericUtilityTestHelper.createDocumentCategory(
          app.Id,
          'Identity Documents',
          borrowerAccount.Id
    
        );
        System.AssertNotEquals(
          docCategory.Id,
          null,
          'Document Category inserted successfully!'
        );
        //Insert Application Collaterals
        genesis__Application_Collateral__c appCollateral = GenericUtilityTestHelper.returnAppCollateral(
          app.Id,
          borrowerAccount.Id
        );
        System.AssertNotEquals(
          appCollateral.Id,
          null,
          'Collateral inserted successfully!'
        );
        List <RecordType> recordTypeList = [SELECT id,
                                                  name,
                                                  sobjectType,
                                                  DeveloperName 
                                                FROM RecordType 
                                                WHERE sobjectType = 'genesis__Employment_Information__c' 
                                                AND DeveloperName='Self_Employed'];
        System.assertEquals(recordTypeList.size(),1,'Record Type inserted successfully!'); 

        genesis__Employment_Information__c employment = GenericUtilityTestHelper.createEmploymentInformation(
          recordTypeList[0].Id,
          party.Id
        );  
        System.assertEquals(
          employment.Id != null,
          true,
          'Employment for Borrower inserted successfully!'
        );
        //Inserting Income
        genesis__Income__c incomeRecord=GenericUtilityTestHelper.returnEmploymentInformation(
          app.Id,
          employment.Id
        );
        System.AssertNotEquals(
          incomeRecord.Id,
          null,
          'Income inserted successfully!'
        );

    }
    @isTest
    static void testcloneApplication(){
        List<genesis__Applications__c> applicationList=[SELECT id 
                                                            FROM genesis__Applications__c 
                                                            WHERE genesis__CL_Product__r.clcommon__Product_Name__c=:ConstantValues.RESIDENTIAL];
        List<genesis__Applications__c> cloneappList=[SELECT id 
                                                          FROM genesis__Applications__c 
                                                          WHERE genesis__CL_Product__r.clcommon__Product_Name__c=:ConstantValues.COMMERCIAL];
        Test.startTest();
        String cloneString=CloneApplicationRecord.cloneApplication(applicationList[0].id,cloneappList[0].id);
        System.assert(cloneString =='Success','Application is Cloned');
        Test.stopTest();
    }
}