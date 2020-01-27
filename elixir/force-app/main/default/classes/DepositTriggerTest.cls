/************************************************************************
Class Name : DepositTriggerTest
Developer : Deep Bhattacharjee
Description : Test class For DepositTrigger and DepositUpdateHelper
************************************************************************/

@isTest
public with sharing class DepositTriggerTest {
    static testMethod void test(){
        Elixir_Before_Or_On_Settlement_Fees__c fee = new Elixir_Before_Or_On_Settlement_Fees__c();
        fee.name = 'Application Fee';
        fee.Distribution_Type__c = 'Pre-Paid Fee';
        fee.Fee_Field_API_Name__c = 'Application_Fee__c';
        insert fee;
        System.assertEquals(fee.name,'Application Fee');
        
        //Inserting Legal Entity
        clcommon__Legal_Entity__c legEntity = ElixirTestHelper.returnLegalEntity();
        insert legEntity;
        System.assertEquals(legEntity.Name,'Individual');
        
        //Inserting Account
        Account acc = ElixirTestHelper.returnBorrowerAccount(legEntity.Id);
        insert acc;
        System.assertEquals(acc.name,'Rameswari Barman');
        
        //Inserting Application
        genesis__applications__c app = ElixirTestHelper.returnApplication(acc.Id);
        app.genesis__Payment_Frequency__c = 'Monthly';
        app.Drawdown_Prepaid_Interest__c = 1000;
        insert app;
        System.assertEquals(app.genesis__account__c,acc.Id);
        
        //Inserting Warehouse
        Warehouse__c ware = ElixirTestHelper.returnWarehouse();
        insert ware;
        System.assertEquals(ware.name,'Warehouse 1');
        
        
        Loan_Warehouse__c loanWarehouse1 = ElixirTestHelper.returnLoanWarehouse(ware.Id,app.Id);
        loanWarehouse1.Active__c = true;
        insert loanWarehouse1;
        System.assertEquals(loanWarehouse1.Warehouse__c,ware.Id);
        
        //Inserting LoanWarehouse
        Loan_Warehouse__c loanWarehouse = ElixirTestHelper.returnLoanWarehouse(ware.Id,app.Id);
        insert loanWarehouse;
        System.assertEquals(loanWarehouse.Warehouse__c,ware.Id);
        
        //Inserting Custom Setting
        Disable_Custom_Triggers__c dis = Disable_Custom_Triggers__c.getOrgDefaults();
        dis.LoanWarehouseTrigger__c = false;
        insert dis;
        System.assertEquals(dis.LoanWarehouseTrigger__c,false);
        
        //Inserting Conversion Mapping
        genesis__Conversion_Mapping_Header__c conHead = new genesis__Conversion_Mapping_Header__c();
        conHead.genesis__Product_Type__c = 'LOAN';
        insert conHead;
        System.assertEquals(conHead.genesis__Product_Type__c,'LOAN');
        
        genesis__Conversion_Mapping__c conMap1 = ElixirTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Loan_Amount__c','loan__Loan_Account__c','loan__Loan_Amount__c');
        genesis__Conversion_Mapping__c conMap2 = ElixirTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Interest_Only_Period__c','loan__Loan_Account__c','loan__Interest_Only_Period__c');
        genesis__Conversion_Mapping__c conMap3 = ElixirTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Payment_Frequency__c','loan__Loan_Account__c','loan__Frequency_of_Loan_Payment__c');
        genesis__Conversion_Mapping__c conMap4 = ElixirTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Interest_Rate__c','loan__Loan_Account__c','loan__Interest_Rate__c');
        genesis__Conversion_Mapping__c conMap5 = ElixirTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Term__c','loan__Loan_Account__c','loan__Number_of_Installments__c');
        List<genesis__Conversion_Mapping__c> conMapList = new List<genesis__Conversion_Mapping__c>();
        conMapList.add(conMap1);
        conMapList.add(conMap2);
        conMapList.add(conMap3);
        conMapList.add(conMap4);
        insert conMapList;
        //System.assertEquals(conMap1.size(),4);
        
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
        update loanC;
        System.assertEquals(loanC.loan__Next_Installment_Date__c,Date.today());

        loan__Payment_Mode__c pmt = new loan__Payment_Mode__c();
        pmt.name = 'ACH';
        insert pmt;
        System.assertEquals(pmt.name,'ACH');

        loan__Bank_Account__c bank = new loan__Bank_Account__c();
        bank.loan__Account__c = acc.Id;
        bank.loan__Active__c = True;
        bank.loan__Bank_Account_Number__c = '123456';
        bank.loan__Bank_Name__c = 'ABCD';
        insert bank;
        System.assertEquals(bank.loan__Active__c,True);

        loanC.loan__Loan_Status__c = 'Approved';
        update loanC;
        loan__Fee__c feeAmt = new loan__Fee__c(name = 'Application Fee', loan__Amount__c = 400,loan__Time_of_charge__c='Pre-Paid Fees');
        insert feeAmt;
        System.assertEquals(feeAmt.name,'Application Fee');
        
        loan__Fee__c feeAmtNext = new loan__Fee__c(name = 'Drawdown Prepaid Interest', loan__Amount__c = 400,loan__Time_of_charge__c='Other');
        insert feeAmtNext;
        System.assertEquals(feeAmtNext.name,'Drawdown Prepaid Interest');
        
        loan__Contract_Pre_Paid_Fee__c conFee = new loan__Contract_Pre_Paid_Fee__c(loan__Amount__c = 400,loan__Contract__c = loanC.Id,loan__Fee_Type__c = feeAmt.Id);
        insert conFee;
        System.assertEquals(conFee.loan__Amount__c,400);

        clcommon__Deposit__c dep = new clcommon__Deposit__c();
        dep.loan__Loan_Account__c = loanC.id;
        dep.clcommon__Current_Deposit_Rate__c =10;
        dep.clcommon__Deposit_Amount__c = 4000;
        dep.clcommon__Deposit_Rate__c = 10;
        insert dep;
        System.assertEquals(dep.clcommon__Current_Deposit_Rate__c,10);

        test.startTest();
        ConvertToContract.executeFun(app.Id);
        app.CL_Contract__c = loanC.Id;
        update app;
        WarehouseFunding.executeFun(loanC.Id,ware.Id);
        //clcommon__Deposit__c dep = [SELECT id,name,clcommon__Current_Deposit_Amount__c,loan__Loan_Account__c FROM clcommon__Deposit__c WHERE loan__Loan_Account__c = :loanC.Id LIMIT 1];
        dep.clcommon__Current_Deposit_Amount__c =2000;
        update dep;
        DepositWithdrawal.withdrawAmt(loanC.Id);
        PageReference pageRef = Page.loan__tabbedLoanAccount;
        pageRef.getParameters().put('LoanId', loanC.id);
        Test.setCurrentPage(pageRef);
        RedrawController controller = new RedrawController();
        controller.acct = loanC;
        controller.redrawAmount = '200'; 
        controller.message = 'Sample Message';
        controller.doRedraw();
        test.stopTest();
    }
    static testMethod void test1(){
        Elixir_Before_Or_On_Settlement_Fees__c fee = new Elixir_Before_Or_On_Settlement_Fees__c();
        fee.name = 'Application Fee';
        fee.Distribution_Type__c = 'Pre-Paid Fee';
        fee.Fee_Field_API_Name__c = 'Application_Fee__c';
        insert fee;
        System.assertEquals(fee.name,'Application Fee');
        
        //Inserting Legal Entity
        clcommon__Legal_Entity__c legEntity = ElixirTestHelper.returnLegalEntity();
        insert legEntity;
        System.assertEquals(legEntity.Name,'Individual');
        
        //Inserting Account
        Account acc = ElixirTestHelper.returnBorrowerAccount(legEntity.Id);
        insert acc;
        System.assertEquals(acc.name,'Rameswari Barman');
        
        //Inserting Application
        genesis__applications__c app = ElixirTestHelper.returnApplication(acc.Id);
        app.genesis__Payment_Frequency__c = 'Monthly';
        app.Drawdown_Prepaid_Interest__c = 1000;
        insert app;
        System.assertEquals(app.genesis__account__c,acc.Id);
        
        //Inserting Warehouse
        Warehouse__c ware = ElixirTestHelper.returnWarehouse();
        insert ware;
        System.assertEquals(ware.name,'Warehouse 1');
        
        
        Loan_Warehouse__c loanWarehouse1 = ElixirTestHelper.returnLoanWarehouse(ware.Id,app.Id);
        loanWarehouse1.Active__c = true;
        insert loanWarehouse1;
        System.assertEquals(loanWarehouse1.Warehouse__c,ware.Id);
        
        //Inserting LoanWarehouse
        Loan_Warehouse__c loanWarehouse = ElixirTestHelper.returnLoanWarehouse(ware.Id,app.Id);
        insert loanWarehouse;
        System.assertEquals(loanWarehouse.Warehouse__c,ware.Id);
        
        //Inserting Custom Setting
        Disable_Custom_Triggers__c dis = Disable_Custom_Triggers__c.getOrgDefaults();
        dis.LoanWarehouseTrigger__c = false;
        insert dis;
        System.assertEquals(dis.LoanWarehouseTrigger__c,false);
        
        //Inserting Conversion Mapping
        genesis__Conversion_Mapping_Header__c conHead = new genesis__Conversion_Mapping_Header__c();
        conHead.genesis__Product_Type__c = 'LOAN';
        insert conHead;
        System.assertEquals(conHead.genesis__Product_Type__c,'LOAN');
        
        genesis__Conversion_Mapping__c conMap1 = ElixirTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Loan_Amount__c','loan__Loan_Account__c','loan__Loan_Amount__c');
        genesis__Conversion_Mapping__c conMap2 = ElixirTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Interest_Only_Period__c','loan__Loan_Account__c','loan__Interest_Only_Period__c');
        genesis__Conversion_Mapping__c conMap3 = ElixirTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Payment_Frequency__c','loan__Loan_Account__c','loan__Frequency_of_Loan_Payment__c');
        genesis__Conversion_Mapping__c conMap4 = ElixirTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Interest_Rate__c','loan__Loan_Account__c','loan__Interest_Rate__c');
        genesis__Conversion_Mapping__c conMap5 = ElixirTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Term__c','loan__Loan_Account__c','loan__Number_of_Installments__c');
        List<genesis__Conversion_Mapping__c> conMapList = new List<genesis__Conversion_Mapping__c>();
        conMapList.add(conMap1);
        conMapList.add(conMap2);
        conMapList.add(conMap3);
        conMapList.add(conMap4);
        insert conMapList;
        //System.assertEquals(conMap1.size(),4);
        
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
        update loanC;
        System.assertEquals(loanC.loan__Next_Installment_Date__c,Date.today());

        loan__Payment_Mode__c pmt = new loan__Payment_Mode__c();
        pmt.name = 'ACH';
        insert pmt;
        System.assertEquals(pmt.name,'ACH');

        loan__Bank_Account__c bank = new loan__Bank_Account__c();
        bank.loan__Account__c = acc.Id;
        bank.loan__Active__c = True;
        bank.loan__Bank_Account_Number__c = '123456';
        bank.loan__Bank_Name__c = 'ABCD';
        insert bank;
        System.assertEquals(bank.loan__Active__c,True);

        loanC.loan__Loan_Status__c = 'Approved';
        update loanC;
        loan__Fee__c feeAmt = new loan__Fee__c(name = 'Application Fee', loan__Amount__c = 400,loan__Time_of_charge__c='Pre-Paid Fees');
        insert feeAmt;
        System.assertEquals(feeAmt.name,'Application Fee');
        
        loan__Fee__c feeAmtNext = new loan__Fee__c(name = 'Drawdown Prepaid Interest', loan__Amount__c = 400,loan__Time_of_charge__c='Other');
        insert feeAmtNext;
        System.assertEquals(feeAmtNext.name,'Drawdown Prepaid Interest');
        
        loan__Contract_Pre_Paid_Fee__c conFee = new loan__Contract_Pre_Paid_Fee__c(loan__Amount__c = 400,loan__Contract__c = loanC.Id,loan__Fee_Type__c = feeAmt.Id);
        insert conFee;
        System.assertEquals(conFee.loan__Amount__c,400);

        clcommon__Deposit__c dep = new clcommon__Deposit__c();
        dep.loan__Loan_Account__c = loanC.id;
        dep.clcommon__Current_Deposit_Rate__c =10;
        dep.clcommon__Deposit_Amount__c = 4000;
        dep.clcommon__Deposit_Rate__c = 10;
        insert dep;
        System.assertEquals(dep.clcommon__Current_Deposit_Rate__c,10);

        test.startTest();
        ConvertToContract.executeFun(app.Id);
        app.CL_Contract__c = loanC.Id;
        update app;
        WarehouseFunding.executeFun(loanC.Id,ware.Id);
        //clcommon__Deposit__c dep = [SELECT id,name,clcommon__Current_Deposit_Amount__c,loan__Loan_Account__c FROM clcommon__Deposit__c WHERE loan__Loan_Account__c = :loanC.Id LIMIT 1];
        dep.clcommon__Current_Deposit_Amount__c =2000;
        update dep;
        DepositWithdrawal.withdrawAmt(loanC.Id);
        PageReference pageRef = Page.loan__tabbedLoanAccount;
        pageRef.getParameters().put('LoanId', loanC.id);
        Test.setCurrentPage(pageRef);
        RedrawController controller = new RedrawController();
        controller.acct = loanC;
        controller.redrawAmount = '-200'; 
        controller.message = 'Sample Message';
        controller.doRedraw();
        controller.cancel();
        test.stopTest();
    }
    static testMethod void test2(){
        Elixir_Before_Or_On_Settlement_Fees__c fee = new Elixir_Before_Or_On_Settlement_Fees__c();
        fee.name = 'Application Fee';
        fee.Distribution_Type__c = 'Pre-Paid Fee';
        fee.Fee_Field_API_Name__c = 'Application_Fee__c';
        insert fee;
        System.assertEquals(fee.name,'Application Fee');
        
        //Inserting Legal Entity
        clcommon__Legal_Entity__c legEntity = ElixirTestHelper.returnLegalEntity();
        insert legEntity;
        System.assertEquals(legEntity.Name,'Individual');
        
        //Inserting Account
        Account acc = ElixirTestHelper.returnBorrowerAccount(legEntity.Id);
        insert acc;
        System.assertEquals(acc.name,'Rameswari Barman');
        
        //Inserting Application
        genesis__applications__c app = ElixirTestHelper.returnApplication(acc.Id);
        app.genesis__Payment_Frequency__c = 'Monthly';
        app.Drawdown_Prepaid_Interest__c = 1000;
        insert app;
        System.assertEquals(app.genesis__account__c,acc.Id);
        
        //Inserting Warehouse
        Warehouse__c ware = ElixirTestHelper.returnWarehouse();
        insert ware;
        System.assertEquals(ware.name,'Warehouse 1');
        
        
        Loan_Warehouse__c loanWarehouse1 = ElixirTestHelper.returnLoanWarehouse(ware.Id,app.Id);
        loanWarehouse1.Active__c = true;
        insert loanWarehouse1;
        System.assertEquals(loanWarehouse1.Warehouse__c,ware.Id);
        
        //Inserting LoanWarehouse
        Loan_Warehouse__c loanWarehouse = ElixirTestHelper.returnLoanWarehouse(ware.Id,app.Id);
        insert loanWarehouse;
        System.assertEquals(loanWarehouse.Warehouse__c,ware.Id);
        
        //Inserting Custom Setting
        Disable_Custom_Triggers__c dis = Disable_Custom_Triggers__c.getOrgDefaults();
        dis.LoanWarehouseTrigger__c = false;
        insert dis;
        System.assertEquals(dis.LoanWarehouseTrigger__c,false);
        
        //Inserting Conversion Mapping
        genesis__Conversion_Mapping_Header__c conHead = new genesis__Conversion_Mapping_Header__c();
        conHead.genesis__Product_Type__c = 'LOAN';
        insert conHead;
        System.assertEquals(conHead.genesis__Product_Type__c,'LOAN');
        
        genesis__Conversion_Mapping__c conMap1 = ElixirTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Loan_Amount__c','loan__Loan_Account__c','loan__Loan_Amount__c');
        genesis__Conversion_Mapping__c conMap2 = ElixirTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Interest_Only_Period__c','loan__Loan_Account__c','loan__Interest_Only_Period__c');
        genesis__Conversion_Mapping__c conMap3 = ElixirTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Payment_Frequency__c','loan__Loan_Account__c','loan__Frequency_of_Loan_Payment__c');
        genesis__Conversion_Mapping__c conMap4 = ElixirTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Interest_Rate__c','loan__Loan_Account__c','loan__Interest_Rate__c');
        genesis__Conversion_Mapping__c conMap5 = ElixirTestHelper.returnConversionMapping(conHead.Id,'genesis__Applications__c','genesis__Term__c','loan__Loan_Account__c','loan__Number_of_Installments__c');
        List<genesis__Conversion_Mapping__c> conMapList = new List<genesis__Conversion_Mapping__c>();
        conMapList.add(conMap1);
        conMapList.add(conMap2);
        conMapList.add(conMap3);
        conMapList.add(conMap4);
        insert conMapList;
        //System.assertEquals(conMap1.size(),4);
        
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
        update loanC;
        System.assertEquals(loanC.loan__Next_Installment_Date__c,Date.today());

        loan__Payment_Mode__c pmt = new loan__Payment_Mode__c();
        pmt.name = 'ACH';
        insert pmt;
        System.assertEquals(pmt.name,'ACH');

        loan__Bank_Account__c bank = new loan__Bank_Account__c();
        bank.loan__Account__c = acc.Id;
        bank.loan__Active__c = True;
        bank.loan__Bank_Account_Number__c = '123456';
        bank.loan__Bank_Name__c = 'ABCD';
        insert bank;
        System.assertEquals(bank.loan__Active__c,True);

        loanC.loan__Loan_Status__c = 'Approved';
        update loanC;
        loan__Fee__c feeAmt = new loan__Fee__c(name = 'Application Fee', loan__Amount__c = 400,loan__Time_of_charge__c='Pre-Paid Fees');
        insert feeAmt;
        System.assertEquals(feeAmt.name,'Application Fee');
        
        loan__Fee__c feeAmtNext = new loan__Fee__c(name = 'Drawdown Prepaid Interest', loan__Amount__c = 400,loan__Time_of_charge__c='Other');
        insert feeAmtNext;
        System.assertEquals(feeAmtNext.name,'Drawdown Prepaid Interest');
        
        loan__Contract_Pre_Paid_Fee__c conFee = new loan__Contract_Pre_Paid_Fee__c(loan__Amount__c = 400,loan__Contract__c = loanC.Id,loan__Fee_Type__c = feeAmt.Id);
        insert conFee;
        System.assertEquals(conFee.loan__Amount__c,400);

        clcommon__Deposit__c dep = new clcommon__Deposit__c();
        dep.loan__Loan_Account__c = loanC.id;
        dep.clcommon__Current_Deposit_Rate__c =10;
        dep.clcommon__Deposit_Amount__c = 4000;
        dep.clcommon__Deposit_Rate__c = 10;
        insert dep;
        System.assertEquals(dep.clcommon__Current_Deposit_Rate__c,10);

        test.startTest();
        ConvertToContract.executeFun(app.Id);
        app.CL_Contract__c = loanC.Id;
        update app;
        WarehouseFunding.executeFun(loanC.Id,ware.Id);
        //clcommon__Deposit__c dep = [SELECT id,name,clcommon__Current_Deposit_Amount__c,loan__Loan_Account__c FROM clcommon__Deposit__c WHERE loan__Loan_Account__c = :loanC.Id LIMIT 1];
        dep.clcommon__Current_Deposit_Amount__c =2000;
        update dep;
        DepositWithdrawal.withdrawAmt(loanC.Id);
        PageReference pageRef = Page.loan__tabbedLoanAccount;
        pageRef.getParameters().put('LoanId', loanC.id);
        Test.setCurrentPage(pageRef);
        RedrawController controller = new RedrawController();
        controller.acct = loanC;
        controller.message = 'Sample Message';
        controller.doRedraw();
        test.stopTest();
    }
}