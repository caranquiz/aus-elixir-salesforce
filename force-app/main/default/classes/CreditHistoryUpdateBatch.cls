/**************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Rameswari Barman
Development Date : 13/05/2021
Last Modified By : Rameswari Barman
Last Modified Date : 13/05/2021
Description : This class is used to update Most Recent Credit Event for all 
                applications by comparing values from parties
***************************************************************************/
global class CreditHistoryUpdateBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
          [
            SELECT Id
            FROM genesis__Applications__c
          ]
        );
    }
    global void execute(Database.BatchableContext bc, List<genesis__Applications__c> scope) {
      try{
          List <Id> appIdList = new List<Id>();
        if (scope != null && !scope.isEmpty()) {
            for(genesis__Applications__c app : scope){
                appIdList.add(app.Id);
            }
            UpdateMostRecentCreditEventInApplication.updateMostRecentCreditEvent(appIdList);
        }
      }
      catch(Exception ex){
        GenericUtility.insertLog('CreditHistoryUpdateBatch', ex);
      }
    }
    global void finish(Database.BatchableContext bc) {
    }
  }