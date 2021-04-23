global class DocumentCategoryCreationBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String endDate = System.label.DocumentCreationLastDate;
        DateTime formatedEndDate;
        if(endDate != NULL && endDate != ''){
            formatedEndDate = Datetime.parse(endDate);
        }
        return Database.getQueryLocator(
            [
              SELECT Id
              FROM genesis__Applications__c
              WHERE CreatedDate <= 2021-04-23T00:00:00Z
              AND genesis__Status__c NOT IN (:'Declined',:'Cancelled')
            ]
          );
    }
    global void execute(Database.BatchableContext bc, List<genesis__Applications__c> scope) {
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
    global void finish(Database.BatchableContext bc) {
    }
  }