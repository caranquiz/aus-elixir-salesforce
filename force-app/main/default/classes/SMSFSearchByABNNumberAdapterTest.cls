/******************************************************************************************************************
  Testing Scenario 1  : (testMethod1) This method tests SMSFSearchByABNNumberAdapter class's createRequest method with valid
  initialized data.
  Testing Scenario 2  : (testMethod2) This method tests SMSFSearchByABNNumberAdapter class's createRequest method with no
  and blank initialized data.
  Testing Scenario 3  : (testMethod3) This method tests SMSFSearchByABNNumberAdapter class's createRequest method with no
  guid data.
*******************************************************************************************************************/

@isTest
public class SMSFSearchByABNNumberAdapterTest {
    @isTest
    static void testMethod1() {
        Map<String, Object> filledInRequestMap = new Map<String, Object>();
        List<Map<String, Object>> guidList = new List<Map<String, Object>>();
        intframework.IntegrationAPIConfiguration apiConfig = new intframework.IntegrationAPIConfiguration();
        SMSFSearchByABNNumberAdapter abnAdapter = new SMSFSearchByABNNumberAdapter();
        Map<String, Object> tempMap = new Map<String, Object>();

        //Mapping data for forming request with a valid data      
        tempMap.put('guid', 'c4726ad0-af04-4d8d-987b-d15966cd1cfd');
        guidList.add(tempMap);

        filledInRequestMap.put('abndata', '58560158971');
        filledInRequestMap.put('guidinfo', guidList);
      
        apiConfig.httpMethod = 'GET';
        apiConfig.requestTimeout = 12000;
        apiConfig.apiNamedCredential = 'https://superfundlookup.gov.au/xmlsearch/SflXmlSearch.asmx/SearchByABN2015';
     
        abnAdapter.setApiConfiguration(apiConfig);

        Test.startTest();
        intframework.BaseIntegrationRequest httpReq = abnAdapter.createRequest(new Map<String, Object>(),filledInRequestMap);
        System.assert(httpReq != null, 'BaseIntegrationRequest is null');
        Test.stopTest();       
    }

    @isTest
    static void testMethod2() {
        Map<String, Object> filledInRequestMap = new Map<String, Object>();
        SMSFSearchByABNNumberAdapter abnAdapter = new SMSFSearchByABNNumberAdapter();

        Test.startTest();
        intframework.BaseIntegrationRequest httpReq = abnAdapter.createRequest(new Map<String, Object>(),filledInRequestMap);
        System.assert(httpReq == null, 'BaseIntegrationRequest is not null');
        Test.stopTest();    
    }

    @isTest
    static void testMethod3() {
        Map<String, Object> filledInRequestMap = new Map<String, Object>();
        intframework.IntegrationAPIConfiguration apiConfig = new intframework.IntegrationAPIConfiguration();
        SMSFSearchByABNNumberAdapter abnAdapter = new SMSFSearchByABNNumberAdapter();

        filledInRequestMap.put('abndata', '58560158971');
      
        apiConfig.httpMethod = 'GET';
        apiConfig.requestTimeout = 12000;
        apiConfig.apiNamedCredential = 'https://superfundlookup.gov.au/xmlsearch/SflXmlSearch.asmx/SearchByABN2015';
     
        abnAdapter.setApiConfiguration(apiConfig);

        Test.startTest();
        intframework.BaseIntegrationRequest httpReq = abnAdapter.createRequest(new Map<String, Object>(),filledInRequestMap);
        System.assert(httpReq == null, 'BaseIntegrationRequest is not null');
        Test.stopTest();    
    }
}