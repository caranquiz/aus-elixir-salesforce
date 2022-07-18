/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This trigger fires when application colletral is deleted or inserted.
Development Date : 31/08/2021
Last Modified Date : 31/08/2021
****************************************************************************************************/

trigger ApplicationCollateralTrigger on genesis__Application_Collateral__c (After insert,After delete) {
    List<Id> coll=new List<Id>();
    List<genesis__Application_Collateral__c> appCollateralList=new List<genesis__Application_Collateral__c>();
    if((Trigger.isAfter && Trigger.isDelete) || (Trigger.isAfter && Trigger.isInsert)) {
        Savepoint sp = Database.setSavepoint();
        try{
            Disable_Custom_Triggers__c disCustomTrigger = Disable_Custom_Triggers__c.getOrgDefaults();//Custom setting to disable this particular trigger
            if(!(disCustomTrigger.UpdateValueDateTrigger__c) && Trigger.isAfter){
                if(Trigger.isDelete){
                    appCollateralList.addAll(Trigger.old);
                }else if(Trigger.isInsert){
                    appCollateralList.addAll(Trigger.new);
                }
            }
            ValuationDateExpiryUpdateHelper.applicationColletaralValueDate(appCollateralList);
            for (genesis__Application_Collateral__c collateral: appCollateralList) {
                coll.add(collateral.genesis__Application__c);
            }
            UpdateFees.updateMortgageFees(coll);
            UpdateFees.updateTitleInsuranceFees(coll);
            Set<Id> appplicationSet = new Set<Id>();
            appplicationSet.addAll(coll);
            ValuationDateExpiryUpdateHelper.updateTotalSecurities(appplicationSet);
        }catch(Exception e){
            Database.rollback(sp);
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'UpdateValueDateTrigger :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = 
                    System.Now(),clcommon__Log_Level__c = 'ERROR'); 
        } 
    }
    
}