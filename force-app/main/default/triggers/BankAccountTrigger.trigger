/****************************************************************************************************
Description:    This is a Trigger on Bank Account Object. It fires on insert and update of a record 
Developer:      Sayak Mukhopadhyay
Created Date:   11/03/2022
*****************************************************************************************************/



trigger BankAccountTrigger on loan__Bank_Account__c(before insert,after insert,before update,after update){
    Disable_Custom_Triggers__c disCustomTrigger = Disable_Custom_Triggers__c.getOrgDefaults();//Custom setting to disable this particular trigger
    if(!(disCustomTrigger.Bank_Account_Trigger__c)){
        if(trigger.isInsert){
            Savepoint sp = Database.setSavepoint();
            try{
                if(trigger.isBefore){
                    BankAccountTriggerHelper.updateChangeField(Trigger.new);
                }
                else if(trigger.isAfter){
                    BankAccountTriggerHelper.submitApprovalOnInsert(Trigger.new);
                }
            }catch(Exception e){
                GenericUtility.insertLog('BankAccountTrigger',e);                           
                Database.rollback(sp);
            }
        }
        if(trigger.isUpdate){
            Savepoint sp  = Database.setSavepoint();
            try{
                if(trigger.isBefore){
                    BankAccountTriggerHelper.updateFields(Trigger.new,Trigger.oldMap);
                }
                else if(trigger.isAfter){
                    BankAccountTriggerHelper.submitApprovalOnUpdate(Trigger.new,Trigger.oldMap);
                }
            }catch(Exception e){
                GenericUtility.insertLog('BankAccountTrigger',e); 
                Database.rollback(sp);
            }
        }
    }
}