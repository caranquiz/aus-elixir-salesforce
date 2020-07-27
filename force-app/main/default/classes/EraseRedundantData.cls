/**********************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : EraseRedundantData */
/* Created Date         : 16/07/2020 */
/* Developed By         : Souvik */
/* Description          : This class is called from the skuid to erase redundant data (when not rendered)
if already stored in the back end. This class has some limitations, they are
1. Evaluation expression serial numbers needs to be between 0-9
2. Evaluation expression cannot consist braces */
/* Last Modified Date   : 16/07/2020 */
/* Last Modified By     : Souvik */
/*********************************************************************************************************/

global with sharing class EraseRedundantData {
    private static Map<String, Rendering_Criteria__c> fieldCriteriaMap = new Map<String, Rendering_Criteria__c>();
    private static Map<String, Map<Integer, Boolean>> fieldCriteriaResultMap = new Map<String, Map<Integer, Boolean>>();
    private static List<Map<String, Map<Integer, Boolean>>> fieldCriteriaResultMapList = new List<Map<String, Map<Integer, Boolean>>>();

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
        try{
            Integer numberCount = expression.countMatches('$');
            // If no serial number specified returns false
            if(numberCount == 0){
                return true;
            }
            if(numberCount == 1){
                Integer index = expression.indexOf('$') + 1;
                return !returnReultAtIndex(Integer.valueOf(expression.subString(index, index+1)), indexBooleanMap);
            }
            Integer refIndex = 0;
            Boolean refResult;
            for(Integer index = 0; index < numberCount - 1; index += 1){
                if(refIndex == 0){
                    Integer firstSerialNumberIndex = expression.indexOf('$', 0);
                    Integer firstSerialNumber = Integer.valueOf(expression.subString(firstSerialNumberIndex + 1, firstSerialNumberIndex + 2));
                    Integer nextSerialNumberIndex = expression.indexOf('$', firstSerialNumberIndex + 1);
                    Integer nextSerialNumber = Integer.valueOf(expression.subString(nextSerialNumberIndex + 1, nextSerialNumberIndex + 2));
                    String operator = expression.subString(firstSerialNumberIndex + 2, nextSerialNumberIndex).trim();
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
                    Integer nextSerialNumberIndex = expression.indexOf('$', refIndex);
                    Integer nextSerialNumber = Integer.valueOf(expression.subString(nextSerialNumberIndex + 1, nextSerialNumberIndex + 2));
                    String operator = expression.subString(refIndex, nextSerialNumberIndex).trim();
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
    private static SObject getDataOfTheSObject(String objectName, Id paramId, Set<String> fieldNames){
        String queryString = 'SELECT Id';
        for(String each : fieldNames){
            queryString += ',' + each;
        }
        queryString += ' FROM ' + objectName + ' WHERE Id=\'' + paramId + '\'';
        List<SObject> objectData = Database.query(queryString);
        if(!objectData.isEmpty()){
            return objectData[0];
        }
        return null;
    }
    private static List<SObject> getDataOfTheSObject(String objectName, List<String> ids, Set<String> fieldNames){
        String queryString = 'SELECT Id';
        for(String each : fieldNames){
            queryString += ',' + each;
        }
        queryString += ' FROM ' + objectName + ' WHERE Id=:ids';
        List<SObject> records = Database.query(queryString);
        return records;
    }
    // This method checks if the given string is a decimal value or not
    private static Boolean isDecimal(String val){
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
            for(String each : singleValueList){
                if(each.trim().equalsIgnoreCase(expectedData.trim())){
                    return true;
                }
            }
            return false;
        }
        if(matchingType.equalsIgnoreCase('!=') || matchingType.equalsIgnoreCase('NOT IN')){
            for(String each : singleValueList){
                if(each.trim().equalsIgnoreCase(expectedData.trim())){
                    return false;
                }
            }
            return true;
        }
        return true;
    }
    public static Boolean checkIfDataMatched(String actualData, String expectedData, String matchingType){
        if(expectedData == null || expectedData.equalsIgnoreCase('null')){
            expectedData = null;
        }
        if(actualData != null && actualData.contains(';')){
            Boolean multiValResult = checkIfDataMatchedForMultivaluedActualData(actualData, expectedData, matchingType);
            return multiValResult;
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
                    return false;
                }
                List<String> valueList = expectedData.split('\n');
                for(String each : valueList){
                    if((each == null || each.trim().equalsIgnoreCase('null')) && actualData == null){
                        return true;
                    }else if(actualData != null && actualData.equalsIgnoreCase(each.trim())){
                        return true;
                    }
                }
                return false;
            }
            when 'NOT IN' {
                List<String> valueList = expectedData.split('\n');
                for(String each : valueList){
                    if((each == null || each.trim().equalsIgnoreCase('null')) && actualData == null){
                        return false;
                    }
                    else if(actualData.equalsIgnoreCase(each.trim())){
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
    private static Boolean checkRenderingCriteria(SObject objectData, Rendering_Criteria__c renderCriteria){
        String relatedField = renderCriteria.Related_Field__c;
        return checkIfDataMatched(String.valueOf(objectData.get(relatedField)),
          renderCriteria.Associated_Value__c,
          renderCriteria.Matching_Type_c__c
        );
    }
    webService static void eraseHiddenFieldsDataOf(String objectName, Id paramId){
        try{
            Map<String, Schema.SObjectField> fieldMapForChild = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            List<Id> renderedFieldIds = new List<Id>();
            Set<String> fieldNames = new Set<String>();
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
            for(Rendered_Field__c each : renderedFields){
                renderedFieldIds.add(each.Id);
                if(fieldMapForChild.get(each.Name) != null){
                    fieldNames.add(each.Name);
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
            for(Rendering_Criteria__c each : renderCriteriaList){
                fieldNames.add(each.Related_Field__c);
            }
            SObject objectData = getDataOfTheSObject(objectName, paramId, fieldNames);
            for(Rendering_Criteria__c each : renderCriteriaList){
                Map<Integer, Boolean> serialCriteriaResultMap;
                if(fieldCriteriaResultMap.get(each.Rendered_Field__r.Name) != null){
                    serialCriteriaResultMap = fieldCriteriaResultMap.get(each.Rendered_Field__r.Name);
                    serialCriteriaResultMap.put(Integer.valueOf(each.Serial_Number__c), checkRenderingCriteria(objectData, each));
                }
                else{
                    serialCriteriaResultMap = new Map<Integer, Boolean>();
                    serialCriteriaResultMap.put(Integer.valueOf(each.Serial_Number__c), checkRenderingCriteria(objectData, each));
                }
                fieldCriteriaResultMap.put(each.Rendered_Field__r.Name, serialCriteriaResultMap);
            }
            Boolean shouldClear;
            for(Rendered_Field__c each : renderedFields){
                shouldClear = evaluteResultByExpression(each.Evaluation_Expression__c, fieldCriteriaResultMap.get(each.Name));
                if(shouldClear){
                    if(fieldMapForChild.get(each.Name) != null){
                        objectData.put(each.Name, null);
                    }
                }
            }
            Database.update(objectData, false);
        }
        catch(Exception ex){
            GenericUtility.insertLog('EraseRedundantData', ex);
        }
    }
    webService static void eraseHiddenFieldsDataOfMultipleRecords(String objectName, String listOfIds){
        try{
            List<String> ids = listOfIds.split(';');
            Map<String, Schema.SObjectField> fieldMapForChild = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            List<Id> renderedFieldIds = new List<Id>();
            Set<String> fieldNames = new Set<String>();
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
            for(Rendered_Field__c each : renderedFields){
                renderedFieldIds.add(each.Id);
                if(fieldMapForChild.get(each.Name) != null){
                    fieldNames.add(each.Name);
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
            for(Rendering_Criteria__c each : renderCriteriaList){
                fieldNames.add(each.Related_Field__c);
            }
            List<SObject> objectDataList = getDataOfTheSObject(objectName, ids, fieldNames);
            for(SObject objectData : objectDataList){
                for(Rendering_Criteria__c each : renderCriteriaList){
                    Map<Integer, Boolean> serialCriteriaResultMap;
                    if(fieldCriteriaResultMap.get(each.Rendered_Field__r.Name) != null){
                        serialCriteriaResultMap = fieldCriteriaResultMap.get(each.Rendered_Field__r.Name);
                        serialCriteriaResultMap.put(Integer.valueOf(each.Serial_Number__c), checkRenderingCriteria(objectData, each));
                    }
                    else{
                        serialCriteriaResultMap = new Map<Integer, Boolean>();
                        serialCriteriaResultMap.put(Integer.valueOf(each.Serial_Number__c), checkRenderingCriteria(objectData, each));
                    }
                    fieldCriteriaResultMap.put(each.Rendered_Field__r.Name, serialCriteriaResultMap);
                }
                fieldCriteriaResultMapList.add(fieldCriteriaResultMap);
            }
            List<Boolean> shouldClearList;
            Integer index = 0;
            for(Map<String,Map<Integer,Boolean>> fieldCriteriaResultMap : fieldCriteriaResultMapList){
                Boolean shouldClear;
                for(Rendered_Field__c each : renderedFields){
                    shouldClear = evaluteResultByExpression(each.Evaluation_Expression__c, fieldCriteriaResultMap.get(each.Name));
                    if(shouldClear){
                        if(fieldMapForChild.get(each.Name) != null){
                            objectDataList[index].put(each.Name, null);
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
    static Boolean isRendered;
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
        try{
            List<String> ids = listOfIds.split(';');
            List<String> fieldNameIfFieldDataList = listOffieldNamesIfFieldData.split(';');
            List<SObject> relatedObjectRecords;
            if(!isFieldData){
                relatedObjectRecords = Database.query('SELECT Id FROM ' + renderedObjectName + ' WHERE Id IN: Ids');
                // If field rendering is mentioned explicitly then deleting the records
                if(isRendered != null && isRendered){
                    Database.delete(relatedObjectRecords, false);
                    return;
                }
            }else{
                String query = 'SELECT Id';
                for(String each : fieldNameIfFieldDataList){
                    query += ',' + each;
                }
                query += ' FROM ' + renderedObjectName + ' WHERE Id IN: Ids';
                relatedObjectRecords = Database.query(query);
                if(shouldClearField != null && shouldClearField){
                    for(String each : fieldNameIfFieldDataList){
                        relatedObjectRecords[0].put(each, null);
                    }
                    Database.update(relatedObjectRecords, false);
                    return;
                }
            }
            List<Id> renderedFieldIds = new List<Id>();
            Set<String> fieldNames = new Set<String>();
            Rendered_Field__c renderedField = [
                SELECT Id,
                Name,
                Rendered_Object__c,
                Evaluation_Expression__c,
                Related_Object_Name__c
                FROM Rendered_Field__c
                WHERE Name = :sectionName
                AND Rendered_Object__c = :objectName
                AND Related_Object_Name__c = :renderedObjectName
                LIMIT 1
            ];
            if(renderedField == null){
                return;
            }
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
            for(Rendering_Criteria__c each : renderCriteriaList){
                fieldNames.add(each.Related_Field__c);
            }
            SObject objectData = getDataOfTheSObject(objectName, paramId, fieldNames);
            if(objectData == null){
                return;
            }
            for(Rendering_Criteria__c each : renderCriteriaList){
                Map<Integer, Boolean> serialCriteriaResultMap;
                if(fieldCriteriaResultMap.get(each.Rendered_Field__r.Name) != null){
                    serialCriteriaResultMap = fieldCriteriaResultMap.get(each.Rendered_Field__r.Name);
                    serialCriteriaResultMap.put(Integer.valueOf(each.Serial_Number__c), checkRenderingCriteria(objectData, each));
                }
                else{
                    serialCriteriaResultMap = new Map<Integer, Boolean>();
                    serialCriteriaResultMap.put(Integer.valueOf(each.Serial_Number__c), checkRenderingCriteria(objectData, each));
                }
                fieldCriteriaResultMap.put(each.Rendered_Field__r.Name, serialCriteriaResultMap);
            }
            Boolean shouldClear = evaluteResultByExpression(renderedField.Evaluation_Expression__c, fieldCriteriaResultMap.get(renderedField.Name));
            if(shouldClear && !isFieldData){
                Database.delete(relatedObjectRecords, false);
            }else if(shouldClear && isFieldData){
                for(String each : fieldNameIfFieldDataList){
                    relatedObjectRecords[0].put(each, null);
                }
                Database.update(relatedObjectRecords, false);
            }
        }
        catch(Exception ex){
            GenericUtility.insertLog('EraseRedundantData', ex);
        }
    }
}