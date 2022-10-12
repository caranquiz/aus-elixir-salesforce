global class QueueUserTriggerHelper {
    public static void QueueUserInsertion(List<collect__Queue_User__c> objQueueUserList){
        Set<Id> userIdList=new Set<Id>();
        for(collect__Queue_User__c objQueueUser : objQueueUserList){
            userIdList.add(objQueueUser.collect__User__c);
        }
        QueueUserFutureMethod(userIdList);
    }
    public static void QueueUserDeletion(List<collect__Queue_User__c> objQueueUserList){
        Set<Id> userIdList=new Set<Id>();
        for(collect__Queue_User__c objQueueUser : objQueueUserList){
            userIdList.add(objQueueUser.collect__User__c);
        }
        QueueUserDeletionFutureMethod(userIdList);
    }
    @future
    public static void QueueUserFutureMethod(Set<Id> userIdList){
        List<GroupMember> objGroupMemberList=new List<GroupMember>();
        Group g = [SELECT Id FROM Group WHERE Name='Collections Dishonor Queue' AND Type = 'Queue'];
        for(Id userId : userIdList){
            //userIdList.add(objQueueUser.collect__User__c);
            GroupMember member = new GroupMember();
            member.UserOrGroupId = userId;
            member.GroupId = g.Id;
            objGroupMemberList.add(member);
        }
        if(objGroupMemberList.size()>0){
            //Database.insert(objGroupMemberList,false);
            insert objGroupMemberList;
        }
    }
    @future
    public static void QueueUserDeletionFutureMethod(Set<Id> userIdList) {
        Group g = [SELECT Id FROM Group WHERE Name='Collections Dishonor Queue' AND Type = 'Queue'];
        List<GroupMember> DeleteGroupMemberRecord=[SELECT Id,GroupId,UserOrGroupId FROM GroupMember WHERE GroupId =: g.id and UserOrGroupId in: userIdList];
        if(DeleteGroupMemberRecord!=NULL && DeleteGroupMemberRecord.Size()>0) {
            delete DeleteGroupMemberRecord;
        }
    }

}