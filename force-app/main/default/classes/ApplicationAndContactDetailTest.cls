/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class give coverage to FirstHomeBuyerAppUpdateBatch,BrokerApplicationUpdateBatch 
                and ContactDetailUpdateBatch apex classes.
Development Date : 6/05/2021
Last Modified Date : 20/05/2021
****************************************************************************************************/

@isTest(SeeAllData=false)
public class ApplicationAndContactDetailTest {
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

        //Insert Address
        clcommon__Address__c testaddress1 =GenericUtilityTestHelper.returnAddress();
        testaddress1.clcommon__Contact__c=testContact.id;
        testaddress1.Mail_At__c=True;
        update testaddress1;
        List<clcommon__Address__c> addressList1=[SELECT id 
                                                        FROM clcommon__Address__c 
                                                        WHERE Mail_At__c=True
                                                        LIMIT 1 ];
        System.assertEquals(
            addressList1.size(), 
            1, 
            'Address Inserted Successfully'
        );

        //Insert Address
        clcommon__Address__c testaddress2 =GenericUtilityTestHelper.returnAddress();
        testaddress2.clcommon__Contact__c=testContact.id;
        testaddress2.Other_At__c=True;
        update testaddress2;
        List<clcommon__Address__c> addressList2=[SELECT id 
                                                        FROM clcommon__Address__c 
                                                        WHERE Other_At__c=True
                                                        LIMIT 1 ];
        System.assertEquals(
            addressList2.size(), 
            1, 
            'Address Inserted Successfully'
        );

        clcommon__Party_Type__c partyType =GenericUtilityTestHelper.insertPartyType(ConstantValues.BORROWER);
        System.AssertNotEquals(
            partyType.Id,
            null,
            ' Party Type inserted successfully.'
        );

        clcommon__Party_Type__c partyType1 =GenericUtilityTestHelper.insertPartyType('Broker');
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
        testParty.First_Home_Buyer__c=ConstantValues.YES_TAG;
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

        //Insert Telephone Contact
        Telephone_Contact_Number__c testTelephone=GenericUtilityTestHelper.returnTelephone(
            testContact.Id
        );
        testTelephone.Phone_Type__c = ConstantValues.MOBILE_TAG;
        update testTelephone;
        List<Telephone_Contact_Number__c> testTelephoneList=[SELECT id 
                                                                FROM Telephone_Contact_Number__c 
                                                                WHERE Phone_Type__c=:ConstantValues.MOBILE_TAG 
                                                                LIMIT 1];
        System.assertEquals(
            testTelephoneList.size(), 
            1, 
            'Telephone Inserted Successfully'
        );

        //Insert Telephone Contact
        Telephone_Contact_Number__c testTelephone1=GenericUtilityTestHelper.returnTelephone(
            testContact.Id
        );
        testTelephone1.Phone_Type__c = ConstantValues.Home_Phone ;
        update testTelephone1;
        List<Telephone_Contact_Number__c> testTelephoneList1=[SELECT id 
                                                                FROM Telephone_Contact_Number__c 
                                                                WHERE Phone_Type__c=:ConstantValues.Home_Phone 
                                                                LIMIT 1];
        System.assertEquals(
            testTelephoneList1.size(), 
            1, 
            'Telephone Inserted Successfully'
        );
    }
    @isTest
    static void applicationDetailTest(){
        List<genesis__Applications__c> testApplicationList=[SELECT id 
                                                                FROM genesis__Applications__c 
                                                                WHERE Allow_Direct_Marketing__c=:ConstantValues.NO_TAG
                                                                LIMIT 1];
        test.startTest();
        FirstHomeBuyerAppUpdateBatch obj = new FirstHomeBuyerAppUpdateBatch(); 
        database.executebatch(obj,1); 
        test.stopTest();
        
    }
    @isTest
    static void applicationDetailTest1(){
        List<genesis__Applications__c> testApplicationList=[SELECT id 
                                                                FROM genesis__Applications__c 
                                                                WHERE Allow_Direct_Marketing__c=:ConstantValues.NO_TAG
                                                                LIMIT 1];
        List<clcommon__Party__c> partyList=[SELECT id 
                                                        FROM clcommon__Party__c 
                                                        WHERE First_Home_Buyer__c=:ConstantValues.YES_TAG
                                                        LIMIT 1 ];
        delete partyList;
        test.startTest();
        FirstHomeBuyerAppUpdateBatch obj = new FirstHomeBuyerAppUpdateBatch(); 
        database.executebatch(obj,1); 
        test.stopTest();
        
    }
    @isTest
    static void contactDetailTest(){
        List<Contact> contactList=[SELECT id FROM Contact];
        test.startTest();
        ContactDetailUpdateBatch obj = new ContactDetailUpdateBatch(); 
        database.executebatch(obj,1); 
        test.stopTest();
        
    }
    @isTest
    static void applicationBrokerTest(){
        test.startTest();
        BrokerApplicationUpdateBatch obj = new BrokerApplicationUpdateBatch(); 
        database.executebatch(obj,1); 
        test.stopTest();
    }
}