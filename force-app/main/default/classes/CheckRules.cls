/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Koushik Mondal
Development Date : 29/07/2020
Last Modified By : Rameswari Barman
Last Modified Date : 21/08/2020
Description : This class query all the Rules and check the Rule Criteria for the Loan Application.
***********************************************************************************************************************************************************/

global with sharing class CheckRules {
    private static List<genesis__Rule__c> ruleList = [SELECT Id,
                                                        Name,
                                                        genesis__Message_success__c,
                                                        genesis__Message_failure__c
                                                        FROM genesis__Rule__c
                                                        WHERE genesis__Enabled__c = true
                                                        AND (Name = 'Risk Grade Compare Warning'
                                                        OR Name = 'Primary Purpose Warning')];
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
            // applicationRecordId = applicationId.substring(0,applicationId.length()-3);
            applicationRecordId = applicationId;
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
                rulesNameList.add('Arms Length Valuer Commentary Exception');
                rulesNameList.add('110% Check Exception');
                rulesNameList.add('Valuation Required Exception');
                rulesNameList.add('Valuation Received Exception');
                rulesNameList.add('Licenced Builder Exception');
                rulesNameList.add('ABN Status Exception');
                rulesNameList.add('BAS % Exception');
                rulesNameList.add('Broker Documents Warning');
                rulesNameList.add('Politically Exposed Person Warning');
                rulesNameList.add('KYC/AML Verified Warning');
                rulesNameList.add('Risk Grade Warning');
                rulesNameList.add('Explanation of Credit Events Warning');
                rulesNameList.add('Explanation Provided Warning');
                rulesNameList.add('Exit Strategy Provided Applicant Warning');
                rulesNameList.add('ABN Status Explanation Provided Warning');
                rulesNameList.add('Living Expense Explanation Received Warning');
                rulesNameList.add('Telephone, Internet, Pay TV & Media Streaming Warning');
                rulesNameList.add('Groceries Warning');
                rulesNameList.add('Recreation and Entertainment Warning');
                rulesNameList.add('Clothing and Personal Care Warning');
                rulesNameList.add('Medical and Health Warning');
                rulesNameList.add('Transport Warning');
                rulesNameList.add('Insurance (Excluding Private Health, Life, IP) Warning');
                rulesNameList.add('Contract Of Sale Warning');
                rulesNameList.add('Valued Date Warning');
                rulesNameList.add('Licenced Real Estate Agent Contract Warning');
                rulesNameList.add('Comparable Sales Evident Warning');
                rulesNameList.add('Valuer Risk Gradings Commentary Warning');
                rulesNameList.add('Land Area Warning');
                rulesNameList.add('Floor Area Warning');
                rulesNameList.add('ABN Effective From Warning');
                rulesNameList.add('ABN Effective From Exception');
                rulesNameList.add('Estimated Completion Date Warning');
                rulesNameList.add('HEM Warning');
                rulesNameList.add('GST Effective From Warning');
                rulesNameList.add('Accountant ABN Status Warning');
                rulesNameList.add('Accountant Phone Number Verified Warning');
                rulesNameList.add('Accountant Call Warning');
                rulesNameList.add('Accountant ABN Search Conducted Warning');
                rulesNameList.add('Primary Residence Property Cost Warning');
                rulesNameList.add('Employer Phone Independently Verified Warning');
                rulesNameList.add('Income Verification Sighted Warning');
                rulesNameList.add('Employment Duration (Months) Warning');
                rulesNameList.add('Employer Verfied Warning');
                rulesNameList.add('Is Director a Beneficiary / Member Warning');
                rulesNameList.add('Is Trustee a Beneficiary / Member Warning');
                rulesNameList.add('Is General Security Agreement Being Taken over this Applicant Warning Check');
                rulesNameList.add('Education and Childcare Warning');
                rulesNameList.add('Investment Property Warning Check');
                rulesNameList.add('Rent/Board (post settlement of this facility) Warning');
                rulesNameList.add('Is Purchaser the Mortgagor Condition Check');
                rulesNameList.add('Home Insurance Certificate Provide Condition');
                rulesNameList.add('Home Insurance Certificate Provide and Body Corporate Condition');
                rulesNameList.add('Home Insurance Certificate Provide and Standard Condition');
                rulesNameList.add('Signed Contract Condition');
                rulesNameList.add('Fixed Price Contract Condition');
                rulesNameList.add('Detailed Costings Held Condition');
                rulesNameList.add('Copy Builders Licence Held Condition');
                rulesNameList.add('Copy Home Owners Warranty Certificate Held Condition');
                rulesNameList.add('Council Approval Held Condition');
                rulesNameList.add('SMSF Status Condition');
                rulesNameList.add('Trust Deed Provided Condition');
                rulesNameList.add('ABN Effective From Living Expense Warning');
                rulesNameList.add('GST Effective From Living Expense Warning');
                rulesNameList.add('Private Pension Amount Warning');
                rulesNameList.add('Other Income Amount Warning');
                rulesNameList.add('Superannuation Amount Warning');
                rulesNameList.add('Location Warning');
                rulesNameList.add('Location Not Acceptable Warning');
                rulesNameList.add('Type of Documents Sighted Warning 1');
                rulesNameList.add('Type of Documents Sighted Warning 2');
                rulesNameList.add('To Be Refinance Condition');
                rulesNameList.add('Gift Stat Dec Received Condition');
                rulesNameList.add('Rental Income Verified Warning');
                rulesNameList.add('Previous conduct explanation received Warning');
                rulesNameList.add('Previous conduct referencing completed Warning');
            }
            else if(tabName == 'APP_XCEP'){
                rulesNameList.add('Matrix Rate Exception');
                rulesNameList.add('Confirm Repayments do not double Exception');
                rulesNameList.add('Override Exception');
                rulesNameList.add('Interest Only Reason Warning');
                rulesNameList.add('Exit Strategy Provided Warning');
                rulesNameList.add('Fixed Rate Lock In Date Warning');
                rulesNameList.add('Matrix Rate Warning');
                rulesNameList.add('Actual LVR > 80% Warning');
                rulesNameList.add('Actual LVR > 70% Warning');
                rulesNameList.add('Actual LVR > 75% Warning');
                rulesNameList.add('Cash Out Purpose Explanation Provided Warning');
                rulesNameList.add('Application Fee Warning');
                rulesNameList.add('Application Fee % Warning');
                loanDetailsRiskGradeWarningCheck(applicationId);
                loanDetailsPrimaryPurposeWarningCheck(applicationId);
                rulesNameList.add('Does applicant understand English Condition');
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
            if(tabName != ConstantValues.LOAN_DETAILS && tabName != ConstantValues.SETTLEMENT && tabName != 'APP_XCEP'){
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
      private static void loanDetailsRiskGradeWarningCheck(Id appId){
        try{
            genesis__Rule__c riskGradeCompRule;
            for(genesis__Rule__c each : ruleList){
                if((each.Name).equals('Risk Grade Compare Warning')){
                    riskGradeCompRule = each;
                }
            }
            if(riskGradeCompRule == null){
                return;
            }
            genesis__Applications__c appObj = [SELECT Id,
                                                Risk_grade_list__c
                                                FROM genesis__Applications__c
                                                WHERE Id =:appId
                                                LIMIT 1];
            if(appObj == null){
                return;
            }
            Map<String, Integer> riskGradeValued = new Map<String, Integer>();
            riskGradeValued.put('Prime', 0);
            riskGradeValued.put('Near Prime', 1);
            riskGradeValued.put('Near Prime +', 2);
            riskGradeValued.put('Specialist', 3);
            riskGradeValued.put('Specialist +', 4);
            List<genesis__Checklist__c> previousChecklists = [SELECT Id
                                                                FROM genesis__Checklist__c
                                                                WHERE genesis__Rule__c =:riskGradeCompRule.Id
                                                                AND genesis__Application__c =:appId];
            Database.delete(previousChecklists, false);
            List<clcommon__Party__c> parties = [SELECT Id,
                                                Legal_Entity_Type__c,
                                                Party_Type_Name__c,
                                                Risk_Grade__c,
                                                genesis__Application__c
                                                FROM clcommon__Party__c
                                                WHERE genesis__Application__c =:appId];
            Integer lowestRiskGrade = 5;
            for(clcommon__Party__c each : parties){
                if(String.IsNotBlank(each.Risk_Grade__c)){
                    if(riskGradeValued.containsKey(each.Risk_Grade__c) &&
                    riskGradeValued.get(each.Risk_Grade__c) < lowestRiskGrade){
                        lowestRiskGrade = riskGradeValued.get(each.Risk_Grade__c);
                    }
                }
            }
            if(lowestRiskGrade == 5){
                successCheckList(riskGradeCompRule, appId);
                return;
            }
            else if(String.isBlank(appObj.Risk_grade_list__c)){
                errorCheckList(riskGradeCompRule, appId);
                return;
            }
            Integer val = riskGradeValued.get(appObj.Risk_grade_list__c);
            if(lowestRiskGrade != val){
                errorCheckList(riskGradeCompRule, appId);
            }
            else{
                successCheckList(riskGradeCompRule, appId);
            }
        }
        catch(Exception ex){
            GenericUtility.insertLog('CheckRules.loanDetailsRiskGradeWarningCheck', ex);
        }
      }
      private static void loanDetailsPrimaryPurposeWarningCheck(Id appId){
        try{
            genesis__Rule__c primPurpCompRule;
            for(genesis__Rule__c each : ruleList){
                if((each.Name).equals('Primary Purpose Warning')){
                    primPurpCompRule = each;
                }
            }
            if(primPurpCompRule == null){
                return;
            }
            genesis__Applications__c appObj = [SELECT Id,
                                                Primary_loan_purpose_list__c
                                                FROM genesis__Applications__c
                                                WHERE Id =:appId
                                                LIMIT 1];
            if(appObj == null){
                return;
            }
            List<genesis__Checklist__c> previousChecklists = [SELECT Id
                                                                FROM genesis__Checklist__c
                                                                WHERE genesis__Rule__c =:primPurpCompRule.Id
                                                                AND genesis__Application__c =:appId];
            Database.delete(previousChecklists, false);
            List<genesis__Application_Collateral__c> appCollaterals = [SELECT Id,
                                                                        genesis__Application__c,
                                                                        genesis__Collateral__r.Primary_Purpose__c
                                                                        FROM genesis__Application_Collateral__c
                                                                        WHERE genesis__Application__c =:appId];
            String prevPrimPurp = appCollaterals[0].genesis__Collateral__r.Primary_Purpose__c;
            for(genesis__Application_Collateral__c each : appCollaterals){
                if(String.isBlank(each.genesis__Collateral__r.Primary_Purpose__c)){
                    errorCheckList(primPurpCompRule, appId);
                    return;
                }
                else if(prevPrimPurp != each.genesis__Collateral__r.Primary_Purpose__c){
                    errorCheckList(primPurpCompRule, appId);
                    return;
                }
                prevPrimPurp = each.genesis__Collateral__r.Primary_Purpose__c;
            }
            if(appObj.Primary_loan_purpose_list__c != prevPrimPurp){
                errorCheckList(primPurpCompRule, appId);
            }else{
                successCheckList(primPurpCompRule, appId);
            }
        }
        catch(Exception ex){
            GenericUtility.insertLog('CheckRules.loanDetailsPrimaryPurposeWarningCheck', ex);
        }
      }
      private static void successCheckList(genesis__Rule__c rule, Id appId){
        genesis__Checklist__c checklistObj = new genesis__Checklist__c();
        checklistObj.genesis__Application__c = appId;
        checklistObj.genesis__Assessed_Record_Id__c = appId;
        checklistObj.genesis__Level__c = 'INFO';
        checklistObj.genesis__Rule__c = rule.Id;
        checklistObj.genesis__Message__c = rule.genesis__Message_success__c;
        Database.insert(checklistObj);
      }
      private static void errorCheckList(genesis__Rule__c rule, Id appId){
        genesis__Checklist__c checklistObj = new genesis__Checklist__c();
        checklistObj.genesis__Application__c = appId;
        checklistObj.genesis__Assessed_Record_Id__c = appId;
        checklistObj.genesis__Level__c = 'ERROR';
        checklistObj.genesis__Rule__c = rule.Id;
        checklistObj.genesis__Message__c = rule.genesis__Message_failure__c;
        Database.insert(checklistObj);
      }
}