global class EquifaxPreviousEnquiryAdapter extends intframework.BaseIntegrationAdapter {
    global override virtual String generateRequestBody(
      Map<String, Object> filledInRequestMap
    ) {
        String requestBody;
        String enquiryId;
        String contentType;
        try{
            requestBody = (String) filledInRequestMap.get('requestBody');
            enquiryId =  (String) filledInRequestMap.get('enquiryId');
            contentType = (String) filledInRequestMap.get('contentType');
            requestbody = requestbody.replace(ConstantValues.USERNAME_KEY, ConstantValues.NC_USERNAME);
            requestbody = requestbody.replace(ConstantValues.PASSWORD_KEY, ConstantValues.NC_PASSWORD);
            requestBody = requestBody.replace(ConstantValues.ENQUIY_ID_CODE, enquiryId);
            requestBody = requestBody.replace(ConstantValues.CONTENT_TYPE_CODE, contentType);
            System.debug(requestBody);
            return requestBody;
        }
        catch(Exception ex){
            GenericUtility.insertLog('EquifaxOrderDocumentAdapter', ex);
            return null;
        }
    }
    global override System.HttpResponse sendRequest(System.HttpRequest httpReq) {
        try {
            httpReq.setEndpoint('callout:' + apiConfig.apiNamedCredential + apiConfig.apiEndpoint);
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
            GenericUtility.insertLog('EquifaxOrderDocumentAdapter', ex);
            return null;
        }
    }
}