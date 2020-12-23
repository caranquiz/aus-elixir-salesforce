/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Hamza Yousuf
Development Date : 20/07/2020
Last Modified By : Hamza Yousuf
Last Modified Date : 13/11/2020
Description : This is the callout class for Equifax Company Enquiry.
***********************************************************************************************************************************************************/

global class EquifaxCompanyEnquiryCallout {
  webService static String companyEnquiryRequest(
    ID partyid,
    ID applicationid,
    Boolean enrichment
  ) {
    try {
      String json;
      Map<String, Object> responseMap;
      List<clcommon__Party__c> partyInfoList = [
        SELECT
          ID,
          clcommon__Account__r.clcommon__Legal_Entity_Type__c,
          clcommon__Type__c
        FROM clcommon__Party__c
        WHERE ID = :partyid
      ];

      List<genesis__Applications__c> applicationList = [
        SELECT Name, genesis__Loan_Amount__c
        FROM genesis__Applications__c
        WHERE ID = :applicationid
      ];

      Map<String, String> queryIDMap = new Map<String, String>();
      queryIDMap.put(ConstantValues.PARTY_ID, partyid);
      if (partyInfoList.isEmpty()) {
        return ConstantValues.NO_PARTY_INFO_FOUND;
      }
      queryIDMap.put(
        ConstantValues.PARTY_TYPE_ID,
        partyInfoList[0].clcommon__Type__c
      );
      if (partyInfoList[0].clcommon__Account__c != null) {
        queryIDMap.put(
          ConstantValues.ENTITY_ID,
          partyInfoList[0].clcommon__Account__r.clcommon__Legal_Entity_Type__c
        );
      }

      queryIDMap.put(ConstantValues.APPLICATION_ID, applicationid);
      List<clcommon__Party__c> partyList = [
        SELECT Id, genesis__Application__c, Party_Type_Name__c
        FROM clcommon__Party__c
        WHERE
          genesis__Application__c = :applicationid
          AND Party_Type_Name__c IN (
            :ConstantValues.BORROWER,
            :ConstantValues.CO_APPLICANT
          )
      ];

      Map<String, Object> requestParamMap = new Map<String, Object>();
      requestParamMap.put(ConstantValues.ENRICHMENT_REQUIRED, enrichment);
      if (partyList.size() > 1) {
        requestParamMap.put(ConstantValues.IS_JOINT, true);
      } else {
        requestParamMap.put(ConstantValues.IS_JOINT, false);
      }

      intframework.AbstractIntegrationService baseintegrationService = intframework.IntegrationServiceFactory.getBaseIntegrationService();
      intframework.BaseIntegrationResponse responseObject = (intframework.BaseIntegrationResponse) baseintegrationService.runSynchronousIntegrationService(
        ConstantValues.EQUIFAX_FAMILY,
        ConstantValues.COMPANY_ENQUIRY_API_TYPE,
        queryIDMap,
        requestParamMap
      );
      //Storing Reponse as Attachment
      Request_And_Response_Storage__c responseSettings = Request_And_Response_Storage__c.getOrgDefaults();
      
      if(responseSettings.Store_Company_Enquiry_Request_Response__c == true){
        //Storing raw response in Attachments
        GenericUtility.createAttachment('EquifaxCompanyEnquiryResponse_'+String.valueOf(DateTime.now())+'.xml',
          responseObject.getBody(),
          partyid
        );
      }
      dom.Document doc = new dom.Document();
      doc.load(responseObject.getBody());
      try {
        responseMap = intframework.XmlToJson.parseDocumentToMap(doc);
      } catch (Exception ex) {
        GenericUtility.insertLog(
          ConstantValues.EQUIFAX_COMPANY_ENQUIRY_CALLOUT,
          ex
        );
        return ConstantValues.SOMETHING_WENT_WRONG;
      }
      return EquifaxCompanyEnquiryResponseHelper.parse(
        json,
        partyInfoList[0],
        responseMap
      );
    } catch (Exception ex) {
      return ex.getMessage() + ex.getLineNumber();
    }
  }
}