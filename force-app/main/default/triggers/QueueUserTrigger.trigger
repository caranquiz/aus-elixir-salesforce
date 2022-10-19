/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This trigger fires when Queue User is Added or Deleted. 
Development Date : 20/09/2022
Last Modified Date : 27/09/2022
****************************************************************************************************/

trigger QueueUserTrigger on collect__Queue_User__c (before insert,after delete) {
    
    try{
        Disable_Custom_Triggers__c disCustomTrigger = Disable_Custom_Triggers__c.getOrgDefaults();//Custom setting to disable this particular trigger
        if(!(disCustomTrigger.QueueUserTrigger__c)){
            List<GroupMember> objGroupMemberList=new List<GroupMember>();
            Group g = [SELECT Id 
                            FROM Group 
                            WHERE Name=: ConstantValues.COLLECTION_QUEUE_TASK 
                            AND Type =: ConstantValues.QUEUE];

            if (Trigger.isInsert) {
                QueueUserTriggerHelper.QueueUserInsertion(Trigger.new);
            }else if (Trigger.isDelete) {
                QueueUserTriggerHelper.QueueUserDeletion(Trigger.old);
            }
        }        
    }catch(Exception exe){
        GenericUtility.insertLog('QueueUserTrigger', exe);
    }

}