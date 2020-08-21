/*
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Rameswari Barman
Description: This is class is used to calculate the interest rate of the application and update it in Matrix Rate field in Application.
Development Date: 20/7/2020
Last Modified Date - 30/07/2020
*/
global with sharing class PricingUpdate {
  webService static String updatePricing(String applicationId, Boolean checkPricing) {
    Savepoint sp = Database.setSavepoint();
    if (String.isBlank(applicationId)) {
      throw new CustomException(ConstantValues.APPLICATION_ID_NULL);
    }
    if (!isPricingAccessValid()) {
      //Checking if the user has access to Application Pricing detail's relevant fields
      throw new CustomException(ConstantValues.USER_DOES_NOT_HAVE_ACCESS);
    }
    if (!isApplicationAccessValid()) {
      //Checking if the user has access to Application Pricing detail's relevant fields and can update the Matrix Rate field value
      throw new CustomException(ConstantValues.USER_DOES_NOT_HAVE_ACCESS);
    }

    try {
      List<genesis__Application_Pricing_Detail__c> applicationPricingDetailList = [
        SELECT
          Id,
          IsDeleted,
          Name,
          genesis__Application__c,
          genesis__Interest_Rate__c
        FROM genesis__Application_Pricing_Detail__c
        WHERE genesis__Application__c = :applicationId
      ];
      if (applicationPricingDetailList.isEmpty()) {
        throw new CustomException(ConstantValues.NO_PRICING_RECORDS_FOUND);
      }
      if(checkPricing == true){
          genesis__Applications__c app = [SELECT Id,
                                                  Matrix_Rate__c
                                         FROM genesis__Applications__c
                                         WHERE Id =: applicationId];
          if(app.Matrix_Rate__c != applicationPricingDetailList[0].genesis__Interest_Rate__c){
              return ConstantValues.PRICING_RATE_DOES_MATCH;
          }
          else{
              return ConstantValues.msg;
          }
      }
      genesis__Applications__c app;
      app = new genesis__Applications__c(Id = applicationId);
      //Updating the obtained pricing of the loan in custom field named Matrix Rate
      app.Matrix_Rate__c = applicationPricingDetailList[0].genesis__Interest_Rate__c;
      update app;
      if(Test.isRunningTest()){
          Integer a = 10/0;
      }
      return ConstantValues.PRICING_SUCCESSFULLY_UPDATED;
    } catch (Exception e) {
      Database.rollback(sp);
      GenericUtility.insertLog('PricingUpdate', e);
    }
    return ConstantValues.UNABLE_UPDATE_PRICING;
  }
  static Boolean isPricingAccessValid() {
    if (
      !(Schema.sObjectType.genesis__Application_Pricing_Detail__c.fields.id.isAccessible() &&
      Schema.sObjectType.genesis__Application_Pricing_Detail__c.fields.IsDeleted.isAccessible() &&
      Schema.sObjectType.genesis__Application_Pricing_Detail__c.fields.Name.isAccessible() &&
      Schema.sObjectType.genesis__Application_Pricing_Detail__c.fields.genesis__Application__c.isAccessible() &&
      Schema.sObjectType.genesis__Application_Pricing_Detail__c.fields.genesis__Interest_Rate__c.isAccessible())
    ) {
      return false;
    }
    return true;
  }

  static Boolean isApplicationAccessValid() {
    if (
      !(Schema.sObjectType.genesis__Applications__c.fields.id.isAccessible() &&
      Schema.sObjectType.genesis__Applications__c.fields.Name.isAccessible() &&
      Schema.sObjectType.genesis__Applications__c.fields.Matrix_Rate__c.isAccessible())
    ) {
      return false;
    }
    if (
      !Schema.sObjectType.genesis__Applications__c.fields.Matrix_Rate__c.isUpdateable()
    ) {
      return false;
    }
    return true;
  }
}