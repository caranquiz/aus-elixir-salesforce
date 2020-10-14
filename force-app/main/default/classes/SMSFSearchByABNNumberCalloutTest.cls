/****************************************************************************************************
 Description          : This test class mostly covers SearchByABNNumberCallout class. 
 Testing Scenario 1   : (testSearchByABNNumber) This method tests SMSFSearchByABNNumberCallout class's
 searchByABNNumber method and uses the MOCK response that is configured at the end. 
 Testing Scenario 2   : (testSearchByABNNumberWithError) This method tests with a error response
 from the SMSFSearchByABNNumberCallout of using search by Australian Business Number. 
 Company: Cloudkaptan Consultancy Services Pvt. Ltd.
 Author: Pratik Agarwal
 Development Date : 2/09/2020
 Last Modified Date : 14/10/2020
****************************************************************************************************/
@isTest
class SMSFSearchByABNNumberCalloutTest{
    @TestSetup
    static void makeData(){
        //Inserting GUID custom settings
        ABN_Search_SMSF__c guidInfo = GenericUtilityTestHelper.createCustomSettingGUID(ConstantValues.GUID_VALUE,
        ConstantValues.ACTIVE_FUNDS_ONLY_VALUE,
        ConstantValues.MAX_SEARCH_RESULTS_VALUE);
        System.assertNotEquals(guidInfo.Id,null,'Custom Setting not inserted successfully');
        //Inserting Account
        Account acc = GenericUtilityTestHelper.createAccount();
        System.assertNotEquals(acc.Id,null,'Account not inserted successfully');
        //Inserting Party
        clcommon__Party__c party = GenericUtilityTestHelper.createParty(acc);
        System.assertNotEquals(party.Id,null,'Party not inserted successfully');
        //Inserting Integration Family
        intframework__Integration_Family__c family = GenericUtilityTestHelper.getFamily(ConstantValues.FAMILY_NAME);
        System.assertNotEquals(family.Id,null,'Family not inserted successfully');
        //Inserting Integration API Type
        intframework__Integration_API_Type__c apiType = GenericUtilityTestHelper.getIntegrationAPIType(family.Id,ConstantValues.NUMBER_API_TYPE);
        System.assertNotEquals(apiType.Id,null,'API Type not inserted successfully');
        //Inserting Integration Provider
        intframework__Integration_Provider__c provider = GenericUtilityTestHelper.getIntegrationProvider(family.Id,ConstantValues.NUMBER_PROVIDER);
        System.assertNotEquals(provider.Id,null,'Provider not inserted successfully');
        //Inserting Integration Configuration
        intframework__Integration_Configuration__c config = GenericUtilityTestHelper.getIntegrationConfiguration(provider.Id,ConstantValues.NUMBER_CONFIGURATION);
        System.assertNotEquals(config.Id,null,'Configuration not inserted successfully');
        //Inserting API Configuration
        intframework__Integration_API_Configuration__c apiConfig = GenericUtilityTestHelper.getIntegrationAPIConfiguration(family.Id,
        apiType.Id,
        provider.Id,
        config.Id,
        ConstantValues.NUMBER_ADAPTER_CLASS,
        ConstantValues.HTTP_METHOD,
        'SearchByABNNumber',
        '',
        ConstantValues.NUMBER_REQUEST_MAPPING);
        System.assertNotEquals(apiConfig.Id,null,'API configuration not inserted succesfully');
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
        clcommon__Party__c party = [SELECT Id FROM clcommon__Party__c WHERE clcommon__Account__r.Name = 'Llloyds'];
        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.startTest();
        String responseString = SMSFSearchByABNNumberCallout.searchByABNNumber('58560158971',party.Id);
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
        clcommon__Party__c party = [SELECT Id FROM clcommon__Party__c WHERE clcommon__Account__r.Name = 'Llloyds'];
        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.startTest();
        String responseString = SMSFSearchByABNNumberCallout.searchByABNNumber('58560158971', party.Id);
        System.assert(responseString != null, 'ABN Response fetch error');
        Test.stopTest();
    }   
}