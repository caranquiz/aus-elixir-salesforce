/*******************************************************************************************************************
  Description : This is the test class for SMSFABNNameSearchAdapter class.
  Testing Scenario 1  : (testMethod1) This method tests SMSFABNNameSearchAdapter class's createRequest method with valid
  initialized data.
  Testing Scenario 2  : (testMethod2) This method tests SMSFABNNameSearchAdapter class's createRequest method with no
  and blank initialized data.
  Testing Scenario 3  : (testMethod3) This method tests SMSFABNNameSearchAdapter class's createRequest method with no
  Account name in Party data.
  Testing Scenario 4  : (testMethod4) This method tests SMSFABNNameSearchAdapter class's createRequest method with no
  guid data.
*******************************************************************************************************************/

@isTest
public class SMSFABNNameSearchAdapterTest {
    @TestSetup
    static void setup(){
        ABN_Search_SMSF__c guidInfo = GenericUtilityTestHelper.createCustomSettingGUID(ConstantValues.GUID_VALUE,
        ConstantValues.ACTIVE_FUNDS_ONLY_VALUE,
        ConstantValues.MAX_SEARCH_RESULTS_VALUE);
        System.assertNotEquals(guidInfo,null,'Custom Setting not inserted successfully');
        Account acc = GenericUtilityTestHelper.createAccount();
        System.assertNotEquals(acc,null,'Account not inserted successfully');
        clcommon__Party__c party = GenericUtilityTestHelper.createParty(acc);
        System.assertNotEquals(party,null,'Party not inserted');
    }

    @isTest
    static void testMethod1() {
        Map<String, Object> filledInRequestMap = new Map<String, Object>();
        Map<String, Object> tempMap = new Map<String, Object>();
        List<Map<String, Object>> guidList = new List<Map<String, Object>>();
        List<Map<String, Object>> partyList = new List<Map<String, Object>>();
        Map<String, Object> partyMap = new Map<String, Object>();
        clcommon__Party__c party = [SELECT Id,ABN_Company_Name__c FROM clcommon__Party__c WHERE ABN_Company_Name__c = 'Llloyds'];
        ABN_Search_SMSF__c guidInfo = ABN_Search_SMSF__c.getInstance();

        //Mapping data for forming request with a valid data
        partyMap.put(ConstantValues.ABN_TRUST_NAME,party.ABN_Company_Name__c);
        partyList.add(partyMap);

        tempMap.put(ConstantValues.GUID,guidInfo.GUID__c);
        tempMap.put(ConstantValues.ACTIVE_FUNDS_ONLY,guidInfo.Active_Funds_Only__c);
        tempMap.put(ConstantValues.MAX_SEARCH_RESULTS,guidInfo.Maximum_Search_Results__c);
        guidList.add(tempMap);
        
        filledInRequestMap.put(ConstantValues.ABN_DATA, '');
        filledInRequestMap.put(ConstantValues.GUID_INFO, guidList);
        filledInRequestMap.put(ConstantValues.PARTY_INFO,partyList);

        //api configuration
        intframework.IntegrationAPIConfiguration apiConfig = new intframework.IntegrationAPIConfiguration();
        apiConfig.httpMethod = ConstantValues.HTTP_METHOD;
        apiConfig.requestTimeout = ConstantValues.REQUEST_TIMEOUT;
        apiConfig.apiNamedCredential = ConstantValues.NAME_NAMED_CREDENTIAL;

        SMSFABNNameSearchAdapter abnAdapter = new SMSFABNNameSearchAdapter();
        abnAdapter.setApiConfiguration(apiConfig);

        Test.startTest();
        intframework.BaseIntegrationRequest httpReq = abnAdapter.createRequest(new Map<String, Object>(), filledInRequestMap);
        System.assert(httpReq != null, 'BaseIntegrationRequest is null');
        Test.stopTest();     
    }

    @isTest
    static void testMethod2() {
        Map<String, Object> filledInRequestMap = new Map<String, Object>();
        SMSFABNNameSearchAdapter abnAdapter = new SMSFABNNameSearchAdapter();

        Test.startTest();
        intframework.BaseIntegrationRequest httpReq = abnAdapter.createRequest(new Map<String, Object>(), filledInRequestMap);
        System.assert(httpReq == null, 'BaseIntegrationRequest is not null');
        Test.stopTest();       
    }
    @isTest
    static void testMethod3() {
        Map<String, Object> filledInRequestMap = new Map<String, Object>();
        Map<String, Object> tempMap = new Map<String, Object>();
        List<Map<String, Object>> guidList = new List<Map<String, Object>>();
        ABN_Search_SMSF__c guidInfo = ABN_Search_SMSF__c.getInstance();

        //Mapping data for forming request with a valid data
        tempMap.put(ConstantValues.GUID,guidInfo.GUID__c);
        tempMap.put(ConstantValues.ACTIVE_FUNDS_ONLY,guidInfo.Active_Funds_Only__c);
        tempMap.put(ConstantValues.MAX_SEARCH_RESULTS,guidInfo.Maximum_Search_Results__c);
        guidList.add(tempMap);
        
        filledInRequestMap.put(ConstantValues.ABN_DATA, '');
        filledInRequestMap.put(ConstantValues.GUID_INFO, guidList);

        //api configuration
        intframework.IntegrationAPIConfiguration apiConfig = new intframework.IntegrationAPIConfiguration();
        apiConfig.httpMethod = ConstantValues.HTTP_METHOD;
        apiConfig.requestTimeout = ConstantValues.REQUEST_TIMEOUT;
        apiConfig.apiNamedCredential = ConstantValues.NAME_NAMED_CREDENTIAL;

        SMSFABNNameSearchAdapter abnAdapter = new SMSFABNNameSearchAdapter();
        abnAdapter.setApiConfiguration(apiConfig);

        Test.startTest();
        intframework.BaseIntegrationRequest httpReq = abnAdapter.createRequest(new Map<String, Object>(), filledInRequestMap);
        System.assert(httpReq == null, 'BaseIntegrationRequest is not null');
        Test.stopTest();       
    }
    @isTest
    static void testMethod4() {
        Map<String, Object> filledInRequestMap = new Map<String, Object>();
        List<Map<String, Object>> partyList = new List<Map<String, Object>>();
        Map<String, Object> partyMap = new Map<String, Object>();
        clcommon__Party__c party = [SELECT Id,ABN_Company_Name__c FROM clcommon__Party__c WHERE ABN_Company_Name__c = 'Llloyds'];

        //Mapping data for forming request with a valid data
        partyMap.put(ConstantValues.ABN_TRUST_NAME,party.ABN_Company_Name__c);
        partyList.add(partyMap);

        filledInRequestMap.put(ConstantValues.ABN_DATA, '');
        filledInRequestMap.put(ConstantValues.PARTY_INFO,partyList);

        //api configuration
        intframework.IntegrationAPIConfiguration apiConfig = new intframework.IntegrationAPIConfiguration();
        apiConfig.httpMethod = ConstantValues.HTTP_METHOD;
        apiConfig.requestTimeout = ConstantValues.REQUEST_TIMEOUT;
        apiConfig.apiNamedCredential = ConstantValues.NAME_NAMED_CREDENTIAL;

        SMSFABNNameSearchAdapter abnAdapter = new SMSFABNNameSearchAdapter();
        abnAdapter.setApiConfiguration(apiConfig);

        Test.startTest();
        intframework.BaseIntegrationRequest httpReq = abnAdapter.createRequest(new Map<String, Object>(), filledInRequestMap);
        System.assert(httpReq == null, 'BaseIntegrationRequest is not null');
        Test.stopTest();       
    }
}