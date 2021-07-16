/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class updates the Broker Field in existing Application whenever this batch job runs.
Development Date : 30/06/2021
Last Modified Date : 30/06/2021
****************************************************************************************************/
public class BrokerApplicationUpdateBatch implements DataBase.StateFul,DataBase.Batchable<sObject>{
    //Query all Application.
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT id,
                                               Name,
                                               Broker__c
                                           FROM genesis__Applications__c
                                           WHERE Broker__c=NULL]);
    }
    public void execute(Database.BatchableContext bc, List<genesis__Applications__c> objApplicationList) {
        try{
            List<clcommon__Party__c> objPartiesList=new List<clcommon__Party__c>();
            Map<Id,Id> partyMap=new Map<Id,Id>();
            if(objApplicationList.size()>0){
                objPartiesList=[SELECT id,
                                      clcommon__Account__c,
                                      genesis__Application__c
                                  FROM clcommon__Party__c 
                                  WHERE genesis__Application__c IN: objApplicationList
                                  AND clcommon__Type__r.Name=:ConstantValues.BROKER_PARTY_TYPE];
                
            }
            for(clcommon__Party__c party:objPartiesList){
                partyMap.put(party.genesis__Application__c,party.clcommon__Account__c);
            }
            for(genesis__Applications__c application:objApplicationList){
                if(partyMap.containskey(application.id) && partyMap.get(application.id)!=Null){
                    application.Broker__c= partyMap.get(application.id);
                }
            }
            
            if(objApplicationList.size()>0){
                Database.update(objApplicationList, false);
            }
            
        }catch(Exception exe){
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'BrokerApplicationUpdateBatch :Exception: '+exe.getStackTraceString()
                                        +'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
    }
    public void finish(Database.BatchableContext bc){
    }

}