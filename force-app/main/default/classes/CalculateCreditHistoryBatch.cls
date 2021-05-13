/**************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Rameswari Barman
Development Date : 13/05/2021
Last Modified By : Rameswari Barman
Last Modified Date : 13/05/2021
Description : This class is used to update existing parties' Date of most credit event value in prod
***************************************************************************/
global class CalculateCreditHistoryBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
          [
            SELECT Id,
            Legal_Entity_Type__c,
            Date_of_Most_Recent_Credit_Event__c 
            FROM clcommon__Party__c 
          ]
        );
    }
    global void execute(Database.BatchableContext bc, List<clcommon__Party__c> scope) {
      try{
            if (scope != null && !scope.isEmpty()) {
                for(clcommon__Party__c eachParty : scope){
                    CalculateCreditHistoryValues.calculateValues(eachParty.Id);
                }
            }
      }
      catch(Exception ex){
        GenericUtility.insertLog('CreditHistoryUpdateBatch', ex);
      }
    }
    global void finish(Database.BatchableContext bc) {
    }
}