trigger QueueUserTrigger on collect__Queue_User__c (before insert,after delete) {
    
    try{
        Disable_Custom_Triggers__c disCustomTrigger = Disable_Custom_Triggers__c.getOrgDefaults();//Custom setting to disable this particular trigger
        if(!(disCustomTrigger.LoanCollateralTrigger__c)){
            List<GroupMember> objGroupMemberList=new List<GroupMember>();
            Group g = [SELECT Id FROM Group WHERE Name='Collection Queue to Assign Task' AND Type = 'Queue'];

            if (Trigger.isInsert) {
                QueueUserTriggerHelper.QueueUserInsertion(Trigger.new);
            }else if (Trigger.isDelete) {
                QueueUserTriggerHelper.QueueUserDeletion(Trigger.old);

            }



        }
        
    }catch(Exception exe){
        insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'QueueUserTrigger :'+exe.getStackTraceString()+':Error::'+exe.getMessage()+' at Line Number '+exe.getLineNumber(), clcommon__Timestamp__c = 
                    System.Now(),clcommon__Log_Level__c = 'ERROR');
    }

}