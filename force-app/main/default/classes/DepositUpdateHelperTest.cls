/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Hamza Yousuf
Development Date : 18/08/2020
Last Modified By : Hamza Yousuf
Last Modified Date : 13/11/2020
Description : This test class covers Deposit Update Helper class.
***********************************************************************************************************************************************************/
@isTest
public with sharing class DepositUpdateHelperTest {
  @TestSetup
  static void makeData() {
    //Inserting Legal Entity
    clcommon__Legal_Entity__c legEntity = GenericUtilityTestHelper.returnLegalEntity();
    System.assertEquals(legEntity.Name, 'Individual');

    //Inserting Account
    Account acc = GenericUtilityTestHelper.returnBorrowerAccount(legEntity.Id);
    System.assertEquals(acc.name, 'Dummy Account');

    //Inserting CL Product
    clcommon__CL_Product__c clProductName = GenericUtilityTestHelper.insertClProduct();
    System.assertEquals(clProductName.clcommon__Product_Name__c, 'Residential');

    //Inserting CL Product
    clcommon__CL_Product__c clProductName2 = GenericUtilityTestHelper.insertClProduct2();
    System.assertEquals(
      clProductName2.clcommon__Product_Name__c,
      'Residential Construction'
    );

    //Inserting Payment mode
    loan__Payment_Mode__c mode1 = GenericUtilityTestHelper.insertpaymentMode();
    System.assertEquals(mode1.Name, 'Direct Debit');

    //Inserting Fees
    Elixir_Before_Or_On_Settlement_Fees__c fee = GenericUtilityTestHelper.insertPrePaidFee();
    System.assertEquals(fee.name, 'Application Fee');

    loan__Fee__c loanfeeAmt = GenericUtilityTestHelper.insertLoanFee();
    System.assertEquals(loanfeeAmt.name, 'Application Fee');

    //Inserting Application
    genesis__applications__c app = GenericUtilityTestHelper.returnApplication(
      acc.Id
    );
    app.genesis__CL_Product__c = clProductName.Id;
    app.Application_Fee__c = 100;
    app.genesis__Status__c = 'LOO Accepted';
    app.genesis__Initial_Advance__c = 100000;
    app.First_Tranche_Prepaid_Interest__c = 1000;
    app.Total_Subsequent_Drawdown__c = 2000000;
    app.Subsequent_Drawdown_Prepaid_Interest_Sum__c = 50000;
    app.Application_Fee__c = 100;
    app.Construction_Progress_Payment_Fee__c = 0;
    app.Primary_loan_purpose_list__c = 'Investment';
    app.Primary_Approval_Date__c = '12/12/2020';
    update app;
    System.assertEquals(app.genesis__account__c, acc.Id);

    //Insert Borrower Party Type
    clcommon__Party_Type__c partyType = GenericUtilityTestHelper.insertPartyType(
      ConstantValues.BORROWER
    );
    System.assertNotEquals(
      partyType.Id,
      null,
      'Party type insertion is successful'
    );
    //Inserting Borrower Party
    clcommon__Party__c party = GenericUtilityTestHelper.createBorowerParty(
      acc,
      partyType.Id,
      app.Id
    );
    System.AssertNotEquals(
      party.Id,
      null,
      'Party inserted successfully!'
    );
    //Insert Application Collaterals
    genesis__Application_Collateral__c appCollateral = GenericUtilityTestHelper.returnAppCollateral(
      app.Id,
      acc.Id
    );
    System.AssertNotEquals(
      appCollateral.Id,
      null,
      'Collateral inserted successfully!'
    );

    //Inserting Loan Purpose
    loan__Loan_Purpose__c loanPurpose = GenericUtilityTestHelper.insertLoanPurpose();
    System.assertNotEquals(loanPurpose.Id, Null,'Loan Purpose is not inserted');

    //Inserting Broker
    clcommon__Party__c broker = GenericUtilityTestHelper.insertBroker(app.Id);
    System.assertEquals(broker.genesis__Application__c, app.Id);

    //Inserting Warehouse
    Warehouse__c ware = GenericUtilityTestHelper.returnWarehouse();
    System.assertEquals(ware.Institution_Name__c, 'Warehouse');
    System.assertEquals(ware.BSB_Number__c, '123456');
    System.assertEquals(ware.Bank_Account_Number__c, '8890231');

    //Inserting LoanWarehouse
    Loan_Warehouse__c loanWarehouse = GenericUtilityTestHelper.returnLoanWarehouse(
      ware.Id,
      app.Id
    );
    System.assertEquals(loanWarehouse.Warehouse__c, ware.Id);

    //Inserting Custom Setting
    Disable_Custom_Triggers__c dis = Disable_Custom_Triggers__c.getOrgDefaults();
    dis.LoanWarehouseTrigger__c = false;
    insert dis;
    System.assertEquals(dis.LoanWarehouseTrigger__c, false);

    //Inserting Conversion Mapping
    genesis__Conversion_Mapping_Header__c conhead = GenericUtilityTestHelper.conversionMapping();
    System.assertEquals(conhead.genesis__Product_Type__c, 'LOAN');

    genesis__Conversion_Mapping__c conMap1 = GenericUtilityTestHelper.returnConversionMapping(
      conHead.Id,
      'genesis__Applications__c',
      'genesis__Loan_Amount__c',
      'loan__Loan_Account__c',
      'loan__Loan_Amount__c'
    );
    genesis__Conversion_Mapping__c conMap2 = GenericUtilityTestHelper.returnConversionMapping(
      conHead.Id,
      'genesis__Applications__c',
      'genesis__Interest_Only_Period__c',
      'loan__Loan_Account__c',
      'loan__Interest_Only_Period__c'
    );
    genesis__Conversion_Mapping__c conMap3 = GenericUtilityTestHelper.returnConversionMapping(
      conHead.Id,
      'genesis__Applications__c',
      'genesis__Payment_Frequency__c',
      'loan__Loan_Account__c',
      'loan__Frequency_of_Loan_Payment__c'
    );
    genesis__Conversion_Mapping__c conMap4 = GenericUtilityTestHelper.returnConversionMapping(
      conHead.Id,
      'genesis__Applications__c',
      'genesis__Interest_Rate__c',
      'loan__Loan_Account__c',
      'loan__Interest_Rate__c'
    );
    genesis__Conversion_Mapping__c conMap5 = GenericUtilityTestHelper.returnConversionMapping(
      conHead.Id,
      'genesis__Applications__c',
      'genesis__Term__c',
      'loan__Loan_Account__c',
      'loan__Number_of_Installments__c'
    );
    List<genesis__Conversion_Mapping__c> conMapList = new List<genesis__Conversion_Mapping__c>();
    conMapList.add(conMap1);
    conMapList.add(conMap2);
    conMapList.add(conMap3);
    conMapList.add(conMap4);
    insert conMapList;
    System.assertNotEquals(
      conMapList.size(),
      0,
      'Conversion Mapping inserted successfully!'
    );

    loan__Loan_Account__c loanAccount = ElixirTestHelper.returnLoanAccount();
    loanAccount.loan__Account__c = acc.Id;
    loanAccount.loan__Loan_Amount__c = 1000;
    loanAccount.loan__Frequency_of_Loan_Payment__c = ConstantValues.MONTHLY;
    loanAccount.Loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING;
    loanAccount.Application__c = app.id;
    loanAccount.APS_Created__c = false;
    loanAccount.loan__Account__c = acc.Id;
    loanAccount.loan__Last_Installment_Date__c = Date.today();
    loanAccount.loan__Next_Installment_Date__c = Date.today();
    loanAccount.loan__Principal_Remaining__c = 100;
    loanAccount.loan__Loan_Status__c = 'Approved';
    loanAccount.APS_Frequency__c=ConstantValues.MONTHLY;
    update loanAccount;

    List<loan__Loan_Account__c> loanAccountList=[SELECT id 
                                                    FROM loan__Loan_Account__c 
                                                    WHERE loan__Account__c=: acc.Id 
                                                    AND Application__c=: app.id];
    System.assertEquals(loanAccountList.size(), 1);

    loan__Payment_Mode__c pmt = GenericUtilityTestHelper.loanPaymentMode();
    System.assertEquals(pmt.name, 'ACH');

    loan__Bank_Account__c bank = GenericUtilityTestHelper.returnDepositAccount();
    System.assertEquals(bank.loan__Active__c, true);
    System.assertEquals(bank.Bank_Account_Name__c, 'ABCDE');

    loan__Fee__c feeAmt = GenericUtilityTestHelper.loanFeeInfo();
    feeAmt.name = 'Drawdown Prepaid Interest';
    update feeAmt;
    System.assertEquals(feeAmt.name, 'Drawdown Prepaid Interest');

    loan__Fee__c feeAmt1 = GenericUtilityTestHelper.loanFeeInfo();
    System.assertEquals(feeAmt1.name, 'Application Fee');

    loan__Contract_Pre_Paid_Fee__c conFee = GenericUtilityTestHelper.contractFee(
      loanAccount.Id,
      feeAmt1.Id
    );
    System.assertEquals(conFee.loan__Amount__c, 400);

    loan__Coborrower__c coBorrower=GenericUtilityTestHelper.returnCoborrower(loanAccount.id,acc.id);
    List<loan__Coborrower__c> coBorrowerList=[SELECT id 
                                                  FROM loan__Coborrower__c 
                                                  WHERE loan__Loan__c=:loanAccount.id 
                                                  AND loan__Account__c=: acc.id];
    System.assertEquals(coBorrowerList.size(),1);

    Linked_Loan__c linkedLoan=GenericUtilityTestHelper.returnlinkedLoan(loanAccount.id,loanAccount.id);
    List<Linked_Loan__c> linkedLoanList=[SELECT id 
                                            FROM Linked_Loan__c 
                                            WHERE Linked_Loan__c=:loanAccount.id
                                            AND Current_Loan_Record__c=: loanAccount.id];
    System.assertEquals(linkedLoanList.size(),1);

    loan__Loan_Collateral__c loanCollateral=GenericUtilityTestHelper.returnLoanCollateral(
      loanAccount.id
    );
    List<loan__Loan_Collateral__c> loanCollateralList=[SELECT id 
                                            FROM loan__Loan_Collateral__c 
                                            WHERE loan__Loan__c=:loanAccount.id];
    System.assertEquals(loanCollateralList.size(),1);

  }
  @isTest
  static void test() {
    genesis__applications__c app = [SELECT ID FROM genesis__applications__c];
    loan__Loan_Account__c loanC = [SELECT ID FROM loan__Loan_Account__c];
    clcommon__Deposit__c dep = GenericUtilityTestHelper.depInfo(loanC.Id);
    System.assertEquals(dep.clcommon__Current_Deposit_Rate__c, 10);
    Warehouse__c ware = [SELECT ID FROM Warehouse__c];
    List<clcommon__Deposit__c> depList = [
      SELECT
        id,
        name,
        clcommon__Current_Deposit_Amount__c,
        loan__Loan_Account__c
      FROM clcommon__Deposit__c
      WHERE loan__Loan_Account__c = :loanC.Id
      LIMIT 1
    ];
    test.startTest();
    ConvertToContract.executeFun(app.Id);
    app.CL_Contract__c = loanC.Id;
    update app;
    WarehouseFunding.executeFun(loanC.Id, ware.Id);
    DepositUpdateHelper.depositUpdate(depList);
  }
  @isTest
  static void redrawControllerTest() {
    genesis__applications__c app = [SELECT ID FROM genesis__applications__c];
    loan__Loan_Account__c loanC = [SELECT ID FROM loan__Loan_Account__c];
    Warehouse__c ware = [SELECT ID FROM Warehouse__c];
    test.startTest();
    ConvertToContract.executeFun(app.Id);
    app.CL_Contract__c = loanC.Id;
    update app;
    WarehouseFunding.executeFun(loanC.Id, ware.Id);
    //Code added by Rameswari to give coverage to Redraw Controller
    PageReference pageRef = Page.loan__tabbedLoanAccount;
    pageRef.getParameters().put('LoanId', loanC.id);
    Test.setCurrentPage(pageRef);
    RedrawController controller = new RedrawController();
    controller.acct = loanC;
    controller.redrawAmount = '200';
    controller.message = 'Sample Message';
    controller.doRedraw();
    controller.cancel();
    test.stopTest();
  }
  @isTest
  static void caseScenarioFornonFITLoans() {
    clcommon__CL_Product__c prod = [
      SELECT Id
      FROM clcommon__CL_Product__c
      WHERE clcommon__Product_Name__c = 'Residential'
    ];
    genesis__applications__c app = [SELECT ID FROM genesis__applications__c];
    app.genesis__CL_Product__c = prod.Id;
    app.genesis__Status__c = 'Approved';
    loan__Loan_Account__c loanC = [SELECT ID FROM loan__Loan_Account__c];
    Warehouse__c ware = [SELECT ID FROM Warehouse__c];
    test.startTest();
    ConvertToContract.executeFun(app.Id);
    app.CL_Contract__c = loanC.Id;
    update app;
    WarehouseFunding.executeFun(loanC.Id, ware.Id);
    Database.executeBatch(new UpdateUnpaidBillsFlagBatch(), 10);
    test.stopTest();
  }
  @isTest
  static void caseScenarioForFITLoans() {
    clcommon__CL_Product__c prod = [
      SELECT Id
      FROM clcommon__CL_Product__c
      WHERE clcommon__Product_Name__c = 'Residential Construction'
    ];
    genesis__applications__c app = [SELECT Id FROM genesis__applications__c];
    app.genesis__CL_Product__c = prod.Id;
    update app;
    loan__Loan_Account__c loanC = [SELECT ID FROM loan__Loan_Account__c];
    Warehouse__c ware = [SELECT ID FROM Warehouse__c];
    test.startTest();
    ConvertToContract.executeFun(app.Id);
    app.CL_Contract__c = loanC.Id;
    update app;
    ConvertToContract.attachValues(app.Id);
    ConvertToContract.collateralValues(app.Id,loanC.Id);
    List<loan__Loan_Account__c> loanIdList=new List<loan__Loan_Account__c>();
    loanIdList.add(loanC);
    ConvertToContract.updateClContract(loanIdList);
    WarehouseFunding.executeFun(loanC.Id, ware.Id);
    app.Drawdown_Prepaid_Interest__c = 1000;
    app.Subsequent_Drawdown__c = 5000;
    app.First_Drawdown_Complete__c = true;
    update app;
    WarehouseFunding.executeFun(loanC.Id, ware.Id);
    LoanPaymentTxnClearingJobCustomQuery.getQuery();
    Database.executeBatch(new UpdateUnpaidBillsFlagBatch(), 10);
    DepositPaymentCreationCustomQuery.getCustomQuery('loan.LoanDepositPaymentCreationDynamicJob');
    LoanCollateralUpdateBatch obj=new LoanCollateralUpdateBatch();
    String sch = '0 0 23 * * ?';
		Id jobId = system.schedule('Test Check', sch, obj );

    LoanCollateralUpdateBatchExecution.executeLoanCollateralUpdateBatchWS();

    Id batchJobId=Database.executeBatch(new LoanCollateralGenerationBatch(), 10);

    test.stopTest();
    AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID =: batchJobId OR ID=:jobId ];
    System.assert(aaj.Status=='Completed', 'Job run successfully');
  }
}