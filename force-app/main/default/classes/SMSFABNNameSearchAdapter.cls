/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Pratik Agarwal
Description : This class fetches the ABN search result response from ABNSearchSMSFAPI config by using SMSF Name.
Development Date : 2/09/2020
Last Modified Date : 14/10/2020
****************************************************************************************************/

global with sharing class SMSFABNNameSearchAdapter extends intframework.BaseIntegrationAdapter {
  //Wrapper class to store different parts of request URL
  public class RequestURL {
    String endPoint;
    String name;
    String guid;
    String activeFundsOnly;
    String maxSearchResults;
  }
  RequestURL reqURL = new RequestURL();
  global override intframework.BaseIntegrationRequest createRequest(
    Map<String, Object> relatedObjectIds,
    Map<String, Object> filledInRequestMap
  ) {
    try {
      intframework.BaseIntegrationRequest httpReq = new intframework.BaseIntegrationRequest();
      String abn = (String) filledInRequestMap.get(ConstantValues.ABN_DATA);

      List<Map<String, Object>> guidList = (List<Map<String, Object>>) filledInRequestMap.get(
        ConstantValues.GUID_INFO
      );
      if (!(guidList.size() > 0)) {
        throw new CustomException(System.label.GUID_not_found);
      }
      //GUID
      reqURL.guid = (String) guidList[0].get(ConstantValues.GUID);
      reqURL.guid = (String) EncodingUtil.urlEncode(reqURL.guid, 'UTF-8');

      //activeFundsOnly
      reqURL.activeFundsOnly = (String) guidList[0]
        .get(ConstantValues.ACTIVE_FUNDS_ONLY);
      reqURL.activeFundsOnly = (String) EncodingUtil.urlEncode(
        reqURL.activeFundsOnly,
        'UTF-8'
      );

      //maxSearchResults
      reqURL.maxSearchResults = (String) guidList[0]
        .get(ConstantValues.MAX_SEARCH_RESULTS);
      reqURL.maxSearchResults = (String) EncodingUtil.urlEncode(
        reqURL.maxSearchResults,
        'UTF-8'
      );

      //Name of trust to be searched
      List<Map<String, Object>> nameList = (List<Map<String, Object>>) filledInRequestMap.get(
        ConstantValues.PARTY_INFO
      );
      if (!(nameList.size() > 0)) {
        throw new CustomException(System.label.Data_not_found_for_callout);
      }
      reqURL.name = (String) nameList[0].get(ConstantValues.ABN_TRUST_NAME);
      reqURL.name = (String) EncodingUtil.urlEncode(reqURL.name, 'UTF-8');

      //Validating values
      validate(guidList, nameList, apiConfig.apiNamedCredential);

      //forming url for requesting response
      reqURL.endPoint = 'callout:' + apiConfig.apiNamedCredential;
      if (Test.isRunningTest()) {
        reqURL.endPoint += apiConfig.apiEndpoint;
      }
      String url = getURL();
      httpReq.setEndpoint(url);
      return httpReq;
    } catch (Exception ex) {
      GenericUtility.insertLog('SMSFABNNameSearchAdapter', ex);
      return null;
    }
  }
  //Method to form Request URL
  public String getURL() {
    reqURL.name = '?name=' + reqURL.name;
    reqURL.guid = '&guid=' + reqURL.guid;
    reqURL.activeFundsOnly = '&activeFundsOnly=' + reqURL.activeFundsOnly;
    reqURL.maxSearchResults = '&maxSearchResults=' + reqURL.maxSearchResults;
    String url =
      reqURL.endPoint +
      reqURL.name +
      reqURL.guid +
      reqURL.activeFundsOnly +
      reqURL.maxSearchResults;
    return url;
  }
  //Method for validation of values
  public void validate(
    List<Map<String, Object>> guidList,
    List<Map<String, Object>> nameList,
    String namedCredential
  ) {
    //Validating GUID info
    GenericUtility.isListValid(guidList, ConstantValues.GUID_EXCEPTION);
    //GUID
    GenericUtility.isValid(reqURL.guid, ConstantValues.GUID_EXCEPTION);
    //ActiveFundsOnly
    GenericUtility.isValid(
      reqURL.activeFundsOnly,
      ConstantValues.ACTIVE_FUNDS_ONLY_EXCEPTION
    );
    //MaxSearchResults
    GenericUtility.isValid(
      reqURL.maxSearchResults,
      ConstantValues.MAX_SEARCH_RESULTS_EXCEPTION
    );
    //Validating Name of trust to be searched
    GenericUtility.isListValid(
      nameList,
      ConstantValues.ABN_TRUST_NAME_EXCEPTION
    );
    GenericUtility.isValid(
      reqURL.name,
      ConstantValues.ABN_TRUST_NAME_EXCEPTION
    );
    //Validating named credential
    GenericUtility.isValid(
      namedCredential,
      ConstantValues.NAMED_CREDENTIAL_EXCEPTION
    );
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
      GenericUtility.insertLog('SMSFABNNameSearchAdapter', ex);
      return null;
    }
  }
}