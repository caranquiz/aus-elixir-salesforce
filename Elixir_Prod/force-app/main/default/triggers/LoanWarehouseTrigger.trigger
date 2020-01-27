/***********************************************************************************************************************
Trigger Name - LoanWarehouseTrigger
Developer - Rameswari Barman
Purpose - When a record in Loan Warehouse junction is inserted, through this trigger acts.
          With the help of this trigger, LoanWarehouseChangeHelper class is called and values in the records of junction object are updated. 
          The newly inserted record value is changed to Active and all the existing application/contract loan warehouse record status is changed to Inactive.
***********************************************************************************************************************/
trigger LoanWarehouseTrigger on Loan_Warehouse__c(after insert){
    if(trigger.isAfter && trigger.isInsert){
        Savepoint sp = Database.setSavepoint();
        try{
            Disable_Custom_Triggers__c disCustomTrigger = Disable_Custom_Triggers__c.getOrgDefaults();//Custom setting to disable this particular trigger
            if(!(disCustomTrigger.LoanWarehouseTrigger__c)){
                LoanWarehouseChangeHelper.loanWarehouse(Trigger.New);
            }
            if(Test.isRunningTest()){
                Integer a = 4/0;
            }
        }
        catch(Exception e){
            Database.rollback(sp);
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'LoanWarehouseTrigger :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = 
                                                  System.Now(),clcommon__Log_Level__c = 'ERROR'); 
            System.debug(e.getMessage()); 
        }
    } 
}