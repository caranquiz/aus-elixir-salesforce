/**********************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : ChangeBorrowerTest */
/* Created Date         : 14/01/2021 */
/* Developed By         : Rameswari Barman */
/* Description          : This test class gives coverage to ChangeBorrower apex class. */
/* Last Modified Date   : 14/01/2021 */
/* Last Modified By     : Rameswari Barman*/
/* Scenarios Tested     : Scenario 1: When null values are passed in place of application Id and to-be borrower party's account Id */
/*                      : Scenario 2: When correct application Id and to-be borrower party's account Id are set*/
/*********************************************************************************************************/

@isTest
private class ChangeBorrowerTest {
  @TestSetup
  static void initialize() {
    clcommon__Legal_Entity__c legalEntity = GenericUtilityTestHelper.returnLegalEntity();
    System.AssertNotEquals(
      legalEntity.Id,
      null,
      'Legal Entity inserted successfully.'
    );

    //Inserting Account
    Account borrowerAccount = GenericUtilityTestHelper.returnBorrowerAccount(
      legalEntity.Id
    );
    System.AssertNotEquals(
      borrowerAccount.Id,
      null,
      'Borrower Account inserted successfully.'
    );
    //Inserting Another Account
    Account guarantorAccount = GenericUtilityTestHelper.returnBorrowerAccount(
      legalEntity.Id
    );
    System.AssertNotEquals(
      guarantorAccount.Id,
      null,
      'Guarantor Account inserted successfully.'
    );
    //Inserting CLProduct
    clcommon__CL_Product__c clProd = GenericUtilityTestHelper.returnClProduct();
    System.assertEquals(
      clProd.clcommon__Product_Name__c,
      'Residential',
      'Product insertion is successful'
    );
    //Insert Application
    genesis__Applications__c app = GenericUtilityTestHelper.insertApplication(
      borrowerAccount.Id,
      clProd.Id
    );
    System.assertNotEquals(
      app.Id,
      null,
      'Origination Application insertion is successful'
    );
    //Insert Borrower Party Type
    clcommon__Party_Type__c partyType = GenericUtilityTestHelper.insertPartyType(
      'Borrower'
    );
    System.assertNotEquals(
      partyType.Id,
      null,
      'Party type insertion is successful'
    );
    //Insert Guarantor Party Type
    clcommon__Party_Type__c guarantorPartyType = GenericUtilityTestHelper.insertPartyType(
      'Guarantor'
    );
    System.assertNotEquals(
      guarantorPartyType.Id,
      null,
      'Party type insertion is successful'
    );
    //Inserting Guarantor Party
    clcommon__Party__c guarantorParty = GenericUtilityTestHelper.createBorowerParty(
      guarantorAccount,
      partyType.Id,
      app.Id
    );
    System.assertNotEquals(
      guarantorParty.Id,
      null,
      'Guarantor party insertion is successful'
    );
    //Inserting Borrower Party
    clcommon__Party__c party = GenericUtilityTestHelper.createBorowerParty(
      borrowerAccount,
      guarantorPartyType.Id,
      app.Id
    );
    System.assertNotEquals(
      party.Id,
      null,
      'Borrower party insertion is successful'
    );
  }
  @isTest
  static void checkForNullValues() {
    List<genesis__Applications__c> appList = [
      SELECT id
      FROM genesis__Applications__c
      LIMIT 1
    ];
    List<Account> accList = [
      SELECT id
      FROM Account
      LIMIT 1
    ];
    System.assertEquals(appList.size(), 1, 'Application is present.');
    System.assertEquals(accList.size(), 1, 'Account is present.');
    Test.startTest();
    ChangeBorrower.applicationPartyDetailsWS(null,null);
    ChangeBorrower.applicationPartyDetailsWS(appList[0].Id,null);
    ChangeBorrower.applicationPartyDetailsWS(null,accList[0].Id);
    Test.stopTest();
  }
  @isTest
  static void testScenario1() {
    List<genesis__Applications__c> appList = [
      SELECT id
      FROM genesis__Applications__c
      LIMIT 1
    ];
    List<Account> accList = [
      SELECT id
      FROM Account
      ORDER BY CreatedDate DESC
    ];
    System.assertEquals(appList.size(), 1, 'Application is present.');
    System.assertEquals(accList.size(), 2, 'Accounts are present.');
    Test.startTest();
    ChangeBorrower.applicationPartyDetailsWS(appList[0].Id,accList[0].Id);
    Test.stopTest();
  }
}