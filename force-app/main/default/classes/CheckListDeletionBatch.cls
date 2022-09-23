/****************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Rameswari Barman
Development Date : 2/09/2022
Last Modified By : Rameswari Barman
Last Modified Date : 2/09/2022
Description : This batch deletes Checklist records that have SUCCESS at status
****************************************************************************************************/

global class CheckListDeletionBatch extends clcommon.DynamicJob {

    global CheckListDeletionBatch(){
        //BLANK CONSTRUCTOR
    } 
    
    global override String getRuntimeQuery() {
        String queryString = '';
        try{
            //Not doing null check for Days_consideration_for_deleting_loan_repayment_schedule_records
            //as its in a custom label and its required to save a value for saving the label
            queryString = 'SELECT Id '+
                          'FROM genesis__Checklist__c '+
                          'WHERE genesis__Message__c = \'SUCCESS\' '+
                          'AND (Checklist_Detail_Fails__c = 0 '+
                          'OR Checklist_Total_Count__c = 0)';
        }catch(Exception exe){
            GenericUtility.insertBatchProcessLog('CheckListDeletionBatch',exe);
        }
        return queryString;
    }
    
    global override void doStart(Database.BatchableContext bc) {}

    global override void doExecute(System.SchedulableContext sc) {
        CheckListDeletionBatch obj = new CheckListDeletionBatch();
        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        Integer size = batch.ChecklistDeletionBatch_Job_Size__c != NULL ? Integer.valueOf(batch.ChecklistDeletionBatch_Job_Size__c) : 200;  
        database.executebatch(obj,size);
    }
    public override void doexecute(Database.BatchableContext bc, List<Sobject> objCheckList) {
        try{
            if(objCheckList.isEmpty() == FALSE){
                Database.delete(objCheckList,false);
            }
        }catch(Exception exe){
            GenericUtility.insertBatchProcessLog('CheckListDeletionBatch',exe);
        }
    }
    global override void doInitialize() {}
  
    global override void doFinish(Database.BatchableContext bc) {}
}