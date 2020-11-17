/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Pratik Agarwal
Description : This class fetches the ABN search result response from SearchByABNNumber by using ABN Number.
Development Date : 2/09/2020
Last Modified Date : 14/10/2020
****************************************************************************************************/

global with sharing class SMSFSearchByABNNumberAdapter extends intframework.BaseIntegrationAdapter {
  global override intframework.BaseIntegrationRequest createRequest(
    Map<String, Object> relatedObjectIds,
    Map<String, Object> filledInRequestMap
  ) {
    try {
      intframework.BaseIntegrationRequest httpReq = new intframework.BaseIntegrationRequest();
      String abn = String.valueOf(
        filledInRequestMap.get(ConstantValues.ABN_NUMBER)
      );

      // BASIC ABN NUMBER VALIDATION CHECK
      List<Map<String, Object>> guidList = (List<Map<String, Object>>) filledInRequestMap.get(
        ConstantValues.GUID_INFO
      );
      GenericUtility.isListValid(guidList, ConstantValues.GUID_EXCEPTION);
      String guid = String.valueOf(guidList[0].get(ConstantValues.GUID));
      // This method will throw exception if the guid is null or blank
      GenericUtility.isValid(guid, ConstantValues.GUID_EXCEPTION);

      //forming url for requesting response
      String ndPoint =
        ConstantVAlues.CALLOUT_STRUCTURE + apiConfig.apiNamedCredential;
      String url =
        ndPoint +
        ConstantValues.ABN_STRUCTURE +
        abn +
        ConstantValues.GUID_STRUCTURE +
        guid;

      httpReq.setEndpoint(url);
      return httpReq;
    } catch (Exception ex) {
      GenericUtility.insertLog(ConstantValues.SMSFSEARCHCLASS, ex);
      return null;
    }
  }
  //Methods below are for test classes to get mock response
  global override System.HttpResponse sendRequest(System.HttpRequest httpReq) {
    try {
      httpReq.setMethod(apiConfig.httpMethod);
      httpReq.setTimeout(apiConfig.requestTimeout);
      System.Http http = new System.Http();
      System.HTTPResponse res;
      res = http.send(httpReq);
      return res;
    } catch (Exception ex) {
      GenericUtility.insertLog(ConstantValues.SMSFSEARCHCLASS, ex);
      return null;
    }
  }
}
