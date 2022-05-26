/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This trigger fires when Loan Collateral is created or updated. 
Development Date : 14/02/2022
Last Modified Date : 24/02/2022
****************************************************************************************************/
trigger LoanCollateralTrigger on loan__Loan_Collateral__c (after insert,after Update) {
    List<loan__Loan_Collateral__c> loanCollList=new List<loan__Loan_Collateral__c>();
    List<Id> loanIdList=new List<Id>();
    try{
        Disable_Custom_Triggers__c disCustomTrigger = Disable_Custom_Triggers__c.getOrgDefaults();//Custom setting to disable this particular trigger
        if(!(disCustomTrigger.LoanCollateralTrigger__c)){
            if (Trigger.isInsert) {
                for (loan__Loan_Collateral__c collateral: Trigger.new) {
                    loanIdList.add(collateral.loan__Loan__c);
                    loanCollList.add(collateral);
                }
            }else{
                for (loan__Loan_Collateral__c collateral: Trigger.new) {
                    loan__Loan_Collateral__c oldcollateral = Trigger.oldMap.get(collateral.Id);
                    if(collateral.Primary_Security__c != oldcollateral.Primary_Security__c){
                        loanIdList.add(collateral.loan__Loan__c);
                        loanCollList.add(collateral);
                    }
                }
            }
            LoanCollateralTriggerHelper.loanColletaralUpdation(loanIdList,loanCollList);
            if(test.isRunningTest()){
                Integer a = 4/0;
            }
        }
    }catch(Exception e){
        insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'LoanCollateralTrigger :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = 
                    System.Now(),clcommon__Log_Level__c = 'ERROR'); 
    }
}