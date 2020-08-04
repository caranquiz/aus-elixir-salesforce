/****************************************************************************************************/
/* Description          : This class fetches the ABN search result response from ABN Lookup by using ABN Number. */
/****************************************************************************************************/

global with sharing class SMSFSearchByABNNumberAdapter extends intframework.BaseIntegrationAdapter {

    global override intframework.BaseIntegrationRequest createRequest(Map<String, Object> relatedObjectIds, Map<String, Object> filledInRequestMap) {
      try {
        intframework.BaseIntegrationRequest httpReq = new intframework.BaseIntegrationRequest();
        String abn = (String) filledInRequestMap.get('abnnumber');

        // BASIC ABN NUMBER VALIDATION CHECK
        List<Map<String, Object>> guidList = (List<Map<String, Object>>) filledInRequestMap.get(
          'guidinfo'
        );
        if(guidList.isEmpty()){
          throw new CustomException(': GUID is null or blank');
        }
        String guid = (String) guidList[0].get('guid');
        // This method will throw exception if the guid is null or blank
        if(String.isBlank(guid)){
          throw new CustomException(': GUID is null or blank');
        }
        
        //forming url for requesting response
        String ndPoint = 'callout:' + apiConfig.apiNamedCredential;
        String url = ndPoint + '?abn=' + abn + '&guid=' + guid;

        httpReq.setEndpoint(url);
        return httpReq;
      } 
      catch (Exception ex) {
        GenericUtility.insertLog('SMSFSearchByABNNumberAdapter', ex);
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
        } 
        catch (Exception ex) {
            GenericUtility.insertLog('SMSFSearchByABNNumberAdapter', ex);
            return null;
        }
    }
}