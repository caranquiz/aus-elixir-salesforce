/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class checks across all parties' Most Recent Credit Event Date 
                and updates the Most Recent Credit Event date in application
Development Date : 13/05/2021
Last Modified Date : 13/05/2021
****************************************************************************************************/
global with sharing  class UpdateMostRecentCreditEventInApplication {
    //Method used for updating the most recent conduct issue date in applications
    Webservice static String updateMostRecentCreditEvent(Id appId){
        try{
            List <genesis__Applications__c> appList = [SELECT Id,
                                                            Date_Of_Most_Recent_Credit_Event__c
                                                        FROM genesis__Applications__c
                                                        WHERE Id = : appId];
            
            List <clcommon__Party__c> partyList = [SELECT Id,
                                                        Date_of_Most_Recent_Credit_Event__c,
                                                        genesis__Application__c
                                                    FROM clcommon__Party__c
                                                    WHERE genesis__Application__c = : appId
                                                    ORDER BY Date_of_Most_Recent_Credit_Event__c ASC NULLS FIRST];
            if(appList.size() > 0){
                for(genesis__Applications__c eachApp : appList){
                    eachApp.Date_Of_Most_Recent_Credit_Event__c = NULL;
                    for(clcommon__Party__c eachParty : partyList){
                        if(eachParty.genesis__Application__c == eachApp.id){
                            if(eachParty.Date_of_Most_Recent_Credit_Event__c != NULL){
                                eachApp.Date_Of_Most_Recent_Credit_Event__c = eachParty.Date_of_Most_Recent_Credit_Event__c;
                            }
                        }
                    }
                }
                Database.update(appList,false);
            }
            
        }catch(Exception exe){
            GenericUtility.insertLog('UpdateApplicationCreditValues.updateApplicationCreditEvent', exe);
            return ConstantValues.GENERAL_ERROR;

        }
        return ConstantValues.SUCCESS;
    }
}