/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Pratik Agarwal
Description          : This is the callout for SMSFSearchByABNNumberAdapter class. 
                          This class fetches the trust response using ABN Number and calls SMSFSearchByABNNumberHelper
                          class to parse the response
Development Date : 2/09/2020
Last Modified Date : 14/10/2020
****************************************************************************************************/

global with sharing class SMSFSearchByABNNumberCallout {
    private static SMSFSearchByABNNumberHelper parserObject = new SMSFSearchByABNNumberHelper();
    webservice static String searchByABNNumber(String abn, String partyId) {
      if(String.isBlank(abn) || String.isBlank(partyId)){
        parserObject.errMessage = ConstantValues.ABN_NUMBER_EMPTY;
        return JSON.serialize(parserObject);
      }
      List<clcommon__Party__c> partyList = new List<clcommon__Party__c>([SELECT Id, Flag_Party__c FROM clcommon__Party__c WHERE Id =: partyId]);
      Map<String, Object> requestParamMap = new Map<String, Object>();
      requestParamMap.put(ConstantValues.ABN_NUMBER, abn);
      dom.Document doc = new dom.Document();
      SMSFSearchByABNNumberHelper result = new SMSFSearchByABNNumberHelper();
  
      try {
        intframework.AbstractIntegrationService baseintegrationService = intframework.IntegrationServiceFactory.getBaseIntegrationService();
        intframework.BaseIntegrationResponse responseObject;
        String apiType = ConstantValues.NUMBER_API_TYPE;
        // Calling the adapter class, by specifying integraiton family and api type in the base integration service
        responseObject = (intframework.BaseIntegrationResponse) baseintegrationService.runSynchronousIntegrationService(
          ConstantValues.FAMILY_NAME,
          apiType,
          new Map<String, Object>(),
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

        String json = System.JSON.serialize(responseMap);
        result = parse(json);
        /*
        Converting the SearchByABNNumberHelper class response object into JSON string format
        to be able to process it in skuid javascript snippet.
        */
        if(partyList.size() > 0){
          partyList.get(0).Flag_Party__c = true;
          Update partyList;
        }
        return System.JSON.serialize(result);
      } 
      catch (Exception ex) {
        GenericUtility.insertLog('SMSFSearchByABNNumberCallout', ex);
        return null;
      }
    }
    //method to parse the response
    public static SMSFSearchByABNNumberHelper parse(String json){
      if(String.isNotBlank(json)){
        // Changing the response format from Map to SMSFABNNameSearchHelper class object
        SMSFSearchByABNNumberHelper parserObject = SMSFSearchByABNNumberHelper.parse(json);
        if(parserObject == null){
          parserObject = new SMSFSearchByABNNumberHelper();
          parserObject.errMessage = ConstantValues.GENERAL_EXCEPTION;
          return parserObject;
        }
        /* The following try-catch block handles if any exception happens while fetching
        matchingFundNames201908 null check */
        try {
          if (parserObject.superFundPayload.response.superannuationFund2015 == null) {
            parserObject.errMessage = ConstantValues.INVALID_ABN;
          }
        } catch (Exception ex) {
          parserObject.errMessage = ConstantValues.GENERAL_EXCEPTION;
        }
        return parserObject;
      }
      return null;
    } 
  }