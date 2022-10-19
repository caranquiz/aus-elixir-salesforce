/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class is the helper class of QueueUserTrigger. 
Development Date : 20/09/2022
Last Modified Date : 27/09/2022
****************************************************************************************************/

global class QueueUserTriggerHelper {
    public static void QueueUserInsertion(List<collect__Queue_User__c> objQueueUserList){
        try{
            Set<Id> userIdList=new Set<Id>();
            for(collect__Queue_User__c objQueueUser : objQueueUserList){
                userIdList.add(objQueueUser.collect__User__c);
            }
            QueueUserFutureMethod(userIdList);
        }catch(Exception exe){
            GenericUtility.insertLog('QueueUserInsertion', exe);
        } 
    }
    public static void QueueUserDeletion(List<collect__Queue_User__c> objQueueUserList){
        try{
            Set<Id> userIdList=new Set<Id>();
            for(collect__Queue_User__c objQueueUser : objQueueUserList){
                userIdList.add(objQueueUser.collect__User__c);
            }
            QueueUserDeletionFutureMethod(userIdList);
        }catch(Exception exe){
            GenericUtility.insertLog('QueueUserDeletion', exe);
        }
    }
    @future
    public static void QueueUserFutureMethod(Set<Id> userIdList){
        List<GroupMember> objGroupMemberList=new List<GroupMember>();

        List<Group> objGroupList = [SELECT Id 
                                        FROM Group 
                                        WHERE Name=:ConstantValues.COLLECTION_QUEUE_TASK 
                                        AND Type =: ConstantValues.QUEUE];

        for(Id userId : userIdList){
            GroupMember member = new GroupMember();
            member.UserOrGroupId = userId;
            if(objGroupList.size()>0){
                member.GroupId = objGroupList[0].Id;
            }
            objGroupMemberList.add(member);
        }
        if(objGroupMemberList.size()>0){
            Database.insert(objGroupMemberList,false);
        }
    }
    @future
    public static void QueueUserDeletionFutureMethod(Set<Id> userIdList) {
        List<Group> objGroupList = [SELECT Id 
                                    FROM Group 
                                    WHERE Name=:ConstantValues.COLLECTION_QUEUE_TASK
                                    AND Type =: ConstantValues.QUEUE LIMIT 1];
        if(objGroupList.size()>0){
            List<GroupMember> DeleteGroupMemberRecord=[SELECT Id,
                                                            GroupId,
                                                            UserOrGroupId 
                                                        FROM GroupMember 
                                                        WHERE GroupId =: objGroupList[0].id 
                                                        AND UserOrGroupId in: userIdList];
            if(DeleteGroupMemberRecord!=NULL && DeleteGroupMemberRecord.Size()>0) {
            delete DeleteGroupMemberRecord;
            }
        }
        
    }

}