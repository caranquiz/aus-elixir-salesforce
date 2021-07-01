/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class update Loan Transaction summary fields 
            if Transaction Amount OR Current Loan Balance OR Consolidated Loan Balance is NULL.
Development Date : 14/06/2021
Last Modified Date : 14/06/2021
****************************************************************************************************/

public class LTSRedrawUpdateBatch implements DataBase.StateFul,DataBase.Batchable<sObject>,Schedulable{
    //Query LTS whose Transaction Type is 'Redraw' AND Transaction Amount OR Current Loan Balance OR Consolidated Loan Balance is NULL
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT id,
                                               Name,
                                         	   loan__Other_Loan_Txn__c,
                                         	   loan__Loan_Account__c,
                                         	   loan__Loan_Account__r.loan__Loan_Amount__c,
                                         	   loan__Other_Loan_Txn__r.loan__Txn_Amt__c,
                                               loan__Other_Loan_Txn__r.id,
                                         	   loan__Transaction_Amount__c,
                                         	   loan__Current_Loan_Balance__c,
                                               loan__Transaction_Time__c,
                                               loan__Transaction_Date__c,
                                         	   loan__Consolidated_Loan_Balance__c
                                           FROM loan__Loan_Transaction_Summary__c
                                           WHERE Transaction_Type__c=: ConstantValues.REDRAW
                                           AND(loan__Transaction_Amount__c=NULL 
                                           OR loan__Consolidated_Loan_Balance__c=NULL
                                           OR loan__Current_Loan_Balance__c =NULL)
                                           AND loan__Invalid_data__c=false]);
    }
    //This method updates LTS.
    public void execute(Database.BatchableContext bc, List<loan__Loan_Transaction_Summary__c> objLTSList) {
        try{
            List<clcommon__Deposit__c> objDepositList=new List<clcommon__Deposit__c>();
            Map<id,Decimal> depositMap=new Map<id,Decimal>();
            List<id> idOtherLoanList=new List<id>();
            for(loan__Loan_Transaction_Summary__c objLTS:objLTSList){
                idOtherLoanList.add(objLTS.loan__Other_Loan_Txn__c);
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
            for(loan__Loan_Transaction_Summary__c objLTS:objLTSList){
                if(objLTS.loan__Other_Loan_Txn__c!=NULL && objLTS.loan__Other_Loan_Txn__r.loan__Txn_Amt__c!=NULL){
                    objLTS.loan__Transaction_Amount__c=-objLTS.loan__Other_Loan_Txn__r.loan__Txn_Amt__c;
                }
                if(objLTS.loan__Loan_Account__c !=NULL && objLTS.loan__Loan_Account__r.loan__Loan_Amount__c!=NULL){
                    objLTS.loan__Current_Loan_Balance__c=objLTS.loan__Loan_Account__r.loan__Loan_Amount__c;
                }
                if(depositMap.containskey(objLTS.loan__Other_Loan_Txn__c)){
                    if(objLTS.loan__Current_Loan_Balance__c!=NULL && depositMap.get(objLTS.loan__Other_Loan_Txn__c) != NULL){
                        objLTS.loan__Consolidated_Loan_Balance__c=objLTS.loan__Current_Loan_Balance__c - depositMap.get(objLTS.loan__Other_Loan_Txn__c);
                    }
                }
                objLTS.loan__Transaction_Time__c=objLTS.loan__Transaction_Date__c;
            }
            if(objLTSList.size()>0){
                Database.update(objLTSList,false);
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