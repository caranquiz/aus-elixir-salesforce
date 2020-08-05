/******************************************************************************************************************
  Description : This class gives test coverage for SMSFSearchByABNNumberAdapter class
  Testing Scenario 1  : (testMethod1) This method tests SMSFSearchByABNNumberAdapter class's createRequest method with valid
  initialized data.
  Testing Scenario 2  : (testMethod2) This method tests SMSFSearchByABNNumberAdapter class's createRequest method with no
  and blank initialized data.
  Testing Scenario 3  : (testMethod3) This method tests SMSFSearchByABNNumberAdapter class's createRequest method with no
  guid data.
*******************************************************************************************************************/

@isTest
public class SMSFSearchByABNNumberAdapterTest {
    @TestSetup
    static void makeData(){
        ABN_Search_SMSF__c guidInfo = GenericUtilityTestHelper.createCustomSettingGUID(ConstantValues.GUID_VALUE,
        ConstantValues.ACTIVE_FUNDS_ONLY_VALUE,
        ConstantValues.MAX_SEARCH_RESULTS_VALUE);
        System.assertNotEquals(guidInfo,null,'Custom Setting not inserted successfully');
    }
    @isTest
    static void testMethod1() {
        Map<String, Object> filledInRequestMap = new Map<String, Object>();
        List<Map<String, Object>> guidList = new List<Map<String, Object>>();
        intframework.IntegrationAPIConfiguration apiConfig = new intframework.IntegrationAPIConfiguration();
        SMSFSearchByABNNumberAdapter abnAdapter = new SMSFSearchByABNNumberAdapter();
        Map<String, Object> tempMap = new Map<String, Object>();
        ABN_Search_SMSF__c guidInfo = ABN_Search_SMSF__c.getInstance();

        //Mapping data for forming request with a valid data      
        tempMap.put(ConstantValues.GUID, guidInfo.GUID__c);
        guidList.add(tempMap);

        filledInRequestMap.put(ConstantValues.ABN_NUMBER, '58560158971');
        filledInRequestMap.put(ConstantValues.GUID_INFO, guidList);
      
        apiConfig.httpMethod = ConstantValues.HTTP_METHOD;
        apiConfig.requestTimeout = ConstantValues.REQUEST_TIMEOUT;
        apiConfig.apiNamedCredential = ConstantValues.NUMBER_NAMED_CREDENTIAL;
     
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

        //Mapping data for forming request with a valid data 
        filledInRequestMap.put(ConstantValues.ABN_NUMBER, '58560158971');
      
        apiConfig.httpMethod = ConstantValues.HTTP_METHOD;
        apiConfig.requestTimeout = ConstantValues.REQUEST_TIMEOUT;
        apiConfig.apiNamedCredential = ConstantValues.NUMBER_NAMED_CREDENTIAL;
     
        abnAdapter.setApiConfiguration(apiConfig);

        Test.startTest();
        intframework.BaseIntegrationRequest httpReq = abnAdapter.createRequest(new Map<String, Object>(),filledInRequestMap);
        System.assert(httpReq == null, 'BaseIntegrationRequest is not null');
        Test.stopTest();    
    }
}