/****************************************************************************************************/
/* Description          : This test class mostly covers EquifaxOrgIdSearchCallout class. */
/* Testing Scenario 1   : (testsearchByABN) This method tests EquifaxOrgIdSearchCallout class's
 searchByABN method with valid data and uses the MOCK response that is configured at the end. */
/* Testing Scenario 2   : (testsearchByABNWithError) This method tests EquifaxOrgIdSearchCallout class's
 searchByABN method with invalid data and uses the MOCK response that is configured at the end. */
/****************************************************************************************************/
@isTest
class EquifaxOrgIdSearchCalloutTest{
    @TestSetup
    static void makeData(){
        //Inserting Credentials custom settings
        EquifaxOrdIdSearch__c equifaxOrgIdSearchObj = GenericUtilityTestHelper.createCustomSettingCreds('A8LJ9999','TS');
        System.assertNotEquals(equifaxOrgIdSearchObj,null,'Custom Setting not inserted successfully');
        //Inserting Account
        Account acc = GenericUtilityTestHelper.createAccount();
        System.assertNotEquals(acc,null,'Account not inserted successfully');
        //Inserting Party
        clcommon__Party__c party = GenericUtilityTestHelper.createParty(acc);
        System.assertNotEquals(party,null,'Party not inserted successfully');
        //Inserting Integration Family
        intframework__Integration_Family__c family = GenericUtilityTestHelper.getFamily(ConstantValues.EQUIFAX_FAMILY_NAME);
        System.assertNotEquals(family,null,'Family not inserted successfully');
        //Inserting Integration API Type
        intframework__Integration_API_Type__c apiType = GenericUtilityTestHelper.getIntegrationAPIType(family.Id,ConstantValues.EQUIFAX_API_TYPE);
        System.assertNotEquals(apiType,null,'API Type not inserted successfully');
        //Inserting Integration Provider
        intframework__Integration_Provider__c provider = GenericUtilityTestHelper.getIntegrationProvider(family.Id,'Equifax Org Id Search');
        System.assertNotEquals(provider,null,'Provider not inserted successfully');
        //Inserting Integration Configuration
        intframework__Integration_Configuration__c config = GenericUtilityTestHelper.getIntegrationConfiguration(provider.Id,'Equifax Org Id Search config');
        System.assertNotEquals(config,null,'Configuration not inserted successfully');
        //Inserting API Configuration
        intframework__Integration_API_Configuration__c apiConfig = GenericUtilityTestHelper.getIntegrationAPIConfiguration(family.Id,
        apiType.Id,
        provider.Id,
        config.Id,
        'EquifaxOrgIdSearchAdapter',
        'POST',
        'EquifaxOrgIdSearch',
        '',
        ConstantValues.EQUIFAX_REQUEST_MAPPING);
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
        WHERE Name = 'EquifaxMockResponse'
        ];
        String xml = srList[0].Body.toString();
        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        res.setHeader('Content-Type', 'text/xml');
        res.setStatus('SUCCESS');
        if (endpoint.contains('nothing')) {
        res.setBody(
            '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><soapenv:Fault><faultcode>soapenv:Server</faultcode><faultstring>Policy Falsified</faultstring><faultactor>https://ctaau.vedaxml.com/cta/sys1nothing</faultactor><detail><l7:policyResult xmlns:l7="http://www.layer7tech.com/ws/policy/fault" status="Service Not Found.  The request may have been sent to an invalid URL, or intended for an unsupported operation."/></detail></soapenv:Fault></soapenv:Body></soapenv:Envelope>'
        );
        } else {
        res.setBody(
            xml
        );
        }
        return res;
    }
    @isTest
    static void testsearchByABN() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.startTest();
        clcommon__Party__c party = [SELECT Id FROM clcommon__Party__c WHERE clcommon__Account__r.Name = 'Llloyds'];
        String responseString = EquifaxOrgIdSearchCallout.searchByABN(party.Id, ConstantValues.ABN_SEARCH_NUMBER);
        System.assert(responseString != null, 'ABN Response fetch error');
        Test.stopTest();
    }
    @isTest
    static void testsearchByABNWithError() {
        List<intframework__Integration_API_Configuration__c> intApiConfig = [
        SELECT Id, intframework__Adapter_Class_Name__c
        FROM intframework__Integration_API_Configuration__c
        WHERE intframework__Adapter_Class_Name__c = 'EquifaxOrgIdSearchAdapter'
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
        String responseString = EquifaxOrgIdSearchCallout.searchByABN(party.Id, ConstantValues.ABN_SEARCH_NUMBER);
        System.assert(responseString != null, 'ABN Response fetch error');
        Test.stopTest();
    }   
}