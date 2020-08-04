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
    global override virtual String generateRequestBody(
      Map<String, Object> filledInRequestMap
    ) {
        String clientReference;
        String enquiryId;
        String requestbody;
        try {
          requestbody = ConstantValues.REQ_ENVELOPE_START + ConstantValues.REQ_HEADER + ConstantValues.REQ_DD_ACTION;
          requestbody += ConstantValues.REQ_BODY + '<land:deliver-document-request>';
          if(filledInRequestMap.containsKey('clientReference') && String.isNotBlank((String) filledInRequestMap.get('clientReference'))){
            clientReference = (String) filledInRequestMap.get('clientReference');
          }
          if(String.isNotBlank(clientReference)){
            requestbody += '<land:request-header><land:client-reference>' + clientReference + '</land:client-reference></land:request-header>';
          }else{
            requestbody += '<land:request-header/>';
          }
          if(filledInRequestMap.containsKey('enquiryId') && String.isNotBlank((String) filledInRequestMap.get('enquiryId'))){
            enquiryId = (String) filledInRequestMap.get('enquiryId');
          }
          requestbody += '<land:deliver-document-request-data><land:enquiry-id>'
            + enquiryId + '</land:enquiry-id>';
            //Content Type of the document
          requestbody += '<land:content-type>application/pdf</land:content-type>';
          requestbody += '</land:deliver-document-request-data>'
          + '</land:deliver-document-request>' + ConstantValues.REQ_ENVELOPE_END;
          return requestbody;
        } catch (Exception ex) {
          GenericUtility.insertLog('EquifaxDeliverDocumentAdapter', ex);
          return null;
        }
    }

    global override System.HttpResponse sendRequest(System.HttpRequest httpReq) {
        try {
          httpReq.setEndpoint('callout:' + apiConfig.apiNamedCredential);
          if(Test.isRunningTest()){
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