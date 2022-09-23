/****************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Rameswari Barman
Development Date : 2/09/2022
Last Modified By : Rameswari Barman
Last Modified Date : 2/09/2022
Description : This batch deletes Loan Repayment Schedule records that are due more than 35 days in future
****************************************************************************************************/

global class AmortizationScheduleDeletionBatch extends clcommon.DynamicJob {

    global AmortizationScheduleDeletionBatch(){
        //BLANK CONSTRUCTOR
    } 
    
    global override String getRuntimeQuery() {
        String queryString = '';
        try{
            queryString = 'SELECT Id '+
                          'FROM genesis__Amortization_Schedule__c '+
                          'WHERE genesis__Application__r.genesis__Status__c in (\''+System.label.Loan_Settled+'\')';
        }catch(Exception exe){
            GenericUtility.insertBatchProcessLog('AmortizationScheduleDeletionBatch',exe);
        }
        return queryString;
    }
    
    global override void doStart(Database.BatchableContext bc) {}

    global override void doExecute(System.SchedulableContext sc) {
        AmortizationScheduleDeletionBatch obj = new AmortizationScheduleDeletionBatch();
        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        Integer size = batch.ApplicationAmortizationScheduleDeletion__c != NULL ? Integer.valueOf(batch.ApplicationAmortizationScheduleDeletion__c) : 200;  
        database.executebatch(obj,size);
    }
    public override void doexecute(Database.BatchableContext bc, List<Sobject> repaymentList) {
        try{
            if(repaymentList.size() > 0){
                Database.delete(repaymentList,false);
            }
        }catch(Exception exe){
            GenericUtility.insertBatchProcessLog('AmortizationScheduleDeletionBatch',exe);
        }
    }
    global override void doInitialize() {}
  
    global override void doFinish(Database.BatchableContext bc) {}
}