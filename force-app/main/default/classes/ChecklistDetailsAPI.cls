/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Khalid Fazlullah
Development Date : 07/08/2020
Last Modified By : Rameswari Barman
Last Modified Date : 21/08/2020
Description : This class query all the Rules and check the Rule Criteria for the Parties/Securities/Income/employment Information.
***********************************************************************************************************************************************************/
public with sharing class ChecklistDetailsAPI {
    public ChecklistDetailsAPI() {}

//Started Bulkification

    public Boolean runRuleCriteriaOnChild(SObject child, genesis__RuleCriteria__c criteria){
        Map<String, Object> objectMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(child));
        ChecklistDetailsAPI api = new ChecklistDetailsAPI();
        String value;
        Double doubleValue;
        Boolean hasRulePassed;
        if(criteria.genesis__Field_Type__c == ConstantValues.DOUBLE_CHECK
        || criteria.genesis__Field_Type__c == ConstantValues.PERCENT_CHECK
        || criteria.genesis__Field_Type__c == ConstantValues.CURRENCY_CHECK){
            doubleValue = api.getDoubleValue(objectMap,criteria.genesis__Field_API_Name__c);
            hasRulePassed = this.evaluateBasedOnDoubleMatchingType(doubleValue,criteria.genesis__Matching_Type__c,criteria.genesis__Matching_Value__c);
        }
        else {
            value = api.getValue(objectMap,criteria.genesis__Field_API_Name__c);
            hasRulePassed = this.evaluateBasedOnMatchingType(value,criteria.genesis__Matching_Type__c,criteria.genesis__Matching_Value__c);
        }
        return hasRulePassed;
    }
    public Boolean evaluateBasedOnDoubleMatchingType(Double matchingOperand1, String matchingOperator, String matchingOperand2){
        Double matchingOperandFinal2 = double.valueOf(matchingOperand2);
        switch on matchingOperator {
            when '==' {     
                if(matchingOperand1 == NULL){
                    return false;
                }
                return (matchingOperand1 == matchingOperandFinal2);
                
            }   
            when '<=' {     
                if(matchingOperand1 == NULL){
                    return false;
                }
                return ((matchingOperand1 < matchingOperandFinal2) || (matchingOperand1 == matchingOperandFinal2)); 
            }
            when '>=' {  
                if(matchingOperand1 == NULL){
                    return false;
                }   
                return ((matchingOperand1 > matchingOperandFinal2) || (matchingOperand1 == matchingOperandFinal2));
                
            }
            when '!=' {   
                if(matchingOperand1 == NULL){
                    return false;
                }  
                return (matchingOperand1 != matchingOperandFinal2);
                
            }
            when '<' {   
                if(matchingOperand1 == NULL){
                    return false;
                }  
                return (matchingOperand1 < matchingOperandFinal2);
            }
            when '>' {   
                if(matchingOperand1 == NULL){
                    return false;
                }  
                return (matchingOperand1 > matchingOperandFinal2);
            }
            when else {     
                return true;
            }
        }
    }
    public Boolean evaluateBasedOnMatchingType(String matchingOperand1, String matchingOperator, String matchingOperand2){
        switch on matchingOperator {
            when '==' {
                if(matchingOperand2.equalsIgnoreCase('NULL') && String.isBlank(matchingOperand1)){
                    return true;
                } 
                if(matchingOperand1 == NULL || matchingOperand1 == ''){
                    return false;
                }
                return (matchingOperand1 == matchingOperand2);
            }
            when '!=' {
                if(matchingOperand2.equalsIgnoreCase('NULL') && String.isNotBlank(matchingOperand1)){
                    return true;
                }
                if(matchingOperand1 == NULL || matchingOperand1 == ''){
                    return false;
                }
                return (matchingOperand1 != matchingOperand2);
            }
            when 'IN' {
                if(matchingOperand2.equalsIgnoreCase('NULL') && String.isBlank(matchingOperand1)){
                    return true;
                } 
                if(matchingOperand1 == NULL || matchingOperand1 == ''){
                    return false;
                }
                List<String> values = matchingOperand2.split(',');
                for(String each : values){
                    if(matchingOperand1.equals(each)){
                        return true;
                    }
                }
                return false;
            }
            when 'NOT IN' {
                if(matchingOperand2.equalsIgnoreCase('NULL') && String.isBlank(matchingOperand1)){
                    return false;
                } 
                if(matchingOperand1 == NULL || matchingOperand1 == ''){
                    return false;
                }
                List<String> values = matchingOperand2.split(',');
                for(String each : values){
                    if(matchingOperand1.equals(each)){
                        return false;
                    }
                }
                return true;
            }
            when else {      
                return true;
            }
        }
    }

    public String getValue(Map<String, Object> child, String key){
        String value;
        Map<String, Object> objectMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(child));
        if(key.indexOf('.')<0){
            if(objectMap.get(key) == null){
                return '';
            }
            else {
                return objectMap.get(key).toString();
            }
        }else{ 
            String objectName = key.substring(0,key.IndexOf('.'));
            String childKey = key.substring(key.IndexOf('.')+1);
            if(objectMap.get(objectName) == null){
                return '';
            }
            Map<String, Object> objectMap2 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(objectMap.get(objectName)));
            return this.getValue(objectMap2,childKey);
        }
    }

    public Double getDoubleValue(Map<String, Object> child, String key){
        String value;
        Map<String, Object> objectMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(child));
        if(key.indexOf('.')<0){
            if(objectMap.get(key) == null){
                return NULL;
            }
            else {
                return Double.valueOf(objectMap.get(key));
            }
        }else{ 
            String objectName = key.substring(0,key.IndexOf('.'));
            String childKey = key.substring(key.IndexOf('.')+1);
            if(objectMap.get(objectName) == null){
                return NULL;
            }
            Map<String, Object> objectMap2 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(objectMap.get(objectName)));
            return this.getDoubleValue(objectMap2,childKey);
        }
    }

    public Boolean runRuleOnChild(SObject child, genesis__Rule__c rule, List<genesis__RuleCriteria__c> criteriaList){
        String expression = rule.genesis__Evaluation_Expression__c;
        String sequenceNumber;
        String criteriaResult;
        /*if(expression == NULL || expression != ''){
            return false;
        }*/
        for(genesis__RuleCriteria__c criteria: criteriaList){
            sequenceNumber = String.valueOf(Integer.valueOf(criteria.genesis__Criteria_Sequence__c));
            criteriaResult = String.valueOf(this.runRuleCriteriaOnChild(child, criteria));
            expression = expression.replaceAll(sequenceNumber, criteriaResult);
        }
        Boolean hasRulePassed = BooleanExpression.eval(expression.toUpperCase());
        return hasRulePassed;
    }
}