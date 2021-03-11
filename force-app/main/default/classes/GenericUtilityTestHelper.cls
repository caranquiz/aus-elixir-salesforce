/*
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Rameswari Barman
Description: This class provides coverage to PricingUpdateCtrl.
Development Date: 20/7/2020
Last Modified By : Rameswari Barman
Last Modified Date : 03/02/2021
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
  public static clcommon__Legal_Entity__c returnCompanyLegalEntity() {
    clcommon__Legal_Entity__c legEntity = new clcommon__Legal_Entity__c(
      Name = 'Company'
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
  public static Contact insertDummyContact(Account accountObject) {
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
      clcommon__Legal_Entity_Type__c = legEntityId,
      Bank_Account_Name__c = 'Test',
      BSB__c = '123456',
      Bank_Account_Number__c = '12345678'
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
    Id clProdId
  ) {
    genesis__Applications__c objApplication = new genesis__Applications__c();
    objApplication.genesis__CL_Product__c = clProdId;
    objApplication.genesis__Loan_Amount__c = 150000;
    objApplication.Repayment_Type__c = 'Principal and Interest';
    objApplication.Expected_security_value__c = 180000;
    objApplication.Risk_grade_list__c = 'Near Prime +';
    objApplication.Document_Type__c = 'Full Doc';
    objApplication.Interest_type__c = 'Variable';
    objApplication.genesis__Status__c = 'LOO Accepted';
    objApplication.genesis__Expected_Start_Date__c = System.today();
    objApplication.genesis__Account__c = accountId;
    insert objApplication;
    return objApplication;
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
  ) {
    return insertRenderedField(name, evaluationExpression, renderedObject, '');
  }
  public static Rendered_Field__c insertRenderedField(
    String name,
    String evaluationExpression,
    String renderedObject,
    String relatedObjectName
  ) {
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
  ) {
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
  ) {
    clcommon__Collateral__c collateral = new clcommon__Collateral__c();
    collateral.clcommon__Collateral_Name__c =
      unitNo +
      ',' +
      streetNo +
      ',' +
      streetName +
      ' ' +
      streetType +
      ',' +
      suburb +
      ',' +
      state +
      ',' +
      postcode;
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
  public static intframework__Integration_Family__c getFamily(
    String familyName
  ) {
    intframework__Integration_Family__c family = new intframework__Integration_Family__c(
      Name = familyName
    );
    insert family;
    return family;
  }
  public static intframework__Integration_API_Type__c getIntegrationAPIType(
    Id familyId,
    String apiTypeName
  ) {
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
    apiConfig.intframework__Execution_Priority__c = 1;
    insert apiConfig;
    return apiConfig;
  }
  public static Account createAccount() {
    Account acc = new Account();
    acc.Name = 'Llloyds';
    insert acc;
    return acc;
  }
  public static clcommon__Party__c createParty(Account acc) {
    clcommon__Party__c party = new clcommon__Party__c();
    party.clcommon__Account__c = acc.Id;
    party.ABN_Company_Name__c = 'Llloyds';
    party.Flag_Party__c = false;
    insert party;
    return party;
  }
  public static ABN_Search_SMSF__c createCustomSettingGUID(
    String guid,
    String activeFundsOnly,
    String maxSearchResults
  ) {
    ABN_Search_SMSF__c guidInfo = new ABN_Search_SMSF__c();
    guidInfo.GUID__c = guid;
    guidInfo.Active_Funds_Only__c = activeFundsOnly;
    guidInfo.Maximum_Search_Results__c = maxSearchResults;
    insert guidInfo;
    return guidInfo;
  }
  public static List<genesis__Rule__c> returnRule() {
    genesis__Rule__c ruleOne = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = 'Rule One',
      genesis__Enabled__c = true
    );
    genesis__Rule__c ruleTwo = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = 'Rule Two',
      genesis__Enabled__c = true
    );
    genesis__Rule__c ruleThree = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = 'Rule Three',
      genesis__Enabled__c = true
    );
    List<genesis__Rule__c> ruleLists = new List<genesis__Rule__c>();
    ruleLists.add(ruleOne);
    ruleLists.add(ruleTwo);
    ruleLists.add(ruleThree);
    //Inserting rule
    insert ruleLists;
    return ruleLists;
  }
  public static EquifaxOrdIdSearch__c createCustomSettingCreds(
    String subscriberIdentifier,
    String security
  ) {
    EquifaxOrdIdSearch__c equifaxOrgIdSearchObj = new EquifaxOrdIdSearch__c();
    equifaxOrgIdSearchObj.Subscriber_Identifier__c = subscriberIdentifier;
    equifaxOrgIdSearchObj.Security__c = security;
    insert equifaxOrgIdSearchObj;
    return equifaxOrgIdSearchObj;
  }
  //Inserting Rules, Checklist and Criteria of Rules
  public static List<genesis__Rule__c> returnRule(Id appId) {
    genesis__Rule__c ruleOne = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = 'Cash Out Purpose Suitable Rule',
      genesis__Enabled__c = true,
      genesis__Evaluation_Expression__c = '1',
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.RULE_CLASSIFICATION
    );
    genesis__Rule__c ruleTwo = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = 'Customer Interview completed Rule',
      genesis__Enabled__c = true,
      genesis__Evaluation_Expression__c = '1',
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.RULE_CLASSIFICATION
    );
    genesis__Rule__c ruleThree = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = 'Temporary Visa Suitability Rule',
      genesis__Enabled__c = true,
      genesis__Evaluation_Expression__c = '1',
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.RULE_CLASSIFICATION
    );
    genesis__Rule__c ruleFour = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = 'GST Suitable Rule',
      genesis__Enabled__c = true,
      genesis__Evaluation_Expression__c = '1',
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.RULE_CLASSIFICATION
    );
    genesis__Rule__c ruleFive = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = 'Explanation of Credit Events Suitable Rule',
      genesis__Enabled__c = true,
      genesis__Evaluation_Expression__c = '1 OR 2',
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.RULE_CLASSIFICATION
    );
    genesis__Rule__c ruleSix = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = 'Confirm letter prepared by accountant Rule',
      genesis__Enabled__c = true,
      genesis__Evaluation_Expression__c = '1',
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.RULE_CLASSIFICATION
    );
    genesis__Rule__c ruleSeven = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = 'Living Expense Explanation Suitable Rule',
      genesis__Enabled__c = true,
      genesis__Evaluation_Expression__c = '1',
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.RULE_CLASSIFICATION
    );
    genesis__Rule__c ruleEight = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = 'Income Consistent with Declaration Rule',
      genesis__Enabled__c = true,
      genesis__Evaluation_Expression__c = '1',
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.RULE_CLASSIFICATION
    );
    genesis__Rule__c ruleNine = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = 'Distressed Asset Rule',
      genesis__Enabled__c = true,
      genesis__Evaluation_Expression__c = '1',
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.RULE_CLASSIFICATION
    );
    genesis__Rule__c ruleTen = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = 'Employment Call Suitable Rule',
      genesis__Enabled__c = true,
      genesis__Evaluation_Expression__c = '1',
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.RULE_CLASSIFICATION
    );
    genesis__Rule__c ruleEl = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = 'Explanation of Credit Enquiries Suitable Rule',
      genesis__Enabled__c = true,
      genesis__Evaluation_Expression__c = '1 OR 2 OR 3',
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.RULE_CLASSIFICATION
    );
    genesis__Rule__c ruleTwl = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = 'Trail (%) Exception',
      genesis__Enabled__c = true,
      genesis__Evaluation_Expression__c = '1',
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.EXCEPTION_CLASSIFICATION
    );
    genesis__Rule__c ruleTtn = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = ConstantValues.CUSTOMER_ACCT_CONDITION,
      genesis__Enabled__c = true,
      genesis__Evaluation_Expression__c = '1',
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.CONDITION_CLASSIFICATION
    );
    genesis__Rule__c ruleFrtn = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = ConstantValues.DOES_APPLICANT_UNDERSTAND_ENGLISH_WARNING,
      genesis__Enabled__c = true,
      genesis__Evaluation_Expression__c = '1',
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.CONDITION_CLASSIFICATION
    );
    genesis__Rule__c ruleFftn = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = ConstantValues.BROKER_DOCS_WARNING,
      genesis__Enabled__c = true,
      genesis__Evaluation_Expression__c = '1',
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.WARNING_CLASSIFICATION
    );
    genesis__Rule__c ruleSxtn = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = ConstantValues.MATRIX_RATE_EXCEPTION,
      genesis__Enabled__c = true,
      genesis__Evaluation_Expression__c = '1',
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.EXCEPTION_CLASSIFICATION
    );
    genesis__Rule__c ruleSvntn = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = ConstantValues.RISK_GRADE_COMPARE_WARNING,
      genesis__Enabled__c = true,
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.WARNING_CLASSIFICATION
    );
    genesis__Rule__c ruleEitn = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = ConstantValues.PRIMARY_PURPOSE_WARNING,
      genesis__Enabled__c = true,
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.WARNING_CLASSIFICATION
    );
    genesis__Rule__c ruleNntn = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = ConstantValues.DOCUMENT_TYPE_WARNING,
      genesis__Enabled__c = true,
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.WARNING_CLASSIFICATION
    );
    genesis__Rule__c ruleTnty = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = ConstantValues.VALUATION_PAID_WARNING,
      genesis__Enabled__c = true,
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.WARNING_CLASSIFICATION
    );
    genesis__Rule__c ruleTnty1 = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = ConstantValues.CASHOUT_PURPOSE_RULE,
      genesis__Enabled__c = true,
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.EXCEPTION_CLASSIFICATION
    );
    genesis__Rule__c ruleTnty2 = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = ConstantValues.GIFT_STAT_DEC_RECEIVED_CONDITION,
      genesis__Evaluation_Expression__c = '1',
      genesis__Enabled__c = true,
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.CONDITION_CLASSIFICATION
    );
    genesis__Rule__c ruleTnty3 = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = ConstantValues.TO_BE_REFINANCED_WARNING,
      genesis__Evaluation_Expression__c = '1',
      genesis__Enabled__c = true,
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.CONDITION_CLASSIFICATION
    );
    genesis__Rule__c ruleTnty4 = new genesis__Rule__c(
      genesis__Object_Type__c = 'Application',
      Name = ConstantValues.HMI_STANDARD_CONDITION,
      genesis__Evaluation_Expression__c = '1',
      genesis__Enabled__c = true,
      genesis__Message_failure__c = 'FAILURE',
      genesis__Message_success__c = 'SUCCESS',
      Rule_Classification__c = ConstantValues.CONDITION_CLASSIFICATION
    );

    List<genesis__Rule__c> ruleLists = new List<genesis__Rule__c>();
    ruleLists.add(ruleOne);
    ruleLists.add(ruleTwo);
    ruleLists.add(ruleThree);
    ruleLists.add(ruleFour);
    ruleLists.add(ruleFive);
    ruleLists.add(ruleSix);
    ruleLists.add(ruleSeven);
    ruleLists.add(ruleEight);
    ruleLists.add(ruleNine);
    ruleLists.add(ruleTen);
    ruleLists.add(ruleEl);
    ruleLists.add(ruleTwl);
    ruleLists.add(ruleTtn);
    ruleLists.add(ruleFrtn);
    ruleLists.add(ruleFftn);
    ruleLists.add(ruleSxtn);
    ruleLists.add(ruleSvntn);
    ruleLists.add(ruleEitn);
    ruleLists.add(ruleNntn);
    ruleLists.add(ruleTnty);
    ruleLists.add(ruleTnty1);
    ruleLists.add(ruleTnty2);
    ruleLists.add(ruleTnty3);
    ruleLists.add(ruleTnty4);
    //Inserting rule
    insert ruleLists;
    List<genesis__RuleCriteria__c> criteriaList = new List<genesis__RuleCriteria__c>();
    genesis__RuleCriteria__c criteriaOne = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 1,
      genesis__Rule__c = ruleLists[0].Id,
      genesis__Related_Object__c = 'genesis__Applications__c',
      genesis__Rule_Object_Reference__c = 'genesis__applications__c',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Cash Out Purpose Suitable',
      genesis__Field_API_Name__c = 'Cash_Out_Purpose_Suitable__c',
      genesis__Field_Type__c = 'Picklist',
      genesis__Matching_Type__c = '==',
      genesis__Matching_Value__c = 'Yes'
    );
    genesis__RuleCriteria__c criteriaTwo = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 1,
      genesis__Rule__c = ruleLists[1].Id,
      genesis__Related_Object__c = 'genesis__Applications__c',
      genesis__Rule_Object_Reference__c = 'genesis__applications__c',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Customer Interview completed',
      genesis__Field_API_Name__c = 'Customer_Interview_completed__c',
      genesis__Field_Type__c = 'Picklist',
      genesis__Matching_Type__c = '==',
      genesis__Matching_Value__c = 'Yes'
    );
    genesis__RuleCriteria__c criteriaThree = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 1,
      genesis__Rule__c = ruleLists[2].Id,
      genesis__Related_Object__c = 'clcommon__Party__c',
      genesis__Rule_Object_Reference__c = 'genesis__applications__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Temporary Visa Suitability',
      genesis__Field_API_Name__c = 'clcommon__Contact__r.Temporary_Visa_Suitability__c',
      genesis__Field_Type__c = 'Picklist',
      genesis__Matching_Type__c = '==',
      genesis__Matching_Value__c = 'Yes'
    );
    genesis__RuleCriteria__c criteriaFour = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 1,
      genesis__Rule__c = ruleLists[4].Id,
      genesis__Related_Object__c = 'clcommon__Party__c',
      genesis__Rule_Object_Reference__c = 'genesis__applications__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Explanation of Credit Events Suitable',
      genesis__Field_API_Name__c = 'Explanation_of_Credit_Events_Suitable__c',
      genesis__Field_Type__c = 'Picklist',
      genesis__Matching_Type__c = '==',
      genesis__Matching_Value__c = 'Yes'
    );
    genesis__RuleCriteria__c criteriaSeven = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 1,
      genesis__Rule__c = ruleLists[6].Id,
      genesis__Related_Object__c = 'genesis__Income__c',
      genesis__Rule_Object_Reference__c = 'genesis__Application__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Income Consistent with Declaration',
      genesis__Field_API_Name__c = 'Income_Consistent_with_Declaration__c',
      genesis__Field_Type__c = 'PICKLIST',
      genesis__Matching_Type__c = '==',
      genesis__Matching_Value__c = 'Yes'
    );
    genesis__RuleCriteria__c criteriaNine = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 1,
      genesis__Rule__c = ruleLists[8].Id,
      genesis__Related_Object__c = 'genesis__Application_Collateral__c',
      genesis__Rule_Object_Reference__c = 'genesis__applications__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Distressed Asset Rule Check',
      genesis__Field_API_Name__c = 'genesis__Collateral__r.Distressed_Asset_Rule_Check__c',
      genesis__Field_Type__c = 'String',
      genesis__Matching_Type__c = '==',
      genesis__Matching_Value__c = 'TRUE'
    );
    genesis__RuleCriteria__c criteriaTen = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 1,
      genesis__Rule__c = ruleLists[9].Id,
      genesis__Related_Object__c = 'genesis__Employment_Information__c',
      genesis__Rule_Object_Reference__c = 'genesis__Application__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Employment Call Suitable',
      genesis__Field_API_Name__c = 'Employment_Call_Suitable__c',
      genesis__Field_Type__c = 'Picklist',
      genesis__Matching_Type__c = '==',
      genesis__Matching_Value__c = 'Yes'
    );
    genesis__RuleCriteria__c criteriaEl = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 1,
      genesis__Rule__c = ruleLists[10].Id,
      genesis__Related_Object__c = 'clcommon__Party__c',
      genesis__Rule_Object_Reference__c = 'genesis__Application__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Number of Credit Enquiries in Last 12 Mo',
      genesis__Field_API_Name__c = 'Number_of_Credit_Enquiries_in_Last_12_Mo__c',
      genesis__Field_Type__c = 'Double',
      genesis__Matching_Type__c = '>=',
      genesis__Matching_Value__c = '1'
    );
    genesis__RuleCriteria__c criteriaFive = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 2,
      genesis__Rule__c = ruleLists[10].Id,
      genesis__Related_Object__c = 'clcommon__Party__c',
      genesis__Rule_Object_Reference__c = 'genesis__Application__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Number of Credit Enquiries in Last 12 Mo',
      genesis__Field_API_Name__c = 'Number_of_Credit_Enquiries_in_Last_12_Mo__c',
      genesis__Field_Type__c = 'Double',
      genesis__Matching_Type__c = '==',
      genesis__Matching_Value__c = '1'
    );
    genesis__RuleCriteria__c criteriaEight = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 3,
      genesis__Rule__c = ruleLists[10].Id,
      genesis__Related_Object__c = 'clcommon__Party__c',
      genesis__Rule_Object_Reference__c = 'genesis__Application__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Number of Credit Enquiries in Last 12 Mo',
      genesis__Field_API_Name__c = 'Number_of_Credit_Enquiries_in_Last_12_Mo__c',
      genesis__Field_Type__c = 'Double',
      genesis__Matching_Type__c = '<=',
      genesis__Matching_Value__c = '1'
    );
    genesis__RuleCriteria__c criteriaSix = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 2,
      genesis__Rule__c = ruleLists[4].Id,
      genesis__Related_Object__c = 'clcommon__Party__c',
      genesis__Rule_Object_Reference__c = 'genesis__Application__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Number Of Dependents',
      genesis__Field_API_Name__c = 'clcommon__Contact__r.Number_Of_Dependents__c',
      genesis__Field_Type__c = 'Double',
      genesis__Matching_Type__c = '<=',
      genesis__Matching_Value__c = '10'
    );
    // genesis__RuleCriteria__c criteriaTwl = new genesis__RuleCriteria__c(
    //   genesis__Criteria_Sequence__c = 2,
    //   genesis__Rule__c = ruleLists[11].Id,
    //   genesis__Related_Object__c = 'clcommon__Party__c',
    //   genesis__Rule_Object_Reference__c = 'genesis__Application__r',
    //   genesis__Stipulation_Type__c = 'FUNDING',
    //   genesis__Field_Name__c = 'Party Type Name',
    //   genesis__Field_API_Name__c = 'Party_Type_Name__c',
    //   genesis__Field_Type__c = 'String',
    //   genesis__Matching_Type__c = '!=',
    //   genesis__Matching_Value__c = 'Broker'
    // );
    genesis__RuleCriteria__c criteriaTtn = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 1,
      genesis__Rule__c = ruleLists[11].Id,
      genesis__Related_Object__c = 'clcommon__Party__c',
      genesis__Rule_Object_Reference__c = 'genesis__Application__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Document Type',
      genesis__Field_API_Name__c = 'Document_Type__c',
      genesis__Field_Type__c = 'PICKLIST',
      genesis__Matching_Type__c = '!=',
      genesis__Matching_Value__c = 'Full'
    );
    genesis__RuleCriteria__c criteriaFrtn = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 1,
      genesis__Rule__c = ruleLists[12].Id,
      genesis__Related_Object__c = 'clcommon__Party__c',
      genesis__Rule_Object_Reference__c = 'genesis__Application__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Document Type',
      genesis__Field_API_Name__c = 'Document_Type__c',
      genesis__Field_Type__c = 'STRING',
      genesis__Matching_Type__c = '!=',
      genesis__Matching_Value__c = 'Full'
    );
    genesis__RuleCriteria__c criteriaFftn = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 1,
      genesis__Rule__c = ruleLists[13].Id,
      genesis__Related_Object__c = 'clcommon__Party__c',
      genesis__Rule_Object_Reference__c = 'genesis__Application__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Does applicant understand English',
      genesis__Field_API_Name__c = 'Does_applicant_understand_English__c',
      genesis__Field_Type__c = 'PICKLIST',
      genesis__Matching_Type__c = '!=',
      genesis__Matching_Value__c = 'No'
    );
    genesis__RuleCriteria__c criteriaSxtn = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 1,
      genesis__Rule__c = ruleLists[14].Id,
      genesis__Related_Object__c = 'clcommon__Party__c',
      genesis__Rule_Object_Reference__c = 'genesis__Application__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Has Broker provided a fully completed Cu',
      genesis__Field_API_Name__c = 'Has_Broker_provided_a_fully_completed_Cu__c',
      genesis__Field_Type__c = 'PICKLIST',
      genesis__Matching_Type__c = '==',
      genesis__Matching_Value__c = 'Yes'
    );
    genesis__RuleCriteria__c criteriaSvntn = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 1,
      genesis__Rule__c = ruleLists[15].Id,
      genesis__Related_Object__c = 'clcommon__Party__c',
      genesis__Rule_Object_Reference__c = 'genesis__Application__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Matrix Rate Exception Check',
      genesis__Field_API_Name__c = 'Matrix_Rate_Exception_Check__c',
      genesis__Field_Type__c = 'STRING',
      genesis__Matching_Type__c = '!=',
      genesis__Matching_Value__c = 'G'
    );
    genesis__RuleCriteria__c criteriaEittn = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 1,
      genesis__Rule__c = ruleLists[20].Id,
      genesis__Related_Object__c = 'genesis__Applications__c',
      genesis__Rule_Object_Reference__c = 'genesis__Application__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Cash Out Purpose Suitable Rule Check',
      genesis__Field_API_Name__c = 'Cash_Out_Purpose_Suitable_Rule_Check__c',
      genesis__Field_Type__c = 'BOOLEAN',
      genesis__Matching_Type__c = '==',
      genesis__Matching_Value__c = 'FALSE'
    );
    genesis__RuleCriteria__c criteriaNntn = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 1,
      genesis__Rule__c = ruleLists[21].Id,
      genesis__Related_Object__c = 'genesis__Asset_Information__c',
      genesis__Rule_Object_Reference__c = 'genesis__Application__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Asset Type',
      genesis__Field_API_Name__c = 'genesis__Asset_Type__c',
      genesis__Field_Type__c = 'PICKLIST',
      genesis__Matching_Type__c = '!=',
      genesis__Matching_Value__c = 'Gifts'
    );
    genesis__RuleCriteria__c criteriaTnty = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 1,
      genesis__Rule__c = ruleLists[22].Id,
      genesis__Related_Object__c = 'genesis__Liability__c',
      genesis__Rule_Object_Reference__c = 'genesis__Application__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'To Be Refinanced',
      genesis__Field_API_Name__c = 'To_Be_Refinanced__c',
      genesis__Field_Type__c = 'BOOLEAN',
      genesis__Matching_Type__c = '==',
      genesis__Matching_Value__c = 'FALSE'
    );
    genesis__RuleCriteria__c criteriaThrty = new genesis__RuleCriteria__c(
      genesis__Criteria_Sequence__c = 1,
      genesis__Rule__c = ruleLists[23].Id,
      genesis__Related_Object__c = 'genesis__Application_Collateral__c',
      genesis__Rule_Object_Reference__c = 'genesis__Application__r',
      genesis__Stipulation_Type__c = 'FUNDING',
      genesis__Field_Name__c = 'Replacement Type',
      genesis__Field_API_Name__c = 'genesis__Collateral__r.Replacement_Type__c',
      genesis__Field_Type__c = 'PICKLIST',
      genesis__Matching_Type__c = '!=',
      genesis__Matching_Value__c = 'Standard'
    );
    List<genesis__Checklist__c> checkList = new List<genesis__Checklist__c>();

    genesis__Checklist__c eachCheckList1 = new genesis__Checklist__c(
      genesis__Application__c = appId,
      genesis__Assessed_Record_Id__c = appId,
      genesis__Is_Archived__c = false,
      genesis__Level__c = 'ERROR',
      genesis__Message__c = 'FAIL',
      genesis__Rule__c = ruleOne.Id,
      genesis__Type__c = 'Business Rule'
    );
    genesis__Checklist__c eachCheckList2 = new genesis__Checklist__c(
      genesis__Application__c = appId,
      genesis__Assessed_Record_Id__c = appId,
      genesis__Is_Archived__c = false,
      genesis__Level__c = 'ERROR',
      genesis__Message__c = 'FAIL',
      genesis__Rule__c = ruleTwo.Id,
      genesis__Type__c = 'Business Rule'
    );
    genesis__Checklist__c eachCheckList3 = new genesis__Checklist__c(
      genesis__Application__c = appId,
      genesis__Assessed_Record_Id__c = appId,
      genesis__Is_Archived__c = false,
      genesis__Level__c = 'ERROR',
      genesis__Message__c = 'FAIL',
      genesis__Rule__c = ruleThree.Id,
      genesis__Type__c = 'Business Rule'
    );
    genesis__Checklist__c eachCheckList4 = new genesis__Checklist__c(
      genesis__Application__c = appId,
      genesis__Assessed_Record_Id__c = appId,
      genesis__Is_Archived__c = false,
      genesis__Level__c = 'ERROR',
      genesis__Message__c = 'FAIL',
      genesis__Rule__c = ruleFive.Id,
      genesis__Type__c = 'Business Rule'
    );
    genesis__Checklist__c eachCheckList5 = new genesis__Checklist__c(
      genesis__Application__c = appId,
      genesis__Assessed_Record_Id__c = appId,
      genesis__Is_Archived__c = false,
      genesis__Level__c = 'ERROR',
      genesis__Message__c = 'FAIL',
      genesis__Rule__c = ruleSeven.Id,
      genesis__Type__c = 'Business Rule'
    );
    genesis__Checklist__c eachCheckList6 = new genesis__Checklist__c(
      genesis__Application__c = appId,
      genesis__Assessed_Record_Id__c = appId,
      genesis__Is_Archived__c = false,
      genesis__Level__c = 'ERROR',
      genesis__Message__c = 'FAIL',
      genesis__Rule__c = ruleNine.Id,
      genesis__Type__c = 'Business Rule'
    );
    genesis__Checklist__c eachCheckList7 = new genesis__Checklist__c(
      genesis__Application__c = appId,
      genesis__Assessed_Record_Id__c = appId,
      genesis__Is_Archived__c = false,
      genesis__Level__c = 'ERROR',
      genesis__Message__c = 'FAIL',
      genesis__Rule__c = ruleTen.Id,
      genesis__Type__c = 'Business Rule'
    );
    genesis__Checklist__c eachCheckList8 = new genesis__Checklist__c(
      genesis__Application__c = appId,
      genesis__Assessed_Record_Id__c = appId,
      genesis__Is_Archived__c = false,
      genesis__Level__c = 'ERROR',
      genesis__Message__c = 'FAIL',
      genesis__Rule__c = ruleEl.Id,
      genesis__Type__c = 'Business Rule'
    );
    genesis__Checklist__c eachCheckList9 = new genesis__Checklist__c(
      genesis__Application__c = appId,
      genesis__Assessed_Record_Id__c = appId,
      genesis__Is_Archived__c = false,
      genesis__Level__c = 'ERROR',
      genesis__Message__c = 'FAIL',
      genesis__Rule__c = ruleTwl.Id,
      genesis__Type__c = 'Business Rule'
    );
    genesis__Checklist__c eachCheckList10 = new genesis__Checklist__c(
      genesis__Application__c = appId,
      genesis__Assessed_Record_Id__c = appId,
      genesis__Is_Archived__c = false,
      genesis__Level__c = 'ERROR',
      genesis__Message__c = 'FAIL',
      genesis__Rule__c = ruleTtn.Id,
      genesis__Type__c = 'Business Rule'
    );
    genesis__Checklist__c eachCheckList11 = new genesis__Checklist__c(
      genesis__Application__c = appId,
      genesis__Assessed_Record_Id__c = appId,
      genesis__Is_Archived__c = false,
      genesis__Level__c = 'ERROR',
      genesis__Message__c = 'FAIL',
      genesis__Rule__c = ruleFrtn.Id,
      genesis__Type__c = 'Business Rule'
    );
    genesis__Checklist__c eachCheckList12 = new genesis__Checklist__c(
      genesis__Application__c = appId,
      genesis__Assessed_Record_Id__c = appId,
      genesis__Is_Archived__c = false,
      genesis__Level__c = 'ERROR',
      genesis__Message__c = 'FAIL',
      genesis__Rule__c = ruleFftn.Id,
      genesis__Type__c = 'Business Rule'
    );
    genesis__Checklist__c eachCheckList13 = new genesis__Checklist__c(
      genesis__Application__c = appId,
      genesis__Assessed_Record_Id__c = appId,
      genesis__Is_Archived__c = false,
      genesis__Level__c = 'ERROR',
      genesis__Message__c = 'FAIL',
      genesis__Rule__c = ruleSxtn.Id,
      genesis__Type__c = 'Business Rule'
    );
    genesis__Checklist__c eachCheckList14 = new genesis__Checklist__c(
      genesis__Application__c = appId,
      genesis__Assessed_Record_Id__c = appId,
      genesis__Is_Archived__c = false,
      genesis__Level__c = 'ERROR',
      genesis__Message__c = 'FAIL',
      genesis__Rule__c = ruleTnty1.Id,
      genesis__Type__c = 'Business Rule'
    );
    genesis__Checklist__c eachCheckList15 = new genesis__Checklist__c(
      genesis__Application__c = appId,
      genesis__Assessed_Record_Id__c = appId,
      genesis__Is_Archived__c = false,
      genesis__Level__c = 'ERROR',
      genesis__Message__c = 'FAIL',
      genesis__Rule__c = ruleTnty2.Id,
      genesis__Type__c = 'Business Rule'
    );
    genesis__Checklist__c eachCheckList16 = new genesis__Checklist__c(
      genesis__Application__c = appId,
      genesis__Assessed_Record_Id__c = appId,
      genesis__Is_Archived__c = false,
      genesis__Level__c = 'ERROR',
      genesis__Message__c = 'FAIL',
      genesis__Rule__c = ruleTnty3.Id,
      genesis__Type__c = 'Business Rule'
    );
    genesis__Checklist__c eachCheckList17 = new genesis__Checklist__c(
      genesis__Application__c = appId,
      genesis__Assessed_Record_Id__c = appId,
      genesis__Is_Archived__c = false,
      genesis__Level__c = 'ERROR',
      genesis__Message__c = 'FAIL',
      genesis__Rule__c = ruleTnty4.Id,
      genesis__Type__c = 'Business Rule'
    );

    //checkList.add(eachCheckList1);
    //checkList.add(eachCheckList2);
    checkList.add(eachCheckList3);
    checkList.add(eachCheckList4);
    checkList.add(eachCheckList5);
    checkList.add(eachCheckList6);
    checkList.add(eachCheckList7);
    checkList.add(eachCheckList8);
    checkList.add(eachCheckList9);
    checkList.add(eachCheckList10);
    checkList.add(eachCheckList11);
    checkList.add(eachCheckList12);
    checkList.add(eachCheckList13);
    checkList.add(eachCheckList14);
    checkList.add(eachCheckList15);
    checkList.add(eachCheckList16);
    checkList.add(eachCheckList17);
    //criteriaList.add(criteriaOne);
    //criteriaList.add(criteriaTwo);
    criteriaList.add(criteriaThree);
    criteriaList.add(criteriaFour);
    criteriaList.add(criteriaFive);
    criteriaList.add(criteriaSix);
    criteriaList.add(criteriaSeven);
    criteriaList.add(criteriaEight);
    criteriaList.add(criteriaNine);
    criteriaList.add(criteriaTen);
    criteriaList.add(criteriaEl);
    // criteriaList.add(criteriaTwl);
    criteriaList.add(criteriaTtn);
    criteriaList.add(criteriaFrtn);
    criteriaList.add(criteriaFftn);
    criteriaList.add(criteriaSxtn);
    criteriaList.add(criteriaSvntn);
    criteriaList.add(criteriaEittn);
    criteriaList.add(criteriaNntn);
    criteriaList.add(criteriaTnty);
    criteriaList.add(criteriaThrty);
    insert checkList;
    insert criteriaList;
    return ruleLists;
  }
  //Inserting Employment and Income
  public static genesis__Employment_Information__c returnEmploymentInformation(
    Id appId
  ) {
    genesis__Employment_Information__c employmentInfo = new genesis__Employment_Information__c(
      genesis__Application__c = appId
    );
    insert employmentInfo;
    return employmentInfo;
  }
  //Inserting Asset Information
  public static genesis__Asset_Information__c returnAssetInformation(
    Id appId
  ) {
    genesis__Asset_Information__c assetInfo = new genesis__Asset_Information__c(
      genesis__Application__c = appId
    );
    insert assetInfo;
    return assetInfo;
  }
  //Inserting Liability
  public static genesis__Liability__c returnLiability(
    Id appId
  ) {
    genesis__Liability__c liability = new genesis__Liability__c(
      genesis__Application__c = appId
    );
    insert liability;
    return liability;
  }
  //Inserting Income
  public static genesis__Income__c returnEmploymentInformation(
    Id appId,
    Id empInfo
  ) {
    genesis__Income__c income = new genesis__Income__c(
      genesis__Application__c = appId,
      Employment_Information__c = empInfo
    );
    insert income;
    return income;
  }
  //Inserting application collateral
  public static genesis__Application_Collateral__c returnAppCollateral(
    Id appId,
    Id borrowerId
  ) {
    clcommon__Collateral__c collateral = new clcommon__Collateral__c(
      clcommon__Address__c = 'Jes Road',
      clcommon__Collateral_Name__c = 'COL1',
      clcommon__City__c = 'Kolata',
      clcommon__Postal_Code__c = '22222',
      clcommon__Value__c = 0
    );
    insert collateral;
    genesis__Application_Collateral__c appCollateral = new genesis__Application_Collateral__c(
      genesis__Application__c = appId,
      genesis__Collateral__c = collateral.Id,
      genesis__Pledge_Amount__c = 0
    );
    insert appCollateral;
    clcommon__Collateral_Owner__c collateralOwner = new clcommon__Collateral_Owner__c(
      clcommon__Collateral__c = collateral.Id,
      clcommon__Ownership__c = 0,
      clcommon__Account__c = borrowerId
    );
    insert collateralOwner;
    return appCollateral;
  }
  public static clcommon__Address__c returnAddress() {
    clcommon__Address__c addressObj = new clcommon__Address__c();
    addressObj.clcommon__County__c = '12';
    addressObj.Street_No__c = '21';
    addressObj.Street_Name__c = 'XYZ';
    addressObj.Street_Type__c = 'Street';
    addressObj.clcommon__City__c = 'Street';
    addressObj.State__c = 'Street';
    addressObj.clcommon__Zip_Code__c = 'Street';
    addressObj.clcommon__Country__c = 'Australia';
    insert addressObj;
    return addressObj;
  }
  //Inserting an LPT
  public static loan__Loan_Payment_Transaction__c returnLoanPayment(
    loan__Loan_Account__c contractObj,
    Id paymentModeId,
    Decimal interest,
    Decimal totalAmount
  ) {
    loan__Loan_Payment_Transaction__c loanPayment = new loan__Loan_Payment_Transaction__c();
    loanPayment.loan__Transaction_Amount__c = totalAmount;
    loanPayment.loan__Interest__c = interest;
    loanPayment.loan__Loan_Account__c = contractObj.id;
    loanPayment.loan__Payment_Application_Mode__c = paymentModeId;
    insert loanPayment;
    return loanPayment;
  }

  //Inserting warehouse
  public static Warehouse__c returnWarehouse() {
    Warehouse__c ware = new Warehouse__c(Institution_Name__c = 'Warehouse');
    ware.Bank_Account_Name__c = 'Test';
    ware.BSB_Number__c = '123456';
    ware.Bank_Account_Number__c = '8890231';
    ware.Collection_Bank_Account_Name__c = 'Test';
    ware.Collection_Bank_Account_Number__c = '1234567';
    ware.Collection_BSB_Number__c = '343655';
    insert ware;
    return ware;
  }
  //Inserting Party
  public static clcommon__Party__c returnParty(Id appId, Id account) {
    clcommon__Party__c party = new clcommon__Party__c(
      genesis__Application__c = appId,
      clcommon__Account__c = account
    );
    insert party;
    return party;
  }
  public static loan__Loan_Account__c returnLoanAccount() {
    loan.TestHelper.createSeedDataForTesting();

    loan__Currency__c curr = loan.TestHelper.createCurrency();
    //Create a dummy MF_Account
    loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount(
      'XXXAccountForTest',
      '10000 - ASSETS'
    );
    loan__MF_Account__c dummyIncAccount = loan.TestHelper.createMFAccount(
      'XXXIncAccountForTest',
      '30000 - INCOME'
    );

    //Create a Fee Set
    loan__Fee__c dummyFee = loan.TestHelper.createFee(
      curr,
      dummyIncAccount,
      dummyAccount
    );
    loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
    loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(
      dummyFee,
      dummyFeeSet
    );

    loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();

    //Create a dummy Loan Product
    loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(
      dummyOffice,
      dummyAccount,
      curr,
      dummyFeeSet
    );

    loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();
    dummyLoanPurpose.loan__Loan_Purpose_Code__c = 'Refinance';
    upsert dummyLoanPurpose;

    account dummyClient = new account();
    dummyClient.Name = 'Pegasus';
    insert dummyClient;

    //Create a dummy Loan Account
    loan__Loan_Account__c loanAccount = loan.TestHelper.createLoanAccountForAccountObj(
      dummyLP,
      dummyClient,
      dummyFeeSet,
      dummyLoanPurpose,
      dummyOffice
    );
    loanAccount.loan__Number_of_Installments__c = 12;
    loanAccount.Loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUS_APPROVED;
    loanAccount.Loan__Fees_Remaining__c = 100;
    loanAccount.Loan__Interest_Remaining__c = 500;
    loanAccount.Loan__Principal_Remaining__c = 1000;
    loanAccount.Loan__Fractionalization_Status__c = loan.LoanConstants.FRACTIONALIZATION_STATUS_ACTIVE;
    loanAccount.Loan__Pay_off_Amount_As_Of_Today__c =
      loanAccount.loan__Fees_Remaining__c +
      loanAccount.loan__Principal_Remaining__c;

    return loanAccount;
  }
  public static Account getAccount() {
    Account testAccount = new Account();
    testAccount.loan__Active__c = 'Yes';
    testAccount.loan__Borrower__c = true;
    testAccount.Name = 'Test';
    testAccount.BillingPostalcode = '1234';
    testAccount.BillingCity = 'TestCity';
    insert testAccount;
    return testAccount;
  }
  public static Contact getContact(Account testAccount) {
    Contact testContact = new Contact();
    testContact.AccountId = testAccount.id;
    testContact.LastName = 'Test';
    insert testContact;
    return testContact;
  }
  public static loan__Bank_Account__c getBankAccount(Account testAccount) {
    loan__Bank_Account__c testPayeebankAccount = new loan__Bank_Account__c();
    testPayeebankAccount.loan__Bank_Name__c = 'PayeeBank';
    testPayeebankAccount.BSB_Number__c = '324089';
    testPayeebankAccount.Bank_Account_Name__c = 'Test';
    testPayeebankAccount.loan__Bank_Account_Number__c = '234567700';
    testPayeebankAccount.loan__Account__c = testAccount.Id;
    testPayeebankAccount.loan__Active__c = true;
    insert testPayeebankAccount;
    return testPayeebankAccount;
  }
  public static loan__Bank_Account__c getPayerBankAccount(Account testAccount) {
    loan__Bank_Account__c testPayerbankAccount = new loan__Bank_Account__c();
    testPayerbankAccount.loan__Bank_Name__c = 'PayerBank';
    testPayerbankAccount.BSB_Number__c = '453009';
    testPayerbankAccount.loan__Bank_Account_Number__c = '770065432';
    testPayerbankAccount.Bank_Account_Name__c = 'Test';
    testPayerbankAccount.loan__Account__c = testAccount.Id;
    testPayerbankAccount.loan__Active__c = true;
    insert testPayerbankAccount;
    return testPayerbankAccount;
  }
  public static loan__Payment_Mode__c getPaymentMode() {
    loan__Payment_Mode__c testDDPaymentMode = new loan__Payment_Mode__c();
    testDDPaymentMode.Name = 'Direct Debit';
    insert testDDPaymentMode;
    return testDDPaymentMode;
  }
  public static loan__Automated_Payment_Configuration__c getAPC(
    loan__Payment_Mode__c testDDPaymentMode,
    loan__Bank_Account__c testPayeebankAccount
  ) {
    loan__Automated_Payment_Configuration__c apc = new loan__Automated_Payment_Configuration__c();
    apc.loan__Folder_Name__c = 'ACH Documents';
    apc.loan__Payment_Mode__c = testDDPaymentMode.Id;
    apc.loan__File_Type__c = 'Text';
    apc.loan__Event__c = 'LOAN PAYMENT';
    apc.loan__Active__c = true;
    apc.loan__Filegen_Class__c = 'LoanPaymentTransactionFileGen';
    apc.Name_of_User__c = 'AJAX CRACKERS';
    apc.Remitter_Name__c = 'AJAX CRACKERS';
    apc.loan__Bank_Account__c = testPayeebankAccount.Id;
    apc.User_Financial_Institution_Name__c = 'NAB';
    apc.User_Id__c = '013095';
    insert apc;
    return apc;
  }
  //Inserting loan warehouse
  public static Loan_Warehouse__c returnLoanWarehouse(Id ware, Id app) {
    Loan_Warehouse__c wh = new Loan_Warehouse__c(
      Warehouse__c = ware,
      Application__c = app
    );
    wh.Active__c = true;
    insert wh;
    return wh;
  }

  public static genesis__applications__c returnApplication(Id accId) {
    //Inserting application
    genesis__applications__c app = new genesis__applications__c(
      genesis__account__c = accId
    );
    app.genesis__Interest_Rate__c = 10;
    app.genesis__Loan_Amount__c = 100000;
    //************
    app.genesis__Initial_Advance__c = 90000;
    app.First_Tranche_Prepaid_Interest__c = 5000;
    app.Subsequent_Drawdown__c = 90000;
    app.Drawdown_Prepaid_Interest__c = 1000;
    app.Construction_Progress_Payment_Fee__c = 3000;
    //************/
    app.genesis__Status__c = 'APPROVED';
    app.genesis__Expected_Start_Date__c = Date.Today();
    //***********/
    app.genesis__Payment_Frequency__c = 'Monthly';
    app.Drawdown_Prepaid_Interest__c = 1000;
    insert app;
    return app;
  }

  public static genesis__Conversion_Mapping_Header__c conversionMapping() {
    genesis__Conversion_Mapping_Header__c conHead = new genesis__Conversion_Mapping_Header__c();
    conHead.genesis__Product_Type__c = 'LOAN';
    insert conHead;
    return conHead;
  }

  public static genesis__Conversion_Mapping__c returnConversionMapping(
    Id conHead,
    String sourceObject,
    String sourceField,
    String DestinationObject,
    String DestinationField
  ) {
    genesis__Conversion_Mapping__c conMap = new genesis__Conversion_Mapping__c();
    conMap.genesis__Conversion_Mapping_Header__c = conHead;
    conMap.genesis__Product_Type__c = 'LOAN';
    conMap.genesis__Application_Object_Name__c = sourceObject;
    conMap.genesis__Application_Field_Name__c = sourceField;
    conMap.genesis__Contract_Object_Name__c = DestinationObject;
    conMap.genesis__Contract_Field_Name__c = DestinationField;
    return conMap;
  }

  public static loan__Payment_Mode__c loanPaymentMode() {
    loan__Payment_Mode__c pmt = new loan__Payment_Mode__c();
    pmt.name = 'ACH';
    insert pmt;
    return pmt;
  }

  public static loan__Bank_Account__c returnDepositAccount() {
    loan__Bank_Account__c bank = new loan__Bank_Account__c();
    bank.loan__Active__c = true;
    bank.loan__Bank_Account_Number__c = '123456';
    bank.loan__Bank_Name__c = 'ABCD';
    bank.Bank_Account_Name__c = 'ABCDE';
    insert bank;
    return bank;
  }

  public static loan__Fee__c loanFeeInfo() {
    loan__Fee__c loanFee = new loan__Fee__c();
    loanFee.name = 'Application Fee';
    loanFee.loan__Amount__c = 400;
    loanFee.loan__Time_of_charge__c = 'Pre-Paid Fees';
    insert loanFee;
    return loanFee;
  }

  public static loan__Contract_Pre_Paid_Fee__c contractFee(
    Id loanID,
    Id feeAmtID
  ) {
    loan__Contract_Pre_Paid_Fee__c conFee = new loan__Contract_Pre_Paid_Fee__c();
    conFee.loan__Amount__c = 400;
    conFee.loan__Contract__c = loanID;
    conFee.loan__Fee_Type__c = feeAmtID;
    insert conFee;
    return conFee;
  }

  public static clcommon__Deposit__c depInfo(Id loanID) {
    clcommon__Deposit__c dep = new clcommon__Deposit__c();
    dep.loan__Loan_Account__c = loanID;
    dep.clcommon__Current_Deposit_Rate__c = 10;
    dep.clcommon__Deposit_Amount__c = 4000;
    dep.clcommon__Deposit_Rate__c = 10;
    insert dep;
    return dep;
  }
  public static clcommon__Party_Type__c insertPartyType(String partTypeName) {
    clcommon__Party_Type__c partyType = new clcommon__Party_Type__c(
      name = partTypeName
    );
    insert partyType;
    return partyType;
  }
  public static clcommon__Party__c insertBroker(Id appId) {
    Account brokerAccount = createAccount();
    clcommon__Party_Type__c partyType = insertPartyType('Broker');
    clcommon__Party__c brokerParty = createParty(brokerAccount);
    brokerParty.clcommon__Type__c = partyType.Id;
    brokerParty.genesis__Application__c = appId;
    brokerParty.Commission_Paid__c = 'Yes';
    brokerParty.Commission_Structure__c = 'Upfront';
    brokerParty.Upfront_Payment_Percentage__c = 10;
    brokerParty.Commission_Paid_To__c = 'Broker';
    update brokerParty;
    return brokerParty;
  }
  public static clcommon__CL_Product__c insertClProduct() {
    //Inserting cl product
    clcommon__CL_Product__c clProd = new clcommon__CL_Product__c(
      clcommon__Product_Name__c = 'Residential'
    );
    insert clProd;
    return clProd;
  }
  public static clcommon__CL_Product__c insertClProduct2() {
    //Inserting cl product
    clcommon__CL_Product__c clProd = new clcommon__CL_Product__c(
      clcommon__Product_Name__c = 'Residential Construction'
    );
    insert clProd;
    return clProd;
  }
  public static Elixir_Before_Or_On_Settlement_Fees__c insertPrePaidFee() {
    Elixir_Before_Or_On_Settlement_Fees__c fee = new Elixir_Before_Or_On_Settlement_Fees__c();
    fee.name = 'Application Fee';
    fee.Distribution_Type__c = 'Pre-Paid Fee';
    fee.Fee_Field_API_Name__c = 'Application_Fee__c';
    insert fee;
    return fee;
  }
  public static loan__Payment_Mode__c insertpaymentMode() {
    loan__Payment_Mode__c mode1 = new loan__Payment_Mode__c(
      Name = 'Direct Debit'
    );
    insert mode1;
    return mode1;
  }
  public static loan__Fee__c insertLoanFee() {
    loan__Fee__c feeAmt = new loan__Fee__c(
      name = 'Application Fee',
      loan__Amount__c = 400,
      loan__Time_of_charge__c = 'Pre-Paid Fees'
    );
    insert feeAmt;
    return feeAmt;
  }
  public static genesis__Application_Collateral__c insertApplicationCollateral(Id appId, Id collateralId){
    genesis__Application_Collateral__c appCollateral = new genesis__Application_Collateral__c(
      genesis__Application__c = appId,
      genesis__Collateral__c = collateralId
    );
    insert appCollateral;
    return appCollateral;
  }
  public static loan__Loan_Purpose__c insertLoanPurpose(){
    loan__Loan_Purpose__c dummyLoanPurpose = new loan__Loan_Purpose__c();
    dummyLoanPurpose.loan__Loan_Purpose_Code__c = 'Investment';
    dummyLoanPurpose.name = 'Investment';
    dummyLoanPurpose.loan__Description__c	= 'Investment';
    insert dummyLoanPurpose;
    return dummyLoanPurpose;
  }
  public static QBEpostCode__c insertQBEPostCode(){
    QBEpostCode__c qbePostCode = new QBEpostCode__c(
      Location__c = 'Metro',
      PostCode_High_RangeNumber__c = 22222,
      PostCode_Low_RangeNumber__c = 2000,
      Name = '1'
    );
    insert qbePostCode;
    return qbePostCode;
  }
  public static S_P_Postcode__c insertSAndPPostCode(){
    S_P_Postcode__c sAndPPostCode = new S_P_Postcode__c(
      Location__c = 'Metro',
      Name = '1',
      PostCode_High_RangeNumber__c = 22222,
      PostCode_Low_RangeNumber__c = 2000
    );
    insert sAndPPostCode;
    return sAndPPostCode;
  }
  public static clcommon__Party__c createBorowerParty(
    Account acc,
    Id partyTypeId,
    Id appId
  ) {
    clcommon__Party__c party = new clcommon__Party__c();
    party.clcommon__Account__c = acc.Id;
    party.clcommon__Type__c = partyTypeId;
    party.genesis__Application__c = appId;
    insert party;
    return party;
  }
  public static genesis__Employment_Information__c createEmploymentInformation(Id recordId,Id partyId){
    genesis__Employment_Information__c employmentEntry = new genesis__Employment_Information__c(
      Primary_Employment__c = true,
      RecordTypeId = recordId,
      Months_Self_Employed__c = 10,
      Party__c = partyId
    );
    insert employmentEntry;
    return employmentEntry;
  }
  public static Attachment createAttachment(Id parentId,String name){
      Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
      Attachment attach = new Attachment(
      ParentId = parentId,
      Name = name,
    	body=bodyBlob
    );
    insert attach;
    return attach;
  }
  public static clcommon__Document_Category__c createDocumentCategory(Id parentId,String name,Id accountId){
    clcommon__Document_Category__c docCate = new clcommon__Document_Category__c(
      genesis__Application__c = parentId,
      clcommon__Category_Name__c = name,
      clcommon__Account__c = accountId
    );
  insert docCate;
  return docCate;
}
}