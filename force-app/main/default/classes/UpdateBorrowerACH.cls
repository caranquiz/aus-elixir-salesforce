/****************************************************************************************************
Description:    This Class acts as a helper class for the Approval Process of CL Contract
Developer:      Sayak Mukhopadhyay
Created Date:   11/03/2022
*****************************************************************************************************/


global with sharing class UpdateBorrowerACH {
    Webservice static void updateAfterApprovalWS(Id contractId){
        Savepoint sp = Database.setSavepoint();
        try{
            loan__Loan_Account__c contract = [SELECT id,
                loan__Borrower_ACH__c,
                Borrower_ACH_Change__c
                FROM loan__Loan_Account__c
                WHERE id =: contractId];
            if(contract.loan__Borrower_ACH__c != contract.Borrower_ACH_Change__c){
                contract.loan__Borrower_ACH__c = contract.Borrower_ACH_Change__c;
                contract.RecordTypeId = ConstantValues.CONTRACT_LOAN_RECORD_TYPE_ID;
            }
            Database.update(contract);
        }catch(Exception e){
            GenericUtility.insertLog('UpdateBorrowerACH',e);
            Database.rollback(sp);
        }
    }
    Webservice static Boolean checkStatusWS(Id contractId){
        Savepoint sp = Database.setSavepoint();
        try{
            loan__Loan_Account__c contract = [SELECT id,
                Borrower_ACH_Change__r.Submit_For_Approval__c
                FROM loan__Loan_Account__c
                WHERE id =: contractId];
            if(contract.Borrower_ACH_Change__r.Submit_For_Approval__c){
                return false;
            }
            return true;
        }catch(Exception e){
            GenericUtility.insertLog('UpdateBorrowerACH',e);
            return false;
        }
    }
    Webservice static void updateAfterRejectionWS(Id contractId){
        Savepoint sp = Database.setSavepoint();
        try{
            loan__Loan_Account__c contract = [SELECT id,
                loan__Borrower_ACH__c,
                Borrower_ACH_Change__c
                FROM loan__Loan_Account__c
                WHERE id =: contractId];
            if(contract.loan__Borrower_ACH__c != contract.Borrower_ACH_Change__c){
                contract.Borrower_ACH_Change__c = contract.loan__Borrower_ACH__c;
                contract.RecordTypeId = ConstantValues.CONTRACT_LOAN_RECORD_TYPE_ID;
            }
            Database.update(contract);
        }catch(Exception e){
            GenericUtility.insertLog('UpdateBorrowerACH',e);
            Database.rollback(sp);
        }
    }
     Webservice static void sendEmailAfterApprovedWS(Id contractId){
        try{
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            loan__Loan_Account__c contract = [SELECT id,
                        Name,
                        LastModifiedBy.Email
                        FROM loan__Loan_Account__c
                        WHERE id =: contractId];
            String recieverAddress = contract.LastModifiedBy.Email;
            String subject = 'Bank account for CL contract has been approved';
            String body = 'Hi,\n\nThis is to notify you that the bank account changes you made on '+contract.Name+' have been approved.\n\nKind Regards,';
            sendMail(recieverAddress,subject,body);
        }catch(Exception e){
            GenericUtility.insertLog('UpdateBorrowerACH',e);
        }
    }
    Webservice static void sendEmailAfterRejectionWS(Id contractId,String comments){
        try{
            loan__Loan_Account__c contract = [SELECT id,
                        Name,
                        LastModifiedBy.Email,
                        LastModifiedById,
                        LastModifiedDate
                    FROM loan__Loan_Account__c
                    WHERE id =: contractId];
            String recieverAddress = contract.LastModifiedBy.Email;
            String subject = 'Bank account for CL contract has been rejected';
            String body = 'Hi,\n\nThis is to notify you that the bank account changes you made on '+contract.Name+' have been rejected because '+comments+'.'+'\n\nKind Regards,';
            sendMail(recieverAddress,subject,body);
            String taskComment = 'The ACH for this contract has been rejected due to incorrect information being entered. Please review and re-submit for approval as soon as possible.';
            newTaskOnContract(contract,taskComment);
        }catch(Exception e){
            GenericUtility.insertLog('UpdateBorrowerACH',e);
        }
    }
    public static void sendMail(String recieverAddress,String subject,String body){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] {recieverAddress};
        message.optOutPolicy = 'FILTER';
        message.subject = subject;
        message.plainTextBody = body;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (!results[0].success) {
            GenericUtility.insertLog('UpdateBorrowerACH','Mail not sent');
        }
    }
    public static void newTaskOnContract(loan__Loan_Account__c contract,String comment){
        Task newTask = new Task();
        newTask.ActivityDate = contract.LastModifiedDate.date();
        newTask.Description__c = ConstantValues.REVIEW_AND_RESUBMIT;
        newTask.Description = comment;
        newTask.OwnerId = contract.LastModifiedById;
        newTask.Priority = ConstantValues.HIGH;
        newTask.Status = ConstantValues.NOT_STARTED;
        newTask.Subject = ConstantValues.INTERNAL_TASK;
        newTask.WhatId = contract.id;
        insert newTask;
    }
}