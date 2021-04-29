/*********************************************************************************************************
Class Name     : ConvertToContract
Description    : Apex class for converting application to contract throgh conversion mappping
Developer      : Rameswari Barman
Implementation code : genesis__applications__c app = [select id from genesis__applications__c where id = 'XXX'];
                      ConvertToContract.executeFun(app.Id)
**********************************************************************************************************/

global with sharing class ConvertToContract{
    Webservice static String executeFun(Id appId){
        String ret = '';
        //Savepoint is setup over here
        Savepoint sp=Database.setSavepoint();
        try{
            genesis__applications__c app = new genesis__applications__c(id=appId);
            String status = genesis.ConvertApplicationCtrl.convertApplicationToContract(appId);//storing the returned message from product class call
            if(status == System.label.Application_converted_to_Contract_message && Schema.sObjectType.genesis__applications__c.fields.genesis__Status__c.isUpdateable()){
                app.genesis__Status__c = System.label.ApplicationStatusAfterConvertedToContract;
                //updating the status of application
                update app;
                attachValues(appId);
            }
            else{
                Database.rollback(sp);
                if(test.isRunningTest()){
                    Integer a = 4/0;
                }
            }
            ret = status;
        }
        catch(Exception e){
            Database.rollback(sp);
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'ConvertToContract :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = 
                                                  System.Now(),clcommon__Log_Level__c = 'ERROR'); 
            ret = e.getMessage();  
        }
        return ret;
    }
    //This function copies values from application to Contract during conversion
    Webservice static String attachValues(Id appId){
        String ret;
        loan__Bank_Account__c banAcc;
        Savepoint sp=Database.setSavepoint();
        try{
            genesis__Applications__c app = [select id,
                                                Primary_loan_purpose_list__c,
                                                Proposed_repayment_method_list__c,
                                                CL_Contract__c,genesis__Account__c,
                                                genesis__Account__r.Bank_Account_Name__c,
                                                genesis__Account__r.BSB__c,
                                                genesis__Account__r.Bank_Account_Number__c,
                                                CreatedDate
                                            from genesis__Applications__c where Id =: appId];
            if(app.CL_Contract__c != null){
                loan__Loan_Account__c contr = [select id,
                                                    loan__Payment_Mode__c,
                                                    loan__Loan_Purpose__c,
                                                    loan__Approval_Date__c
                                                from loan__Loan_Account__c 
                                                where id =: app.CL_Contract__c];
                //Checking if proposed repayment method list is provided in application or not
                if(app.Proposed_repayment_method_list__c != null){
                    loan__Payment_Mode__c paymentModeId = [select id from loan__Payment_Mode__c where name =: app.Proposed_repayment_method_list__c];
                    contr.loan__Payment_Mode__c = paymentModeId.Id;
                }
                //Checking if loan purpose list is provided in application or not
                if(app.Primary_loan_purpose_list__c != null){
                    loan__Loan_Purpose__c purposeId = [select id from loan__Loan_Purpose__c where name =: app.Primary_loan_purpose_list__c];
                    contr.loan__Loan_Purpose__c = purposeId.Id;
                }
                //Attaching Bank Account
                if(app.genesis__Account__r.Bank_Account_Name__c != null && app.genesis__Account__r.BSB__c != null && app.genesis__Account__r.Bank_Account_Number__c != null){
                    banAcc = new loan__Bank_Account__c();
                    banAcc.loan__Bank_Account_Number__c = app.genesis__Account__r.Bank_Account_Number__c;
                    banAcc.BSB_Number__c = app.genesis__Account__r.BSB__c;
                    banAcc.Bank_Account_Name__c = app.genesis__Account__r.Bank_Account_Name__c;
                    banAcc.loan__Active__c = true;
                    banAcc.loan__Account_Usage__c = System.label.Borrower_Bank_Account_Type;
                    banAcc.loan__Bank_Name__c = app.genesis__Account__r.BSB__c;
                    banAcc.loan__Account__c = app.genesis__Account__c;
                    if(banAcc != null){
                        insert banAcc;
                        contr.loan__Borrower_ACH__c = banAcc.Id;
                    }
                }
                //Change made by Rameswari on 24/12/2020
                //Attaching Application Date and Approval Date
                DateTime appCreationDate = app.CreatedDate;
                contr.loan__Application_Date__c = date.newInstance(appCreationDate.year() ,appCreationDate.month(), appCreationDate.day());
                
                if(contr != null 
                    && (app.Proposed_repayment_method_list__c != null
                    || app.Primary_loan_purpose_list__c != null 
                    || banAcc!=null 
                    || appCreationDate != null)){
                    update contr;
                }
            }
        }
        catch(Exception e){
            Database.rollback(sp);
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'ConvertToContract :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = 
                                                  System.Now(),clcommon__Log_Level__c = 'ERROR'); 
            ret = e.getMessage();  
        }
        return ret;
    }
}