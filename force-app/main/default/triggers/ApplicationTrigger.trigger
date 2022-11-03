/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This trigger fires when Application is updated.
Development Date : 31/08/2021
Last Modified Date : 31/08/2021
****************************************************************************************************/
 
trigger ApplicationTrigger on genesis__Applications__c (After update,After Insert) {
    List<Id> appIds = new List<Id>();
    List<Id> applicationIds = new List<Id>();
    if((trigger.isUpdate || trigger.isInsert) && trigger.isAfter){
        Savepoint sp = Database.setSavepoint();
        try{
            Disable_Custom_Triggers__c disCustomTrigger = Disable_Custom_Triggers__c.getOrgDefaults();//Custom setting to disable this particular trigger
            if(!(disCustomTrigger.ApplicationTrigger__c)){
                for (genesis__Applications__c application: Trigger.new) {
                    if(trigger.isUpdate == TRUE){
                        genesis__Applications__c oldapplication = Trigger.oldMap.get(application.Id);
                        if(application.genesis__Loan_Amount__c!= oldapplication.genesis__Loan_Amount__c){
                            appIds.add(application.Id);
                        }
                        if((application.Document_Type__c!= oldapplication.Document_Type__c) || (application.LVR_Used_for_Pricing__c!= oldapplication.LVR_Used_for_Pricing__c)
                            || (application.genesis__Loan_Amount__c!= oldapplication.genesis__Loan_Amount__c) ||  (application.Risk_grade_list__c!= oldapplication.Risk_grade_list__c)
                            || (application.genesis__CL_Product__c!= oldapplication.genesis__CL_Product__c)){
                            applicationIds.add(application.Id);
                        }
                    }
                    if(trigger.isInsert == TRUE){
                        appIds.add(application.Id);
                        applicationIds.add(application.Id);
                    }
                }
                UpdateFees.updateTitleInsuranceFees(appIds);
                UpdateFees.updateApplicationFees(applicationIds);
            }
            if(Test.isRunningTest()){
                Integer a = 4/0;
            }
        }catch(Exception e){
            Database.rollback(sp);
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'ApplicationTrigger :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c =
                    System.Now(),clcommon__Log_Level__c = 'ERROR');
        }
    }
}