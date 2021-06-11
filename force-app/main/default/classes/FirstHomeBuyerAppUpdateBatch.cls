/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class updates the First Home Buyer in existing Application whenever this batch job runs.
Development Date : 31/05/2021
Last Modified Date : 10/06/2021
****************************************************************************************************/
public class FirstHomeBuyerAppUpdateBatch implements DataBase.StateFul,DataBase.Batchable<sObject>{
    //Query all Application.
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT id,
                                               Name,
                                               First_Home_Buyer__c
                                           FROM genesis__Applications__c]);
    }
    public void execute(Database.BatchableContext bc, List<genesis__Applications__c> objApplicationList) {
        try{
            List<clcommon__Party__c> objPartiesList=new List<clcommon__Party__c>();
            if(objApplicationList.size()>0){
                objPartiesList=[SELECT id,
                                      First_Home_Buyer__c,
                                      genesis__Application__c
                                  FROM clcommon__Party__c 
                                  WHERE genesis__Application__c IN: objApplicationList
                                  AND First_Home_Buyer__c= 'Yes'
                                  AND Legal_Entity_Type__c='Individual'
                                  AND (clcommon__Type__r.Name='Borrower' 
                                  OR clcommon__Type__r.Name='Co-applicant' 
                                  OR clcommon__Type__r.Name='Guarantor')];
                
            }
            for(genesis__Applications__c application:objApplicationList){
                for(clcommon__Party__c party:objPartiesList){
                    if(party.genesis__Application__c==application.id){
                        application.First_Home_Buyer__c='Yes';
                    }
                }
                if(application.First_Home_Buyer__c!='Yes'){
                    application.First_Home_Buyer__c='No';
                }
            }
            
            if(objApplicationList.size()>0){
                Database.update(objApplicationList, false);
            }
            
        }catch(Exception exe){
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'FirstHomeBuyerAppUpdateBatch :Exception: '+exe.getStackTraceString()
                                        +'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
    }
    public void finish(Database.BatchableContext bc){
    }
}