/****************************************************************************************************
Description:    This is a test class for UpdateBorrowerACH and BorrowerACHApprovalEmail
Developer:      Sayak Mukhopadhyay
Created Date:   13/04/2022
*****************************************************************************************************/



@isTest(SeeAllData = false)
public class UpdateBorrowerACHTest{
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
        System.AssertNotEquals(
         testBankAccount.Id,
         null,
        'Bank Account inserted successfully.'
        );
        // Inserting Application
        genesis__applications__c testApplication = GenericUtilityTestHelper.returnApplication(testAccount.id);
        System.AssertNotEquals(
         testApplication.Id,
         null,
        'Application inserted successfully.'
        );
        //Inserting Contract
        loan__Loan_Account__c testContract = GenericUtilityTestHelper.returnLoanAccount();
        testContract.loan__Borrower_ACH__c = testBankAccount.id;
        testContract.Borrower_ACH_Change__c = null;
        update testContract;
        System.AssertNotEquals(
         testContract.Id,
         null,
        'Contract inserted successfully.'
        );
    }
    @isTest
    static void approvalAndRejectionTest(){
        test.startTest();
        loan__Loan_Account__c contract = [SELECT id FROM loan__Loan_Account__c];
        UpdateBorrowerACH.updateAfterApprovalWS(contract.id);
        contract.Borrower_ACH_Change__c = null;
        update contract;
        UpdateBorrowerACH.updateAfterRejectionWS(contract.id);
        test.stopTest();
    } 
    @isTest
    static void checkStatusTest(){
       test.startTest();
       loan__Loan_Account__c contract = [SELECT id FROM loan__Loan_Account__c];
       loan__Bank_Account__c bankAccount = [SELECT id FROM loan__Bank_Account__c];
       bankAccount.Submit_For_Approval__c = True;
       update bankAccount;
       UpdateBorrowerACH.checkStatusWS(contract.id);
       test.stopTest();
    }
    @isTest
    static void sendEmailTest(){
       test.startTest();
       loan__Loan_Account__c contract = [SELECT id FROM loan__Loan_Account__c];
       UpdateBorrowerACH.sendEmailAfterApprovedWS(contract.id);
       UpdateBorrowerACH.sendEmailAfterRejectionWS(contract.id,'Comment');
       List<Id> contractIdList = new List<Id>();
       contractIdList.add(contract.id);
       BorrowerACHApprovalEmail.sendEmail(contractIdList);
       test.stopTest();
    }
}