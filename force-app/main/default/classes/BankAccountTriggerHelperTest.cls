/****************************************************************************************************
Description:    This is a Test Class for BankAccount Trigger and BankAccountTriggerHelper Class
Developer:      Sayak Mukhopadhyay
Created Date:   11/03/2022
*****************************************************************************************************/


@isTest(SeeAllData = false)
public class BankAccountTriggerHelperTest{
    @TestSetup
    static void initialize(){
        //Inserting Account 
        Account testAccount = GenericUtilityTestHelper.insertDummyAccount();
        System.AssertNotEquals(
         testAccount.Id,
         null,
        'Account inserted successfully.'
        );
        //Inserting Bank Account
        loan__Bank_Account__c testBankAccount = GenericUtilityTestHelper.getBankAccount(testAccount);
        testBankAccount.Submit_For_Approval__c = True;
        update testBankAccount;
        System.AssertNotEquals(
         testBankAccount.Id,
         null,
        'Bank Account inserted successfully.'
        );
    }
    @isTest
    static void bankAccountTest(){
        test.startTest();
        loan__Bank_Account__c bankAccount = getBankAccount();
        bankAccount.Active_Change__c = false;
        update bankAccount;
        test.stopTest();
    } 
    @isTest
    static void bankAccountTestForApproved(){
        test.startTest();
        loan__Bank_Account__c bankAccount = getBankAccount();
        bankAccount.Approved__c = True;
        bankAccount.Submit_For_Approval__c = False;
        bankAccount.Created_After_Conversion__c = True;
        update bankAccount;
        test.stopTest();
    }
    @isTest
    static void bankAccountTestForRejected(){
        test.startTest();
        loan__Bank_Account__c bankAccount = getBankAccount();
        bankAccount.Approved__c = False;
        bankAccount.Submit_For_Approval__c = False;
        bankAccount.Created_After_Conversion__c = True;
        update bankAccount;
        test.stopTest();
    }
    static loan__Bank_Account__c getBankAccount(){
        loan__Bank_Account__c bankAccount = [SELECT id,Active_Change__c FROM loan__Bank_Account__c];
        return bankAccount;
    }
}