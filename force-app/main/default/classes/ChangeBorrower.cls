/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Rameswari Barman
Development Date : 14/01/2021
Last Modified By : Rameswari Barman
Last Modified Date : 14/01/2021
Description : This class helps in changing the borrower of an application.
                As this class is called through Skuid - the party types of the existing Borrower of the application is changed to Guarantor 
                and the selected guarantor account's party type is changed to borrower
***********************************************************************************************************************************************************/

global with sharing class ChangeBorrower {
  webService static String applicationPartyDetailsWS(
    Id applicationId,
    Id accountId
  ) {
    String returnValue = '',newLegalEntity = '';
    Integer check = 0; //this variable helps in keeping track if the interchange of borrower and guarantor has been made possible or not
    Savepoint sp = Database.setSavepoint();
    try {
      if (String.isBlank(applicationId)) {
        return (ConstantValues.CHECKRULES_APPLICATION_ID_NULL);
      }
      if (String.isBlank(accountId)) {
        return (ConstantValues.provideAccId);
      }
      List<genesis__Applications__c> application = new List<genesis__Applications__c>(
        [
        SELECT ID, genesis__Account__c,Legal_Entity__c 
        FROM genesis__Applications__c
        WHERE Id = :applicationId
        LIMIT 1
        ]
      );
      if (application.size() > 0 == false) {
        return (ConstantValues.NO_APPLICATION);
      }
      //Querying the list of parties attached with the application
      List<clcommon__Party__c> partyList = new List<clcommon__Party__c>(
        [
          SELECT
            id,
            name,
            clcommon__Type__r.name,
            clcommon__Account__c,
            genesis__Application__c,
            clcommon__Account__r.clcommon__Legal_Entity_Type__c
          FROM clcommon__Party__c
          WHERE genesis__Application__r.id = :applicationId
        ]
      );
      List<clcommon__Party_Type__c> guarantorParty = new List<clcommon__Party_Type__c>(
        [
        SELECT Id
        FROM clcommon__Party_Type__c
        WHERE Name = :ConstantValues.GUARANTOR
        LIMIT 1
        ]
      );
      List<clcommon__Party_Type__c> borrowerParty = new List<clcommon__Party_Type__c>(
        [
        SELECT Id
        FROM clcommon__Party_Type__c
        WHERE Name = :ConstantValues.BORROWER
        LIMIT 1
        ]
      );
      if (guarantorParty.size() > 0 && borrowerParty.size() > 0) {
        for (clcommon__Party__c eachParty : partyList) {
          if (eachParty.clcommon__Type__r.name == ConstantValues.BORROWER) {
            ++check; //adds 1 if borower is changed to guarantor
            eachParty.clcommon__Type__c = guarantorParty[0].Id;
          }
          if (String.isBlank(eachParty.clcommon__Account__c) == false && eachParty.clcommon__Account__c == accountId) {
            eachParty.clcommon__Type__c = borrowerParty[0].Id;
            newLegalEntity = eachParty.clcommon__Account__r.clcommon__Legal_Entity_Type__c;
            ++check; //adds 1 if guarantor is changed to borrower
          }
        }
        if (check == 2 && newLegalEntity != '') {
          application[0].genesis__Account__c = accountId;
          application[0].Legal_Entity__c = newLegalEntity;
          if (partyList.size() > 0) {
            Database.update(partyList, false);
          }
          if (application.size() > 0) {
            Database.update(application, false);
          }
          returnValue = ConstantValues.SUCCESS_STATUS;
        } else {
          returnValue = ConstantValues.GENERAL_ERROR;
        }
      } else {
        returnValue = ConstantValues.GENERAL_ERROR;
      }
    } catch (Exception e) {
      Database.rollback(sp);
      GenericUtility.insertLog(ConstantValues.SOMETHING_WENT_WRONG, e);
      returnValue = e.getMessage();
    }
    return returnValue;
  }
}