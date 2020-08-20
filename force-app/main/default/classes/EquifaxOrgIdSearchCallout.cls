/********************************************************************************************/
/* Description : This class calls for sending request using Integration Framework, passes the 
                 required data and calls the parser class for parsing the response.
/********************************************************************************************/
global with sharing class EquifaxOrgIdSearchCallout {
    private static EquifaxOrgIdSearchParser parserObject = new EquifaxOrgIdSearchParser();
    webService static String searchByABN(String partyId, String abn) {
        if(String.isBlank(partyId) || String.isBlank(abn)){
            parserObject.errMessage = ConstantValues.PARTY_ID_EMPTY;
            return JSON.serialize(parserObject);
        }
        Map<String, Object> queryIdMap = new Map<String, Object>();
        Map<String, Object> requestParamMap = new Map<String, Object>();
        dom.Document doc = new dom.Document();
        EquifaxOrgIdSearchParser result = new EquifaxOrgIdSearchParser();
        try {
            StaticResource staticResource = [SELECT Id,Name,Body FROM StaticResource WHERE Name =: ConstantValues.EQUIFAX_XML_BODY];
            //putting dynamic parameters in map for intframework
            queryIdMap.put(ConstantValues.PARTY_ID, partyId);
            requestParamMap.put(ConstantValues.EQUIFAX_ABN_NUMBER,abn);
            requestParamMap.put(ConstantValues.EQUIFAX_XML_REQUEST_BODY,staticResource.Body.toString());
            intframework.AbstractIntegrationService baseintegrationService = intframework.IntegrationServiceFactory.getBaseIntegrationService();
            intframework.BaseIntegrationResponse responseObject;
            // Calling the adapter class, by specifying integraiton family and api type in the base integration service
            responseObject = (intframework.BaseIntegrationResponse) baseintegrationService.runSynchronousIntegrationService(
            ConstantValues.EQUIFAX_FAMILY_NAME,
            ConstantValues.EQUIFAX_API_TYPE,
            queryIdMap,
            requestParamMap
            );
            // null check before fetching the body data
            if (responseObject == null || responseObject.getBody() == null) {
                parserObject.errMessage = ConstantValues.GENERAL_EXCEPTION;
                return JSON.serialize(parserObject);
            }
            doc.load(responseObject.getBody());
            // Changing the response format from String to Map
            Map<String, Object> responseMap = intframework.XmlToJson.parseDocumentToMap(doc);
            // Searializing JSON Map to send for parsing
            String json = System.JSON.serialize(responseMap);
            //Checking for exceptions in response
            Boolean res = checkForException(json);
            if(!res){
                return null;
            }
            //parsing the response
            result = parse(json);
            if(result.errMessage == ConstantValues.INVALID_REQUEST){
                throw new CustomException(ConstantValues.INVALID_REQUEST);
            }
            
            return System.JSON.serialize(result);
        } 
        catch (Exception ex) {
            GenericUtility.insertLog('EquifaxOrgIdSearchCallout', ex);
            return null;
        }
    }
    public static EquifaxOrgIdSearchParser parse(String json){
        if(String.isNotBlank(json)){
            // Changing the response format from Map to EquifaxOrgIdSearchParser class object
            EquifaxOrgIdSearchParser parserObject = EquifaxOrgIdSearchParser.parse(json);
            if(parserObject == null){
                return parserObject;
            }
            /* The following try-catch block handles if any exception happens while fetching
            response null check */
            try {
                if (parserObject.bcaMessage.bcaServices.bcaService.bcaServiceData.response == null) {
                    parserObject.errMessage = ConstantValues.INVALID_REQUEST;
                    return parserObject;
                }
                if (parserObject.bcaMessage.bcaServices.bcaService.bcaServiceData.response.orgIdResult == null) {
                    return null;
                }
            } 
            catch (Exception ex) {
                GenericUtility.insertLog('EquifaxOrgIdSearchCallout', ex);
                return null;
            }
            String asicStat = parserObject.bcaMessage.bcaServices.bcaService.bcaServiceData.response.orgIdResult[0].asicReport.asicStatus.nodeValue;
            asicStat = GenericUtility.convertToDescription(asicStat);
            parserObject.bcaMessage.bcaServices.bcaService.bcaServiceData.response.orgIdResult[0].asicReport.asicStatus.nodeValue = asicStat;
            return parserObject;
        }
        return null;
    }
    public static Boolean checkForException(String json){
        try{
            if(String.isNotBlank(json)){
                if(json.contains(ConstantValues.BCA_ERROR)){
                    String errorDescription = json.substringBetween(ConstantValues.BCA_ERROR_DESCRIPTION_TAG,ConstantValues.BCA_ERROR_DESCRIPTION_CLOSE_TAG);
                    throw new CustomException(errorDescription);
                }
                return true;
            }
            return false;
        }
        catch(Exception ex){
            GenericUtility.insertLog('EquifaxOrgIdSearchCallout', ex);
            return false;
        }
    }
}