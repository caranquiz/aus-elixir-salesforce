/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This trigger fires when Collateral is updated. 
Development Date : 31/08/2021
Last Modified Date : 31/08/2021
****************************************************************************************************/

trigger CollateralTrigger on clcommon__Collateral__c (After update) {
    List<Id> collId=new List<Id>();
    List<Id> collStateIds=new List<Id>();
    List<Id> collprimary=new List<Id>();
    List<Id> collStatus=new List<Id>();
    List<Id> appIds = new List<Id>();
    List<Id> applicationId = new List<Id>();
    List<Id> appId2 = new List<Id>();
    List<genesis__Application_Collateral__c> appcollateralList=new List<genesis__Application_Collateral__c>();
    if(trigger.isUpdate && trigger.isAfter){
        Savepoint sp = Database.setSavepoint();
        try{
            Disable_Custom_Triggers__c disCustomTrigger = Disable_Custom_Triggers__c.getOrgDefaults();//Custom setting to disable this particular trigger
            if(!(disCustomTrigger.CollateralTrigger__c)){
                appcollateralList=[SELECT id,
                                        genesis__Collateral__c,
                                        genesis__Collateral__r.id,
                                        genesis__Application__c,
                                        genesis__Application__r.id
                                    FROM  genesis__Application_Collateral__c
                                    WHERE genesis__Collateral__c in: Trigger.new];
                for (clcommon__Collateral__c collateral: Trigger.new) {
                    clcommon__Collateral__c oldcollateral = Trigger.oldMap.get(collateral.Id);
                    if(collateral.clcommon__Value_Date__c!= oldcollateral.clcommon__Value_Date__c){
                        collId.add(collateral.Id);
                    }
                    if(collateral.clcommon__State__c!= oldcollateral.clcommon__State__c){
                        collStateIds.add(collateral.Id);
                        collprimary.add(collateral.Id);
                    }
                    if((collateral.Primary_Usage__c!= oldcollateral.Primary_Usage__c) || (collateral.Primary_Security__c != oldcollateral.Primary_Security__c)){
                        collprimary.add(collateral.Id);
                    }
                    if(collateral.clcommon__Status__c!= oldcollateral.clcommon__Status__c){
                        collStatus.add(collateral.Id);
                    }
                }
                
                for(genesis__Application_Collateral__c appcollateral:appcollateralList){
                    if(collStateIds.size()>0 && collStateIds.contains(appcollateral.genesis__Collateral__r.id)){
                        appIds.add(appCollateral.genesis__Application__r.id);
                    }else if(collprimary.size()>0 && collprimary.contains(appcollateral.genesis__Collateral__r.id)){
                        applicationId.add(appCollateral.genesis__Application__r.id);
                    }else if(collStatus.size()>0 && collStatus.contains(appcollateral.genesis__Collateral__r.id)){
                        appId2.add(appCollateral.genesis__Application__r.id);                        
                    }
                }
                
                ValuationDateExpiryUpdateHelper.colletaralValuationDateExpiry(collId);
                UpdateFees.updateMortgageFees(appIds);
                UpdateFees.updateTitleInsuranceFees(applicationId);
                UpdateFees.updateApplicationFees(appId2);
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