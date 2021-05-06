/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Rameswari Barman
Development Date : 03/05/2021
Last Modified By : Rameswari Barman
Last Modified Date : 03/05/2021
Description : Calls the Handler class CollateralOwnerTriggerHandler.
              Helps in checking whether the account owner belong to the application attached with the collateral.
***********************************************************************************************************************************************************/
Trigger CollateralOwnerTrigger on clcommon__Collateral_Owner__c (before insert){
    if(trigger.isInsert){
        Savepoint sp = Database.setSavepoint();
        try{
            Disable_Custom_Triggers__c disCustomTrigger = Disable_Custom_Triggers__c.getOrgDefaults();//Custom setting to disable this particular trigger
            if(!(disCustomTrigger.DepositTrigger__c)){
                CollateralOwnerTriggerHandler.collateralCheck(Trigger.New);
            }
        }
        catch(Exception e){
            Database.rollback(sp);
            GenericUtility.insertLog('CollateralOwnerTrigger', e);
        }
    }
}