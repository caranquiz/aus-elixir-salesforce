
@isTest
private class LoanDisbursalFilegenTest{
    @TestSetup
    static Void initialize() {
        loan__Org_Parameters__c checkTrigger = new loan__Org_Parameters__c();
        checkTrigger.loan__Disable_Triggers__c = true;
        insert checkTrigger;
        checkTrigger = loan__Org_Parameters__c.getInstance();
        System.assertEquals(
          checkTrigger.loan__Disable_Triggers__c,
          true,
          'Org Parameter config error'
        );
        
      Account solicitorAccount = GenericUtilityTestHelper.insertDummyAccount();
      solicitorAccount.Bank_Account_Name__c = 'XYZ WWS';
      solicitorAccount.Bank_Account_Number__c = '123456789';
      solicitorAccount.BSB__c = '231723';
      update solicitorAccount;
      List<Account> testAccountList = new List<Account>([SELECT Id FROM Account]);
      System.assertEquals(testAccountList.size(), 1, 'Account insert error');

      Warehouse__c testWarehouse = new Warehouse__c();
      testWarehouse.Institution_Name__c = 'TEST FIN INSTITUTION';
      testWarehouse.Bank_Account_Number__c = '2213412';
      testWarehouse.BSB_Number__c = '562122';
      insert testWarehouse;

      loan__Loan_Account__c testLoanAccount = GenericUtilityTestHelper.returnLoanAccount();
      testLoanAccount.Warehouse__c = testWarehouse.Id;
      update testLoanAccount;
      List<loan__Loan_Account__c> testLoanAccountList = new List<loan__Loan_Account__c>(
        [SELECT Id FROM loan__Loan_Account__c]
      );
      System.assertEquals(
        testLoanAccountList.size(),
        1,
        'CL Contract insert error'
      );

      loan__Coborrower__c contractParty = new loan__Coborrower__c();
      contractParty.loan__Account__c = solicitorAccount.Id;
      contractParty.loan__Loan__c = testLoanAccount.Id;
      contractParty.loan__Party_Type__c = 'Solicitor';
      insert contractParty;

      loan__Payment_Mode__c testPaymentMode = [SELECT Id, Name FROM loan__Payment_Mode__c WHERE Name = 'ACH'];
      System.debug(testPaymentMode);
      System.assert(
        testPaymentMode != null,
        'Payment Mode insert error'
      );
        
      loan__Bank_Account__c testBankAccount = new loan__Bank_Account__c();
      testBankAccount.loan__Account__c = solicitorAccount.Id;
      testBankAccount.loan__Active__c = true;
      testBankAccount.loan__Bank_Account_Number__c = '1234567';
      testBankAccount.loan__Bank_Name__c = 'TEST BANK';
      insert testBankAccount;

      loan__Automated_Payment_Configuration__c apc = new loan__Automated_Payment_Configuration__c();
      apc.loan__Folder_Name__c = 'ACH Documents';
      apc.loan__Payment_Mode__c = testPaymentMode.Id;
      apc.loan__File_Type__c = 'Text';
      apc.loan__Event__c = 'LOAN DISBURSAL';
      apc.loan__Active__c = true;
      apc.loan__Filegen_Class__c = 'LoanPaymentTxnFileGen';
      apc.Name_of_User__c = 'WINGATE GROUP';
      apc.Remitter_Name__c = 'WINGATE GROUP';
      apc.loan__Bank_Account__c = testBankAccount.Id;
      apc.User_Financial_Institution_Name__c = 'NAB';
      apc.User_Id__c = '992810';
      insert apc;
      List<loan__Automated_Payment_Configuration__c> testApcList = new List<loan__Automated_Payment_Configuration__c>(
        [SELECT Id FROM loan__Automated_Payment_Configuration__c]
      );
      System.assertEquals(testApcList.size(), 1, 'APC insert error');

      loan__Loan_Disbursal_Transaction__c ldtObj = new loan__Loan_Disbursal_Transaction__c();
      ldtObj.loan__Disbursed_Amt__c = 123000;
      ldtObj.loan__Mode_of_Payment__c = testPaymentMode.Id;
      ldtObj.loan__Cleared__c = true;
      ldtObj.loan__Loan_Account__c = testLoanAccount.Id;
      ldtObj.loan__Financed_Amount__c = 122000;
      insert ldtObj;

      loan__Disbursal_Txn_Distribution__c ldtDist = new loan__Disbursal_Txn_Distribution__c();
      ldtDist.loan__Name_of_Entity__c = 'Application Fee';
      ldtDist.loan__Distribution_Amount__c = 23;
      ldtDist.loan__Loan_Disbursal_Transaction__c = ldtObj.Id;
      insert ldtDist;
    }
    static testMethod void testWithValidScope() {
        loan__Automated_Payment_Configuration__c apc = [
          SELECT Id
          FROM loan__Automated_Payment_Configuration__c
        ];
        List<loan__Loan_Disbursal_Transaction__c> testLdtList = [SELECT Id FROM loan__Loan_Disbursal_Transaction__c];
        test.startTest();
        loan.TransactionSweepToACHState state = new loan.TransactionSweepToACHState();
        state.o1 = apc;
        LoanDisbursalFilegen obj = new LoanDisbursalFilegen();
        String fileName = obj.getSimpleFileName();
        List<String> ret = obj.getEntries(state, testLdtList);
        System.assertEquals(ret.size(), 1, 'Entry list size wrong');
        string header = obj.getHeader(state, testLdtList);
        string trailor = obj.getTrailer(state, testLdtList);
        test.stopTest();
      }
}