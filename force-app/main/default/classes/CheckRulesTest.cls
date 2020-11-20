/**********************************************************************************************************************************************************
Description : This class the Test class for CheckRules Apex Class.
Scenarios Tested : 1) This method acts as unit testing when the application id is not equal to null and Loan Details tab rules are executed
                   2) This method acts as unit testing when the application id is equal to null
                   3) This method acts as unit testing when the application id is not equal to null and Credit History tab rules are executed 
                   4) This method acts as unit testing when the application id is not equal to null and Settlement tab rules are executed
                   5) This method acts as unit testing when the application id is not equal to null and Securities tab rules are executed
                   6) This method acts as unit testing when the application id is not equal to null and Individual Contact Details tab rules are executed
                   7) This method acts as unit testing when the application id is not equal to null and Non Individual Contact Details tab rules are executed
                   8) This method acts as unit testing when the application id is not equal to null and Individual Employment Information tab rules are executed
                   9) This method acts as unit testing when the application id is not equal to null and Living Expense tab rules are executed
                   10) This method acts as unit testing when the application id is not equal to null and Company Income tab rules are executed
                   11) This method acts as unit testing when the application id is not equal to null and Credit History tab rules are executed
***********************************************************************************************************************************************************/
@isTest
private class CheckRulesTest {
  @testSetup
  static void setup() {
    clcommon__Legal_Entity__c legalEntity = GenericUtilityTestHelper.returnLegalEntity();
    List<clcommon__Legal_Entity__c> legalEntityList = [
      SELECT Id, Name
      FROM clcommon__Legal_Entity__c
      WHERE Name = 'Individual'
      LIMIT 1
    ];
    System.assert(
      legalEntityList[0].Name == 'Individual',
      'Legal Entity was not inserted.'
    );

    Account accountDetails = GenericUtilityTestHelper.returnBorrowerAccount(
      legalEntity.Id
    );
    List<Account> accountDetailsList = [
      SELECT Id, Name
      FROM Account
      WHERE Name = 'Dummy Account'
      LIMIT 1
    ];
    System.assert(
      accountDetailsList[0].Name == 'Dummy Account',
      'Borrower Account was not inserted.'
    );

    clcommon__CL_Product__c clProduct = GenericUtilityTestHelper.returnClProduct();
    List<clcommon__CL_Product__c> clProductList = [
      SELECT Id, clcommon__Product_Name__c
      FROM clcommon__CL_Product__c
      WHERE clcommon__Product_Name__c = 'Residential'
      LIMIT 1
    ];
    System.assert(
      clProductList[0].clcommon__Product_Name__c == 'Residential',
      'CL Product was not inserted.'
    );

    genesis__Applications__c applicationDetails = GenericUtilityTestHelper.insertApplication(
      accountDetails.Id,
      clProduct.Id
    );
    applicationDetails.Risk_grade_list__c = 'Near Prime';
    applicationDetails.Document_Type__c = 'Full Doc';
    applicationDetails.Valuation_Fee_Collected_at_Settlement__c = 'No';
    update applicationDetails;
    List<genesis__Applications__c> applicationDetailsList = [
      SELECT Id, genesis__Loan_Amount__c
      FROM genesis__Applications__c
      WHERE genesis__Loan_Amount__c = 150000
      LIMIT 1
    ];
    System.assert(
      applicationDetailsList[0].genesis__Loan_Amount__c == 150000,
      'Application was not inserted.'
    );

    List<genesis__Rule__c> ruleList = GenericUtilityTestHelper.returnRule(
      applicationDetailsList[0].Id
    );
    List<genesis__Rule__c> getRuleList = [
      SELECT Id, Name
      FROM genesis__Rule__c
      WHERE genesis__Enabled__c = true
    ];
    System.assert(
      ruleList[0].Name == 'Cash Out Purpose Suitable Rule',
      'Rule was not inserted.'
    );

    genesis__Employment_Information__c employmentInfo = GenericUtilityTestHelper.returnEmploymentInformation(
      applicationDetailsList[0].Id
    );
    System.assertNotEquals(
      employmentInfo.Id,
      null,
      'Employment Information has been inserted'
    );

    genesis__Liability__c liability = GenericUtilityTestHelper.returnLiability(
      applicationDetailsList[0].Id
    );
    liability.To_Be_Refinanced__c = TRUE;
    liability.genesis__Name_of_Creditor__c = 'SOME NAME';
    update liability;
    System.assertNotEquals(
      liability.Id,
      null,
      'Liability has been inserted'
    );

    genesis__Income__c income = GenericUtilityTestHelper.returnEmploymentInformation(
      applicationDetailsList[0].Id,
      employmentInfo.Id
    );
    genesis__Application_Collateral__c appCollateral = GenericUtilityTestHelper.returnAppCollateral(
      applicationDetailsList[0].Id,
      accountDetails.Id
    );
    System.AssertNotEquals(
      appCollateral.Id,
      null,
      'Collateral inserted successfully!'
    );

    clcommon__Party__c returnParty = GenericUtilityTestHelper.returnParty(
      applicationDetailsList[0].Id,
      accountDetails.Id
    );
    returnParty.Risk_Grade__c = 'Near Prime';
    returnParty.Document_Type__c = 'Full';
    update returnParty;

    genesis__Asset_Information__c assetInfo = GenericUtilityTestHelper.returnAssetInformation(
        applicationDetailsList[0].Id
    );
    assetInfo.genesis__Asset_Type__c = 'Gifts';
    assetInfo.Address__c = 'XYZ';
    assetInfo.genesis__Market_Value__c = 123000;
    update assetInfo;
    System.AssertNotEquals(
      assetInfo.Id,
      null,
      'Asset Information inserted successfully!'
    );

    List<clcommon__Collateral__c> colList = [
        SELECT Id FROM clcommon__Collateral__c
    ];
    System.assertEquals(colList.size(), 1, 'Collateral not inserted');
    update new clcommon__Collateral__c(
        Id = colList[0].Id,
        Replacement_Type__c = 'Standard',
        Replacement_Value__c = 100000
    );
  }

  //This method acts as unit testing when the application id is not equal to null and Loan Details tab rules are executed
  @isTest
  static void testMethod1() {
    List<genesis__Applications__c> applicationDetailsList = [
      SELECT Id, genesis__Loan_Amount__c
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assert(
      applicationDetailsList[0].genesis__Loan_Amount__c == 150000,
      'Application was not inserted.'
    );

    Test.startTest();
    String returnValue = CheckRules.callCheckRulesWS(
      applicationDetailsList[0].Id,
      'Loan Details'
    );
    Test.stopTest();
    List<Checklist_Detail__c> logList = [SELECT Id, Status__c, Checklist__r.genesis__Rule__r.Name FROM Checklist_Detail__c WHERE Status__c = 'SUCCESS'];
    for(Checklist_Detail__c each : logList) {
        System.debug(each);
System.debug(each.Checklist__r.genesis__Rule__r.Name);
    }
  }

  //This method acts as unit testing when the application id is equal to null
  @isTest
  static void testMethod2() {
    Test.startTest();
    String returnValue = CheckRules.callCheckRulesWS(null, 'Loan Details');
    Test.stopTest();
  }
  @isTest
  //This method acts as unit testing when the application id is not equal to null and Credit History tab rules are executed
  static void testMethod3() {
    List<genesis__Applications__c> applicationDetailsList = [
      SELECT Id, genesis__Loan_Amount__c
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assert(
      applicationDetailsList[0].genesis__Loan_Amount__c == 150000,
      'Application was not inserted.'
    );

    Test.startTest();
    String returnValue = CheckRules.callCheckRulesWS(
      applicationDetailsList[0].Id,
      'Credit History'
    );
    Test.stopTest();
    //System.assertEquals(ConstantValues.Success,returnValue,'Success');
    List<Checklist_Detail__c> logList = [SELECT Id, Status__c, Checklist__r.genesis__Rule__r.Name FROM Checklist_Detail__c WHERE Status__c = 'SUCCESS'];
    for(Checklist_Detail__c each : logList) {
        System.debug(each);
System.debug(each.Checklist__r.genesis__Rule__r.Name);
    }
  }
  @isTest
  //This method acts as unit testing when the application id is not equal to null and Review tab rules are executed
  static void testMethod4() {
    List<genesis__Applications__c> applicationDetailsList = [
      SELECT Id, genesis__Loan_Amount__c
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assert(
      applicationDetailsList[0].genesis__Loan_Amount__c == 150000,
      'Application was not inserted.'
    );

    Test.startTest();
    String returnValue = CheckRules.callCheckRulesWS(
      applicationDetailsList[0].Id,
      ConstantValues.XCEPTION
    );
    Test.stopTest();
    System.assertEquals(ConstantValues.Success, returnValue, 'Success');
    List<Checklist_Detail__c> logList = [SELECT Id, Status__c, Checklist__r.genesis__Rule__r.Name FROM Checklist_Detail__c WHERE Status__c = 'SUCCESS'];
    for(Checklist_Detail__c each : logList) {
        System.debug(each);
System.debug(each.Checklist__r.genesis__Rule__r.Name);
    }
  }
  @isTest
  //This method acts as unit testing when the application id is not equal to null and Securities tab rules are executed
  static void testMethod5() {
    List<genesis__Applications__c> applicationDetailsList = [
      SELECT Id, genesis__Loan_Amount__c
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assert(
      applicationDetailsList[0].genesis__Loan_Amount__c == 150000,
      'Application was not inserted.'
    );

    Test.startTest();
    String returnValue = CheckRules.callCheckRulesWS(
      applicationDetailsList[0].Id,
      'Securities'
    );
    Test.stopTest();
    System.assertEquals(ConstantValues.Success, returnValue, 'Success');
    List<Checklist_Detail__c> logList = [SELECT Id, Status__c, Checklist__r.genesis__Rule__r.Name FROM Checklist_Detail__c WHERE Status__c = 'SUCCESS'];
    for(Checklist_Detail__c each : logList) {
        System.debug(each);
System.debug(each.Checklist__r.genesis__Rule__r.Name);
    }
  }
  @isTest
  //This method acts as unit testing when the application id is not equal to null and Individual Contact Details tab rules are executed
  static void testMethod6() {
    List<genesis__Applications__c> applicationDetailsList = [
      SELECT Id, genesis__Loan_Amount__c
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assert(
      applicationDetailsList[0].genesis__Loan_Amount__c == 150000,
      'Application was not inserted.'
    );

    Test.startTest();
    String returnValue = CheckRules.callCheckRulesWS(
      applicationDetailsList[0].Id,
      'Individual Contact Details'
    );
    Test.stopTest();
    System.assertEquals(ConstantValues.Success, returnValue, 'Success');
    List<Checklist_Detail__c> logList = [SELECT Id, Status__c, Checklist__r.genesis__Rule__r.Name FROM Checklist_Detail__c WHERE Status__c = 'SUCCESS'];
    for(Checklist_Detail__c each : logList) {
        System.debug(each);
System.debug(each.Checklist__r.genesis__Rule__r.Name);
    }
  }
  @isTest
  //This method acts as unit testing when the application id is not equal to null and Non Individual Contact Details tab rules are executed
  static void testMethod7() {
    List<genesis__Applications__c> applicationDetailsList = [
      SELECT Id, genesis__Loan_Amount__c
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assert(
      applicationDetailsList[0].genesis__Loan_Amount__c == 150000,
      'Application was not inserted.'
    );

    Test.startTest();
    String returnValue = CheckRules.callCheckRulesWS(
      applicationDetailsList[0].Id,
      'Non Individual Contact Details'
    );
    Test.stopTest();
    System.assertEquals(ConstantValues.Success, returnValue, 'Success');
    List<Checklist_Detail__c> logList = [SELECT Id, Status__c, Checklist__r.genesis__Rule__r.Name FROM Checklist_Detail__c WHERE Status__c = 'SUCCESS'];
    for(Checklist_Detail__c each : logList) {
        System.debug(each);
System.debug(each.Checklist__r.genesis__Rule__r.Name);
    }
  }
  @isTest
  //This method acts as unit testing when the application id is not equal to null and Individual Employment Information tab rules are executed
  static void testMethod8() {
    List<genesis__Applications__c> applicationDetailsList = [
      SELECT Id, genesis__Loan_Amount__c
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assert(
      applicationDetailsList[0].genesis__Loan_Amount__c == 150000,
      'Application was not inserted.'
    );

    Test.startTest();
    String returnValue = CheckRules.callCheckRulesWS(
      applicationDetailsList[0].Id,
      'Individual Employment Information'
    );
    Test.stopTest();
    System.assertEquals(ConstantValues.Success, returnValue, 'Success');
    List<Checklist_Detail__c> logList = [SELECT Id, Status__c, Checklist__r.genesis__Rule__r.Name FROM Checklist_Detail__c WHERE Status__c = 'SUCCESS'];
    for(Checklist_Detail__c each : logList) {
        System.debug(each);
System.debug(each.Checklist__r.genesis__Rule__r.Name);
    }
  }
  @isTest
  //This method acts as unit testing when the application id is not equal to null and Living Expense tab rules are executed
  static void testMethod9() {
    List<genesis__Applications__c> applicationDetailsList = [
      SELECT Id, genesis__Loan_Amount__c
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assert(
      applicationDetailsList[0].genesis__Loan_Amount__c == 150000,
      'Application was not inserted.'
    );

    Test.startTest();
    String returnValue = CheckRules.callCheckRulesWS(
      applicationDetailsList[0].Id,
      'Living Expense'
    );
    Test.stopTest();
    System.assertEquals(ConstantValues.Success, returnValue, 'Success');
    List<Checklist_Detail__c> logList = [SELECT Id, Status__c, Checklist__r.genesis__Rule__r.Name FROM Checklist_Detail__c WHERE Status__c = 'SUCCESS'];
    for(Checklist_Detail__c each : logList) {
        System.debug(each);
System.debug(each.Checklist__r.genesis__Rule__r.Name);
    }
  }
  @isTest
  //This method acts as unit testing when the application id is not equal to null and Company Income tab rules are executed
  static void testMethod10() {
    List<genesis__Applications__c> applicationDetailsList = [
      SELECT Id, genesis__Loan_Amount__c
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assert(
      applicationDetailsList[0].genesis__Loan_Amount__c == 150000,
      'Application was not inserted.'
    );

    Test.startTest();
    String returnValue = CheckRules.callCheckRulesWS(
      applicationDetailsList[0].Id,
      'Company Income'
    );
    Test.stopTest();
    System.assertEquals(ConstantValues.Success, returnValue, 'Success');
    List<Checklist_Detail__c> logList = [SELECT Id, Status__c, Checklist__r.genesis__Rule__r.Name FROM Checklist_Detail__c WHERE Status__c = 'SUCCESS'];
    for(Checklist_Detail__c each : logList) {
        System.debug(each);
System.debug(each.Checklist__r.genesis__Rule__r.Name);
    }
  }
  @isTest
  //This method acts as unit testing when the application id is not equal to null and Review tab rules are executed
  static void testMethod11() {
    List<genesis__Applications__c> applicationDetailsList = [
      SELECT Id, genesis__Loan_Amount__c
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assert(
      applicationDetailsList[0].genesis__Loan_Amount__c == 150000,
      'Application was not inserted.'
    );

    Test.startTest();
    String returnValue = CheckRules.callCheckRulesWS(
      applicationDetailsList[0].Id,
      ConstantValues.WARNING
    );
    Test.stopTest();
    System.assertEquals(ConstantValues.Success, returnValue, 'Success');
    List<Checklist_Detail__c> logList = [SELECT Id, Status__c, Checklist__r.genesis__Rule__r.Name FROM Checklist_Detail__c WHERE Status__c = 'SUCCESS'];
    for(Checklist_Detail__c each : logList) {
        System.debug(each);
System.debug(each.Checklist__r.genesis__Rule__r.Name);
    }
  }
  @isTest
  //This method acts as unit testing when the application id is not equal to null and Review tab rules are executed
  static void testMethod12() {
    List<genesis__Applications__c> applicationDetailsList = [
      SELECT Id, genesis__Loan_Amount__c
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assert(
      applicationDetailsList[0].genesis__Loan_Amount__c == 150000,
      'Application was not inserted.'
    );

    Test.startTest();
    String returnValue = CheckRules.callCheckRulesWS(
      applicationDetailsList[0].Id,
      ConstantValues.WARNING2
    );
    Test.stopTest();
    System.assertEquals(ConstantValues.Success, returnValue, 'Success');
    List<Checklist_Detail__c> logList = [SELECT Id, Status__c, Checklist__r.genesis__Rule__r.Name FROM Checklist_Detail__c WHERE Status__c = 'SUCCESS'];
    for(Checklist_Detail__c each : logList) {
        System.debug(each);
System.debug(each.Checklist__r.genesis__Rule__r.Name);
    }
  }
  @isTest
  //This method acts as unit testing when the application id is not equal to null and Review tab rules are executed
  static void testMethod13() {
    List<genesis__Applications__c> applicationDetailsList = [
      SELECT Id, genesis__Loan_Amount__c
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assert(
      applicationDetailsList[0].genesis__Loan_Amount__c == 150000,
      'Application was not inserted.'
    );
    List<clcommon__Legal_Entity__c> legalEntityList = [
      SELECT Id
      FROM clcommon__Legal_Entity__c
      LIMIT 1
    ];
    legalEntityList[0].Name = 'Company';
    update legalEntityList;
    List<clcommon__Party__c> partyList = [
      SELECT Id, Legal_Entity_Type__c
      FROM clcommon__Party__c
      LIMIT 1
    ];
    partyList[0].clcommon__Type__c = GenericUtilityTestHelper.insertPartyType(
        ConstantValues.GUARANTOR
      )
      .Id;
    update partyList;
    Test.startTest();
    String returnValue = CheckRules.callCheckRulesWS(
      applicationDetailsList[0].Id,
      ConstantValues.CONDITION
    );
    Test.stopTest();
    System.assertEquals(ConstantValues.Success, returnValue, 'Success');
    List<Checklist_Detail__c> logList = [SELECT Id, Status__c, Checklist__r.genesis__Rule__r.Name FROM Checklist_Detail__c WHERE Status__c = 'SUCCESS'];
    for(Checklist_Detail__c each : logList) {
        System.debug(each);
System.debug(each.Checklist__r.genesis__Rule__r.Name);
    }
  }
  @isTest
  //This method acts as unit testing when the application id is not equal to null and Review tab rules are executed
  static void testMethod14() {
    List<genesis__Applications__c> applicationDetailsList = [
      SELECT Id, genesis__Loan_Amount__c
      FROM genesis__Applications__c
      LIMIT 1
    ];
    System.assert(
      applicationDetailsList[0].genesis__Loan_Amount__c == 150000,
      'Application was not inserted.'
    );
    List<clcommon__Legal_Entity__c> legalEntityList = [
      SELECT Id
      FROM clcommon__Legal_Entity__c
      LIMIT 1
    ];
    legalEntityList[0].Name = 'Company';
    update legalEntityList;
    List<clcommon__Party__c> partyList = [
      SELECT Id
      FROM clcommon__Party__c
      LIMIT 1
    ];
    partyList[0].clcommon__Type__c = GenericUtilityTestHelper.insertPartyType(
        ConstantValues.CO_APPLICANT
      )
      .Id;
    update partyList;
    Test.startTest();
    String returnValue = CheckRules.callCheckRulesWS(
      applicationDetailsList[0].Id,
      ConstantValues.APP_EXCEP
    );
    Test.stopTest();
    System.assertEquals(ConstantValues.Success, returnValue, 'Success');
    List<Checklist_Detail__c> logList = [SELECT Id, Status__c, Checklist__r.genesis__Rule__r.Name FROM Checklist_Detail__c WHERE Status__c = 'SUCCESS'];
    for(Checklist_Detail__c each : logList) {
        System.debug(each);
System.debug(each.Checklist__r.genesis__Rule__r.Name);
    }
  }
  @isTest
  //This method acts as unit testing when the application id is not equal to null and Review tab rules are executed
  static void testMethod15() {
    List<genesis__Applications__c> applicationDetailsList = [
      SELECT Id, genesis__Loan_Amount__c
      FROM genesis__Applications__c
      LIMIT 1
    ];
    Test.startTest();
    String returnValue = CheckRules.callCheckRulesWS(
      applicationDetailsList[0].Id,
      ConstantValues.RECOMMENDED
    );
    Test.stopTest();
    System.assertEquals(ConstantValues.Success, returnValue, 'Success');
    List<Checklist_Detail__c> logList = [SELECT Id, Status__c, Checklist__r.genesis__Rule__r.Name FROM Checklist_Detail__c WHERE Status__c = 'SUCCESS'];
    for(Checklist_Detail__c each : logList) {
        System.debug(each);
System.debug(each.Checklist__r.genesis__Rule__r.Name);
    }
  }
  @isTest
  static void testChecklistDetailsAPIMethods() {
    Test.startTest();
    ChecklistDetailsAPI obj = new ChecklistDetailsAPI();
    obj.evaluateBasedOnDoubleMatchingType((Double) 12.3, '!=', '10.1');
    obj.evaluateBasedOnDoubleMatchingType((Double) 12.3, '<', '10.1');
    obj.evaluateBasedOnDoubleMatchingType((Double) 12.3, '>', '10.1');
    obj.evaluateBasedOnMatchingType('ABC', '==', 'XYZ');
    obj.evaluateBasedOnMatchingType('ABC', 'IN', 'XYZ,ABC');
    obj.evaluateBasedOnMatchingType('LIO', 'NOT IN', 'XYZ,ABC');
    Test.stopTest();
  }
}
