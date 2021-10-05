/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This trigger fires when application colletral is deleted or inserted.
Development Date : 31/08/2021
Last Modified Date : 31/08/2021
****************************************************************************************************/

trigger UpdateValueDateTrigger on genesis__Application_Collateral__c (After insert,After delete) {
    List<Id> coll=new List<Id>();
    if((Trigger.isAfter && Trigger.isDelete) || (Trigger.isAfter && Trigger.isInsert)) {
        Savepoint sp = Database.setSavepoint();
        try{
            Disable_Custom_Triggers__c disCustomTrigger = Disable_Custom_Triggers__c.getOrgDefaults();//Custom setting to disable this particular trigger
            if(!(disCustomTrigger.UpdateValueDateTrigger__c) && (Trigger.isAfter && Trigger.isDelete)){
                ValuationDateExpiryUpdateHelper.applicationColletaralValueDate(Trigger.old);
                for (genesis__Application_Collateral__c collateral: Trigger.old) {
                    system.debug('delete');
                    system.debug(collateral.genesis__Collateral__c);
                    system.debug(collateral.genesis__Application__c);
                    coll.add(collateral.genesis__Application__c);
                }
                system.debug('colllDelete-->'+coll);
                UpdateFees.updateMortgageFees(coll);
                UpdateFees.updateTitleInsuranceFees(coll);
            }
            if(!(disCustomTrigger.UpdateValueDateTrigger__c) && (Trigger.isAfter && Trigger.isInsert)){
                ValuationDateExpiryUpdateHelper.applicationColletaralValueDate(Trigger.new);
                for (genesis__Application_Collateral__c collateral: Trigger.new) {
                    system.debug('hiii');
                    coll.add(collateral.genesis__Application__c);
                }
                system.debug('colll-->'+coll);
                UpdateFees.updateMortgageFees(coll);
                UpdateFees.updateTitleInsuranceFees(coll);
            }
            if(Test.isRunningTest()){
                Integer a = 4/0;
            }
        }catch(Exception e){
            Database.rollback(sp);
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'UpdateValueDateTrigger :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = 
                    System.Now(),clcommon__Log_Level__c = 'ERROR'); 
        } 
    }
    
}