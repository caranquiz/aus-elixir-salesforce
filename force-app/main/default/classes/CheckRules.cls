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
                                                        OR Name = 'Primary Purpose Warning'
                                                        OR Name = 'Document Type Compare Warning'
                                                        OR Name = 'Valuation Paid Warning')];
    private static String applicationManualData;
    private static Map<String, String> sObjectNameManualDataMap = new Map<String, String>();

    private static String testing = '';

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
            if(tabName == 'Recommended'){
                rulesNameList.add(ConstantValues.CASHOUT_PURPOSE_RULE);
                rulesNameList.add(ConstantValues.COMMISSION_MANADATE_PERCENTAGE_RULE);
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
                rulesNameList.add(ConstantValues.INCOME_INCONSISTANT_WITH_DECLARATION_RULE);
                rulesNameList.add(ConstantValues.GST_EFFECTIVE_FROM_RULE);
                rulesNameList.add(ConstantValues.LIVING_EXPENSE_EXPLANATION_SUITABLE_RULE);
                rulesNameList.add(ConstantValues.BANK_STATEMENT_REVIEWED_RULE);
                rulesNameList.add(ConstantValues.SATISFACTORY_EXPLANATION_PROVIDED_RULE);
                rulesNameList.add(ConstantValues.ACL_VERIFIED_RULE);
                rulesNameList.add(ConstantValues.COMMISSION_STATUS_RULE);
                rulesNameList.add(ConstantValues.PREVIOUS_CONDUCT_SUITABLE);
            }
            else if(tabName == ConstantValues.LOAN_DETAILS){
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
                rulesNameList.add(ConstantVAlues.ABN_EFFECTIVE_RULE);
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
                rulesNameList.add('Trail (%) Exception');
                rulesNameList.add('Upfront Payment (%) Exception');
                rulesNameList.add('Arms Length Valuer Commentary Exception');
                rulesNameList.add('110% Check Exception');
                rulesNameList.add('Valuation Required Exception');
                rulesNameList.add('Valuation Received Exception');
                rulesNameList.add('Licenced Builder Exception');
                rulesNameList.add('ABN Status Exception');
                rulesNameList.add('Override Employment Exception');
                rulesNameList.add('BAS % Exception');
                rulesNameList.add('Employment Call Made Exception');
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
                rulesNameList.add('Is Purchaser the Mortgagor Condition');
                rulesNameList.add('Home Insurance Certificate Provide Warning');
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
                rulesNameList.add('ABN Status Employment Exception');
                rulesNameList.add('Does applicant understand English Condition');
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
                rulesNameList.add('Is the Application Form fully completed? Warning');
                loanDetailsRiskGradeWarningCheck(applicationId);
                loanDetailsPrimaryPurposeWarningCheck(applicationId);
                loanDetailsDocumentCompareWarningCheck(applicationId);
                loanDetailsValuationPaidWarningCheck(applicationId);
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
                                                    Cash_Out_Purpose_Suitable_Rule_Check__c,
                                                    Rule_Manual_Data__c
                                                    FROM genesis__Applications__c 
                                                    WHERE id = :applicationRecordId
                                                    LIMIT 1];
            List<clcommon__Party__c> partyList = [SELECT Id, Name, genesis__Application__c,
                                                    Rule_Manual_Data__c
                                                    FROM clcommon__Party__c
                                                    WHERE genesis__Application__c =:applicationRecordId];
            List<genesis__Application_Collateral__c> appColList = [SELECT Id, Name, genesis__Application__c,
                                                                    Rule_Manual_Data__c
                                                                    FROM genesis__Application_Collateral__c
                                                                    WHERE genesis__Application__c =:applicationRecordId];
            if(tabName == 'APP_XCEP') {
                updateRuleDataOnApplcationFromChecklists(application, rulesNameList);
            } else if(tabName == ConstantValues.REVIEW){
                updateRuleDataOnPartiesFromChecklistDetails(partyList, rulesNameList);
                updateRuleDataOnApplicationCollateralsFromChecklistDetails(appColList, rulesNameList);
            }
            if(Test.isRunningTest() == false){
                previousChecklistList = [SELECT Id,
                                        genesis__Application__c,
                                        genesis__Assessed_Record_Id__c,
                                        genesis__Is_Archived__c ,
                                        genesis__Level__c,
                                        genesis__Message__c,
                                        genesis__Rule__c,
                                        genesis__Rule__r.Name,
                                        genesis__Type__c
                                        FROM genesis__Checklist__c 
                                        WHERE genesis__Application__c  =: applicationRecordId
                                        AND genesis__Rule__r.Name =: rulesNameList];
                if(previousChecklistList != NULL && previousChecklistList.size() > 0){
                    Database.delete(previousChecklistList);
                }
                checkList = genesis.RulesAPI.evaluateRules(application, mapRules.values(), true, true);
            }
            else{
                checkList = [SELECT Id,
                                genesis__Application__c,
                                genesis__Assessed_Record_Id__c,
                                genesis__Is_Archived__c ,
                                genesis__Level__c,
                                genesis__Message__c,
                                genesis__Rule__c,
                                genesis__Rule__r.Name,
                                genesis__Type__c
                                FROM genesis__Checklist__c];
            }
            if(tabName == 'APP_XCEP') {
                updateChecklistsFromRuleDataOnApplication(application, rulesNameList);
            }
            if(tabName != ConstantValues.LOAN_DETAILS && tabName != ConstantValues.SETTLEMENT && tabName != 'APP_XCEP'){
                ChildChecklistAPI api = new ChildChecklistAPI();
                List<Checklist_Detail__c> listOfDetail = api.processListOfChecklist(checkList, applicationRecordId);
                Database.insert(listOfDetail);
                try{
                    List<Checklist_Detail__c> updatedChecklistDetails = new List<Checklist_Detail__c>();
                    updatedChecklistDetails.addAll(updateChecklistDetailsFromRuleDataOnParties(partyList, rulesNameList));
                    updatedChecklistDetails.addAll(updateChecklistDetailsFromRuleDataOnApplicationCollaterals(appColList, rulesNameList));
                    Database.update(updatedChecklistDetails);
                } catch(Exception ex){
                    GenericUtility.insertLog('Checklist Details Updation Error', ex);
                }
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
        ){
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
            Id previousChecklistId;
            if(previousChecklists.isEmpty()){
                previousChecklistId = null;
            } else {
                previousChecklistId = previousChecklists[0].Id;
            }
            // Database.delete(previousChecklists, false);
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
                successCheckList(riskGradeCompRule, appId, previousChecklistId);
                return;
            }
            else if(String.isBlank(appObj.Risk_grade_list__c)){
                errorCheckList(riskGradeCompRule, appId, previousChecklistId);
                return;
            }
            Integer val = riskGradeValued.get(appObj.Risk_grade_list__c);
            if(lowestRiskGrade != val){
                errorCheckList(riskGradeCompRule, appId, previousChecklistId);
            }
            else{
                successCheckList(riskGradeCompRule, appId, previousChecklistId);
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
            List<genesis__Checklist__c> previousChecklist = [SELECT Id, genesis__Rule__c
                                                        FROM genesis__Checklist__c
                                                        WHERE genesis__Rule__c =:primPurpCompRule.Id
                                                        AND genesis__Application__c =:appId];
            Id previousChecklistId;
            if(previousChecklist.isEmpty()){
                previousChecklistId = null;
            } else {
                previousChecklistId = previousChecklist[0].Id;
            }
            // Database.delete(previousChecklists, false);
            List<genesis__Application_Collateral__c> appCollaterals = [SELECT Id,
                                                                        genesis__Application__c,
                                                                        genesis__Collateral__r.Primary_Purpose__c
                                                                        FROM genesis__Application_Collateral__c
                                                                        WHERE genesis__Application__c =:appId];
            if(appCollaterals.isEmpty()){
                return;
            }
            String prevPrimPurp = appCollaterals[0].genesis__Collateral__r.Primary_Purpose__c;
            for(genesis__Application_Collateral__c each : appCollaterals){
                if(String.isBlank(each.genesis__Collateral__r.Primary_Purpose__c)){
                    errorCheckList(primPurpCompRule, appId, previousChecklistId);
                    return;
                }
                else if(prevPrimPurp != each.genesis__Collateral__r.Primary_Purpose__c){
                    errorCheckList(primPurpCompRule, appId, previousChecklistId);
                    return;
                }
                prevPrimPurp = each.genesis__Collateral__r.Primary_Purpose__c;
            }
            if(appObj.Primary_loan_purpose_list__c != prevPrimPurp){
                errorCheckList(primPurpCompRule, appId, previousChecklistId);
            }else{
                successCheckList(primPurpCompRule, appId, previousChecklistId);
            }
        }
        catch(Exception ex){
            GenericUtility.insertLog('CheckRules.loanDetailsPrimaryPurposeWarningCheck', ex);
        }
    }
    private static void loanDetailsDocumentCompareWarningCheck(Id appId){
        try{
            genesis__Rule__c docTypeCompRule;
            for(genesis__Rule__c each : ruleList){
                if((each.Name).equals('Document Type Compare Warning')){
                    docTypeCompRule = each;
                }
            }
            if(docTypeCompRule == null){
                return;
            }
            genesis__Applications__c appObj = [SELECT Id,
                                                Document_Type__c
                                                FROM genesis__Applications__c
                                                WHERE Id =:appId
                                                LIMIT 1];
            if(appObj == null){
                return;
            }
            List<genesis__Checklist__c> previousChecklist = [SELECT Id, genesis__Rule__c
                                                        FROM genesis__Checklist__c
                                                        WHERE genesis__Rule__c =:docTypeCompRule.Id
                                                        AND genesis__Application__c =:appId];
            Id previousChecklistId;
            if(previousChecklist.isEmpty()){
                previousChecklistId = null;
            } else {
                previousChecklistId = previousChecklist[0].Id;
            }
            // Database.delete(previousChecklists, false);
            List<clcommon__Party__c> parties = [SELECT Id,
                                                Document_Type__c,
                                                Legal_Entity_Type__c
                                                FROM clcommon__Party__c
                                                WHERE genesis__Application__c =:appId
                                                AND Legal_Entity_Type__c != 'Individual'];
            List<genesis__Employment_Information__c> empInfoList = [SELECT Id,
                                                                    RecordType.Name,
                                                                    genesis__Application__c,
                                                                    Document_Type__c
                                                                    FROM genesis__Employment_Information__c
                                                                    WHERE RecordType.Name = 'Self Employed'
                                                                    AND genesis__Application__c =:appId];
            if(parties.isEmpty()){
                return;
            }
            String prevDocType = parties[0].Document_Type__c;
            for(clcommon__Party__c each : parties){
                if(String.isBlank(each.Document_Type__c)){
                    errorCheckList(docTypeCompRule, appId, previousChecklistId);
                    return;
                }
                else if(prevDocType != each.Document_Type__c){
                    errorCheckList(docTypeCompRule, appId, previousChecklistId);
                    return;
                }
                prevDocType = each.Document_Type__c;
            }
            if(!empInfoList.isEmpty()){
                prevDocType = empInfoList[0].Document_Type__c;
                for(genesis__Employment_Information__c each : empInfoList){
                    if(String.isBlank(each.Document_Type__c)){
                        errorCheckList(docTypeCompRule, appId, previousChecklistId);
                        return;
                    }
                    else if(prevDocType != each.Document_Type__c){
                        errorCheckList(docTypeCompRule, appId, previousChecklistId);
                        return;
                    }
                    prevDocType = each.Document_Type__c;
                }
            }
            if((appObj.Document_Type__c).equalsIgnoreCase('Full Doc') && !(prevDocType).equalsIgnoreCase('Full')){
                errorCheckList(docTypeCompRule, appId, previousChecklistId);
            } else if((appObj.Document_Type__c).equalsIgnoreCase('Alt Doc') && !(prevDocType).equalsIgnoreCase('Alt')){
                errorCheckList(docTypeCompRule, appId, previousChecklistId);
            } else{
                successCheckList(docTypeCompRule, appId, previousChecklistId);
            }
        }
        catch(Exception ex){
            GenericUtility.insertLog('CheckRules.loanDetailsDocumentCompareWarningCheck', ex);
        }
    }
    public static void loanDetailsValuationPaidWarningCheck(Id appId){
        try{
            genesis__Rule__c valPaidRule;
            for(genesis__Rule__c each : ruleList){
                if((each.Name).equals('Valuation Paid Warning')){
                    valPaidRule = each;
                }
            }
            if(valPaidRule == null){
                return;
            }
            genesis__Applications__c appObj = [SELECT Id,
                                                Valuation_Fee_Collected_at_Settlement__c
                                                FROM genesis__Applications__c
                                                WHERE Id =:appId
                                                LIMIT 1];
            if(appObj == null){
                return;
            }
            List<genesis__Checklist__c> previousChecklist = [SELECT Id, genesis__Rule__c
                                                        FROM genesis__Checklist__c
                                                        WHERE genesis__Rule__c =:valPaidRule.Id
                                                        AND genesis__Application__c =:appId];
            Id previousChecklistId;
            if(previousChecklist.isEmpty()){
                previousChecklistId = null;
            } else {
                previousChecklistId = previousChecklist[0].Id;
            }
            // Database.delete(previousChecklists, false);
            List<genesis__Application_Collateral__c> appCollaterals = [SELECT Id,
                                                                        genesis__Application__c,
                                                                        genesis__Collateral__c,
                                                                        genesis__Collateral__r.Valuation_Paid__c,
                                                                        genesis__Collateral__r.Valuation_Paid_Render_Check__c
                                                                        FROM genesis__Application_Collateral__c
                                                                        WHERE genesis__Application__c =:appId];
            if(appCollaterals.isEmpty()){
                return;
            }
            if(appObj.Valuation_Fee_Collected_at_Settlement__c != 'No'){
                successCheckList(valPaidRule, appId, previousChecklistId);
                return;
            }
            for(genesis__Application_Collateral__c each : appCollaterals){
                System.debug(each);
                if(each.genesis__Collateral__c == null){
                    continue;
                }
                System.debug(each.genesis__Collateral__r.Valuation_Paid_Render_Check__c);
                System.debug(each.genesis__Collateral__r.Valuation_Paid__c);
                if(each.genesis__Collateral__r.Valuation_Paid_Render_Check__c
                && each.genesis__Collateral__r.Valuation_Paid__c != 'Yes'){
                    System.debug('CALLED');
                    errorCheckList(valPaidRule, appId, previousChecklistId);
                    return;
                }
            }
            successCheckList(valPaidRule, appId, previousChecklistId);
        }
        catch(Exception ex){
            GenericUtility.insertLog('CheckRules.loanDetailsValuationPaidWarningCheck', ex);
        }
    }
    private static void successCheckList(genesis__Rule__c rule, Id appId, Id checklistId){
        genesis__Checklist__c checklistObj;
        if(String.isBlank(checklistId)){
            checklistObj = new genesis__Checklist__c();
        } else {
            checklistObj = new genesis__Checklist__c(Id = checklistId);
        }
        checklistObj.genesis__Application__c = appId;
        checklistObj.genesis__Assessed_Record_Id__c = appId;
        checklistObj.genesis__Level__c = 'INFO';
        checklistObj.genesis__Rule__c = rule.Id;
        checklistObj.genesis__Message__c = rule.genesis__Message_success__c;
        Database.upsert(checklistObj);
    }
    private static void errorCheckList(genesis__Rule__c rule, Id appId, Id checklistId){
        genesis__Checklist__c checklistObj;
        if(String.isBlank(checklistId)){
            checklistObj = new genesis__Checklist__c();
        } else {
            checklistObj = new genesis__Checklist__c(Id = checklistId);
        }
        checklistObj.genesis__Application__c = appId;
        checklistObj.genesis__Assessed_Record_Id__c = appId;
        checklistObj.genesis__Level__c = 'ERROR';
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
	}
    public static void updateRuleDataOnApplcationFromChecklists(genesis__Applications__c appObj, List<String> rulesNameList){
        List<genesis__Checklist__c> checklistList = [SELECT Id, genesis__Rule__r.Name,
                                                        Exception_Approver__c,
                                                        Exception_Commentary__c,
                                                        Exception_Recommender__c,
                                                        Status__c,
                                                        Supporting_Documentation__c,
                                                        Waiver_Reason__c
                                                        FROM genesis__Checklist__c
                                                        WHERE genesis__Rule__r.Name IN:rulesNameList
                                                        AND genesis__Application__c =:appObj.Id];
        Map<String, genesis__Checklist__c> ruleChecklistMap = new Map<String, genesis__Checklist__c>();
        String manualData = '{"checklistManualDataMapping":[';
        Boolean flag = true;
        for(genesis__Checklist__c each : checklistList){
            if(flag){
                flag = false;
                manualData += '{';
            }else {
                manualData += ',{';
            }
            manualData += '"ruleName":"' + each.genesis__Rule__r.Name + '",';
            manualData += '"exceptionRecommender":"' + each.Exception_Recommender__c + '",';
            manualData += '"exceptionApprover":"' + each.Exception_Approver__c + '",';
            manualData += '"exceptionCommentary":"' + each.Exception_Commentary__c + '",';
            manualData += '"status":"' + each.Status__c + '",';
            manualData += '"supportingDocumentVerified":"' + each.Supporting_Documentation__c + '",';
            manualData += '"waiverReason":"' + each.Waiver_Reason__c + '"';
            manualData += '}';
        }
        manualData += ']}';
        applicationManualData = manualData;
    }
    public static void updateChecklistsFromRuleDataOnApplication(genesis__Applications__c appObj, List<String> rulesNameList){
        if(String.isBlank(applicationManualData)){
            return;
        }
        String ruleManualData = applicationManualData;
        CheckRules checkRulesObj = (CheckRules) System.JSON.deserialize(ruleManualData, CheckRules.class);
        ClassChecklistManualDataMapping[] checklistManualDataList = checkRulesObj.checklistManualDataMapping;
        List<genesis__Checklist__c> checklistList = [SELECT Id, genesis__Rule__r.Name
                                                        FROM genesis__Checklist__c
                                                        WHERE genesis__Rule__r.Name IN:rulesNameList
                                                        AND genesis__Application__c =:appObj.Id];
        Map<String, Id> ruleChecklistMap = new Map<String, Id>();
        for(genesis__Checklist__c each : checklistList){
            ruleChecklistMap.put(each.genesis__Rule__r.Name, each.Id);
        }
        List<genesis__Checklist__c> updatedChecklists = new List<genesis__Checklist__c>();
        for(ClassChecklistManualDataMapping each : checklistManualDataList){
            if(String.isNotBlank(each.ruleName) && ruleChecklistMap.containsKey(each.ruleName)){
                if(!ruleChecklistMap.containsKey(each.ruleName)){
                    continue;
                }
                genesis__Checklist__c checklistObj = new genesis__Checklist__c(Id = ruleChecklistMap.get(each.ruleName));
                if(String.isNotBlank(each.exceptionRecommender) && !(each.exceptionRecommender).equalsIgnoreCase('null')){
                    checklistObj.Exception_Recommender__c = each.exceptionRecommender;
                } if(String.isNotBlank(each.exceptionApprover) && !(each.exceptionApprover).equalsIgnoreCase('null')){
                    checklistObj.Exception_Approver__c = each.exceptionApprover;
                } if(String.isNotBlank(each.exceptionCommentary) && !(each.exceptionCommentary).equalsIgnoreCase('null')){
                    checklistObj.Exception_Commentary__c = each.exceptionCommentary;
                } if(String.isNotBlank(each.status) && !(each.status).equalsIgnoreCase('null')){
                    checklistObj.Status__c = each.status;
                } if(String.isNotBlank(each.supportingDocumentVerified) && !(each.supportingDocumentVerified).equalsIgnoreCase('null')){
                    checklistObj.Supporting_Documentation__c = each.supportingDocumentVerified;
                } if(String.isNotBlank(each.waiverReason) && !(each.waiverReason).equalsIgnoreCase('null')){
                    checklistObj.Waiver_Reason__c = each.waiverReason;
                }
                updatedChecklists.add(checklistObj);
            }
        }
        Database.update(updatedChecklists, false);
    }
    public static void updateRuleDataOnPartiesFromChecklistDetails(List<clcommon__Party__c> partyList, List<String> rulesNameList){
        List<Id> partyIds = new List<Id>();
        for(clcommon__Party__c each : partyList){
            partyIds.add(each.Id);
        }
        Map<String, List<Checklist_Detail__c>> partyChecklistDetailsMap = new Map<String, List<Checklist_Detail__c>>();
        List<Checklist_Detail__c> checklistDetailList = [SELECT Id, Party__c, Party__r.Name,
                                                            Application_Collateral__c,
                                                            Employment_Information__c,
                                                            Income__c,
                                                            Checklist__r.genesis__Rule__r.Name,
                                                            Exception_Approver__c,
                                                            Exception_Commentary__c,
                                                            Exception_Recommender__c,
                                                            Condition_Status__c,
                                                            Supporting_Document_Verified__c,
                                                            Waiver_Reason__c
                                                            FROM Checklist_Detail__c
                                                            WHERE Party__c IN:partyIds
                                                            AND Checklist__r.genesis__Rule__r.Name IN:rulesNameList];
        for(Checklist_Detail__c each : checklistDetailList){
            List<Checklist_Detail__c> checklistDetails = partyChecklistDetailsMap.get(each.Party__r.Name);
            if(checklistDetails == null){
                checklistDetails = new List<Checklist_Detail__c>();
            }
            checklistDetails.add(each);
            partyChecklistDetailsMap.put(each.Party__r.Name, checklistDetails);
        }
        updateRuleDataOnSObjectsFromChecklistDetails(partyList, partyChecklistDetailsMap);
    }
    public static void updateRuleDataOnApplicationCollateralsFromChecklistDetails(List<genesis__Application_Collateral__c> appColList, List<String> rulesNameList){
        List<Id> appColIds = new List<Id>();
        for(genesis__Application_Collateral__c each : appColList){
            appColIds.add(each.Id);
        }
        Map<String, List<Checklist_Detail__c>> appColChecklistDetailsMap = new Map<String, List<Checklist_Detail__c>>();
        List<Checklist_Detail__c> checklistDetailList = [SELECT Id, Party__c, Party__r.Name,
                                                            Application_Collateral__c,
                                                            Employment_Information__c,
                                                            Income__c,
                                                            Application_Collateral__r.Name,
                                                            Checklist__r.genesis__Rule__r.Name,
                                                            Exception_Approver__c,
                                                            Exception_Commentary__c,
                                                            Exception_Recommender__c,
                                                            Condition_Status__c,
                                                            Supporting_Document_Verified__c,
                                                            Waiver_Reason__c
                                                            FROM Checklist_Detail__c
                                                            WHERE Application_Collateral__c IN:appColIds
                                                            AND Checklist__r.genesis__Rule__r.Name IN:rulesNameList];
        for(Checklist_Detail__c each : checklistDetailList){
            List<Checklist_Detail__c> checklistDetails = appColChecklistDetailsMap.get(each.Application_Collateral__r.Name);
            if(checklistDetails == null){
                checklistDetails = new List<Checklist_Detail__c>();
            }
            checklistDetails.add(each);
            appColChecklistDetailsMap.put(each.Application_Collateral__r.Name, checklistDetails);
        }
        updateRuleDataOnSObjectsFromChecklistDetails(appColList, appColChecklistDetailsMap);
    }
    private static void updateRuleDataOnSObjectsFromChecklistDetails(List<SObject> sobjectList, Map<String, List<Checklist_Detail__c>> sobjectChecklistDetailsMap){
        List<SObject> updatedSObjects = new List<SObject>();
        for(SObject each : sobjectList){
            List<Checklist_Detail__c> checklistDetails = sobjectChecklistDetailsMap.get((String) each.get('Name'));
            if(checklistDetails == null){
                checklistDetails = new List<Checklist_Detail__c>();
            }
            String manualData = '{"checklistManualDataMapping":[';
            Boolean flag = true;
            for(Checklist_Detail__c each2 : checklistDetails){
                if(flag){
                    flag = false;
                    manualData += '{';
                }else {
                    manualData += ',{';
                }
                manualData += '"ruleName":"';
                manualData += each2.Checklist__r.genesis__Rule__r.Name;
                if(String.isNotBlank(each2.Application_Collateral__c)){
                    manualData += each2.Application_Collateral__c;
                }
                if(String.isNotBlank(each2.Employment_Information__c)){
                    manualData += each2.Employment_Information__c;
                }
                if(String.isNotBlank(each2.Party__c)){
                    manualData += each2.Party__c;
                }
                if(String.isNotBlank(each2.Income__c)){
                    manualData += each2.Income__c;
                }
                manualData += '",';
                manualData += '"exceptionRecommender":"' + each2.Exception_Recommender__c + '",';
                manualData += '"exceptionApprover":"' + each2.Exception_Approver__c + '",';
                manualData += '"exceptionCommentary":"' + each2.Exception_Commentary__c + '",';
                manualData += '"status":"' + each2.Condition_Status__c + '",';
                manualData += '"supportingDocumentVerified":"' + each2.Supporting_Document_Verified__c + '",';
                manualData += '"waiverReason":"' + each2.Waiver_Reason__c + '"';
                manualData += '}';
            }
            manualData += ']}';
            sObjectNameManualDataMap.put((String) each.get('Name'), manualData);
        }
    }

    public static List<Checklist_Detail__c> updateChecklistDetailsFromRuleDataOnParties(List<clcommon__Party__c> partyList, List<String> rulesNameList){
        List<Id> partyIds = new List<Id>();
        for(clcommon__Party__c each : partyList){
            partyIds.add(each.Id);
        }
        List<Checklist_Detail__c> checklistDetailList = [SELECT Id, Name, Party__c, Party__r.Name,
                                                            Application_Collateral__c,
                                                            Employment_Information__c,
                                                            Income__c,
                                                            Checklist__r.genesis__Rule__r.Name,
                                                            Exception_Approver__c,
                                                            Exception_Commentary__c,
                                                            Exception_Recommender__c,
                                                            Condition_Status__c,
                                                            Supporting_Document_Verified__c,
                                                            Waiver_Reason__c
                                                            FROM Checklist_Detail__c
                                                            WHERE Party__c IN:partyIds
                                                            AND Checklist__r.genesis__Rule__r.Name IN:rulesNameList];
        return updateChecklistDetailsFromRuleDataOnRelatedObjects(partyList, checklistDetailList, 'Party');
    }
    public static List<Checklist_Detail__c> updateChecklistDetailsFromRuleDataOnApplicationCollaterals(List<genesis__Application_Collateral__c> appColList, List<String> rulesNameList){
        List<Id> appColIds = new List<Id>();
        for(genesis__Application_Collateral__c each : appColList){
            appColIds.add(each.Id);
        }
        List<Checklist_Detail__c> checklistDetailList = [SELECT Id, Name, Application_Collateral__c,
                                                            Application_Collateral__r.Name,
                                                            Employment_Information__c,
                                                            Income__c,
                                                            Party__c,
                                                            Checklist__r.genesis__Rule__r.Name,
                                                            Exception_Approver__c,
                                                            Exception_Commentary__c,
                                                            Exception_Recommender__c,
                                                            Condition_Status__c,
                                                            Supporting_Document_Verified__c,
                                                            Waiver_Reason__c
                                                            FROM Checklist_Detail__c
                                                            WHERE Application_Collateral__c IN:appColIds
                                                            AND Checklist__r.genesis__Rule__r.Name IN:rulesNameList];
        return updateChecklistDetailsFromRuleDataOnRelatedObjects(appColList, checklistDetailList, 'Application_Collateral');
    }
    private static List<Checklist_Detail__c> updateChecklistDetailsFromRuleDataOnRelatedObjects(List<SObject> objectList, List<Checklist_Detail__c> checklistDetailList, String sObjectType){
        Map<String, Map<String, Id>> objectRuleChecklistDetailsMapMap = new Map<String, Map<String, Id>>();
        for(Checklist_Detail__c each : checklistDetailList){
            Map<String, Id> ruleChecklistDetailsMap;
            if(sObjectType.equals('Party')){
                ruleChecklistDetailsMap = objectRuleChecklistDetailsMapMap.get(each.Party__r.Name);
            } else if (sObjectType.equals('Application_Collateral')){
                ruleChecklistDetailsMap = objectRuleChecklistDetailsMapMap.get(each.Application_Collateral__r.Name);
            } else {
                continue;
            }
            if(ruleChecklistDetailsMap == null){
                ruleChecklistDetailsMap = new Map<String, Id>();
            }
            String ruleName = each.Checklist__r.genesis__Rule__r.Name;
            if(String.isNotBlank(each.Application_Collateral__c)){
                ruleName += each.Application_Collateral__c;
            }
            if(String.isNotBlank(each.Employment_Information__c)){
                ruleName += each.Employment_Information__c;
            }
            if(String.isNotBlank(each.Party__c)){
                ruleName += each.Party__c;
            }
            if(String.isNotBlank(each.Income__c)){
                ruleName += each.Income__c;
            }
            ruleChecklistDetailsMap.put(ruleName, each.Id);
            if(sObjectType.equals('Party')){
                ruleChecklistDetailsMap = objectRuleChecklistDetailsMapMap.put(each.Party__r.Name, ruleChecklistDetailsMap);
            } else if (sObjectType.equals('Application_Collateral')){
                ruleChecklistDetailsMap = objectRuleChecklistDetailsMapMap.put(each.Application_Collateral__r.Name, ruleChecklistDetailsMap);
            } else {
                continue;
            }
        }
        List<Checklist_Detail__c> updatedChecklists = new List<Checklist_Detail__c>();
        for(SObject each : objectList){
            String ruleManualData = sObjectNameManualDataMap.get((String) each.get('Name'));
            if(String.isBlank(ruleManualData)){
                continue;
            }
            CheckRules checkRulesObj = (CheckRules) System.JSON.deserialize(ruleManualData, CheckRules.class);
            ClassChecklistManualDataMapping[] checklistManualDataList = checkRulesObj.checklistManualDataMapping;
            Map<String, Id> ruleChecklistDetailsMap = objectRuleChecklistDetailsMapMap.get((String) each.get('Name'));
            for(ClassChecklistManualDataMapping each2 : checklistManualDataList){
                if(String.isNotBlank(each2.ruleName) && ruleChecklistDetailsMap.containsKey(each2.ruleName)){
                    testing += each2.ruleName + ' : ';
                    // testing += ruleChecklistMap.get(each2.ruleName) + ' : ';
                    testing += (String)each.get('Name') + '\n';
                    Checklist_Detail__c checklistObj = new Checklist_Detail__c(Id = ruleChecklistDetailsMap.get(each2.ruleName));
                    if(String.isNotBlank(each2.exceptionRecommender) && !(each2.exceptionRecommender).equalsIgnoreCase('null')){
                        checklistObj.Exception_Recommender__c = each2.exceptionRecommender;
                    } if(String.isNotBlank(each2.exceptionApprover) && !(each2.exceptionApprover).equalsIgnoreCase('null')){
                        checklistObj.Exception_Approver__c = each2.exceptionApprover;
                    } if(String.isNotBlank(each2.exceptionCommentary) && !(each2.exceptionCommentary).equalsIgnoreCase('null')){
                        checklistObj.Exception_Commentary__c = each2.exceptionCommentary;
                    } if(String.isNotBlank(each2.status) && !(each2.status).equalsIgnoreCase('null')){
                        checklistObj.Condition_Status__c = each2.status;
                    } if(String.isNotBlank(each2.supportingDocumentVerified) && !(each2.supportingDocumentVerified).equalsIgnoreCase('null')){
                        checklistObj.Supporting_Document_Verified__c = each2.supportingDocumentVerified;
                    } if(String.isNotBlank(each2.waiverReason) && !(each2.waiverReason).equalsIgnoreCase('null')){
                        checklistObj.Waiver_Reason__c = each2.waiverReason;
                    }
                    updatedChecklists.add(checklistObj);
                }
            }
        }
        return updatedChecklists;
    }
}