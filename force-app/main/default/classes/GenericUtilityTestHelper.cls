/*
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Rameswari Barman
Description: This class provides coverage to PricingUpdateCtrl.
Development Date: 20/7/2020
*/
@isTest
public with sharing class GenericUtilityTestHelper {
    public static clcommon__Legal_Entity__c returnLegalEntity() {
    //Inserting legal entity
    clcommon__Legal_Entity__c legEntity = new clcommon__Legal_Entity__c(
      Name = 'Individual'
    );
    insert legEntity;
    return legEntity;
  }
  public static account insertDummyAccount() {
    account dummyClient2 = new account();
    dummyClient2.Name = 'Elixir';
    insert dummyClient2;
    return dummyClient2;
  }
  public static Contact insertDummyContact(
    Account accountObject
  ) {
    Contact dummyContact = new Contact();
    dummyContact.LastName = 'Elixir';
    dummyContact.accountId = accountObject.Id;
    dummyContact.Account = accountObject;
    insert dummyContact;
    return dummyContact;
  }
  public static Account returnBorrowerAccount(Id legEntityId) {
    //Inserting account
    Account acc = new Account(
      name = 'Dummy Account',
      clcommon__Legal_Entity_Type__c = legEntityId
    );
    insert acc;
    return acc;
  }
  public static clcommon__CL_Product__c returnClProduct() {
    //Inserting cl product
    clcommon__CL_Product__c clProd = new clcommon__CL_Product__c(
      clcommon__Product_Name__c = 'Residential'
    );
    insert clProd;
    return clProd;
  }
  public static genesis__applications__c insertApplication(
    Id accountId,
    Id clProdId){
    genesis__Applications__c app = new genesis__Applications__c();
    app.genesis__CL_Product__c = clProdId;
    app.genesis__Loan_Amount__c = 150000;
    app.Repayment_Type__c = 'Principal and Interest';
    app.Expected_security_value__c = 180000;
    app.Risk_grade_list__c = 'Near Prime +';
    app.Document_Type__c = 'Full Doc';
    app.Interest_type__c = 'Variable';
    insert app;
    return app;
  }
  public static genesis__Rate_Card_Setup_Header__c insertRateHeader() {
    genesis__Rate_Card_Setup_Header__c ratecardHeader = new genesis__Rate_Card_Setup_Header__c();
    ratecardHeader.genesis__Start_Date__c = Date.newInstance(2018, 3, 5);
    ratecardHeader.genesis__Transaction_Date__c = Date.today();
    insert ratecardHeader;
    return ratecardHeader;
  }
  public static genesis__Rate_Card_Setup_Detail__c insertRateCard(
    Id ratecardHeaderId
  ) {
    genesis__Rate_Card_Setup_Detail__c ratecard = new genesis__Rate_Card_Setup_Detail__c();
    ratecard.genesis__Interest_Rate__c = 9;
    ratecard.genesis__Maximum_Financed_Amount__c = 1500000;
    ratecard.genesis__Minimum_Financed_Amount__c = 0;
    ratecard.genesis__Payment_Frequency__c = 'MONTHLY';
    ratecard.genesis__Pricing_Method__c = 'INTEREST RATE';
    ratecard.genesis__Term__c = 12;
    ratecard.genesis__Total_Payments__c = 0;
    ratecard.genesis__Use_Additional_Determining_Factors__c = true;
    ratecard.genesis__Rate_Card_Setup_Header__c = ratecardHeaderId;
    insert ratecard;
    return ratecard;
  }
  public static genesis__Application_Pricing_Detail__c insertApplicationPricingDetail(
    Id appId,
    Id ratecardId
  ) {
    genesis__Application_Pricing_Detail__c pricingDetail = new genesis__Application_Pricing_Detail__c();
    pricingDetail.genesis__Application__c = appId;
    pricingDetail.genesis__Rate_Card_Setup_Detail__c = ratecardId;
    pricingDetail.genesis__Interest_Rate__c = 4.4;
    insert pricingDetail;
    return pricingDetail;
  }
  public static Rendered_Field__c insertRenderedField(
    String name,
    String evaluationExpression,
    String renderedObject
  ){
    return insertRenderedField(name, evaluationExpression, renderedObject, '');
  }
  public static Rendered_Field__c insertRenderedField(
    String name,
    String evaluationExpression,
    String renderedObject,
    String relatedObjectName
  ){
    Rendered_Field__c renderedField = new Rendered_Field__c();
    renderedField.Name = name;
    renderedField.Rendered_Object__c = renderedObject;
    renderedField.Evaluation_Expression__c = evaluationExpression;
    renderedField.Related_Object_Name__c = relatedObjectName;
    insert renderedField;
    return renderedField;
  }
  public static Rendering_Criteria__c insertRenderingCriteria(
    Id renderedFieldId,
    Integer serialNumber,
    String relatedField,
    String matchingType,
    String value
  ){
    Rendering_Criteria__c renderingCriteria = new Rendering_Criteria__c();
    renderingCriteria.Rendered_Field__c = renderedFieldId;
    renderingCriteria.Serial_Number__c = serialNumber;
    renderingCriteria.Related_Field__c = relatedField;
    renderingCriteria.Matching_Type_c__c = matchingType;
    renderingCriteria.Associated_Value__c = value;
    insert renderingCriteria;
    return renderingCriteria;
  }
  public static clcommon__Collateral__c getCollateral(
    String unitNo,
    String streetNo,
    String streetName,
    String streetType,
    String suburb,
    String state,
    String postcode
  ){
    clcommon__Collateral__c collateral = new clcommon__Collateral__c();
    collateral.clcommon__Collateral_Name__c = unitNo + ',' + streetNo + ',' + streetName + ' ' + streetType
    + ',' + suburb + ',' + state + ',' + postcode;
    collateral.Unit_No__c = unitNo;
    collateral.Street_No__c = streetNo;
    collateral.Street_Name__c = streetName;
    collateral.Street_Type__c = streetType;
    collateral.clcommon__City__c = suburb;
    collateral.clcommon__State__c = state;
    collateral.clcommon__Postal_Code__c = postcode;
    insert collateral;
    return collateral;
  }
  // Integration Test Helper
  public static intframework__Integration_Family__c getFamily(String familyName){
    intframework__Integration_Family__c family = new intframework__Integration_Family__c(Name = familyName);
    insert family;
    return family;
  }
  public static intframework__Integration_API_Type__c getIntegrationAPIType(Id familyId, String apiTypeName){
    intframework__Integration_API_Type__c apiType = new intframework__Integration_API_Type__c(
      Name = apiTypeName,
      intframework__Integration_Family__c = familyId
    );
    insert apiType;
    return apiType;
  }
  public static intframework__Integration_Provider__c getIntegrationProvider(
    Id familyId,
    String name
  ) {
    intframework__Integration_Provider__c provider = new intframework__Integration_Provider__c();
    provider.Name = name;
    provider.intframework__Active__c = true;
    provider.intframework__Integration_Family__c = familyId;
    provider.intframework__Product_Name__c = 'testProduct';
    provider.intframework__Product_Version__c = '1.0';
    provider.intframework__Provider_Name__c = 'testProvider';
    provider.intframework__Support_Type__c = 'Custom';
    insert provider;
    return provider;
  }
  public static intframework__Integration_Configuration__c getIntegrationConfiguration(
    Id providerId,
    String name
  ) {
    intframework__Integration_Configuration__c config = new intframework__Integration_Configuration__c();
    config.Name = name;
    config.intframework__Integration_Provider__c = providerId;
    insert config;
    return config;
  }
  public static intframework__Integration_API_Configuration__c getIntegrationAPIConfiguration(
    Id familyId,
    Id apiTypeId,
    Id providerId,
    Id configId,
    String adapterName,
    String method,
    String apiNamedCred,
    String endpoint,
    String requestMappingJSON
  ) {
    intframework__Integration_API_Configuration__c apiConfig = new intframework__Integration_API_Configuration__c();
    apiConfig.Name = 'test_API_Config';
    apiConfig.intframework__Adapter_Class_Name__c = adapterName;
    apiConfig.intframework__Use_Response_Mocker__c = true;
    apiConfig.intframework__HTTP_Method__c = method;
    apiConfig.intframework__API_Named_Credential__c = apiNamedCred;
    apiConfig.intframework__API_Endpoint__c = endpoint;

    apiConfig.intframework__Request_Mapping__c = requestMappingJSON;
    apiConfig.intframework__Response_Mapping__c = '';
    apiConfig.intframework__Integration_Family__c = familyId;
    apiConfig.intframework__Integration_API_Type__c = apiTypeId;
    apiConfig.intframework__Integration_Provider__c = providerId;
    apiConfig.intframework__Integration_Configuration__c = configId;
    insert apiConfig;
    return apiConfig;
  }
}