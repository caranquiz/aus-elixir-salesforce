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
                            APXT_BPM__Query_Id__c,
                            Count_Cl_Contract_Size__c,
                            APXT_BPM__Title__c
                            FROM APXT_BPM__Conductor__c 
                            WHERE APXT_BPM__Title__c=: ConstantValues.STATEMENT_CONGA_BATCH];
    }
    public void clickLaunch() {
        if(congaBatch.Count_Cl_Contract_Size__c!=null){
            Integer cuntOffset=Integer.valueOf(900*congaBatch.Count_Cl_Contract_Size__c);
            String queryString=ConstantValues.ALL_CL_CONTRACT_QUERY+String.valueOf(cuntOffset);
            List<loan__Loan_Account__c> loanAccountList=Database.query(queryString);
            String queryString2=ConstantValues.CONGA_CL_CONTRACT_QUERY +String.valueOf(cuntOffset);
            List<loan__Loan_Account__c> loanAccountList2=Database.query(queryString2);

            if(congaBatch!=null && ((loanAccountList.size()>0 && cuntOffset==0) || loanAccountList2.size()>0)){
                Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
                StatementBulkGenerationLoanUpdateBatch obj = new StatementBulkGenerationLoanUpdateBatch();
                Integer size = batch.StatementBulkGenerationLoanUpdateBatch__c != NULL ? Integer.valueOf(batch.StatementBulkGenerationLoanUpdateBatch__c) : 10;  
                jobId = Database.executebatch(obj,size);
                waitPoll = true;
                ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.severity.CONFIRM,
                    ConstantValues.BATCH_JOB_START
                )
                );
            }else{
                    ApexPages.addMessage(
                        new ApexPages.message(
                        ApexPages.severity.WARNING,
                        ConstantValues.STATEMENT_NOT_GENERATED
                        )
                    );
                    congaBatch.Count_Cl_Contract_Size__c=0;
                    update congaBatch;
            }
    }
    }
    //Re-direct to Conga Batch page 
	public PageReference redirectWhenDone() {
        try{
            List<APXTConga4__Conga_Merge_Query__c> congaQueryList=new List <APXTConga4__Conga_Merge_Query__c>();
            congaQueryList=[SELECT id,APXTConga4__Query__c FROM APXTConga4__Conga_Merge_Query__c WHERE id =: congaBatch.APXT_BPM__Query_Id__c];
            AsyncApexJob job = [SELECT Id, 
                                    Status,
                                    ExtendedStatus,
                                    NumberOfErrors,
                                    JobItemsProcessed,
                                    TotalJobItems, 
                                    CreatedBy.Email
                                FROM AsyncApexJob 
                                WHERE Id =:jobId];

            if((job.Status == ConstantValues.ABORTED 
                    || job.Status == ConstantValues.COMPLETED 
                    || job.Status == ConstantValues.FAILED) 
                    || Test.isRunningTest() == True 
            ) {
                if(congaBatch.Count_Cl_Contract_Size__c!=null){
                    Integer cuntOffset=Integer.valueOf(900*congaBatch.Count_Cl_Contract_Size__c);
                    String queryString=ConstantValues.CONGA_CL_CONTRACT_QUERY+String.valueOf(cuntOffset);
                    List<loan__Loan_Account__c> loanAccountList=Database.query(queryString);
                    if(loanAccountList.size()>0){
                        congaQueryList[0].APXTConga4__Query__c=ConstantValues.CONGA_CL_CONTRACT_QUERY+String.valueOf(cuntOffset);
                        update congaQueryList;
                        congaBatch.Count_Cl_Contract_Size__c=congaBatch.Count_Cl_Contract_Size__c+1;
                        update congaBatch;
                        waitPoll = false;
                        PageReference pageRef;
                        pageRef=new PageReference('/'+congaBatch.id);
                        pageRef.setRedirect(true);
                        return pageRef; 
                    }else{
                        waitPoll = false;
                        congaBatch.Count_Cl_Contract_Size__c=0;
                        update congaBatch;
                        return null;
                    }
                }else{
                    return null;
                } 
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