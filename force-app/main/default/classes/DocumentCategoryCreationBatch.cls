/**************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Rameswari Barman
Development Date : 23/04/2021
Last Modified By : Rameswari Barman
Last Modified Date : 23/04/2021
Description : This class is used to make Document categories 
by assigning applications in small chunks so that governer limits are not met
***************************************************************************/
global class DocumentCategoryCreationBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
      DateTime lastDocCreatedDate = Date.newInstance(Integer.valueOf(Label.DocumentCreationLastDate.split('-').get(2)),Integer.valueOf(Label.DocumentCreationLastDate.split('-').get(1)),Integer.valueOf(Label.DocumentCreationLastDate.split('-').get(0)));
      List <String> validStatusList = System.label.DocumentCreationStatus.split(',');
      if(Test.isRunningTest() == true){
        return Database.getQueryLocator(
          [
            SELECT Id
            FROM genesis__Applications__c
            WHERE genesis__Status__c IN: validStatusList
          ]
        );
      }
      else{
        return Database.getQueryLocator(
          [
            SELECT Id
            FROM genesis__Applications__c
            WHERE CreatedDate  <: lastDocCreatedDate
            AND genesis__Status__c IN: validStatusList
          ]
        );
      }
    }
    global void execute(Database.BatchableContext bc, List<genesis__Applications__c> scope) {
      try{
        if (scope != null && !scope.isEmpty()) {
          CreateDocumentCategories.createLoanLevelDocFolders(scope);
          CreateDocumentCategories.createReviewDocFolders(scope);
          CreateDocumentCategories.createSecurityDocFolders(scope);
          CreateDocumentCategories.createpartyDocFolders(scope);
          CreateDocumentCategories.createIndividualEmpPartyDocFolders(scope);
          CreateDocumentCategories.createIndentityDocFolders(scope);
          CreateDocumentCategories.createIndividualEmploymentSubFolders(scope);
          CreateDocumentCategories.createNonIndividualEmpIncomeDocFolders(scope);
          CreateDocumentCategories.createHouseholdPartyDocFolders(scope);
        }
      }
      catch(Exception ex){
        GenericUtility.insertLog('DocumentCategoryCreationBatch', ex);
      }
    }
    global void finish(Database.BatchableContext bc) {
    }
  }