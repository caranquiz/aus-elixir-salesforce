/* Name - ABNAPICalloutTest 
Description - Test class for ABN API callout
Developer - Soumik Sarkar
*/
@isTest
public with sharing class ABNAPICalloutTest{    

    static testMethod void test1() {

        //Inserting Legal Entity
            clcommon__Legal_Entity__c legEntity = ElixirTestHelper.returnLegalEntity();
            insert legEntity;
            System.assertEquals(legEntity.Name,'Individual');

        //Inserting Account
            Account acc = ElixirTestHelper.returnBorrowerAccount(legEntity.Id);
            insert acc;
            System.assertEquals(acc.name,'Rameswari Barman');

        clcommon__Party_Type__c partyType = new clcommon__Party_Type__c(name = 'Broker');
        insert partyType;
        System.assertEquals(partyType.name,'Broker');
        
        clcommon__Party__c broParty = new clcommon__Party__c(clcommon__Type__c=partyType.Id,clcommon__Account__c = acc.id);
        insert broParty;
        System.assertEquals(broParty.clcommon__Account__c,acc.id);

        ABN_Company_Information__c cObj = new ABN_Company_Information__c();
        cObj.Party__c = broParty.id;
        insert cObj;
        System.assertEquals(cObj.Party__c,broParty.id);
        
        List<ABN_Company_List__c> companyList = new List<ABN_Company_List__c>();
        
        ABN_Company_List__c obj = new ABN_Company_List__c();
        obj.ABN_Company_Information__c = cObj.id;
        obj.ABN_Identifier_Value__c = 'jhsjfjh';
        insert obj;
        //obj.ABN_Company_Information__r.Employment_Information__c =  cObj.Employment_Information__c;
        //insert obj;
        System.assertEquals('jhsjfjh',obj.ABN_Identifier_Value__c);
        
        ints.IntegrationConfigurationDTO IntegrationConfiguration = new ints.IntegrationConfigurationDTO();
        HttpResponse res = new HttpResponse();
        String payLoad = '<?xml version="1.0" encoding="utf-8"?><ABRPayloadSearchResults xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://abr.business.gov.au/ABRXMLSearch/"><request><identifierSearchRequest><authenticationGUID>c74fa70d-610f-4a9c-9703-2321c82ce510</authenticationGUID><identifierType>ABN</identifierType><identifierValue>27634779990</identifierValue><history>Y</history></identifierSearchRequest></request><response><usageStatement>The Registrar of the ABR monitors the quality of the information available on this website and updates the information regularly. However, neither the Registrar of the ABR nor the Commonwealth guarantee that the information available through this service (including search results) is accurate, up to date, complete or accept any liability arising from the use of or reliance upon this site.</usageStatement><dateRegisterLastUpdated>2019-10-17</dateRegisterLastUpdated><dateTimeRetrieved>2019-10-17T17:20:03.4135718+11:00</dateTimeRetrieved><businessEntity><recordLastUpdatedDate>2019-07-10</recordLastUpdatedDate><ABN><identifierValue>27634779990</identifierValue><isCurrentIndicator>Y</isCurrentIndicator><replacedFrom>0001-01-01</replacedFrom></ABN><entityStatus><entityStatusCode>Active</entityStatusCode><effectiveFrom>2019-07-10</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></entityStatus><ASICNumber>634779990</ASICNumber><entityType><entityTypeCode>PRV</entityTypeCode><entityDescription>Australian Private Company</entityDescription></entityType><goodsAndServicesTax><effectiveFrom>2019-07-10</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></goodsAndServicesTax><mainName><organisationName>WINGATE ELIXIR FINANCIAL PTY LTD</organisationName><effectiveFrom>2019-07-10</effectiveFrom></mainName><mainBusinessPhysicalAddress><stateCode>VIC</stateCode><postcode>3000</postcode><effectiveFrom>2019-07-10</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></mainBusinessPhysicalAddress></businessEntity></response></ABRPayloadSearchResults>';

        ints__Integration_Configuration__c icObj = new ints__Integration_Configuration__c();
        icObj.ints__Authorization_Named_Credential__c ='ABN_Api' ;
        icObj.ints__Integration_Service__c = 'ID Verification';
        icObj.ints__Active__c =true;
        icObj.ints__Request_Mapping__c = '{"thirdPartySystem":{"name":"abnRequest","dynamicDataMapping":[{"Alias":"abn_request"}],"filters":[{"tablename":"ABN_Company_List__c","tableAlias":"companyInfo","fields":[{"Alias":"companyABN","fieldAPI":"ABN_Identifier_Value__c"}],"whereClause":"Id=:abnCompanyId"}],"otherParameters":{"service":"ABRSearchByABN","histdetails":"N"}}}';
        icObj.ints__Execution_Priority__c = 1;
        icObj.ints__Adaptor_Class__c = 'ABNAdapter' ;
        icObj.ints__API_Named_Credential__c = 'ABN_Api';
        icObj.ints__Response_Mapping__c ='{"StorageConfiguration":{"StoreInDB":"False"},"DMLOperations":[]}' ;
        icObj.name = 'ABN_API';
        icObj.ints__Third_Party_System__c = 'ABN';
        icObj.ints__Type__c = 'Get Access Token';
        icObj.ints__Use_Mocker__c = true;
        
        insert icObj;
        System.assertEquals('ABN_API',icObj.name);        
        //Mocker Object
        ints__Mocker__c mockObj = new ints__Mocker__c();
        mockObj.ints__Integration_Configuration__c = icObj.Id;
        mockObj.ints__Response_Body__c= payLoad;
        mockObj.ints__Response_Status__c = '200 - OK';  
        mockObj.ints__Control_Field_Value__c = '12345';  
        mockObj.ints__content_Type__c = 'application/xml';
        
        insert mockObj;
        System.assertequals('12345',mockObj.ints__Control_Field_Value__c);
        
        ints__Additional_Parameters__c param = new ints__Additional_Parameters__c();
        param.ints__Key__c = 'Control_Field';
        param.ints__Value__c = 'Provider';
        param.ints__Integration_Configuration__c = icObj.Id;
        insert param;
        System.assertEquals(param.ints__Value__c,'Provider');
        Test.startTest();
        ABNAPICallout.makeABNCallout(obj.id);
        Test.stopTest(); 
        
    }
    
    static testMethod void test2() {
        //clcommon__Party__c  pObj = new  clcommon__Party__c();
        //insert pObj;
        
        genesis__Employment_Information__c eObj = new genesis__Employment_Information__c();
        insert eObj;
        
        ABN_Company_Information__c cObj = new ABN_Company_Information__c();
        //cObj.Party__c = pObj.id;
        cObj.Employment_Information__c = eObj.id;
        insert cObj;
        System.assertequals(cObj.Employment_Information__c,eObj.id);
        
        List<ABN_Company_List__c> companyList = new List<ABN_Company_List__c>();
        
        ABN_Company_List__c obj = new ABN_Company_List__c();
        obj.ABN_Company_Information__c = cObj.id;
        obj.ABN_Identifier_Value__c = 'jhsjfjh';
        insert obj;
        //obj.ABN_Company_Information__r.Employment_Information__c =  cObj.Employment_Information__c;
        //insert obj;
        System.assertequals('jhsjfjh',obj.ABN_Identifier_Value__c);
        
        ints.IntegrationConfigurationDTO IntegrationConfiguration = new ints.IntegrationConfigurationDTO();
        HttpResponse res = new HttpResponse();
        String payLoad = '<?xml version="1.0" encoding="utf-8"?><ABRPayloadSearchResults xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://abr.business.gov.au/ABRXMLSearch/"><request><identifierSearchRequest><authenticationGUID>c74fa70d-610f-4a9c-9703-2321c82ce510</authenticationGUID><identifierType>ABN</identifierType><identifierValue>27634779990</identifierValue><history>Y</history></identifierSearchRequest></request><response><usageStatement>The Registrar of the ABR monitors the quality of the information available on this website and updates the information regularly. However, neither the Registrar of the ABR nor the Commonwealth guarantee that the information available through this service (including search results) is accurate, up to date, complete or accept any liability arising from the use of or reliance upon this site.</usageStatement><dateRegisterLastUpdated>2019-10-17</dateRegisterLastUpdated><dateTimeRetrieved>2019-10-17T17:20:03.4135718+11:00</dateTimeRetrieved><businessEntity><recordLastUpdatedDate>2019-07-10</recordLastUpdatedDate><ABN><identifierValue>27634779990</identifierValue><isCurrentIndicator>Y</isCurrentIndicator><replacedFrom>0001-01-01</replacedFrom></ABN><entityStatus><entityStatusCode>Active</entityStatusCode><effectiveFrom>2019-07-10</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></entityStatus><ASICNumber>634779990</ASICNumber><entityType><entityTypeCode>PRV</entityTypeCode><entityDescription>Australian Private Company</entityDescription></entityType><goodsAndServicesTax><effectiveFrom>2019-07-10</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></goodsAndServicesTax><mainName><organisationName>WINGATE ELIXIR FINANCIAL PTY LTD</organisationName><effectiveFrom>2019-07-10</effectiveFrom></mainName><mainBusinessPhysicalAddress><stateCode>VIC</stateCode><postcode>3000</postcode><effectiveFrom>2019-07-10</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></mainBusinessPhysicalAddress></businessEntity></response></ABRPayloadSearchResults>';

        ints__Integration_Configuration__c icObj = new ints__Integration_Configuration__c();
        icObj.ints__Authorization_Named_Credential__c ='ABN_Api' ;
        icObj.ints__Integration_Service__c = 'ID Verification';
        icObj.ints__Active__c =true;
        icObj.ints__Request_Mapping__c = '{"thirdPartySystem":{"name":"abnRequest","dynamicDataMapping":[{"Alias":"abn_request"}],"filters":[{"tablename":"ABN_Company_List__c","tableAlias":"companyInfo","fields":[{"Alias":"companyABN","fieldAPI":"ABN_Identifier_Value__c"}],"whereClause":"Id=:abnCompanyId"}],"otherParameters":{"service":"ABRSearchByABN","histdetails":"N"}}}';
        icObj.ints__Execution_Priority__c = 1;
        icObj.ints__Adaptor_Class__c = 'ABNAdapter' ;
        icObj.ints__API_Named_Credential__c = 'ABN_Api';
        icObj.ints__Response_Mapping__c ='{"StorageConfiguration":{"StoreInDB":"False"},"DMLOperations":[]}' ;
        icObj.name = 'ABN_API';
        icObj.ints__Third_Party_System__c = 'ABN';
        icObj.ints__Type__c = 'Get Access Token';
        icObj.ints__Use_Mocker__c = true;
        
        insert icObj;
        System.assertequals('ABN_API',icObj.name);        
        //Mocker Object
        ints__Mocker__c mockObj = new ints__Mocker__c();
        mockObj.ints__Integration_Configuration__c = icObj.Id;
        mockObj.ints__Response_Body__c= payLoad;
        mockObj.ints__Response_Status__c = '200 - OK';  
        mockObj.ints__Control_Field_Value__c = '12345';  
        mockObj.ints__content_Type__c = 'application/xml';
        
        insert mockObj;
        System.assertequals('12345',mockObj.ints__Control_Field_Value__c);
        
        ints__Additional_Parameters__c param = new ints__Additional_Parameters__c();
        param.ints__Key__c = 'Control_Field';
        param.ints__Value__c = 'Provider';
        param.ints__Integration_Configuration__c = icObj.Id;
        insert param;
        System.assertEquals(param.ints__Value__c,'Provider');
        Test.startTest();
        ABNAPICallout.makeABNCompanySkuidCallout(obj.id);
        Test.stopTest(); 
        
    }
     
    static testMethod void test3() {
        //clcommon__Party__c  pObj = new  clcommon__Party__c();
        //insert pObj;
        
        genesis__Employment_Information__c eObj = new genesis__Employment_Information__c();
        insert eObj;
        
        ABN_Company_Information__c cObj = new ABN_Company_Information__c();
        //cObj.Party__c = pObj.id;
        //cObj.Employment_Information__c = eObj.id;
        //insert cObj;
        
        List<ABN_Company_List__c> companyList = new List<ABN_Company_List__c>();
        
        ABN_Company_List__c obj = new ABN_Company_List__c();
        //obj.ABN_Company_Information__c = cObj.id;
        obj.ABN_Identifier_Value__c = 'jhsjfjh';
        insert obj;
        //obj.ABN_Company_Information__r.Employment_Information__c =  cObj.Employment_Information__c;
        //insert obj;
        System.assertequals('jhsjfjh',obj.ABN_Identifier_Value__c);
        
        ints.IntegrationConfigurationDTO IntegrationConfiguration = new ints.IntegrationConfigurationDTO();
        HttpResponse res = new HttpResponse();
        String payLoad = '<?xml version="1.0" encoding="utf-8"?><ABRPayloadSearchResults xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://abr.business.gov.au/ABRXMLSearch/"><request><identifierSearchRequest><authenticationGUID>c74fa70d-610f-4a9c-9703-2321c82ce510</authenticationGUID><identifierType>ABN</identifierType><identifierValue>27634779990</identifierValue><history>Y</history></identifierSearchRequest></request><response><usageStatement>The Registrar of the ABR monitors the quality of the information available on this website and updates the information regularly. However, neither the Registrar of the ABR nor the Commonwealth guarantee that the information available through this service (including search results) is accurate, up to date, complete or accept any liability arising from the use of or reliance upon this site.</usageStatement><dateRegisterLastUpdated>2019-10-17</dateRegisterLastUpdated><dateTimeRetrieved>2019-10-17T17:20:03.4135718+11:00</dateTimeRetrieved><businessEntity><recordLastUpdatedDate>2019-07-10</recordLastUpdatedDate><ABN><identifierValue>27634779990</identifierValue><isCurrentIndicator>Y</isCurrentIndicator><replacedFrom>0001-01-01</replacedFrom></ABN><entityStatus><entityStatusCode>Active</entityStatusCode><effectiveFrom>2019-07-10</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></entityStatus><ASICNumber>634779990</ASICNumber><entityType><entityTypeCode>PRV</entityTypeCode><entityDescription>Australian Private Company</entityDescription></entityType><goodsAndServicesTax><effectiveFrom>2019-07-10</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></goodsAndServicesTax><mainName><organisationName>WINGATE ELIXIR FINANCIAL PTY LTD</organisationName><effectiveFrom>2019-07-10</effectiveFrom></mainName><mainBusinessPhysicalAddress><stateCode>VIC</stateCode><postcode>3000</postcode><effectiveFrom>2019-07-10</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></mainBusinessPhysicalAddress></businessEntity></response></ABRPayloadSearchResults>';

        ints__Integration_Configuration__c icObj = new ints__Integration_Configuration__c();
        icObj.ints__Authorization_Named_Credential__c ='ABN_Api' ;
        icObj.ints__Integration_Service__c = 'ID Verification';
        icObj.ints__Active__c =true;
        icObj.ints__Request_Mapping__c = '{"thirdPartySystem":{"name":"abnRequest","dynamicDataMapping":[{"Alias":"abn_request"}],"filters":[{"tablename":"ABN_Company_List__c","tableAlias":"companyInfo","fields":[{"Alias":"companyABN","fieldAPI":"ABN_Identifier_Value__c"}],"whereClause":"Id=:abnCompanyId"}],"otherParameters":{"service":"ABRSearchByABN","histdetails":"N"}}}';
        icObj.ints__Execution_Priority__c = 1;
        icObj.ints__Adaptor_Class__c = 'ABNAdapter' ;
        icObj.ints__API_Named_Credential__c = 'ABN_Api';
        icObj.ints__Response_Mapping__c ='{"StorageConfiguration":{"StoreInDB":"False"},"DMLOperations":[]}' ;
        icObj.name = 'ABN_API';
        icObj.ints__Third_Party_System__c = 'ABN';
        icObj.ints__Type__c = 'Get Access Token';
        icObj.ints__Use_Mocker__c = true;
        
        insert icObj;
        System.assertequals('ABN_API',icObj.name);        
        //Mocker Object
        ints__Mocker__c mockObj = new ints__Mocker__c();
        mockObj.ints__Integration_Configuration__c = icObj.Id;
        mockObj.ints__Response_Body__c= payLoad;
        mockObj.ints__Response_Status__c = '200 - OK';  
        mockObj.ints__Control_Field_Value__c = '12345';  
        mockObj.ints__content_Type__c = 'application/xml';
        
        insert mockObj;
        System.assertequals('12345',mockObj.ints__Control_Field_Value__c);
        
        ints__Additional_Parameters__c param = new ints__Additional_Parameters__c();
        param.ints__Key__c = 'Control_Field';
        param.ints__Value__c = 'Provider';
        param.ints__Integration_Configuration__c = icObj.Id;
        insert param;
        System.assertequals(param.ints__Value__c,'Provider');
        Test.startTest();
        ABNAPICallout.makeABNCallout(obj.id);
        Test.stopTest(); 
        
    }
    
    static testMethod void test4() {
        //clcommon__Party__c  pObj = new  clcommon__Party__c();
        //insert pObj;
        
        //genesis__Employment_Information__c eObj = new genesis__Employment_Information__c();
        //insert eObj;
        
        ABN_Company_Information__c cObj = new ABN_Company_Information__c();
        //cObj.Party__c = pObj.id;
        //cObj.Employment_Information__c = eObj.id;
        //insert cObj;
        
        List<ABN_Company_List__c> companyList = new List<ABN_Company_List__c>();
        
        ABN_Company_List__c obj = new ABN_Company_List__c();
        obj.ABN_Company_Information__c = cObj.id;
        obj.ABN_Identifier_Value__c = 'jhsjfjh';
        insert obj;
        //obj.ABN_Company_Information__r.Employment_Information__c =  cObj.Employment_Information__c;
        //insert obj;
        System.assertequals('jhsjfjh',obj.ABN_Identifier_Value__c);
        
        ints.IntegrationConfigurationDTO IntegrationConfiguration = new ints.IntegrationConfigurationDTO();
        HttpResponse res = new HttpResponse();
        String payLoad = '<?xml version="1.0" encoding="utf-8"?><ABRPayloadSearchResults xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://abr.business.gov.au/ABRXMLSearch/"><request><identifierSearchRequest><authenticationGUID>c74fa70d-610f-4a9c-9703-2321c82ce510</authenticationGUID><identifierType>ABN</identifierType><identifierValue>27634779990</identifierValue><history>Y</history></identifierSearchRequest></request><response><usageStatement>The Registrar of the ABR monitors the quality of the information available on this website and updates the information regularly. However, neither the Registrar of the ABR nor the Commonwealth guarantee that the information available through this service (including search results) is accurate, up to date, complete or accept any liability arising from the use of or reliance upon this site.</usageStatement><dateRegisterLastUpdated>2019-10-17</dateRegisterLastUpdated><dateTimeRetrieved>2019-10-17T17:20:03.4135718+11:00</dateTimeRetrieved><businessEntity><recordLastUpdatedDate>2019-07-10</recordLastUpdatedDate><ABN><identifierValue>27634779990</identifierValue><isCurrentIndicator>Y</isCurrentIndicator><replacedFrom>0001-01-01</replacedFrom></ABN><entityStatus><entityStatusCode>Active</entityStatusCode><effectiveFrom>2019-07-10</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></entityStatus><ASICNumber>634779990</ASICNumber><entityType><entityTypeCode>PRV</entityTypeCode><entityDescription>Australian Private Company</entityDescription></entityType><goodsAndServicesTax><effectiveFrom>2019-07-10</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></goodsAndServicesTax><mainName><organisationName>WINGATE ELIXIR FINANCIAL PTY LTD</organisationName><effectiveFrom>2019-07-10</effectiveFrom></mainName><mainName><organisationName>WINGATE ELIXIR FINANCIAL PTY LTD</organisationName><effectiveFrom>2019-07-10</effectiveFrom></mainName><mainBusinessPhysicalAddress><stateCode>VIC</stateCode><postcode>3000</postcode><effectiveFrom>2019-07-10</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></mainBusinessPhysicalAddress></businessEntity></response></ABRPayloadSearchResults>';

        ints__Integration_Configuration__c icObj = new ints__Integration_Configuration__c();
        icObj.ints__Authorization_Named_Credential__c ='ABN_Api' ;
        icObj.ints__Integration_Service__c = 'ID Verification';
        icObj.ints__Active__c =true;
        icObj.ints__Request_Mapping__c = '{"thirdPartySystem":{"name":"abnRequest","dynamicDataMapping":[{"Alias":"abn_request"}],"filters":[{"tablename":"ABN_Company_List__c","tableAlias":"companyInfo","fields":[{"Alias":"companyABN","fieldAPI":"ABN_Identifier_Value__c"}],"whereClause":"Id=:abnCompanyId"}],"otherParameters":{"service":"ABRSearchByABN","histdetails":"N"}}}';
        icObj.ints__Execution_Priority__c = 1;
        icObj.ints__Adaptor_Class__c = 'ABNAdapter' ;
        icObj.ints__API_Named_Credential__c = 'ABN_Api';
        icObj.ints__Response_Mapping__c ='{"StorageConfiguration":{"StoreInDB":"False"},"DMLOperations":[]}' ;
        icObj.name = 'ABN_API';
        icObj.ints__Third_Party_System__c = 'ABN';
        icObj.ints__Type__c = 'Get Access Token';
        icObj.ints__Use_Mocker__c = true;
        
        insert icObj;
        System.assertequals('ABN_API',icObj.name);        
        //Mocker Object
        ints__Mocker__c mockObj = new ints__Mocker__c();
        mockObj.ints__Integration_Configuration__c = icObj.Id;
        mockObj.ints__Response_Body__c= payLoad;
        mockObj.ints__Response_Status__c = '200 - OK';  
        mockObj.ints__Control_Field_Value__c = '12345';  
        mockObj.ints__content_Type__c = 'application/xml';
        
        insert mockObj;
        System.assertequals('12345',mockObj.ints__Control_Field_Value__c);
        
        ints__Additional_Parameters__c param = new ints__Additional_Parameters__c();
        param.ints__Key__c = 'Control_Field';
        param.ints__Value__c = 'Provider';
        param.ints__Integration_Configuration__c = icObj.Id;
        insert param;
        System.assertequals(param.ints__Value__c,'Provider');
        Test.startTest();
        ABNAPICallout.makeABNCallout(obj.id);
        Test.stopTest(); 
        
    }
    static testMethod void test5() {
        //clcommon__Party__c  pObj = new  clcommon__Party__c();
        //insert pObj;
        
        //genesis__Employment_Information__c eObj = new genesis__Employment_Information__c();
        //insert eObj;
        
        ABN_Company_Information__c cObj = new ABN_Company_Information__c();
        //cObj.Party__c = pObj.id;
        //cObj.Employment_Information__c = eObj.id;
        //insert cObj;
        
        List<ABN_Company_List__c> companyList = new List<ABN_Company_List__c>();
        
        ABN_Company_List__c obj = new ABN_Company_List__c();
        obj.ABN_Company_Information__c = cObj.id;
        obj.ABN_Identifier_Value__c = 'jhsjfjh';
        insert obj;
        //obj.ABN_Company_Information__r.Employment_Information__c =  cObj.Employment_Information__c;
        //insert obj;
        System.assertequals('jhsjfjh',obj.ABN_Identifier_Value__c);
        
        ints.IntegrationConfigurationDTO IntegrationConfiguration = new ints.IntegrationConfigurationDTO();
        HttpResponse res = new HttpResponse();
        //String payLoad = '<?xml version="1.0" encoding="utf-8"?><ABRPayloadSearchResults xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://abr.business.gov.au/ABRXMLSearch/"><request><identifierSearchRequest><authenticationGUID>c74fa70d-610f-4a9c-9703-2321c82ce510</authenticationGUID><identifierType>ABN</identifierType><identifierValue>27634779990</identifierValue><history>Y</history></identifierSearchRequest></request><response><usageStatement>The Registrar of the ABR monitors the quality of the information available on this website and updates the information regularly. However, neither the Registrar of the ABR nor the Commonwealth guarantee that the information available through this service (including search results) is accurate, up to date, complete or accept any liability arising from the use of or reliance upon this site.</usageStatement><dateRegisterLastUpdated>2019-10-17</dateRegisterLastUpdated><dateTimeRetrieved>2019-10-17T17:20:03.4135718+11:00</dateTimeRetrieved><businessEntity><recordLastUpdatedDate>2019-07-10</recordLastUpdatedDate><ABN><identifierValue>27634779990</identifierValue><isCurrentIndicator>Y</isCurrentIndicator><replacedFrom>0001-01-01</replacedFrom></ABN><entityStatus><entityStatusCode>Active</entityStatusCode><effectiveFrom>2019-07-10</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></entityStatus><ASICNumber>634779990</ASICNumber><entityType><entityTypeCode>PRV</entityTypeCode><entityDescription>Australian Private Company</entityDescription></entityType><goodsAndServicesTax><effectiveFrom>2019-07-10</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></goodsAndServicesTax><mainName><organisationName>WINGATE ELIXIR FINANCIAL PTY LTD</organisationName><effectiveFrom>2019-07-10</effectiveFrom></mainName><mainName><organisationName>WINGATE ELIXIR FINANCIAL PTY LTD</organisationName><effectiveFrom>2019-07-10</effectiveFrom></mainName><mainBusinessPhysicalAddress><stateCode>VIC</stateCode><postcode>3000</postcode><effectiveFrom>2019-07-10</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></mainBusinessPhysicalAddress></businessEntity></response></ABRPayloadSearchResults>';
        //String payLoad = '<?xml version="1.0" encoding="utf-8"?><ABRPayloadSearchResults xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://abr.business.gov.au/ABRXMLSearch/"><request><identifierSearchRequest><authenticationGUID>c74fa70d-610f-4a9c-9703-2321c82ce510</authenticationGUID><history>N</history><identifierType>ABN</identifierType><identifierValue>36095926640</identifierValue></identifierSearchRequest></request><response><businessEntity><ABN><element><identifierValue>36095926640</identifierValue><isCurrentIndicator>Y</isCurrentIndicator><replacedFrom>0000-12-30</replacedFrom></element><element><identifierValue>36095926640</identifierValue><isCurrentIndicator>Y</isCurrentIndicator><replacedFrom>2001-05-01</replacedFrom><replacedIdentifierValue>54095726640</replacedIdentifierValue></element></ABN><ASICNumber>95926640</ASICNumber><entityStatus><effectiveFrom>2001-05-01</effectiveFrom><effectiveTo>0000-12-30</effectiveTo><entityStatusCode>Active</entityStatusCode></entityStatus><entityType><entityDescription>Australian Private Company</entityDescription><entityTypeCode>PRV</entityTypeCode></entityType><goodsAndServicesTax><effectiveFrom>2001-05-01</effectiveFrom><effectiveTo>0000-12-30</effectiveTo></goodsAndServicesTax><mainBusinessPhysicalAddress><effectiveFrom>2014-09-18</effectiveFrom><effectiveTo>0000-12-30</effectiveTo><postcode>3131</postcode><stateCode>VIC</stateCode></mainBusinessPhysicalAddress><mainName><element><effectiveFrom>2010-11-23</effectiveFrom><organisationName>LALISSE AUSTRALIA PTY LTD</organisationName></element></mainName><mainTradingName><effectiveFrom>2011-10-28</effectiveFrom><organisationName>LALISSE AUSTRALIA PTY LTD</organisationName></mainTradingName><recordLastUpdatedDate>2016-10-28</recordLastUpdatedDate></businessEntity><dateRegisterLastUpdated>2020-01-22</dateRegisterLastUpdated><dateTimeRetrieved>2020-01-22T22:30:21.7645728+11:00</dateTimeRetrieved><usageStatement>The Registrar of the ABR monitors the quality of the information available on this website and updates the information regularly. However, neither the Registrar of the ABR nor the Commonwealth guarantee that the information available through this service (including search results) is accurate, up to date, complete or accept any liability arising from the use of or reliance upon this site.</usageStatement></response></ABRPayloadSearchResults>';
        String payLoad = '<?xml version="1.0" encoding="utf-8"?><ABRPayloadSearchResults xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://abr.business.gov.au/ABRXMLSearch/"><request><identifierSearchRequest><authenticationGUID>c74fa70d-610f-4a9c-9703-2321c82ce510</authenticationGUID><identifierType>ABN</identifierType><identifierValue>36095926640</identifierValue><history>N</history></identifierSearchRequest></request><response><usageStatement>The Registrar of the ABR monitors the quality of the information available on this website and updates the information regularly. However, neither the Registrar of the ABR nor the Commonwealth guarantee that the information available through this service (including search results) is accurate, up to date, complete or accept any liability arising from the use of or reliance upon this site.</usageStatement><dateRegisterLastUpdated>2020-01-22</dateRegisterLastUpdated><dateTimeRetrieved>2020-01-22T23:37:40.5217182+11:00</dateTimeRetrieved><businessEntity><recordLastUpdatedDate>2016-10-28</recordLastUpdatedDate><ABN><identifierValue>36095926640</identifierValue><isCurrentIndicator>Y</isCurrentIndicator><replacedFrom>0001-01-01</replacedFrom></ABN><ABN><identifierValue>36095926640</identifierValue><isCurrentIndicator>Y</isCurrentIndicator><replacedIdentifierValue>54095726640</replacedIdentifierValue><replacedFrom>2001-05-01</replacedFrom></ABN><entityStatus><entityStatusCode>Active</entityStatusCode><effectiveFrom>2001-05-01</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></entityStatus><ASICNumber>095926640</ASICNumber><entityType><entityTypeCode>PRV</entityTypeCode><entityDescription>Australian Private Company</entityDescription></entityType><goodsAndServicesTax><effectiveFrom>2001-05-01</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></goodsAndServicesTax><mainName><organisationName>LALISSE AUSTRALIA PTY LTD</organisationName><effectiveFrom>2010-11-23</effectiveFrom></mainName><mainTradingName><organisationName>LALISSE AUSTRALIA PTY LTD</organisationName><effectiveFrom>2011-10-28</effectiveFrom></mainTradingName><mainBusinessPhysicalAddress><stateCode>VIC</stateCode><postcode>3131</postcode><effectiveFrom>2014-09-18</effectiveFrom><effectiveTo>0001-01-01</effectiveTo></mainBusinessPhysicalAddress></businessEntity></response></ABRPayloadSearchResults>';
        ints__Integration_Configuration__c icObj = new ints__Integration_Configuration__c();
        icObj.ints__Authorization_Named_Credential__c ='ABN_Api' ;
        icObj.ints__Integration_Service__c = 'ID Verification';
        icObj.ints__Active__c =true;
        icObj.ints__Request_Mapping__c = '{"thirdPartySystem":{"name":"abnRequest","dynamicDataMapping":[{"Alias":"abn_request"}],"filters":[{"tablename":"ABN_Company_List__c","tableAlias":"companyInfo","fields":[{"Alias":"companyABN","fieldAPI":"ABN_Identifier_Value__c"}],"whereClause":"Id=:abnCompanyId"}],"otherParameters":{"service":"ABRSearchByABN","histdetails":"N"}}}';
        icObj.ints__Execution_Priority__c = 1;
        icObj.ints__Adaptor_Class__c = 'ABNAdapter' ;
        icObj.ints__API_Named_Credential__c = 'ABN_Api';
        icObj.ints__Response_Mapping__c ='{"StorageConfiguration":{"StoreInDB":"False"},"DMLOperations":[]}' ;
        icObj.name = 'ABN_API';
        icObj.ints__Third_Party_System__c = 'ABN';
        icObj.ints__Type__c = 'Get Access Token';
        icObj.ints__Use_Mocker__c = true;
        
        insert icObj;
        System.assertequals('ABN_API',icObj.name);        
        //Mocker Object
        ints__Mocker__c mockObj = new ints__Mocker__c();
        mockObj.ints__Integration_Configuration__c = icObj.Id;
        mockObj.ints__Response_Body__c= payLoad;
        mockObj.ints__Response_Status__c = '200 - OK';  
        mockObj.ints__Control_Field_Value__c = '12345';  
        mockObj.ints__content_Type__c = 'application/xml';
        insert mockObj;
        System.assertequals('12345',mockObj.ints__Control_Field_Value__c);
        
        ints__Additional_Parameters__c param = new ints__Additional_Parameters__c();
        param.ints__Key__c = 'Control_Field';
        param.ints__Value__c = 'Provider';
        param.ints__Integration_Configuration__c = icObj.Id;
        insert param;
        System.assertequals(param.ints__Value__c,'Provider');
        Test.startTest();
        ABNAPICallout.makeABNCallout(obj.id);
        Test.stopTest(); 
        
    }
 
}