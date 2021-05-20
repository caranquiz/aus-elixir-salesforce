/*********************************************************************************************************
Class Name     : ElixirTestHelper
Description    : Apex class for helping in developing Test Classes
Developer      : Rameswari Barman
**********************************************************************************************************/
@isTest
public with sharing class ElixirTestHelper {

    public static clcommon__Legal_Entity__c returnLegalEntity(){
    
        //Inserting legal entity
        clcommon__Legal_Entity__c legEntity = new clcommon__Legal_Entity__c(Name = 'Individual');
        return legEntity;
        }
        
    public static Account returnBorrowerAccount(Id legEntityId){
    
        //Inserting account
        Account acc = new Account(name = 'Rameswari Barman',clcommon__Legal_Entity_Type__c = legEntityId);
        return acc;
    }

    public static clcommon__CL_Product__c returnClProduct(){

        //Inserting cl product
        clcommon__CL_Product__c clProd = new clcommon__CL_Product__c(clcommon__Product_Name__c='Residential');
        return clProd;
    }

    public static clcommon__CL_Product__c returnClProduct2(){

        //Inserting cl product
        clcommon__CL_Product__c clProd = new clcommon__CL_Product__c(clcommon__Product_Name__c='Commercial');
        return clProd;
    }

    public static clcommon__CL_Product__c returnClProduct3(){

        //Inserting cl product
        clcommon__CL_Product__c clProd = new clcommon__CL_Product__c(clcommon__Product_Name__c='Residential Construction');
        return clProd;
    }
        
    public static genesis__applications__c returnApplication(Id accId){
    
        //Inserting application
        genesis__applications__c app = new genesis__applications__c(genesis__account__c = accId);
        app.genesis__Interest_Rate__c = 10;
        app.genesis__Loan_Amount__c = 100000;
        //************
        app.genesis__Initial_Advance__c = 90000;
        app.First_Tranche_Prepaid_Interest__c = 5000;
        app.Subsequent_Drawdown__c = 90000;
        app.Drawdown_Prepaid_Interest__c = 1000;
        app.Construction_Progress_Payment_Fee__c = 3000;
        //************/
        app.genesis__Status__c = 'APPROVED';
        app.genesis__Expected_Start_Date__c= Date.Today();
        return app;
    }
        
    public static Warehouse__c returnWarehouse(){
        
        //Inserting warehouse
        Warehouse__c ware = new Warehouse__c(name = 'Warehouse 1');
        return ware;
    }
    
    public static Loan_Warehouse__c returnLoanWarehouse(Id ware,Id app){
        
        //Inserting loan warehouse
        Loan_Warehouse__c wh = new Loan_Warehouse__c(Warehouse__c = ware, Application__c = app);
        return wh;
    }
    public static loan__Loan_Account__c returnLoan(Id accId, Id appId){
    
        //Inserting CL Contract
        loan__Loan_Account__c loan = new loan__Loan_Account__c(loan__Account__c=accId,Application__c=appId);
        loan.loan__Frequency_of_Loan_Payment__c = 'Monthly';
        return loan;
    }
    public static loan__Loan_Account__c returnLoanAccount() {
        
        loan.TestHelper.createSeedDataForTesting();
        
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        //Create a dummy MF_Account
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        loan__MF_Account__c dummyIncAccount = loan.TestHelper.createMFAccount('XXXIncAccountForTest','30000 - INCOME');
        
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr,dummyIncAccount ,dummyAccount);                                   
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);
        
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        
        //Create a dummy Loan Product
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(dummyOffice,
                            dummyAccount, 
                            curr, 
                            dummyFeeSet);
        
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();        
        dummyLoanPurpose.loan__Loan_Purpose_Code__c = 'Refinance';
        upsert dummyLoanPurpose;
        
        
        account dummyClient = new account(); 
        dummyClient.Name = 'Elixir';
        insert dummyClient;
        
        //Create a dummy Loan Account
        loan__Loan_Account__c loanAccount = loan.TestHelper.createLoanAccountForAccountObj(dummyLP,
                                                    dummyClient,
                                                    dummyFeeSet,
                                                    dummyLoanPurpose,
                                                    dummyOffice);
        loanAccount.loan__Number_of_Installments__c     = 12;                                  
        loanAccount.Loan__Loan_Status__c                = loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING;
        loanAccount.Loan__Fees_Remaining__c             = 100;
        loanAccount.Loan__Interest_Remaining__c         = 500;
        loanAccount.Loan__Principal_Remaining__c        = 1000;
        loanAccount.Loan__Fractionalization_Status__c   = loan.LoanConstants.FRACTIONALIZATION_STATUS_ACTIVE;
        loanAccount.Loan__Pay_off_Amount_As_Of_Today__c = loanAccount.loan__Fees_Remaining__c + loanAccount.loan__Principal_Remaining__c;
        

        return loanAccount;
    }
    public static clcommon__Bank_Account__c returnmoneyAccount(string accNm){
       clcommon__Bank_Account__c trstAcc1 = new clcommon__Bank_Account__c();
       trstAcc1.clcommon__Bank_Name__c = 'ICICI';
       trstAcc1.clcommon__Bank_Account_Number__c = '011206715';
       trstAcc1.clcommon__Active__c = True ;
       trstAcc1.clcommon__Account_Usage__c = accNm;
       return trstAcc1 ;

    }
    public static loan__Bank_Account__c returnTrustAccount(string accNm,String conId){
       loan__Bank_Account__c trstAcc = new loan__Bank_Account__c();
       trstAcc.loan__Bank_Name__c = 'ICICI';
       trstAcc.loan__Bank_Account_Number__c = '011206715';
       trstAcc.loan__Active__c = True ;
       trstAcc.loan__Account_Usage__c = accNm;
       trstAcc.loan__Contact__c=conId;
       return trstAcc ;

    }
    public static peer__Loan_Application__c createLoanApplication(Account accTest){
    
        peer__Loan_Application__c loanApp  =  new peer__Loan_Application__c();
        loanApp.peer__Borrower__c                =  accTest.id;
        loanApp.peer__Requested_Loan_Amount__c   =  1000;
        loanApp.peer__Interest_Rate__c           =  3;
        loanApp.peer__Term__c                    =  12;
        loanApp.peer__Stage__c = 'In Funding';
        loanApp.peer__Loan_Purpose__c            =  'Personal';
        
        return loanApp;
    }
    public static loan__Bank_Account__c returnBankAccount(string accNm,String conId){
       loan__Bank_Account__c bnkAcc = new loan__Bank_Account__c();
       bnkAcc.loan__Bank_Name__c = 'Axis';
       bnkAcc.loan__Bank_Account_Number__c = '011201345';
       bnkAcc.loan__Active__c = True ;
       bnkAcc.loan__Account_Usage__c = accNm;
       bnkAcc.loan__Contact__c=conId;
       return bnkAcc;

    }
    public static loan__Loan_Disbursal_Transaction__c  returnLoanDisbursal(loan__Loan_Account__c contractObj) {
         loan__Loan_Disbursal_Transaction__c  loanPayment  =  new loan__Loan_Disbursal_Transaction__c();
           loanPayment.loan__Disbursed_Amt__c       =  10000;
           loanPayment.loan__Loan_Account__c          =   contractObj.id;
           return loanPayment;
    
    }

    public static loan__Loan_Payment_Transaction__c   returnLoanPayment(loan__Loan_Account__c contractObj) {
         loan__Loan_Payment_Transaction__c   loanPayment  =  new loan__Loan_Payment_Transaction__c ();
            loanPayment.loan__Transaction_Amount__c    =  10000;
            loanPayment.loan__Loan_Account__c          =   contractObj.id;
           return loanPayment;
    
    }
    
    public static loan__Loan_account_Due_Details__c createUnpaidDue(loan__Loan_Account__c loanAccount, Decimal dueAmount){
        loan__Loan_account_Due_Details__c bill = loan.TestHelper.createUnpaidDue(loanAccount,dueAmount);
        return bill;
    }
    
    public static loan__Investor_Loan__c returninvLoan(Account a,loan__Loan_Account__c l,Decimal amt) {
        loan__Investor_Loan__c invLoan = loan.TestHelper2.createInvestmentOrder(a,l,amt);
        return invLoan;
    }
    
    public static loan__Investor_Loan_Account_Txns__c returnilTid(loan__Investor_Loan__c io, Decimal p, Decimal i, Decimal f) {
        loan__Investor_Loan_Account_Txns__c ilTid = loan.TestHelper2.createInvestorPaymentTxn(io,p,i,f);
        return ilTid;
    }
    public static genesis__Conversion_Mapping__c returnConversionMapping(Id conHead,String sourceObject, String sourceField,String DestinationObject,String DestinationField){
        genesis__Conversion_Mapping__c conMap = new genesis__Conversion_Mapping__c();
        conMap.genesis__Conversion_Mapping_Header__c = conHead;
        conMap.genesis__Product_Type__c = 'LOAN';
        conMap.genesis__Application_Object_Name__c = sourceObject;
        conMap.genesis__Application_Field_Name__c = sourceField;
        conMap.genesis__Contract_Object_Name__c = DestinationObject;
        conMap.genesis__Contract_Field_Name__c = DestinationField;
        return conMap;
    }
    public static Linked_Loan__c returnlinkedLoan(Id currLoan,Id LLoan){
        Linked_Loan__c linkedloan=new Linked_Loan__c();
        linkedloan.Current_Loan_Record__c=currLoan;
        linkedloan.Linked_Loan__c=LLoan;
        return linkedloan;
    }

    public static loan__Org_Parameters__c returnOrgParameter(){
        loan__Org_Parameters__c checkTrigger = new loan__Org_Parameters__c();
        checkTrigger.loan__Disable_Triggers__c = true;
        return checkTrigger;
    }
}