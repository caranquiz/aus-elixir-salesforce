/**********************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : EquifaxDeliverDocumentAdapter */
/* Created Date         : 30/07/2020 */
/* Developed By         : Souvik */
/* Description          : This is the adapter class for Deliver Document API of Equifax */
/* Last Modified Date   : 30/07/2020 */
/* Last Modified By     : Souvik */
/*********************************************************************************************************/

global class EquifaxDeliverDocumentAdapter extends intframework.BaseIntegrationAdapter {
  global String attachmentSecurityId;
  global String attachmentRequestBody;
  global override virtual String generateRequestBody(
    Map<String, Object> filledInRequestMap
  ) {
    String clientReference;
    String enquiryId;
    String requestbody;
    try {
      if (filledInRequestMap == null) {
        return null;
      }
      requestbody =
        ConstantValues.REQ_ENVELOPE_START +
        ConstantValues.REQ_HEADER +
        ConstantValues.REQ_DD_ACTION;
      requestbody +=
        ConstantValues.REQ_BODY + '<land:deliver-document-request>';
      if (
        filledInRequestMap.containsKey('clientReference') &&
        String.isNotBlank((String) filledInRequestMap.get('clientReference'))
      ) {
        clientReference = (String) filledInRequestMap.get('clientReference');
      }
      if (String.isNotBlank(clientReference)) {
        requestbody +=
          '<land:request-header><land:client-reference>' +
          clientReference +
          '</land:client-reference></land:request-header>';
      } else {
        requestbody += '<land:request-header/>';
      }
      if (
        filledInRequestMap.containsKey('enquiryId') &&
        String.isNotBlank((String) filledInRequestMap.get('enquiryId'))
      ) {
        enquiryId = (String) filledInRequestMap.get('enquiryId');
      }
      requestbody +=
        '<land:deliver-document-request-data><land:enquiry-id>' +
        enquiryId +
        '</land:enquiry-id>';
      //Content Type of the document
      requestbody += '<land:content-type>application/pdf</land:content-type>';
      requestbody +=
        '</land:deliver-document-request-data>' +
        '</land:deliver-document-request>' +
        ConstantValues.REQ_ENVELOPE_END;
        attachmentRequestBody = requestBody;
        if(filledInRequestMap.containsKey('securityId') &&
          String.valueOf(filledInRequestMap.get('securityId')) != NULL
          && String.valueOf(filledInRequestMap.get('securityId')) != ''){
          attachmentSecurityId = String.valueOf(filledInRequestMap.get('securityId'));
        }
      return requestbody;
    } catch (Exception ex) {
      GenericUtility.insertLog('EquifaxDeliverDocumentAdapter', ex);
      return null;
    }
  }
  global override intframework.BaseIntegrationResponse preProcessResponse(intframework.BaseIntegrationResponse response){
    //Storing Request as Attachment
    Request_And_Response_Storage__c responseSettings = Request_And_Response_Storage__c.getOrgDefaults(); 
    if(responseSettings.Store_Land_Title_Store_Request_Response__c == true){
        GenericUtility.createAttachment('EquifaxSearchDeliverDocumentRequest_'+String.valueOf(DateTime.now())+'.xml',
        attachmentRequestBody,
        attachmentSecurityId
      );
    }
    return response;
  }
  global override System.HttpResponse sendRequest(System.HttpRequest httpReq) {
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
      System.Http http = new System.Http();
      System.HTTPResponse res;
      res = http.send(httpReq);
      return res;
    } catch (Exception ex) {
      GenericUtility.insertLog('EquifaxDeliverDocumentAdapter', ex);
      return null;
    }
  }
}