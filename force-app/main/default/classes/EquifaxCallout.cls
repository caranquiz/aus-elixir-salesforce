/**********************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : EquifaxCallout */
/* Created Date         : 28/07/2020 */
/* Developed By         : Souvik */
/* Description          : This is the callout class for Equifax Title Search, Order Document
and Deliver Document APIs. */
/* Last Modified Date   : 28/07/2020 */
/* Last Modified By     : Souvik */
/*********************************************************************************************************/

global with sharing class EquifaxCallout {
    // Checks if Collateral exists associated with the provided Id
    private static clcommon__Collateral__c checkCollateralId(Id collateralId){
        List<clcommon__Collateral__c> collateralList = new List<clcommon__Collateral__c>(
        [
            SELECT Id, Name, Document_Enquiry_Id__c, Full_Address__c
            FROM clcommon__Collateral__c
            WHERE Id = :collateralId
        ]
        );
        if(collateralList.isEmpty()){
            return null;
        }
        return collateralList[0];
    }
    private static String processCallout(String apiType, Map<String, String> queryIdMap, Map<String, Object> requestParamMap) {
        intframework.AbstractIntegrationService baseintegrationService = intframework.IntegrationServiceFactory.getBaseIntegrationService();
        intframework.BaseIntegrationResponse responseObject;
        responseObject = (intframework.BaseIntegrationResponse) baseintegrationService.runSynchronousIntegrationService(
        ConstantValues.EQUIFAX_FAMILY,
        apiType,
        queryIdMap,
        requestParamMap
        );
        dom.Document doc = new dom.Document();
        doc.load(responseObject.getBody());
        Map<String, Object> responseMap = intframework.XmlToJson.parseDocumentToMap(
            doc
        );
        String json = System.JSON.serialize(responseMap);
        return GenericUtility.modifyJsonKeysIntoCamelcasing(json);
    }
    webService static String equifaxTitleSearch(Id collateralId, Boolean confirmPrice) {
        try {
            clcommon__Collateral__c collateralObj = checkCollateralId(collateralId);
            if(collateralObj == null){
                return ConstantValues.NO_COLLATERAL;
            }
            Map<String, String> queryIdMap = new Map<String, String>();
            queryIdMap.put(ConstantValues.COLLATERAL_ID, (String) collateralObj.id);
            Map<String, Object> requestParamMap = new Map<String, Object>();
            requestParamMap.put('clientReference', collateralObj.Name);
            if(confirmPrice != null && confirmPrice == true){
                requestParamMap.put('confirmPrice', true);
            }
            String json = processCallout(ConstantValues.TITLE_SEARCH_API_TYPE, queryIdMap, requestParamMap);
            List<String> queries = new List<String>();
            queries.add(ConstantValues.LANDTITLE_KEY);
            queries.add(ConstantValues.ERROR_KEY);
            JsonObjectToArray obj = new JsonObjectToArray();
            json = obj.modifyAllByRecur(json, queries);
            return json;
        } catch (Exception ex) {
            GenericUtility.insertLog('EquifaxCallout', ex);
        }
        return ConstantValues.GENERAL_ERROR;
    }
    public class OrderDocumentData {
        public String enquiryId;
        public String exceptionData;
        public String priceValue;
    }
    webService static String equifaxOrderDocument(String testTitleReference, String testStateRef, Id collateralId, Boolean confirmPrice) {
        try {
            clcommon__Collateral__c collateralObj = checkCollateralId(collateralId);
            if(collateralObj == null){
                return ConstantValues.NO_COLLATERAL;
            }
            Map<String, Object> requestParamMap = new Map<String, Object>();
            requestParamMap.put('titleReference', testTitleReference);
            requestParamMap.put('testStateRef', testStateRef);
            requestParamMap.put('clientRef', collateralObj.Name);
            if(confirmPrice != null && confirmPrice == true){
                requestParamMap.put('confirmPrice', true);
            }
            String json = processCallout(ConstantValues.ORDER_DOCUMENT_API_TYPE, new Map<String, String>(), requestParamMap);
            OrderDocumentData orderDocdata = EquifaxOrderDocumentResponseHelper.parse(json);
            if(confirmPrice != null && confirmPrice == true){
                if(String.isBlank(orderDocdata.enquiryId)){
                    if(String.isNotBlank(orderDocdata.exceptionData)){
                        return orderDocdata.exceptionData;
                    }
                    return ConstantValues.INVALID_RESPONSE;
                }
                collateralObj.Document_Enquiry_Id__c = orderDocdata.enquiryId;
                Database.update(collateralObj);
                return ConstantValues.ORDER_DOC_SUCCESS;
            } else {
                return System.JSON.serialize(orderDocdata);
            }
        } catch (Exception ex) {
            GenericUtility.insertLog('EquifaxCallout', ex);
        }
        return ConstantValues.GENERAL_ERROR;
    }
    public class LandTitleDocumentData {
        public String documentStatus;
        public Attachment documentAttachment;
        public String paidAmount;
        public String exceptionData;
    }
    webService static String equifaxDeliverDocument(Id collateralId) {
        LandTitleDocumentData documentData = new LandTitleDocumentData();
        try{
            clcommon__Collateral__c collateralObj = checkCollateralId(collateralId);
            if(collateralObj == null){
                return ConstantValues.NO_COLLATERAL;
            }
            if(String.isBlank(collateralObj.Document_Enquiry_Id__c)){
                return ConstantValues.NO_ENQUIRY_ID;
            }
            Map<String, Object> requestParamMap = new Map<String, Object>();
            requestParamMap.put('enquiryId', collateralObj.Document_Enquiry_Id__c);
            requestParamMap.put('clientReference', collateralObj.Name);
            String json = processCallout(ConstantValues.DELIVER_DOCUMENT_API_TYPE, new Map<String, String>(), requestParamMap);
            documentData = EquifaxDeliverDocumentResponseHelper.parse(json);
            if(String.isNotBlank(documentData.documentStatus)){
                collateralObj.Document_Status__c = documentData.documentStatus;
            }
            if(String.isNotBlank(documentData.paidAmount)){
                collateralObj.Price_Paid_for_Document__c = documentData.paidAmount;
            }
            if(documentData.documentAttachment != null){
                documentData.documentAttachment.Name = 'Title[' + collateralObj.Full_Address__c + '].pdf';
                documentData.documentAttachment.parentId = collateralObj.Id;
                Database.insert(documentData.documentAttachment);
                collateralObj.Document_Retrived__c = true;
            }
            Database.update(collateralObj);
            List<clcommon__Document_Category__c> docCatList =
            [
                SELECT Id, clcommon__Category_Name__c
                FROM clcommon__Document_Category__c
                WHERE clcommon__Category_Name__c =:ConstantValues.TITLE_SEARCH_DOCUMENT_CATEGORY_NAME
                AND clcommon__Collateral__c =:collateralObj.Id
            ];
            //Attaching the retrieved document with the collateral
            if(!docCatList.isEmpty()){
                clcommon__Document_Category__c docCat = docCatList[0];
                clcommon__Category_Attachment_Association__c attachDoc = new clcommon__Category_Attachment_Association__c();
                attachDoc.Name = documentData.documentAttachment.Name;
                attachDoc.clcommon__Attachment_Id__c = documentData.documentAttachment.Id;
                attachDoc.clcommon__Document_Category__c = docCat.Id;
                Database.insert(attachDoc);
            }
            return System.JSON.serialize(documentData);
        }
        catch(Exception ex){
            GenericUtility.insertLog('EquifaxCallout', ex);
        }
        return ConstantValues.GENERAL_ERROR;
    }
}