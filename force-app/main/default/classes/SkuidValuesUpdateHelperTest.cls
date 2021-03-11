/**********************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : SkuidValuesUpdateHelperTest */
/* Created Date         : 07/01/2021 */
/* Developed By         : Rameswari Barman */
/* Description          : This test class gives coverage to SkuidValuesUpdateHelper apex class. */
/* Last Modified Date   : 11/03/2021 */
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
      'Individual Legal Entity inserted successfully.'
    );
    clcommon__Legal_Entity__c companyLegalEntity = GenericUtilityTestHelper.returnCompanyLegalEntity();
    System.AssertNotEquals(
      companyLegalEntity.Id,
      null,
      'Company Legal Entity inserted successfully.'
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
    //Inserting Dummy Contact
    Contact borrowerContact = GenericUtilityTestHelper.insertDummyContact(
      borrowerAccount
    );
    System.AssertNotEquals(
      borrowerContact.Id,
      null,
      'Borrower Contact inserted successfully.'
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
    clcommon__Party_Type__c partyType2 = GenericUtilityTestHelper.insertPartyType(
      'Guarantor'
    );
    System.assertNotEquals(
      partyType2.Id,
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
      'Party inserted successfully!'
    );
    //Inserting Attachment
    Attachment attach =  GenericUtilityTestHelper.createAttachment(
      party.Id,'Sample'
    );
    System.AssertNotEquals(
      attach.Id,
      null,
      'Attachment inserted successfully!'
    );
    //Inserting Document Category
    clcommon__Document_Category__c docCategory = GenericUtilityTestHelper.createDocumentCategory(
      app.Id,
      'Identity Documents',
      borrowerAccount.Id

    );
    System.AssertNotEquals(
      docCategory.Id,
      null,
      'Document Category inserted successfully!'
    );
    //Inserting Guarantor Party
    clcommon__Party__c guarantorParty = GenericUtilityTestHelper.createBorowerParty(
      borrowerAccount,
      partyType2.Id,
      app.Id
    );
    System.AssertNotEquals(
      guarantorParty.Id,
      null,
      'Party inserted successfully!'
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
    List <RecordType> recordTypeList = [SELECT id,
                                          name,
                                          sobjectType,
                                          DeveloperName 
                                        FROM RecordType 
                                        WHERE sobjectType = 'genesis__Employment_Information__c' 
                                        AND DeveloperName='Self_Employed'];
    System.assertEquals(recordTypeList.size(),1,'Record Type inserted successfully!');                                    
    genesis__Employment_Information__c employment = GenericUtilityTestHelper.createEmploymentInformation(
      recordTypeList[0].Id,
      party.Id
    );  
    System.assertEquals(employment.Id != null,
      true,
      'Employment for Borrower inserted successfully!'
    );         
    genesis__Employment_Information__c employmentInformation = GenericUtilityTestHelper.createEmploymentInformation(
      recordTypeList[0].Id,
      guarantorParty.Id
    ); 
    System.assertEquals(employmentInformation.Id != null,
      true,
      'Employment for Borrower inserted successfully!'
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
  static void mortgageValuesTest2() {
    List<genesis__Applications__c> appList = [
      SELECT id
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assertEquals(appList.size(), 1, 'Application is present.');
    List <clcommon__Party__c> partyList = [
      SELECT Id,
        genesis__Application__c,
        Trust_Structure__c
      FROM clcommon__Party__c
      WHERE genesis__Application__c =: appList[0].Id
      AND Party_Type_Name__c = 'Borrower'];
    System.assertEquals(appList.size(), 1, 'Borrower Party is present.');  
    partyList[0].Trust_Structure__c = 'SMSF';
    update partyList;
    Test.startTest();
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
  @isTest
  static void updateEmploymentDetailsIndividualTest() {
    List<genesis__Applications__c> appList = [
      SELECT id
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assertEquals(appList.size(), 1, 'Application is present.');
    List<clcommon__Legal_Entity__c> legalEntityList = [
      SELECT Id
      FROM clcommon__Legal_Entity__c
      WHERE Name = 'Individual'];
    System.assertEquals(legalEntityList.size(), 1, 'Legal Entity is present.');
    appList[0].Legal_Entity__c = legalEntityList[0].Id;
    update appList;
    Test.startTest();
    SkuidValuesUpdateHelper.updateEmploymentTypeMonthsSelfEmployed(null);
    SkuidValuesUpdateHelper.updateEmploymentTypeMonthsSelfEmployed(appList[0].Id);
    Test.stopTest();
  }
  @isTest
  static void updateEmploymentDetailsCompanyTest() {
    List<genesis__Applications__c> appList = [
      SELECT id
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assertEquals(appList.size(), 1, 'Application is present.');
    List<clcommon__Legal_Entity__c> legalEntityList = [
      SELECT Id
      FROM clcommon__Legal_Entity__c
      WHERE Name = 'Company'];
    System.assertEquals(legalEntityList.size(), 1, 'Legal Entity is present.');
    appList[0].Legal_Entity__c = legalEntityList[0].Id;
    update appList;
    Test.startTest();
    SkuidValuesUpdateHelper.updateEmploymentTypeMonthsSelfEmployed(null);
    SkuidValuesUpdateHelper.updateEmploymentTypeMonthsSelfEmployed(appList[0].Id);
    Test.stopTest();
  }
  @isTest
  static void updateLoanPartyDetailsTest() {
    List<genesis__Applications__c> appList = [
      SELECT id
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assertEquals(appList.size(), 1, 'Application is present.');
    List <clcommon__Party__c> partyList = [
      SELECT Id,
        genesis__Application__c,
        clcommon__Contact__c
      FROM clcommon__Party__c
      WHERE genesis__Application__c =: appList[0].Id
      AND Party_Type_Name__c = 'Borrower'];
    System.assertEquals(appList.size(), 1, 'Borrower Party is present.');  
    List<Contact> contactList = [
      SELECT id
      FROM Contact
      LIMIT 1
    ];
    System.assertEquals(contactList.size(), 1, 'Contact is present.');
    partyList[0].clcommon__Contact__c = contactList[0].Id;
    update partyList;
    Test.startTest();
    SkuidValuesUpdateHelper.updateLoanPartyDetails(null);
    SkuidValuesUpdateHelper.updateLoanPartyDetails(appList[0].Id);
    Test.stopTest();
  }
  @isTest
  static void categoryAttachmentCheckAndCreationTest() {
    List<Attachment> attList = [
      SELECT Id
      FROM Attachment
      LIMIT 1
    ];
    System.assertEquals(attList.size(), 1, 'Attachment is present.');
    List <Id> attachmentIdList = new List<Id>();
    for(Attachment att : attList){
      attachmentIdList.add(att.Id);
    }
    System.assertEquals(attachmentIdList.size(), 1, 'Attachment Id verified.');
    List <clcommon__Document_Category__c> docCategoryList = [
      SELECT Id from clcommon__Document_Category__c limit 1
    ];
    System.assertEquals(docCategoryList.size(), 1, 'Document Category is present.');
    Test.startTest();
    CategoryAttachmentUtility.categoryAttachmentCheckAndCreation(docCategoryList[0].Id,attachmentIdList);
    CategoryAttachmentUtility.deleteAttachment(attachmentIdList[0]);
    Test.stopTest();
  }
  @isTest
  static void categoryAttachmentCheckAndCreationBlankTest() {
    List<Attachment> attList = [
      SELECT Id
      FROM Attachment
      LIMIT 1
    ];
    System.assertEquals(attList.size(), 1, 'Attachment is present.');
    List <Id> attachmentIdList = new List<Id>();
    for(Attachment att : attList){
      attachmentIdList.add(att.Id);
    }
    System.assertEquals(attachmentIdList.size(), 1, 'Attachment Id verified.');
    List <clcommon__Document_Category__c> docCategoryList = [
      SELECT Id from clcommon__Document_Category__c limit 1
    ];
    System.assertEquals(docCategoryList.size(), 1, 'Document Category is present.');
    Test.startTest();
    CategoryAttachmentUtility.categoryAttachmentCheckAndCreation(null,attachmentIdList);
    CategoryAttachmentUtility.categoryAttachmentCheckAndCreation(docCategoryList[0].Id,null);
    CategoryAttachmentUtility.deleteAttachment(null);
    Test.stopTest();
  }
}