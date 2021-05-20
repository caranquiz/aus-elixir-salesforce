/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class updates the Total Sum of Linked Loan in Contract whenever this batch job runs.
Development Date : 19/05/2021
Last Modified Date : 20/05/2021
****************************************************************************************************/

public class UpdateSumOfLinkedLoanBatch implements DataBase.StateFul,DataBase.Batchable<sObject>,Schedulable { 
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT id,
                                                Name,
                                                Linked_Loans__c,
                                                Current_Loan_Balance_Excluding_Deposit__c,
                                                Total_Amount_Borrowed__c 
                                            FROM loan__Loan_Account__c ]);
    }
    public void execute(Database.BatchableContext bc, List<loan__Loan_Account__c> scope) {
        try{
            List<Linked_Loan__c> linkedLoanList = new List<Linked_Loan__c>();
            if(scope.size()>0){
                linkedLoanList =[SELECT id,
                                        Linked_Loan__r.Name,
                                        Current_Loan_Record__c,
                                        Current_Loan_Balance_Excluding_Deposit__c 
                                    FROM Linked_Loan__c 
                                    WHERE Current_Loan_Record__c IN: scope];
            
                for(loan__Loan_Account__c loan1:scope){
                    if(linkedLoanList.size()>0){
                        loan1.Total_Amount_Borrowed__c=loan1.Current_Loan_Balance_Excluding_Deposit__c;
                        for(Linked_Loan__c lla : linkedLoanList){
                            if(lla.Current_Loan_Record__c==loan1.id){
                                if(loan1.Total_Amount_Borrowed__c==NULL){
                                    loan1.Total_Amount_Borrowed__c=lla.Current_Loan_Balance_Excluding_Deposit__c;
                                }else{
                                    loan1.Total_Amount_Borrowed__c=loan1.Total_Amount_Borrowed__c + lla.Current_Loan_Balance_Excluding_Deposit__c;
                                }
                            }
                        }
                    }
                }
            }
            if(scope.size()>0){
                Database.update(scope,false);
            }
        }catch(Exception exe){
            insert new clcommon__Log__c(
                clcommon__Message__c = 'UpdateSumOfLinkedLoanBatch :Exception: '+exe.getStackTraceString()+'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Time__c = System.Now());
        }
    }
    public void execute(SchedulableContext sc) {
        UpdateSumOfLinkedLoanBatch usl = new UpdateSumOfLinkedLoanBatch();
        Integer size = 10000;  
        database.executebatch(usl,size);
    }
    public void finish(Database.BatchableContext bc){
    }
}