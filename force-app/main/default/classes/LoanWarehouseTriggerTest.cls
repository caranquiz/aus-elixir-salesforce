/***********************************************************************************************************************
    Class Name - LoanWarehouseTriggerTest
    Developer - Rameswari Barman
    Purpose - Test class for LoanWarehouseTrigger and LoanWarehouseChangeHelper class
***********************************************************************************************************************/
    @isTest
    public with sharing class LoanWarehouseTriggerTest {    
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

            //Inserting Bpay payment mode
            loan__Payment_Mode__c mode1 = new loan__Payment_Mode__c(Name = 'Bpay');
            insert mode1;
            System.assertEquals(mode1.Name,'Bpay');
            
            //Inserting CL Product
            clcommon__CL_Product__c clProd = ElixirTestHelper.returnClProduct();
            insert clProd;
            System.assertEquals(clProd.clcommon__Product_Name__c,'Residential');
            
            //Inserting Bpay payment mode
            loan__Payment_Mode__c mode = new loan__Payment_Mode__c(Name = 'Bpay');
            insert mode;
            System.assertEquals(mode.Name,'Bpay');
            
            //Inserting Loan Purpose
            loan__Loan_Purpose__c lp = new loan__Loan_Purpose__c(Name='Investment',loan__Description__c='Investment',loan__Loan_Purpose_Code__c='Investment');
            insert lp;
            System.assertEquals(lp.name,'Investment');
            
            //Inserting Account
            Account acc = ElixirTestHelper.returnBorrowerAccount(legEntity.Id);
            acc.Bank_Account_Number__c = '123445';
            acc.BSB__c = '123456';
            acc.Bank_Account_Name__c = 'Test';
            insert acc;
            System.assertEquals(acc.name,'Rameswari Barman');
            
            //Inserting Application
            genesis__applications__c app = ElixirTestHelper.returnApplication(acc.Id);
            app.genesis__Payment_Frequency__c = 'Monthly';
            app.Drawdown_Prepaid_Interest__c = 1000;
            app.genesis__CL_Product__c = clProd.id;
            app.Proposed_repayment_method_list__c = 'Bpay';
            app.Primary_loan_purpose_list__c = 'Investment';
            insert app;
            System.debug('test=='+app.genesis__CL_Product_Name__c);
            System.assertEquals(app.genesis__account__c,acc.Id);
            
            //Inserting Warehouse
            Warehouse__c ware = ElixirTestHelper.returnWarehouse();
            insert ware;
            System.assertEquals(ware.name,'Warehouse 1');
            
            Account acc1 = ElixirTestHelper.returnBorrowerAccount(legEntity.Id);
            acc1.Name = 'Rameswari Barman Broker';
            insert acc1;
            System.assertEquals(acc1.name,'Rameswari Barman Broker');
            
            clcommon__Party_Type__c partyType = new clcommon__Party_Type__c(name = 'Broker');
            insert partyType;
            System.assertEquals(partyType.name,'Broker');
            
            clcommon__Party__c broParty = new clcommon__Party__c(genesis__Application__c = app.Id,clcommon__Type__c=partyType.Id,Upfront_Payment_Percentage__c = 0.5,Commission_Paid_To__c = 'Broker', clcommon__Account__c = acc1.Id);
            insert broParty;
            System.assertEquals(broParty.genesis__Application__c,app.Id);
            
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
            System.assertEquals(conMapList.size(),4);
            
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
            
            /*loan__Loan_Account__c loanCBro = ElixirTestHelper.returnLoanAccount();
            loanCBro.loan__Account__c = acc.Id;
            loanCBro.loan__Loan_Amount__c = 1000;
            loanCBro.loan__Frequency_of_Loan_Payment__c = ConstantValues.MONTHLY;
            loanCBro.Loan__Loan_Status__c = 'Approved';
            loanCBro.Application__c = app.id;
            loanCBro.APS_Created__c = false;
            loanCBro.loan__Account__c = acc.Id;
            loanCBro.loan__Last_Installment_Date__c = Date.today();
            loanCBro.loan__Next_Installment_Date__c = Date.today();
            loanCBro.loan__Principal_Remaining__c = 100;
            update loanCBro;
            System.assertEquals(loanCBro.loan__Next_Installment_Date__c,Date.today());*/
    
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
    
            loan__Transaction_Summary__c tranSum = new loan__Transaction_Summary__c();
            tranSum.loan__Loan_Account__c = loanC.Id;
            tranSum.loan__Txn_Date__c = Date.today();
            insert tranSum;
            System.assertEquals(tranSum.loan__Loan_Account__c,loanC.Id);
            List <loan__Transaction_Summary__c> transList = new List<loan__Transaction_Summary__c>();
            transList.add(tranSum);
            test.startTest();
            ConvertToContract.executeFun(app.Id);
            app.CL_Contract__c = loanC.Id;
            update app;
            ConvertToContract.attachValues(app.Id);
            WarehouseFunding.executeFun(loanC.Id,ware.Id);
            PageReference pageRef = Page.loan__tabbedLoanAccount;
            pageRef.getParameters().put('LoanId', loanC.id);
            Test.setCurrentPage(pageRef);
            WarehouseController cont = new WarehouseController();
            cont.acct = loanC;
            cont.Save();
            cont.Cancel();
            
            TransactionController trans = new TransactionController();
            trans.txnList = transList;
            trans.doSearch();
            trans.exportToPDF();
            
            //WarehouseFunding.executeFun(loanCBro.Id,ware.Id);
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

            //Inserting Bpay payment mode
            loan__Payment_Mode__c mode = new loan__Payment_Mode__c(Name = 'Bpay');
            insert mode;
            System.assertEquals(mode.Name,'Bpay');
            
            //Inserting Loan Purpose
            loan__Loan_Purpose__c lp = new loan__Loan_Purpose__c(Name='Investment',loan__Description__c='Investment',loan__Loan_Purpose_Code__c='Investment');
            insert lp;
            System.assertEquals(lp.name,'Investment');
            
            //Inserting CL Product
            clcommon__CL_Product__c clProd = ElixirTestHelper.returnClProduct();
            insert clProd;
            System.assertEquals(clProd.clcommon__Product_Name__c,'Residential');
            
            
            
            //Inserting Account
            Account acc = ElixirTestHelper.returnBorrowerAccount(legEntity.Id);
            acc.Bank_Account_Number__c = '123445';
            acc.BSB__c = '123456';
            acc.Bank_Account_Name__c = 'Test';
            insert acc;
            System.assertEquals(acc.name,'Rameswari Barman');
            
            //Inserting Application
            genesis__applications__c app = ElixirTestHelper.returnApplication(acc.Id);
            app.genesis__Payment_Frequency__c = 'Monthly';
            app.Drawdown_Prepaid_Interest__c = 1000;
            app.genesis__CL_Product__c = clProd.id;
            app.Proposed_repayment_method_list__c = 'Bpay';
            app.Primary_loan_purpose_list__c = 'Investment';
            insert app;
            System.assertEquals(app.genesis__account__c,acc.Id);
            
            //Inserting Warehouse
            Warehouse__c ware = ElixirTestHelper.returnWarehouse();
            insert ware;
            System.assertEquals(ware.name,'Warehouse 1');
            
            Account acc1 = ElixirTestHelper.returnBorrowerAccount(legEntity.Id);
            acc1.Name = 'Rameswari Barman Broker';
            insert acc1;
            System.assertEquals(acc1.name,'Rameswari Barman Broker');
            
            clcommon__Party_Type__c partyType = new clcommon__Party_Type__c(name = 'Broker');
            insert partyType;
            System.assertEquals(partyType.name,'Broker');
            
            clcommon__Party__c broParty = new clcommon__Party__c(genesis__Application__c = app.Id,clcommon__Type__c=partyType.Id,Upfront_Payment_Percentage__c = 0.5,Commission_Paid_To__c = 'Aggregator', clcommon__Account__c = acc1.Id);
            insert broParty;
            System.assertEquals(broParty.genesis__Application__c,app.Id);
            
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
            System.assertEquals(conMapList.size(),4);
            
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
            
            /*loan__Loan_Account__c loanCBro = ElixirTestHelper.returnLoanAccount();
            loanCBro.loan__Account__c = acc.Id;
            loanCBro.loan__Loan_Amount__c = 1000;
            loanCBro.loan__Frequency_of_Loan_Payment__c = ConstantValues.MONTHLY;
            loanCBro.Loan__Loan_Status__c = 'Approved';
            loanCBro.Application__c = app.id;
            loanCBro.APS_Created__c = false;
            loanCBro.loan__Account__c = acc.Id;
            loanCBro.loan__Last_Installment_Date__c = Date.today();
            loanCBro.loan__Next_Installment_Date__c = Date.today();
            loanCBro.loan__Principal_Remaining__c = 100;
            update loanCBro;
            System.assertEquals(loanCBro.loan__Next_Installment_Date__c,Date.today());*/
    
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
    
            test.startTest();
            ConvertToContract.executeFun(app.Id);
            app.CL_Contract__c = loanC.Id;
            update app;
            ConvertToContract.attachValues(app.Id);
            WarehouseFunding.executeFun(loanC.Id,ware.Id);
            //WarehouseFunding.executeFun(loanCBro.Id,ware.Id);
            test.stopTest();
        }
        static testMethod void test3(){
            
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
            
            //Inserting Bpay payment mode
            loan__Payment_Mode__c mode = new loan__Payment_Mode__c(Name = 'Bpay');
            insert mode;
            System.assertEquals(mode.Name,'Bpay');
            
            //Inserting Loan Purpose
            loan__Loan_Purpose__c lp = new loan__Loan_Purpose__c(Name='Investment',loan__Description__c='Investment',loan__Loan_Purpose_Code__c='Investment');
            insert lp;
            System.assertEquals(lp.name,'Investment');
            
            //Inserting CL Product
            clcommon__CL_Product__c clProd = ElixirTestHelper.returnClProduct3();
            insert clProd;
            System.assertEquals(clProd.clcommon__Product_Name__c,'Residential Construction');
            
            
            
            //Inserting Account
            Account acc = ElixirTestHelper.returnBorrowerAccount(legEntity.Id);
            acc.Bank_Account_Number__c = '123445';
            acc.BSB__c = '123456';
            acc.Bank_Account_Name__c = 'Test';
            insert acc;
            System.assertEquals(acc.name,'Rameswari Barman');
            
            //Inserting Application
            genesis__applications__c app = ElixirTestHelper.returnApplication(acc.Id);
            app.genesis__Payment_Frequency__c = 'WEEKLY';
            app.Drawdown_Prepaid_Interest__c = 1000;
            app.genesis__CL_Product__c = clProd.id;
            app.Proposed_repayment_method_list__c = 'Bpay';
            app.Primary_loan_purpose_list__c = 'Investment';
            app.genesis__Initial_Advance__c = 100000;
            app.First_Tranche_Prepaid_Interest__c = 1000;
            app.Total_Subsequent_Drawdown__c = 2000000;
            app.Subsequent_Drawdown_Prepaid_Interest_Sum__c = 50000;
            insert app;
            System.assertEquals(app.genesis__account__c,acc.Id);
            
            //Inserting Warehouse
            Warehouse__c ware = ElixirTestHelper.returnWarehouse();
            insert ware;
            System.assertEquals(ware.name,'Warehouse 1');
            
            Account acc1 = ElixirTestHelper.returnBorrowerAccount(legEntity.Id);
            acc1.Name = 'Rameswari Barman Broker';
            insert acc1;
            System.assertEquals(acc1.name,'Rameswari Barman Broker');
            
            clcommon__Party_Type__c partyType = new clcommon__Party_Type__c(name = 'Broker');
            insert partyType;
            System.assertEquals(partyType.name,'Broker');
            
            clcommon__Party__c broParty = new clcommon__Party__c(genesis__Application__c = app.Id,clcommon__Type__c=partyType.Id,Upfront_Payment_Percentage__c = 0.5,Commission_Paid_To__c = 'Broker', clcommon__Account__c = acc1.Id);
            insert broParty;
            System.assertEquals(broParty.genesis__Application__c,app.Id);
            
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
            System.assertEquals(conMapList.size(),4);
            
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
            
            /*loan__Loan_Account__c loanCBro = ElixirTestHelper.returnLoanAccount();
            loanCBro.loan__Account__c = acc.Id;
            loanCBro.loan__Loan_Amount__c = 1000;
            loanCBro.loan__Frequency_of_Loan_Payment__c = ConstantValues.MONTHLY;
            loanCBro.Loan__Loan_Status__c = 'Approved';
            loanCBro.Application__c = app.id;
            loanCBro.APS_Created__c = false;
            loanCBro.loan__Account__c = acc.Id;
            loanCBro.loan__Last_Installment_Date__c = Date.today();
            loanCBro.loan__Next_Installment_Date__c = Date.today();
            loanCBro.loan__Principal_Remaining__c = 100;
            update loanCBro;
            System.assertEquals(loanCBro.loan__Next_Installment_Date__c,Date.today());*/
    
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
    
            test.startTest();
            ConvertToContract.executeFun(app.Id);
            app.CL_Contract__c = loanC.Id;
            update app;
            ConvertToContract.attachValues(app.Id);
            WarehouseFunding.executeFun(loanC.Id,ware.Id);
            //WarehouseFunding.executeFun(loanCBro.Id,ware.Id);
            test.stopTest();
        }
        static testMethod void test4(){
            
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

            //Inserting Bpay payment mode
            loan__Payment_Mode__c mode = new loan__Payment_Mode__c(Name = 'Bpay');
            insert mode;
            System.assertEquals(mode.Name,'Bpay');
            
            //Inserting Loan Purpose
            loan__Loan_Purpose__c lp = new loan__Loan_Purpose__c(Name='Investment',loan__Description__c='Investment',loan__Loan_Purpose_Code__c='Investment');
            insert lp;
            System.assertEquals(lp.name,'Investment');
            
            //Inserting CL Product
            clcommon__CL_Product__c clProd = ElixirTestHelper.returnClProduct();
            insert clProd;
            System.assertEquals(clProd.clcommon__Product_Name__c,'Residential');
            
            
            
            //Inserting Account
            Account acc = ElixirTestHelper.returnBorrowerAccount(legEntity.Id);
            acc.Bank_Account_Number__c = '123445';
            acc.BSB__c = '123456';
            acc.Bank_Account_Name__c = 'Test';
            insert acc;
            System.assertEquals(acc.name,'Rameswari Barman');
            
            //Inserting Application
            genesis__applications__c app = ElixirTestHelper.returnApplication(acc.Id);
            app.genesis__Payment_Frequency__c = 'BI-WEEKLY';
            app.Drawdown_Prepaid_Interest__c = 1000;
            //System.debug('cl product==' + select id from clcommon__CL_Product__c where clcommon__Product_Name__c =: System.label.Construction_Development);
            app.genesis__CL_Product__c = clProd.id;
            app.Proposed_repayment_method_list__c = 'Bpay';
            app.Primary_loan_purpose_list__c = 'Investment';
            insert app;
            System.assertEquals(app.genesis__account__c,acc.Id);
            
            //Inserting Warehouse
            Warehouse__c ware = ElixirTestHelper.returnWarehouse();
            insert ware;
            System.assertEquals(ware.name,'Warehouse 1');
            
            Account acc1 = ElixirTestHelper.returnBorrowerAccount(legEntity.Id);
            acc1.Name = 'Rameswari Barman Broker';
            insert acc1;
            System.assertEquals(acc1.name,'Rameswari Barman Broker');
            
            clcommon__Party_Type__c partyType = new clcommon__Party_Type__c(name = 'Broker');
            insert partyType;
            System.assertEquals(partyType.name,'Broker');
            
            clcommon__Party__c broParty = new clcommon__Party__c(genesis__Application__c = app.Id,clcommon__Type__c=partyType.Id,Upfront_Payment_Percentage__c = 0.5,Commission_Paid_To__c = 'Broker', clcommon__Account__c = acc1.Id);
            insert broParty;
            System.assertEquals(broParty.genesis__Application__c,app.Id);
            
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
            System.assertEquals(conMapList.size(),4);
            
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
            
            /*loan__Loan_Account__c loanCBro = ElixirTestHelper.returnLoanAccount();
            loanCBro.loan__Account__c = acc.Id;
            loanCBro.loan__Loan_Amount__c = 1000;
            loanCBro.loan__Frequency_of_Loan_Payment__c = ConstantValues.MONTHLY;
            loanCBro.Loan__Loan_Status__c = 'Approved';
            loanCBro.Application__c = app.id;
            loanCBro.APS_Created__c = false;
            loanCBro.loan__Account__c = acc.Id;
            loanCBro.loan__Last_Installment_Date__c = Date.today();
            loanCBro.loan__Next_Installment_Date__c = Date.today();
            loanCBro.loan__Principal_Remaining__c = 100;
            update loanCBro;
            System.assertEquals(loanCBro.loan__Next_Installment_Date__c,Date.today());*/
    
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
    
            test.startTest();
            ConvertToContract.executeFun(app.Id);
            app.CL_Contract__c = loanC.Id;
            update app;
            ConvertToContract.attachValues(app.Id);
            WarehouseFunding.executeFun(loanC.Id,ware.Id);
            //WarehouseFunding.executeFun(loanCBro.Id,ware.Id);
            test.stopTest();
        }
    }