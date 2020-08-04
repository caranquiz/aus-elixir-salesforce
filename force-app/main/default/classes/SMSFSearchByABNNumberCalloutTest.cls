/****************************************************************************************************/
/* Description          : This test class mostly covers SearchByABNNumberCallout class. */
/* Testing Scenario 1   : (testSearchByABNNumber) This method tests SMSFSearchByABNNumberCallout class's
 searchByABNNumber method and uses the MOCK response that is configured at the end. */
/* Testing Scenario 2   : (testSearchByABNNumberWithError) This method tests with a error response
 from the SMSFSearchByABNNumberCallout of using search by Australian Business Number. */
/****************************************************************************************************/
@isTest
class SMSFSearchByABNNumberCalloutTest{
    @TestSetup
    static void makeData(){
        //Inserting GUID custom settings
        ABN_Search_SMSF__c guidInfo = new ABN_Search_SMSF__c(GUID__c = 'c4726ad0-af04-4d8d-987b-d15966cd1cfd');
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
        apiType.Name = 'SearchByABNNumberAPI';
        apiType.intframework__Integration_Family__c = family.Id;
        insert apiType;
        System.assertNotEquals(apiType,null,'API Type not inserted successfully');
        //Inserting Integration Provider
        intframework__Integration_Provider__c provider = new intframework__Integration_Provider__c();
        provider.Name = 'SearchByABNNumber';
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
        config.Name = 'SearchByABNNumber config';
        config.intframework__Integration_Provider__c = provider.Id;
        insert config;
        System.assertNotEquals(config,null,'Configuration not inserted successfully');
        //Inserting API Configuration
        intframework__Integration_API_Configuration__c apiConfig = new intframework__Integration_API_Configuration__c();
        apiConfig.Name = 'SearchByABNNumber';
        apiConfig.intframework__Adapter_Class_Name__c = 'SMSFSearchByABNNumberAdapter';
        apiConfig.intframework__Use_Response_Mocker__c = true;
        apiConfig.intframework__HTTP_Method__c = 'GET';
        apiConfig.intframework__API_Named_Credential__c = 'SearchByABNNumber';
        apiConfig.intframework__API_Endpoint__c = '';
        apiConfig.intframework__Execution_Priority__c = 1;
        apiConfig.intframework__Request_Mapping__c = '{"thirdPartySystem":{"name":"abnRequest","dynamicDataParameters":[{"externalField":"abnnumber"}],"filters":[{"objectAPI":"ABN_Search_SMSF__c","objectAlias":"guidinfo","fields":[{"externalField":"guid","fieldAPI":"GUID__c"}],"whereClause":""}]}}';
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
            '<?xml version="1.0" encoding="utf-8"?><SuperFundPayload xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://superfundlookup.gov.au"><Request><Guid>c4726ad0-af04-4d8d-987b-d15966cd1cfd</Guid><ABN>58560158971</ABN></Request><Response><UsageStatement>This extract is based on information supplied by superannuation entities to the Commissioner of Taxation. You should consider verifying this information from other sources. Neither the Australian Government nor the Tax Office endorse or guarantee the performance of complying superannuation funds.</UsageStatement><DateTimeRetrieved>2020-08-02T21:36:15.161495+10:00</DateTimeRetrieved><SuperannuationFund2015><RecordLastUpdatedDate>2018-03-30T00:00:00</RecordLastUpdatedDate><OrganisationName><Name>LLOYDS SUPERANNUATION FUND</Name><TypeCode>MN</TypeCode><StartDate>2000-07-06T00:00:00</StartDate></OrganisationName><Identifier><Value>58560158971</Value><Name>ABN</Name><IdentifierStatus><Description>Active</Description><StartDate>2000-05-31T00:00:00</StartDate></IdentifierStatus></Identifier><FundType><Code>SMF</Code><Description>ATO Regulated Self-Managed Superannuation Fund</Description></FundType><Address><PurposeCode>POS</PurposeCode><Line1>26 CHILDREY PL</Line1><Line2/><SuburbLocalityName>CASTLE HILL</SuburbLocalityName><StateTerritoryCode>NSW</StateTerritoryCode><Postcode>2154</Postcode><CountryName>AUSTRALIA</CountryName></Address><ComplyingStatus><Code>Y</Code><Description>Complying</Description></ComplyingStatus></SuperannuationFund2015></Response></SuperFundPayload>'
        );
        }
        return res;
    }
    @isTest
    static void testSearchByABNNumber() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.startTest();
        String responseString = SMSFSearchByABNNumberCallout.searchByABNNumber('58560158971');
        System.assert(responseString != null, 'ABN Response fetch error');
        Test.stopTest();
    }
    @isTest
    static void testSearchByABNNumberWithError() {
        List<intframework__Integration_API_Configuration__c> intApiConfig = [
        SELECT Id, intframework__Adapter_Class_Name__c
        FROM intframework__Integration_API_Configuration__c
        WHERE intframework__Adapter_Class_Name__c = 'SMSFSearchByABNNumberAdapter'
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
        String responseString = SMSFSearchByABNNumberCallout.searchByABNNumber('58560158971');
        System.assert(responseString != null, 'ABN Response fetch error');
        Test.stopTest();
    }   
}