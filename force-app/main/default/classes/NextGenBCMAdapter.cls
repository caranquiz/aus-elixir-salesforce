/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class the adapter class for generating request body under Integration
                  framework when Application status updates.
Development Date : 09/05/2022
Last Modified Date : 18/05/2022
Devloper's comment : Some part of the codes are hardcoded and not been put in Constant Classes - since
                      they are referenced only here and its a one time use.
****************************************************************************************************/

global without sharing class NextGenBCMAdapter extends intframework.BaseIntegrationAdapter{

    //Wrapper class for dynamic data for generating request body
    private class RequestBody {
        String appName;
        String xmlRequestBody;
        String originatorNumber;
        String appStatus;
        String messageBatch;
        String message;

    }
    RequestBody reqBody = new RequestBody();
    global override virtual String generateRequestBody(Map<String, Object> filledInRequestMap) {
      try {
          List<Map<String, Object>> appList = (List<Map<String, Object>>) filledInRequestMap.get(
              'appInfo'
            );
            if(appList.size()>0){
              reqBody.appName = (String) appList[0]
                .get('name');
              reqBody.originatorNumber = (String) appList[0]
                  .get('originatorId');
            }
            
            reqBody.messageBatch = (String) filledInRequestMap.get(
              'messageBatch'
            );
            reqBody.message = (String) filledInRequestMap.get(
              'message'
            );
            reqBody.appStatus = (String) filledInRequestMap.get(
              'appStatus'
            );
            reqBody.xmlRequestBody = (String) filledInRequestMap.get(
              'nextGenXMLRequestBody'
            );
            
            reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace('ApplicationId',
              reqBody.appName
            );
            reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace('BrokerId',
              reqBody.originatorNumber
            );
            reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace(
              'Status',
              reqBody.appStatus
            );
            reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace('MessageBatchUniqueId',
              reqBody.messageBatch
            );
            reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace(
              'MessageUniqueId',
              reqBody.message
            );
          
          return reqBody.xmlRequestBody;
      }catch(Exception exe){
          GenericUtility.insertLog('NextGenBCMAdapter', exe);
          return null;
      }
    }
    global override System.HttpResponse sendRequest(System.HttpRequest httpReq) {
        try {
          httpReq.setEndpoint(apiConfig.apiEndpoint);
          httpReq.setMethod(apiConfig.httpMethod);
          httpReq.setTimeout(apiConfig.requestTimeout);
          System.Http http = new System.Http();
          System.HTTPResponse res;
          res = http.send(httpReq);
          return res;
        } catch (Exception ex) {
          GenericUtility.insertLog('NextGenBCMAdapter', ex);
          return null;
        }
      }

}