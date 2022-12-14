/**********************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : EquifaxPreviousEnquiryAdapter */
/* Created Date         : 11/08/2020 */
/* Developed By         : Souvik */
/* Description          : This is the adapter class for Previous Enquiry API of Equifax */
/* Last Modified Date   : 2/11/2020 */
/* Last Modified By     : Souvik */
/*********************************************************************************************************/

global class EquifaxPreviousEnquiryAdapter extends intframework.BaseIntegrationAdapter {
  global String attachmentPartyId;
  global String attachmentRequestBody;
  global override virtual String generateRequestBody(
    Map<String, Object> filledInRequestMap
  ) {
    String requestBody;
    String enquiryId;
    String contentType;
    try {
      requestBody = (String) filledInRequestMap.get('requestBody');
      enquiryId = (String) filledInRequestMap.get('enquiryId');
      contentType = (String) filledInRequestMap.get('contentType');
      requestbody = requestbody.replace(
        ConstantValues.USERNAME_KEY,
        ConstantValues.NC_USERNAME
      );
      requestbody = requestbody.replace(
        ConstantValues.PASSWORD_KEY,
        ConstantValues.NC_PASSWORD
      );
      requestBody = requestBody.replace(
        ConstantValues.ENQUIY_ID_CODE,
        enquiryId
      );
      requestBody = requestBody.replace(
        ConstantValues.CONTENT_TYPE_CODE,
        contentType
      );
      attachmentRequestBody = requestBody;
      if(filledInRequestMap.containsKey('partyId')
      && (String)(filledInRequestMap.get('partyId')) != NULL
      && (String)(filledInRequestMap.get('partyId')) != ''){
        attachmentPartyId = (String) filledInRequestMap.get('partyId');
      }
      return requestBody;
    } catch (Exception ex) {
      GenericUtility.insertLog('EquifaxPreviousEnquiryAdapter', ex);
      return null;
    }
  }
  global override intframework.BaseIntegrationResponse preProcessResponse(intframework.BaseIntegrationResponse response){
    //Storing Request as Attachment
    Request_And_Response_Storage__c responseSettings = Request_And_Response_Storage__c.getOrgDefaults(); 
    if(responseSettings.Store_Individual_Prv_Enq_RequestResponse__c == true){
        GenericUtility.createAttachment('EquifaxPreviousEnquiryRequest_'+String.valueOf(DateTime.now())+'.xml',
        attachmentRequestBody,
        attachmentPartyId
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
      GenericUtility.insertLog('EquifaxPreviousEnquiryAdapter', ex);
      return null;
    }
  }
}