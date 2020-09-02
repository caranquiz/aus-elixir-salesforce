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
 public static Account createAccount(){
 Account acc = new Account();
 acc.Name = 'Llloyds';
 insert acc;
 return acc;
 }
 public static clcommon__Party__c createParty(Account acc){
 clcommon__Party__c party = new clcommon__Party__c();
 party.clcommon__Account__c = acc.Id;
 party.ABN_Company_Name__c = 'Llloyds';
 party.Flag_Party__c = false;
 insert party;
 return party;
 }
 public static ABN_Search_SMSF__c createCustomSettingGUID(String guid, String activeFundsOnly, String maxSearchResults){
    ABN_Search_SMSF__c guidInfo = new ABN_Search_SMSF__c();
    guidInfo.GUID__c = guid;
    guidInfo.Active_Funds_Only__c = activeFundsOnly;
    guidInfo.Maximum_Search_Results__c = maxSearchResults;
    insert guidInfo;
    return guidInfo;
 }
 public static List<genesis__Rule__c> returnRule(){
   genesis__Rule__c ruleOne = new genesis__Rule__c(genesis__Object_Type__c = 'Application',Name = 'Rule One',genesis__Enabled__c = true);
   genesis__Rule__c ruleTwo = new genesis__Rule__c(genesis__Object_Type__c = 'Application',Name = 'Rule Two',genesis__Enabled__c = true);
   genesis__Rule__c ruleThree = new genesis__Rule__c(genesis__Object_Type__c = 'Application',Name = 'Rule Three',genesis__Enabled__c = true);
   List<genesis__Rule__c> ruleLists = new List<genesis__Rule__c>();
   ruleLists.add(ruleOne);
   ruleLists.add(ruleTwo);
   ruleLists.add(ruleThree);
   //Inserting rule
   insert ruleLists;
   return ruleLists;
 }
 public static EquifaxOrdIdSearch__c createCustomSettingCreds(String subscriberIdentifier, String security){
  EquifaxOrdIdSearch__c equifaxOrgIdSearchObj = new EquifaxOrdIdSearch__c();
  equifaxOrgIdSearchObj.Subscriber_Identifier__c = subscriberIdentifier;
  equifaxOrgIdSearchObj.Security__c = security;
  insert equifaxOrgIdSearchObj;
  return equifaxOrgIdSearchObj;
 }
  //Inserting Rules, Checklist and Criteria of Rules
  public static List<genesis__Rule__c> returnRule(Id appId){
    genesis__Rule__c ruleOne = new genesis__Rule__c(genesis__Object_Type__c = 'Application',Name = 'Cash Out Purpose Suitable Rule',genesis__Enabled__c = true,genesis__Evaluation_Expression__c = '1',genesis__Message_failure__c = 'FAILURE', genesis__Message_success__c = 'SUCCESS');
    genesis__Rule__c ruleTwo = new genesis__Rule__c(genesis__Object_Type__c = 'Application',Name = 'Customer Interview completed Rule',genesis__Enabled__c = true,genesis__Evaluation_Expression__c = '1', genesis__Message_failure__c = 'FAILURE', genesis__Message_success__c = 'SUCCESS');
    genesis__Rule__c ruleThree = new genesis__Rule__c(genesis__Object_Type__c = 'Application',Name = 'Temporary Visa Suitability Rule',genesis__Enabled__c = true,genesis__Evaluation_Expression__c = '1', genesis__Message_failure__c = 'FAILURE', genesis__Message_success__c = 'SUCCESS');
    genesis__Rule__c ruleFour = new genesis__Rule__c(genesis__Object_Type__c = 'Application',Name = 'GST Suitable Rule',genesis__Enabled__c = true,genesis__Evaluation_Expression__c = '1', genesis__Message_failure__c = 'FAILURE', genesis__Message_success__c = 'SUCCESS');
    genesis__Rule__c ruleFive = new genesis__Rule__c(genesis__Object_Type__c = 'Application',Name = 'Explanation of Credit Events Suitable Rule',genesis__Enabled__c = true,genesis__Evaluation_Expression__c = '1 OR 2', genesis__Message_failure__c = 'FAILURE', genesis__Message_success__c = 'SUCCESS');
    genesis__Rule__c ruleSix = new genesis__Rule__c(genesis__Object_Type__c = 'Application',Name = 'Confirm letter prepared by accountant Rule',genesis__Enabled__c = true,genesis__Evaluation_Expression__c = '1', genesis__Message_failure__c = 'FAILURE', genesis__Message_success__c = 'SUCCESS');
    genesis__Rule__c ruleSeven = new genesis__Rule__c(genesis__Object_Type__c = 'Application',Name = 'Living Expense Explanation Suitable Rule',genesis__Enabled__c = true, genesis__Evaluation_Expression__c = '1',genesis__Message_failure__c = 'FAILURE', genesis__Message_success__c = 'SUCCESS');
    genesis__Rule__c ruleEight = new genesis__Rule__c(genesis__Object_Type__c = 'Application',Name = 'Income Consistent with Declaration Rule',genesis__Enabled__c = true, genesis__Evaluation_Expression__c = '1', genesis__Message_failure__c = 'FAILURE', genesis__Message_success__c = 'SUCCESS');
    genesis__Rule__c ruleNine = new genesis__Rule__c(genesis__Object_Type__c = 'Application',Name = 'Distressed Asset Rule',genesis__Enabled__c = true, genesis__Evaluation_Expression__c = '1',genesis__Message_failure__c = 'FAILURE', genesis__Message_success__c = 'SUCCESS');
    genesis__Rule__c ruleTen = new genesis__Rule__c(genesis__Object_Type__c = 'Application',Name = 'Employment Call Suitable Rule',genesis__Enabled__c = true, genesis__Evaluation_Expression__c = '1',genesis__Message_failure__c = 'FAILURE', genesis__Message_success__c = 'SUCCESS');
    genesis__Rule__c ruleEl = new genesis__Rule__c(genesis__Object_Type__c = 'Application',Name = 'Explanation of Credit Enquiries Suitable Rule',genesis__Enabled__c = true, genesis__Evaluation_Expression__c = '1 OR 2 OR 3',genesis__Message_failure__c = 'FAILURE', genesis__Message_success__c = 'SUCCESS');
    
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
    //Inserting rule
    insert ruleLists;
    List <genesis__RuleCriteria__c> criteriaList = new List<genesis__RuleCriteria__c>();
    genesis__RuleCriteria__c criteriaOne = new genesis__RuleCriteria__c(genesis__Criteria_Sequence__c = 1,
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
    genesis__RuleCriteria__c criteriaTwo = new genesis__RuleCriteria__c(genesis__Criteria_Sequence__c = 1,
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
    genesis__RuleCriteria__c criteriaThree = new genesis__RuleCriteria__c(genesis__Criteria_Sequence__c = 1,
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
    genesis__RuleCriteria__c criteriaFour = new genesis__RuleCriteria__c(genesis__Criteria_Sequence__c = 1,
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
    genesis__RuleCriteria__c criteriaSeven = new genesis__RuleCriteria__c(genesis__Criteria_Sequence__c = 1,
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
    genesis__RuleCriteria__c criteriaNine = new genesis__RuleCriteria__c(genesis__Criteria_Sequence__c = 1,
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
    genesis__RuleCriteria__c criteriaTen = new genesis__RuleCriteria__c(genesis__Criteria_Sequence__c = 1,
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
    genesis__RuleCriteria__c criteriaEl = new genesis__RuleCriteria__c(genesis__Criteria_Sequence__c = 1,
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
    genesis__RuleCriteria__c criteriaFive = new genesis__RuleCriteria__c(genesis__Criteria_Sequence__c = 2,
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
    genesis__RuleCriteria__c criteriaEight = new genesis__RuleCriteria__c(genesis__Criteria_Sequence__c = 3,
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
    genesis__RuleCriteria__c criteriaSix = new genesis__RuleCriteria__c(genesis__Criteria_Sequence__c = 2,
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
    List <genesis__Checklist__c> checkList = new List<genesis__Checklist__c>();
   
    genesis__Checklist__c eachCheckList1 = new genesis__Checklist__c(
                    genesis__Application__c = appId,
                    genesis__Assessed_Record_Id__c = appId,
                    genesis__Is_Archived__c = False,
                    genesis__Level__c = 'ERROR',
                    genesis__Message__c = 'FAIL',
                    genesis__Rule__c = ruleOne.Id,
                    genesis__Type__c = 'Business Rule');
    genesis__Checklist__c eachCheckList2 = new genesis__Checklist__c(
                    genesis__Application__c = appId,
                    genesis__Assessed_Record_Id__c = appId,
                    genesis__Is_Archived__c = False,
                    genesis__Level__c = 'ERROR',
                    genesis__Message__c = 'FAIL',
                    genesis__Rule__c = ruleTwo.Id,
                    genesis__Type__c = 'Business Rule');
    genesis__Checklist__c eachCheckList3 = new genesis__Checklist__c(
                    genesis__Application__c = appId,
                    genesis__Assessed_Record_Id__c = appId,
                    genesis__Is_Archived__c = False,
                    genesis__Level__c = 'ERROR',
                    genesis__Message__c = 'FAIL',
                    genesis__Rule__c = ruleThree.Id,
                    genesis__Type__c = 'Business Rule');
    genesis__Checklist__c eachCheckList4 = new genesis__Checklist__c(
                    genesis__Application__c = appId,
                    genesis__Assessed_Record_Id__c = appId,
                    genesis__Is_Archived__c = False,
                    genesis__Level__c = 'ERROR',
                    genesis__Message__c = 'FAIL',
                    genesis__Rule__c = ruleFive.Id,
                    genesis__Type__c = 'Business Rule');
    genesis__Checklist__c eachCheckList5 = new genesis__Checklist__c(
                    genesis__Application__c = appId,
                    genesis__Assessed_Record_Id__c = appId,
                    genesis__Is_Archived__c = False,
                    genesis__Level__c = 'ERROR',
                    genesis__Message__c = 'FAIL',
                    genesis__Rule__c = ruleSeven.Id,
                    genesis__Type__c = 'Business Rule');
     genesis__Checklist__c eachCheckList6 = new genesis__Checklist__c(
                    genesis__Application__c = appId,
                    genesis__Assessed_Record_Id__c = appId,
                    genesis__Is_Archived__c = False,
                    genesis__Level__c = 'ERROR',
                    genesis__Message__c = 'FAIL',
                    genesis__Rule__c = ruleNine.Id,
                    genesis__Type__c = 'Business Rule');
    genesis__Checklist__c eachCheckList7 = new genesis__Checklist__c(
                    genesis__Application__c = appId,
                    genesis__Assessed_Record_Id__c = appId,
                    genesis__Is_Archived__c = False,
                    genesis__Level__c = 'ERROR',
                    genesis__Message__c = 'FAIL',
                    genesis__Rule__c = ruleTen.Id,
                    genesis__Type__c = 'Business Rule'); 
    genesis__Checklist__c eachCheckList8 = new genesis__Checklist__c(
                    genesis__Application__c = appId,
                    genesis__Assessed_Record_Id__c = appId,
                    genesis__Is_Archived__c = False,
                    genesis__Level__c = 'ERROR',
                    genesis__Message__c = 'FAIL',
                    genesis__Rule__c = ruleEl.Id,
                    genesis__Type__c = 'Business Rule');
                       
    //checkList.add(eachCheckList1);
    //checkList.add(eachCheckList2);
    checkList.add(eachCheckList3);
    checkList.add(eachCheckList4);
    checkList.add(eachCheckList5);
    checkList.add(eachCheckList6);
    checkList.add(eachCheckList7);
    checkList.add(eachCheckList8);
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
    insert checkList;
    insert criteriaList;
    return ruleLists;
  }
    //Inserting Employment and Income
    public static genesis__Employment_Information__c returnEmploymentInformation(Id appId){
        genesis__Employment_Information__c employmentInfo = new genesis__Employment_Information__c(genesis__Application__c = appId
        );
        insert employmentInfo;
        return employmentInfo;
    }
    //Inserting Income
    public static genesis__Income__c returnEmploymentInformation(Id appId, Id empInfo){
        genesis__Income__c income = new genesis__Income__c(genesis__Application__c = appId,
        Employment_Information__c = empInfo
        );
        insert income;
        return income;
    }
    //Inserting application collateral
    public static genesis__Application_Collateral__c returnAppCollateral(Id appId, Id borrowerId){
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
      return appCollateral;
    }
    
    //Inserting Party
    public static clcommon__Party__c returnParty(Id appId, Id account){
    clcommon__Party__c party = new clcommon__Party__c(genesis__Application__c = appId,
    clcommon__Account__c = account);
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
}