/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This is the controller class of ActivityListPage.This class shows detail of Task 
      related to Loan and delete the Task when Del button is clicked.
Development Date : 04/01/2022
Last Modified Date : 05/01/2022
****************************************************************************************************/
global class TaskRelatedLoanController {
    public List<loan__Loan_Account__c> acctList {get;set;}
    public String taskId {get; set;}
    
    public TaskRelatedLoanController(ApexPages.StandardController stdController){
        acctList = [SELECT id,
                      Name,loan__Account__c 
                  FROM loan__Loan_Account__c 
                  WHERE id = :ApexPages.currentPage().getParameters().get(ConstantValues.LOAN_ID)];
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
            GenericUtility.insertLog('TaskRelatedLoanController',exe);
            return null;
        }
        
    }
}