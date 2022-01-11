/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This batch class query all Active Loans and update the document visibility to AllUsers.
Development Date : 01/12/2021
Last Modified Date : 09/12/2021
****************************************************************************************************/

public class ContentDocumentLinkVisibilityUpdateBatch implements DataBase.StateFul,DataBase.Batchable<sObject>,Schedulable{
    List<String> loanStatusList=System.label.Active_CL_Contract_Status.split(',');
	//Query all Active Cl Contract  
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id,
                                                 Name, 
                                                 Statement_Start_Date__c,
                                                 Statement_End_Date__c,
                                                 Conga_Batch_Start_Date__c,
                                                 Conga_Batch_End_Date__c
                                         FROM loan__Loan_Account__c 
                                         WHERE loan__Loan_Status__c in: loanStatusList]);
    }
    
    public void execute(Database.BatchableContext bc, List<loan__Loan_Account__c> objLoanList) {
        try{
            Set<Id> newSet = new Set<Id>();
            for(loan__Loan_Account__c loanAccount:objLoanList){
                newSet.add(loanAccount.id);
            }
            List <ContentDocumentLink> contentDocumentLinkList = [SELECT Id,
                                                                        ContentDocument.Title,
                                                                        ContentDocumentId,
                                                                        ContentDocument.CreatedDate,
                                                                  		Visibility,
                                                                  		shareType
                                                                  FROM ContentDocumentLink
                                                                  WHERE LinkedEntityId IN: newSet
                                                                  AND (Visibility !=: ConstantValues.ALLUSERS
                                                                  OR shareType!=:ConstantValues.SHARE_TYPE_V)];
            for(ContentDocumentLink objcontentDocument:contentDocumentLinkList){
                if((objcontentDocument.ContentDocument.Title).startsWith(ConstantValues.HALF_YEARLY_STATEMENT)){
					objcontentDocument.Visibility =ConstantValues.ALLUSERS;
					objcontentDocument.shareType = ConstantValues.SHARE_TYPE_V;                    
                }
            }
            if(contentDocumentLinkList.size()>0){
                update contentDocumentLinkList;
            }           
        }catch(Exception exe){
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'ContentDocumentLinkVisibilityUpdateBatch :Exception: '+exe.getStackTraceString()
                                        +'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
    }
    public void execute(SchedulableContext sc) {
        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        ContentDocumentLinkVisibilityUpdateBatch obj = new ContentDocumentLinkVisibilityUpdateBatch();
        Integer size = batch.ContentDocumentLinkVisibility_Size__c != NULL ? Integer.valueOf(batch.ContentDocumentLinkVisibility_Size__c) : 10;  
        database.executebatch(obj,size);
    }
    public void finish(Database.BatchableContext bc){
        
        AsyncApexJob a = [SELECT Id, 
                                Status,
                                ExtendedStatus,
                                NumberOfErrors,
                                JobItemsProcessed,
                                TotalJobItems, 
                                CreatedBy.Email
                            FROM AsyncApexJob 
                            WHERE Id =:bc.getJobId()];
        if(a!=null){

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject(ConstantValues.MAIL_SUBJECT + a.Status);
            if(a.Status == ConstantValues.COMPLETED){
                mail.setPlainTextBody(ConstantValues.MAIL_BODY_COMPLETED);
            }else{
                mail.setPlainTextBody(ConstantValues.MAIL_BODY + a.TotalJobItems +'with '+ a.NumberOfErrors + ' failures.');
            }
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        }
    }
}