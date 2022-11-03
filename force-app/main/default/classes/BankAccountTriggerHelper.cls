/****************************************************************************************************
Description:    This Class is a Helper Class for Bank Account Trigger
Developer:      Sayak Mukhopadhyay
Created Date:   11/03/2022
*****************************************************************************************************/

public class BankAccountTriggerHelper {
    public static void updateChangeField(List<loan__Bank_Account__c> newBankAccountList){
        Savepoint sp = Database.setSavepoint();
        try{
            for(loan__Bank_Account__c eachBankAccount : newBankAccountList) {
                eachBankAccount.Bank_Account_Number_Change__c = eachBankAccount.loan__Bank_Account_Number__c;
                eachBankAccount.Bank_Account_Name_Change__c = eachBankAccount.Bank_Account_Name__c;
                eachBankAccount.Bank_Name_Change__c = eachBankAccount.loan__Bank_Name__c;
                eachBankAccount.Account_Usage_Change__c = eachBankAccount.loan__Account_Usage__c;
                eachBankAccount.Active_Change__c = eachBankAccount.loan__Active__c;
                eachBankAccount.Account_Change__c = eachBankAccount.loan__Account__c;
                eachBankAccount.BSB_Number_Change__c = eachBankAccount.BSB_Number__c;
            }
        }catch(Exception e){
            GenericUtility.insertLog('BankAccountTriggerHelper',e); 
            Database.rollback(sp);
        }
    }
    public static void submitApprovalOnInsert(List<loan__Bank_Account__c> newBankAccountList){
        Savepoint sp = Database.setSavepoint();
        try{
            for(loan__Bank_Account__c eachBankAccount : newBankAccountList){
                if (!eachBankAccount.Created_After_Conversion__c){
                    submitForApproval(eachBankAccount);
                } 
                if(eachBankAccount.Created_After_Conversion__c){
                    submitForApproval(eachBankAccount);
                }
            }
        }catch(Exception e){
            GenericUtility.insertLog('BankAccountTriggerHelper',e);
            Database.rollback(sp);
        }
    }
public static void updateFields(List<loan__Bank_Account__c> newBankAccountList, Map<Id,loan__Bank_Account__c> oldMap){
        Savepoint sp = Database.setSavepoint();
        try{
            List<loan__Loan_Account__c> contractList = new List<loan__Loan_Account__c>();
            List<Id> bankAccountIdList = new List<Id>();
            for(loan__Bank_Account__c eachBankAccount : newBankAccountList){
                bankAccountIdList.add(eachBankAccount.id);
            }
            contractList = [SELECT id,
                                loan__Borrower_ACH__c,
                                Borrower_ACH_Change__c,
                                Bank_Detail_Change__c
                                FROM loan__Loan_Account__c
                                WHERE Borrower_ACH_Change__c in: bankAccountIdList];
            for(loan__Bank_Account__c eachBankAccount : newBankAccountList){
                if(!eachBankAccount.Submit_For_Approval__c && oldMap.get(eachBankAccount.id).Submit_For_Approval__c){
                    if(eachBankAccount.Approved__c) {
                        eachBankAccount.Field_Update__c = true;
                        eachBankAccount.loan__Bank_Account_Number__c = eachBankAccount.Bank_Account_Number_Change__c;
                        eachBankAccount.Bank_Account_Name__c = eachBankAccount.Bank_Account_Name_Change__c;
                        eachBankAccount.loan__Bank_Name__c = eachBankAccount.Bank_Name_Change__c;
                        eachBankAccount.loan__Account_Usage__c = eachBankAccount.Account_Usage_Change__c;
                        eachBankAccount.loan__Active__c = eachBankAccount.Active_Change__c;
                        eachBankAccount.loan__Account__c = eachBankAccount.Account_Change__c;
                        eachBankAccount.BSB_Number__c = eachBankAccount.BSB_Number_Change__c;
                        eachBankAccount.Approved__c = false;
                        eachBankAccount.Field_Update__c = false;
                        if(eachBankAccount.Created_After_Conversion__c){
                            for(loan__Loan_Account__c eachContract : contractList){
                               if(eachContract.Borrower_ACH_Change__c == eachBankAccount.id && eachContract.Borrower_ACH_Change__c != eachContract.loan__Borrower_ACH__c){
                                    eachContract.loan__Borrower_ACH__c = eachContract.Borrower_ACH_Change__c;
                               }
                            }
                        }else{
                            for(loan__Loan_Account__c eachContract : contractList){
                                eachContract.Bank_Detail_Change__c=true;
                            }

                        }
                        Database.update(contractList,false);
                        eachBankAccount.Created_After_Conversion__c = false;
                    } else{
                        eachBankAccount.Bank_Account_Number_Change__c = oldMap.get(eachBankAccount.id).loan__Bank_Account_Number__c;
                        eachBankAccount.Bank_Account_Name_Change__c = oldMap.get(eachBankAccount.id).Bank_Account_Name__c;
                        eachBankAccount.Bank_Name_Change__c = oldMap.get(eachBankAccount.id).loan__Bank_Name__c;
                        eachBankAccount.Account_Usage_Change__c = oldMap.get(eachBankAccount.id).loan__Account_Usage__c;
                        eachBankAccount.Active_Change__c = oldMap.get(eachBankAccount.id).loan__Active__c;
                        eachBankAccount.Account_Change__c = oldMap.get(eachBankAccount.id).loan__Account__c;
                        eachBankAccount.BSB_Number_Change__c = oldMap.get(eachBankAccount.id).BSB_Number__c;
                        String taskComment = 'The Bank Account has been rejected due to incorrect information being entered. Please review, re-enter and submit again for approval as soon as possible.';
                        newTaskOnBankAccount(oldMap.get(eachBankAccount.id),taskComment);
                    }
                }
            }
        }catch(Exception e){
            GenericUtility.insertLog('BankAccountTriggerHelper',e);
            Database.rollback(sp);
        }
    }
    public static void submitApprovalOnUpdate(List<loan__Bank_Account__c> newBankAccountList, Map<Id,loan__Bank_Account__c> oldMap){
        for(loan__Bank_Account__c eachBankAccount : newBankAccountList){
            loan__Bank_Account__c oldBankAccount = oldMap.get(eachBankAccount.Id);
            if(!eachBankAccount.Submit_For_Approval__c && oldBankAccount.Submit_For_Approval__c){
                continue;
            }
            else if((eachBankAccount.Bank_Account_Number_Change__c != oldBankAccount.Bank_Account_Number_Change__c) ||
              (eachBankAccount.Bank_Account_Name_Change__c != oldBankAccount.Bank_Account_Name_Change__c) ||
              (eachBankAccount.Bank_Name_Change__c != oldBankAccount.Bank_Name_Change__c) ||
              (eachBankAccount.Account_Usage_Change__c != oldBankAccount.Account_Usage_Change__c) ||
              (eachBankAccount.Active_Change__c != oldBankAccount.Active_Change__c) ||
              (eachBankAccount.Account_Change__c != oldBankAccount.Account_Change__c) ||
              (eachBankAccount.BSB_Number_Change__c != oldBankAccount.BSB_Number_Change__c)){
                submitForApproval(eachBankAccount);
                  
            }
        }
    }
    public static void submitForApproval(loan__Bank_Account__c bankAccount) {               
        Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();          
        approvalRequest.setComments('Submitting approval request');        
        approvalRequest.setObjectId(bankAccount.id);    
        Approval.ProcessResult result = Approval.process(approvalRequest);        
    }
    public static void newTaskOnBankAccount(loan__Bank_Account__c bankAccount,String comment){
        try{
            Task newTask = new Task();
            newTask.ActivityDate = bankAccount.LastModifiedDate.date();
            newTask.Description__c = ConstantValues.REVIEW_AND_RESUBMIT;
            newTask.Description = comment;
            newTask.OwnerId = bankAccount.LastModifiedById;
            newTask.Priority = ConstantValues.HIGH;
            newTask.Status = ConstantValues.NOT_STARTED;
            newTask.Subject = ConstantValues.INTERNAL_TASK;
            newTask.WhatId = bankAccount.id;
            insert newTask;
        }catch(Exception e){
            GenericUtility.insertLog('BankAccountTriggerHelper',e);
        }
    }
}