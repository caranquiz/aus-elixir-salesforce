/****************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Rameswari Barman
Development Date : 2/09/2022
Last Modified By : Rameswari Barman
Last Modified Date : 2/09/2022
Description : This batch deletes ChecklistDetail records that have SUCCESS at status
****************************************************************************************************/

global class CheckListDetailDeletionBatch extends clcommon.DynamicJob {

    global CheckListDetailDeletionBatch(){
        //BLANK CONSTRUCTOR
    } 
    
    global override String getRuntimeQuery() {
        String queryString = '';
        try{
            //Not doing null check for Days_consideration_for_deleting_loan_repayment_schedule_records
            //as its in a custom label and its required to save a value for saving the label
            queryString = 'SELECT Id '+
                          'FROM Checklist_Detail__c '+
                          'WHERE Status__c = \'SUCCESS\'';
        }catch(Exception exe){
            GenericUtility.insertBatchProcessLog('CheckListDetailDeletionBatch',exe);
        }
        return queryString;
    }
    
    global override void doStart(Database.BatchableContext bc) {}

    global override void doExecute(System.SchedulableContext sc) {
        CheckListDetailDeletionBatch obj = new CheckListDetailDeletionBatch();
        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        Integer size = batch.ChecklistDetailDeletionBatch_Job_Size__c != NULL ? Integer.valueOf(batch.ChecklistDetailDeletionBatch_Job_Size__c) : 200;  
        database.executebatch(obj,size);
    }
    public override void doexecute(Database.BatchableContext bc, List<Sobject> objChecklistDetailList) {
        try{
            if(objChecklistDetailList.isEmpty() == FALSE){
                Database.delete(objChecklistDetailList,false);
            }
        }catch(Exception exe){
            GenericUtility.insertBatchProcessLog('CheckListDetailDeletionBatch',exe);
        }
    }
    global override void doInitialize() {}
  
    global override void doFinish(Database.BatchableContext bc) {}
}