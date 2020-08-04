/****************************************************************************************************/
/* Description : This class fetches the ABN search result response from ABN Lookup by using SMSF Name. */
/****************************************************************************************************/

global with sharing class SMSFABNNameSearchAdapter extends intframework.BaseIntegrationAdapter {

    global override intframework.BaseIntegrationRequest createRequest(Map<String, Object> relatedObjectIds, Map<String, Object> filledInRequestMap) {
      try {
        intframework.BaseIntegrationRequest httpReq = new intframework.BaseIntegrationRequest();
        String abn = (String) filledInRequestMap.get('abndata');

        // BASIC ABN NUMBER VALIDATION CHECK
        List<Map<String, Object>> guidList = (List<Map<String, Object>>) filledInRequestMap.get('guidInfo');
        listValidation(guidList,': GUID is null or blank');

        String guid = (String) guidList[0].get('guid');
        // This method will throw exception if the guid is null or blank
        validation(guid,': GUID is null or blank');

        //activeFundsOnly
        String activeFundsOnly = (String) guidList[0].get('activeFundsOnly');
        validation(activeFundsOnly,': Active Funds Only is null or blank');

        //maxSearchResults
        String maxSearchResults = (String) guidList[0].get('maxSearchResults');
        validation(maxSearchResults,': Maximum Search Results is null or blank');

        List<Map<String, Object>> nameList = (List<Map<String, Object>>) filledInRequestMap.get('partyinfo');
        listValidation(nameList,': Name is null or blank');

        String name = (String) nameList[0].get('name');
        validation(name,': Name is null or blank');

        //Validating named credential
        validation(apiConfig.apiNamedCredential,': API named credential is null or blank');

        //forming url for requesting response
        String ndPoint = 'callout:' + apiConfig.apiNamedCredential;
        name = '?name=' + name;
        guid = '&guid=' + guid;
        activeFundsOnly = '&activeFundsOnly=' + activeFundsOnly;
        maxSearchResults = '&maxSearchResults=' + maxSearchResults;
        String url = ndPoint + name + guid + activeFundsOnly + maxSearchResults;

        httpReq.setEndpoint(url);
        return httpReq;
      } 
      catch (Exception ex) {
        GenericUtility.insertLog('SMSFABNNameSearchAdapter', ex);
        return null;
      }
    }
    global override virtual String generateRequestBody(Map<String, Object> filledInRequestMap) {
      return '';
    }

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
    public static void validation(String value,String msg){
      if(String.isBlank(value)){
        throw new CustomException(msg);
      }
    }
    public static void listValidation(List<Map<String, Object>> value, String msg){
      if(value.isEmpty()){
        throw new CustomException(msg);
      }
    }
  }