/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class update Loan Transaction summary fields 
            if backdated Charge is created.
Development Date : 29/12/2021
Last Modified Date : 30/12/2021
****************************************************************************************************/

global with sharing class LTSChargeUpdateBatch  implements DataBase.StateFul,DataBase.Batchable<sObject>,Schedulable{
    loan.GlobalLoanUtilFacade glutil = new loan.GlobalLoanUtilFacade();
    Date systemDate=!Test.isRunningTest()?glutil.getCurrentSystemDate():Date.today();
    Date todayDate=Date.today();
    //Query Charge whose Transaction Date is less than system Date.
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT id,
                                              Name,
                                              loan__Balance__c,
                                              loan__Date__c,
                                              CreatedDate,
                                              loan__Loan_Account__c,
                                              loan__Loan_Account__r.Id
                                          FROM loan__Charge__c
                                          WHERE Include_in_Summary__c= true
                                          AND loan__Date__c <: systemDate
                                          ORDER BY loan__Date__c DESC,CreatedDate DESC]);
    }
    //This method updates LTS.
    public void execute(Database.BatchableContext bc, List<loan__Charge__c> objChargeList) {
        try{
            List<Date> startDate=new List<Date>();
            Map<Id,Date> startDateMap=new Map<Id,Date>();
            List<Id> loanIdList=new List<Id>();
            Map<Id,Id> loanStatementCheckMap=new Map<Id,Id>();
            Map<Id,Decimal> openStatement=new Map<Id,Decimal>();

            for(loan__Charge__c objCharge : objChargeList){
                loanIdList.add(objCharge.loan__Loan_Account__r.Id);
                startDate.add(objCharge.loan__Date__c);
                startDateMap.put(objCharge.loan__Loan_Account__r.Id,objCharge.loan__Date__c);
            }
            List <loan__Loan_Transaction_Summary__c> transactionSummaryList = [SELECT Id,
                                                                                    Name,
                                                                                    loan__Transaction_Date__c,
                                                                                    Transaction_Type__c,
                                                                                    Debit__c,
                                                                                    Credit__c,
                                                                                    loan__Balance__c,
                                                                                    loan__Loan_Account__c,
                                                                                    loan__Current_Loan_Balance__c,
                                                                                    loan__Loan_Account__r.id,
                                                                                    loan__Consolidated_Loan_Balance__c
                                                                                FROM loan__Loan_Transaction_Summary__c
                                                                                WHERE loan__Transaction_Date__c >=: startDate
                                                                                AND loan__Loan_Account__c in: loanIdList
                                                                                AND loan__Consolidated_Loan_Balance__c != NULL
                                                                                AND loan__Last_Transaction_Type__c NOT IN (:ConstantValues.OTHER_TRANSACTION)
                                                                                AND (Transaction_Type__c IN (:ConstantValues.PAYMENT_RECEIVED,
                                                                                    :ConstantValues.INTEREST_TAG,:ConstantValues.REDRAW,:ConstantValues.DISBURSEMENT) 
                                                                                OR loan__Invalid_Data__c = false OR loan__Loan_Charge__c != null)
                                                                                AND (loan__Loan_Payment_Txn__c = null
                                                                                OR (loan__Loan_Payment_Txn__r.loan__Payment_Mode__r.Name NOT IN 
                                                                                    (:ConstantValues.DISCOUNT_TAG,:ConstantValues.INTERNAL_TRANSFER) 
                                                                                AND loan__Loan_Payment_Txn__r.loan__Rejected__c = false
                                                                                AND loan__Loan_Payment_Txn__r.loan__Reversed__c = false))
                                                                                AND (loan__Interest_Posting_Txn__c = null OR loan__Interest_Posting_Txn__r.loan__Reversed__c = false) 
                                                                                AND (loan__Other_Loan_Txn__c = null OR loan__Other_Loan_Txn__r.loan__Reversed__c = false) 
                                                                                AND (loan__Loan_Disbursal__c = null OR (loan__Loan_Disbursal__r.loan__Reversed__c= false 
                                                                                AND loan__Loan_Disbursal__r.loan__Rejected__c= false AND loan__Loan_Disbursal__r.loan__Cleared__c = true)) 
                                                                                AND (loan__Loan_Charge__c= null OR (loan__Loan_Charge__r.loan__Waive__c= false)) 
                                                                                ORDER BY loan__Transaction_Date__c ASC, CreatedDate ASC, loan__Transaction_Time__c ASC, Name ASC];
            List <loan__Loan_Transaction_Summary__c> openingBalanceList = [SELECT Id,
                                                                                loan__Transaction_Date__c,
                                                                                Transaction_Type__c,
                                                                                Debit__c,
                                                                                Credit__c,
                                                                                loan__Balance__c,
                                                                                loan__Loan_Account__c,
                                                                                loan__Loan_Account__r.id,
                                                                                loan__Current_Loan_Balance__c,
                                                                                loan__Consolidated_Loan_Balance__c
                                                                            FROM loan__Loan_Transaction_Summary__c
                                                                            WHERE loan__Loan_Account__c in: loanIdList
                                                                            AND loan__Transaction_Date__c <: startDate
                                                                            AND loan__Consolidated_Loan_Balance__c != NULL
                                                                            AND loan__Last_Transaction_Type__c NOT IN (:ConstantValues.OTHER_TRANSACTION)
                                                                            AND (Transaction_Type__c IN (:ConstantValues.PAYMENT_RECEIVED,
                                                                                :ConstantValues.INTEREST_TAG,:ConstantValues.REDRAW,:ConstantValues.DISBURSEMENT) 
                                                                            OR loan__Invalid_Data__c = false OR loan__Loan_Charge__c != null)
                                                                            AND (loan__Loan_Payment_Txn__c = null
                                                                            OR (loan__Loan_Payment_Txn__r.loan__Payment_Mode__r.Name NOT IN 
                                                                                (:ConstantValues.DISCOUNT_TAG,:ConstantValues.INTERNAL_TRANSFER) 
                                                                            AND loan__Loan_Payment_Txn__r.loan__Rejected__c = false
                                                                            AND loan__Loan_Payment_Txn__r.loan__Reversed__c = false))
                                                                            AND (loan__Interest_Posting_Txn__c = null OR loan__Interest_Posting_Txn__r.loan__Reversed__c = false) 
                                                                            AND (loan__Other_Loan_Txn__c = null OR loan__Other_Loan_Txn__r.loan__Reversed__c = false) 
                                                                            AND (loan__Loan_Disbursal__c = null OR (loan__Loan_Disbursal__r.loan__Reversed__c= false 
                                                                            AND loan__Loan_Disbursal__r.loan__Rejected__c= false AND loan__Loan_Disbursal__r.loan__Cleared__c = true)) 
                                                                            AND (loan__Loan_Charge__c= null OR (loan__Loan_Charge__r.loan__Waive__c= false)) 
                                                                            ORDER BY loan__Transaction_Date__c DESC, CreatedDate DESC, loan__Transaction_Time__c DESC, Name DESC ];   
            for(Id loanId:loanIdList){
                for(loan__Loan_Transaction_Summary__c openingBalance:openingBalanceList){
                    if(loanId==openingBalance.loan__Loan_Account__r.id && openingBalance.loan__Consolidated_Loan_Balance__c != NULL ){
                        openStatement.put(loanId,openingBalance.loan__Consolidated_Loan_Balance__c);
                        break;
                    }
                }
            }
            for(loan__Loan_Transaction_Summary__c transactionBalance:transactionSummaryList){
                loanStatementCheckMap.put(transactionBalance.id,transactionBalance.loan__Loan_Account__r.id);
            }
            for(loan__Loan_Transaction_Summary__c openingBalance:transactionSummaryList){
                if(loanStatementCheckMap.containsKey(openingBalance.id) && loanStatementCheckMap.get(openingBalance.id)!=NULL 
                    && loanStatementCheckMap.get(openingBalance.id)==openingBalance.loan__Loan_Account__r.id && openingBalance.loan__Consolidated_Loan_Balance__c != NULL 
                    && startDateMap.get(openingBalance.loan__Loan_Account__r.id)!=NULL&& openingBalance.loan__Transaction_Date__c>=startDateMap.get(openingBalance.loan__Loan_Account__r.id)
                    && openStatement.containsKey(openingBalance.loan__Loan_Account__r.id) && openStatement.get(openingBalance.loan__Loan_Account__r.id)!=NULL){
                    
                    if(openingBalance.Debit__c!=NULL){
                        openingBalance.loan__Consolidated_Loan_Balance__c=openStatement.get(openingBalance.loan__Loan_Account__r.id) + openingBalance.Debit__c;
                    }else if(openingBalance.Credit__c!=NULL){
                        openingBalance.loan__Consolidated_Loan_Balance__c=openStatement.get(openingBalance.loan__Loan_Account__r.id) - openingBalance.Credit__c;
                    }
                    openStatement.put(openingBalance.loan__Loan_Account__r.id,openingBalance.loan__Consolidated_Loan_Balance__c);
                }
            }
            
            if(transactionSummaryList.size()>0){
                Database.update(transactionSummaryList,false);
            }
        }catch(Exception exe){
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'LTSChargeUpdateBatch :Exception: '+exe.getStackTraceString()
                                        +'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
    }
    public void execute(SchedulableContext sc) {
        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        LTSChargeUpdateBatch obj = new LTSChargeUpdateBatch();
        Integer size = batch.LTSChargeUpdateBatch__c != NULL ? Integer.valueOf(batch.LTSChargeUpdateBatch__c) : 10;  
        database.executebatch(obj,size);
    }
    public void finish(Database.BatchableContext bc){
    }

}