/**********************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : SkuidValuesUpdateHelperTest */
/* Created Date         : 07/01/2021 */
/* Developed By         : Rameswari Barman */
/* Description          : This test class gives coverage to SkuidValuesUpdateHelper apex class. */
/* Last Modified Date   : 07/01/2021 */
/* Last Modified By     : Rameswari Barman*/
/*********************************************************************************************************/

@isTest
private class SkuidValuesUpdateHelperTest {
  @TestSetup
  static void initialize() {
    clcommon__Legal_Entity__c legalEntity = GenericUtilityTestHelper.returnLegalEntity();
    System.AssertNotEquals(
      legalEntity.Id,
      null,
      'Legal Entity inserted successfully.'
    );
    //Insert Dummy Account
    account dummyClientAccount = GenericUtilityTestHelper.insertDummyAccount();
    System.AssertNotEquals(
      dummyClientAccount.Id,
      null,
      'Account inserted successfully.'
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
    //Inserting Borrower Party
    clcommon__Party__c party = GenericUtilityTestHelper.createBorowerParty(
      borrowerAccount,
      partyType.Id,
      app.Id
    );
    System.AssertNotEquals(
      party.Id,
      null,
      'Collateral inserted successfully!'
    );
    //Insert Application Collaterals
    genesis__Application_Collateral__c appCollateral = GenericUtilityTestHelper.returnAppCollateral(
      app.Id,
      borrowerAccount.Id
    );
    System.AssertNotEquals(
      appCollateral.Id,
      null,
      'Collateral inserted successfully!'
    );
    QBEpostCode__c qbe = GenericUtilityTestHelper.insertQBEPostCode();
    System.AssertNotEquals(
      qbe.Id,
      null,
      'QBE inserted successfully!'
    );
    S_P_Postcode__c sAndP = GenericUtilityTestHelper.insertSAndPPostCode();
    System.AssertNotEquals(
      sAndP.Id,
      null,
      'S&P postcode inserted successfully!'
    );
  }
  @isTest
  static void locationValuesTest() {
    List<genesis__Applications__c> appList = [
      SELECT id
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assertEquals(appList.size(), 1, 'Application is present.');
    Test.startTest();
    SkuidValuesUpdateHelper.updateLocationValues(null);
    SkuidValuesUpdateHelper.updateLocationValues(appList[0].Id);
    Test.stopTest();
  }
  @isTest
  static void mortgageValuesTest() {
    List<genesis__Applications__c> appList = [
      SELECT id
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assertEquals(appList.size(), 1, 'Application is present.');
    Test.startTest();
    SkuidValuesUpdateHelper.updateMortgagorName(null);
    SkuidValuesUpdateHelper.updateMortgagorName(appList[0].Id);
    Test.stopTest();
  }
  @isTest
  static void firstPAymentDateTest() {
    List<genesis__Applications__c> appList = [
      SELECT id
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assertEquals(appList.size(), 1, 'Application is present.');
    Test.startTest();
    SkuidValuesUpdateHelper.updateFirstPaymentDate(null);
    SkuidValuesUpdateHelper.updateFirstPaymentDate(appList[0].Id);
    Test.stopTest();
  }
}