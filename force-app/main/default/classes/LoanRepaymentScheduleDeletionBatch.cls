/****************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Rameswari Barman
Development Date : 2/09/2022
Last Modified By : Rameswari Barman
Last Modified Date : 2/09/2022
Description : This batch deletes Loan Repayment Schedule records that are due more than 35 days in future
****************************************************************************************************/

global class LoanRepaymentScheduleDeletionBatch extends clcommon.DynamicJob {

    global LoanRepaymentScheduleDeletionBatch(){
        //BLANK CONSTRUCTOR
    } 
    
    global override String getRuntimeQuery() {
        String formattedString = '';
        try{
            //Not doing null check for Days_consideration_for_deleting_loan_repayment_schedule_records
            //as its in a custom label and its required to save a value for saving the label
            String currentSystemDate = ((DateTime) (!Test.isRunningTest()?
                (new loan.GlobalLoanUtilFacade()).getCurrentSystemDate().addDays(Integer.ValueOf(
                System.label.Days_consideration_for_deleting_loan_repayment_schedule_records)): Date.Today())).format('yyyy-MM-dd');
            List<String> params = new List<String>{
                currentSystemDate
            };
            String queryString = 'SELECT Id '+
                                 'FROM loan__Repayment_Schedule__c '+
                                 'WHERE loan__Is_Archived__c = TRUE '+
                                 'AND loan__Due_Date__c > {0}';
            formattedString = String.format(queryString, params);
        }catch(Exception exe){
            GenericUtility.insertBatchProcessLog('LoanRepaymentScheduleDeletionBatch',exe);
        }
        return formattedString;
    }
    
    global override void doStart(Database.BatchableContext bc) {}

    global override void doExecute(System.SchedulableContext sc) {
        LoanRepaymentScheduleDeletionBatch obj = new LoanRepaymentScheduleDeletionBatch();
        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        Integer size = batch.LoanRepaymentScheduleDeletionBatch__c != NULL ? Integer.valueOf(batch.LoanRepaymentScheduleDeletionBatch__c) : 200;  
        database.executebatch(obj,size);
    }
    public override void doexecute(Database.BatchableContext bc, List<Sobject> repaymentList) {
        try{
            if(repaymentList.isEmpty() == FALSE){
                Database.delete(repaymentList,false);
            }
        }catch(Exception exe){
            GenericUtility.insertBatchProcessLog('LoanRepaymentScheduleDeletionBatch',exe);
        }
    }
    global override void doInitialize() {}
  
    global override void doFinish(Database.BatchableContext bc) {}
}