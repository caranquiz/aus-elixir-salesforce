/*******************************************************************************************************************
  Class Name        : EquifaxEnquiryCalloutTest
  Class Description : This test class mostly covers EquifaxEnquiryCallout class
  Developed By      : Souvik Dey
  Testing Scenario 1  : (testEquifaxApplyIndividual) This method tests Apply Individual API callout by Equifax.
  Testing Scenario 2  : (testEquifaxPreviousEnquiry) This method tests Previous Enquiry API callout by Equifax.
  Testing Scenario 3  : (testOrgIdSearchBatchACN) This method tests OrgId Search Batch by ACN API callout by Equifax.
  Testing Scenario 4  : (testOrgIdSearchBatchABN) This method tests OrgId Search Batch by ABN API callout by Equifax.
  Testing Scenario 4  : (testEquifaxApplyIndividualAdapterWithNCCPStatusNonRegulated) This method tests the adapter
                        class with Exception.
  Last Modified Date  : 17/10/2020
  Last Modified By  : Souvik
********************************************************************************************************************/

@isTest
public class EquifaxEnquiryCalloutTest {
  @TestSetup
  static void initialize() {
    intframework__Integration_Family__c family = GenericUtilityTestHelper.getFamily(
      ConstantValues.EQUIFAX_FAMILY
    );
    // Configuration of Apply Individual API Integration
    intframework__Integration_API_Type__c apiType = GenericUtilityTestHelper.getIntegrationAPIType(
      family.Id,
      'Apply Individual'
    );
    intframework__Integration_Provider__c provider = GenericUtilityTestHelper.getIntegrationProvider(
      family.Id,
      'ApplyIndividual'
    );
    intframework__Integration_Configuration__c config = GenericUtilityTestHelper.getIntegrationConfiguration(
      provider.Id,
      'ApplyIndividual config'
    );
    GenericUtilityTestHelper.getIntegrationAPIConfiguration(
      family.Id,
      apiType.Id,
      provider.Id,
      config.Id,
      'EquifaxApplyIndividualAdapter',
      'POST',
      'EquifaxCredentials',
      '/applyIndividual',
      '{"thirdPartySystem":{"name":"Equifax","dynamicDataParameters":[{"externalField":"addressType"},{"externalField":"relationshipCode"}],"filters":[{"objectAPI":"genesis__Applications__c","objectAlias":"appInfo","fields":[{"externalField":"nccpStatus","fieldAPI":"NCCP_status_list__c"},{"externalField":"loanAmount","fieldAPI":"genesis__Loan_Amount__c"},{"externalField":"appName","fieldAPI":"Name"}],"whereClause":"Id = :appId"},{"objectAPI":"clcommon__Party__c","objectAlias":"partyInfo","fields":[{"externalField":"reference","fieldAPI":"Name"}],"whereClause":"Id = :partyId"},{"objectAPI":"Contact","objectAlias":"conInfo","fields":[{"externalField":"firstName","fieldAPI":"FirstName"},{"externalField":"lastName","fieldAPI":"LastName"},{"externalField":"middleName","fieldAPI":"MiddleName"},{"externalField":"gender","fieldAPI":"Gender__c"},{"externalField":"dob","fieldAPI":"Birthdate"}],"whereClause":"Id = :conId"},{"objectAPI":"clcommon__Address__c","objectAlias":"addressInfo","fields":[{"externalField":"unitNo","fieldAPI":"clcommon__County__c"},{"externalField":"streetNo","fieldAPI":"Street_No__c"},{"externalField":"streetName","fieldAPI":"Street_Name__c"},{"externalField":"streetType","fieldAPI":"Street_Type__c"},{"externalField":"suburb","fieldAPI":"clcommon__City__c"},{"externalField":"state","fieldAPI":"State__c"},{"externalField":"postCode","fieldAPI":"clcommon__Zip_Code__c"},{"externalField":"country","fieldAPI":"clcommon__Country__c"}],"whereClause":"Id = :addressId"}]}}'
    );
    // Configuration of Previous Enquiry API Integration
    apiType = GenericUtilityTestHelper.getIntegrationAPIType(
      family.Id,
      ConstantValues.PREVIOUS_ENQUIRY_API_TYPE
    );
    provider = GenericUtilityTestHelper.getIntegrationProvider(
      family.Id,
      'PreviousEnquiry'
    );
    config = GenericUtilityTestHelper.getIntegrationConfiguration(
      provider.Id,
      'PreviousEnquiry config'
    );
    GenericUtilityTestHelper.getIntegrationAPIConfiguration(
      family.Id,
      apiType.Id,
      provider.Id,
      config.Id,
      'EquifaxPreviousEnquiryAdapter',
      'POST',
      'EquifaxCredentials',
      '/previousEnquiry',
      '{"thirdPartySystem":{"name":"Equifax","dynamicDataParameters":[{"externalField":"enquiryId"},{"externalField":"contentType"},{"externalField":"requestBody"}],"filters":[]}}'
    );
    // Configuration of Organisation Identification API Integration
    family = GenericUtilityTestHelper.getFamily(
      ConstantValues.EQUIFAX_FAMILY_NAME
    );
    apiType = GenericUtilityTestHelper.getIntegrationAPIType(
      family.Id,
      ConstantValues.EQUIFAX_API_TYPE
    );
    provider = GenericUtilityTestHelper.getIntegrationProvider(
      family.Id,
      'Equifax Org Id Search'
    );
    config = GenericUtilityTestHelper.getIntegrationConfiguration(
      provider.Id,
      'Equifax Org Id Search config'
    );
    GenericUtilityTestHelper.getIntegrationAPIConfiguration(
      family.Id,
      apiType.Id,
      provider.Id,
      config.Id,
      'EquifaxOrgIdSearchAdapter',
      'POST',
      'EquifaxOrgIdSearch',
      '/orgIdSearch',
      '{"thirdPartySystem":{"name":"EquifaxOrgIdSearch","dynamicDataParameters":[{"externalField":"equifaxXMLRequestBody"},{"externalField":"abnNumber"}],"filters":[{"objectAPI":"clcommon__Party__c","objectAlias":"partyInfo","fields":[{"externalField":"name","fieldAPI":"Name"}],"whereClause":"Id = :partyId"},{"objectAPI":"EquifaxOrdIdSearch__c","objectAlias":"credentials","fields":[{"externalField":"subscriberIdentifier","fieldAPI":"Subscriber_Identifier__c"},{"externalField":"security","fieldAPI":"Security__c"}],"whereClause":""}]}}'
    );
    GenericUtilityTestHelper.createCustomSettingCreds('A8LJ9999', 'TS');
    List<EquifaxOrdIdSearch__c> equifaxOrgIdSearchObjects = [
      SELECT Id
      FROM EquifaxOrdIdSearch__c
    ];
    System.assertEquals(
      equifaxOrgIdSearchObjects.size(),
      1,
      'Org Id Search record is not inserted'
    );
    Account acctObj = GenericUtilityTestHelper.insertDummyAccount();
    List<Account> acctList = [SELECT Id FROM Account];
    System.assertEquals(acctList.size(), 1, 'Account record is not inserted');
    genesis__Applications__c appObj = GenericUtilityTestHelper.returnApplication(
      acctObj.Id
    );
    appObj.genesis__Loan_Amount__c = 100000;
    appObj.NCCP_status_list__c = 'Regulated';
    update appObj;
    List<genesis__Applications__c> appList = [
      SELECT Id
      FROM genesis__Applications__c
    ];
    System.assertEquals(
      appList.size(),
      1,
      'Application record is not inserted'
    );
    GenericUtilityTestHelper.createParty(acctObj);
    List<clcommon__Party__c> partyList = [SELECT Id FROM clcommon__Party__c];
    System.assertEquals(partyList.size(), 1, 'Party record is not inserted');
    Contact conObj = GenericUtilityTestHelper.insertDummyContact(acctObj);
    conObj.FirstName = 'TEST1';
    conObj.LastName = 'TEST2';
    conObj.Birthdate = Date.newInstance(1998, 9, 21);
    conObj.Gender__c = 'Other';
    update conObj;
    List<Contact> conList = [SELECT Id FROM Contact];
    System.assertEquals(conList.size(), 1, 'Contact record is not inserted');
    GenericUtilityTestHelper.returnAddress();
    List<clcommon__Address__c> addressList = [
      SELECT Id
      FROM clcommon__Address__c
    ];
    System.assertEquals(
      addressList.size(),
      1,
      'Address record is not inserted'
    );
    clcommon__Document_Category__c docCat = new clcommon__Document_Category__c();
    docCat.clcommon__Category_Name__c = ConstantValues.PREV_ENQ_DOC_CAT;
    docCat.clcommon__Account__c = acctObj.Id;
    insert docCat;
    List<clcommon__Document_Category__c> docCatList = [
      SELECT Id
      FROM clcommon__Document_Category__c
    ];
    System.assertEquals(
      docCatList.size(),
      1,
      'Document Category record is not inserted'
    );
    List<intframework__Integration_Family__c> intFamilies = [
      SELECT Id
      FROM intframework__Integration_Family__c
    ];
    System.assertEquals(
      intFamilies.size(),
      2,
      'Integration Family record is not inserted'
    );
    List<intframework__Integration_API_Type__c> intApiTypes = [
      SELECT Id
      FROM intframework__Integration_API_Type__c
    ];
    System.assertEquals(
      intApiTypes.size(),
      3,
      'Integration API Type records are not inserted'
    );
    List<intframework__Integration_Provider__c> intProviders = [
      SELECT Id
      FROM intframework__Integration_Provider__c
    ];
    System.assertEquals(
      intProviders.size(),
      3,
      'Integration Provider records are not inserted'
    );
    List<intframework__Integration_Configuration__c> intConfigs = [
      SELECT Id
      FROM intframework__Integration_Configuration__c
    ];
    System.assertEquals(
      intConfigs.size(),
      3,
      'Integration Configuration records are not inserted'
    );
    List<intframework__Integration_API_Configuration__c> intApiConfigs = [
      SELECT Id,intframework__API_Endpoint__c
      FROM intframework__Integration_API_Configuration__c
    ];
    System.assertEquals(
      intApiConfigs.size(),
      3,
      'Integration API Configuration records are not inserted'
    );
  }
  @isTest
  static void testEquifaxApplyIndividual() {
    List<genesis__Applications__c> appList = [
      SELECT Id
      FROM genesis__Applications__c
    ];
    System.assertEquals(
      appList.size(),
      1,
      'Application record is not inserted'
    );
    List<clcommon__Party__c> partyList = [SELECT Id FROM clcommon__Party__c];
    System.assertEquals(partyList.size(), 1, 'Party record is not inserted');
    List<Contact> conList = [SELECT Id FROM Contact];
    System.assertEquals(conList.size(), 1, 'Contact record is not inserted');
    List<clcommon__Address__c> addressList = [
      SELECT Id
      FROM clcommon__Address__c
    ];
    System.assertEquals(
      addressList.size(),
      1,
      'Address record is not inserted'
    );
    Test.setMock(HttpCalloutMock.class, new Mock());
    Test.startTest();
    String responseString = EquifaxEnquiryCallout.equifaxApplyIndividual(
      appList[0].Id,
      partyList[0].Id,
      conList[0].Id,
      addressList[0].Id
    );
    Test.stopTest();
    List<clcommon__Log__c> logList = [
      SELECT Id, clcommon__Message__c
      FROM clcommon__Log__c
    ];
    System.assertEquals(0, logList.size(), 'Exception occurred');
    System.assertNotEquals(
      ConstantValues.GENERAL_ERROR,
      responseString,
      'Response fetching error'
    );
  }
  @isTest
  static void testEquifaxPreviousEnquiry() {
    List<clcommon__Party__c> partyList = [SELECT Id FROM clcommon__Party__c];
    Test.setMock(HttpCalloutMock.class, new Mock());
    Test.startTest();
    String responseString = EquifaxEnquiryCallout.equifaxPreviousEnquiry(
      '200824-C104B-0009F',
      partyList[0].Id
    );
    Test.stopTest();
    List<clcommon__Log__c> logList = [
      SELECT Id, clcommon__Message__c
      FROM clcommon__Log__c
    ];
    System.assertEquals(0, logList.size(), 'Exception occurred');
    System.assertNotEquals(
      ConstantValues.GENERAL_ERROR,
      responseString,
      'Response fetching error'
    );
  }
  @isTest
  static void testOrgIdSearchBatchACN() {
    List<clcommon__Party__c> partyList = [SELECT Id FROM clcommon__Party__c];
    insert new Current_Directorship__c(
      Org_Id_verified__c = false,
      Party__c = partyList[0].Id,
      ACN__c = '121001911'
    );
    Test.setMock(HttpCalloutMock.class, new Mock());
    Test.startTest();
    Database.executeBatch(new EquifaxOrgIdSearchBatch(), 1);
    Test.stopTest();
    List<clcommon__Log__c> logList = [
      SELECT Id, clcommon__Message__c
      FROM clcommon__Log__c
    ];
    System.assertEquals(0, logList.size(), 'Exception occurred');
  }
  @isTest
  static void testOrgIdSearchBatchABN() {
    List<clcommon__Party__c> partyList = [SELECT Id FROM clcommon__Party__c];
    insert new Current_Directorship__c(
      Org_Id_verified__c = false,
      Party__c = partyList[0].Id,
      ABN__c = '11121001911'
    );
    Test.setMock(HttpCalloutMock.class, new Mock());
    Test.startTest();
    Database.executeBatch(new EquifaxOrgIdSearchBatch(), 1);
    Test.stopTest();
    List<clcommon__Log__c> logList = [
      SELECT Id, clcommon__Message__c
      FROM clcommon__Log__c
    ];
    System.assertEquals(0, logList.size(), 'Exception occurred');
  }
  @isTest
  static void testEquifaxApplyIndividualAdapterWithException() {
    List<genesis__Applications__c> appList = [
      SELECT Id
      FROM genesis__Applications__c
    ];
    Map<String, Object> appData = new Map<String, Object>();
    appData.put('nccpStatus', ConstantValues.NCCP_NON_REGULATED);
    List<Map<String, Object>> appInfo = new List<Map<String, Object>>();
    appInfo.add(appData);
    Map<String, Object> filledInRequestMap = new Map<String, Object>();
    filledInRequestMap.put('appInfo', appInfo);
    EquifaxApplyIndividualAdapter instance = new EquifaxApplyIndividualAdapter();
    Test.startTest();
    instance.generateRequestBody(filledInRequestMap);
    Test.stopTest();
    List<clcommon__Log__c> logList = [SELECT Id FROM clcommon__Log__c];
    System.assertEquals(1, logList.size(), 'Exception log not inserted');
  }
  @isTest
  static void testEquifaxApplyIndividual1() {
    List<genesis__Applications__c> appList = [
      SELECT Id
      FROM genesis__Applications__c
    ];
    System.assertEquals(
      appList.size(),
      1,
      'Application record is not inserted'
    );
    List<clcommon__Party__c> partyList = [SELECT Id FROM clcommon__Party__c];
    System.assertEquals(partyList.size(), 1, 'Party record is not inserted');
    List<Contact> conList = [SELECT Id FROM Contact];
    System.assertEquals(conList.size(), 1, 'Contact record is not inserted');
    List<clcommon__Address__c> addressList = [
      SELECT Id
      FROM clcommon__Address__c
    ];
    System.assertEquals(
      addressList.size(),
      1,
      'Address record is not inserted'
    );

    intframework__Integration_API_Configuration__c api = [
      SELECT ID,intframework__API_Endpoint__c
      FROM intframework__Integration_API_Configuration__c
      WHERE intframework__API_Endpoint__c='/applyIndividual'
    ];
    api.intframework__API_Endpoint__c = '/individualApply2';
    update api;
    System.assertEquals(
      api.intframework__API_Endpoint__c,
      '/individualApply2',
      'Integration API Configuration records are not updated'
    );

    Test.setMock(HttpCalloutMock.class, new Mock());
    Test.startTest();
    String responseString = EquifaxEnquiryCallout.equifaxApplyIndividual(
      appList[0].Id,
      partyList[0].Id,
      conList[0].Id,
      addressList[0].Id
    );
    Test.stopTest();
    List<clcommon__Log__c> logList = [
      SELECT Id, clcommon__Message__c
      FROM clcommon__Log__c
    ];
    System.assertEquals(0, logList.size(), 'Exception occurred');
    System.assertNotEquals(
      ConstantValues.GENERAL_ERROR,
      responseString,
      'Response fetching error'
    );
  }
  @isTest
  static void testEquifaxApplyIndividual2() {
    List<genesis__Applications__c> appList = [
      SELECT Id
      FROM genesis__Applications__c
    ];
    System.assertEquals(
      appList.size(),
      1,
      'Application record is not inserted'
    );
    List<clcommon__Party__c> partyList = [SELECT Id FROM clcommon__Party__c];
    System.assertEquals(partyList.size(), 1, 'Party record is not inserted');
    List<Contact> conList = [SELECT Id FROM Contact];
    System.assertEquals(conList.size(), 1, 'Contact record is not inserted');
    List<clcommon__Address__c> addressList = [
      SELECT Id
      FROM clcommon__Address__c
    ];
    System.assertEquals(
      addressList.size(),
      1,
      'Address record is not inserted'
    );

    intframework__Integration_API_Configuration__c api = [
      SELECT ID,intframework__API_Endpoint__c
      FROM intframework__Integration_API_Configuration__c
      WHERE intframework__API_Endpoint__c='/applyIndividual'
    ];
    api.intframework__API_Endpoint__c = '/individualApply3';
    update api;
    System.assertEquals(
      api.intframework__API_Endpoint__c,
      '/individualApply3',
      'Integration API Configuration records are not updated'
    );

    Test.setMock(HttpCalloutMock.class, new Mock());
    Test.startTest();
    String responseString = EquifaxEnquiryCallout.equifaxApplyIndividual(
      appList[0].Id,
      partyList[0].Id,
      conList[0].Id,
      addressList[0].Id
    );
    Test.stopTest();
    List<clcommon__Log__c> logList = [
      SELECT Id, clcommon__Message__c
      FROM clcommon__Log__c
    ];
    System.assertEquals(0, logList.size(), 'Exception occurred');
    System.assertNotEquals(
      ConstantValues.GENERAL_ERROR,
      responseString,
      'Response fetching error'
    );
  }

  /* Mock class returns response from static resource depending on endpoint being called */
  private class Mock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
      System.debug(
        LoggingLevel.DEBUG,
        'End point for Mock request is ' + req.getEndPoint()
      );
      return getMockResponse(req.getEndpoint(), 200);
    }
  }

  /* method to get mock response from static resource */
  private static HttpResponse getMockResponse(
    String endpoint,
    Integer statusCode
  ) {
    HttpResponse res = new HttpResponse();
    res.setStatusCode(statusCode);
    res.setHeader('Content-Type', 'text/xml');
    res.setStatus('SUCCESS');
    Map<String, String> responseMap = new Map<String, String>();
    List<StaticResource> srList = [
      SELECT Id, Name, Body
      FROM StaticResource
      WHERE
        Name = 'Sample_APPLY_INDIVIDUAL_Response'
        OR Name = 'Sample_PREVIOUS_ENQUIRY_Response'
        OR Name = 'Sample_ORG_ID_Response' 
        OR Name= 'Sample_APPLY_INDIVIDUAL_Response2'
        OR Name= 'Sample_APPLY_INDIVIDUAL_Response3'
    ];
    for (StaticResource each : srList) {
      responseMap.put(each.Name, each.Body.toString());
    }
    System.debug(endpoint);
    if (endpoint.contains('applyIndividual')) {
      res.setBody(responseMap.get('Sample_APPLY_INDIVIDUAL_Response'));
    } else if (endpoint.contains('previousEnquiry')) {
      res.setBody(responseMap.get('Sample_PREVIOUS_ENQUIRY_Response'));
    } else if (endpoint.contains('EquifaxOrgIdSearch')) {
      res.setBody(responseMap.get('Sample_ORG_ID_Response'));
    }else if (endpoint.contains('individualApply2')) {
      res.setBody(responseMap.get('Sample_APPLY_INDIVIDUAL_Response2'));
    }else if (endpoint.contains('individualApply3')) {
      res.setBody(responseMap.get('Sample_APPLY_INDIVIDUAL_Response3'));
    }
    return res;
  }
}