/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Koushik Mondal
Development Date : 29/07/2020
Last Modified By : Rameswari Barman
Last Modified Date : 21/08/2020
Description : This class query all the Rules and check the Rule Criteria for the Loan Application.
***********************************************************************************************************************************************************/

global with sharing class CheckRules {
  private static List<genesis__Rule__c> ruleList = [
    SELECT Id, Name, genesis__Message_success__c, genesis__Message_failure__c
    FROM genesis__Rule__c
    WHERE
      genesis__Enabled__c = true
      AND (Name = :ConstantValues.RISK_GRADE_COMPARE_WARNING
      OR Name = :ConstantValues.PRIMARY_PURPOSE_WARNING
      OR Name = :ConstantValues.DOCUMENT_TYPE_WARNING
      OR Name = :ConstantValues.VALUATION_PAID_WARNING)
  ];
  private static String applicationManualData;
  private static Map<String, String> sObjectNameManualDataMap = new Map<String, String>();

  private static String testing = '';
  webService static String callCheckRulesWS(
    String applicationId,
    String tabName
  ) {
    String returnValue = '';
    List<String> rulesNameList = new List<String>();
    List<genesis__Checklist__c> previousChecklistList = new List<genesis__Checklist__c>();
    Savepoint sp = Database.setSavepoint();
    List<genesis__Checklist__c> checkList = new List<genesis__Checklist__c>();
    try {
      if (applicationId == null) {
        return (ConstantValues.CHECKRULES_APPLICATION_ID_NULL);
      }
      //By the name of specific rules are executed
      if (tabName == ConstantValues.RECOMMENDED) {
        rulesNameList.add(ConstantValues.CASHOUT_PURPOSE_RULE);
        rulesNameList.add(ConstantValues.INTEREST_ONLY_SUITABE_RULE);
        rulesNameList.add(ConstantValues.EXIT_STRATEGY_SUITABLE_RULE);
        rulesNameList.add(ConstantValues.LENDERS_MORTAGE_INSURANCE_RULE);
        rulesNameList.add(ConstantValues.CUSTOMER_INTERVIEW_COMPLETED_RULE);
        rulesNameList.add(ConstantValues.DISTRESSED_ASSET_RULE);
        rulesNameList.add(ConstantValues.CHECK_VAL_VALUE_RULE);
        rulesNameList.add(ConstantValues.TEMPORARY_VISA_SUITABILITY_RULE);
        //rulesNameList.add(ConstantValues.ABN_STATUS_EXPLANATION_SUITABLE_RULE);
        rulesNameList.add(ConstantValues.EXIT_STRATEGY_SUITABLE_RULE_CONTACT);
        rulesNameList.add(ConstantValues.BORROWER_IS_A_STAFF_MEMBER);
        rulesNameList.add(ConstantValues.GST_SUITABLE_RULE);
        rulesNameList.add(ConstantVAlues.ABN_EFFECTIVE_RULE);
        rulesNameList.add(ConstantValues.EXPLANATION_OF_CREDIT_EVENTS);
        rulesNameList.add(ConstantValues.EXPLANATION_OF_CREDIT_ENQUIRIES);
        rulesNameList.add(ConstantValues.EXPLANATION_OF_BANKRUPTCY);
        rulesNameList.add(ConstantValues.EXPLANATION_OF_AGE_OF_CREDIT_FILE);
        rulesNameList.add(ConstantValues.CONFIRM_LETTER_PREPARED_BY_ACCOUNTANT);
        rulesNameList.add(ConstantValues.CONFIRM_STATED_ANNUAL_INCOME);
        rulesNameList.add(ConstantValues.ACCOUNTANT_AWARE_OF_ANY_CIRCUMSTANCE);
        rulesNameList.add(ConstantValues.ACCOUNTANT_CALL_SUITABLE_RULE);
        rulesNameList.add(ConstantValues.EMPLOYMENT_CALL_SUITABLE_RULE);
        rulesNameList.add(
          ConstantValues.INCOME_INCONSISTANT_WITH_DECLARATION_RULE
        );
        rulesNameList.add(ConstantValues.GST_EFFECTIVE_FROM_RULE);
        rulesNameList.add(
          ConstantValues.LIVING_EXPENSE_EXPLANATION_SUITABLE_RULE
        );
        rulesNameList.add(ConstantValues.BANK_STATEMENT_REVIEWED_RULE);
        rulesNameList.add(
          ConstantValues.SATISFACTORY_EXPLANATION_PROVIDED_RULE
        );
        rulesNameList.add(ConstantValues.ACL_VERIFIED_RULE);
        rulesNameList.add(ConstantValues.COMMISSION_STATUS_RULE);
        rulesNameList.add(ConstantValues.PREVIOUS_CONDUCT_SUITABLE);
        rulesNameList.add(ConstantValues.LMI_RULE);
        rulesNameList.add(
          ConstantValues.SELF_EMPLOYMENT_ABN_EFFECTIVE_FROM_RULE
        );
      } else if (tabName == ConstantValues.LOAN_DETAILS) {
        rulesNameList.add(ConstantValues.CASHOUT_PURPOSE_RULE);
        rulesNameList.add(ConstantValues.INTEREST_ONLY_SUITABE_RULE);
        rulesNameList.add(ConstantValues.EXIT_STRATEGY_SUITABLE_RULE);
        rulesNameList.add(ConstantValues.LENDERS_MORTAGE_INSURANCE_RULE);
        rulesNameList.add(ConstantValues.LMI_RULE);
      } else if (tabName == ConstantValues.CUSTOMER_INTERVIEW) {
        rulesNameList.add(ConstantValues.CUSTOMER_INTERVIEW_COMPLETED_RULE);
      } else if (tabName == ConstantValues.SECURITIES) {
        rulesNameList.add(ConstantValues.DISTRESSED_ASSET_RULE);
        rulesNameList.add(ConstantValues.CHECK_VAL_VALUE_RULE);
      } else if (tabName == ConstantValues.INDIVIDUAL_CONTACT_DETAILS) {
        rulesNameList.add(ConstantValues.TEMPORARY_VISA_SUITABILITY_RULE);
        //rulesNameList.add(ConstantValues.ABN_STATUS_EXPLANATION_SUITABLE_RULE);
        rulesNameList.add(ConstantValues.EXIT_STRATEGY_SUITABLE_RULE_CONTACT);
        rulesNameList.add(ConstantValues.BORROWER_IS_A_STAFF_MEMBER);
      } else if (tabName == ConstantValues.NON_INDIVIDUAL_CONTACT_DETAILS) {
        rulesNameList.add(ConstantValues.GST_SUITABLE_RULE);
        rulesNameList.add(ConstantVAlues.ABN_EFFECTIVE_RULE);
      } else if (tabName == ConstantValues.CREDIT_HISTORY) {
        rulesNameList.add(ConstantValues.EXPLANATION_OF_CREDIT_EVENTS);
        rulesNameList.add(ConstantValues.EXPLANATION_OF_CREDIT_ENQUIRIES);
        rulesNameList.add(ConstantValues.EXPLANATION_OF_BANKRUPTCY);
        rulesNameList.add(ConstantValues.EXPLANATION_OF_AGE_OF_CREDIT_FILE);
      } else if (tabName == ConstantValues.INDIVIDUAL_EMPLOYMENT_INFORMATION) {
        rulesNameList.add(ConstantValues.CONFIRM_LETTER_PREPARED_BY_ACCOUNTANT);
        rulesNameList.add(ConstantValues.CONFIRM_STATED_ANNUAL_INCOME);
        rulesNameList.add(ConstantValues.ACCOUNTANT_AWARE_OF_ANY_CIRCUMSTANCE);
        rulesNameList.add(ConstantValues.ACCOUNTANT_CALL_SUITABLE_RULE);
        rulesNameList.add(ConstantValues.EMPLOYMENT_CALL_SUITABLE_RULE);
        rulesNameList.add(
          ConstantValues.INCOME_INCONSISTANT_WITH_DECLARATION_RULE
        );
        rulesNameList.add(ConstantValues.GST_EFFECTIVE_FROM_RULE);
        rulesNameList.add(
          ConstantValues.SELF_EMPLOYMENT_ABN_EFFECTIVE_FROM_RULE
        );
      } else if (tabName == ConstantValues.LIVING_EXPENSE) {
        rulesNameList.add(
          ConstantValues.LIVING_EXPENSE_EXPLANATION_SUITABLE_RULE
        );
        rulesNameList.add(ConstantValues.BANK_STATEMENT_REVIEWED_RULE);
      } else if (tabName == ConstantValues.COMPANY_INCOME) {
        rulesNameList.add(
          ConstantValues.INCOME_INCONSISTANT_WITH_DECLARATION_RULE
        );
        rulesNameList.add(
          ConstantValues.SATISFACTORY_EXPLANATION_PROVIDED_RULE
        );
        rulesNameList.add(ConstantValues.CONFIRM_LETTER_PREPARED_BY_ACCOUNTANT);
        rulesNameList.add(ConstantValues.CONFIRM_STATED_ANNUAL_INCOME);
        rulesNameList.add(ConstantValues.ACCOUNTANT_AWARE_OF_ANY_CIRCUMSTANCE);
        rulesNameList.add(ConstantValues.ACCOUNTANT_CALL_SUITABLE_RULE);
      } else if (tabName == ConstantValues.BROKER_CONTACT_DETAILS) {
        rulesNameList.add(ConstantValues.ACL_VERIFIED_RULE);
        rulesNameList.add(ConstantValues.COMMISSION_STATUS_RULE);
      } else if (tabName == ConstantValues.ASSET_LIABILITY) {
        rulesNameList.add(ConstantValues.PREVIOUS_CONDUCT_SUITABLE);
      } else if (tabName == ConstantValues.XCEPTION) {
        rulesNameList.add(ConstantValues.TRAIL_EXCEPTION);
        rulesNameList.add(ConstantValues.UPFRONT_EXCEPTION);
        rulesNameList.add(ConstantValues.ARMS_LENGTH_EXCEPTION);
        rulesNameList.add(ConstantValues.HUNDRED_CHECK_EXCEPTION);
        rulesNameList.add(ConstantValues.VALUATION_REQUIRED_EXCEPTION);
        rulesNameList.add(ConstantValues.VALUATION_RECEIVED_EXCEPTION);
        rulesNameList.add(ConstantValues.LICENSED_BUILDER_EXCEPTION);
        rulesNameList.add(ConstantValues.ABN_STATUS_EXCEPTION);
        rulesNameList.add(ConstantValues.OVERRIDE_EMPLOYMENT_EXCEPTION);
        rulesNameList.add(ConstantValues.BAS_EXCEPTION);
        rulesNameList.add(ConstantValues.EMPLOYMENT_CALL_MADE_EXCEPTION);
        rulesNameList.add(ConstantValues.MONTHS_SELF_EMPLOYED_EXCEPTION);
        rulesNameList.add(ConstantValues.OVERRIDE_EXCEPTION);
        rulesNameList.add(ConstantValues.ABN_EFFECTIVE_SELF_EMPLOYEMENT_EXCEPTION);
      } else if (tabName == ConstantValues.WARNING) {
        rulesNameList.add(ConstantValues.BROKER_DOCS_WARNING);
        rulesNameList.add(ConstantValues.POLITICALLY_EXPOSED_WARNING);
        rulesNameList.add(ConstantValues.KYC_AML_WARNING);
        rulesNameList.add(ConstantValues.RISK_WARNING);
        rulesNameList.add(ConstantValues.EXPLANATION_PROVIDED_WARNING);
        rulesNameList.add(ConstantValues.EXIT_STRATEGY_WARNING);
        rulesNameList.add(ConstantValues.ABN_STATUS_WARNING);
        rulesNameList.add(ConstantValues.LIVING_EXPENSE_WARNING);
        rulesNameList.add(ConstantValues.TELEPHONE_WARNING);
        rulesNameList.add(ConstantValues.GROCERIES_WARNING);
        rulesNameList.add(ConstantValues.RECREATION_ENTERTAINMENT_WARNING);
        rulesNameList.add(ConstantValues.CLOTHING_AND_PERSONAL_WARNING);
        rulesNameList.add(ConstantValues.MEDICAL_AND_HEALTH_WARNING);
        rulesNameList.add(ConstantValues.TRANSPORT_WARNING);
        rulesNameList.add(ConstantValues.INSURANCE_WARNING);
        rulesNameList.add(ConstantValues.CONTRACT_OF_SALE_WARNING);
        rulesNameList.add(ConstantValues.VALUED_DATE_WARNING);
        rulesNameList.add(ConstantValues.LICENSED_REAL_ESTATE_WARNING);
        rulesNameList.add(ConstantValues.COMPARABLE_SALES_EVIDENT_WARNING);
        rulesNameList.add(ConstantValues.VALUER_RISK_GRADINGS_WARNING);
        rulesNameList.add(ConstantValues.LAND_AREA_WARNING);
        rulesNameList.add(ConstantValues.FLOOR_AREA_WARING);
        rulesNameList.add(ConstantValues.ABN_EFFECTIVE_FROM_WARNING);
        rulesNameList.add(ConstantValues.HEM_WARNING);
        rulesNameList.add(ConstantValues.GST_EFFECTIVE_FROM_WARNING);
        rulesNameList.add(ConstantValues.ACCOUNTANT_ABN_STATUS_WARNING);
        rulesNameList.add(ConstantValues.ACCOUNTANT_PHONE_NUMBER_WARNING);
        rulesNameList.add(ConstantValues.ACCOUNTANT_CALL_WARNING);
        rulesNameList.add(ConstantValues.COMMISSION_MANADATE_PERCENTAGE_WARNING);
        rulesNameList.add(ConstantValues.UPFRONT_EXCEEDS_STANDARD_PERCENTAGE);
        rulesNameList.add(ConstantValues.TRAIL_EXCEEDS_STANDARD_PERCENTAGE);
      } else if (tabName == ConstantValues.WARNING2) {
        rulesNameList.add(
          ConstantValues.ACCOUNTANT_ABN_SEARCH_CONDUCTED_WARNING
        );
        rulesNameList.add(
          ConstantValues.PRIMARY_RESIDENCE_PROPERTY_COST_WARNING
        );
        rulesNameList.add(ConstantValues.EMPLOYER_PHONE_VERIFIED_WARNING);
        rulesNameList.add(ConstantValues.INCOME_VERIFICATEOION_SIGHTED);
        rulesNameList.add(ConstantValues.EMPLOYMENT_DURATION_WARNING);
        rulesNameList.add(ConstantValues.EMPLOYER_VERIFIED_WARNING);
        rulesNameList.add(ConstantValues.IS_DIRECTOR_A_BENEFICIARY_WARNING);
        rulesNameList.add(ConstantValues.IS_TRUSTEE_A_BENEFICIARY_WARNING);
        rulesNameList.add(ConstantValues.GSA_WARNING);
        rulesNameList.add(ConstantValues.EDUCATION_WARNING);
        rulesNameList.add(ConstantValues.INVETSMENT_PROPERTY_WARNING);
        rulesNameList.add(ConstantValues.RENT_BOARD_WARNING);
        rulesNameList.add(
          ConstantValues.ABN_EFFECTIVE_FROM_LIVING_EXPENSE_WARING
        );
        rulesNameList.add(
          ConstantValues.GST_EFFECTIVE_FROM_LIVING_ESPENSE_WARNING
        );
        rulesNameList.add(ConstantValues.PRVATE_PENSION_AMT_WARNING);
        rulesNameList.add(ConstantValues.OTHER_INCOME_AMOUNT_WARNING);
        rulesNameList.add(ConstantValues.SUPERANUATION_AMOUNT_WARNING);
        rulesNameList.add(ConstantValues.LOCATION_WARNING);
        rulesNameList.add(ConstantValues.LOCATION_NOT_ACCEPTABLE_WARNING);
        rulesNameList.add(ConstantValues.TYPE_OF_DOCUMENTS_WARNING);
        rulesNameList.add(ConstantValues.TYPE_OF_DOCUMENTS_WARNING2);
        rulesNameList.add(ConstantValues.TO_BE_REFINANCED_WARNING);
        rulesNameList.add(
          ConstantValues.DOES_APPLICANT_UNDERSTAND_ENGLISH_WARNING
        );
        rulesNameList.add(ConstantValues.RENTAL_INCOME_VERIFIED_WARNING);
        rulesNameList.add(ConstantValues.PREVIOUS_CONDUCT_EXLANATION_WARNING);
        rulesNameList.add(
          ConstantValues.PREVIOUS_CONDUCT_REFERENCING_COMPLETED_WARNING
        );
        rulesNameList.add(ConstantValues.ABN_STATUS_EMPLPYMENT_WARNING);
        rulesNameList.add(ConstantValues.GOVERNMENT_BENEFIT_AMT_WARNING);
        rulesNameList.add(ConstantValues.BANKRUPT_DISCHARGE_DATE_WARNING);
        rulesNameList.add(
          ConstantValues.EXPLANATION_OF_BAKRUPTCY_RECEIVED_WARNING
        );
        rulesNameList.add(ConstantValues.DATE_OF_CREDIT_REPORT_WARNING);
      } else if (tabName == ConstantValues.CONDITION) {
        rulesNameList.add(ConstantValues.ABN_EFFECTIVE_FROM_ECEPTION);
        rulesNameList.add(ConstantValues.ESTIMATED_COMPLETION_DATE);
        rulesNameList.add(ConstantValues.IS_PURCHASOR_MORTGAGOR_CONDITION);
        rulesNameList.add(
          ConstantValues.HOME_INSURANCE_CERTIFICATE_PROVIDED_CONDITION
        );
        rulesNameList.add(ConstantValues.HMI_BODY_CORPORATE_CONDITION);
        rulesNameList.add(ConstantValues.HMI_STANDARD_CONDITION);
        rulesNameList.add(ConstantValues.SIGNED_CONTRACT_CONDITION);
        rulesNameList.add(ConstantValues.FIXED_PRICE_CONTRACT_CONDITION);
        rulesNameList.add(ConstantValues.DETAILED_COSTINGS_HELD_DEFINITION);
        rulesNameList.add(ConstantValues.COPY_BUILDERS_LICENSE_HELD_CONDITION);
        rulesNameList.add(ConstantValues.COPY_HOME_OWNERS_WARRANTY_CONDITION);
        rulesNameList.add(ConstantValues.COUNCIL_APPROVAL_CONDITON);
        rulesNameList.add(ConstantValues.SMSF_STATUS_CONDITION);
        rulesNameList.add(ConstantValues.TRUST_DEED_PROVIDED_CONDITION);
        rulesNameList.add(ConstantValues.CUSTOMER_ACCT_CONDITION);
        rulesNameList.add(ConstantValues.GIFT_STAT_DEC_RECEIVED_CONDITION);
      } else if (tabName == ConstantValues.APP_EXCEP) {
        rulesNameList.add(ConstantValues.MATRIX_RATE_EXCEPTION);
        rulesNameList.add(ConstantValues.CONFIRM_REPAYMENTS_WARNING);
        rulesNameList.add(ConstantValues.IO_WARNING);
        rulesNameList.add(ConstantValues.EXIT_STRATEGY_PROVIEDED_WARNING);
        rulesNameList.add(ConstantValues.FIXED_RATE_WARNING);
        rulesNameList.add(ConstantValues.MATRIX_RATE_WARNING);
        rulesNameList.add(ConstantValues.ACTUAL_LVR_80_WARNING);
        rulesNameList.add(ConstantValues.ACTUAL_LVR_70_WARNING);
        rulesNameList.add(ConstantValues.ACTUAL_LVR_75_WARNING);
        rulesNameList.add(ConstantValues.CASH_OUT_PURPOSE_WARNING);
        rulesNameList.add(ConstantValues.APPLICATION_FEE_WARNING);
        rulesNameList.add(ConstantValues.APPLICATION_FEE_PERCENTAGE_WARNING);
        rulesNameList.add(ConstantValues.APPLICATION_FORM_COMPLETED_WARNING);
        loanDetailsRiskGradeWarningCheck(applicationId);
        loanDetailsPrimaryPurposeWarningCheck(applicationId);
        loanDetailsDocumentCompareWarningCheck(applicationId);
        loanDetailsValuationPaidWarningCheck(applicationId);
      }
      Map<Id, genesis__Rule__c> mapRules = new Map<Id, genesis__Rule__c>(
        [
          SELECT Id, Name
          FROM genesis__Rule__c
          WHERE genesis__Enabled__c = true AND Name = :rulesNameList
        ]
      );

      if (!isApplicationAccessValid()) {
        //Checking if the user has access to Application's relevant fields
        throw new CustomException(ConstantValues.USER_DOES_NOT_HAVE_ACCESS);
      }

      if (!isCheckListAccessValid()) {
        //Checking if the user has access to checklist's relevant fields
        throw new CustomException(ConstantValues.USER_DOES_NOT_HAVE_ACCESS);
      }

      if (!(mapRules != null && mapRules.size() > 0)) {
        //Checking if rules are present or not
        throw new CustomException(ConstantValues.INVALID_RULES);
      }
      genesis__Applications__c application = [
        SELECT
          Id,
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
        WHERE id = :applicationId
        LIMIT 1
      ];
      List<clcommon__Party__c> partyList = [
        SELECT Id, Name, genesis__Application__c
        FROM clcommon__Party__c
        WHERE genesis__Application__c = :applicationId
      ];
      List<genesis__Application_Collateral__c> appColList = [
        SELECT Id, Name, genesis__Application__c
        FROM genesis__Application_Collateral__c
        WHERE genesis__Application__c = :applicationId
      ];
      if (tabName == ConstantValues.APP_EXCEP) {
        updateRuleDataOnApplcationFromChecklists(application, rulesNameList);
      } else if (
        tabName == ConstantValues.WARNING ||
        tabName == ConstantValues.WARNING2 ||
        tabName == ConstantValues.XCEPTION ||
        tabName == ConstantValues.CONDITION
      ) {
        updateRuleDataOnPartiesFromChecklistDetails(partyList, rulesNameList);
        updateRuleDataOnApplicationCollateralsFromChecklistDetails(
          appColList,
          rulesNameList
        );
      }
      if (Test.isRunningTest() == false) {
        previousChecklistList = [
          SELECT
            Id,
            genesis__Application__c,
            genesis__Assessed_Record_Id__c,
            genesis__Is_Archived__c,
            genesis__Level__c,
            genesis__Message__c,
            genesis__Rule__c,
            genesis__Rule__r.Name,
            genesis__Type__c
          FROM genesis__Checklist__c
          WHERE
            genesis__Application__c = :applicationId
            AND genesis__Rule__r.Name = :rulesNameList
        ];
        if (previousChecklistList.size() > 0) {
          Database.delete(previousChecklistList);
        }
        checkList = genesis.RulesAPI.evaluateRules(
          application,
          mapRules.values(),
          true,
          true
        );
      } else {
        checkList = [
          SELECT
            Id,
            genesis__Application__c,
            genesis__Assessed_Record_Id__c,
            genesis__Is_Archived__c,
            genesis__Level__c,
            genesis__Message__c,
            genesis__Rule__c,
            genesis__Rule__r.Name,
            genesis__Type__c
          FROM genesis__Checklist__c
        ];
      }
      if (
        tabName != ConstantValues.LOAN_DETAILS &&
        tabName != ConstantValues.SETTLEMENT &&
        tabName != ConstantValues.APP_EXCEP
      ) {
        ChildChecklistAPI api = new ChildChecklistAPI();
        List<Checklist_Detail__c> listOfDetail = api.processListOfChecklist(
          checkList,
          applicationId
        );
        Database.insert(listOfDetail);
        try {
          List<Checklist_Detail__c> updatedChecklistDetails = new List<Checklist_Detail__c>();
          updatedChecklistDetails.addAll(
            updateChecklistDetailsFromRuleDataOnParties(
              partyList,
              rulesNameList
            )
          );
          updatedChecklistDetails.addAll(
            updateChecklistDetailsFromRuleDataOnApplicationCollaterals(
              appColList,
              rulesNameList
            )
          );
          Database.update(updatedChecklistDetails);
        } catch (Exception ex) {
          GenericUtility.insertLog('Checklist Details Updation Error', ex);
        }
      }
      returnValue = ConstantValues.Success;
      if (
        tabName == ConstantValues.APP_EXCEP ||
        tabName == ConstantValues.WARNING ||
        tabName == ConstantValues.WARNING2 ||
        tabName == ConstantValues.XCEPTION ||
        tabName == ConstantValues.CONDITION
      ) {
        updateChecklistsFromRuleDataOnApplication(application, rulesNameList);
        manupulateConditionText(applicationId);
      }
    } catch (Exception e) {
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
  private static void loanDetailsRiskGradeWarningCheck(Id appId) {
    try {
      Id previousChecklistId;
      Integer lowestRiskGrade = 0;
      genesis__Rule__c riskGradeCompRule;
      for (genesis__Rule__c eachRule : ruleList) {
        if ((eachRule.Name).equals(ConstantValues.RISK_GRADE_COMPARE_WARNING)) {
          riskGradeCompRule = eachRule;
        }
      }
      if (riskGradeCompRule == null) {
        return;
      }
      genesis__Applications__c appObj = [
        SELECT Id, Risk_grade_list__c
        FROM genesis__Applications__c
        WHERE Id = :appId
        LIMIT 1
      ];
      Map<String, Integer> riskGradeValued = new Map<String, Integer>();
      riskGradeValued.put(ConstantValues.PRIME, 0);
      riskGradeValued.put(ConstantValues.NEAR_PRIME, 1);
      riskGradeValued.put(ConstantValues.NEAR_PRIME_PLUS, 2);
      riskGradeValued.put(ConstantValues.SPECIALIST, 3);
      riskGradeValued.put(ConstantValues.SPECIALIST_PLUS, 4);
      List<genesis__Checklist__c> previousChecklists = [
        SELECT Id
        FROM genesis__Checklist__c
        WHERE
          genesis__Rule__c = :riskGradeCompRule.Id
          AND genesis__Application__c = :appId
      ];
      if (previousChecklists.isEmpty()) {
        previousChecklistId = null;
      } else {
        previousChecklistId = previousChecklists[0].Id;
      }
      // Database.delete(previousChecklists, false);
      List<clcommon__Party__c> parties = [
        SELECT
          Id,
          Legal_Entity_Type__c,
          Party_Type_Name__c,
          Risk_Grade__c,
          genesis__Application__c
        FROM clcommon__Party__c
        WHERE genesis__Application__c = :appId
      ];
      for (clcommon__Party__c eachParty : parties) {
        if (String.IsNotBlank(eachParty.Risk_Grade__c)) {
          if (
            riskGradeValued.containsKey(eachParty.Risk_Grade__c) &&
            riskGradeValued.get(eachParty.Risk_Grade__c) > lowestRiskGrade
          ) {
            lowestRiskGrade = riskGradeValued.get(eachParty.Risk_Grade__c);
          }
        }
      }
      if (lowestRiskGrade == 0) {
        successCheckList(riskGradeCompRule, appId, previousChecklistId);
        return;
      } else if (String.isBlank(appObj.Risk_grade_list__c)) {
        errorCheckList(riskGradeCompRule, appId, previousChecklistId);
        return;
      }
      Integer val = riskGradeValued.get(appObj.Risk_grade_list__c);
      if (lowestRiskGrade != val) {
        errorCheckList(riskGradeCompRule, appId, previousChecklistId);
      } else {
        successCheckList(riskGradeCompRule, appId, previousChecklistId);
      }
    } catch (Exception ex) {
      GenericUtility.insertLog(
        'CheckRules.loanDetailsRiskGradeWarningCheck',
        ex
      );
    }
  }
  private static void loanDetailsPrimaryPurposeWarningCheck(Id appId) {
    try {
      genesis__Rule__c primPurpCompRule;
      for (genesis__Rule__c eachRule : ruleList) {
        if ((eachRule.Name).equals(ConstantValues.PRIMARY_PURPOSE_WARNING)) {
          primPurpCompRule = eachRule;
        }
      }
      if (primPurpCompRule == null) {
        return;
      }
      genesis__Applications__c appObj = [
        SELECT Id, Primary_loan_purpose_list__c
        FROM genesis__Applications__c
        WHERE Id = :appId
        LIMIT 1
      ];
      List<genesis__Checklist__c> previousChecklist = [
        SELECT Id, genesis__Rule__c
        FROM genesis__Checklist__c
        WHERE
          genesis__Rule__c = :primPurpCompRule.Id
          AND genesis__Application__c = :appId
      ];
      Id previousChecklistId;
      if (previousChecklist.isEmpty()) {
        previousChecklistId = null;
      } else {
        previousChecklistId = previousChecklist[0].Id;
      }
      // Database.delete(previousChecklists, false);
      List<genesis__Application_Collateral__c> appCollaterals = [
        SELECT
          Id,
          genesis__Application__c,
          genesis__Collateral__r.Primary_Purpose__c
        FROM genesis__Application_Collateral__c
        WHERE genesis__Application__c = :appId
      ];
      if (appCollaterals.isEmpty()) {
        return;
      }
      String prevPrimPurp = '';
      if (appCollaterals[0].genesis__Collateral__c != null) {
        prevPrimPurp = appCollaterals[0]
          .genesis__Collateral__r.Primary_Purpose__c;
      }
      for (
        genesis__Application_Collateral__c eachAppCollateral : appCollaterals
      ) {
        if (eachAppCollateral.genesis__Collateral__c != null) {
          if (
            String.isBlank(
              eachAppCollateral.genesis__Collateral__r.Primary_Purpose__c
            )
          ) {
            errorCheckList(primPurpCompRule, appId, previousChecklistId);
            return;
          } else if (
            prevPrimPurp !=
            eachAppCollateral.genesis__Collateral__r.Primary_Purpose__c
          ) {
            errorCheckList(primPurpCompRule, appId, previousChecklistId);
            return;
          }
          prevPrimPurp = eachAppCollateral.genesis__Collateral__r.Primary_Purpose__c;
        }
      }
      if (appObj.Primary_loan_purpose_list__c != prevPrimPurp) {
        errorCheckList(primPurpCompRule, appId, previousChecklistId);
      } else {
        successCheckList(primPurpCompRule, appId, previousChecklistId);
      }
    } catch (Exception ex) {
      GenericUtility.insertLog(
        'CheckRules.loanDetailsPrimaryPurposeWarningCheck',
        ex
      );
    }
  }
  private static void loanDetailsDocumentCompareWarningCheck(Id appId) {
    try {
      genesis__Rule__c docTypeCompRule;
      for (genesis__Rule__c eachRule : ruleList) {
        if ((eachRule.Name).equals(ConstantValues.DOCUMENT_TYPE_WARNING)) {
          docTypeCompRule = eachRule;
        }
      }
      if (docTypeCompRule == null) {
        return;
      }
      genesis__Applications__c appObj = [
        SELECT Id, Document_Type__c
        FROM genesis__Applications__c
        WHERE Id = :appId
        LIMIT 1
      ];
      List<genesis__Checklist__c> previousChecklist = [
        SELECT Id, genesis__Rule__c
        FROM genesis__Checklist__c
        WHERE
          genesis__Rule__c = :docTypeCompRule.Id
          AND genesis__Application__c = :appId
      ];
      Id previousChecklistId;
      if (previousChecklist.isEmpty()) {
        previousChecklistId = null;
      } else {
        previousChecklistId = previousChecklist[0].Id;
      }
      // Database.delete(previousChecklists, false);
      List<clcommon__Party__c> parties = [
        SELECT Id, Document_Type__c, Legal_Entity_Type__c, Party_Type_Name__c
        FROM clcommon__Party__c
        WHERE
          genesis__Application__c = :appId
          AND Legal_Entity_Type__c != :ConstantValues.indType
          AND Party_Type_Name__c NOT IN (
            :ConstantValues.BROKER_PARTY_TYPE,
            :ConstantValues.AGGRERATOR_PARTY_TYPE,
            :ConstantValues.SOLICITOR_PARTY_TYPE,
            :ConstantValues.VALUER_PARTY_TYPE,
            :ConstantValues.HOUSEHOLD_PARTY_TYPE
          )
      ];
      List<genesis__Employment_Information__c> empInfoList = [
        SELECT Id, RecordType.Name, genesis__Application__c, Document_Type__c
        FROM genesis__Employment_Information__c
        WHERE
          RecordType.Name = :ConstantValues.SELF_EMPLOYED
          AND genesis__Application__c = :appId
      ];
      if (parties.isEmpty()) {
        return;
      }
      String prevDocType = parties[0].Document_Type__c;
      for (clcommon__Party__c eachParty : parties) {
        if (String.isBlank(eachParty.Document_Type__c)) {
          errorCheckList(docTypeCompRule, appId, previousChecklistId);
          return;
        } else if (prevDocType != eachParty.Document_Type__c) {
          errorCheckList(docTypeCompRule, appId, previousChecklistId);
          return;
        }
        prevDocType = eachParty.Document_Type__c;
      }
      if (!empInfoList.isEmpty()) {
        prevDocType = empInfoList[0].Document_Type__c;
        for (genesis__Employment_Information__c each : empInfoList) {
          if (String.isBlank(each.Document_Type__c)) {
            errorCheckList(docTypeCompRule, appId, previousChecklistId);
            return;
          } else if (prevDocType != each.Document_Type__c) {
            errorCheckList(docTypeCompRule, appId, previousChecklistId);
            return;
          }
          prevDocType = each.Document_Type__c;
        }
      }
      if (
        (appObj.Document_Type__c).equalsIgnoreCase(ConstantValues.FULL_DOC) &&
        !(prevDocType).equalsIgnoreCase(ConstantValues.FULL)
      ) {
        errorCheckList(docTypeCompRule, appId, previousChecklistId);
      } else if (
        (appObj.Document_Type__c).equalsIgnoreCase(ConstantValues.ALT_DOC) &&
        !(prevDocType).equalsIgnoreCase(ConstantValues.ALT)
      ) {
        errorCheckList(docTypeCompRule, appId, previousChecklistId);
      } else {
        successCheckList(docTypeCompRule, appId, previousChecklistId);
      }
    } catch (Exception ex) {
      GenericUtility.insertLog(
        'CheckRules.loanDetailsDocumentCompareWarningCheck',
        ex
      );
    }
  }
  public static void loanDetailsValuationPaidWarningCheck(Id appId) {
    try {
      genesis__Rule__c valPaidRule;
      for (genesis__Rule__c eachRule : ruleList) {
        if ((eachRule.Name).equals(ConstantValues.VALUATION_PAID_WARNING)) {
          valPaidRule = eachRule;
        }
      }
      if (valPaidRule == null) {
        return;
      }
      genesis__Applications__c appObj = [
        SELECT Id, Valuation_Fee_Collected_at_Settlement__c
        FROM genesis__Applications__c
        WHERE Id = :appId
        LIMIT 1
      ];
      if (appObj == null) {
        return;
      }
      List<genesis__Checklist__c> previousChecklist = [
        SELECT Id, genesis__Rule__c
        FROM genesis__Checklist__c
        WHERE
          genesis__Rule__c = :valPaidRule.Id
          AND genesis__Application__c = :appId
      ];
      Id previousChecklistId;
      if (previousChecklist.isEmpty()) {
        previousChecklistId = null;
      } else {
        previousChecklistId = previousChecklist[0].Id;
      }
      // Database.delete(previousChecklists, false);
      List<genesis__Application_Collateral__c> appCollaterals = [
        SELECT
          Id,
          genesis__Application__c,
          genesis__Collateral__c,
          genesis__Collateral__r.Valuation_Paid__c,
          genesis__Collateral__r.Valuation_Paid_Render_Check__c
        FROM genesis__Application_Collateral__c
        WHERE genesis__Application__c = :appId
      ];
      if (appCollaterals.isEmpty()) {
        return;
      }
      if (
        appObj.Valuation_Fee_Collected_at_Settlement__c != ConstantValues.NO_TAG
      ) {
        successCheckList(valPaidRule, appId, previousChecklistId);
        return;
      }
      for (
        genesis__Application_Collateral__c eachAppColleteral : appCollaterals
      ) {
        if (eachAppColleteral.genesis__Collateral__c == null) {
          continue;
        }
        if (
          eachAppColleteral.genesis__Collateral__r.Valuation_Paid_Render_Check__c &&
          eachAppColleteral.genesis__Collateral__r.Valuation_Paid__c !=
          ConstantValues.YES_TAG
        ) {
          errorCheckList(valPaidRule, appId, previousChecklistId);
          return;
        }
      }
      successCheckList(valPaidRule, appId, previousChecklistId);
    } catch (Exception ex) {
      GenericUtility.insertLog(
        'CheckRules.loanDetailsValuationPaidWarningCheck',
        ex
      );
    }
  }
  private static void successCheckList(
    genesis__Rule__c rule,
    Id appId,
    Id checklistId
  ) {
    genesis__Checklist__c checklistObj;
    if (String.isBlank(checklistId)) {
      checklistObj = new genesis__Checklist__c();
    } else {
      checklistObj = new genesis__Checklist__c(Id = checklistId);
    }
    checklistObj.genesis__Application__c = appId;
    checklistObj.genesis__Assessed_Record_Id__c = appId;
    checklistObj.genesis__Level__c = ConstantValues.INFO;
    checklistObj.genesis__Rule__c = rule.Id;
    checklistObj.genesis__Message__c = rule.genesis__Message_success__c;
    Database.upsert(checklistObj);
  }
  private static void errorCheckList(
    genesis__Rule__c rule,
    Id appId,
    Id checklistId
  ) {
    genesis__Checklist__c checklistObj;
    if (String.isBlank(checklistId)) {
      checklistObj = new genesis__Checklist__c();
    } else {
      checklistObj = new genesis__Checklist__c(Id = checklistId);
    }
    checklistObj.genesis__Application__c = appId;
    checklistObj.genesis__Assessed_Record_Id__c = appId;
    checklistObj.genesis__Level__c = ConstantValues.ERROR_TAG;
    checklistObj.genesis__Rule__c = rule.Id;
    checklistObj.genesis__Message__c = rule.genesis__Message_failure__c;
    Database.upsert(checklistObj);
  }

  public ClassChecklistManualDataMapping[] checklistManualDataMapping;
  class ClassChecklistManualDataMapping {
    public String ruleName;
    public String exceptionRecommender;
    public String exceptionApprover;
    public String exceptionCommentary;
    public String status;
    public String supportingDocumentVerified;
    public String waiverReason;
    public String shownOnIndicativeLetter;
  }
  public static void updateRuleDataOnApplcationFromChecklists(
    genesis__Applications__c appObj,
    List<String> rulesNameList
  ) {
    List<genesis__Checklist__c> checklistList = [
      SELECT
        Id,
        genesis__Rule__r.Name,
        Exception_Approver__c,
        Exception_Commentary__c,
        Exception_Recommender__c,
        Status__c,
        Supporting_Documentation__c,
        Waiver_Reason__c
      FROM genesis__Checklist__c
      WHERE
        genesis__Rule__r.Name IN :rulesNameList
        AND genesis__Application__c = :appObj.Id
    ];
    Map<String, genesis__Checklist__c> ruleChecklistMap = new Map<String, genesis__Checklist__c>();
    String manualData = '{"checklistManualDataMapping":[';
    Boolean flag = true;
    for (genesis__Checklist__c eachChecklist : checklistList) {
      if (flag) {
        flag = false;
        manualData += '{';
      } else {
        manualData += ',{';
      }
      manualData += '"ruleName":"' + eachChecklist.genesis__Rule__r.Name + '",';
      manualData +=
        '"exceptionRecommender":"' +
        eachChecklist.Exception_Recommender__c +
        '",';
      manualData +=
        '"exceptionApprover":"' +
        eachChecklist.Exception_Approver__c +
        '",';
      manualData +=
        '"exceptionCommentary":"' +
        eachChecklist.Exception_Commentary__c +
        '",';
      manualData += '"status":"' + eachChecklist.Status__c + '",';
      manualData +=
        '"supportingDocumentVerified":"' +
        eachChecklist.Supporting_Documentation__c +
        '",';
      manualData += '"waiverReason":"' + eachChecklist.Waiver_Reason__c + '"';
      manualData += '}';
    }
    manualData += ']}';
    applicationManualData = manualData;
  }
  public static void updateChecklistsFromRuleDataOnApplication(
    genesis__Applications__c appObj,
    List<String> rulesNameList
  ) {
    if (String.isBlank(applicationManualData)) {
      return;
    }
    String ruleManualData = applicationManualData;
    CheckRules checkRulesObj = (CheckRules) System.JSON.deserialize(
      ruleManualData,
      CheckRules.class
    );
    ClassChecklistManualDataMapping[] checklistManualDataList = checkRulesObj.checklistManualDataMapping;
    List<genesis__Checklist__c> checklistList = [
      SELECT Id, genesis__Rule__r.Name
      FROM genesis__Checklist__c
      WHERE
        genesis__Rule__r.Name IN :rulesNameList
        AND genesis__Application__c = :appObj.Id
    ];
    Map<String, Id> ruleChecklistMap = new Map<String, Id>();
    for (genesis__Checklist__c eachChecklist : checklistList) {
      ruleChecklistMap.put(
        eachChecklist.genesis__Rule__r.Name,
        eachChecklist.Id
      );
    }
    List<genesis__Checklist__c> updatedChecklists = new List<genesis__Checklist__c>();
    for (
      ClassChecklistManualDataMapping eachChecklistMapping : checklistManualDataList
    ) {
      if (
        String.isNotBlank(eachChecklistMapping.ruleName) &&
        ruleChecklistMap.containsKey(eachChecklistMapping.ruleName)
      ) {
        if (!ruleChecklistMap.containsKey(eachChecklistMapping.ruleName)) {
          continue;
        }
        genesis__Checklist__c checklistObj = new genesis__Checklist__c(
          Id = ruleChecklistMap.get(eachChecklistMapping.ruleName)
        );
        if (
          String.isNotBlank(eachChecklistMapping.exceptionRecommender) &&
          !(eachChecklistMapping.exceptionRecommender).equalsIgnoreCase('null')
        ) {
          checklistObj.Exception_Recommender__c = eachChecklistMapping.exceptionRecommender;
        }
        if (
          String.isNotBlank(eachChecklistMapping.exceptionApprover) &&
          !(eachChecklistMapping.exceptionApprover).equalsIgnoreCase('null')
        ) {
          checklistObj.Exception_Approver__c = eachChecklistMapping.exceptionApprover;
        }
        if (
          String.isNotBlank(eachChecklistMapping.exceptionCommentary) &&
          !(eachChecklistMapping.exceptionCommentary).equalsIgnoreCase('null')
        ) {
          checklistObj.Exception_Commentary__c = eachChecklistMapping.exceptionCommentary;
        }
        if (
          String.isNotBlank(eachChecklistMapping.status) &&
          !(eachChecklistMapping.status).equalsIgnoreCase('null')
        ) {
          checklistObj.Status__c = eachChecklistMapping.status;
        }
        if (
          String.isNotBlank(eachChecklistMapping.supportingDocumentVerified) &&
          !(eachChecklistMapping.supportingDocumentVerified)
            .equalsIgnoreCase('null')
        ) {
          checklistObj.Supporting_Documentation__c = eachChecklistMapping.supportingDocumentVerified;
        }
        if (
          String.isNotBlank(eachChecklistMapping.waiverReason) &&
          !(eachChecklistMapping.waiverReason).equalsIgnoreCase('null')
        ) {
          checklistObj.Waiver_Reason__c = eachChecklistMapping.waiverReason;
        }
        updatedChecklists.add(checklistObj);
      }
    }
    Database.update(updatedChecklists, false);
  }
  public static void updateRuleDataOnPartiesFromChecklistDetails(
    List<clcommon__Party__c> partyList,
    List<String> rulesNameList
  ) {
    List<Id> partyIds = new List<Id>();
    for (clcommon__Party__c each : partyList) {
      partyIds.add(each.Id);
    }
    Map<String, List<Checklist_Detail__c>> partyChecklistDetailsMap = new Map<String, List<Checklist_Detail__c>>();
    List<Checklist_Detail__c> checklistDetailList = [
      SELECT
        Id,
        Party__c,
        Party__r.Name,
        Application_Collateral__c,
        Employment_Information__c,
        Income__c,
        Asset_Information__c,
        Liability__c,
        Checklist__r.genesis__Rule__r.Name,
        Exception_Approver__c,
        Exception_Commentary__c,
        Exception_Recommender__c,
        Condition_Status__c,
        Supporting_Document_Verified__c,
        Waiver_Reason__c,
        Show_on_Indicative_Approval_Letter__c
      FROM Checklist_Detail__c
      WHERE
        Party__c IN :partyIds
        AND Checklist__r.genesis__Rule__r.Name IN :rulesNameList
    ];
    for (Checklist_Detail__c eachChecklistDetail : checklistDetailList) {
      List<Checklist_Detail__c> checklistDetails = partyChecklistDetailsMap.get(
        eachChecklistDetail.Party__r.Name
      );
      if (checklistDetails == null) {
        checklistDetails = new List<Checklist_Detail__c>();
      }
      checklistDetails.add(eachChecklistDetail);
      partyChecklistDetailsMap.put(
        eachChecklistDetail.Party__r.Name,
        checklistDetails
      );
    }
    updateRuleDataOnSObjectsFromChecklistDetails(
      partyList,
      partyChecklistDetailsMap
    );
  }
  public static void updateRuleDataOnApplicationCollateralsFromChecklistDetails(
    List<genesis__Application_Collateral__c> appColList,
    List<String> rulesNameList
  ) {
    List<Id> appColIds = new List<Id>();
    for (genesis__Application_Collateral__c eachAppCollateral : appColList) {
      appColIds.add(eachAppCollateral.Id);
    }
    Map<String, List<Checklist_Detail__c>> appColChecklistDetailsMap = new Map<String, List<Checklist_Detail__c>>();
    List<Checklist_Detail__c> checklistDetailList = [
      SELECT
        Id,
        Party__c,
        Party__r.Name,
        Application_Collateral__c,
        Employment_Information__c,
        Asset_Information__c,
        Liability__c,
        Income__c,
        Application_Collateral__r.Name,
        Checklist__r.genesis__Rule__r.Name,
        Exception_Approver__c,
        Exception_Commentary__c,
        Exception_Recommender__c,
        Condition_Status__c,
        Supporting_Document_Verified__c,
        Waiver_Reason__c,
        Show_on_Indicative_Approval_Letter__c
      FROM Checklist_Detail__c
      WHERE
        Application_Collateral__c IN :appColIds
        AND Checklist__r.genesis__Rule__r.Name IN :rulesNameList
    ];
    for (Checklist_Detail__c eachChecklistDetail : checklistDetailList) {
      List<Checklist_Detail__c> checklistDetails = appColChecklistDetailsMap.get(
        eachChecklistDetail.Application_Collateral__r.Name
      );
      if (checklistDetails == null) {
        checklistDetails = new List<Checklist_Detail__c>();
      }
      checklistDetails.add(eachChecklistDetail);
      appColChecklistDetailsMap.put(
        eachChecklistDetail.Application_Collateral__r.Name,
        checklistDetails
      );
    }
    updateRuleDataOnSObjectsFromChecklistDetails(
      appColList,
      appColChecklistDetailsMap
    );
  }
  private static void updateRuleDataOnSObjectsFromChecklistDetails(
    List<SObject> sobjectList,
    Map<String, List<Checklist_Detail__c>> sobjectChecklistDetailsMap
  ) {
    List<SObject> updatedSObjects = new List<SObject>();
    for (SObject eachSobject : sobjectList) {
      List<Checklist_Detail__c> checklistDetails = sobjectChecklistDetailsMap.get(
        (String) eachSobject.get('Name')
      );
      if (checklistDetails == null) {
        checklistDetails = new List<Checklist_Detail__c>();
      }
      String manualData = '{"checklistManualDataMapping":[';
      Boolean flag = true;
      for (Checklist_Detail__c eachChecklistDetail : checklistDetails) {
        if (flag) {
          flag = false;
          manualData += '{';
        } else {
          manualData += ',{';
        }
        manualData += '"ruleName":"';
        if (
          String.isNotBlank(eachChecklistDetail.Checklist__c) &&
          String.isNotBlank(
            eachChecklistDetail.Checklist__r.genesis__Rule__c
          ) &&
          String.isNotBlank(
            eachChecklistDetail.Checklist__r.genesis__Rule__r.Name
          )
        ) {
          manualData += eachChecklistDetail.Checklist__r.genesis__Rule__r.Name;
        }
        if (String.isNotBlank(eachChecklistDetail.Application_Collateral__c)) {
          manualData += eachChecklistDetail.Application_Collateral__c;
        }
        if (String.isNotBlank(eachChecklistDetail.Employment_Information__c)) {
          manualData += eachChecklistDetail.Employment_Information__c;
        }
        if (String.isNotBlank(eachChecklistDetail.Party__c)) {
          manualData += eachChecklistDetail.Party__c;
        }
        if (String.isNotBlank(eachChecklistDetail.Income__c)) {
          manualData += eachChecklistDetail.Income__c;
        }
        if (String.isNotBlank(eachChecklistDetail.Asset_Information__c)) {
          manualData += eachChecklistDetail.Asset_Information__c;
        }
        if (String.isNotBlank(eachChecklistDetail.Liability__c)) {
          manualData += eachChecklistDetail.Liability__c;
        }
        manualData += '",';
        manualData +=
          '"exceptionRecommender":"' +
          eachChecklistDetail.Exception_Recommender__c +
          '",';
        manualData +=
          '"exceptionApprover":"' +
          eachChecklistDetail.Exception_Approver__c +
          '",';
        manualData +=
          '"exceptionCommentary":"' +
          eachChecklistDetail.Exception_Commentary__c +
          '",';
        manualData +=
          '"status":"' +
          eachChecklistDetail.Condition_Status__c +
          '",';
        manualData +=
          '"supportingDocumentVerified":"' +
          eachChecklistDetail.Supporting_Document_Verified__c +
          '",';
        manualData +=
          '"waiverReason":"' +
          eachChecklistDetail.Waiver_Reason__c +
          '",';
        manualData +=
          '"shownOnIndicativeLetter":"' +
          eachChecklistDetail.Show_on_Indicative_Approval_Letter__c +
          '"';
        manualData += '}';
      }
      manualData += ']}';
      sObjectNameManualDataMap.put(
        (String) eachSobject.get('Name'),
        manualData
      );
    }
  }

  public static List<Checklist_Detail__c> updateChecklistDetailsFromRuleDataOnParties(
    List<clcommon__Party__c> partyList,
    List<String> rulesNameList
  ) {
    List<Id> partyIds = new List<Id>();
    for (clcommon__Party__c eachParty : partyList) {
      partyIds.add(eachParty.Id);
    }
    List<Checklist_Detail__c> checklistDetailList = [
      SELECT
        Id,
        Name,
        Party__c,
        Party__r.Name,
        Application_Collateral__c,
        Employment_Information__c,
        Asset_Information__c,
        Liability__c,
        Income__c,
        Checklist__r.genesis__Rule__r.Name,
        Exception_Approver__c,
        Exception_Commentary__c,
        Exception_Recommender__c,
        Condition_Status__c,
        Supporting_Document_Verified__c,
        Waiver_Reason__c,
        Show_on_Indicative_Approval_Letter__c
      FROM Checklist_Detail__c
      WHERE
        Party__c IN :partyIds
        AND Checklist__r.genesis__Rule__r.Name IN :rulesNameList
    ];
    return updateChecklistDetailsFromRuleDataOnRelatedObjects(
      partyList,
      checklistDetailList,
      ConstantValues.PARTY_TAG
    );
  }
  public static List<Checklist_Detail__c> updateChecklistDetailsFromRuleDataOnApplicationCollaterals(
    List<genesis__Application_Collateral__c> appColList,
    List<String> rulesNameList
  ) {
    List<Id> appColIds = new List<Id>();
    for (genesis__Application_Collateral__c eachAppCollateral : appColList) {
      appColIds.add(eachAppCollateral.Id);
    }
    List<Checklist_Detail__c> checklistDetailList = [
      SELECT
        Id,
        Name,
        Application_Collateral__c,
        Application_Collateral__r.Name,
        Employment_Information__c,
        Asset_Information__c,
        Liability__c,
        Income__c,
        Party__c,
        Checklist__r.genesis__Rule__r.Name,
        Exception_Approver__c,
        Exception_Commentary__c,
        Exception_Recommender__c,
        Condition_Status__c,
        Supporting_Document_Verified__c,
        Waiver_Reason__c,
        Show_on_Indicative_Approval_Letter__c
      FROM Checklist_Detail__c
      WHERE
        Application_Collateral__c IN :appColIds
        AND Checklist__r.genesis__Rule__r.Name IN :rulesNameList
    ];
    return updateChecklistDetailsFromRuleDataOnRelatedObjects(
      appColList,
      checklistDetailList,
      ConstantValues.APPLICATION_COLLATERAL
    );
  }
  private static List<Checklist_Detail__c> updateChecklistDetailsFromRuleDataOnRelatedObjects(
    List<SObject> objectList,
    List<Checklist_Detail__c> checklistDetailList,
    String sObjectType
  ) {
    Map<String, Map<String, Id>> objectRuleChecklistDetailsMapMap = new Map<String, Map<String, Id>>();
    for (Checklist_Detail__c eachChecklist : checklistDetailList) {
      Map<String, Id> ruleChecklistDetailsMap;
      if (sObjectType.equals(ConstantValues.PARTY_TAG)) {
        ruleChecklistDetailsMap = objectRuleChecklistDetailsMapMap.get(
          eachChecklist.Party__r.Name
        );
      } else if (
        sObjectType.equals(ConstantValues.APPLICATION_COLLATERAL) &&
        String.isNotBlank(eachChecklist.Application_Collateral__c) &&
        String.isNotBlank(eachChecklist.Application_Collateral__r.Name)
      ) {
        ruleChecklistDetailsMap = objectRuleChecklistDetailsMapMap.get(
          eachChecklist.Application_Collateral__r.Name
        );
      } else {
        continue;
      }
      if (ruleChecklistDetailsMap == null) {
        ruleChecklistDetailsMap = new Map<String, Id>();
      }
      String ruleName = eachChecklist.Checklist__r.genesis__Rule__r.Name;
      if (String.isNotBlank(eachChecklist.Application_Collateral__c)) {
        ruleName += eachChecklist.Application_Collateral__c;
      }
      if (String.isNotBlank(eachChecklist.Employment_Information__c)) {
        ruleName += eachChecklist.Employment_Information__c;
      }
      if (String.isNotBlank(eachChecklist.Party__c)) {
        ruleName += eachChecklist.Party__c;
      }
      if (String.isNotBlank(eachChecklist.Income__c)) {
        ruleName += eachChecklist.Income__c;
      }
      if (String.isNotBlank(eachChecklist.Asset_Information__c)) {
        ruleName += eachChecklist.Asset_Information__c;
      }
      if (String.isNotBlank(eachChecklist.Liability__c)) {
        ruleName += eachChecklist.Liability__c;
      }
      ruleChecklistDetailsMap.put(ruleName, eachChecklist.Id);
      if (sObjectType.equals(ConstantValues.PARTY_TAG)) {
        ruleChecklistDetailsMap = objectRuleChecklistDetailsMapMap.put(
          eachChecklist.Party__r.Name,
          ruleChecklistDetailsMap
        );
      } else if (sObjectType.equals(ConstantValues.APPLICATION_COLLATERAL)) {
        ruleChecklistDetailsMap = objectRuleChecklistDetailsMapMap.put(
          eachChecklist.Application_Collateral__r.Name,
          ruleChecklistDetailsMap
        );
      } else {
        continue;
      }
    }
    List<Checklist_Detail__c> updatedChecklists = new List<Checklist_Detail__c>();
    for (SObject eachChecklistDetail : objectList) {
      String ruleManualData = sObjectNameManualDataMap.get(
        (String) eachChecklistDetail.get('Name')
      );
      if (String.isBlank(ruleManualData)) {
        continue;
      }
      CheckRules checkRulesObj = (CheckRules) System.JSON.deserialize(
        ruleManualData,
        CheckRules.class
      );
      ClassChecklistManualDataMapping[] checklistManualDataList = checkRulesObj.checklistManualDataMapping;
      Map<String, Id> ruleChecklistDetailsMap = objectRuleChecklistDetailsMapMap.get(
        (String) eachChecklistDetail.get('Name')
      );
      for (
        ClassChecklistManualDataMapping eachChecklistManualData : checklistManualDataList
      ) {
        if (
          String.isNotBlank(eachChecklistManualData.ruleName) &&
          ruleChecklistDetailsMap.containsKey(eachChecklistManualData.ruleName)
        ) {
          testing += eachChecklistManualData.ruleName + ' : ';
          // testing += ruleChecklistMap.get(eachChecklistManualData.ruleName) + ' : ';
          testing += (String) eachChecklistDetail.get('Name') + '\n';
          Checklist_Detail__c checklistObj = new Checklist_Detail__c(
            Id = ruleChecklistDetailsMap.get(eachChecklistManualData.ruleName)
          );
          if (
            String.isNotBlank(eachChecklistManualData.exceptionRecommender) &&
            !(eachChecklistManualData.exceptionRecommender)
              .equalsIgnoreCase('null')
          ) {
            checklistObj.Exception_Recommender__c = eachChecklistManualData.exceptionRecommender;
          }
          if (
            String.isNotBlank(eachChecklistManualData.exceptionApprover) &&
            !(eachChecklistManualData.exceptionApprover)
              .equalsIgnoreCase('null')
          ) {
            checklistObj.Exception_Approver__c = eachChecklistManualData.exceptionApprover;
          }
          if (
            String.isNotBlank(eachChecklistManualData.exceptionCommentary) &&
            !(eachChecklistManualData.exceptionCommentary)
              .equalsIgnoreCase('null')
          ) {
            checklistObj.Exception_Commentary__c = eachChecklistManualData.exceptionCommentary;
          }
          if (
            String.isNotBlank(eachChecklistManualData.status) &&
            !(eachChecklistManualData.status).equalsIgnoreCase('null')
          ) {
            checklistObj.Condition_Status__c = eachChecklistManualData.status;
          }
          if (
            String.isNotBlank(
              eachChecklistManualData.supportingDocumentVerified
            ) &&
            !(eachChecklistManualData.supportingDocumentVerified)
              .equalsIgnoreCase('null')
          ) {
            checklistObj.Supporting_Document_Verified__c = eachChecklistManualData.supportingDocumentVerified;
          }
          if (
            String.isNotBlank(eachChecklistManualData.waiverReason) &&
            !(eachChecklistManualData.waiverReason).equalsIgnoreCase('null')
          ) {
            checklistObj.Waiver_Reason__c = eachChecklistManualData.waiverReason;
          }
          if (
            String.isNotBlank(
              eachChecklistManualData.shownOnIndicativeLetter
            ) &&
            !(eachChecklistManualData.shownOnIndicativeLetter)
              .equalsIgnoreCase('null')
          ) {
            checklistObj.Show_on_Indicative_Approval_Letter__c = eachChecklistManualData.shownOnIndicativeLetter;
          }
          updatedChecklists.add(checklistObj);
        }
      }
    }
    return updatedChecklists;
  }
  private static void manupulateConditionText(Id applicationId) {
    String message;
    String gurantorNames = '';
    Boolean flag = false;
    try {
      List<Checklist_Detail__c> checklistDetails = [
        SELECT
          Id,
          Manual_Message__c,
          Status__c,
          Checklist__r.genesis__Rule__r.Name,
          Checklist__r.genesis__Rule__r.genesis__Message_failure__c,
          Party__c,
          Party__r.clcommon__Account__r.Name,
          Checklist__r.genesis__Application__c,
          Asset_Information__c,
          Asset_Information__r.Address__c,
          Asset_Information__r.genesis__Market_Value__c,
          Application_Collateral__c,
          Application_Collateral__r.genesis__Collateral__c,
          Application_Collateral__r.genesis__Collateral__r.Replacement_Value__c,
          Liability__c,
          Liability__r.genesis__Name_of_Creditor__c
        FROM Checklist_Detail__c
        WHERE
          Rule_Classification__c = :ConstantValues.CONDITION_CLASSIFICATION
          AND Status__c != :ConstantValues.SUCCESS_STATUS
          AND Checklist__r.genesis__Application__c = :applicationId
      ];
      List<clcommon__Party__c> gurantorParties = [
        SELECT
          Id,
          clcommon__Account__r.Name,
          Party_Type_Name__c,
          genesis__Application__c
        FROM clcommon__Party__c
        WHERE
          Party_Type_Name__c = :ConstantValues.GUARANTOR
          AND genesis__Application__c = :applicationId
      ];
      for (clcommon__Party__c eachGurantor : gurantorParties) {
        if (flag) {
          gurantorNames += ', ';
        } else {
          flag = true;
        }
        if (
          String.isNotBlank(eachGurantor.clcommon__Account__c) &&
          String.isNotBlank(eachGurantor.clcommon__Account__r.Name)
        ) {
          gurantorNames += eachGurantor.clcommon__Account__r.Name;
        }
      }
      for (Checklist_Detail__c eachChecklistDetails : checklistDetails) {
        message = eachChecklistDetails.Checklist__r.genesis__Rule__r.genesis__Message_failure__c;
        if (
          eachChecklistDetails.Checklist__r.genesis__Rule__r.Name ==
          ConstantValues.CUSTOMER_ACCT_CONDITION
        ) {
          message = message.replace(
            ConstantValues.GURANTORS_NAME_KEY,
            gurantorNames
          );
        } else if (
          eachChecklistDetails.Checklist__r.genesis__Rule__r.Name ==
          ConstantValues.DOES_APPLICANT_UNDERSTAND_ENGLISH_WARNING
        ) {
          message = message.replace(
            ConstantValues.DOES_APPLICANT_UNDERSTAND_ENG_COND_TXT_KEY,
            ConstantValues.DOES_APPLICANT_UNDERSTAND_ENG_COND_TXT
          );
          message = message.replace(
            ConstantValues.IND_APPLICANT_KEY,
            eachChecklistDetails.Party__r.clcommon__Account__r.Name
          );
        } else if (
          eachChecklistDetails.Checklist__r.genesis__Rule__r.Name ==
          ConstantValues.GIFT_STAT_DEC_RECEIVED_CONDITION
        ) {
          if (eachChecklistDetails.Asset_Information__c != null) {
            if (
              String.isNotBlank(
                eachChecklistDetails.Asset_Information__r.Address__c
              )
            ) {
              message = message.replace(
                ConstantValues.GIFT_GIVER_NAME_KEY,
                eachChecklistDetails.Asset_Information__r.Address__c
              );
            }
            if (
              eachChecklistDetails.Asset_Information__r.genesis__Market_Value__c !=
              null
            ) {
              message = message.replace(
                ConstantValues.GIFT_AMOUNT_KEY,
                String.valueOf(
                  eachChecklistDetails.Asset_Information__r.genesis__Market_Value__c
                )
              );
            }
          }
        } else if (
          eachChecklistDetails.Checklist__r.genesis__Rule__r.Name ==
          ConstantValues.TO_BE_REFINANCED_WARNING
        ) {
          if (eachChecklistDetails.Liability__c != null) {
            if (
              String.isNotBlank(
                eachChecklistDetails.Liability__r.genesis__Name_of_Creditor__c
              )
            ) {
              message = message.replace(
                ConstantValues.LENDER_DETAILS_KEY,
                eachChecklistDetails.Liability__r.genesis__Name_of_Creditor__c
              );
            }
          }
        } else if (
          eachChecklistDetails.Checklist__r.genesis__Rule__r.Name ==
          ConstantValues.HMI_STANDARD_CONDITION
        ) {
          if (
            eachChecklistDetails.Application_Collateral__c != null &&
            eachChecklistDetails.Application_Collateral__r.genesis__Collateral__r !=
            null &&
            eachChecklistDetails.Application_Collateral__r.genesis__Collateral__r.Replacement_Value__c !=
            null
          ) {
            Decimal replacementVal = eachChecklistDetails.Application_Collateral__r.genesis__Collateral__r.Replacement_Value__c;
            List<String> args = new List<String>{
              '0',
              'number',
              '###,###,##0.00'
            };
            String stringVal = String.format(replacementVal.format(), args);
            stringVal = (stringVal.contains('.')
              ? stringVal
              : (stringVal + '.00'));
            message = message.replace(
              ConstantValues.REPLACEMENT_VALUE_KEY,
              stringVal
            );
          }
        }
        eachChecklistDetails.Manual_Message__c = message;
      }
      Database.update(checklistDetails, false);
    } catch (Exception ex) {
      GenericUtility.insertLog('CheckRules.manupulateConditionText', ex);
    }
  }
}