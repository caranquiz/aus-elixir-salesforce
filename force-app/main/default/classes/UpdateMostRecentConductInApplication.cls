public with sharing class UpdateMostRecentConductInApplication {
	@InvocableMethod(
    label='Update Date Of Most Recent Conduct Issue'
    description='Updates Date Of Most Recent Conduct Issue value on Application'
  	)
    public static void updateMostRecentConductIssueDate(List<Id> appIdList){
        try{
            List <genesis__Applications__c> appList = [SELECT Id,
                                                            Date_Of_Most_Recent_Conduct_Issue__c
                                                        FROM genesis__Applications__c
                                                        WHERE Id IN : appIdList];
            
            List <clcommon__Party__c> partyList = [SELECT Id,
                                                        Date_of_most_recent_conduct_issue__c,
                                                        genesis__Application__c
                                                        FROM clcommon__Party__c
                                                        WHERE genesis__Application__c IN : appIdList
                                                        ORDER BY Date_of_most_recent_conduct_issue__c ASC NULLS FIRST];
            if(partyList.size() > 0){
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
            
        }catch(Exception e){
            GenericUtility.insertLog('UpdateApplicationDateValue.updateApplication', e);
        }
    }
}