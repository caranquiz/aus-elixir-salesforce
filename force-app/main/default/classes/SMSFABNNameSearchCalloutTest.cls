/****************************************************************************************************/
/* Description          : This test class mostly covers SMSFABNNameSearchCallout class. */
/* Testing Scenario 1   : (testSearchBySMSFName) This method tests SMSFABNNameSearchCallout class's
 searchBySMSFName method and uses the MOCK response that is configured at the end. */
/* Testing Scenario 2   : (testSearchBySMSFNameWithError) This method tests with a error response
 from the ABNLookup callout of using search by SMSF Trust Name.
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Pratik Agarwal
Development Date : 2/09/2020
Last Modified Date : 14/10/2020
****************************************************************************************************/
@isTest
class SMSFABNNameSearchCalloutTest {
  @TestSetup
  static void makeData() {
    //Inserting GUID custom settings
    ABN_Search_SMSF__c guidInfo = GenericUtilityTestHelper.createCustomSettingGUID(
      ConstantValues.GUID_VALUE,
      ConstantValues.ACTIVE_FUNDS_ONLY_VALUE,
      ConstantValues.MAX_SEARCH_RESULTS_VALUE
    );
    System.assertNotEquals(
      guidInfo.Id,
      null,
      'Custom Setting not inserted successfully'
    );
    //Inserting Account
    Account acc = GenericUtilityTestHelper.createAccount();
    System.assertNotEquals(acc.Id, null, 'Account not inserted successfully');
    //Inserting Party
    clcommon__Party__c party = GenericUtilityTestHelper.createParty(acc);
    System.assertNotEquals(party.Id, null, 'Party not inserted successfully');
    //Inserting Integration Family
    intframework__Integration_Family__c family = GenericUtilityTestHelper.getFamily(
      ConstantValues.FAMILY_NAME
    );
    System.assertNotEquals(family.Id, null, 'Family not inserted successfully');
    //Inserting Integration API Type
    intframework__Integration_API_Type__c apiType = GenericUtilityTestHelper.getIntegrationAPIType(
      family.Id,
      ConstantValues.NAME_API_TYPE
    );
    System.assertNotEquals(
      apiType.Id,
      null,
      'API Type not inserted successfully'
    );
    //Inserting Integration Provider
    intframework__Integration_Provider__c provider = GenericUtilityTestHelper.getIntegrationProvider(
      family.Id,
      ConstantValues.NAME_PROVIDER
    );
    System.assertNotEquals(
      provider.Id,
      null,
      'Provider not inserted successfully'
    );
    //Inserting Integration Configuration
    intframework__Integration_Configuration__c config = GenericUtilityTestHelper.getIntegrationConfiguration(
      provider.Id,
      ConstantValues.NAME_CONFIGURATION
    );
    System.assertNotEquals(
      config.Id,
      null,
      'Configuration not inserted successfully'
    );
    //Inserting API Configuration
    intframework__Integration_API_Configuration__c apiConfig = GenericUtilityTestHelper.getIntegrationAPIConfiguration(
      family.Id,
      apiType.Id,
      provider.Id,
      config.Id,
      ConstantValues.NAME_ADAPTER_CLASS,
      ConstantValues.HTTP_METHOD,
      'ABNSearchSMSF',
      '',
      ConstantValues.NAME_REQUEST_MAPPING
    );
    System.assertNotEquals(
      apiConfig.Id,
      null,
      'API configuration not inserted succesfully'
    );
  }
  /* Mock class returns response from static resource depending on endpoint being called */
  private class Mock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
      return getMockResponse(req.getEndpoint(), 200);
    }
  }

  /* method to get mock response */
  private static HttpResponse getMockResponse(
    String endpoint,
    Integer statusCode
  ) {
    List<StaticResource> srList = [
      SELECT Id, Name, Body
      FROM StaticResource
      WHERE Name = 'ABNNameSearchDummyXML'
    ];
    System.assertEquals(srList.size(), 1, 'Static Resource not found');
    String xml = srList[0].Body.toString();
    HttpResponse res = new HttpResponse();
    res.setStatusCode(statusCode);
    res.setHeader('Content-Type', 'text/xml');
    res.setStatus('SUCCESS');
    if (endpoint.contains('nothing')) {
      res.setBody(
        '<?xml version="1.0" encoding="utf-8"?><SuperFundNamesPayload xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://superfundlookup.gov.au"><Request><Guid>c4726ad0-af04-4d8d-987b-d15966cd1cfd</Guid><Name>^</Name><ActiveFundsOnly>Y</ActiveFundsOnly></Request><Response><DateTimeRetrieved>2020-10-21T04:57:03.8000062+11:00</DateTimeRetrieved><Exception><Code>Search</Code><Description>No records found</Description></Exception></Response></SuperFundNamesPayload>'
      );
    } else {
      res.setBody(xml);
    }
    return res;
  }
  @isTest
  static void testSearchBySMSFName() {
    Test.setMock(HttpCalloutMock.class, new Mock());
    Test.startTest();
    clcommon__Party__c party = [
      SELECT Id
      FROM clcommon__Party__c
      WHERE clcommon__Account__r.Name = 'Llloyds'
    ];
    String responseString = SMSFABNNameSearchCallout.searchBySMSFName(party.Id);
    System.assert(responseString != null, 'ABN Response fetch error');
    Test.stopTest();
    List<clcommon__Log__c> logList = [
      SELECT Id, clcommon__Message__c
      FROM clcommon__Log__c
    ];
    for (clcommon__Log__c each : logList) {
      System.debug(each.clcommon__Message__c);
    }
  }
  @isTest
  static void testSearchBySMSFNameWithError() {
    List<intframework__Integration_API_Configuration__c> intApiConfig = [
      SELECT Id, intframework__Adapter_Class_Name__c
      FROM intframework__Integration_API_Configuration__c
      WHERE
        intframework__Adapter_Class_Name__c = :ConstantValues.NAME_ADAPTER_CLASS
    ];
    System.assertEquals(
      intApiConfig.size(),
      1,
      'Integration API Configuration for Search By ABN insertion error'
    );
    intApiConfig[0].intframework__API_Endpoint__c = 'nothing';
    update intApiConfig;
    Test.setMock(HttpCalloutMock.class, new Mock());
    Test.startTest();
    clcommon__Party__c party = [
      SELECT Id
      FROM clcommon__Party__c
      WHERE clcommon__Account__r.Name = 'Llloyds'
    ];
    String responseString = SMSFABNNameSearchCallout.searchBySMSFName(party.Id);
    System.assert(responseString != null, 'ABN Response fetch error');
    Test.stopTest();
  }
  @isTest
  static void testSearchBySMSFNameWithBlankPartyId() {
    Test.startTest();
    String responseString = SMSFABNNameSearchCallout.searchBySMSFName('');
    Test.stopTest();
    System.assert(
      responseString.contains(ConstantValues.PARTY_ID_EMPTY),
      'ABN Response error'
    );
  }
  @isTest
  static void testSearchBySMSFNameNullResponse() {
    Test.startTest();
    clcommon__Party__c party = [
      SELECT Id
      FROM clcommon__Party__c
      WHERE clcommon__Account__r.Name = 'Llloyds'
    ];
    String responseString = SMSFABNNameSearchCallout.searchBySMSFName(party.Id);
    Test.stopTest();
    System.assert(
      responseString.contains(ConstantValues.GENERAL_EXCEPTION),
      'ABN Response error'
    );
  }
  @isTest
  static void SMSFSearchByABNNameHelperParseWithError() {
    Test.startTest();
    SMSFABNNameSearchHelper parsedResponse = SMSFABNNameSearchHelper.parse(
      '<>'
    );
    Test.stopTest();
    System.assert(parsedResponse == null, 'Response parsing error');
    List<clcommon__Log__c> logList = [SELECT Id FROM clcommon__Log__c];
    System.assert(logList.size() == 1, 'Log insetion error');
  }
}
