/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class checks across party's Most Recent Coduct Date 
                and updates the most recent conduct issue date in application
Development Date : 13/05/2021
Last Modified Date : 13/05/2021
****************************************************************************************************/
global with sharing class UpdateMostRecentConductInApplication {
    //Method used for updating the most recent conduct issue date in applications
    Webservice static String updateMostRecentConductIssueDate(Id appId){
        try{
            List <genesis__Applications__c> appList = [SELECT Id,
                                                            Date_Of_Most_Recent_Conduct_Issue__c
                                                        FROM genesis__Applications__c
                                                        WHERE Id  =: appId];
            
            List <clcommon__Party__c> partyList = [SELECT Id,
                                                        Date_of_most_recent_conduct_issue__c,
                                                        genesis__Application__c
                                                    FROM clcommon__Party__c
                                                    WHERE genesis__Application__c = : appId
                                                    ORDER BY Date_of_most_recent_conduct_issue__c ASC NULLS FIRST];
            if(appList.size() > 0){
                for(genesis__Applications__c eachApp : appList){
                    eachApp.Date_Of_Most_Recent_Conduct_Issue__c = NULL;
                    for(clcommon__Party__c eachParty : partyList){
                        if(eachParty.genesis__Application__c == eachApp.id){
                            if(eachParty.Date_of_most_recent_conduct_issue__c != NULL){
                                eachApp.Date_Of_Most_Recent_Conduct_Issue__c = eachParty.Date_of_most_recent_conduct_issue__c;
                            }
                        }
                    }
                }
                Database.update(appList,false);
            }
            
        }catch(Exception exe){
            GenericUtility.insertLog('UpdateApplicationDateValue.updateApplication', exe);
             return ConstantValues.GENERAL_ERROR;

        }
        return ConstantValues.SUCCESS;
    }
}