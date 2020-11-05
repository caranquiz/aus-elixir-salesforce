/****************************************************************************************************/
/* Description          : This test class mostly covers the LoanPaymentReturnFileProcessor class. */
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
    testPayeebankAccount.Bank_Account_Name__c = 'PayeeBank';
    testPayeebankAccount.BSB_Number__c = '324089';
    testPayeebankAccount.loan__Bank_Account_Number__c = '234567700';
    testPayeebankAccount.loan__Account__c = testAccount.Id;
    testPayeebankAccount.loan__Active__c = true;
    insert testPayeebankAccount;
    loan__Bank_Account__c testPayerbankAccount = new loan__Bank_Account__c();
    testPayerbankAccount.loan__Bank_Name__c = 'PayeeBank';
    testPayerbankAccount.Bank_Account_Name__c = 'PayerBank';
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
    List<String> records = new List<String>();
    List<loan__Loan_Payment_Transaction__c> lptList = new List<loan__Loan_Payment_Transaction__c>(
      [
        SELECT Id, Name
        FROM loan__Loan_Payment_Transaction__c
        WHERE loan__Reversed__c = false
      ]
    );
    System.assertEquals(lptList.size(), 2, 'Non reversed LPT not inserted');
    records.add('0                 01NAB       ORDE Financial            609710Payments    010520');
    records.add('2756-2341234567897130000500000xxxxxx                          '
        + 'LPT-000000999' +
      '     123-456123456789AJAX CRACKERS   00000000');
    records.add('2756-2341234567897130000500000xxxxxx                          '
        + lptList[0].Name +
      '     123-456123456789AJAX CRACKERS   00000000');
    records.add('2756-2341234567898130000500000xxxxxx                          '
        + lptList[1].Name +
      '     123-456123456789AJAX CRACKERS   00000000');
    lptList = new List<loan__Loan_Payment_Transaction__c>(
      [
        SELECT Id, Name
        FROM loan__Loan_Payment_Transaction__c
        WHERE loan__Reversed__c = true
      ]
    );
    System.assertEquals(lptList.size(), 1, 'Reversed LPT not inserted');
    records.add('2756-2341234567899130000500100xxxxxx                          '
      + lptList[0].Name +
      '     123-456123456789AJAX CRACKERS   00000000');
    records.add('7999-999            000000000000017158630001715863                        000003');
    String val = String.join(records, '\n');
    Test.startTest();
    LoanPaymentReturnFileProcessor fileHandlerObj = new LoanPaymentReturnFileProcessor();
    List<loan.ACHReturn> achReturns = fileHandlerObj.parseFile(val, 'loan__Loan_Payment_Transaction__c');
    Test.stopTest();
    System.debug(achReturns.size());
    System.assertEquals(
        achReturns.size(),
        2, 
        'LPT reversal record not inserted'
    );
  }
  @isTest
  static void testWithInvalidFileData() {
    Test.startTest();
    LoanPaymentReturnFileProcessor fileHandlerObj = new LoanPaymentReturnFileProcessor();
    fileHandlerObj.parseFile(null, 'XTY');
    Test.stopTest();
  }
}