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
        ABN_Search_SMSF__c guidInfo = new ABN_Search_SMSF__c(GUID__c = 'c4726ad0-af04-4d8d-987b-d15966cd1cfd',Active_Funds_Only__c = 'Y', Maximum_Search_Results__c = '200');
        insert guidInfo;
        System.assertNotEquals(guidInfo,null,'Custom Setting not inserted successfully');
        //Inserting Account
        Account acc = new Account();
        acc.Name = 'Llloyds';
        insert acc;
        System.assertNotEquals(acc,null,'Account not inserted successfully');
        //Inserting Party
        clcommon__Party__c party = new clcommon__Party__c();
        party.clcommon__Account__c = acc.Id;
        insert party;
        System.assertNotEquals(party,null,'Party not inserted successfully');
        //Inserting Integration Family
        intframework__Integration_Family__c family = new intframework__Integration_Family__c();
        family.Name = 'ABNSearchSMSF';
        insert family;
        System.assertNotEquals(family,null,'Family not inserted successfully');
        //Inserting Integration API Type
        intframework__Integration_API_Type__c apiType = new intframework__Integration_API_Type__c();
        apiType.Name = 'ABNSearchSMSFAPI';
        apiType.intframework__Integration_Family__c = family.Id;
        insert apiType;
        System.assertNotEquals(apiType,null,'API Type not inserted successfully');
        //Inserting Integration Provider
        intframework__Integration_Provider__c provider = new intframework__Integration_Provider__c();
        provider.Name = 'ABNSearchSMSF';
        provider.intframework__Active__c = true;
        provider.intframework__Integration_Family__c = family.Id;
        provider.intframework__Product_Name__c = 'testProduct';
        provider.intframework__Product_Version__c = '1.0';
        provider.intframework__Provider_Name__c = 'testProvider';
        provider.intframework__Support_Type__c = 'Custom';
        insert provider;
        System.assertNotEquals(provider,null,'Provider not inserted successfully');
        //Inserting Integration Configuration
        intframework__Integration_Configuration__c config = new intframework__Integration_Configuration__c();
        config.Name = 'ABNSearchSMSF config';
        config.intframework__Integration_Provider__c = provider.Id;
        insert config;
        System.assertNotEquals(config,null,'Configuration not inserted successfully');
        //Inserting API Configuration
        intframework__Integration_API_Configuration__c apiConfig = new intframework__Integration_API_Configuration__c();
        apiConfig.Name = 'ABNSearchSMSFAPI config';
        apiConfig.intframework__Adapter_Class_Name__c = 'SMSFABNNameSearchAdapter';
        apiConfig.intframework__Use_Response_Mocker__c = true;
        apiConfig.intframework__HTTP_Method__c = 'GET';
        apiConfig.intframework__API_Named_Credential__c = 'ABNSearchSMSF';
        apiConfig.intframework__API_Endpoint__c = '';
        apiConfig.intframework__Execution_Priority__c = 1;
        apiConfig.intframework__Request_Mapping__c = '{"thirdPartySystem":{"name":"ABNSearchSMSF","dynamicDataParameters":[{"externalField":"abndata"}],"filters":[{"objectAPI":"clcommon__Party__c","objectAlias":"partyinfo","fields":[{"externalField":"name","fieldAPI":"clcommon__Account__r.Name"}],"whereClause":"Id = :partyId"},{"objectAPI":"ABN_Search_SMSF__c","objectAlias":"guidInfo","fields":[{"externalField":"guid","fieldAPI":"GUID__c"},{"externalField":"activeFundsOnly","fieldAPI":"Active_Funds_Only__c"},{"externalField":"maxSearchResults","fieldAPI":"Maximum_Search_Results__c"}],"whereClause":""}]}}';
        apiConfig.intframework__Response_Mapping__c = '';
        apiConfig.intframework__Integration_Family__c = family.Id;
        apiConfig.intframework__Integration_API_Type__c = apiType.Id;
        apiConfig.intframework__Integration_Provider__c = provider.Id;
        apiConfig.intframework__Integration_Configuration__c = config.Id;
        insert apiConfig;
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