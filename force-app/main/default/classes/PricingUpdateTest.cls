/*
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Rameswari Barman
Description: This class provides coverage to PricingUpdateCtrl.
Development Date: 20/7/2020
Scenarios Tested: 1)Generate Pricing button from Loan Details tab is clicked and pricing obtained from rate card is updated in tMatrix rate of loan
                  2)When application's status is changed to Recommended, it is checked whether the interest rate obtained
                   from rate card matches with the current matrix rate
*/
@isTest
private class PricingUpdateTest {
    @testSetup 
    static void setup() {
        //Inserting LegalEntity
        clcommon__Legal_Entity__c legEntity = GenericUtilityTestHelper.returnLegalEntity();
        System.AssertNotEquals(legEntity.Id,NULL,'Legal Entity inserted successfully.');
        
        //Insert Dummy Account
        account dummyClientAccount = GenericUtilityTestHelper.insertDummyAccount();
        System.AssertNotEquals(dummyClientAccount.Id,NULL,'Account inserted successfully.');
        
        //Inserting Account
        Account borrowerAccount = GenericUtilityTestHelper.returnBorrowerAccount(legEntity.Id);
        System.AssertNotEquals(borrowerAccount.Id,NULL,'Borrower Account inserted successfully.');
        
        loan.TestHelper.createSeedDataForTesting();  
        loan__Currency__c curr2 = loan.TestHelper.createCurrency();  
        //Create a dummy MF_Account  
        loan__MF_Account__c dummyAcc = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');  
        System.AssertNotEquals(dummyAcc.Id, NULL, 'Account inserted successfully');
        
        loan__MF_Account__c dummyIncAcc = loan.TestHelper.createMFAccount('XXXIncAccountForTest','30000 - INCOME');  
        System.AssertNotEquals(dummyIncAcc.Id, NULL, 'Account inserted successfully');
        
        //Inserting CLProduct
        clcommon__CL_Product__c clProd = GenericUtilityTestHelper.returnClProduct();
        System.assertEquals(clProd.clcommon__Product_Name__c,'Residential', 'Product insertion is successful');
        
        //Insert Application
        genesis__Applications__c app = GenericUtilityTestHelper.insertApplication(borrowerAccount.Id,clProd.Id);
        System.assertNotEquals(app.Id,NULL, 'Origination Application insertion is successful');
        
        //Inserting Pricing Details 
        genesis__Rate_Card_Setup_Header__c ratecardHeader = GenericUtilityTestHelper.insertRateHeader();
        System.assertEquals(Date.today(),ratecardHeader.genesis__Transaction_Date__c,'Rate card header inserted successfully.');
        
        //Insert Rate Card Setup Detail
        genesis__Rate_Card_Setup_Detail__c ratecard = GenericUtilityTestHelper.insertRateCard(ratecardHeader.Id);
        System.assertNotEquals(ratecard.Id,NULL,'Rate card inserted successfully.');
        
        ratecard=[select id from genesis__Rate_Card_Setup_Detail__c limit 1];
        
        //Insert Application pricing detail
        genesis__Application_Pricing_Detail__c pricingDetail = GenericUtilityTestHelper.insertApplicationPricingDetail(app.Id, ratecard.Id);
        System.assertNotEquals(pricingDetail.Id,NULL,'Application Pricing detail inserted successfully');
    }
    @isTest
    static void scenario1() 
    {
        List <genesis__Applications__c> appList = [select id from genesis__Applications__c limit 1];
        System.assertEquals(appList.size(),1,'Application is present.');
        Test.startTest();
        String checkReturn1 = PricingUpdate.updatePricing(appList[0].Id,false);
        System.assertEquals(checkReturn1,'Unable to update the pricing',true);
        String checkReturn2 = PricingUpdate.updatePricing(appList[0].Id,true);
        System.assertEquals(checkReturn2,
            ConstantValues.PRICING_RATE_DOES_MATCH,
            true);
        Test.stopTest();
    }
 }