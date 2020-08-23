/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Khalid Fazlullah
Development Date : 07/08/2020
Last Modified By : Rameswari Barman
Last Modified Date : 21/08/2020
Description : This class query all the Rules and check the Rule Criteria for the Parties/Securities/Income/employment Information.
***********************************************************************************************************************************************************/
public with sharing class ChildChecklistAPI {
    public ChildChecklistAPI() {

    }
    public List<Checklist_Detail__c> processListOfChecklist(List<genesis__Checklist__c> listOfCheckList, Id appId){
        Set<String> types;
        String type;
        Integer counter = 0;
        List<Checklist_Detail__c> checklistDetailList = new List<Checklist_Detail__c>();
        Map <Id,String> checklistMap = new Map<Id,String>();
        Set<Id> ruleIds = new Set<Id>();
        List<genesis__RuleCriteria__c> criteriaList = new List<genesis__RuleCriteria__c>();
        List<genesis__RuleCriteria__c> intermediateList = new List<genesis__RuleCriteria__c>();
        List <genesis__Rule__c> ruleList = new List<genesis__Rule__c>();
        Map <Id,genesis__Rule__c> ruleMap = new Map <Id,genesis__Rule__c>();
        Map <Id,List<genesis__RuleCriteria__c>> criteriaRuleMap = new Map <Id,List<genesis__RuleCriteria__c>>();
        if(!(listOfCheckList != NULL && listOfCheckList.size() > 0)){
            throw new CustomException(ConstantValues.EMPTY_CHECKLIST);
        }
        for (genesis__Checklist__c eachChecklist : listOfCheckList) {
            if(eachChecklist.genesis__Rule__c != NULL){
                ruleIds.add(eachChecklist.genesis__Rule__c);
            }
        }
        if(!(ruleIds != NULL && ruleIds.size() > 0)){
            throw new CustomException(ConstantValues.NO_RULE_FOUND);
        }
        ruleList = [Select Id,
                            genesis__Message_failure__c,
                            Name,
                            genesis__Evaluation_Expression__c
                            from genesis__Rule__c where Id =: ruleIds];
        
        criteriaList = [select Id, 
                                Name, genesis__Criteria_Sequence__c,
                                genesis__Related_Object__c,
                                genesis__Field_API_Name__c,
                                genesis__Matching_Type__c,
                                genesis__Matching_Value__c,
                                genesis__Field_Type__c,
                                genesis__Rule__c
                                from genesis__RuleCriteria__c
                                where genesis__Rule__c=:ruleIds order by genesis__Criteria_Sequence__c];
                                
        if(!(criteriaList != NULL && criteriaList.size() > 0)){
            throw new CustomException(ConstantValues.RULE_CRITERIA_NOT_FOUND);
        }
        for(genesis__Checklist__c eachChecklist : listOfCheckList){
            for(genesis__RuleCriteria__c criteria : criteriaList){
                if(counter == 0){
                    checklistMap.put(eachChecklist.Id,(criteria.genesis__Related_Object__c).toLowerCase());
                    counter ++;
                }
                else if(checklistMap.containsKey(eachChecklist.Id) == false){
                    if(eachChecklist.genesis__Rule__c ==  criteria.genesis__Rule__c){
                        checklistMap.put(eachChecklist.Id,(criteria.genesis__Related_Object__c).toLowerCase());
                    }
                } 
            }
            for(genesis__Rule__c eachRule : ruleList){
                if(eachRule.Id == eachChecklist.genesis__Rule__c){
                    ruleMap.put(eachChecklist.Id,eachRule);
                }
            }
        }
        for(genesis__Rule__c eachRule : ruleList){
            for(genesis__RuleCriteria__c criteria : criteriaList){
                if(criteria.genesis__Rule__c == eachRule.Id){
                    intermediateList.add(criteria);
                }
            }
            criteriaRuleMap.put(eachRule.Id,intermediateList);
            intermediateList = new List<genesis__RuleCriteria__c>();
        }
        List<clcommon__Party__c> partyList = [select id,
                                                clcommon__Contact__c,
                                                clcommon__Contact__r.Temporary_Visa_Suitability__c,
                                                clcommon__Contact__r.Temporary_Visa_Suitability_Rule_Check__c,
                                                ABN_Status_Explanation_Suitable__c,
                                                ABN_Status_Explanation_Suitable_Rule__c,
                                                Exit_Strategy_Suitable__c,
                                                GST_Suitable__c,
                                                Explanation_of_Age_of_Credit_File_Suitab__c,
                                                Age_of_Credit_File__c,
                                                Explanation_of_Bankruptcy_Suitable__c,
                                                Previously_Bankrupt_Discharged__c,
                                                Explanation_of_Credit_Enquiries_Suitable__c,
                                                Number_of_Credit_Enquiries_in_Last_12_Mo__c,
                                                Explanation_of_Credit_Events_Suitable__c,
                                                Explanation_of_Credit_Events_Rule_Check__c,
                                                Explanation_Of_Credit_Enquiry_Rule_Check__c,
                                                Explanation_of_Bankruptcy_Rule_Check__c,
                                                Explanation_of_Age_of_Credit_File_Rule_C__c,
                                                Number_Of_Credit_Events__c,
                                                Living_Expense_Explanation_Suitable__c,
                                                Bank_Statments_Reviewed__c,
                                                Bank_Statement_Reviewed_Rule_Check__c,
                                                Explanation_of_Living_Expense_Rule_Check__c,
                                                Is_Borrower_Staff__c,
                                                GST_Suitable_Rule_Check__c,
                                                clcommon__Account__c,
                                                clcommon__Account__r.Commission_Status__c,
                                                ACL_ACR_Verified__c,
                                                Party_Type_Name__c,
                                                Legal_Entity_Type__c,
                                                bankrupt_discharged__c,
                                                Explanation_of_Previous_Conduct_Suitable__c,
                                                Previous_Conduct_Commentary_Rule_Check__c 
                                                from clcommon__Party__c where genesis__Application__c =:appId];
    List<genesis__Income__c> incomeList = [select id,
                                                Party__c,
                                                Employment_Information__c,
                                                Employment_Information__r.Party__c,
                                                Accountant_Call_Suitable__c,
                                                Accountant_Call_Suitable_Render__c,
                                                Confirm_letter_prepared_by_accountant__c,
                                                Confirm_stated_annual_income__c,
                                                Is_the_accountant_aware_of_any_circumsta__c,
                                                Income_Consistent_with_Declaration__c,
                                                Satisfactory_Explanation_Provided__c,
                                                Self_Employment_Rule_Check__c,
                                                Income_Consistant_Rule_Check__c,
                                                Satisfactory_Explanation_Provided_Render__c
                                                from genesis__Income__c
                                                where genesis__Application__c =:appId];
        List<genesis__Application_Collateral__c> collateralList = [select id,
                                                                    genesis__Collateral__r.Check_Val_Value_Rule_Check__c,
                                                                    genesis__Collateral__r.Check_Val_Value_Render__c,
                                                                    genesis__Collateral__r.Distressed_Asset_Rule_Check__c,
                                                                    genesis__Collateral__r.Distressed_Asset_Render__c
                                                                    from genesis__Application_Collateral__c where genesis__Application__c =:appId];
        List<genesis__Employment_Information__c> empInfoList = [select id,
                                                                    Party__c,
                                                                    Party__r.Id,
                                                                    ABN_Effective_from_Rule_Check__c,
                                                                    Employment_Call_Suitable__c,
                                                                    Party__r.Risk_Grade__c,
                                                                    Employment_Call_Suitable_Rule_Check__c
                                                                    from genesis__Employment_Information__c
                                                                    where genesis__Application__c =:appId];
        for (genesis__Checklist__c checklist : listOfCheckList) {
            type = checklistMap.get(checklist.Id);
            switch on type {
                when 'clcommon__party__c' {
                    if(partyList != NULL && partyList.size() > 0){
                        checklistDetailList.addAll(this.processParties(checklist.genesis__Application__c,checklist,partyList,ruleMap.get(checklist.Id),criteriaRuleMap.get(ruleMap.get(checklist.Id).Id)));
                    }
                    else{
                        throw new CustomException(ConstantValues.RECORDS_NOT_FOUND);
                    }
                }   
                when 'genesis__income__c' {
                    if(incomeList != NULL && incomeList.size() > 0){
                        checklistDetailList.addAll(this.processIncome(checklist.genesis__Application__c,checklist,incomeList,ruleMap.get(checklist.Id),criteriaRuleMap.get(ruleMap.get(checklist.Id).Id)));
                    }
                    else{
                        throw new CustomException(ConstantValues.RECORDS_NOT_FOUND);
                    }
                }
                when 'genesis__application_collateral__c' { 
                    if(collateralList != NULL && collateralList.size() > 0){
                        checklistDetailList.addAll(this.processCollateral(checklist.genesis__Application__c,checklist,collateralList,ruleMap.get(checklist.Id),criteriaRuleMap.get(ruleMap.get(checklist.Id).Id)));
                    }
                    else{
                        throw new CustomException(ConstantValues.RECORDS_NOT_FOUND);
                    }
                }
                when 'genesis__employment_information__c' { 
                    checklistDetailList.addAll(this.processEmploymentInformation(checklist.genesis__Application__c,
                    checklist,empInfoList,ruleMap.get(checklist.Id),
                    criteriaRuleMap.get(ruleMap.get(checklist.Id).Id)));
                }
                when else {      
                    throw new CustomException(ConstantValues.TYPE_NOT_SUPPORTED);
                }
            }
        }
        return checklistDetailList;
    }

    public List<Checklist_Detail__c> processListOfSObjects(List<SObject> sObjectList, genesis__Checklist__c checklist, genesis__Rule__c rule,List<genesis__RuleCriteria__c> criteriaList){
        ChecklistDetailsAPI api = new ChecklistDetailsAPI();
        List<Checklist_Detail__c> listOfChecklist = new List<Checklist_Detail__c>();
        Checklist_Detail__c detail ;
            for(SObject sObj: sObjectList){
                detail = new Checklist_Detail__c();
                detail.Checklist__c = checklist.id;
                detail.Record_Id__c = sObj.id;
                detail.Status__c = api.runRuleOnChild(sObj,rule,criteriaList)?ConstantValues.SUCCESS:ConstantValues.FAIL;
                if(sObj.getSObjectType() == Schema.genesis__Application_Collateral__c.sObjectType){
                    detail.Application_Collateral__c = sObj.Id;
                }
                else if(sObj.getSObjectType() == Schema.clcommon__Party__c.sObjectType){
                    detail.Party__c = sObj.Id;
                }
                else if(sObj.getSObjectType() == Schema.genesis__Employment_Information__c.sObjectType){
                    detail.Employment_Information__c = sObj.Id;
                    if(sObj.get(ConstantValues.PARTY_API) != NULL){
                        Id iden = Id.valueOf(sObj.get(ConstantValues.PARTY_API)+'');
                        detail.Party__c = iden;
                    }
                }
                else if(sObj.getSObjectType() == Schema.genesis__Income__c.sObjectType){
                    detail.Income__c = sObj.Id;
                    Id iden;
                    if(sObj.getSobject(ConstantValues.EMPLOYMENT_INFORMATION_API) != NULL){
                        if((sObj.getSObject(ConstantValues.EMPLOYMENT_INFORMATION_API).get(ConstantValues.PARTY_API)) != NULL){
                            iden = Id.valueOf(sObj.getSObject(ConstantValues.EMPLOYMENT_INFORMATION_API).get(ConstantValues.PARTY_API)+'');
                        }
                        detail.Party__c = iden;
                    }
                    if(sObj.get(ConstantValues.PARTY_API) != NULL){
                        iden = Id.valueOf(sObj.get(ConstantValues.PARTY_API)+'');
                        detail.Party__c = iden;
                    }
                }
                listOfChecklist.add(detail);
            }
            return listOfChecklist;
    }
    public List<Checklist_Detail__c> processParties(String appId, genesis__Checklist__c checklist, List<clcommon__Party__c> partyList, genesis__Rule__c rule, List<genesis__RuleCriteria__c> criteriaList){
        return this.processListOfSObjects(partyList, checklist, rule, criteriaList);
    }

    public List<Checklist_Detail__c> processIncome(String appId, genesis__Checklist__c checklist,List<genesis__Income__c> incomeList, genesis__Rule__c rule, List<genesis__RuleCriteria__c> criteriaList){
        return this.processListOfSObjects(incomeList, checklist, rule, criteriaList);
    }

    public List<Checklist_Detail__c> processCollateral(String appId, genesis__Checklist__c checklist, List<genesis__Application_Collateral__c> collateralList, genesis__Rule__c rule, List<genesis__RuleCriteria__c> criteriaList){
        return this.processListOfSObjects(collateralList, checklist, rule, criteriaList);
    }

    public List<Checklist_Detail__c> processEmploymentInformation(String appId, genesis__Checklist__c checklist,List<genesis__Employment_Information__c> empInfoList, genesis__Rule__c rule, List<genesis__RuleCriteria__c> criteriaList){
        return this.processListOfSObjects(empInfoList, checklist, rule, criteriaList);
    }
}