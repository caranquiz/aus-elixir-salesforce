/****************************************************************************************************/
/* Description          : This test class mostly covers the LoanPaymentReturnFileHandler class. */
/* Testing Scenario 1   : (testWithValidData) This test method will test with 1 reversable LPT,
1 LPT with multiple Txns exception, 1 LPT with already reversed exception and 6 LPTs with Txn not
found exception. Total 9 LPTs to cover every return cause. */
/* Testing Scenario 2   : (testWithValidData) This test method will test how the class will handle
 if invalid a file is provided. */
/****************************************************************************************************/

@isTest
public class LoanPaymentReturnFileHandlerTest {
  @TestSetup
  static void initialize() {
    loan__Org_Parameters__c checkTrigger = new loan__Org_Parameters__c();
    checkTrigger.loan__Disable_Triggers__c = true;
    insert checkTrigger;
    Account testAccount = new Account();
    testAccount.loan__Active__c = 'Yes';
    testAccount.loan__Borrower__c = true;
    testAccount.Name = 'Test';
    testAccount.BillingPostalcode = '1234';
    testAccount.BillingCity = 'TestCity';
    insert testAccount;
    Contact testContact = new Contact();
    testContact.AccountId = testAccount.id;
    testContact.LastName = 'Test';
    insert testContact;
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
    loan__Payment_Mode__c testDDPaymentMode = new loan__Payment_Mode__c();
    testDDPaymentMode.Name = 'Direct Debit';
    insert testDDPaymentMode;
    loan__Loan_Account__c testLoanAccount = new loan__Loan_Account__c();
    testLoanAccount.loan__Account__c = testAccount.Id;
    testLoanAccount.loan__Contact__c = testContact.Id;
    testLoanAccount.loan__Loan_Amount__c = 500000;
    testLoanAccount.loan__Disbursed_Amount__c = 500000;
    //testLoanAccount.loan__Total_Amount_Disbursed__c = 500000;
    testLoanAccount.loan__Loan_Status__c = 'Approved';
    testLoanAccount.loan__Borrower_ACH__c = testPayerbankAccount.Id;
    insert testLoanAccount;
    loan__Loan_Disbursal_Transaction__c testLdt = new loan__Loan_Disbursal_Transaction__c();
    testLdt.loan__Loan_Account__c = testLoanAccount.Id;
    testLdt.loan__Disbursal_Date__c = Date.newInstance(2019, 6, 10);
    testLdt.loan__Mode_of_Payment__c = testDDPaymentMode.Id;
    testLdt.loan__Cleared__c = true;
    insert testLdt;
    testLoanAccount.loan__Disbursal_Date__c = Date.newInstance(2019, 6, 10);
    update testLoanAccount;
    loan__Loan_Payment_Transaction__c testLpt = new loan__Loan_Payment_Transaction__c();
    testLpt.loan__Loan_Account__c = testLoanAccount.Id;
    testLpt.loan__Sent_to_ACH__c = false;
    testLpt.loan__Payment_Type__c = 'Regular';
    testLpt.loan__Transaction_Date__c = Date.newInstance(2019, 6, 10);
    testLpt.loan__Payment_Mode__c = testDDPaymentMode.id;
    testLpt.loan__Transaction_Amount__c = 5000;
    testLpt.loan__Cleared__c = true;
    testLpt.loan__Reversed__c = false;
    testLpt.loan__Rejected__c = false;
    insert testLpt;
    loan__Loan_Payment_Transaction__c testLpt2 = new loan__Loan_Payment_Transaction__c();
    testLpt2.loan__Loan_Account__c = testLoanAccount.Id;
    testLpt2.loan__Sent_to_ACH__c = false;
    testLpt2.loan__Payment_Type__c = 'Regular';
    testLpt2.loan__Transaction_Date__c = Date.newInstance(2019, 6, 10);
    testLpt2.loan__Payment_Mode__c = testDDPaymentMode.id;
    testLpt2.loan__Transaction_Amount__c = 5000;
    testLpt2.loan__Cleared__c = true;
    testLpt2.loan__Reversed__c = true;
    testLpt2.loan__Rejected__c = false;
    insert testLpt2;
    testLoanAccount.loan__Last_Transaction_Id__c = (String) testLpt.Id;
    update testLoanAccount;
    testLoanAccount = new loan__Loan_Account__c();
    testLoanAccount.loan__Account__c = testAccount.Id;
    testLoanAccount.loan__Contact__c = testContact.Id;
    testLoanAccount.loan__Loan_Amount__c = 500000;
    testLoanAccount.loan__Disbursed_Amount__c = 500000;
    //testLoanAccount.loan__Total_Amount_Disbursed__c = 500000;
    testLoanAccount.loan__Loan_Status__c = 'Approved';
    testLoanAccount.loan__Borrower_ACH__c = testPayerbankAccount.Id;
    insert testLoanAccount;
    testLdt = new loan__Loan_Disbursal_Transaction__c();
    testLdt.loan__Loan_Account__c = testLoanAccount.Id;
    testLdt.loan__Disbursal_Date__c = Date.newInstance(2019, 6, 10);
    testLdt.loan__Mode_of_Payment__c = testDDPaymentMode.Id;
    testLdt.loan__Cleared__c = true;
    insert testLdt;
    testLoanAccount.loan__Disbursal_Date__c = Date.newInstance(2019, 6, 10);
    update testLoanAccount;
    testLpt = new loan__Loan_Payment_Transaction__c();
    testLpt.loan__Loan_Account__c = testLoanAccount.Id;
    testLpt.loan__Sent_to_ACH__c = false;
    testLpt.loan__Payment_Type__c = 'Regular';
    testLpt.loan__Transaction_Date__c = Date.newInstance(2019, 6, 10);
    testLpt.loan__Payment_Mode__c = testDDPaymentMode.id;
    testLpt.loan__Transaction_Amount__c = 5000;
    testLpt.loan__Cleared__c = true;
    testLpt.loan__Reversed__c = false;
    testLpt.loan__Rejected__c = false;
    insert testLpt;
  }
  @isTest
  static void testWithValidData() {
    List<loan__Loan_Payment_Transaction__c> lptList = new List<loan__Loan_Payment_Transaction__c>(
      [
        SELECT Id, Name
        FROM loan__Loan_Payment_Transaction__c
        WHERE loan__Reversed__c = false
      ]
    );
    System.assertEquals(lptList.size(), 2, 'Non reversed LPT not inserted');
    String record =
      '2756-2341234567897130000500000xxxxxx                          ' +
      lptList[0].Name +
      '     123-456123456789AJAX CRACKERS   00000000';
    record +=
      '\n2756-2341234567898130000500000xxxxxx                          ' +
      lptList[1].Name +
      '     123-456123456789AJAX CRACKERS   00000000';
    lptList = new List<loan__Loan_Payment_Transaction__c>(
      [
        SELECT Id, Name
        FROM loan__Loan_Payment_Transaction__c
        WHERE loan__Reversed__c = true
      ]
    );
    System.assertEquals(lptList.size(), 1, 'Reversed LPT not inserted');
    record +=
      '\n2756-2341234567899130000500000xxxxxx                          ' +
      lptList[0].Name +
      '     123-456123456789AJAX CRACKERS   00000000';
    List<StaticResource> sr = new List<StaticResource>(
      [
        SELECT Id, Name, Body
        FROM StaticResource
        WHERE Name = 'deReturnSampleReport'
        LIMIT 1
      ]
    );
    System.assertEquals(sr.size(), 1, 'Static Resource not found');
    String val = sr[0].Body.toString();
    List<String> records = val.split('\n');
    records.add(1, record);
    val = String.join(records, '\n');
    Test.startTest();
    LoanPaymentReturnFileHandler fileHandlerObj = new LoanPaymentReturnFileHandler();
    fileHandlerObj.parse(val);
    Test.stopTest();
    List<loan__Repayment_Transaction_Adjustment__c> reversalRecords = new List<loan__Repayment_Transaction_Adjustment__c>(
      [SELECT Id FROM loan__Repayment_Transaction_Adjustment__c]
    );
    System.assertEquals(
      reversalRecords.size(),
      1,
      'LPT reversal record not inserted'
    );
    String likeQuery = ConstantValues.TXN_REV_ERR + '%';
    List<peer__Bank_Recon_Exception__c> exceptionList;
    exceptionList = new List<peer__Bank_Recon_Exception__c>(
      [
        SELECT Id, peer__Recon_Message__c, peer__Reference_Number__c
        FROM peer__Bank_Recon_Exception__c
        WHERE peer__Recon_Message__c LIKE :likeQuery
      ]
    );
    System.assertEquals(
      exceptionList.size(),
      1,
      'Multiple Txn exception count from Return Report mismatched with the actual'
    );
    exceptionList = new List<peer__Bank_Recon_Exception__c>(
      [
        SELECT Id, peer__Recon_Message__c, peer__Reference_Number__c
        FROM peer__Bank_Recon_Exception__c
        WHERE peer__Recon_Message__c = :ConstantValues.ALREADY_REV
      ]
    );
    System.assertEquals(
      exceptionList.size(),
      1,
      'Already reversed Txn exception count from Return Report mismatched with the actual'
    );
    exceptionList = new List<peer__Bank_Recon_Exception__c>(
      [
        SELECT Id, peer__Recon_Message__c, peer__Reconciliation_Message__c
        FROM peer__Bank_Recon_Exception__c
        WHERE peer__Recon_Message__c = :ConstantValues.TXN_NOT_FOUND
      ]
    );
    System.assertEquals(
      exceptionList.size(),
      6,
      'Invalid Txn exception count from Return Report mismatched with the actual'
    );
  }
  @isTest
  static void testWithInvalidFileData() {
    String val = '';
    Test.startTest();
    LoanPaymentReturnFileHandler fileHandlerObj = new LoanPaymentReturnFileHandler();
    try {
      fileHandlerObj.parse(val);
    } catch (Exception ex) {
      System.debug(ex.getMessage());
    }
    Test.stopTest();
  }
}
