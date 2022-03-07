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
        
        //Inserting CL Product
        clcommon__CL_Product__c testCLProduct=GenericUtilityTestHelper.returnClProduct();
        System.AssertNotEquals(
            testCLProduct.Id,
            null,
            'CL Product inserted successfully'
        );

        //Inserting Application
        genesis__applications__c testApplication=GenericUtilityTestHelper.returnApplication(testAccount.id);
        testApplication.genesis__CL_Product__c=testCLProduct.id;
        testApplication.Suggested_Application_Fee__c=1000;
        update testApplication;
        List<genesis__applications__c> testApplicationList=[SELECT id 
                                                                FROM genesis__applications__c 
                                                                WHERE genesis__CL_Product__r.clcommon__Product_Name__c=:ConstantValues.Residential 
                                                                LIMIT 1];
        System.assertEquals(
            testApplicationList.size(),
            1,
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
        testcollateral.Primary_Usage__c=ConstantValues.RESIDENTIAL;
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

        clcommon__CL_Product__c cLProduct=[SELECT id,clcommon__Product_Name__c FROM clcommon__CL_Product__c];
        cLProduct.clcommon__Product_Name__c=ConstantValues.SMSF_COMMERCIAL;
        update cLProduct;
        List<clcommon__CL_Product__c> clProductList=[SELECT id 
                                                        FROM clcommon__CL_Product__c 
                                                        WHERE clcommon__Product_Name__c=:ConstantValues.SMSF_COMMERCIAL];
        System.assertEquals(
            clProductList.size(),
            1, 
            'CL Product Updated Successfully'
        );
        genesis__applications__c application=[SELECT id,genesis__Loan_Amount__c FROM genesis__applications__c];
        application.genesis__Loan_Amount__c=2000000;
        application.Actual_Security_Value__c=2800000;
        application.genesis__CL_Product__c=cLProduct.id;
        update application;
        List<genesis__applications__c> applicationList=[SELECT id 
                                                            FROM genesis__applications__c 
                                                            WHERE genesis__Loan_Amount__c=2000000 
                                                            AND genesis__CL_Product__r.clcommon__Product_Name__c=:ConstantValues.SMSF_COMMERCIAL];
        System.assertEquals(
            applicationList.size(),
            1, 
            'Application Updated Successfully'
        );

        clcommon__Collateral__c collateral=[SELECT id,clcommon__Value_Date__c,Primary_Usage__c FROM clcommon__Collateral__c];
        collateral.Primary_Usage__c=ConstantValues.COMMERCIAL;
        collateral.clcommon__Value_Date__c=Date.newInstance(2020, 12, 12);
        collateral.clcommon__Value__c=6000;
        collateral.Estimated_Value__c=2000;
        update collateral;
        List<clcommon__Collateral__c> collateralList=[SELECT id 
                                                        FROM clcommon__Collateral__c 
                                                        WHERE Primary_Usage__c=: ConstantValues.COMMERCIAL 
                                                        AND clcommon__Value__c=6000
                                                        AND Estimated_Value__c=2000];
        System.assertEquals(
            collateralList.size(), 
            1, 
            'Collateral Updated Sucessfully');
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
        application.Document_Type__c=ConstantValues.FULL_DOC;
        application.Actual_Security_Value__c=1000000;
        application.Risk_grade_list__c=ConstantValues.SPECIALIST;
        update application;
        List<genesis__applications__c> applicationList=[SELECT id 
                                                            FROM genesis__applications__c 
                                                            WHERE genesis__Loan_Amount__c=650000 
                                                            AND Document_Type__c =: ConstantValues.FULL_DOC 
                                                            AND Risk_grade_list__c=:ConstantValues.SPECIALIST];
        System.assertEquals(
            applicationList.size(),
            1, 
            'Application Updated Successfully');
        test.stopTest();
    }
    @isTest
    static void applicationTest1(){
        test.startTest();
        genesis__applications__c application=[SELECT id,genesis__Loan_Amount__c FROM genesis__applications__c];
        application.genesis__Loan_Amount__c=1050000;
        application.Document_Type__c=ConstantValues.FULL_DOC;
        application.Actual_Security_Value__c=140000;
        application.Risk_grade_list__c=ConstantValues.NEAR_PRIME_PLUS;
        update application;
        List<genesis__applications__c> applicationList=[SELECT id 
                                                            FROM genesis__applications__c 
                                                            WHERE genesis__Loan_Amount__c=1050000 
                                                            AND Document_Type__c =: ConstantValues.FULL_DOC 
                                                            AND Risk_grade_list__c=:ConstantValues.NEAR_PRIME_PLUS];
        System.assertEquals(
            applicationList.size(),
            1, 
            'Application Updated Successfully');
        test.stopTest();
    }
    @isTest
    static void applicationTest2(){
        test.startTest();
        genesis__applications__c application=[SELECT id,genesis__Loan_Amount__c FROM genesis__applications__c];
        application.genesis__Loan_Amount__c=2050000;
        application.Document_Type__c=ConstantValues.ALT_DOC;
        application.Actual_Security_Value__c=3153846.1;
        application.Risk_grade_list__c=ConstantValues.PRIME;
        update application;
        List<genesis__applications__c> applicationList=[SELECT id 
                                                            FROM genesis__applications__c 
                                                            WHERE genesis__Loan_Amount__c=2050000 
                                                            AND Document_Type__c =: ConstantValues.ALT_DOC 
                                                            AND Risk_grade_list__c=:ConstantValues.PRIME];
        System.assertEquals(
            applicationList.size(),
            1, 
            'Application Updated Successfully');
        test.stopTest();
    }
    @isTest
    static void applicationTest3(){
        test.startTest();
        genesis__applications__c application=[SELECT id,genesis__Loan_Amount__c FROM genesis__applications__c];
        application.genesis__Loan_Amount__c=3400000;
        application.Document_Type__c=ConstantValues.ALT_DOC;
        application.Actual_Security_Value__c=4533333.33;
        application.Risk_grade_list__c=ConstantValues.NEAR_PRIME;
        update application;
        List<genesis__applications__c> applicationList=[SELECT id 
                                                            FROM genesis__applications__c 
                                                            WHERE genesis__Loan_Amount__c=3400000 
                                                            AND Document_Type__c =: ConstantValues.ALT_DOC 
                                                            AND Risk_grade_list__c=:ConstantValues.NEAR_PRIME];
        System.assertEquals(
            applicationList.size(),
            1, 
            'Application Updated Successfully');
        test.stopTest();
    }

    @isTest
    static void applicationTest4(){
        test.startTest();

        clcommon__CL_Product__c cLProduct=[SELECT id,clcommon__Product_Name__c FROM clcommon__CL_Product__c];
        cLProduct.clcommon__Product_Name__c=ConstantValues.COMMERCIAL;
        update cLProduct;
        List<clcommon__CL_Product__c> clProductList=[SELECT id 
                                                        FROM clcommon__CL_Product__c 
                                                        WHERE clcommon__Product_Name__c=:ConstantValues.COMMERCIAL];
        System.assertEquals(
            clProductList.size(),
            1, 
            'CL Product Updated Successfully');

        genesis__applications__c application=[SELECT id,genesis__Loan_Amount__c FROM genesis__applications__c];
        application.genesis__Loan_Amount__c=2000000;
        application.Document_Type__c=ConstantValues.ALT_DOC;
        application.Actual_Security_Value__c=2900000;
        application.Risk_grade_list__c=ConstantValues.NEAR_PRIME_PLUS;
        application.genesis__CL_Product__c=cLProduct.id;
        update application;
        List<genesis__applications__c> applicationList=[SELECT id 
                                                            FROM genesis__applications__c 
                                                            WHERE genesis__Loan_Amount__c=2000000 
                                                            AND Document_Type__c =: ConstantValues.ALT_DOC 
                                                            AND Risk_grade_list__c=:ConstantValues.NEAR_PRIME_PLUS];
        System.assertEquals(
            applicationList.size(),
            1, 
            'Application Updated Successfully');
        test.stopTest();
    }
    @isTest
    static void applicationTest5(){
        test.startTest();

        clcommon__CL_Product__c cLProduct=[SELECT id,clcommon__Product_Name__c FROM clcommon__CL_Product__c];
        cLProduct.clcommon__Product_Name__c=ConstantValues.COMMERCIAL;
        update cLProduct;
        List<clcommon__CL_Product__c> clProductList=[SELECT id 
                                                        FROM clcommon__CL_Product__c 
                                                        WHERE clcommon__Product_Name__c=:ConstantValues.COMMERCIAL];
        System.assertEquals(
            clProductList.size(),
            1, 
            'CL Product Updated Successfully');

        genesis__applications__c application=[SELECT id,genesis__Loan_Amount__c FROM genesis__applications__c];
        application.genesis__Loan_Amount__c=2000000;
        application.Document_Type__c=ConstantValues.ALT_DOC;
        application.Actual_Security_Value__c=2800000;
        application.Risk_grade_list__c=ConstantValues.NEAR_PRIME;
        application.genesis__CL_Product__c=cLProduct.id;
        update application;
        List<genesis__applications__c> applicationList=[SELECT id 
                                                            FROM genesis__applications__c 
                                                            WHERE genesis__Loan_Amount__c=2000000 
                                                            AND Document_Type__c =: ConstantValues.ALT_DOC 
                                                            AND Risk_grade_list__c=:ConstantValues.NEAR_PRIME];
        System.assertEquals(
            applicationList.size(),
            1, 
            'Application Updated Successfully');
        test.stopTest();
    }
    @isTest
    static void applicationTest6(){
        test.startTest();

        clcommon__CL_Product__c cLProduct=[SELECT id,clcommon__Product_Name__c FROM clcommon__CL_Product__c];
        cLProduct.clcommon__Product_Name__c=ConstantValues.COMMERCIAL;
        update cLProduct;
        List<clcommon__CL_Product__c> clProductList=[SELECT id 
                                                        FROM clcommon__CL_Product__c 
                                                        WHERE clcommon__Product_Name__c=:ConstantValues.COMMERCIAL];
        System.assertEquals(
            clProductList.size(),
            1, 
            'CL Product Updated Successfully');

        genesis__applications__c application=[SELECT id,genesis__Loan_Amount__c FROM genesis__applications__c];
        application.genesis__Loan_Amount__c=2000000;
        application.Document_Type__c=ConstantValues.FULL_DOC;
        application.Actual_Security_Value__c=2800000;
        application.Risk_grade_list__c=ConstantValues.PRIME;
        application.genesis__CL_Product__c=cLProduct.id;
        update application;
        List<genesis__applications__c> applicationList=[SELECT id 
                                                            FROM genesis__applications__c 
                                                            WHERE genesis__Loan_Amount__c=2000000 
                                                            AND Document_Type__c =: ConstantValues.FULL_DOC 
                                                            AND Risk_grade_list__c=:ConstantValues.PRIME];
        System.assertEquals(
            applicationList.size(),
            1, 
            'Application Updated Successfully');
        test.stopTest();
    }

    @isTest
    static void applicationTest7(){
        test.startTest();

        clcommon__CL_Product__c cLProduct=[SELECT id,clcommon__Product_Name__c FROM clcommon__CL_Product__c];
        cLProduct.clcommon__Product_Name__c=ConstantValues.VACANT_LAND_RESIDENTIAL;
        update cLProduct;
        List<clcommon__CL_Product__c> clProductList=[SELECT id 
                                                        FROM clcommon__CL_Product__c 
                                                        WHERE clcommon__Product_Name__c=:ConstantValues.VACANT_LAND_RESIDENTIAL];
        System.assertEquals(
            clProductList.size(),
            1, 
            'CL Product Updated Successfully');

        genesis__applications__c application=[SELECT id,genesis__Loan_Amount__c FROM genesis__applications__c];
        application.genesis__Loan_Amount__c=2000000;
        application.Document_Type__c=ConstantValues.FULL_DOC;
        application.Actual_Security_Value__c=2800000;
        application.Risk_grade_list__c=ConstantValues.PRIME;
        application.genesis__CL_Product__c=cLProduct.id;
        update application;
        List<genesis__applications__c> applicationList=[SELECT id 
                                                            FROM genesis__applications__c 
                                                            WHERE genesis__Loan_Amount__c=2000000 
                                                            AND Document_Type__c =: ConstantValues.FULL_DOC 
                                                            AND Risk_grade_list__c=:ConstantValues.PRIME];
        System.assertEquals(
            applicationList.size(),
            1, 
            'Application Updated Successfully');
        test.stopTest();
    }
    @isTest
    static void applicationTest8(){
        test.startTest();

        clcommon__CL_Product__c cLProduct=[SELECT id,clcommon__Product_Name__c FROM clcommon__CL_Product__c];
        cLProduct.clcommon__Product_Name__c=ConstantValues.SMSF_RESIDENTIAL;
        update cLProduct;
        List<clcommon__CL_Product__c> clProductList=[SELECT id 
                                                        FROM clcommon__CL_Product__c 
                                                        WHERE clcommon__Product_Name__c=:ConstantValues.SMSF_RESIDENTIAL];
        System.assertEquals(
            clProductList.size(),
            1, 
            'CL Product Updated Successfully'
        );
        genesis__applications__c application=[SELECT id,genesis__Loan_Amount__c FROM genesis__applications__c];
        application.genesis__Loan_Amount__c=2000000;
        application.Actual_Security_Value__c=2800000;
        application.genesis__CL_Product__c=cLProduct.id;
        update application;
        List<genesis__applications__c> applicationList=[SELECT id 
                                                            FROM genesis__applications__c 
                                                            WHERE genesis__Loan_Amount__c=2000000 
                                                            AND genesis__CL_Product__r.clcommon__Product_Name__c=:ConstantValues.SMSF_RESIDENTIAL];
        System.assertEquals(
            applicationList.size(),
            1, 
            'Application Updated Successfully'
        );

        test.stopTest();
    }
}