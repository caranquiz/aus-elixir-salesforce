/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class updates the Total Sum of Linked Loan in CL Contract whenever this batch job runs.
Development Date : 19/05/2021
Last Modified Date : 20/05/2021
****************************************************************************************************/

public class TotalSumOfLinkedLoanUpdateBatch implements DataBase.StateFul,DataBase.Batchable<sObject>,Schedulable {
    //Query all Cl Contract  
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT id,
                                               Name,
                                               Linked_Loans__c,
                                               Current_Loan_Balance_Excluding_Deposit__c,
                                               Total_Sum_Of_Linked_Loans__c 
                                           FROM loan__Loan_Account__c]);
    }
    //This method updates Total Sum of Linked Loan in CL Contract.
    public void execute(Database.BatchableContext bc, List<loan__Loan_Account__c> objLoanList) {
        try{
            List<Linked_Loan__c> objLinkedLoanList = new List<Linked_Loan__c>();
            if(objLoanList.size()>0){
                objLinkedLoanList =[SELECT id,
                                       Linked_Loan__r.Name,
                                       Current_Loan_Record__c,
                                       Current_Loan_Balance_Excluding_Deposit__c 
                                   FROM Linked_Loan__c 
                                   WHERE Current_Loan_Record__c IN: objLoanList];
            
                for(loan__Loan_Account__c loanAccount:objLoanList){
                    if(objLinkedLoanList.size()>0){
                        loanAccount.Total_Sum_Of_Linked_Loans__c=loanAccount.Current_Loan_Balance_Excluding_Deposit__c;
                        for(Linked_Loan__c linkedLoan : objLinkedLoanList){
                            if(linkedLoan.Current_Loan_Record__c==loanAccount.id){
                                if(loanAccount.Total_Sum_Of_Linked_Loans__c==NULL){
                                    loanAccount.Total_Sum_Of_Linked_Loans__c=linkedLoan.Current_Loan_Balance_Excluding_Deposit__c;
                                }else{
                                    loanAccount.Total_Sum_Of_Linked_Loans__c=loanAccount.Total_Sum_Of_Linked_Loans__c + linkedLoan.Current_Loan_Balance_Excluding_Deposit__c;
                                }
                            }
                        }
                    }
                }
            }
            if(objLoanList.size()>0){
                Database.update(objLoanList,false);
            }
        }catch(Exception exe){
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'TotalSumOfLinkedLoanUpdateBatch :Exception: '+exe.getStackTraceString()+'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
    }
    public void execute(SchedulableContext sc) {
        TotalSumOfLinkedLoanUpdateBatch obj = new TotalSumOfLinkedLoanUpdateBatch();
        Integer size = 30;  
        database.executebatch(obj,size);
    }
    public void finish(Database.BatchableContext bc){
    }
}