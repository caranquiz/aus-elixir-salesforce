@isTest
private class ABNNameCalloutTest{
    @testSetup static void setup(){
        Account accObj = new Account(Name = 'Test Account');
        INSERT accObj;
        
        clcommon__Party__c partyObj = new clcommon__Party__c(clcommon__Account__C = accObj.id);
        INSERT partyObj;
        
        genesis__Employment_Information__c empObj = new genesis__Employment_Information__c(Name = 'Test Emp 101', Company_Name__c = 'Test Emp 201');
        INSERT empObj;
        
        //INTEGRATION CONFIG FOR ABNNAMEAPI_1
        ints__Integration_Configuration__c icObj = new ints__Integration_Configuration__c();
        icObj.name = 'ABN_NameAPI';
        icObj.ints__Integration_Service__c = 'ID Verification';
        icObj.ints__Third_Party_System__c = '';
        icObj.ints__Type__c = '';
        icObj.ints__API_Endpoint__c = 'https://abr.business.gov.au/abrxmlsearch/AbrXmlSearch.asmx/';
        icObj.ints__Adaptor_Class__c = 'ABNNameAdapter';
        icObj.ints__Active__c = true;
        icObj.ints__Authorization_Named_Credential__c = 'ABN_Api';
        icObj.ints__Execution_Priority__c = 2;
        icObj.ints__Use_Mocker__c = true;
        icObj.ints__Request_Mapping__c = '{"thirdPartySystem":{"name":"abnNameRequest","dynamicDataMapping":[{"Alias":"abn_request"}],"filters":[{"tablename":"clcommon__Party__c","tableAlias":"partyInfo","fields":[{"Alias":"companyABN","fieldAPI":"clcommon__Account__r.Name"}],"whereClause":"Id=:partyId"}],"otherParameters":{"service":"ABRSearchByNameAdvancedSimpleProtocol2017","postcode":"","tradingName":"","legalName":"","businessName":"","activeABNsOnly":"","QLD":"","NT":"","SA":"","WA":"","VIC":"","ACT":"","TAS":"","NSW":"","searchWidth":"","minimumScore":"","maxSearchResults":""}}}';
        icObj.ints__Response_Mapping__c = '{"StorageConfiguration":{"StoreInDB":"False"},"DMLOperations":[{"DML":"Insert","ObjectMapping":[{"objectName":"ABN_Information__c","objectAlias":"=>response=>businessEntity=>mainName","fields":[{"Alias":"organisationName","fieldAPI":"Organisation_Name__c"}]}]}]}';        
        insert icObj;
        
        
        //Mocker Object FOR ABNNAMEAPI_1
        ints__Mocker__c mockObj = new ints__Mocker__c();
        mockObj.ints__Integration_Configuration__c = icObj.Id;
        mockObj.ints__Response_Body__c= '<?xml version="1.0" encoding="utf-8"?><ABRPayloadSearchResults xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://abr.business.gov.au/ABRXMLSearch/"><request><nameSearchRequestAdvanced2017><authenticationGUID>c74fa70d-610f-4a9c-9703-2321c82ce510</authenticationGUID><name>Wingate Elixir Financial PYT LTD</name><filters><nameType><tradingName>Y</tradingName><legalName>Y</legalName><businessName>Y</businessName></nameType><postcode /><stateCode><QLD>Y</QLD><NT>Y</NT><SA>Y</SA><WA>Y</WA><VIC>Y</VIC><ACT>Y</ACT><TAS>Y</TAS><NSW>Y</NSW></stateCode><activeABNsOnly>N</activeABNsOnly></filters><searchWidth>Typical</searchWidth><minimumScore>0</minimumScore><maxSearchResults>0</maxSearchResults></nameSearchRequestAdvanced2017></request><response><usageStatement>The Registrar of the ABR monitors the quality of the information available on this website and updates the information regularly. However, neither the Registrar of the ABR nor the Commonwealth guarantee that the information available through this service (including search results) is accurate, up to date, complete or accept any liability arising from the use of or reliance upon this site.</usageStatement><dateRegisterLastUpdated>2019-11-02</dateRegisterLastUpdated><dateTimeRetrieved>2019-11-02T03:16:43.8628047+11:00</dateTimeRetrieved><searchResultsList><numberOfRecords>10</numberOfRecords><exceedsMaximum>N</exceedsMaximum><searchResultsRecord><ABN><identifierValue>27634779990</identifierValue><identifierStatus>Active</identifierStatus></ABN><mainName><organisationName>WINGATE ELIXIR FINANCIAL PTY LTD</organisationName><score>97</score><isCurrentIndicator>Y</isCurrentIndicator></mainName><mainBusinessPhysicalAddress><stateCode>VIC</stateCode><postcode>3000</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>61100137871</identifierValue><identifierStatus>Cancelled</identifierStatus></ABN><mainTradingName><organisationName>ELIXIR FINANCE</organisationName><score>94</score><isCurrentIndicator>Y</isCurrentIndicator></mainTradingName><mainBusinessPhysicalAddress><stateCode>QLD</stateCode><postcode>4000</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>13612262629</identifierValue><identifierStatus>Active</identifierStatus></ABN><mainName><organisationName>ELIXIR FINANCE PTY LIMITED</organisationName><score>94</score><isCurrentIndicator>N</isCurrentIndicator></mainName><mainBusinessPhysicalAddress><stateCode>NSW</stateCode><postcode>2000</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>74604805601</identifierValue><identifierStatus>Active</identifierStatus></ABN><businessName><organisationName>Elixir Financial</organisationName><score>94</score><isCurrentIndicator>Y</isCurrentIndicator></businessName><mainBusinessPhysicalAddress><stateCode>VIC</stateCode><postcode>3004</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>55090504984</identifierValue><identifierStatus>Cancelled</identifierStatus></ABN><mainName><organisationName>WINGATE PTY LTD</organisationName><score>82</score><isCurrentIndicator>N</isCurrentIndicator></mainName><mainBusinessPhysicalAddress><stateCode>WA</stateCode><postcode>6011</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>11008808197</identifierValue><identifierStatus>Active</identifierStatus></ABN><mainName><organisationName>WINGATE PTY LTD</organisationName><score>82</score><isCurrentIndicator>Y</isCurrentIndicator></mainName><mainBusinessPhysicalAddress><stateCode>WA</stateCode><postcode>6005</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>95085397379</identifierValue><identifierStatus>Active</identifierStatus></ABN><mainName><organisationName>WINQUOTE FINANCE PTY LIMITED</organisationName><score>75</score><isCurrentIndicator>Y</isCurrentIndicator></mainName><mainBusinessPhysicalAddress><stateCode>NSW</stateCode><postcode>2060</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>72636145750</identifierValue><identifierStatus>Active</identifierStatus></ABN><mainName><organisationName>WINGATE ELIXIR HOLDINGS PTY LTD</organisationName><score>73</score><isCurrentIndicator>Y</isCurrentIndicator></mainName><mainBusinessPhysicalAddress><stateCode>VIC</stateCode><postcode>3000</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>67003926930</identifierValue><identifierStatus>Active</identifierStatus></ABN><mainName><organisationName>WANGATE PTY. LIMITED</organisationName><score>71</score><isCurrentIndicator>Y</isCurrentIndicator></mainName><mainBusinessPhysicalAddress><stateCode>NSW</stateCode><postcode>2144</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>86099582448</identifierValue><identifierStatus>Active</identifierStatus></ABN><mainName><organisationName>WYNGATE PTY LTD</organisationName><score>71</score><isCurrentIndicator>Y</isCurrentIndicator></mainName><mainBusinessPhysicalAddress><stateCode>VIC</stateCode><postcode>3166</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord></searchResultsList></response></ABRPayloadSearchResults>';
        mockObj.ints__Response_Status__c = '200 - OK';  
        mockObj.ints__Control_Field_Value__c = 'ABRSearchByNameAdvancedSimpleProtocol2017';  
        mockObj.ints__content_Type__c = 'application/json';
        
        insert mockObj;
        //System.assertequals('12345',mockObj.ints__Control_Field_Value__c);
        
        //Create additional parameter with key 'Control_Field'FOR ABNNAMEAPI_1
        ints__Additional_Parameters__c param = new ints__Additional_Parameters__c();
        param.ints__Key__c = 'Control_Field';
        param.ints__Value__c = 'service';
        param.ints__Integration_Configuration__c = icObj.Id;
        insert param;
        
        
        //INTEGRATION CONFIG FOR ABNNAMEAPI_2
        ints__Integration_Configuration__c integrationObj = new ints__Integration_Configuration__c();
        integrationObj.Name = 'ABN_NameAPI2';
        integrationObj.ints__Integration_Service__c = 'ID Verification';
        integrationObj.ints__Third_Party_System__c = '';
        integrationObj.ints__Type__c = '';
        integrationObj.ints__API_Endpoint__c = 'https://abr.business.gov.au/abrxmlsearch/AbrXmlSearch.asmx/';
        integrationObj.ints__Adaptor_Class__c = 'ABNNameAdapter';
        integrationObj.ints__Active__c = true;
        integrationObj.ints__Authorization_Named_Credential__c = 'ABN_Api';
        integrationObj.ints__Execution_Priority__c = 5;
        integrationObj.ints__Use_Mocker__c = true;
        integrationObj.ints__Request_Mapping__c = '{"thirdPartySystem":{"name":"abnNameRequest","dynamicDataMapping":[{"Alias":"abn_request"}],"filters":[{"tablename":"genesis__Employment_Information__c","tableAlias":"partyInfo","fields":[{"Alias":"companyABN","fieldAPI":"Company_Name__c"}],"whereClause":"Id=:empId"}],"otherParameters":{"service":"ABRSearchByNameAdvancedSimpleProtocol2017","postcode":"","tradingName":"","legalName":"","businessName":"","activeABNsOnly":"","QLD":"","NT":"","SA":"","WA":"","VIC":"","ACT":"","TAS":"","NSW":"","searchWidth":"","minimumScore":"","maxSearchResults":""}}}';
        integrationObj.ints__Response_Mapping__c = '{"StorageConfiguration":{"StoreInDB":"False"},"DMLOperations":[{"DML":"Insert","ObjectMapping":[{"objectName":"ABN_Information__c","objectAlias":"=>response=>businessEntity=>mainName","fields":[{"Alias":"organisationName","fieldAPI":"Organisation_Name__c"}]}]}]}';        
        INSERT integrationObj;
        
        //Mocker Object FOR ABNNAMEAPI_2
        ints__Mocker__c mockerObj = new ints__Mocker__c();
        mockerObj.ints__Integration_Configuration__c = integrationObj.Id;
        mockerObj.ints__Response_Body__c= '<?xml version="1.0" encoding="utf-8"?><ABRPayloadSearchResults xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://abr.business.gov.au/ABRXMLSearch/"><request><nameSearchRequestAdvanced2017><authenticationGUID>c74fa70d-610f-4a9c-9703-2321c82ce510</authenticationGUID><name>Wingate Elixir Financial PYT LTD</name><filters><nameType><tradingName>Y</tradingName><legalName>Y</legalName><businessName>Y</businessName></nameType><postcode /><stateCode><QLD>Y</QLD><NT>Y</NT><SA>Y</SA><WA>Y</WA><VIC>Y</VIC><ACT>Y</ACT><TAS>Y</TAS><NSW>Y</NSW></stateCode><activeABNsOnly>N</activeABNsOnly></filters><searchWidth>Typical</searchWidth><minimumScore>0</minimumScore><maxSearchResults>0</maxSearchResults></nameSearchRequestAdvanced2017></request><response><usageStatement>The Registrar of the ABR monitors the quality of the information available on this website and updates the information regularly. However, neither the Registrar of the ABR nor the Commonwealth guarantee that the information available through this service (including search results) is accurate, up to date, complete or accept any liability arising from the use of or reliance upon this site.</usageStatement><dateRegisterLastUpdated>2019-11-02</dateRegisterLastUpdated><dateTimeRetrieved>2019-11-02T03:16:43.8628047+11:00</dateTimeRetrieved><searchResultsList><numberOfRecords>10</numberOfRecords><exceedsMaximum>N</exceedsMaximum><searchResultsRecord><ABN><identifierValue>27634779990</identifierValue><identifierStatus>Active</identifierStatus></ABN><mainName><organisationName>WINGATE ELIXIR FINANCIAL PTY LTD</organisationName><score>97</score><isCurrentIndicator>Y</isCurrentIndicator></mainName><mainBusinessPhysicalAddress><stateCode>VIC</stateCode><postcode>3000</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>61100137871</identifierValue><identifierStatus>Cancelled</identifierStatus></ABN><mainTradingName><organisationName>ELIXIR FINANCE</organisationName><score>94</score><isCurrentIndicator>Y</isCurrentIndicator></mainTradingName><mainBusinessPhysicalAddress><stateCode>QLD</stateCode><postcode>4000</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>13612262629</identifierValue><identifierStatus>Active</identifierStatus></ABN><mainName><organisationName>ELIXIR FINANCE PTY LIMITED</organisationName><score>94</score><isCurrentIndicator>N</isCurrentIndicator></mainName><mainBusinessPhysicalAddress><stateCode>NSW</stateCode><postcode>2000</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>13612262629</identifierValue><identifierStatus>Active</identifierStatus></ABN><otherTradingName><organisationName>ELIXIR FINANCE PTY LIMITED</organisationName><score>94</score><isCurrentIndicator>N</isCurrentIndicator></otherTradingName><mainBusinessPhysicalAddress><stateCode>NSW</stateCode><postcode>2000</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>13612262629</identifierValue><identifierStatus>Active</identifierStatus></ABN><legalName><fullName>ELIXIR FINANCE PTY LIMITED</fullName><score>94</score><isCurrentIndicator>N</isCurrentIndicator></legalName><mainBusinessPhysicalAddress><stateCode>NSW</stateCode><postcode>2000</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>13612262629</identifierValue><identifierStatus>Active</identifierStatus></ABN><legalName><organisationName>ELIXIR FINANCE PTY LIMITED</organisationName><score>94</score><isCurrentIndicator>N</isCurrentIndicator></legalName><mainBusinessPhysicalAddress><stateCode>NSW</stateCode><postcode>2000</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress><ASICNumber>3400</ASICNumber><entityStatus><effectiveFrom>2019-11-02</effectiveFrom><entityStatusCode>3664</entityStatusCode></entityStatus><entityType><entityDescription>Hello Kitty</entityDescription></entityType><goodsAndServicesTax><effectiveFrom>2019-11-02</effectiveFrom></goodsAndServicesTax></searchResultsRecord><searchResultsRecord><ABN><identifierValue>74604805601</identifierValue><identifierStatus>Active</identifierStatus></ABN><businessName><organisationName>Elixir Financial</organisationName><score>94</score><isCurrentIndicator>Y</isCurrentIndicator></businessName><mainBusinessPhysicalAddress><stateCode>VIC</stateCode><postcode>3004</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>55090504984</identifierValue><identifierStatus>Cancelled</identifierStatus></ABN><mainName><organisationName>WINGATE PTY LTD</organisationName><score>82</score><isCurrentIndicator>N</isCurrentIndicator></mainName><mainBusinessPhysicalAddress><stateCode>WA</stateCode><postcode>6011</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>11008808197</identifierValue><identifierStatus>Active</identifierStatus></ABN><mainName><organisationName>WINGATE PTY LTD</organisationName><score>82</score><isCurrentIndicator>Y</isCurrentIndicator></mainName><mainBusinessPhysicalAddress><stateCode>WA</stateCode><postcode>6005</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>95085397379</identifierValue></ABN><mainName><organisationName>WINQUOTE FINANCE PTY LIMITED</organisationName><score>75</score><isCurrentIndicator>Y</isCurrentIndicator></mainName><mainBusinessPhysicalAddress></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><mainName><organisationName>WINGATE ELIXIR HOLDINGS PTY LTD</organisationName><score>73</score><isCurrentIndicator>Y</isCurrentIndicator></mainName></searchResultsRecord><searchResultsRecord><ABN><identifierValue>72636145750</identifierValue><identifierStatus>Active</identifierStatus></ABN><mainName><organisationName>WINGATE ELIXIR HOLDINGS PTY LTD</organisationName><score>73</score><isCurrentIndicator>Y</isCurrentIndicator></mainName><mainBusinessPhysicalAddress><stateCode>VIC</stateCode><postcode>3000</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>67003926930</identifierValue><identifierStatus>Active</identifierStatus></ABN><mainName><organisationName>WANGATE PTY. LIMITED</organisationName><score>71</score><isCurrentIndicator>Y</isCurrentIndicator></mainName><mainBusinessPhysicalAddress><stateCode>NSW</stateCode><postcode>2144</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord><searchResultsRecord><ABN><identifierValue>86099582448</identifierValue><identifierStatus>Active</identifierStatus></ABN><mainName><organisationName>WYNGATE PTY LTD</organisationName><score>71</score><isCurrentIndicator>Y</isCurrentIndicator></mainName><mainBusinessPhysicalAddress><stateCode>VIC</stateCode><postcode>3166</postcode><isCurrentIndicator>Y</isCurrentIndicator></mainBusinessPhysicalAddress></searchResultsRecord></searchResultsList></response></ABRPayloadSearchResults>';
        mockerObj.ints__Response_Status__c = '200 - OK';  
        mockerObj.ints__Control_Field_Value__c = 'ABRSearchByNameAdvancedSimpleProtocol2017';  
        mockerObj.ints__content_Type__c = 'application/json';        
        insert mockerObj;
        
        //Create additional parameter with key 'Control_Field' FOR ABNNAMEAPI_2
        ints__Additional_Parameters__c xtraparam = new ints__Additional_Parameters__c();
        xtraparam.ints__Key__c = 'Control_Field';
        xtraparam.ints__Value__c = 'service';
        xtraparam.ints__Integration_Configuration__c = integrationObj.Id;
        insert xtraparam;   
    }
    
    //HAPPY FLOW WITH PARTY OBJ
    static testMethod void testCase1(){
        clcommon__Party__c partyObj = [SELECT Id, Name FROM clcommon__Party__c ORDER BY CreatedDate DESC LIMIT 1];
        
        Test.startTest();
        String s = ABNNameCallout.makeABNSkuidCallout(partyObj.id, 'P');
        System.assert(s.equalsIgnoreCase('SUCCESS'));
        Test.stopTest();
    }
    
    //ERROR SCENARIO
    static testMethod void testCase2(){       
        clcommon__Party__c partyObj = [SELECT Id, Name FROM clcommon__Party__c ORDER BY CreatedDate DESC LIMIT 1];
        ints__Mocker__c mockObj = [SELECT id, 
                                          Name 
                                          FROM ints__Mocker__c 
                                          WHERE ints__Integration_Configuration__c =: 
                                          [SELECT Id, 
                                                  Name 
                                                  FROM ints__Integration_Configuration__c 
                                                  WHERE Name = 'ABN_NameAPI'] 
                                          ORDER BY CreatedDate DESC LIMIT 1];
        mockObj.ints__Response_Status__c = '400 - Bad Request';   
        UPDATE mockObj;
        
        
        Test.startTest();
        String s = ABNNameCallout.makeABNSkuidCallout(partyObj.id, 'P');
        System.assert(s.equalsIgnoreCase('SUCCESS') == false );
        Test.stopTest();
             
    }
    
    //HAPPY FLOW WITH EMPLOYMENT OBJ
    static testMethod void TestCase3(){
        genesis__Employment_Information__c empObj = [SELECT Id, Name FROM genesis__Employment_Information__c ORDER BY CreatedDate DESC LIMIT 1];
        ints__Integration_Configuration__c integrationObj = [SELECT Id, Name FROM ints__Integration_Configuration__c ORDER BY CreatedDate DESC LIMIT 1];        
        ints__Mocker__c mockObj = [SELECT id, 
                                          Name 
                                          FROM ints__Mocker__c 
                                          WHERE ints__Integration_Configuration__c =: 
                                          [SELECT Id, 
                                                  Name 
                                                  FROM ints__Integration_Configuration__c 
                                                  WHERE Name = 'ABN_NameAPI2'] 
                                          ORDER BY CreatedDate DESC LIMIT 1];
          

        Test.startTest();
        String s = ABNNameCallout.makeABNSkuidCallout(empObj.id, 'E');
        System.assert(s.contains('Something went wrong'));
        ABNNameCallout.deleteCompanyList(empObj.id, 'E');
        Test.stopTest();
    }
}