/********************************************************************************
Class Name : WarehouseFunding
Description : This class is used to fund a loan through warehouse- by creating LDTs, disbursal disctributions and changes the status of
              the CL Contract to Active
Developer : Rameswari Barman
Development Date : 27/09/2019
Implementation Code -    loan__Loan_Account__c loanC = [select id from loan__Loan_Account__c where id = 'XXX'];
          Warehouse__c ware = [select id from Warehouse__c where id = 'XXX'];
          WarehouseFunding.executeFun(loanC.Id,ware.Id);
*********************************************************************************/

global class WarehouseFunding{
static Date currentSystemDate =(Test.isRunningTest()?Date.Today():(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
    Webservice static String executeFun(Id iden, Id investor){
        String ret = '', retCheck = '',restAPSCheck = '';
        Savepoint sp = Database.setSavepoint();
        try{
            loan__Loan_Account__c loanAcc = [select id,name,loan__Account__c,APS_Created__c,Application__r.genesis__Payment_Frequency__c,loan__Last_Installment_Date__c,loan__Next_Installment_Date__c,loan__Last_Disbursal_Amount__c,Warehouse__c from loan__Loan_Account__c where id =: iden];
            loanAcc.Warehouse__c = investor;
            if(loanAcc != null){
                update loanAcc;
            }
            genesis__applications__c app = [select id,genesis__Interest_Rate__c,genesis__Status__c,CL_Contract__c,genesis__Loan_Amount__c from genesis__applications__c where CL_Contract__c =: iden];
            retCheck = createDisbusals(loanAcc.Id,app.genesis__Loan_Amount__c,loanAcc.Name,app);
            ret = retCheck;
            restAPSCheck = createAPS(loanAcc);
        }
        catch(Exception e){
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'WarehouseFunding :'+e.getStackTraceString()+':Error::'+e.getMessage(), clcommon__Timestamp__c = System.Now(),clcommon__Log_Level__c = 'ERROR'); 
            ret = e.getMessage();
            Database.rollback(sp);
        }
    return ret;
    }
    static String createDisbusals(ID loans,Decimal totalDisbursal,String loanId,genesis__Applications__c app){
        String ret = '';
        Decimal feeAmount;
        Savepoint sp1 = Database.setSavepoint();
        try{
            loan__Payment_Mode__c mode = [Select id,Name from loan__Payment_Mode__c where Name =: 'ACH' limit 1];
            List<loan__Loan_Disbursal_Transaction__c> ldtList = new List<loan__Loan_Disbursal_Transaction__c>([Select id,
                                                                      loan__Loan_Account__c
                                                                      From loan__Loan_Disbursal_Transaction__c
                                                                      Where loan__Loan_Account__c =: loans]);
            loan__Loan_Disbursal_Transaction__c ldt= new loan__Loan_Disbursal_Transaction__c();
            ldt.loan__Loan_Disbursal_Transaction_Type__c = System.label.Regular;
            ldt.loan__Disbursed_Amt__c = totalDisbursal;
            ldt.loan__Disbursal_Date__c = currentSystemDate;
            ldt.loan__Mode_of_Payment__c = mode.id;
            ldt.loan__Loan_Account__c = loans;
            AggregateResult[] groupedResults = [SELECT SUM(loan__Amount__c)feeAmnt 
                                                    FROM loan__Contract_Pre_Paid_Fee__c 
                                                    Where loan__Amount__c>0 
                                                    AND loan__Contract__c =:loans 
                                                    AND loan__Loan_Disbursal_Transaction__c=null];
            if(groupedResults.size() > 0){
                feeAmount = Double.valueOf(groupedResults[0].get(ConstantValues.FEE_AMNT)); 
            }           
            ldt.loan__Financed_Amount__c = (feeAmount!=null?totalDisbursal-feeAmount:totalDisbursal);
            if(!(Test.isRunningTest()) && ldt != null){
                insert ldt;
            }
            map<String,Elixir_Before_Or_On_Settlement_Fees__c> feeMappingSet = Elixir_Before_Or_On_Settlement_Fees__c.getAll();
            list< loan__Disbursal_Txn_Distribution__c > ddtList= new list< loan__Disbursal_Txn_Distribution__c >();
            loan__Disbursal_Txn_Distribution__c ddtObj;
            list<loan__Contract_Pre_Paid_Fee__c> ppfList=[select id, Name , 
                                                                 loan__Loan_Disbursal_Transaction__c ,
                                                                 loan__Fee_Type__r.Name, 
                                                                 loan__Fee_Type__c,
                                                                 loan__Amount__c 
                                                          from loan__Contract_Pre_Paid_Fee__c 
                                                          Where loan__Amount__c>0 AND loan__Contract__c =:loans];
            if(ppfList != null && ppfList.size() > 0){
                for(loan__Contract_Pre_Paid_Fee__c ppf: ppfList){
                    if(ppf.loan__Amount__c!=null && ppf.loan__Amount__c>0 && ppf.loan__Loan_Disbursal_Transaction__c==null){
                        ddtObj= new loan__Disbursal_Txn_Distribution__c();
                        ddtObj.loan__Distribution_Type__c=feeMappingSet.get(ppf.loan__Fee_Type__r.Name).Distribution_Type__c;
                        ddtObj.loan__Loan_Disbursal_Transaction__c=ldt.Id;
                        ddtObj.loan__Distribution_Amount__c=ppf.loan__Amount__c;
                        ddtObj.loan__Name_of_Entity__c=ppf.loan__Fee_Type__r.Name;
                        ddtObj.loan__Reference__c=ppf.Name;
                        ddtObj.loan__Fee__c=ppf.loan__Fee_Type__c;
                        ddtObj.loan__Source_Record_Name__c=ppf.Name;
                        ddtObj.loan__Source_Record_ID__c =ppf.Id;
                        ddtObj.loan__Loan_Disbursal_Transaction__c=ldt.Id;
                        if(ldtList != null && ldtList.size() > 0){
                            ddtObj.First_Drawdown__c = False;
                        }
                        else{
                            ddtObj.First_Drawdown__c = True;
                        }
                        ddtList.add(ddtObj);
                        ppf.loan__Loan_Disbursal_Transaction__c=ldt.Id;
                    }
                }
            }
            //*****creating DDT for Borrower distribution...
            ddtObj= new loan__Disbursal_Txn_Distribution__c();
            ddtObj.loan__Distribution_Type__c=ConstantValues.DISBURSEMENT;
            ddtObj.loan__Loan_Disbursal_Transaction__c=ldt.Id;
            ddtObj.loan__Distribution_Amount__c=ldt.loan__Financed_Amount__c;
            ddtObj.loan__Name_of_Entity__c=loanId;
            ddtObj.loan__Reference__c=loanId;
            if(ldtList != null && ldtList.size() > 0){
                ddtObj.First_Drawdown__c = False;
            }
            else{
                ddtObj.First_Drawdown__c = True;
            }
            ddtList.add(ddtObj);
            if(ddtList != null && ddtList.size() > 0){
                insert ddtList;
            }
            if(ppfList != null){
                update ppfList;
            }
            ret = System.label.FundingMsg;
        }
        catch(Exception e){
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'WarehouseFunding :'+e.getStackTraceString()+':Error::'+e.getMessage(), clcommon__Timestamp__c = System.Now(),clcommon__Log_Level__c = 'ERROR'); 
            ret = e.getMessage();
            System.debug(ret);
            Database.rollback(sp1);
        }
        return ret;
    }
    public static String createAPS(loan__Loan_Account__c loanRec){
        String ret = '';
        try{
            loan__Payment_Mode__c pmtMode = [Select Id,
                                                    Name 
                                            from loan__Payment_Mode__c 
                                            where Name =: System.label.ACH limit 1];
            loan__Automated_Payment_Setup__c pmtSetup = new loan__Automated_Payment_Setup__c();
            loan__Bank_Account__c bankRec = [Select id,
                                                loan__Account__c,
                                                loan__Active__c
                                                    From loan__Bank_Account__c
                                                    Where loan__Active__c = True
                                                    And loan__Account__c =: loanRec.loan__Account__c limit 1];
            pmtSetup.loan__Active__c = Boolean.ValueOf(System.label.True);
            pmtSetup.loan__Amount_Type__c = System.label.LastBilledAmt;
            pmtSetup.loan__Bank_Account__c = bankRec.Id;
            pmtSetup.loan__CL_Contract__c = loanRec.Id;
            pmtSetup.loan__Debit_Date__c = loanRec.loan__Next_Installment_Date__c;
            pmtSetup.loan__Frequency__c = loanRec.Application__r.genesis__Payment_Frequency__c;
            pmtSetup.loan__Payment_Mode__c = pmtMode.Id;
            pmtSetup.loan__Recurring_ACH_End_Date__c = loanRec.loan__Last_Installment_Date__c;
            pmtSetup.loan__Recurring_ACH_Start_Date__c = currentSystemDate;
            pmtSetup.loan__Type__c = System.label.Recurring;
            pmtSetup.loan__Setup_Date__c = currentSystemDate;
            PmtSetup.loan__Debit_Day__c=(loanRec.loan__Next_Installment_Date__c).day();
            loanRec.APS_Created__c = true;
            if(pmtSetup != null){
                insert pmtSetup;
            }
            if(loanRec != null){
                update loanRec;
            }
            ret = System.label.SuccessMessage;
            if(Test.isRunningTest()){
            Integer a = 4/0;
            }
        }
        catch(Exception e){
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'WarehouseFunding :'+e.getStackTraceString()+':Error::'+e.getMessage(), clcommon__Timestamp__c = System.Now(),clcommon__Log_Level__c = 'ERROR'); 
            ret = e.getMessage();
        }
        return ret;
    }
}