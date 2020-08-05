/****************************************************************************************************/
/* Description          : This test class mostly covers SMSFABNNameSearchCallout class. */
/* Testing Scenario 1   : (testSearchBySMSFName) This method tests SMSFABNNameSearchCallout class's
 searchBySMSFName method and uses the MOCK response that is configured at the end. */
/* Testing Scenario 2   : (testSearchBySMSFNameWithError) This method tests with a error response
 from the ABNLookup callout of using search by SMSF Trust Name. */
/****************************************************************************************************/
@isTest
class SMSFABNNameSearchCalloutTest{
    @TestSetup
    static void makeData(){
        //Inserting GUID custom settings
        ABN_Search_SMSF__c guidInfo = GenericUtilityTestHelper.createCustomSettingGUID(ConstantValues.GUID_VALUE,
        ConstantValues.ACTIVE_FUNDS_ONLY_VALUE,
        ConstantValues.MAX_SEARCH_RESULTS_VALUE);
        System.assertNotEquals(guidInfo,null,'Custom Setting not inserted successfully');
        //Inserting Account
        Account acc = GenericUtilityTestHelper.createAccount();
        System.assertNotEquals(acc,null,'Account not inserted successfully');
        //Inserting Party
        clcommon__Party__c party = GenericUtilityTestHelper.createParty(acc);
        System.assertNotEquals(party,null,'Party not inserted successfully');
        //Inserting Integration Family
        intframework__Integration_Family__c family = GenericUtilityTestHelper.getFamily(ConstantValues.FAMILY_NAME);
        System.assertNotEquals(family,null,'Family not inserted successfully');
        //Inserting Integration API Type
        intframework__Integration_API_Type__c apiType = GenericUtilityTestHelper.getIntegrationAPIType(family.Id,ConstantValues.NAME_API_TYPE);
        System.assertNotEquals(apiType,null,'API Type not inserted successfully');
        //Inserting Integration Provider
        intframework__Integration_Provider__c provider = GenericUtilityTestHelper.getIntegrationProvider(family.Id,ConstantValues.NAME_PROVIDER);
        System.assertNotEquals(provider,null,'Provider not inserted successfully');
        //Inserting Integration Configuration
        intframework__Integration_Configuration__c config = GenericUtilityTestHelper.getIntegrationConfiguration(provider.Id,ConstantValues.NAME_CONFIGURATION);
        System.assertNotEquals(config,null,'Configuration not inserted successfully');
        //Inserting API Configuration
        intframework__Integration_API_Configuration__c apiConfig = GenericUtilityTestHelper.getIntegrationAPIConfiguration(family.Id,
        apiType.Id,
        provider.Id,
        config.Id,
        ConstantValues.NAME_ADAPTER_CLASS,
        ConstantValues.HTTP_METHOD,
        'ABNSearchSMSF',
        '',
        ConstantValues.NUMBER_REQUEST_MAPPING);
        System.assertNotEquals(apiConfig,null,'API configuration not inserted succesfully');
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
        String xml = srList[0].Body.toString();
        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        res.setHeader('Content-Type', 'text/xml');
        res.setStatus('SUCCESS');
        if (endpoint.contains('nothing')) {
        res.setBody(
            '<?xml version="1.0" encoding="utf-8"?><ABRPayloadSearchResults xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://superfundlookup.gov.au"><request><identifierSearchRequest><authenticationGUID>e0dd27d6-4b6e-4e06-b94e-65ac6887d4e3</authenticationGUID><identifierType>ABN</identifierType><identifierValue>46006261611</identifierValue><history>N</history></identifierSearchRequest></request><response><dateRegisterLastUpdated>0001-01-01</dateRegisterLastUpdated><dateTimeRetrieved>2020-06-25T17:59:22.3002957+10:00</dateTimeRetrieved><exception><exceptionDescription>Search text is not a valid ABN or ACN</exceptionDescription><exceptionCode>WEBSERVICES</exceptionCode></exception></response></ABRPayloadSearchResults>'
        );
        } else {
        res.setBody(
            xml
        );
        }
        return res;
    }
    @isTest
    static void testSearchBySMSFName() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.startTest();
        clcommon__Party__c party = [SELECT Id FROM clcommon__Party__c WHERE clcommon__Account__r.Name = 'Llloyds'];
        String responseString = SMSFABNNameSearchCallout.searchBySMSFName(party.Id);
        System.assert(responseString != null, 'ABN Response fetch error');
        Test.stopTest();
    }
    @isTest
    static void testSearchBySMSFNameWithError() {
        List<intframework__Integration_API_Configuration__c> intApiConfig = [
        SELECT Id, intframework__Adapter_Class_Name__c
        FROM intframework__Integration_API_Configuration__c
        WHERE intframework__Adapter_Class_Name__c = 'SMSFABNNameSearchAdapter'
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
        clcommon__Party__c party = [SELECT Id FROM clcommon__Party__c WHERE clcommon__Account__r.Name = 'Llloyds'];
        String responseString = SMSFABNNameSearchCallout.searchBySMSFName(party.Id);
        System.assert(responseString != null, 'ABN Response fetch error');
        Test.stopTest();
    }   
}