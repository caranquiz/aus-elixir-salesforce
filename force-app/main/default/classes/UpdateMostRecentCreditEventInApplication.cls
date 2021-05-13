public with sharing  class UpdateMostRecentCreditEventInApplication {
	@InvocableMethod(
    label='Update Date Of Most Recent Credit Event'
    description='Updates Date Of Most Recent Credit Event value on Application'
  	)
    public static void updateMostRecentCreditEvent(List<Id> appIdList){
        try{
            List <genesis__Applications__c> appList = [SELECT Id,
                                                            Date_Of_Most_Recent_Credit_Event__c
                                                        FROM genesis__Applications__c
                                                        WHERE Id IN : appIdList];
            
            List <clcommon__Party__c> partyList = [SELECT Id,
                                                        Date_of_Most_Recent_Credit_Event__c,
                                                        genesis__Application__c
                                                        FROM clcommon__Party__c
                                                        WHERE genesis__Application__c IN : appIdList
                                                        ORDER BY Date_of_Most_Recent_Credit_Event__c ASC NULLS FIRST];
            if(partyList.size() > 0){
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
            
        }catch(Exception e){
            GenericUtility.insertLog('UpdateApplicationCreditValues.updateApplicationCreditEvent', e);
        }
    }
}