/****************************************************************************************************/
/* Description          : This test class mostly covers the LoanPaymentTransactionFileGen class. */
/* Testing Scenario 1   : (checkInitialiedData) Tests if the inserted records in setup method exist */
/* Testing Scenario 2   : (testWithValidScope) Tests with all the valid data required to generate a
ABA file for Loan Payment Txns */
/* Testing Scenario 3   : (testWithException) Tests without the Remitter Name in the APC. */
/* Testing Scenario 4   : (testWithException2) Tests with Bank Account set to null in the APC. */
/* Testing Scenario 5   : (testWithException5) Tests while generating ABA file if APC isn't found or
is null how will it handle. */
/* Testing Scenario 6   : (testWithInvalidScope) Tests with no Borrower ACH bank account spedified */
/* Testing Scenario 7   : (testWithInvalidScope3) Tests with Account name length greater than 32 */
/****************************************************************************************************/

@isTest
private class LoanPaymentTransactionFileGenTest {
  @TestSetup
  static Void initialize() {
    Account testAccount = new Account();
    testAccount.loan__Active__c = 'Yes';
    testAccount.loan__Borrower__c = true;
    testAccount.Name = 'Test';
    testAccount.BillingPostalcode = '1234';
    testAccount.BillingCity = 'TestCity';
    insert testAccount;
    List<Account> testAccountList = new List<Account>([SELECT Id FROM Account]);
    System.assertEquals(testAccountList.size(), 1, 'Account insert error');

    Contact testContact = new Contact();
    testContact.AccountId = testAccount.id;
    testContact.LastName = 'Test';
    insert testContact;
    List<Contact> testContactList = new List<Contact>([SELECT Id FROM Contact]);
    System.assertEquals(testContactList.size(), 1, 'Contact insert error');

    loan__Bank_Account__c testPayeebankAccount = new loan__Bank_Account__c();
    testPayeebankAccount.loan__Bank_Name__c = 'PayeeBank';
    testPayeebankAccount.BSB_Number__c = '324089';
    testPayeebankAccount.loan__Bank_Account_Number__c = '234567700';
    testPayeebankAccount.loan__Account__c = testAccount.Id;
    testPayeebankAccount.loan__Active__c = true;
    insert testPayeebankAccount;

    loan__Bank_Account__c testPayerbankAccount = new loan__Bank_Account__c();
    testPayerbankAccount.loan__Bank_Name__c = 'PayerBank';
    testPayerbankAccount.BSB_Number__c = '453009';
    testPayerbankAccount.loan__Bank_Account_Number__c = '770065432';
    testPayerbankAccount.loan__Account__c = testAccount.Id;
    testPayerbankAccount.loan__Active__c = true;
    insert testPayerbankAccount;
    List<loan__Bank_Account__c> testbankAccountList = new List<loan__Bank_Account__c>(
      [SELECT Id FROM loan__Bank_Account__c]
    );
    System.assertEquals(
      testbankAccountList.size(),
      2,
      'Bank Account insert error'
    );

    loan__Payment_Mode__c testDDPaymentMode = new loan__Payment_Mode__c();
    testDDPaymentMode.Name = 'ACH';
    insert testDDPaymentMode;
    List<loan__Payment_Mode__c> testPaymentModeList = new List<loan__Payment_Mode__c>(
      [SELECT Id FROM loan__Payment_Mode__c]
    );
    System.assertEquals(
      testPaymentModeList.size(),
      1,
      'Payment Mode insert error'
    );

    loan__Loan_Account__c testLoanAccount = GenericUtilityTestHelper.returnLoanAccount();
    testLoanAccount.loan__Borrower_ACH__c = testPayerbankAccount.Id;
    update testLoanAccount;
    List<loan__Loan_Account__c> testLoanAccountList = new List<loan__Loan_Account__c>(
      [SELECT Id FROM loan__Loan_Account__c]
    );
    System.assertEquals(
      testLoanAccountList.size(),
      1,
      'CL Contract insert error'
    );

    loan__Automated_Payment_Configuration__c apc = new loan__Automated_Payment_Configuration__c();
    apc.loan__Folder_Name__c = 'ACH Documents';
    apc.loan__Payment_Mode__c = testDDPaymentMode.Id;
    apc.loan__File_Type__c = 'Text';
    apc.loan__Event__c = 'LOAN PAYMENT';
    apc.loan__Active__c = true;
    apc.loan__Filegen_Class__c = 'LoanPaymentTransactionFileGen';
    apc.Name_of_User__c = 'AJAX CRACKERS';
    apc.Remitter_Name__c = 'AJAX CRACKERS';
    apc.loan__Bank_Account__c = testPayeebankAccount.Id;
    apc.User_Financial_Institution_Name__c = 'NAB';
    apc.User_Id__c = '013095';
    insert apc;
    List<loan__Automated_Payment_Configuration__c> testApcList = new List<loan__Automated_Payment_Configuration__c>(
      [SELECT Id FROM loan__Automated_Payment_Configuration__c]
    );
    System.assertEquals(testApcList.size(), 1, 'APC insert error');
    loan__Loan_Payment_Transaction__c testLpt = GenericUtilityTestHelper.returnLoanPayment(
      testLoanAccount,
      testDDPaymentMode.Id,
      9,
      5000
    );
    List<loan__Loan_Payment_Transaction__c> testLptList = new List<loan__Loan_Payment_Transaction__c>(
      [SELECT Id FROM loan__Loan_Payment_Transaction__c]
    );
    System.assertEquals(
      testLptList.size(),
      1,
      'Loan Payment Transaction insert error'
    );
  }
  static testMethod void testWithValidScope() {
    loan__Automated_Payment_Configuration__c apc = [
      SELECT Id
      FROM loan__Automated_Payment_Configuration__c
    ];
    List<loan__Loan_Payment_Transaction__c> testLptList = new List<loan__Loan_Payment_Transaction__c>(
      [SELECT Id FROM loan__Loan_Payment_Transaction__c]
    );
    test.startTest();
    loan.TransactionSweepToACHState state = new loan.TransactionSweepToACHState();
    state.o1 = apc;
    LoanPaymentTransactionFileGen obj = new LoanPaymentTransactionFileGen();
    String fileName = obj.getSimpleFileName();
    List<String> ret = obj.getEntries(state, testLptList);
    System.assertEquals(ret.size(), 1, 'Entry list size wrong');
    string header = obj.getHeader(state, testLptList);
    string trailor = obj.getTrailer(state, testLptList);
    test.stopTest();
  }
  static testMethod void testWithException() {
    loan__Automated_Payment_Configuration__c apc = [
      SELECT Id, Remitter_Name__c
      FROM loan__Automated_Payment_Configuration__c
    ];
    apc.Remitter_Name__c = null;
    update apc;
    List<loan__Loan_Payment_Transaction__c> testLptList = new List<loan__Loan_Payment_Transaction__c>(
      [SELECT Id FROM loan__Loan_Payment_Transaction__c]
    );

    test.startTest();
    loan.TransactionSweepToACHState state = new loan.TransactionSweepToACHState();
    state.o1 = apc;
    LoanPaymentTransactionFileGen obj = new LoanPaymentTransactionFileGen();
    String fileName = obj.getSimpleFileName();
    List<String> ret = obj.getEntries(state, testLptList);
    string header = obj.getHeader(state, testLptList);
    string trailor = obj.getTrailer(state, testLptList);
    test.stopTest();
    List<clcommon__Log__c> logList = [SELECT Id, clcommon__Message__c FROM clcommon__Log__c];
    System.assertEquals(1, logList.size(), 'Log insertion error');
  }
  static testMethod void testWithException2() {
    loan__Automated_Payment_Configuration__c apc = [
      SELECT Id, Remitter_Name__c, loan__Bank_Account__c, loan__Bank_Account__r.loan__Bank_Account_Number__c
      FROM loan__Automated_Payment_Configuration__c
    ];
    List<loan__Loan_Payment_Transaction__c> testLptList = new List<loan__Loan_Payment_Transaction__c>(
      [SELECT Id FROM loan__Loan_Payment_Transaction__c]
    );
    apc.loan__Bank_Account__c = null;
    update apc;

    test.startTest();
    loan.TransactionSweepToACHState state = new loan.TransactionSweepToACHState();
    state.o1 = apc;
    LoanPaymentTransactionFileGen obj = new LoanPaymentTransactionFileGen();
    String fileName = obj.getSimpleFileName();
    List<String> ret = obj.getEntries(state, testLptList);
    string header = obj.getHeader(state, testLptList);
    string trailor = obj.getTrailer(state, testLptList);
    test.stopTest();
    List<clcommon__Log__c> logList = [SELECT Id, clcommon__Message__c FROM clcommon__Log__c];
    System.assertEquals(1, logList.size(), 'Log insertion error');
  }
  static testMethod void testWithException5() {
    List<loan__Loan_Payment_Transaction__c> testLptList = new List<loan__Loan_Payment_Transaction__c>(
      [SELECT Id FROM loan__Loan_Payment_Transaction__c]
    );
    test.startTest();
    loan.TransactionSweepToACHState state = new loan.TransactionSweepToACHState();
    state.o1 = new loan__Automated_Payment_Configuration__c(Id = null);
    LoanPaymentTransactionFileGen obj = new LoanPaymentTransactionFileGen();
    String fileName = obj.getSimpleFileName();
    List<String> ret = obj.getEntries(state, testLptList);
    string header = obj.getHeader(state, testLptList);
    string trailor = obj.getTrailer(state, testLptList);
    test.stopTest();
    List<clcommon__Log__c> logList = [SELECT Id, clcommon__Message__c FROM clcommon__Log__c];
    System.assertEquals(logList.size(), 2, 'Log insertion error');
  }
  static testMethod void testWithInvalidScope() {
    loan__Automated_Payment_Configuration__c apc = [
      SELECT Id, Remitter_Name__c, loan__Bank_Account__c
      FROM loan__Automated_Payment_Configuration__c
    ];
    List<loan__Loan_Payment_Transaction__c> testLptList = new List<loan__Loan_Payment_Transaction__c>(
      [SELECT Id FROM loan__Loan_Payment_Transaction__c]
    );
    loan__Loan_Account__c loanContract = [
      SELECT Id, loan__Borrower_ACH__c
      FROM loan__Loan_Account__c
    ];
    loanContract.loan__Borrower_ACH__c = null;
    update loanContract;

    test.startTest();
    loan.TransactionSweepToACHState state = new loan.TransactionSweepToACHState();
    state.o1 = apc;
    LoanPaymentTransactionFileGen obj = new LoanPaymentTransactionFileGen();
    String fileName = obj.getSimpleFileName();
    List<String> ret = obj.getEntries(state, testLptList);
    string header = obj.getHeader(state, testLptList);
    string trailor = obj.getTrailer(state, testLptList);
    test.stopTest();
  }
  static testMethod void testWithInvalidScope3() {
    loan__Automated_Payment_Configuration__c apc = [
      SELECT Id, Remitter_Name__c, loan__Bank_Account__c
      FROM loan__Automated_Payment_Configuration__c
    ];
    List<loan__Loan_Payment_Transaction__c> testLptList = new List<loan__Loan_Payment_Transaction__c>(
      [SELECT Id FROM loan__Loan_Payment_Transaction__c]
    );
    loan__Bank_Account__c bankAccount = [
      SELECT Id, loan__Account__c
      FROM loan__Bank_Account__c
      WHERE loan__Bank_Name__c = 'PayerBank'
    ];
    Account testAccount = [
      SELECT Id
      FROM Account
      WHERE Id = :bankAccount.loan__Account__c
    ];
    testAccount.Name = 'Testing with Account Name length greater than 32';
    update testAccount;

    test.startTest();
    loan.TransactionSweepToACHState state = new loan.TransactionSweepToACHState();
    state.o1 = apc;
    LoanPaymentTransactionFileGen obj = new LoanPaymentTransactionFileGen();
    String fileName = obj.getSimpleFileName();
    List<String> ret = obj.getEntries(state, testLptList);
    string header = obj.getHeader(state, testLptList);
    string trailor = obj.getTrailer(state, testLptList);
    test.stopTest();
  }
}