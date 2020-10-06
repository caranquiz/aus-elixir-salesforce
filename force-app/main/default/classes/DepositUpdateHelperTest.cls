@isTest
public with sharing class DepositUpdateHelperTest {
    @TestSetup
    static void makeData(){
        //Inserting Legal Entity
        clcommon__Legal_Entity__c legEntity = GenericUtilityTestHelper.returnLegalEntity();
        System.assertEquals(legEntity.Name,'Individual');
        
        //Inserting Account
        Account acc = GenericUtilityTestHelper.returnBorrowerAccount(legEntity.Id);
        System.assertEquals(acc.name,'Dummy Account');
        
        //Inserting Application
        genesis__applications__c app = GenericUtilityTestHelper.returnApplication(acc.Id);
        System.assertEquals(app.genesis__account__c,acc.Id);
        
        //Inserting Warehouse
        Warehouse__c ware = GenericUtilityTestHelper.returnWarehouse();
        System.assertEquals(ware.Institution_Name__c,'Warehouse');
        System.assertEquals(ware.BSB_Number__c, '123456');
        System.assertEquals(ware.Bank_Account_Number__c, '8890231');
        
        //Inserting LoanWarehouse
        Loan_Warehouse__c loanWarehouse = GenericUtilityTestHelper.returnLoanWarehouse(ware.Id,app.Id);
        System.assertEquals(loanWarehouse.Warehouse__c,ware.Id);
        
        //Inserting Custom Setting
        Disable_Custom_Triggers__c dis = Disable_Custom_Triggers__c.getOrgDefaults();
        dis.LoanWarehouseTrigger__c = false;
        insert dis;
        System.assertEquals(dis.LoanWarehouseTrigger__c,false);
        
        //Inserting Conversion Mapping
        genesis__Conversion_Mapping_Header__c conhead = GenericUtilityTestHelper.conversionMapping();
        System.assertEquals(conhead.genesis__Product_Type__c,'LOAN');
        
        genesis__Conversion_Mapping__c conMap1 = GenericUtilityTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Loan_Amount__c','loan__Loan_Account__c','loan__Loan_Amount__c');
        genesis__Conversion_Mapping__c conMap2 = GenericUtilityTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Interest_Only_Period__c','loan__Loan_Account__c','loan__Interest_Only_Period__c');
        genesis__Conversion_Mapping__c conMap3 = GenericUtilityTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Payment_Frequency__c','loan__Loan_Account__c','loan__Frequency_of_Loan_Payment__c');
        genesis__Conversion_Mapping__c conMap4 = GenericUtilityTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Interest_Rate__c','loan__Loan_Account__c','loan__Interest_Rate__c');
        genesis__Conversion_Mapping__c conMap5 = GenericUtilityTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Term__c','loan__Loan_Account__c','loan__Number_of_Installments__c');
        List<genesis__Conversion_Mapping__c> conMapList = new List<genesis__Conversion_Mapping__c>();
        conMapList.add(conMap1);
        conMapList.add(conMap2);
        conMapList.add(conMap3);
        conMapList.add(conMap4);
        insert conMapList;
        
        loan__Loan_Account__c loanC = ElixirTestHelper.returnLoanAccount();
        loanC.loan__Account__c = acc.Id;
        loanC.loan__Loan_Amount__c = 1000;
        loanC.loan__Frequency_of_Loan_Payment__c = ConstantValues.MONTHLY;
        loanC.Loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING;
        loanC.Application__c = app.id;
        loanC.APS_Created__c = false;
        loanC.loan__Account__c = acc.Id;
        loanC.loan__Last_Installment_Date__c = Date.today();
        loanC.loan__Next_Installment_Date__c = Date.today();
        loanC.loan__Principal_Remaining__c = 100;
        loanC.loan__Loan_Status__c = 'Approved';
        update loanC;
        System.assertEquals(loanC.loan__Next_Installment_Date__c,Date.today());

        loan__Payment_Mode__c pmt = GenericUtilityTestHelper.loanPaymentMode();
        System.assertEquals(pmt.name,'ACH');

        loan__Bank_Account__c bank = GenericUtilityTestHelper.returnDepositAccount();
        System.assertEquals(bank.loan__Active__c,True);
        System.assertEquals(bank.Bank_Account_Name__c,'ABCDE');

        
        loan__Fee__c feeAmt = GenericUtilityTestHelper.loanFeeInfo();
        feeAmt.name = 'Drawdown Prepaid Interest';
        update feeAmt;
        System.assertEquals(feeAmt.name,'Drawdown Prepaid Interest');

        loan__Contract_Pre_Paid_Fee__c conFee = GenericUtilityTestHelper.contractFee(loanC.Id, feeAmt.Id);
        System.assertEquals(conFee.loan__Amount__c,400);
    
        clcommon__Deposit__c dep = GenericUtilityTestHelper.depInfo(loanC.Id);
        System.assertEquals(dep.clcommon__Current_Deposit_Rate__c,10);
    }
    @isTest
    static void test(){
        genesis__applications__c app = [SELECT ID from genesis__applications__c];
        loan__Loan_Account__c loanC = [SELECT ID from loan__Loan_Account__c];
        Warehouse__c ware  = [SELECT ID from Warehouse__c];
        List <clcommon__Deposit__c> depList = [SELECT id,name,clcommon__Current_Deposit_Amount__c,loan__Loan_Account__c FROM clcommon__Deposit__c WHERE loan__Loan_Account__c = :loanC.Id LIMIT 1];
        test.startTest();
        ConvertToContract.executeFun(app.Id);
        app.CL_Contract__c = loanC.Id;
        update app;
        WarehouseFunding.executeFun(loanC.Id,ware.Id);
        DepositUpdateHelper.depositUpdate(depList);
        test.stopTest();
    }
}