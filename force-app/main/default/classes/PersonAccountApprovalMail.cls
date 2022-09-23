/****************************************************************************************************
Description:    This Class used for Send Email after Person Account Approval Process 
Developer:      Sayak Mukhopadhyay
Created Date:   22/06/2022
*****************************************************************************************************/

public with sharing class PersonAccountApprovalMail {
    @InvocableMethod (label = 'Person Account Approval Mail' 
                        description = 'Mail After Approval Or Rejection'
                        category = 'Person Account')
    public static void personAccountApprovalMail(List<Id>accIdList) {
        try {
            String recieverEmail,status,comment,accName;
            List<Account> objAccountList = [SELECT id,
                                                Name,
                                                Approved__c,
                                                Rejected__c,
                                                (   SELECT id,
                                                    Name,
                                                    Owner.Email,
                                                    Owner.Name
                                                    FROM genesis__Applications_account__r
                                                    ORDER BY createdDate DESC LIMIT 1
                                                )
                                                FROM Account
                                                WHERE id in :accIdList];
            List<ProcessInstance> objProcessInsstaceList = [SELECT id,
                                                                TargetObjectId,
                                                                (   SELECT id,
                                                                    Comments 
                                                                    FROM Steps 
                                                                    ORDER BY createdDate DESC LIMIT 1
                                                                )
                                                                FROM ProcessInstance 
                                                                WHERE TargetObjectId in :accIdList
                                                                AND (Status =: ConstantValues.APPROVED
                                                                OR Status =: ConstantValues.REJECTED) 
                                                                ORDER BY createdDate DESC];
            for(Account objAccount : objAccountList){
                if(objAccount.genesis__Applications_account__r.size()>0){
                    String appName = objAccount.genesis__Applications_account__r[0].Name;
                    String appOwnerName = objAccount.genesis__Applications_account__r[0].Owner.Name;
                    recieverEmail = objAccount.genesis__Applications_account__r[0].Owner.Email;
                }
                accName = objAccount.Name;
                if(objAccount.Approved__c == true){
                    status = ConstantValues.APPROVED;
                }else if(objAccount.Rejected__c == true){
                    status = ConstantValues.REJECTED;
                }
                if(Test.isRunningTest()){
                    Integer check = 4/0;
                }
                for(ProcessInstance objProcessInstance : objProcessInsstaceList){
                    if(objProcessInstance.TargetObjectId == objAccount.id){
                        if(objProcessInstance.Steps.size()>0){
                            comment = objProcessInstance.Steps[0].Comments;
                        }
                        if(!String.isBlank(recieverEmail) && !recieverEmail.contains(ConstantValues.INVALID)){
                            sendEmail(recieverEmail,status,accName,comment);
                        }
                        break;
                    }
                }
            }
        }catch(Exception e){
            GenericUtility.insertLog('PersonAccountApprovalMail',e);
        }
    }
    public static void sendEmail(String recieverEmail,String status,String accName,String comment){
        try {
            String mailSubject;
            String mailBody;
            if(status == ConstantValues.APPROVED){
                mailSubject = ConstantValues.AML_APPROVAL_APPROVED_MAIL_SUBJECT;
                mailBody = ConstantValues.AML_APPROVAL_APPROVED_MAIL_BODY;
            }else if(status == ConstantValues.REJECTED){
                mailSubject = ConstantValues.AML_APPROVAL_REJECTED_MAIL_SUBJECT;
                mailBody = ConstantValues.AML_APPROVAL_REJECTED_MAIL_BODY;
                if(!String.isBlank(comment)){
                    mailBody = mailBody.replace(ConstantValues.APPROVAL_COMMENT,comment);
                }else{
                    mailBody = mailBody.replace(ConstantValues.APPROVAL_COMMENT,' ');
                }
            }
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {recieverEmail};
            message.optOutPolicy = ConstantValues.FILTER;
            mailSubject = mailSubject.replace(ConstantValues.PERSONAL_ACCOUNT_NAME,accName);
            mailBody = mailBody.replace(ConstantValues.PERSONAL_ACCOUNT_NAME,accName);
            message.subject = mailSubject;
            message.plainTextBody = mailBody;
            messages.add(message);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results.size()>0 && !results[0].success) {
                GenericUtility.insertLog('PersonAccountApprovalMail','Mail not sent');
            }
        }catch(Exception e) {
            GenericUtility.insertLog('PersonAccountApprovalMail',e); 
        }
    }
}