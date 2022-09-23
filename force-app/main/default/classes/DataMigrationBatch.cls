/****************************************************************************************************
Company              : Cloudkaptan Consultancy Services Pvt. Ltd. 
Class Name           : UpdateEmploymentTypeOnApplication 
Created Date         : 19/08/2022 
Developed By         : Sayak Mukhopadhyay
Last Modified By     : Sayak Mukhopadhyay
Description          : This Batch Job is used for One time Data Migration
****************************************************************************************************/
public class DataMigrationBatch implements DataBase.StateFul,DataBase.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT id,
                                            Monthly_Living_Expenses_Used__c
                                            FROM genesis__Applications__c]);
    }
    public void execute(Database.BatchableContext bc, List<genesis__Applications__c>objAppList){
        Double partyLivingExpense = 0;
        List<String> partyTypeList = new String[]{ConstantValues.BORROWER,ConstantValues.GUARANTOR,ConstantValues.CO_APPLICANT};
        List<clcommon__Party__c> objPartyList = [SELECT id,
                                                    Name,
                                                    genesis__Application__c,
                                                    Living_Expense_Used_for_Servicing_Purpos__c,
                                                    clcommon__Account__r.Name 
                                                    FROM clcommon__Party__c  
                                                    WHERE genesis__Application__c in: objAppList 
                                                    AND ((Party_Type_Name__c IN: partyTypeList
                                                    AND Legal_Entity_Type__c =: ConstantValues.indType) 
                                                    OR Party_Type_Name__c =: ConstantValues.HOUSEHOLD_PARTY_TYPE)];
        Map<Id,Double> totalLivingExpenseMap = new Map<Id,Double>();
        for(genesis__Applications__c objApp : objAppList){
            totalLivingExpenseMap.put(objApp.id,0.0);
        }
        for(clcommon__Party__c objParty : objPartyList){
            partyLivingExpense = objParty.Living_Expense_Used_for_Servicing_Purpos__c;
            if(partyLivingExpense != null && totalLivingExpenseMap.containsKey(objParty.genesis__Application__c)){
                totalLivingExpenseMap.put(objParty.genesis__Application__c,totalLivingExpenseMap.get(objParty.genesis__Application__c) + partyLivingExpense);
            }
        }
        for(genesis__Applications__c objApp : objAppList){
            if(totalLivingExpenseMap.containsKey(objApp.id)){
                objApp.Monthly_Living_Expenses_Used__c = totalLivingExpenseMap.get(objApp.id);
            }
        }
        if(objAppList.size()>0){
            Database.update(objAppList,false);
        }
    }
    public void finish(Database.BatchableContext bc){
    }
}