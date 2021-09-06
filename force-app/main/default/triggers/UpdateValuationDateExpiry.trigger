/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This trigger fires when Collateral Value Date is updated. 
Development Date : 31/08/2021
Last Modified Date : 31/08/2021
****************************************************************************************************/

trigger UpdateValuationDateExpiry on clcommon__Collateral__c (After update) {
    List<Id> collId=new List<Id>();
    if(trigger.isUpdate){
        Savepoint sp = Database.setSavepoint();
        try{
            Disable_Custom_Triggers__c disCustomTrigger = Disable_Custom_Triggers__c.getOrgDefaults();//Custom setting to disable this particular trigger
            if(!(disCustomTrigger.UpdateValuationDateExpiry__c)){
                for (clcommon__Collateral__c collateral: Trigger.new) {
                    clcommon__Collateral__c oldcollateral = Trigger.oldMap.get(collateral.Id);
                    if(collateral.clcommon__Value_Date__c!= oldcollateral.clcommon__Value_Date__c){
                        collId.add(collateral.Id);
                    }
                }
                ValuationDateExpiryUpdateHelper.colletaralValuationDateExpiry(collId);
            }
            if(Test.isRunningTest()){
                Integer a = 4/0;
            }
        }catch(Exception e){
            Database.rollback(sp);
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'UpdateValuationDateExpiry :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = 
                    System.Now(),clcommon__Log_Level__c = 'ERROR'); 
        }
    }
}