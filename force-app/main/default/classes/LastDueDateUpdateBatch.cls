/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Rameswari Barman
Description : This class is a work around for Q2 ticket 03342761 which updates Last Due Date field in CL Contract
    when a bill has been generated but value in Last Due Date is null
Development Date : 23/06/2022
Last Modified Date : 23/06/2022
****************************************************************************************************/

global with sharing class LastDueDateUpdateBatch extends clcommon.DynamicJob{

    global LastDueDateUpdateBatch(){
        //BLANK CONSTRUCTOR
    } 
    global override String getRuntimeQuery() {
        return 'SELECT Id, Name,loan__Previous_Installment_Date__c '+
                'FROM loan__Loan_Account__c '+
                'WHERE loan__Loan_Status__c IN (\'Active - Good Standing\',\'Active - Bad Standing\',\'Active - Matured\',\'Active - Marked for Closure\') '+
                'AND loan__Previous_Installment_Date__c = NULL '+
                'AND Total_no_of_generated_bills__c > 0 '+
                'ORDER BY Id';
    }
    global override void doStart(Database.BatchableContext bc) {}

    global override void doExecute(System.SchedulableContext sc) {
        LastDueDateUpdateBatch obj = new LastDueDateUpdateBatch();
        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        Integer size = batch.LastDueDateUpdateBatch__c != NULL ? Integer.valueOf(batch.LastDueDateUpdateBatch__c) : 200;
        Database.executeBatch(obj, size);
    }
    //This method updates the Last Due Date in CL Contracts where Last Due Date = NULL
    public override void doexecute(Database.BatchableContext bc, List<sobject> loanList) {
        try{
            List <loan__Loan_Account__c> updatedLoanList = new List <loan__Loan_Account__c>();
            List <AggregateResult> billList = [SELECT loan__Loan_Account__c,
                                                                    MAX(loan__Due_Date__c) lastDueDate
                                                                    FROM loan__Loan_account_Due_Details__c
                                                                    WHERE loan__DD_Primary_Flag__c = TRUE
                                                                    AND loan__Loan_Account__c IN : loanList 
                                                                    AND loan__Due_Date__c != NULL
                                                                    GROUP BY loan__Loan_Account__c];
            for(AggregateResult objDueDetails : billList){
                loan__Loan_Account__c objLoanAccount = new loan__Loan_Account__c(Id = (Id)objDueDetails.get('loan__Loan_Account__c'),
                loan__Previous_Installment_Date__c = Date.ValueOf(objDueDetails.get('lastDueDate')));
                updatedLoanList.add(objLoanAccount);
            }
            if(loanList.isEmpty() == FALSE){
                Database.update(updatedLoanList,false);
            }
        }catch(Exception exe){
            GenericUtility.insertBatchProcessLog('LastDueDateUpdateBatch',exe);
        }
    }
    global override void doInitialize() {}
  
    global override void doFinish(Database.BatchableContext bc) {}
}