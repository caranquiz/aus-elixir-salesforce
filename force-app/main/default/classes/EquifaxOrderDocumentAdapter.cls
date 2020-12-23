/**********************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : EquifaxOrderDocumentAdapter */
/* Created Date         : 30/07/2020 */
/* Developed By         : Souvik */
/* Description          : This is the adapter class for Order Document API of Equifax */
/* Last Modified Date   : 30/07/2020 */
/* Last Modified By     : Souvik */
/*********************************************************************************************************/

global class EquifaxOrderDocumentAdapter extends intframework.BaseIntegrationAdapter {
  global String attachmentSecurityId;
  global String attachmentRequestBody;
  global override virtual String generateRequestBody(
    Map<String, Object> filledInRequestMap
  ) {
    String clientReference;
    String testStateRef;
    String testTitleReference;
    String requestbody;
    Boolean orderTitleProceed = true;
    try {
      if (filledInRequestMap == null) {
        return null;
      }
      requestbody =
        ConstantValues.REQ_ENVELOPE_START +
        ConstantValues.REQ_HEADER +
        ConstantValues.REQ_OD_ACTION;
      requestbody += ConstantValues.REQ_BODY + '<land:order-document-request>';
      if (
        filledInRequestMap.containsKey('titleReference') &&
        String.isNotBlank((String) filledInRequestMap.get('titleReference'))
      ) {
        testTitleReference = (String) filledInRequestMap.get('titleReference');
      }
      if (
        filledInRequestMap.containsKey('testStateRef') &&
        String.isNotBlank((String) filledInRequestMap.get('testStateRef'))
      ) {
        testStateRef = (String) filledInRequestMap.get('testStateRef');
      }
      if (
        filledInRequestMap.containsKey('clientRef') &&
        String.isNotBlank((String) filledInRequestMap.get('clientRef'))
      ) {
        clientReference = (String) filledInRequestMap.get('clientRef');
      }
      if (String.isNotBlank(clientReference)) {
        requestbody +=
          '<land:request-header><land:client-reference>' +
          clientReference +
          '</land:client-reference></land:request-header>';
      } else {
        requestbody += '<land:request-header/>';
      }
      requestbody += '<land:order-document-request-data>';
      requestbody +=
        '<land:state-territory-land-registry>' +
        testStateRef +
        '</land:state-territory-land-registry>';
      // Checks if callout happening in test environment
      Equifax_Referece__c equifaxRefObj = Equifax_Referece__c.getInstance();
      if (
        equifaxRefObj == null ||
        (equifaxRefObj != null && !equifaxRefObj.Test_Environment__c)
      ) {
        if (
          filledInRequestMap.containsKey('confirmPrice') &&
          filledInRequestMap.get('confirmPrice') != null
        ) {
          requestbody += '<land:price-confirm-proceed>true</land:price-confirm-proceed>';
        } else {
          requestbody += '<land:price-confirm-proceed/>';
        }
      }
      if (
        equifaxRefObj != null &&
        String.isNotBlank(equifaxRefObj.Callback_Notify_url__c)
      ) {
        requestbody +=
          '<land:callback-notify>' +
          equifaxRefObj.Callback_Notify_url__c +
          '</land:callback-notify>';
      }
      if (orderTitleProceed != null) {
        requestbody +=
          '<land:order-title-proceed>' +
          String.valueOf(orderTitleProceed) +
          '</land:order-title-proceed>';
      }
      requestbody +=
        '<land:order-title-request><land:title-by-reference><land:title-reference>' +
        testTitleReference +
        '</land:title-reference></land:title-by-reference></land:order-title-request>';
      requestbody += '</land:order-document-request-data></land:order-document-request></soap:Body></soap:Envelope>';
      attachmentRequestBody = requestBody;
      if(filledInRequestMap.containsKey('securityId') &&
        String.valueOf(filledInRequestMap.get('securityId')) != NULL
        && String.valueOf(filledInRequestMap.get('securityId')) != ''){
        attachmentSecurityId = String.valueOf(filledInRequestMap.get('securityId'));
      }
      return requestbody;
    } catch (Exception ex) {
      GenericUtility.insertLog('EquifaxOrderDocumentAdapter', ex);
      return null;
    }
  }
  global override intframework.BaseIntegrationResponse preProcessResponse(intframework.BaseIntegrationResponse response){
    //Storing Request as Attachment
    Request_And_Response_Storage__c responseSettings = Request_And_Response_Storage__c.getOrgDefaults(); 
    if(responseSettings.Store_Land_Title_Store_Request_Response__c == true){
        GenericUtility.createAttachment('EquifaxSearchOrderDocumentRequest_'+String.valueOf(DateTime.now())+'.xml',
        attachmentRequestBody,
        attachmentSecurityId
      );
    }
    return response;
  }
  global override System.HttpResponse sendRequest(System.HttpRequest httpReq) {
    System.HTTPResponse res;
    System.Http http;
    try {
      httpReq.setEndpoint(
        'callout:' +
        apiConfig.apiNamedCredential +
        apiConfig.apiEndpoint
      );
      if (Test.isRunningTest()) {
        httpReq.setEndpoint(apiConfig.apiEndpoint);
      }
      httpReq.setMethod(apiConfig.httpMethod);
      httpReq.setTimeout(apiConfig.requestTimeout);
      http = new System.Http();
      res = http.send(httpReq);
      return res;
    } catch (Exception ex) {
      GenericUtility.insertLog('EquifaxOrderDocumentAdapter', ex);
      return null;
    }
  }
}