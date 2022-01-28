/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class update Loan Transaction summary fields 
            if Transaction Amount OR Current Loan Balance OR Consolidated Loan Balance is NULL.
Development Date : 14/06/2021
Last Modified Date : 14/06/2021
****************************************************************************************************/

public class LTSRedrawUpdateBatch implements DataBase.StateFul,DataBase.Batchable<sObject>,Schedulable{
    loan.GlobalLoanUtilFacade glutil = new loan.GlobalLoanUtilFacade();
    Date systemDate=!Test.isRunningTest()?glutil.getCurrentSystemDate():Date.today();
    //Query LTS whose Transaction Type is 'Redraw' AND Transaction Amount OR Current Loan Balance OR Consolidated Loan Balance is NULL
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT id,
                                                Name,
                                                loan__Other_Loan_Txn__c,
                                                loan__Loan_Account__c,
                                                loan__Loan_Account__r.loan__Loan_Balance__c,
                                                loan__Loan_Account__r.loan__Loan_Amount__c,
                                                loan__Other_Loan_Txn__r.loan__Txn_Amt__c,
                                                loan__Other_Loan_Txn__r.id,
                                                loan__Loan_Account__r.Id,
                                                loan__Transaction_Amount__c,
                                                loan__Current_Loan_Balance__c,
                                                loan__Transaction_Time__c,
                                                loan__Transaction_Date__c,
                                                Transaction_Type__c,
                                                loan__Loan_Account__r.loan__Closed_Date__c,
                                                loan__Other_Loan_Txn__r.loan__Txn_Date__c,
                                                loan__Other_Loan_Txn__r.loan__Repayment_Start_Date__c,
                                                loan__Consolidated_Loan_Balance__c
                                            FROM loan__Loan_Transaction_Summary__c
                                            WHERE (Transaction_Type__c =: ConstantValues.REDRAW
                                            AND(loan__Transaction_Amount__c=NULL 
                                            OR loan__Consolidated_Loan_Balance__c=NULL
                                            OR loan__Current_Loan_Balance__c =NULL))
                                            OR  Transaction_Type__c =: ConstantValues.REFUND
                                            ORDER BY loan__Transaction_Date__c ASC,CreatedDate ASC]);
    }
    //This method updates LTS.
    public void execute(Database.BatchableContext bc, List<loan__Loan_Transaction_Summary__c> objLTSList) {
        try{
            List<clcommon__Deposit__c> objDepositList=new List<clcommon__Deposit__c>();
            Map<id,Decimal> depositMap=new Map<id,Decimal>();
            List<id> idOtherLoanList=new List<id>();
            List<Id> loanIdList=new List<Id>();
            List<id> backDatedLoanId=new List<Id>();
            List<Date> backDatedDate=new List<Date>();
            Map<Id,Date> backDatedDateList=new Map<Id,Date>();

            for(loan__Loan_Transaction_Summary__c objLTS:objLTSList){
                if(objLTS.Transaction_Type__c==ConstantValues.REDRAW && objLTS.loan__Other_Loan_Txn__c != NULL){
                    idOtherLoanList.add(objLTS.loan__Other_Loan_Txn__c);
                }
                if(objLTS.Transaction_Type__c==ConstantValues.REFUND
                        || (objLTS.loan__Other_Loan_Txn__c != NULL
                        && objLTS.loan__Other_Loan_Txn__r.loan__Txn_Date__c != NULL 
                        && objLTS.loan__Loan_Account__r.loan__Closed_Date__c != NULL 
                        && objLTS.loan__Other_Loan_Txn__r.loan__Txn_Date__c >= objLTS.loan__Loan_Account__r.loan__Closed_Date__c)){
                    loanIdList.add(objLTS.loan__Loan_Account__r.Id);
                }
                if(objLTS.Transaction_Type__c==ConstantValues.REDRAW && objLTS.loan__Other_Loan_Txn__c !=NULL
                        && objLTS.loan__Other_Loan_Txn__r.loan__Txn_Date__c!=objLTS.loan__Other_Loan_Txn__r.loan__Repayment_Start_Date__c
                        && objLTS.loan__Other_Loan_Txn__r.loan__Txn_Date__c!=systemDate){
                    backDatedLoanId.add(objLTS.loan__Loan_Account__r.Id);
                    backDatedDate.add(objLTS.loan__Other_Loan_Txn__r.loan__Txn_Date__c);
                    backDatedDateList.put(objLTS.loan__Loan_Account__r.Id,objLTS.loan__Other_Loan_Txn__r.loan__Txn_Date__c);
                }
            }
            if(idOtherLoanList.size()>0){
                objDepositList=[SELECT id,
                                    clcommon__Deposit_Amount__c,
                                    loan__Other_Loan_Transaction__c,
                                    loan__Other_Loan_Transaction__r.id
                                FROM clcommon__Deposit__c 
                                WHERE loan__Other_Loan_Transaction__c=:idOtherLoanList];
            }
            for(clcommon__Deposit__c deposit:objDepositList){
                depositMap.put(deposit.loan__Other_Loan_Transaction__c,deposit.clcommon__Deposit_Amount__c);
            }
            
            List <loan__Loan_Transaction_Summary__c> openingBalanceList = [SELECT Id,
                                                                                Name,
                                                                                loan__Transaction_Date__c,
                                                                                Transaction_Type__c,
                                                                                Debit__c,
                                                                                Credit__c,
                                                                                loan__Balance__c,
                                                                                loan__Loan_Account__c,
                                                                                loan__Current_Loan_Balance__c,
                                                                                loan__Loan_Account__r.id,
                                                                                loan__Interest_Posting_Txn__r.loan__Balance__c,
                                                                                loan__Consolidated_Loan_Balance__c,
                                                                                loan__Loan_Payment_Txn__c,
                                                                                loan__Loan_Payment_Txn__r.id
                                                                                FROM loan__Loan_Transaction_Summary__c 
                                                                                WHERE Include_in_Summary__c = true 
                                                                                AND loan__Loan_Account__c in: loanIdList
                                                                                AND loan__Consolidated_Loan_Balance__c != NULL 
                                                                                AND Transaction_Type__c IN (:ConstantValues.PAYMENT_RECEIVED,:ConstantValues.REFUND)
                                                                                AND (loan__Loan_Payment_Txn__c = null 
                                                                                OR (loan__Loan_Payment_Txn__r.loan__Payment_Mode__r.Name NOT IN
                                                                                    (:ConstantValues.DISCOUNT_TAG,:ConstantValues.INTERNAL_TRANSFER) 
                                                                                AND loan__Loan_Payment_Txn__r.loan__Payoff_Balance__c = 0 
                                                                                AND loan__Loan_Payment_Txn__r.loan__Rejected__c = false and loan__Loan_Payment_Txn__r.loan__Reversed__c = false))
                                                                                AND (loan__Other_Loan_Txn__c = null
                                                                                OR (loan__Other_Loan_Txn__r.loan__Reversed__c = false))
                                                                                ORDER BY loan__Transaction_Date__c ASC, CreatedDate ASC, loan__Transaction_Time__c ASC, Name ASC]; 
                
            for(loan__Loan_Transaction_Summary__c objLTS:objLTSList){
                if(objLTS.Transaction_Type__c==ConstantValues.REDRAW){
                    if(objLTS.loan__Other_Loan_Txn__c!=NULL && objLTS.loan__Other_Loan_Txn__r.loan__Txn_Amt__c!=NULL){
                        objLTS.loan__Transaction_Amount__c=-objLTS.loan__Other_Loan_Txn__r.loan__Txn_Amt__c;
                    }
                    if(objLTS.loan__Loan_Account__c !=NULL && objLTS.loan__Loan_Account__r.loan__Loan_Balance__c!=NULL){
                        objLTS.loan__Current_Loan_Balance__c=objLTS.loan__Loan_Account__r.loan__Loan_Balance__c;
                    }
                    if(depositMap.containskey(objLTS.loan__Other_Loan_Txn__c)){
                        if(objLTS.loan__Current_Loan_Balance__c!=NULL && depositMap.get(objLTS.loan__Other_Loan_Txn__c) != NULL){
                            objLTS.loan__Consolidated_Loan_Balance__c=objLTS.loan__Current_Loan_Balance__c - depositMap.get(objLTS.loan__Other_Loan_Txn__c);
                        }
                    }
                    if(objLTS.loan__Other_Loan_Txn__c != null && objLTS.loan__Other_Loan_Txn__r.loan__Txn_Date__c!=null){
                        objLTS.loan__Transaction_Date__c=objLTS.loan__Other_Loan_Txn__r.loan__Txn_Date__c;
                        objLTS.loan__Transaction_Time__c=objLTS.loan__Other_Loan_Txn__r.loan__Txn_Date__c;
                    }
                }
            }
            if(objLTSList.size()>0){
                Database.update(objLTSList,false);
            }
            if(backDatedLoanId.size()>0 && backDatedDate.size()>0){
                LTSCalculateConsolidatedLoanBalance.calculateConsolidatedLoanBalance(backDatedLoanId,backDatedDate,backDatedDateList);
            }
            Map<Id,loan__Loan_Transaction_Summary__c> openStatement=new Map<Id,loan__Loan_Transaction_Summary__c>();
            Map<Id,Id> excludeStatement=new Map<Id,Id>();
            List<Id> lptIdList=new List<Id>();
            for(Id loanId:loanIdList){
                for(loan__Loan_Transaction_Summary__c openingBalance:openingBalanceList){
                    if(loanId==openingBalance.loan__Loan_Account__r.id && openingBalance.loan__Consolidated_Loan_Balance__c != NULL ){
                        openStatement.put(loanId,openingBalance);
                        excludeStatement.put(loanId,openingBalance.id);
                        if(openingBalance.loan__Loan_Payment_Txn__c!=null){
                            lptIdList.add(openingBalance.loan__Loan_Payment_Txn__r.id);
                        }
                        break;
                    }
                }
            }
            if(lptIdList.size()>0){
                LTSConsolidatedLoanBalanceUpdate.updateConsolidatedLoanBalance(lptIdList);
            }else{
                for(Id loanId:loanIdList){
                    Decimal statementBalance=(openStatement.get(loanId)).loan__Consolidated_Loan_Balance__c;
                    for(loan__Loan_Transaction_Summary__c openingBalance:openingBalanceList){
                        if(loanId==openingBalance.loan__Loan_Account__r.id && openingBalance.loan__Consolidated_Loan_Balance__c != NULL &&
                            excludeStatement.get(loanId)!=openingBalance.id){
                            if(openingBalance.Debit__c!=NULL){
                                openingBalance.loan__Consolidated_Loan_Balance__c=statementBalance + openingBalance.Debit__c;
                            }else if(openingBalance.Credit__c!=NULL){
                                openingBalance.loan__Consolidated_Loan_Balance__c=statementBalance - openingBalance.Credit__c;
                            }
                            statementBalance=openingBalance.loan__Consolidated_Loan_Balance__c;
                        }
                    }
                }
                
                if(openingBalanceList.size()>0){
                    Database.update(openingBalanceList,false);
                }
            }
        }catch(Exception exe){
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'LTSRedrawUpdateBatch :Exception: '+exe.getStackTraceString()
                                        +'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
    }
    
    public void execute(SchedulableContext sc) {
        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        LTSRedrawUpdateBatch obj = new LTSRedrawUpdateBatch();
        Integer size = batch.LTSRedrawUpdateBatch_Size__c != NULL ? Integer.valueOf(batch.LTSRedrawUpdateBatch_Size__c) : 10;  
        database.executebatch(obj,size);
    }
    public void finish(Database.BatchableContext bc){
    }

}