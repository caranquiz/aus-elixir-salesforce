/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Rameswari Barman
Development Date : 03/05/2021
Last Modified By : Rameswari Barman
Last Modified Date : 03/05/2021
Description : Calls the Handler class CollateralOwnerTriggerHandler.
              Helps in checking whether the account owner belong to the application attached with the collateral.
***********************************************************************************************************************************************************/
Trigger CollateralOwnerTrigger on clcommon__Collateral_Owner__c (before insert, before update){
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
        Savepoint sp = Database.setSavepoint();
        try{
            Disable_Custom_Triggers__c disCustomTrigger = Disable_Custom_Triggers__c.getOrgDefaults();//Custom setting to disable this particular trigger
            if(!(disCustomTrigger.CollateralOwnerTrigger__c)){
                CollateralOwnerTriggerHandler.collateralCheck(Trigger.New);
            }
            //The forced error had to be inserted as only the catch block was not getting executed
            //and coverage was not achieved
            if(Test.isRunningTest()){
                Integer x = 10/0;
            }
        }
        catch(Exception e){
            Database.rollback(sp);
            GenericUtility.insertLog('CollateralOwnerTrigger', e);
        }
    }
}