/*******************************************************************************************************************
  Class Name        : EquifaxCalloutTest
  Class Description : This test class mostly covers EquifaxCallout class
  Developed By      : Souvik Dey
  Testing Scenario 1  : (testTitleSearchWithMockResponse) This method tests title search API callout by Equifax.
  Testing Scenario 2  : (testOrderDocumentWithMockResponse) This method tests order document API callout by Equifax.
  Testing Scenario 3  : (testDeliverDocumentWithMockResponse) This method tests deliver document API callout by
  Equifax.
  Testing Scenario 4  : (testOrderDocumentWithExceptionMockResponse) This method tests order document API callout
  with response with exception.
  Last Modified Date  : 28/07/2020
  Last Modified By  : Souvik
********************************************************************************************************************/

@isTest
private class EquifaxCalloutTest {
  @TestSetup
  static void initialize() {
    intframework__Integration_Family__c family = GenericUtilityTestHelper.getFamily(
      ConstantValues.EQUIFAX_FAMILY
    );
    // Configuration of Title Search by Address API Integration
    intframework__Integration_API_Type__c apiType = GenericUtilityTestHelper.getIntegrationAPIType(
      family.Id,
      ConstantValues.TITLE_SEARCH_API_TYPE
    );
    intframework__Integration_Provider__c provider = GenericUtilityTestHelper.getIntegrationProvider(
      family.Id,
      'TitleSearch'
    );
    intframework__Integration_Configuration__c config = GenericUtilityTestHelper.getIntegrationConfiguration(
      provider.Id,
      'EquifaxTitleSearch config'
    );
    GenericUtilityTestHelper.getIntegrationAPIConfiguration(
      family.Id,
      apiType.Id,
      provider.Id,
      config.Id,
      'EquifaxSearchTitleByAddressAdapter',
      'POST',
      'EquifaxCredentials',
      '/titleSearchByAddress',
      '{"thirdPartySystem":{"name":"Equifax","dynamicDataParameters":[{"externalField":"equifaxdata"}],"filters":[{"objectAPI":"clcommon__Collateral__c","objectAlias":"collateralInfo","fields":[{"externalField":"unitNo","fieldAPI":"Unit_No__c"},{"externalField":"streetNo","fieldAPI":"Street_No__c"},{"externalField":"streetName","fieldAPI":"Street_Name__c"},{"externalField":"streetType","fieldAPI":"Street_Type__c"},{"externalField":"city","fieldAPI":"clcommon__City__c"},{"externalField":"state","fieldAPI":"clcommon__State__c"},{"externalField":"postalCode","fieldAPI":"clcommon__Postal_Code__c"},{"externalField":"country","fieldAPI":"Country__c"}],"whereClause":"Id = :collateralId"}]}}'
    );
    // Configuration of Order Document API Integration
    apiType = GenericUtilityTestHelper.getIntegrationAPIType(
      family.Id,
      ConstantValues.ORDER_DOCUMENT_API_TYPE
    );
    provider = GenericUtilityTestHelper.getIntegrationProvider(
      family.Id,
      'OrderDocument'
    );
    config = GenericUtilityTestHelper.getIntegrationConfiguration(
      provider.Id,
      'EquifaxOrderDocument config'
    );
    GenericUtilityTestHelper.getIntegrationAPIConfiguration(
      family.Id,
      apiType.Id,
      provider.Id,
      config.Id,
      'EquifaxOrderDocumentAdapter',
      'POST',
      'EquifaxCredentials',
      '/OrderDocument',
      '{"thirdPartySystem":{"name":"Equifax","dynamicDataParameters":[{"externalField":"titleReference"},{"externalField":"testStateRef"},{"externalField":"clientRef"}],"filters":[]}}'
    );
    // Configuration of Deliver Document API Integration
    apiType = GenericUtilityTestHelper.getIntegrationAPIType(
      family.Id,
      ConstantValues.DELIVER_DOCUMENT_API_TYPE
    );
    provider = GenericUtilityTestHelper.getIntegrationProvider(
      family.Id,
      'DeliverDocument'
    );
    config = GenericUtilityTestHelper.getIntegrationConfiguration(
      provider.Id,
      'EquifaxDeliverDocument config'
    );
    GenericUtilityTestHelper.getIntegrationAPIConfiguration(
      family.Id,
      apiType.Id,
      provider.Id,
      config.Id,
      'EquifaxDeliverDocumentAdapter',
      'POST',
      'EquifaxCredentials_stub',
      '/DeliverDocument',
      '{"thirdPartySystem":{"name":"Equifax","dynamicDataParameters":[{"externalField":"enquiryId"},{"externalField":"clientReference"}],"filters":[]}}'
    );
    clcommon__Collateral__c col = GenericUtilityTestHelper.getCollateral(
      '',
      '342',
      'Hammond',
      'Rd',
      'DANDENONG',
      'VIC',
      '3175'
    );
    col.Document_Enquiry_Id__c = '140805-MFNYX-0000O';
    update col;
    List<clcommon__Collateral__c> collaterals = [
      SELECT Id
      FROM clcommon__Collateral__c
    ];
    System.assertEquals(
      collaterals.size(),
      1,
      'Collateral record is not inserted'
    );
    clcommon__Document_Category__c docCat = new clcommon__Document_Category__c();
    docCat.clcommon__Category_Name__c = ConstantValues.TITLE_SEARCH_DOCUMENT_CATEGORY_NAME;
    docCat.clcommon__Collateral__c = col.Id;
    insert docCat;
    List<clcommon__Document_Category__c> docCats = [
      SELECT Id
      FROM clcommon__Document_Category__c
    ];
    System.assertEquals(
      docCats.size(),
      1,
      'Document Category record is not inserted'
    );
    List<intframework__Integration_Family__c> intFamilies = [
      SELECT Id
      FROM intframework__Integration_Family__c
    ];
    System.assertEquals(
      intFamilies.size(),
      1,
      'Integration Family record is not inserted'
    );
    List<intframework__Integration_API_Type__c> intApiTypes = [
      SELECT Id
      FROM intframework__Integration_API_Type__c
    ];
    System.assertEquals(
      intApiTypes.size(),
      3,
      'Integration API Type records are not inserted'
    );
    List<intframework__Integration_Provider__c> intProviders = [
      SELECT Id
      FROM intframework__Integration_Provider__c
    ];
    System.assertEquals(
      intProviders.size(),
      3,
      'Integration Provider records are not inserted'
    );
    List<intframework__Integration_Configuration__c> intConfigs = [
      SELECT Id
      FROM intframework__Integration_Configuration__c
    ];
    System.assertEquals(
      intConfigs.size(),
      3,
      'Integration Configuration records are not inserted'
    );
    List<intframework__Integration_API_Configuration__c> intApiConfigs = [
      SELECT Id
      FROM intframework__Integration_API_Configuration__c
    ];
    System.assertEquals(
      intApiConfigs.size(),
      3,
      'Integration API Configuration records are not inserted'
    );
  }
  @isTest
  static void testTitleSearchWithMockResponse() {
    List<clcommon__Collateral__c> collateralList = [
      SELECT Id
      FROM clcommon__Collateral__c
      LIMIT 1
    ];
    Test.setMock(HttpCalloutMock.class, new Mock());
    Test.startTest();
    String responseString = EquifaxCallout.equifaxTitleSearch(
      collateralList[0].Id,
      true
    );
    Test.stopTest();
    System.assertNotEquals(
      ConstantValues.GENERAL_ERROR,
      responseString,
      'Response fetching error'
    );
  }
  @isTest
  static void testOrderDocumentWithMockResponse() {
    List<clcommon__Collateral__c> collateralList = [
      SELECT Id
      FROM clcommon__Collateral__c
      LIMIT 1
    ];
    Test.setMock(HttpCalloutMock.class, new Mock());
    Test.startTest();
    String responseString = EquifaxCallout.equifaxOrderDocument(
      '1234',
      'VIC',
      collateralList[0].Id,
      true
    );
    Test.stopTest();
    System.assertNotEquals(
      ConstantValues.GENERAL_ERROR,
      responseString,
      'Response fetching error'
    );
  }
  @isTest
  static void testDeliverDocumentWithMockResponse() {
    List<clcommon__Collateral__c> collateralList = [
      SELECT Id
      FROM clcommon__Collateral__c
      LIMIT 1
    ];
    Test.setMock(HttpCalloutMock.class, new Mock());
    Test.startTest();
    String responseString = EquifaxCallout.equifaxDeliverDocument(
      collateralList[0].Id,
      'WAJGH623'
    );
    Test.stopTest();
    List<clcommon__Log__c> logList = [
      SELECT Id, clcommon__Message__c
      FROM clcommon__Log__c
    ];
    for (clcommon__Log__c each : logList) {
      System.debug(each.clcommon__Message__c);
    }
    System.assertEquals(0, logList.size(), 'Exception occurred');
    System.assertNotEquals(
      ConstantValues.GENERAL_ERROR,
      responseString,
      'Response fetching error'
    );
  }
  @isTest
  static void testOrderDocumentWithExceptionMockResponse() {
    List<clcommon__Collateral__c> collateralList = [
      SELECT Id
      FROM clcommon__Collateral__c
      LIMIT 1
    ];
    Test.setMock(HttpCalloutMock.class, new Mock());
    intframework__Integration_API_Configuration__c apiConfig = [
      SELECT Id
      FROM intframework__Integration_API_Configuration__c
      WHERE intframework__Adapter_Class_Name__c = 'EquifaxOrderDocumentAdapter'
    ];
    apiConfig.intframework__API_Endpoint__c = 'ODException';
    update apiConfig;
    Test.startTest();
    String responseString = EquifaxCallout.equifaxOrderDocument(
      '1234',
      'VIC',
      collateralList[0].Id,
      true
    );
    Test.stopTest();
    System.assertEquals(
      ConstantValues.GENERAL_ERROR,
      responseString,
      'Response fetching error'
    );
  }
  /* Mock class returns response from static resource depending on endpoint being called */
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
      WHERE
        Name = :ConstantValues.SAMPLE_TITLE_SEARCH_RES
        OR Name = :ConstantValues.SAMPLE_ORDER_DOCUMENT_RES
        OR Name = :ConstantValues.SAMPLE_DELIVER_DOCUMENT_SUCCESS_RES
        OR Name = 'Sample_Order_Document_Error_Response'
    ];
    for (StaticResource each : srList) {
      responseMap.put(each.Name, each.Body.toString());
    }
    System.debug(endpoint);
    if (endpoint.contains('titleSearchByAddress')) {
      res.setBody(responseMap.get(ConstantValues.SAMPLE_TITLE_SEARCH_RES));
    } else if (endpoint.contains('OrderDocument')) {
      res.setBody(responseMap.get(ConstantValues.SAMPLE_ORDER_DOCUMENT_RES));
    } else if (endpoint.contains('DeliverDocument')) {
      res.setBody(
        responseMap.get(ConstantValues.SAMPLE_DELIVER_DOCUMENT_SUCCESS_RES)
      );
    } else if (endpoint.contains('ODException')) {
      res.setBody(responseMap.get('Sample_Order_Document_Error_Response'));
    } else {
      res.setBody('');
    }
    return res;
  }
}
