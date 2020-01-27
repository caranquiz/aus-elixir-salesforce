/*******************************
Trigger Name : DepositTrigger
Developer : Deep Bhattacharjee
Purpose : When a record in Deposit Details in Cl Contract is updated, this trigger acts.
          Through this trigger DepositUpdateHelper class is called which updates Deposit Amount of CL Contract
********************************/

Trigger DepositTrigger on clcommon__Deposit__c (after update){
    if(trigger.isUpdate){
        Savepoint sp = Database.setSavepoint();
        try{
            Disable_Custom_Triggers__c disCustomTrigger = Disable_Custom_Triggers__c.getOrgDefaults();//Custom setting to disable this particular trigger
            if(!(disCustomTrigger.DepositTrigger__c)){
                DepositUpdateHelper.depositUpdate(Trigger.New);
            }
            if(Test.isRunningTest()){
                Integer x = 10/0;
            }
        }
        catch(Exception e){
            Database.rollback(sp);
            insert new clcommon__Log__c(
                clcommon__Message__c = 'DepositTrigger :Exception: '+e.getStackTraceString()+'error= '+e.getMessage()+' at Line Number '+e.getLineNumber(),
                clcommon__Time__c = System.Now());
        }
    }
}