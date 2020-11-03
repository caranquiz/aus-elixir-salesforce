/**********************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : EraseRedundantData */
/* Created Date         : 16/07/2020 */
/* Developed By         : Souvik */
/* Description          : This class is called from the skuid to erase redundant data (when not rendered)
if already stored in the back end. This class has some limitations, they are
1. Evaluation expression serial numbers needs to be between 0 to 9
2. Evaluation expression cannot consist braces */
/* Last Modified Date   : 16/07/2020 */
/* Last Modified By     : Souvik */
/*********************************************************************************************************/

global with sharing class EraseRedundantData {
    private static String prefix = '$';
    private static Map<String, Map<Integer, Boolean>> fieldCriteriaResultMap = new Map<String, Map<Integer, Boolean>>();
    private static List<Map<String, Map<Integer, Boolean>>> fieldCriteriaResultMapList = new List<Map<String, Map<Integer, Boolean>>>();
    static Boolean isRendered;
    /* This method handles if the specified serial number in the evaluation expression does not contains any
    render criteria result */
    private static Boolean returnReultAtIndex(Integer index, Map<Integer, Boolean> indexBooleanMap){
        Boolean result = indexBooleanMap.get(index);
        if(result != null){
            return result;
        }
        return true;
    }
    // This method evaluates the specified expression string and returns a boolean value
    private static Boolean evaluteResultByExpression(String expression, Map<Integer, Boolean> indexBooleanMap){
        Integer firstSerialNumberIndex;
        Integer firstSerialNumber;
        Integer nextSerialNumberIndex;
        Integer nextSerialNumber;
        String operator;
        Integer refIndex = 0;
        Boolean refResult;
        Integer numberCount;
        Integer index;
        try{
            numberCount = expression.countMatches(prefix);
            // If no serial number specified returns false
            if(numberCount == 0){
                return true;
            }
            if(numberCount == 1){
                index = expression.indexOf(prefix) + 1;
                if(index == 0){
                    return true;
                }
                return !returnReultAtIndex(Integer.valueOf(expression.subString(index, index+1)), indexBooleanMap);
            }
            
            for(index = 0; index < numberCount - 1; index += 1){
                if(refIndex == 0){
                    firstSerialNumberIndex = expression.indexOf(prefix, 0);
                    firstSerialNumber = Integer.valueOf(expression.subString(firstSerialNumberIndex + 1, firstSerialNumberIndex + 2));
                    nextSerialNumberIndex = expression.indexOf(prefix, firstSerialNumberIndex + 1);
                    nextSerialNumber = Integer.valueOf(expression.subString(nextSerialNumberIndex + 1, nextSerialNumberIndex + 2));
                    operator = expression.subString(firstSerialNumberIndex + 2, nextSerialNumberIndex).trim();
                    switch on operator {
                        when '&&' {
                            refResult = (returnReultAtIndex(firstSerialNumber, indexBooleanMap) && returnReultAtIndex(nextSerialNumber, indexBooleanMap));
                        }
                        when '||' {
                            refResult = (returnReultAtIndex(firstSerialNumber, indexBooleanMap) || returnReultAtIndex(nextSerialNumber, indexBooleanMap));
                        }
                    }
                    refIndex = nextSerialNumberIndex + 2;
                }
                else{
                    nextSerialNumberIndex = expression.indexOf(prefix, refIndex);
                    nextSerialNumber = Integer.valueOf(expression.subString(nextSerialNumberIndex + 1, nextSerialNumberIndex + 2));
                    operator = expression.subString(refIndex, nextSerialNumberIndex).trim();
                    switch on operator {
                        when '&&' {
                            refResult = (refResult && returnReultAtIndex(nextSerialNumber, indexBooleanMap));
                        }
                        when '||' {
                            refResult = (refResult || returnReultAtIndex(nextSerialNumber, indexBooleanMap));
                        }
                    }
                    refIndex = nextSerialNumberIndex + 2;
                }
            }
            return !refResult;
        }
        catch(Exception ex){
            GenericUtility.insertLog('EraseRedundantData', ex);
            return true;
        }
    }
    private static List<SObject> getDataOfTheSObject(String objectName, List<String> ids, Set<String> fieldNames){
        String queryString = 'SELECT Id';
        for(String eachField : fieldNames){
            queryString += ',' + eachField;
        }
        queryString += ' FROM ' + objectName + ' WHERE Id IN:ids';
        List<SObject> records = Database.query(queryString);
        return records;
    }
    // This method checks if the given string is a decimal value or not
    public static Boolean isDecimal(String val){
        if(String.isBlank(val)){
            return false;
        }
        try{
            Decimal.valueOf(val);
            return true;
        }catch(Exception ex){
            return false;
        }
    }
    private static Boolean checkIfDataMatchedForMultivaluedActualData(String actualData, String expectedData, String matchingType){
        List<String> singleValueList = actualData.split(';');
        if(matchingType.equalsIgnoreCase('==') || matchingType.equalsIgnoreCase('IN')){
            for(String eachValue : singleValueList){
                if(eachValue.trim().equalsIgnoreCase(expectedData.trim())){
                    return true;
                }
            }
            return false;
        }
        if(matchingType.equalsIgnoreCase('!=') || matchingType.equalsIgnoreCase('NOT IN')){
            for(String eachValue : singleValueList){
                if(eachValue.trim().equalsIgnoreCase(expectedData.trim())){
                    return false;
                }
            }
            return true;
        }
        return true;
    }
    // Returns mathing result, in case of exception always returns true
    public static Boolean checkIfDataMatched(String actualData, String expectedData, String matchingType){
        List<String> valueList;
        try{
            if(matchingType == null){
                return true;
            }
            if(expectedData == null || expectedData.equalsIgnoreCase('null')){
                expectedData = null;
            }
            if(actualData != null && actualData.contains(';')){
                return checkIfDataMatchedForMultivaluedActualData(actualData, expectedData, matchingType);
            }
            switch on matchingType {
                when '==' {
                    if(actualData == null){
                        return (actualData == expectedData);
                    }else if(isDecimal(actualData) && isDecimal(expectedData)){
                        return (Decimal.valueOf(actualData) == Decimal.valueOf(expectedData));
                    }else {
                        return (actualData.equalsIgnoreCase(expectedData));
                    }
                }
                when '!=' {
                    if(actualData == null){
                        return (actualData != expectedData);
                    }else if(isDecimal(actualData) && isDecimal(expectedData)){
                        return (Decimal.valueOf(actualData) != Decimal.valueOf(expectedData));
                    }else {
                        return (!actualData.equalsIgnoreCase(expectedData));
                    }
                }
                when '<=' {
                    if(actualData == null){
                        return true;
                    }else if(isDecimal(actualData) && isDecimal(expectedData)){
                        return (Decimal.valueOf(actualData) <= Decimal.valueOf(expectedData));
                    }else {
                        return true;
                    }
                }
                when '>=' {
                    if(actualData == null){
                        return true;
                    }else if(isDecimal(actualData) && isDecimal(expectedData)){
                        return (Decimal.valueOf(actualData) >= Decimal.valueOf(expectedData));
                    }else {
                        return true;
                    }
                }
                when '<' {
                    if(actualData == null){
                        return true;
                    }else if(isDecimal(actualData) && isDecimal(expectedData)){
                        return (Decimal.valueOf(actualData) < Decimal.valueOf(expectedData));
                    }else {
                        return true;
                    }
                }
                when '>' {
                    if(actualData == null){
                        return true;
                    }else if(isDecimal(actualData) && isDecimal(expectedData)){
                        return (Decimal.valueOf(actualData) > Decimal.valueOf(expectedData));
                    }else {
                        return true;
                    }
                }
                when 'IN' {
                    if(actualData == null && expectedData == null){
                        return true;
                    }
                    valueList = expectedData.split('\n');
                    for(String eachValue : valueList){
                        if((eachValue == null || eachValue.trim().equalsIgnoreCase('null')) && actualData == null){
                            return true;
                        }else if(actualData != null && actualData.equalsIgnoreCase(eachValue.trim())){
                            return true;
                        }
                    }
                    return false;
                }
                when 'NOT IN' {
                    if(actualData == null && expectedData == null){
                        return false;
                    }
                    valueList = expectedData.split('\n');
                    for(String eachValue : valueList){
                        if((eachValue == null || eachValue.trim().equalsIgnoreCase('null')) && actualData == null){
                            return false;
                        }
                        else if(actualData.equalsIgnoreCase(eachValue.trim())){
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
        catch(Exception ex){
            GenericUtility.insertLog('EraseRedundantData', ex);
            return true;
        }
    }
    private static Boolean checkRenderingCriteria(SObject objectData, Rendering_Criteria__c renderCriteria){
        String relatedField = renderCriteria.Related_Field__c;
        return checkIfDataMatched(String.valueOf(objectData.get(relatedField)),
          renderCriteria.Associated_Value__c,
          renderCriteria.Matching_Type_c__c
        );
    }
    webService static void eraseHiddenFieldsDataOf(String objectName, Id paramId){
        Map<String, Schema.SObjectField> fieldMapForChild;
        List<Id> renderedFieldIds = new List<Id>();
        Set<String> fieldNames = new Set<String>();
        SObject objectData;
        Boolean shouldClear;
        try{
            fieldMapForChild = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            List<Rendered_Field__c> renderedFields = [
                SELECT Id,
                Name,
                Rendered_Object__c,
                Evaluation_Expression__c,
                Related_Object_Name__c
                FROM Rendered_Field__c
                WHERE Rendered_Object__c = :objectName
                AND Related_Object_Name__c = null
            ];
            for(Rendered_Field__c eachField : renderedFields){
                renderedFieldIds.add(eachField.Id);
                if(fieldMapForChild.get(eachField.Name) != null){
                    fieldNames.add(eachField.Name);
                }
            }
            List<Rendering_Criteria__c> renderCriteriaList = [
                SELECT Id,
                Associated_Value__c,
                Matching_Type_c__c,
                Related_Field__c,
                Rendered_Field__c,
                Rendered_Field__r.Name,
                Serial_Number__c
                FROM Rendering_Criteria__c
                WHERE Rendered_Field__c IN :renderedFieldIds
            ];
            for(Rendering_Criteria__c eachCriteria : renderCriteriaList){
                fieldNames.add(eachCriteria.Related_Field__c);
            }
            List<Id> ids = new List<Id>();
            ids.add(paramId);
            List<SObject> objects = getDataOfTheSObject(objectName, ids, fieldNames);
            if(objects.isEmpty()){
                return;
            }
            objectData = objects[0];
            for(Rendering_Criteria__c eachRenderCriteria : renderCriteriaList){
                Map<Integer, Boolean> serialCriteriaResultMap;
                if(eachRenderCriteria.Serial_Number__c == null){
                    continue;
                }
                if(fieldCriteriaResultMap.get(eachRenderCriteria.Rendered_Field__r.Name) != null){
                    serialCriteriaResultMap = fieldCriteriaResultMap.get(eachRenderCriteria.Rendered_Field__r.Name);
                    serialCriteriaResultMap.put(Integer.valueOf(eachRenderCriteria.Serial_Number__c), checkRenderingCriteria(objectData, eachRenderCriteria));
                }
                else{
                    serialCriteriaResultMap = new Map<Integer, Boolean>();
                    serialCriteriaResultMap.put(Integer.valueOf(eachRenderCriteria.Serial_Number__c), checkRenderingCriteria(objectData, eachRenderCriteria));
                }
                fieldCriteriaResultMap.put(eachRenderCriteria.Rendered_Field__r.Name, serialCriteriaResultMap);
            }
            for(Rendered_Field__c eachRenderedField : renderedFields){
                shouldClear = evaluteResultByExpression(eachRenderedField.Evaluation_Expression__c, fieldCriteriaResultMap.get(eachRenderedField.Name));
                if(shouldClear){
                    if(fieldMapForChild.get(eachRenderedField.Name) != null){
                        objectData.put(eachRenderedField.Name, null);
                    }
                }
            }
            Database.update(objectData, false);
        }
        catch(Exception ex){
            GenericUtility.insertLog('EraseRedundantData', ex);
        }
    }
    webService static void eraseHiddenObjectData(
        String objectName,
        String sectionName,
        String renderedObjectName,
        Id paramId,
        String listOfIds,
        Boolean shouldClear,
        String listOffieldNamesIfFieldData
    ){
        if(shouldClear != null){
            isRendered = shouldClear;
        }
        String ref = '';
        if(listOffieldNamesIfFieldData != null){
            ref = listOffieldNamesIfFieldData;
        }
        eraseRelatedObjectFieldData(
            objectName,
            sectionName,
            renderedObjectName,
            paramId,
            listOfIds,
            false,
            ref,
            null
        );
    }
    webService static void eraseRelatedObjectFieldData(
        String objectName,
        String sectionName,
        String renderedObjectName,
        Id paramId,
        String listOfIds,
        Boolean isFieldData,
        String listOffieldNamesIfFieldData,
        Boolean shouldClearField
    ){
        List<String> ids;
        List<String> fieldNameIfFieldDataList;
        List<SObject> relatedObjectRecords;
        Map<Integer, Boolean> serialCriteriaResultMap;
        List<Id> renderedFieldIds = new List<Id>();
        Set<String> fieldNames = new Set<String>();
        SObject objectData;
        Rendered_Field__c renderedField;
        try{
            ids = listOfIds.split(';');
            fieldNameIfFieldDataList = listOffieldNamesIfFieldData.split(';');
            if(!isFieldData){
                relatedObjectRecords = Database.query('SELECT Id FROM ' + renderedObjectName + ' WHERE Id IN: Ids');
                // If field rendering is mentioned explicitly then deleting the records
                if(isRendered != null && isRendered){
                    Database.delete(relatedObjectRecords, false);
                    return;
                }
            }else{
                String query = 'SELECT Id';
                for(String eachFieldName : fieldNameIfFieldDataList){
                    query += ',' + eachFieldName;
                }
                query += ' FROM ' + renderedObjectName + ' WHERE Id IN: Ids';
                relatedObjectRecords = Database.query(query);
                if(shouldClearField != null && shouldClearField){
                    for(String eachFieldName : fieldNameIfFieldDataList){
                        relatedObjectRecords[0].put(eachFieldName, null);
                    }
                    Database.update(relatedObjectRecords, false);
                    return;
                }
            }
            List<Rendered_Field__c> renderedFieldList = [
                SELECT Id,
                Name,
                Rendered_Object__c,
                Evaluation_Expression__c,
                Related_Object_Name__c
                FROM Rendered_Field__c
                WHERE Name = :sectionName
                AND Rendered_Object__c = :objectName
                AND Related_Object_Name__c = :renderedObjectName
            ];
            if(renderedFieldList.isEmpty()){
                return;
            }
            renderedField = renderedFieldList[0];
            List<Rendering_Criteria__c> renderCriteriaList = [
                SELECT Id,
                Associated_Value__c,
                Matching_Type_c__c,
                Related_Field__c,
                Rendered_Field__c,
                Rendered_Field__r.Name,
                Rendered_Field__r.Rendered_Object__c,
                Rendered_Field__r.Related_Object_Name__c,
                Serial_Number__c
                FROM Rendering_Criteria__c
                WHERE Rendered_Field__c = :renderedField.Id
            ];
            if(renderCriteriaList.isEmpty()){
                return;
            }
            for(Rendering_Criteria__c eachRenderCriteria : renderCriteriaList){
                fieldNames.add(eachRenderCriteria.Related_Field__c);
            }
            List<Id> refIdList = new List<Id>();
            refIdList.add(paramId);
            List<SObject> objects = getDataOfTheSObject(objectName, refIdList, fieldNames);
            if(objects.isEmpty()){
                return;
            }
            objectData = objects[0];
            if(objectData == null){
                return;
            }
            for(Rendering_Criteria__c eachRenderCriteria : renderCriteriaList){
                if(eachRenderCriteria.Serial_Number__c == null){
                    continue;
                }
                if(fieldCriteriaResultMap.get(eachRenderCriteria.Rendered_Field__r.Name) != null){
                    serialCriteriaResultMap = fieldCriteriaResultMap.get(eachRenderCriteria.Rendered_Field__r.Name);
                    serialCriteriaResultMap.put(Integer.valueOf(eachRenderCriteria.Serial_Number__c), checkRenderingCriteria(objectData, eachRenderCriteria));
                }
                else{
                    serialCriteriaResultMap = new Map<Integer, Boolean>();
                    serialCriteriaResultMap.put(Integer.valueOf(eachRenderCriteria.Serial_Number__c), checkRenderingCriteria(objectData, eachRenderCriteria));
                }
                fieldCriteriaResultMap.put(eachRenderCriteria.Rendered_Field__r.Name, serialCriteriaResultMap);
            }
            Boolean shouldClear = evaluteResultByExpression(renderedField.Evaluation_Expression__c, fieldCriteriaResultMap.get(renderedField.Name));
            if(shouldClear && !isFieldData){
                Database.delete(relatedObjectRecords, false);
            }else if(shouldClear && isFieldData){
                for(String eachFieldName : fieldNameIfFieldDataList){
                    relatedObjectRecords[0].put(eachFieldName, null);
                }
                Database.update(relatedObjectRecords, false);
            }
        }
        catch(Exception ex){
            GenericUtility.insertLog('EraseRedundantData', ex);
        }
    }
    webService static void eraseHiddenFieldsDataOfMultipleRecords(String objectName, String listOfIds){
        List<String> ids;
        Map<String, Schema.SObjectField> fieldMapForChild;
        List<Id> renderedFieldIds = new List<Id>();
        Set<String> fieldNames = new Set<String>();
        List<Boolean> shouldClearList;
        List<SObject> objectDataList;
        Map<Integer, Boolean> serialCriteriaResultMap;
        Integer index = 0;
        Boolean shouldClear;
        try{
            ids = listOfIds.split(';');
            fieldMapForChild = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            List<Rendered_Field__c> renderedFields = [
                SELECT Id,
                Name,
                Rendered_Object__c,
                Evaluation_Expression__c,
                Related_Object_Name__c
                FROM Rendered_Field__c
                WHERE Rendered_Object__c = :objectName
                AND Related_Object_Name__c = null
            ];
            for(Rendered_Field__c eachRenderedField : renderedFields){
                renderedFieldIds.add(eachRenderedField.Id);
                if(fieldMapForChild.get(eachRenderedField.Name) != null){
                    fieldNames.add(eachRenderedField.Name);
                }
            }
            List<Rendering_Criteria__c> renderCriteriaList = [
                SELECT Id,
                Associated_Value__c,
                Matching_Type_c__c,
                Related_Field__c,
                Rendered_Field__c,
                Rendered_Field__r.Name,
                Serial_Number__c
                FROM Rendering_Criteria__c
                WHERE Rendered_Field__c IN :renderedFieldIds
            ];
            for(Rendering_Criteria__c eachRenderingCriteria : renderCriteriaList){
                fieldNames.add(eachRenderingCriteria.Related_Field__c);
            }
            objectDataList = getDataOfTheSObject(objectName, ids, fieldNames);
            for(SObject objectData : objectDataList){
                for(Rendering_Criteria__c eachRenderingCriteria : renderCriteriaList){
                    if(eachRenderingCriteria.Serial_Number__c == null){
                        continue;
                    }
                    if(fieldCriteriaResultMap.get(eachRenderingCriteria.Rendered_Field__r.Name) != null){
                        serialCriteriaResultMap = fieldCriteriaResultMap.get(eachRenderingCriteria.Rendered_Field__r.Name);
                        serialCriteriaResultMap.put(Integer.valueOf(eachRenderingCriteria.Serial_Number__c), checkRenderingCriteria(objectData, eachRenderingCriteria));
                    }
                    else{
                        serialCriteriaResultMap = new Map<Integer, Boolean>();
                        serialCriteriaResultMap.put(Integer.valueOf(eachRenderingCriteria.Serial_Number__c), checkRenderingCriteria(objectData, eachRenderingCriteria));
                    }
                    fieldCriteriaResultMap.put(eachRenderingCriteria.Rendered_Field__r.Name, serialCriteriaResultMap);
                }
                fieldCriteriaResultMapList.add(fieldCriteriaResultMap);
            }
            
            for(Map<String,Map<Integer,Boolean>> fieldCriteriaResultMap : fieldCriteriaResultMapList){
                for(Rendered_Field__c eachRenderedField : renderedFields){
                    shouldClear = evaluteResultByExpression(eachRenderedField.Evaluation_Expression__c, fieldCriteriaResultMap.get(eachRenderedField.Name));
                    if(shouldClear){
                        if(fieldMapForChild.get(eachRenderedField.Name) != null){
                            objectDataList[index].put(eachRenderedField.Name, null);
                        }
                    }
                }
                index += 1;
            }
            Database.update(objectDataList, false);
        }
        catch(Exception ex){
            GenericUtility.insertLog('EraseRedundantData', ex);
        }
    }
}