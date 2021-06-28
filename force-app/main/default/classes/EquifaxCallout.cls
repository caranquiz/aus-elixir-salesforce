/**********************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : EquifaxCallout */
/* Created Date         : 28/07/2020 */
/* Developed By         : Souvik */
/* Description          : This is the callout class for Equifax Title Search, Order Document
 and Deliver Document APIs. */
/* Last Modified Date   : 28/06/2021 */
/* Last Modified By     : Rameswari Barman */
/*********************************************************************************************************/

global without sharing class EquifaxCallout {
  // Checks if Collateral exists associated with the provided Id
  private static clcommon__Collateral__c checkCollateralId(Id collateralId) {
    List<clcommon__Collateral__c> collateralList = new List<clcommon__Collateral__c>(
      [
        SELECT Id, Name, Document_Enquiry_Id__c, Full_Address__c
        FROM clcommon__Collateral__c
        WHERE Id = :collateralId
      ]
    );
    if (collateralList.isEmpty()) {
      return null;
    }
    return collateralList[0];
  }
  private static String processCallout(
    String apiType,
    Map<String, String> queryIdMap,
    Map<String, Object> requestParamMap,
    Id collateralId,
    String documentName
  ) {
    intframework.AbstractIntegrationService baseintegrationService = intframework.IntegrationServiceFactory.getBaseIntegrationService();
    intframework.BaseIntegrationResponse responseObject;
    Map<String, Object> responseMap;
    dom.Document doc = new dom.Document();
    String json;
    responseObject = (intframework.BaseIntegrationResponse) baseintegrationService.runSynchronousIntegrationService(
      ConstantValues.EQUIFAX_FAMILY,
      apiType,
      queryIdMap,
      requestParamMap
    );
    
    //Storing Reponse as Attachment
    Request_And_Response_Storage__c responseSettings = Request_And_Response_Storage__c.getOrgDefaults();
      
    if(responseSettings.Store_Land_Title_Store_Request_Response__c == true){
      //Storing raw response in Attachments
      GenericUtility.createAttachment(documentName+String.valueOf(DateTime.now())+'.xml',
        responseObject.getBody(),
        collateralId
      );
    }
    doc.load(responseObject.getBody());
    responseMap = intframework.XmlToJson.parseDocumentToMap(doc);
    json = System.JSON.serialize(responseMap);
    return GenericUtility.modifyJsonKeysIntoCamelcasing(json);
  }
  webService static String equifaxTitleSearch(
    Id collateralId,
    Boolean confirmPrice
  ) {
    clcommon__Collateral__c collateralObj;
    Map<String, String> queryIdMap = new Map<String, String>();
    Map<String, Object> requestParamMap = new Map<String, Object>();
    String json;
    List<String> queries = new List<String>();
    JsonObjectToArray obj = new JsonObjectToArray();
    try {
      collateralObj = checkCollateralId(collateralId);
      if (collateralObj == null || collateralObj.id == null) {
        return ConstantValues.NO_COLLATERAL;
      }
      queryIdMap.put(ConstantValues.COLLATERAL_ID, (String) collateralObj.id);
      List <genesis__Applications__c> applicationList = [select id,
                                                          Name 
                                                          from genesis__Applications__c
                                                          where Id in (Select genesis__Application__c 
                                                          from  genesis__Application_Collateral__c 
                                                          where genesis__Collateral__c =: collateralObj.id) limit 1];
      if(applicationList.isEmpty() == null){
        return ConstantValues.NO_APPLICATION;
      }
      requestParamMap.put('clientReference', applicationList[0].Name);
      if (confirmPrice != null && confirmPrice == true) {
        requestParamMap.put('confirmPrice', true);
      }
      json = processCallout(
        ConstantValues.TITLE_SEARCH_API_TYPE,
        queryIdMap,
        requestParamMap,
        collateralId,
        ConstantValues.TITLE_SEARCH_DOC
      );
      queries.add(ConstantValues.LANDTITLE_KEY);
      queries.add(ConstantValues.ERROR_KEY);
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
  webService static String equifaxOrderDocument(
    String testTitleReference,
    String testStateRef,
    Id collateralId,
    Boolean confirmPrice
  ) {
    clcommon__Collateral__c collateralObj;
    Map<String, Object> requestParamMap = new Map<String, Object>();
    String json;
    OrderDocumentData orderDocdata;
    try {
      collateralObj = checkCollateralId(collateralId);
      if (collateralObj == null) {
        return ConstantValues.NO_COLLATERAL;
      }
      requestParamMap.put('titleReference', testTitleReference);
      requestParamMap.put('testStateRef', testStateRef);
      requestParamMap.put('securityId',collateralId);
      List <genesis__Applications__c> applicationList = [select id,
                                                          Name 
                                                          from genesis__Applications__c
                                                          where Id in (Select genesis__Application__c 
                                                          from  genesis__Application_Collateral__c 
                                                          where genesis__Collateral__c =: collateralObj.id) limit 1];
      if(applicationList.isEmpty() == null){
        return ConstantValues.NO_APPLICATION;
      }
      requestParamMap.put('clientRef', applicationList[0].Name);
      if (confirmPrice != null && confirmPrice == true) {
        requestParamMap.put('confirmPrice', true);
      }
      json = processCallout(
        ConstantValues.ORDER_DOCUMENT_API_TYPE,
        new Map<String, String>(),
        requestParamMap,
        collateralId,
        ConstantValues.ORDER_DOC
      );
      orderDocdata = EquifaxOrderDocumentResponseHelper.parse(json);
      if (confirmPrice != null && confirmPrice == true) {
        if (String.isBlank(orderDocdata.enquiryId)) {
          if (String.isNotBlank(orderDocdata.exceptionData)) {
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
  webService static String equifaxDeliverDocument(
    Id collateralId,
    String enquiryId
  ) {
    LandTitleDocumentData documentData = new LandTitleDocumentData();
    clcommon__Collateral__c collateralObj;
    Map<String, Object> requestParamMap = new Map<String, Object>();
    String json;
    clcommon__Document_Category__c docCat;
    clcommon__Category_Attachment_Association__c attachDoc = new clcommon__Category_Attachment_Association__c();
    try {
      collateralObj = checkCollateralId(collateralId);
      if (collateralObj == null) {
        return ConstantValues.NO_COLLATERAL;
      }
      if (String.isNotBlank(collateralObj.Document_Enquiry_Id__c)) {
        requestParamMap.put('enquiryId', collateralObj.Document_Enquiry_Id__c);
      }
      if (String.isNotBlank(enquiryId)) {
        requestParamMap.put('enquiryId', enquiryId);
      }
      requestParamMap.put('securityId', collateralId);
      List <genesis__Applications__c> applicationList = [select id,
                                                          Name 
                                                          from genesis__Applications__c
                                                          where Id in (Select genesis__Application__c 
                                                          from  genesis__Application_Collateral__c 
                                                          where genesis__Collateral__c =: collateralObj.id) limit 1];
      if(applicationList.isEmpty() == null){
        return ConstantValues.NO_APPLICATION;
      }
      requestParamMap.put('clientReference', applicationList[0].Name);
      json = processCallout(
        ConstantValues.DELIVER_DOCUMENT_API_TYPE,
        new Map<String, String>(),
        requestParamMap,
        collateralId,
        ConstantValues.DELIVER_DOC
      );
      documentData = EquifaxDeliverDocumentResponseHelper.parse(json);
      if (String.isNotBlank(documentData.documentStatus)) {
        collateralObj.Document_Status__c = documentData.documentStatus;
      }
      if (String.isNotBlank(documentData.paidAmount)) {
        collateralObj.Price_Paid_for_Document__c = documentData.paidAmount;
      }
      if (documentData.documentAttachment != null) {
        documentData.documentAttachment.Name =
          'Title[' +
          collateralObj.Full_Address__c +
          '].pdf';
        documentData.documentAttachment.parentId = collateralObj.Id;
        Database.insert(documentData.documentAttachment);
        collateralObj.Document_Retrived__c = true;
        //update title search document - added by RB on 28-06-2021
        collateralObj.Title_Search_Status__c = ConstantValues.TITLE_RECEIVED;
      }
      Database.update(collateralObj);
      List<clcommon__Document_Category__c> docCatList = [
        SELECT Id, clcommon__Category_Name__c
        FROM clcommon__Document_Category__c
        WHERE
          clcommon__Category_Name__c = :ConstantValues.TITLE_SEARCH_DOCUMENT_CATEGORY_NAME
          AND clcommon__Collateral__c = :collateralObj.Id
      ];
      //Attaching the retrieved document with the collateral
      if (!docCatList.isEmpty() && documentData.documentAttachment != null) {
        docCat = docCatList[0];
        attachDoc.Name = documentData.documentAttachment.Name;
        attachDoc.clcommon__Attachment_Id__c = documentData.documentAttachment.Id;
        attachDoc.clcommon__Document_Category__c = docCat.Id;
        attachDoc.clcommon__Reason__c = enquiryId;
        Database.insert(attachDoc);
      }
    } catch (Exception ex) {
      GenericUtility.insertLog('EquifaxCallout', ex);
      documentData.exceptionData = ConstantValues.GENERAL_ERROR;
    }
    return System.JSON.serialize(documentData);
  }
}