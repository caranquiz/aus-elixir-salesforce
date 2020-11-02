@isTest
private class EquifaxCompanyEnquiryCalloutTest {
    @TestSetup
    static void initialize() {
        clcommon__Party_Type__c partyType = new clcommon__Party_Type__c();
        partyType.Name = 'Borrower';
        insert partyType;


        intframework__Integration_Family__c family = GenericUtilityTestHelper.getFamily(
            ConstantValues.EQUIFAX_FAMILY
        );
        
        intframework__Integration_API_Type__c apiType = GenericUtilityTestHelper.getIntegrationAPIType(
            family.Id,
            'Company Enquiry'
        );
        intframework__Integration_Provider__c provider = GenericUtilityTestHelper.getIntegrationProvider(
            family.Id,
            'Company Enquiry'
        );
        intframework__Integration_Configuration__c config = GenericUtilityTestHelper.getIntegrationConfiguration(
            provider.Id,
            'Company Enquiry'
        );
        GenericUtilityTestHelper.getIntegrationAPIConfiguration(
            family.Id,
            apiType.Id,
            provider.Id,
            config.Id,
            'EquifaxCompanyEnquiryAdapter',
            'POST',
            'EquifaxCredentials',
            '/companyEnquiry1',
            '{"thirdPartySystem":{"name":"Equifax","dynamicDataParameters":[{"externalField":"enrichmentRequired"},{"externalField":"isJoint"}],"filters":[{"objectAPI":"clcommon__Party__c","objectAlias":"partyinfo","fields":[{"externalField":"companyACN","fieldAPI":"Company_ACN__c"},{"externalField":"trusteeACN","fieldAPI":"Trustee_ACN__c"},{"externalField":"name","fieldAPI":"Name"}],"whereClause":"Id = :partyId"},{"objectAPI":"clcommon__Party_Type__c","objectAlias":"partyRelatedInfo","fields":[{"externalField":"partyTypeName","fieldAPI":"Name"}],"whereClause":"Id = :partyTypeId"},{"objectAPI":"clcommon__Legal_Entity__c","objectAlias":"entityRelatedInfo","fields":[{"externalField":"entityName","fieldAPI":"Name"}],"whereClause":"Id = :entityID"},{"objectAPI":"genesis__Applications__c","objectAlias":"applicationInfo","fields":[{"externalField":"applicationName","fieldAPI":"Name"},{"externalField":"loanAmount","fieldAPI":"genesis__Loan_Amount__c"}],"whereClause":"Id = :applicationID"}]}}'
        );


        Account acc = GenericUtilityTestHelper.createAccount();
        clcommon__CL_Product__c prod = GenericUtilityTestHelper.returnClProduct();
        genesis__applications__c application = GenericUtilityTestHelper.insertApplication(acc.Id, prod.Id);
        clcommon__Party__c party = GenericUtilityTestHelper.createParty(acc);
        party.clcommon__Type__c = partyType.Id;
        update party;
        clcommon__Legal_Entity__c entity = GenericUtilityTestHelper.returnLegalEntity();
        acc.clcommon__Legal_Entity_Type__c = entity.Id;
        update acc;
        
        

    }


    @isTest 
    static void testcompanyEnquiryRequest(){
        clcommon__Party__c party = [SELECT ID from clcommon__Party__c];
        genesis__applications__c application = [SELECT ID from genesis__Applications__c];   
        
        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.startTest();
        String testEnquiry = EquifaxCompanyEnquiryCallout.companyEnquiryRequest(party.ID, application.ID, true);
        List<clcommon__Log__c> logList = [SELECT Id, clcommon__Message__c FROM clcommon__Log__c];
        for(clcommon__Log__c each : logList){
            System.debug(each.clcommon__Message__c);
        }
        Test.stopTest();
        System.assertNotEquals(ConstantValues.GENERAL_ERROR, testEnquiry, 'Response fetching error');
    }

    @isTest 
    static void testcompanyEnquiryRequest2(){
        clcommon__Party__c party = [SELECT ID from clcommon__Party__c];
        genesis__applications__c application = [SELECT ID from genesis__Applications__c];   
        intframework__Integration_API_Configuration__c api = [SELECT ID from intframework__Integration_API_Configuration__c];
        api.intframework__API_Endpoint__c = 'companyEnquiry2';
        update api;

        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.startTest();
        String testEnquiry = EquifaxCompanyEnquiryCallout.companyEnquiryRequest(party.ID, application.ID, true);
        List<clcommon__Log__c> logList = [SELECT Id, clcommon__Message__c FROM clcommon__Log__c];
        for(clcommon__Log__c each : logList){
            System.debug(each.clcommon__Message__c);
        }
        Test.stopTest();
        System.assertNotEquals(ConstantValues.GENERAL_ERROR, testEnquiry, 'Response fetching error');
    }

    @isTest 
    static void testcompanyEnquiryRequest3(){
        clcommon__Party__c party = [SELECT ID from clcommon__Party__c];
        genesis__applications__c application = [SELECT ID from genesis__Applications__c];   
        intframework__Integration_API_Configuration__c api = [SELECT ID from intframework__Integration_API_Configuration__c];
        api.intframework__API_Endpoint__c = 'companyEnquiry3';
        update api;

        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.startTest();
        String testEnquiry = EquifaxCompanyEnquiryCallout.companyEnquiryRequest(party.ID, application.ID, true);
        List<clcommon__Log__c> logList = [SELECT Id, clcommon__Message__c FROM clcommon__Log__c];
        for(clcommon__Log__c each : logList){
            System.debug(each.clcommon__Message__c);
        }
        Test.stopTest();
        System.assertNotEquals(ConstantValues.GENERAL_ERROR, testEnquiry, 'Response fetching error');
    }

    @isTest 
    static void testcompanyEnquiryRequest4(){
        clcommon__Party__c party = [SELECT ID from clcommon__Party__c];
        genesis__applications__c application = [SELECT ID from genesis__Applications__c];   
        intframework__Integration_API_Configuration__c api = [SELECT ID from intframework__Integration_API_Configuration__c];
        api.intframework__API_Endpoint__c = 'companyEnquiry4';
        update api;

        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.startTest();
        String testEnquiry = EquifaxCompanyEnquiryCallout.companyEnquiryRequest(party.ID, application.ID, true);
        List<clcommon__Log__c> logList = [SELECT Id, clcommon__Message__c FROM clcommon__Log__c];
        for(clcommon__Log__c each : logList){
            System.debug(each.clcommon__Message__c);
        }
        Test.stopTest();
        System.assertNotEquals(ConstantValues.GENERAL_ERROR, testEnquiry, 'Response fetching error');
    }
    @isTest 
    static void testcompanyEnquiryRequest5(){
        clcommon__Party__c party = [SELECT ID from clcommon__Party__c];
        genesis__applications__c application = [SELECT ID from genesis__Applications__c];   
        intframework__Integration_API_Configuration__c api = [SELECT ID from intframework__Integration_API_Configuration__c];
        api.intframework__API_Endpoint__c = 'companyEnquiry5';
        update api;

        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.startTest();
        String testEnquiry = EquifaxCompanyEnquiryCallout.companyEnquiryRequest(party.ID, application.ID, true);
        List<clcommon__Log__c> logList = [SELECT Id, clcommon__Message__c FROM clcommon__Log__c];
        for(clcommon__Log__c each : logList){
            System.debug(each.clcommon__Message__c);
        }
        Test.stopTest();
        System.assertNotEquals(ConstantValues.GENERAL_ERROR, testEnquiry, 'Response fetching error');
    }
    @isTest
    static void testcompanyEnquiryRequest6(){
        List<clcommon__Party__c> party = [SELECT ID from clcommon__Party__c];
        genesis__applications__c application = [SELECT ID from genesis__Applications__c];
        Map<String, Object> request = new Map<String, Object>();
        Map<String, Object> partyDetails = new Map<String, Object>();
        partyDetails.put('companyACN', 1234);
        List<Map<String, Object>> partyList = new List<Map<String, Object>>();
        partyList.add(partyDetails);
        request.put('partyinfo', partyList);
        Test.startTest();
        EquifaxCompanyEnquiryAdapter ob = new EquifaxCompanyEnquiryAdapter();
        ob.generateRequestBody(request);
        Test.stopTest();
    }

    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            System.debug(
                LoggingLevel.DEBUG,
                'End point for Mock request is ' + req.getEndPoint()
            );
            return getMockResponse(req.getEndpoint(), 200);
        }
    }

    /* method to get mock response from static resource */
    private static HttpResponse getMockResponse(
        String endpoint,
        Integer statusCode
    ) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        res.setHeader('Content-Type', 'text/xml');
        res.setStatus('SUCCESS');
        Map<String, String> responseMap = new Map<String, String>();
        List<StaticResource> srList = [
            SELECT Id, Name, Body
            FROM StaticResource
            WHERE Name = 'CompanyEnquiryMockResponse'
            OR Name = 'CompanyEnquiryMockResponse2'
            OR Name = 'MultipleDefaultsResponse'
            OR Name ='MultipleShareholder'
        ];
        System.debug(endpoint);
        for(StaticResource each : srList){
            responseMap.put(each.Name, each.Body.toString());
        }

        if(endpoint.contains('companyEnquiry1')){
            res.setBody(responseMap.get('CompanyEnquiryMockResponse'));
        }
        else if(endpoint.contains('companyEnquiry2')){
            res.setBody(responseMap.get('CompanyEnquiryMockResponse2'));
        }
        else if(endpoint.contains('companyEnquiry3')){
            res.setBody(responseMap.get('MultipleDefaultsResponse'));
        }
        else if(endpoint.contains('companyEnquiry4')){
            res.setBody(responseMap.get('ErrorCondition'));
        }
        else if(endpoint.contains('companyEnquiry5')){
            res.setBody(responseMap.get('MultipleShareholder'));
        }
        else{
            res.setBody('');
        }
        return res;
    }
    
    
}