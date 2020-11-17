/*******************************************************************************************************************
  Description : This is the test class for EquifaxOrgIdSearchAdapter class.
  Testing Scenario 1  : (testMethod1) This method tests EquifaxOrgIdSearchAdapter class's generateRequestBody method with valid
  initialized data.
  Testing Scenario 2  : (testMethod2) This method tests EquifaxOrgIdSearchAdapter class's generateRequestBody method with no
  and blank initialized data.
  Testing Scenario 3  : (testMethod3) This method tests EquifaxOrgIdSearchAdapter class's generateRequestBody method with no
  Custom Settings Credentials data.
  Company: Cloudkaptan Consultancy Services Pvt. Ltd.
  Author: Pratik Agarwal
  Development Date : 2/09/2020
  Last Modified Date : 14/10/2020  
*******************************************************************************************************************/

@isTest
public class EquifaxOrgIdSearchAdapterTest {
  @TestSetup
  static void setup() {
    //Inserting Credentials custom settings
    EquifaxOrdIdSearch__c equifaxOrgIdSearchObj = GenericUtilityTestHelper.createCustomSettingCreds(
      'A8LJ9999',
      'TS'
    );
    System.assertNotEquals(
      equifaxOrgIdSearchObj.Id,
      null,
      'Custom Setting not inserted successfully'
    );
    //Inserting Account for Party
    Account acc = GenericUtilityTestHelper.createAccount();
    System.assertNotEquals(acc.Id, null, 'Account not inserted successfully');
    //Inserting Party
    clcommon__Party__c party = GenericUtilityTestHelper.createParty(acc);
    System.assertNotEquals(party.Id, null, 'Party not inserted');
  }

  @isTest
  static void testMethod1() {
    Map<String, Object> filledInRequestMap = new Map<String, Object>();
    Map<String, Object> tempMap = new Map<String, Object>();
    List<Map<String, Object>> equifaxCredList = new List<Map<String, Object>>();
    List<Map<String, Object>> partyList = new List<Map<String, Object>>();
    Map<String, Object> partyMap = new Map<String, Object>();
    clcommon__Party__c party = [
      SELECT Id, ABN_Company_Name__c, Name
      FROM clcommon__Party__c
      WHERE ABN_Company_Name__c = 'Llloyds'
    ];
    EquifaxOrdIdSearch__c equifaxOrgIdSearchObj = EquifaxOrdIdSearch__c.getInstance();
    StaticResource staticResource = [
      SELECT Id, Name, Body
      FROM StaticResource
      WHERE Name = :ConstantValues.EQUIFAX_XML_BODY
    ];
    System.assertNotEquals(
      staticResource.Id,
      null,
      'Static Resource not found!'
    );
    //Mapping data for forming request with a valid data
    partyMap.put('name', party.Name);
    partyList.add(partyMap);

    tempMap.put(
      'subscriberIdentifier',
      equifaxOrgIdSearchObj.Subscriber_Identifier__c
    );
    tempMap.put('security', equifaxOrgIdSearchObj.Security__c);
    equifaxCredList.add(tempMap);

    filledInRequestMap.put(
      ConstantValues.EQUIFAX_ACN_NUMBER,
      ConstantValues.ABN_SEARCH_NUMBER
    );
    filledInRequestMap.put(
      ConstantValues.EQUIFAX_XML_REQUEST_BODY,
      staticResource.Body.toString()
    );
    filledInRequestMap.put('credentials', equifaxCredList);
    filledInRequestMap.put(ConstantValues.PARTY_INFO, partyList);

    //api configuration
    intframework.IntegrationAPIConfiguration apiConfig = new intframework.IntegrationAPIConfiguration();
    apiConfig.httpMethod = ConstantValues.HTTP_METHOD;
    apiConfig.requestTimeout = ConstantValues.REQUEST_TIMEOUT;
    apiConfig.apiNamedCredential = ConstantValues.NAME_NAMED_CREDENTIAL;

    EquifaxOrgIdSearchAdapter abnAdapter = new EquifaxOrgIdSearchAdapter();
    abnAdapter.setApiConfiguration(apiConfig);

    Test.startTest();
    String httpReq = abnAdapter.generateRequestBody(filledInRequestMap);
    System.assert(httpReq != null, 'BaseIntegrationRequest is null');
    Test.stopTest();
  }

  @isTest
  static void testMethod2() {
    Map<String, Object> filledInRequestMap = new Map<String, Object>();
    EquifaxOrgIdSearchAdapter abnAdapter = new EquifaxOrgIdSearchAdapter();

    Test.startTest();
    String httpReq = abnAdapter.generateRequestBody(filledInRequestMap);
    System.assert(httpReq == null, 'BaseIntegrationRequest is not null');
    Test.stopTest();
  }
  @isTest
  static void testMethod3() {
    Map<String, Object> filledInRequestMap = new Map<String, Object>();
    List<Map<String, Object>> partyList = new List<Map<String, Object>>();
    Map<String, Object> partyMap = new Map<String, Object>();
    clcommon__Party__c party = [
      SELECT Id, ABN_Company_Name__c, Name
      FROM clcommon__Party__c
      WHERE ABN_Company_Name__c = 'Llloyds'
    ];
    StaticResource staticResource = [
      SELECT Id, Name, Body
      FROM StaticResource
      WHERE Name = :ConstantValues.EQUIFAX_XML_BODY
    ];
    System.assertNotEquals(
      staticResource.Id,
      null,
      'Static Resource not found!'
    );
    //Mapping data for forming request with a valid data
    partyMap.put('name', party.Name);
    partyList.add(partyMap);

    filledInRequestMap.put(
      ConstantValues.EQUIFAX_ACN_NUMBER,
      ConstantValues.ABN_SEARCH_NUMBER
    );
    filledInRequestMap.put(
      ConstantValues.EQUIFAX_XML_REQUEST_BODY,
      staticResource.Body.toString()
    );
    filledInRequestMap.put(ConstantValues.PARTY_INFO, partyList);

    //api configuration
    intframework.IntegrationAPIConfiguration apiConfig = new intframework.IntegrationAPIConfiguration();
    apiConfig.httpMethod = ConstantValues.HTTP_METHOD;
    apiConfig.requestTimeout = ConstantValues.REQUEST_TIMEOUT;
    apiConfig.apiNamedCredential = ConstantValues.NAME_NAMED_CREDENTIAL;

    EquifaxOrgIdSearchAdapter abnAdapter = new EquifaxOrgIdSearchAdapter();
    abnAdapter.setApiConfiguration(apiConfig);

    Test.startTest();
    String httpReq = abnAdapter.generateRequestBody(filledInRequestMap);
    System.assert(httpReq == null, 'BaseIntegrationRequest is not null');
    Test.stopTest();
  }
}
