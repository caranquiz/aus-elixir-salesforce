global class TaskRelatedLoanContractController {
    public List<loan__Loan_Account__c> acctList {get;set;}
    public String taskId {get; set;}
    public collect__Loan_Account__c collectAccount {get;set;}
    
    public TaskRelatedLoanContractController(ApexPages.StandardController stdController){
        collectAccount=[SELECT id,
                                Name,
                                collect__Account__c,
                                collect__Account__r.Name,
                                collect__External_ID__c,
                                collect__Contact__c,
                                collect__Days_Past_Due__c,
                                collect__Delinquent_Amount__c,
                                CL_Contract__c,
                                CL_Contract__r.Name
                            FROM collect__Loan_Account__c 
                            WHERE id = :ApexPages.currentPage().getParameters().get('id')];
		Id loanId=collectAccount.CL_Contract__c;
        acctList = [SELECT id,
                      Name,loan__Account__c 
                  FROM loan__Loan_Account__c 
                  WHERE id = :loanId];
    }
    //This method returns the Task Details related to CL Contract.
    public List<Task> gettaskList(){
        List<Task> taskList=new List<Task>();
        if(acctList.size()>0){
            taskList =[SELECT id,
                            Subject,
                            whoId,
                            ActivityDate,
                            CreatedDate,
                            OwnerId,
                            LastModifiedById,
                            LastModifiedDate,
                            Description__c
                        FROM Task 
                        WHERE whatId=:acctList[0].id
                        ORDER BY LastModifiedDate DESC];
        }
        return taskList;
    }
    //This method delete the selected Task
    public PageReference deleteTask(){
        try{
            List<Task> deleteTaskList=new List<Task>();
            if(taskId!=null){
                deleteTaskList = [SELECT id,
                                        Subject,
                                        whoId,
                                        ActivityDate,
                                        CreatedDate,
                                        OwnerId,
                                        LastModifiedById,
                                        LastModifiedDate
                                    FROM Task 
                                    WHERE id =: taskId LIMIT 1];
            }
            
            if(deleteTaskList.size()>0){
                database.delete(deleteTaskList,false);
            }
            
            PageReference tempPage =  ApexPages.currentPage();          
            tempPage.setRedirect(true);
            return tempPage;

        }catch(Exception exe){
            GenericUtility.insertLog('TaskRelatedLoanContractController',exe);
            return null;
        }
        
    }
}