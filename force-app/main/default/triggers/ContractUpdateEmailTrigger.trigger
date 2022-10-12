trigger ContractUpdateEmailTrigger on EmailMessage (after insert) {
    try{
        Disable_Custom_Triggers__c disCustomTrigger = Disable_Custom_Triggers__c.getOrgDefaults();//Custom setting to disable this particular trigger
        if(!(disCustomTrigger.LoanCollateralTrigger__c)){
            if(Trigger.isInsert && Trigger.isAfter){
                List<Id> relatedListId=new List<Id>();
                Map<Id,String> textBodyMap=new Map<Id,String>();
                Map<Id,String> textSubjectMap=new Map<Id,String>();
                for(EmailMessage objEmail: Trigger.New){
                    relatedListId.add(objEmail.RelatedToId);
                    textBodyMap.put(objEmail.RelatedToId,objEmail.TextBody);
					textSubjectMap.put(objEmail.RelatedToId,objEmail.Subject);
                }
                List<collect__Loan_Account__c> collectAccountList=[SELECT id,
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
                                                                       WHERE id in: relatedListId];
                List<collect__Collection_Activity__c> collectionActivityList=new List<collect__Collection_Activity__c>();
                for(collect__Loan_Account__c collectAccount:collectAccountList){
                    collect__Collection_Activity__c collectionActivity=new collect__Collection_Activity__c();
                    collectionActivity.collect__Account__c=collectAccount.collect__Account__c;
                    collectionActivity.collect__Action__c='Email';
                    collectionActivity.collect__Dev_Contract__c=collectAccount.id;
                    collectionActivity.collect__Contact__c=collectAccount.collect__Contact__c;
                    collectionActivity.collect__Activity_Date__c=Date.today();
                    collectionActivity.collect__Days_Past_Due__c=collectAccount.collect__Days_Past_Due__c;
                    collectionActivity.collect__Loan_Account_Id__c=collectAccount.collect__External_ID__c;
                    //collectionActivityList.collect__Delinquent_Amount__c=collectAccount.collect__Delinquent_Amount__c;
                    collectionActivity.Body__c=textBodyMap.get(collectAccount.id);
                    collectionActivity.Subject__c=textSubjectMap.get(collectAccount.id);
                    collectionActivity.collect__Completed__c=true;
                    collectionActivity.collect__Completion_Date__c=Date.today();
                    collectionActivity.Mail_Sent__c = True;
                    collectionActivityList.add(collectionActivity);
                }
                if(collectionActivityList.size()>0){
                    insert collectionActivityList;
                }
            }
        }
        
    }catch(Exception exe){
		GenericUtility.insertLog('ContractUpdateEmailTrigger',exe);
    }
}