/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This controller class used to re-direct to Conga batches and make some changes in Cl contract
                    when Launch Conga Batch button is clicked and when Update File Visibility is clicked then 
                    ContentDocumentLinkVisibilityUpdateBatch runs.
Development Date : 01/12/2021
Last Modified Date : 09/12/2021
****************************************************************************************************/

public with sharing class LoanStatementBulkGenerationFile {

    static Date currentSystemDate =(Test.isRunningTest()?Date.Today():(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
    public APXT_BPM__Conductor__c congaBatch{get;set;}
    Id jobId;
    public Boolean waitPoll { get; set; }

    public LoanStatementBulkGenerationFile () {
        congaBatch = [SELECT id,
                            name,
                            Statement_Generation_End_Date__c,
                            Statement_Generation_Start_Date__c,
                            APXT_BPM__Title__c
                            FROM APXT_BPM__Conductor__c 
                            WHERE APXT_BPM__Title__c=: ConstantValues.STATEMENT_CONGA_BATCH];
    }
    public void clickLaunch() {
        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        StatementBulkGenerationLoanUpdateBatch obj = new StatementBulkGenerationLoanUpdateBatch();
        Integer size = batch.StatementBulkGenerationLoanUpdateBatch__c != NULL ? Integer.valueOf(batch.StatementBulkGenerationLoanUpdateBatch__c) : 10;  
        jobId = Database.executebatch(obj,size);
        waitPoll = true;
        ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.severity.CONFIRM,
          'Batch Job has started successfully.'
        )
        );

    }
    //Re-direct to Conga Batche page 
	public PageReference redirectWhenDone() {
        try{
            AsyncApexJob job = [SELECT Id, 
                                Status,
                                ExtendedStatus,
                                NumberOfErrors,
                                JobItemsProcessed,
                                TotalJobItems, 
                                CreatedBy.Email
                            FROM AsyncApexJob 
                            WHERE Id =:jobId];
            if(job.Status == 'Aborted' || job.Status == 'Completed' || job.Status == 'Failed') {
                PageReference pageRef;
                pageRef=new PageReference('/'+congaBatch.id);
                return pageRef; 
            }else{
                return null;
            } 
        }catch(Exception e){
            GenericUtility.insertLog('LoanStatementBulkGenerationFile.clickLaunch', e);
            return null;
        }        
    }

    // Execute ContentDocumentLinkVisibilityUpdateBatch batch job.
    public void runbatch(){

        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        ContentDocumentLinkVisibilityUpdateBatch obj = new ContentDocumentLinkVisibilityUpdateBatch();
        Integer size = batch.ContentDocumentLinkVisibility_Size__c != NULL ? Integer.valueOf(batch.ContentDocumentLinkVisibility_Size__c) : 10;  
        database.executebatch(obj,size);
        ApexPages.addMessage(
        new ApexPages.Message(
            ApexPages.severity.CONFIRM,
            ConstantValues.BATCH_JOB_START
        )
        );
    }
}