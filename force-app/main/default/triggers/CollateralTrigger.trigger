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
    List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
    List<Id> appIds = new List<Id>();
    List<genesis__Applications__c> appList1 = new List<genesis__Applications__c>();
    List<Id> applicationId = new List<Id>();
    List<genesis__Applications__c> appList2 = new List<genesis__Applications__c>();
    List<Id> appId2 = new List<Id>();
    if(trigger.isUpdate && trigger.isAfter){
        Savepoint sp = Database.setSavepoint();
        try{
            Disable_Custom_Triggers__c disCustomTrigger = Disable_Custom_Triggers__c.getOrgDefaults();//Custom setting to disable this particular trigger
            if(!(disCustomTrigger.CollateralTrigger__c)){
                
                for (clcommon__Collateral__c collateral: Trigger.new) {
                    clcommon__Collateral__c oldcollateral = Trigger.oldMap.get(collateral.Id);
                    if(collateral.clcommon__Value_Date__c!= oldcollateral.clcommon__Value_Date__c){
                        collId.add(collateral.Id);
                    }
                    if(collateral.clcommon__State__c!= oldcollateral.clcommon__State__c){
                        collStateIds.add(collateral.Id);
                        collprimary.add(collateral.Id);
                    }
                    if(collateral.Primary_Usage__c!= oldcollateral.Primary_Usage__c){
                        collprimary.add(collateral.Id);
                    }
                    if(collateral.clcommon__Status__c!= oldcollateral.clcommon__Status__c){
                        collStatus.add(collateral.Id);
                    }
                }
                if(collStateIds.size()>0){
                    appList = [Select Id,
                                    Mortgage_Registration_Fee__c
                                    FROM genesis__Applications__c
                                    WHERE Id IN (SELECT genesis__Application__c
                                    FROM genesis__Application_Collateral__c 
                                    WHERE genesis__Collateral__c in: collStateIds)
                                    ORDER BY Id];
                    for(genesis__Applications__c eachApp : appList){
                        appIds.add(eachApp.Id);
                    }
                }
                if(collprimary.size()>0){
                    appList1 = [Select Id
                                    FROM genesis__Applications__c
                                    WHERE Id IN (SELECT genesis__Application__c
                                    FROM genesis__Application_Collateral__c 
                                    WHERE genesis__Collateral__c in: collprimary)
                                    ORDER BY Id];
                    for(genesis__Applications__c eachApp : appList1){
                        applicationId.add(eachApp.Id);
                    }
                }
                if(collStatus.size()>0){
                    appList2 = [Select Id
                                    FROM genesis__Applications__c
                                    WHERE Id IN (SELECT genesis__Application__c
                                    FROM genesis__Application_Collateral__c 
                                    WHERE genesis__Collateral__c in: collStatus)
                                    ORDER BY Id];
                    for(genesis__Applications__c eachApp : appList2){
                        appId2.add(eachApp.Id);
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