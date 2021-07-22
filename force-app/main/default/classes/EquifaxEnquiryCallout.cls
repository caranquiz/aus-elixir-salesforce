/**********************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : EquifaxEnquiryCallout */
/* Created Date         : 11/08/2020 */
/* Developed By         : Souvik */
/* Description          : This is the callout class for Equifax Apply Individual and Previous Enquiry. */
/* Last Modified Date   : 12/08/2020 */
/* Last Modified By     : Souvik */
/*********************************************************************************************************/

global with sharing class EquifaxEnquiryCallout {
  webService static String equifaxApplyIndividual(
    Id appId,
    Id partyId,
    Id conId,
    Id addressId
  ) {
    Map<String, String> queryIdMap = new Map<String, String>();
    Map<String, Object> requestParamMap = new Map<String, Object>();
    intframework.AbstractIntegrationService baseintegrationService = intframework.IntegrationServiceFactory.getBaseIntegrationService();
    dom.Document doc = new dom.Document();
    Map<String, Object> responseMap;
    Map<String, Object> responseMap1;
    String json;
    String helperObject;
    try {
      List<genesis__Applications__c> appList = [
        SELECT Id
        FROM genesis__Applications__c
        WHERE Id = :appId
      ];
      if (appList.isEmpty()) {
        return ConstantValues.NO_APPLICATION;
      }
      genesis__Applications__c appObj = appList[0];
      List<clcommon__Party__c> partyList = [
        SELECT Id, Party_Type_Name__c,Credit_Report_Enquiry_Callout_Made__c
        FROM clcommon__Party__c
        WHERE Id = :partyId
      ];
      if (partyList.isEmpty()) {
        return ConstantValues.NO_PARTY;
      }
      clcommon__Party__c partyObj = partyList[0];
      List<Contact> contactList = [SELECT Id FROM Contact WHERE Id = :conId];
      if (contactList.isEmpty()) {
        return ConstantValues.NO_CONTACT;
      }
      Contact conObj = contactList[0];
      List<clcommon__Address__c> addressList = [
        SELECT Id
        FROM clcommon__Address__c
        WHERE Id = :addressId
      ];
      if (addressList.isEmpty()) {
        return ConstantValues.NO_ADDRESS;
      }
      clcommon__Address__c addressObj = addressList[0];
      queryIdMap.put('appId', appObj.Id);
      queryIdMap.put('partyId', partyObj.Id);
      queryIdMap.put('conId', conObj.Id);
      queryIdMap.put('addressId', addressObj.Id);
      requestParamMap.put('addressType', 'C');
      partyList = [
        SELECT Id
        FROM clcommon__Party__c
        WHERE
          genesis__Application__c = :appId
          AND Party_Type_Name__c IN (
            :ConstantValues.BORROWER,
            :ConstantValues.CO_APPLICANT
          )
      ];
      if (
        String.isNotBlank(partyObj.Party_Type_Name__c) &&
        (partyObj.Party_Type_Name__c).equalsIgnoreCase(ConstantValues.GUARANTOR)
      ) {
        requestParamMap.put('relationshipCode', '3');
      } else if (partyList.size() > 1) {
        requestParamMap.put('relationshipCode', '2');
      } else {
        requestParamMap.put('relationshipCode', '1');
      }
      intframework.BaseIntegrationResponse responseObject = (intframework.BaseIntegrationResponse) baseintegrationService.runSynchronousIntegrationService(
        ConstantValues.EQUIFAX_FAMILY,
        ConstantValues.APPLY_INDIVIDUAL_API_TYPE,
        queryIdMap,
        requestParamMap
      );
      partyObj.Credit_Report_Enquiry_Callout_Made__c = true;
      update partyObj;
      //Storing Reponse as Attachment
      Request_And_Response_Storage__c responseSettings = Request_And_Response_Storage__c.getOrgDefaults();
      
      if(responseSettings.Store_Individual_Prv_Enq_RequestResponse__c == true){
        //Storing raw response in Attachments
        GenericUtility.createAttachment('EquifaxApplyIndividualResponse_'+String.valueOf(DateTime.now())+'.xml',
          responseObject.getBody(),
          partyId
        );
      }
      if(responseObject != NULL && responseObject.responseMap != NULL){
        responseMap1 = responseObject.responseMap;
      }
      doc.load(responseObject.getBody());
      //responseMap = intframework.XmlToJson.parseDocumentToMap(doc);
      json = System.JSON.serialize(responseMap1);
      System.debug('JSON ===>'+json);
      helperObject = EquifaxIndividualResponseHelper.parse(
        json,
        partyObj,
        responseMap1
      );
      if (helperObject == null) {
        return ConstantValues.GENERAL_ERROR;
      }
      return helperObject;
     /* return EquifaxApplyIndividualResponseHelper.updatePartyWithApplyIndividualResponse(
        partyObj,
        helperObject
      );*/
    } catch (Exception ex) {
      GenericUtility.insertLog('EquifaxEnquiryCallout', ex);
      return ConstantValues.GENERAL_ERROR;
    }
  }
  webService static String equifaxPreviousEnquiry(
    String enquiryId,
    Id partyId
  ) {
    String pdfData;
    clcommon__Party__c partyObj;
    Map<String, Object> requestParamMap = new Map<String, Object>();
    StaticResource sr;
    String requestBody;
    intframework.AbstractIntegrationService baseintegrationService = intframework.IntegrationServiceFactory.getBaseIntegrationService();
    intframework.BaseIntegrationResponse responseObject;
    dom.Document doc = new dom.Document();
    Map<String, Object> responseMap;
    Attachment documentAttachment = new Attachment();
    List<clcommon__Document_Category__c> docCatList;
    clcommon__Document_Category__c docCat;
    clcommon__Category_Attachment_Association__c attachDoc = new clcommon__Category_Attachment_Association__c();
    try {
      partyObj = [
        SELECT
          Id,
          clcommon__Account__c,
          clcommon__Contact__r.FirstName,
          clcommon__Contact__r.lastName,
          genesis__Application__c
        FROM clcommon__Party__c
        WHERE Id = :partyId
      ];
      sr = [
        SELECT Id, Name, Body
        FROM StaticResource
        WHERE Name = :ConstantValues.PREV_ENQ_STATIC_RES
      ];
      if (sr == null) {
        throw new CustomException(ConstantValues.PREV_ENQ_REQ_BODY_SRNAME);
      }
      requestBody = sr.Body.toString();
      requestParamMap.put('requestBody', requestBody);
      if (String.isBlank(enquiryId)) {
        return ConstantValues.NO_ENQ_ID;
      }
      requestParamMap.put('enquiryId', enquiryId);
      requestParamMap.put('contentType', ConstantValues.APP_PDF_CONTENT_TYPE);
      requestParamMap.put('partyId',partyId);
      responseObject = (intframework.BaseIntegrationResponse) baseintegrationService.runSynchronousIntegrationService(
        ConstantValues.EQUIFAX_FAMILY,
        ConstantValues.PREVIOUS_ENQUIRY_API_TYPE,
        new Map<String, String>(),
        requestParamMap
      );
      //Storing Reponse as Attachment
      Request_And_Response_Storage__c responseSettings = Request_And_Response_Storage__c.getOrgDefaults();
      
      if(responseSettings.Store_Individual_Prv_Enq_RequestResponse__c == true){
        //Storing raw response in Attachments
        GenericUtility.createAttachment('EquifaxPreviouslResponse_'+String.valueOf(DateTime.now())+'.xml',
          responseObject.getBody(),
          partyId
        );
      }
      doc.load(responseObject.getBody());
      responseMap = intframework.XmlToJson.parseDocumentToMap(doc);
      // This inner try catch block terminates the code if any exception occurs during fetching the document
      try {
        pdfData = (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) responseMap
                  .get(ConstantValues.ENVELOPE_KEY))
                .get(ConstantValues.BODY_KEY))
              .get(ConstantValues.RESPONSE_KEY))
            .get(ConstantValues.BINARYDATA_KEY))
          .get(ConstantValues.NODEVALUE_KEY);
        documentAttachment.ContentType = ConstantValues.APP_PDF_CONTENT_TYPE;
        documentAttachment.Body = EncodingUtil.base64Decode(pdfData);
        documentAttachment.Name =
          ConstantValues.PREV_ENQ_PDF_NAME_PREF +
          partyObj.clcommon__Contact__r.FirstName +
          ' ' +
          partyObj.clcommon__Contact__r.LastName +
          ' (OBSOLETE).pdf';
        documentAttachment.parentId = partyObj.Id;
        Database.insert(documentAttachment);
        docCatList = [
          SELECT Id, clcommon__Category_Name__c
          FROM clcommon__Document_Category__c
          WHERE
            clcommon__Category_Name__c = :ConstantValues.PREV_ENQ_DOC_CAT
            AND genesis__Application__c = :partyObj.genesis__Application__c
        ];
        if (docCatList.isEmpty()) {
          throw new CustomException(ConstantValues.DOCUMENT_CATEGORY_NOT_FOUND);
        }
        //Attaching the retrieved document with the collateral
        docCat = docCatList[0];
        attachDoc.Name = documentAttachment.Name;
        attachDoc.clcommon__Attachment_Id__c = documentAttachment.Id;
        attachDoc.clcommon__Document_Category__c = docCat.Id;
        Database.insert(attachDoc);
        return ConstantValues.PDF_REPORT_DOWNLOADED;
      } catch (Exception ex) {
        throw new CustomException(ConstantValues.RESPONSE_PARSE_ERR);
      }
    } catch (Exception ex) {
      GenericUtility.insertLog('EquifaxEnquiryCallout', ex);
      return ConstantValues.GENERAL_ERROR;
    }
  }
}