/*
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Rameswari Barman
Description: This class provides coverage to PricingUpdateCtrl.
Development Date: 20/7/2020
*/
@isTest
public with sharing class GenericUtilityTestHelper {

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
}