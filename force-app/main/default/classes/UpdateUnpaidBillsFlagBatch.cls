/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Rameswari Barman
Description : This class updates the Unpaid Bills flag for the ones wrongly updated when all the bills are satisfied
Development Date : 09/06/2021
Last Modified Date : 09/06/2021
****************************************************************************************************/
global with sharing class UpdateUnpaidBillsFlagBatch implements DataBase.StateFul,DataBase.Batchable<sObject>,Schedulable {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id,
                                            Name,
                                            Total_no_of_generated_bills__c,
                                            Total_no_of_Paid_bills__c,
                                            loan__Unpaid_Bills__c 
                                        FROM loan__Loan_Account__c 
                                        WHERE loan__Unpaid_Bills__c = true]);
    }
    public void execute(Database.BatchableContext bc, List<loan__Loan_Account__c> scope) {
        try{
            if(scope.size()>0){
                for(loan__Loan_Account__c rec:scope){
                    if(rec.Total_no_of_generated_bills__c == rec.Total_no_of_Paid_bills__c){
                        rec.loan__Unpaid_Bills__c = false;
                    }
                }
                Database.update(scope,false);
            }
        }catch(Exception exe){
            insert new clcommon__Log__c(
                clcommon__Message__c = 'UpdateUnpaidBillsFlagBatch :Exception: '+exe.getStackTraceString()+'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Time__c = System.Now());
        }
    }
    public void execute(SchedulableContext sc) {
        UpdateUnpaidBillsFlagBatch unpaidBillsBatch = new UpdateUnpaidBillsFlagBatch();  
        database.executebatch(unpaidBillsBatch,20);
    }
    public void finish(Database.BatchableContext bc){
    }
}