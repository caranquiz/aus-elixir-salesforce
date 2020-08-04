/******************************************************************************************************************
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
        Account acc = new Account();
        acc.Name = 'Llloyds';
        insert acc;
        System.assertNotEquals(acc,null,'Account not inserted successfully');
        clcommon__Party__c party = new clcommon__Party__c();
        party.clcommon__Account__c = acc.Id;
        party.ABN_Company_Name__c = 'Llloyds';
        insert party;
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

        //Mapping data for forming request with a valid data
        partyMap.put('name',party.ABN_Company_Name__c);
        partyList.add(partyMap);

        tempMap.put('guid','c4726ad0-af04-4d8d-987b-d15966cd1cfd');
        tempMap.put('activeFundsOnly','Y');
        tempMap.put('maxSearchResults','200');
        guidList.add(tempMap);
        
        filledInRequestMap.put('abndata', '');
        filledInRequestMap.put('guidInfo', guidList);
        filledInRequestMap.put('partyinfo',partyList);

        //api configuration
        intframework.IntegrationAPIConfiguration apiConfig = new intframework.IntegrationAPIConfiguration();
        apiConfig.httpMethod = 'GET';
        apiConfig.requestTimeout = 12000;
        apiConfig.apiNamedCredential = 'https://superfundlookup.gov.au/xmlsearch/SflXmlSearch.asmx/SearchByName201911';

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

        tempMap.put('guid','c4726ad0-af04-4d8d-987b-d15966cd1cfd');
        tempMap.put('activeFundsOnly','Y');
        tempMap.put('maxSearchResults','200');
        guidList.add(tempMap);
        
        filledInRequestMap.put('abndata', '');
        filledInRequestMap.put('guidInfo', guidList);

        //api configuration
        intframework.IntegrationAPIConfiguration apiConfig = new intframework.IntegrationAPIConfiguration();
        apiConfig.httpMethod = 'GET';
        apiConfig.requestTimeout = 12000;
        apiConfig.apiNamedCredential = 'https://superfundlookup.gov.au/xmlsearch/SflXmlSearch.asmx/SearchByName201911';

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
        partyMap.put('name',party.ABN_Company_Name__c);
        partyList.add(partyMap);

        filledInRequestMap.put('abndata', '');
        filledInRequestMap.put('partyinfo',partyList);

        //api configuration
        intframework.IntegrationAPIConfiguration apiConfig = new intframework.IntegrationAPIConfiguration();
        apiConfig.httpMethod = 'GET';
        apiConfig.requestTimeout = 12000;
        apiConfig.apiNamedCredential = 'https://superfundlookup.gov.au/xmlsearch/SflXmlSearch.asmx/SearchByName201911';

        SMSFABNNameSearchAdapter abnAdapter = new SMSFABNNameSearchAdapter();
        abnAdapter.setApiConfiguration(apiConfig);

        Test.startTest();
        intframework.BaseIntegrationRequest httpReq = abnAdapter.createRequest(new Map<String, Object>(), filledInRequestMap);
        System.assert(httpReq == null, 'BaseIntegrationRequest is not null');
        Test.stopTest();       
    }
}