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
        if(Test.isRunningTest() == true){
          return Database.getQueryLocator(
            [
              SELECT Id
              FROM genesis__Applications__c
              WHERE genesis__Status__c NOT IN (:'Declined',:'Cancelled')
            ]
          );
        }
        else{
          return Database.getQueryLocator(
            [
              SELECT Id
              FROM genesis__Applications__c
              WHERE CreatedDate  <= 2021-04-23T00:00:00Z
              AND genesis__Status__c NOT IN (:'Declined',:'Cancelled')
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
        }
      }
      catch(Exception ex){
        GenericUtility.insertLog('DocumentCategoryCreationBatch', ex);
      }
    }
    global void finish(Database.BatchableContext bc) {
    }
  }