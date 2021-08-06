/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class give coverage to LinkPartyCreditReport class
Development Date : 26/07/2021
Last Modified Date : 30/07/2021
****************************************************************************************************/

@isTest(SeeAllData=false)
public class LinkPartyCreditReportTest {
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
        
        //Insert Contact
        Contact testContact=GenericUtilityTestHelper.insertDummyContact(
            testAccount
        );
        System.AssertNotEquals(
        testContact.Id,
        null,
        ' Contact inserted successfully.'
        );

        //Insert Application
        genesis__Applications__c testApplication = GenericUtilityTestHelper.returnApplication(
            testAccount.Id
        );
        testApplication.Allow_Direct_Marketing__c=ConstantValues.NO_TAG;
        testApplication.First_Home_Buyer__c=ConstantValues.NO_TAG;
        update testApplication;
        List<genesis__Applications__c> applicationList=[SELECT id 
                                                        FROM genesis__Applications__c 
                                                        WHERE Allow_Direct_Marketing__c=:ConstantValues.NO_TAG
                                                        LIMIT 1 ];
        System.assertEquals(
            applicationList.size(), 
            1, 
            'Application Inserted Successfully'
        );
        clcommon__Party_Type__c partyType =GenericUtilityTestHelper.insertPartyType(ConstantValues.BORROWER);
        System.AssertNotEquals(
            partyType.Id,
            null,
            ' Party Type inserted successfully.'
        );

        clcommon__Party_Type__c partyType1 =GenericUtilityTestHelper.insertPartyType('Co-Applicant');
        System.AssertNotEquals(
            partyType.Id,
            null,
            ' Party Type inserted successfully.'
        );

        //Insert Party
        clcommon__Party__c testParty=GenericUtilityTestHelper.returnParty(
            testApplication.id,
            testAccount.Id
        );
        testParty.clcommon__Contact__c=testContact.Id;
        testParty.clcommon__Type__c=partyType.Id ;
        update testParty;
        List<clcommon__Party__c> partyList=[SELECT id 
                                                        FROM clcommon__Party__c 
                                                        WHERE id=:testParty.Id
                                                        LIMIT 1 ];
        System.assertEquals(
            partyList.size(), 
            1, 
            'Party Inserted Successfully'
        );

        //Insert Party
        clcommon__Party__c testParty1=GenericUtilityTestHelper.returnParty(
            testApplication.id,
            testAccount.Id
        );
        testParty1.clcommon__Contact__c=testContact.Id;
        testParty1.First_Home_Buyer__c=ConstantValues.YES_TAG;
        testParty1.clcommon__Type__c=partyType1.Id ;
        update testParty1;
        List<clcommon__Party__c> partyList1=[SELECT id 
                                                        FROM clcommon__Party__c 
                                                        WHERE id=:testParty1.Id
                                                        LIMIT 1 ];
        System.assertEquals(
            partyList1.size(), 
            1, 
            'Party Inserted Successfully'
        );
        //Insert Credit Account
        Credit_Account__c testCreditAccount=GenericUtilityTestHelper.createCreditAccount(
            testParty1.id
        );
        System.AssertNotEquals(
            testCreditAccount.id,
            null,
            'Credit Account Inserted Successfully'
        );
        //Insert Payment Default
        Payment_Default__c testPaymentDefault=GenericUtilityTestHelper.createPaymentDefaults(
            testParty1.id,
            testCreditAccount.id
        );
        System.AssertNotEquals(
            testPaymentDefault.id,
            null,
            'payment Default Inserted Successfully'
        );
        //Insert Director
        Director__c testdirector=GenericUtilityTestHelper.returnDirector(
            testParty1.id
        );
        System.AssertNotEquals(
            testdirector.id,
            null,
            'Director Inserted Successfully'
        );
        //Insert Directorship
        Current_Directorship__c testdirectorship=GenericUtilityTestHelper.returnDirectorship(
            testParty1.id
        );
        System.AssertNotEquals(
            testdirectorship.id,
            null,
            'Directorship Inserted Successfully'
        );
        //Insert Credit Enquiry
        Credit_Enquiry__c testCreditEnquiry=GenericUtilityTestHelper.returnCreditEnquiry(
            testParty1.id
        );
        System.AssertNotEquals(
            testCreditEnquiry.id,
            null,
            'Credit Enquiry Inserted Successfully'
        );
	}
 @isTest
    static void partyTest(){
        List<clcommon__Party__c> testParty1=[SELECT id 
                                                FROM clcommon__Party__c 
                                                WHERE clcommon__Type__r.Name=:ConstantValues.BORROWER
                                                LIMIT 1];
        List<clcommon__Party__c> testParty2=[SELECT id 
                                                FROM clcommon__Party__c 
                                                WHERE clcommon__Type__r.Name='Co-Applicant'
                                                LIMIT 1];
        test.startTest();
        //UpdateCreditReport obj = new UpdateCreditReport(); 
        LinkPartyCreditReport.linkCreditReport(testParty1[0].id,testParty2[0].id); 
        test.stopTest();
        
    }  
}