/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Koushik Mondal
Development Date : 29/07/2020
Last Modified By : Rameswari Barman
Last Modified Date : 21/08/2020
Description : This class query all the Rules and check the Rule Criteria for the Loan Application.
***********************************************************************************************************************************************************/

global with sharing class CheckRules {
    webService static String callCheckRulesWS(String applicationId, String tabName) {
        String returnValue = '';
        String applicationRecordId;
        List <String> rulesNameList = new List<String>();
        List<genesis__Checklist__c> previousChecklistList = new List<genesis__Checklist__c>();
        Savepoint sp = Database.setSavepoint();
        List<genesis__Checklist__c> checkList = new List<genesis__Checklist__c>();
        try {
            if (applicationId == null) {
                return (ConstantValues.CHECKRULES_APPLICATION_ID_NULL);
            }
            applicationRecordId = applicationId.substring(0,applicationId.length()-3);
            //By the name of specific rules are executed
            if(tabName == ConstantValues.LOAN_DETAILS){
                rulesNameList.add(ConstantValues.CASHOUT_PURPOSE_RULE);
                rulesNameList.add(ConstantValues.COMMISSION_MANADATE_PERCENTAGE_RULE);
                rulesNameList.add(ConstantValues.INTEREST_ONLY_SUITABE_RULE);
                rulesNameList.add(ConstantValues.EXIT_STRATEGY_SUITABLE_RULE);
                rulesNameList.add(ConstantValues.LENDERS_MORTAGE_INSURANCE_RULE);
            }
            else if(tabName == ConstantValues.SETTLEMENT){
                rulesNameList.add(ConstantValues.CUSTOMER_INTERVIEW_COMPLETED_RULE);
            }
            else if(tabName == ConstantValues.SECURITIES){
                rulesNameList.add(ConstantValues.DISTRESSED_ASSET_RULE);
                rulesNameList.add(ConstantValues.CHECK_VAL_VALUE_RULE);
            }
            else if(tabName == ConstantValues.INDIVIDUAL_CONTACT_DETAILS){
                rulesNameList.add(ConstantValues.TEMPORARY_VISA_SUITABILITY_RULE);
                rulesNameList.add(ConstantValues.ABN_STATUS_EXPLANATION_SUITABLE_RULE);
                rulesNameList.add(ConstantValues.EXIT_STRATEGY_SUITABLE_RULE_CONTACT);
                rulesNameList.add(ConstantValues.BORROWER_IS_A_STAFF_MEMBER);
            }
            else if(tabName == ConstantValues.NON_INDIVIDUAL_CONTACT_DETAILS){
                rulesNameList.add(ConstantValues.GST_SUITABLE_RULE);
            }
            else if(tabName == ConstantValues.CREDIT_HISTORY){
                rulesNameList.add(ConstantValues.EXPLANATION_OF_CREDIT_EVENTS);
                rulesNameList.add(ConstantValues.EXPLANATION_OF_CREDIT_ENQUIRIES);
                rulesNameList.add(ConstantValues.EXPLANATION_OF_BANKRUPTCY);
                rulesNameList.add(ConstantValues.EXPLANATION_OF_AGE_OF_CREDIT_FILE);
            }
            else if(tabName == ConstantValues.INDIVIDUAL_EMPLOYMENT_INFORMATION){
                rulesNameList.add(ConstantValues.CONFIRM_LETTER_PREPARED_BY_ACCOUNTANT);
                rulesNameList.add(ConstantValues.CONFIRM_STATED_ANNUAL_INCOME);
                rulesNameList.add(ConstantValues.ACCOUNTANT_AWARE_OF_ANY_CIRCUMSTANCE);
                rulesNameList.add(ConstantValues.ACCOUNTANT_CALL_SUITABLE_RULE);
                rulesNameList.add(ConstantValues.EMPLOYMENT_CALL_SUITABLE_RULE);
                rulesNameList.add(ConstantValues.INCOME_INCONSISTANT_WITH_DECLARATION_RULE);
                rulesNameList.add(ConstantValues.GST_EFFECTIVE_FROM_RULE);
            }
            else if(tabName == ConstantValues.LIVING_EXPENSE){
                rulesNameList.add(ConstantValues.LIVING_EXPENSE_EXPLANATION_SUITABLE_RULE);
                rulesNameList.add(ConstantValues.BANK_STATEMENT_REVIEWED_RULE);
            }
            else if(tabName == ConstantValues.COMPANY_INCOME){
                rulesNameList.add(ConstantValues.INCOME_INCONSISTANT_WITH_DECLARATION_RULE);
                rulesNameList.add(ConstantValues.SATISFACTORY_EXPLANATION_PROVIDED_RULE);
                rulesNameList.add(ConstantValues.CONFIRM_LETTER_PREPARED_BY_ACCOUNTANT);
                rulesNameList.add(ConstantValues.CONFIRM_STATED_ANNUAL_INCOME);
                rulesNameList.add(ConstantValues.ACCOUNTANT_AWARE_OF_ANY_CIRCUMSTANCE);
                rulesNameList.add(ConstantValues.ACCOUNTANT_CALL_SUITABLE_RULE);
            }
            else if(tabName == ConstantValues.BROKER_CONTACT_DETAILS){
                rulesNameList.add(ConstantValues.ACL_VERIFIED_RULE);
                rulesNameList.add(ConstantValues.COMMISSION_STATUS_RULE);
            }
            else if(tabName == ConstantValues.ASSET_LIABILITY){
                rulesNameList.add(ConstantValues.PREVIOUS_CONDUCT_SUITABLE);
            }
            else if(tabName == ConstantValues.REVIEW){
                rulesNameList.add('Matrix Rate Exception');
                rulesNameList.add('Confirm Repayments do not double Exception');
                rulesNameList.add('Arms Length Valuer Commentary Exception');
                rulesNameList.add('110% Check Exception');
                rulesNameList.add('Valuation Required Exception');
                rulesNameList.add('Valuation Received Exception');
                rulesNameList.add('Licenced Builder Exception');
                rulesNameList.add('ABN Status Exception');
            }
            Map<Id,genesis__Rule__c> mapRules = new Map<Id,genesis__Rule__c>([SELECT Id,
                                                                            Name
                                                                            FROM genesis__Rule__c
                                                                            WHERE genesis__Enabled__c = true
                                                                            AND Name =: rulesNameList]);

            if (!isApplicationAccessValid()) {
                //Checking if the user has access to Application's relevant fields
                throw new CustomException(ConstantValues.USER_DOES_NOT_HAVE_ACCESS);
            }
            
            if (!isCheckListAccessValid()) {
                //Checking if the user has access to checklist's relevant fields
                throw new CustomException(ConstantValues.USER_DOES_NOT_HAVE_ACCESS);
            }

            if(!(mapRules != NULL && mapRules.size() > 0)){
                //Checking if rules are present or not
                throw new CustomException(ConstantValues.INVALID_RULES);
            }
            genesis__Applications__c application = [SELECT  Id, 
                                                    Lenders_Mortgage_Insurance__c,
                                                    Actual_LVR__c,
                                                    Exit_Strategy_Suitable__c,
                                                    Exit_Strategy_Suitable_Rule_Check__c,
                                                    Exit_Strategy_Provided__c,
                                                    Repayment_Type__c,
                                                    Customer_Interview_Completed_Rule_Check__c,
                                                    Customer_Interview_completed__c,
                                                    genesis__CL_Product_Name__c,
                                                    NCCP_status_list__c,
                                                    Commission_Mandate_Percentage__c,
                                                    Commission_Mandate__c,
                                                    Commission_Mandate_Percentage_Rule_Check__c,
                                                    Cash_Out_Purpose_Suitable__c,
                                                    Cash_Out_Purpose_Suitable_Rule_Check__c
                                                    FROM genesis__Applications__c 
                                                    WHERE id = :applicationRecordId
                                                    LIMIT 1];   
            if(Test.isRunningTest() == false){
                previousChecklistList = [SELECT Id 
                                            FROM genesis__Checklist__c 
                                            WHERE genesis__Application__c  =: applicationRecordId
                                            AND genesis__Rule__r.Name =: rulesNameList];
                if(previousChecklistList != NULL && previousChecklistList.size() > 0){
                    Database.delete(previousChecklistList);
                }
                checkList = genesis.RulesAPI.evaluateRules(application, mapRules.values(), true, true);
            }
            else{
                checkList = [Select Id,
                                    genesis__Application__c,
                                    genesis__Assessed_Record_Id__c,
                                    genesis__Is_Archived__c ,
                                    genesis__Level__c,
                                    genesis__Message__c,
                                    genesis__Rule__c,
                                    genesis__Rule__r.Name,
                                    genesis__Type__c
                                    From genesis__Checklist__c];
            }
            if(tabName != ConstantValues.LOAN_DETAILS && tabName != ConstantValues.SETTLEMENT){
                ChildChecklistAPI api = new ChildChecklistAPI();
                List<Checklist_Detail__c> listOfDetail = api.processListOfChecklist(checkList, applicationRecordId);
                Database.insert(listOfDetail);
            }
            returnValue = ConstantValues.Success;
        } 
        catch (Exception e) {
            Database.rollback(sp);
            returnValue = e.getMessage();
            GenericUtility.insertLog('CheckRules', e);
        }
      return returnValue;
    }
    static Boolean isCheckListAccessValid() {
        if (
          !(Schema.sObjectType.genesis__Checklist__c.fields.id.isAccessible() &&
          Schema.sObjectType.genesis__Checklist__c.fields.genesis__Application__c.isAccessible() &&
          Schema.sObjectType.genesis__Checklist__c.fields.genesis__Assessed_Record_Id__c.isAccessible() && 
          Schema.sObjectType.genesis__Checklist__c.fields.genesis__Is_Archived__c.isAccessible() &&
          Schema.sObjectType.genesis__Checklist__c.fields.genesis__Level__c.isAccessible() && 
          Schema.sObjectType.genesis__Checklist__c.fields.genesis__Message__c.isAccessible() &&
          Schema.sObjectType.genesis__Checklist__c.fields.genesis__Rule__c.isAccessible() &&
          Schema.sObjectType.genesis__Checklist__c.fields.genesis__Type__c.isAccessible())
        ) {
          return false;
        }
        return true;
      }
      static Boolean isApplicationAccessValid() {
        if (
          !(Schema.sObjectType.genesis__Applications__c.fields.id.isAccessible() &&
          Schema.sObjectType.genesis__Applications__c.fields.Lenders_Mortgage_Insurance__c.isAccessible() &&
          Schema.sObjectType.genesis__Applications__c.fields.Actual_LVR__c.isAccessible() && 
          Schema.sObjectType.genesis__Applications__c.fields.Exit_Strategy_Suitable__c.isAccessible() &&
          Schema.sObjectType.genesis__Applications__c.fields.Exit_Strategy_Suitable_Rule_Check__c.isAccessible() && 
          Schema.sObjectType.genesis__Applications__c.fields.Exit_Strategy_Provided__c.isAccessible() &&
          Schema.sObjectType.genesis__Applications__c.fields.Repayment_Type__c.isAccessible() &&
          Schema.sObjectType.genesis__Applications__c.fields.Customer_Interview_Completed_Rule_Check__c.isAccessible() &&
          Schema.sObjectType.genesis__Applications__c.fields.Customer_Interview_completed__c.isAccessible() &&
          Schema.sObjectType.genesis__Applications__c.fields.genesis__CL_Product_Name__c.isAccessible() &&
          Schema.sObjectType.genesis__Applications__c.fields.NCCP_status_list__c.isAccessible() &&
          Schema.sObjectType.genesis__Applications__c.fields.Commission_Mandate_Percentage__c.isAccessible() &&
          Schema.sObjectType.genesis__Applications__c.fields.Commission_Mandate__c.isAccessible() &&
          Schema.sObjectType.genesis__Applications__c.fields.Commission_Mandate_Percentage_Rule_Check__c.isAccessible() &&
          Schema.sObjectType.genesis__Applications__c.fields.Cash_Out_Purpose_Suitable__c.isAccessible() && 
          Schema.sObjectType.genesis__Applications__c.fields.Cash_Out_Purpose_Suitable_Rule_Check__c.isAccessible())
        ) {
          return false;
        }
        return true;
      }
}