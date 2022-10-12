public class CreateTaskToContract {
@InvocableMethod(
    label='Create Task'
    description='Create Task when No Email is Held'
    )
    public static void createTaskRelatedToContract(List<Id> loanIdList) {
         loan.GlobalLoanUtilFacade glutil = new loan.GlobalLoanUtilFacade();
      	 //Date systemDate=!Test.isRunningTest()?glutil.getCurrentSystemDate():Date.today();
      	 Date systemDate=Date.today();
         List<loan__Coborrower__c> objCoborrowerList=[SELECT id,
                                                    loan__Contact__c,
                                                    loan__Contact__r.Email,
                                                    loan__Account__c,
                                                    loan__Account__r.id,
                                                    loan__Loan__c,
                                                    loan__Loan__r.Id
                                                    FROM loan__Coborrower__c 
                                                    WHERE loan__Loan__c in: loanIdList 
                                                    AND loan__Party_Type__c IN ('Borrower','Co-Applicant')];

        List<Id> objAccountIdList=new List<Id>();
        List<Id> objAccIdList=new List<Id>();
        List<Id> objCheckEmailIdList=new List<Id>();
        Map<Id,Id> accountLoanIdMap=new Map<Id,Id>();
        
        for(loan__Coborrower__c objCoborrower:objCoborrowerList){
            if(objCoborrower.loan__Account__c!=null && objCoborrower.loan__Contact__c==null){
                objAccountIdList.add(objCoborrower.loan__Account__r.id);
                accountLoanIdMap.put(objCoborrower.loan__Account__r.Id,objCoborrower.loan__Loan__r.Id);
            }
            if(objCoborrower.loan__Account__c!=null && objCoborrower.loan__Contact__c!=null 
                    && (objCoborrower.loan__Contact__r.Email==null || String.isBlank(objCoborrower.loan__Contact__r.Email))){
                objCheckEmailIdList.add(objCoborrower.loan__Contact__r.Id);
                accountLoanIdMap.put(objCoborrower.loan__Contact__r.Id,objCoborrower.loan__Loan__r.Id);
            }
        }
        if(objAccountIdList!=null){
            List<AccountContactRelation> objAccountContactRelList=[SELECT id,AccountId,ContactId,Contact.Email FROM AccountContactRelation WHERE AccountId in:objAccountIdList];
            for(AccountContactRelation objAccountContactRel:objAccountContactRelList){
                if(objAccountContactRel.AccountId!=null 
                        && objAccountContactRel.ContactId!=null && objAccountContactRel.Contact.Email==null){
                            objAccIdList.add(objAccountContactRel.AccountId);
                            objCheckEmailIdList.add(objAccountContactRel.ContactId);
                            accountLoanIdMap.put(objAccountContactRel.ContactId,accountLoanIdMap.get(objAccountContactRel.AccountId));
                }
            }
        }
        List<Group> objQueueList=[SELECT Id,
                                  		developerName 
                                  	FROM Group 
                                  	WHERE developerName='Collection_Queue_to_Assign_Task' LIMIT 1];
        List<Task> objTaskList=new List<Task>();
        Time myTime = Time.newInstance(4, 0, 0, 0);
		DateTime dt = DateTime.newInstanceGMT(systemDate, myTime)- (10/24);
        for(Id objContactId:objCheckEmailIdList){
            Task newTask = new Task();
            newTask.ActivityDate = systemDate;
            newTask.Description__c = 'Dishonored payment-No Email';
            //newTask.Description = comment;
            newTask.OwnerId = objQueueList[0].id;
            newTask.Subject = ConstantValues.INTERNAL_TASK;
            newTask.WhatId = accountLoanIdMap.get(objContactId);
            newTask.WhoId = objContactId;
            newTask.isReminderSet=true;
            newTask.ReminderDateTime=dt;
            objTaskList.add(newTask);
        }
        if(objTaskList.size()>0){
            //Database.insert(objTaskList,false);
            insert objTaskList;
        }
    }
}