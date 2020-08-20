/********************************************************************************************/
/* Description : This class is the Adapter class for generating request body under Integration
                 framework.
/********************************************************************************************/
global without sharing class EquifaxOrgIdSearchAdapter extends intframework.BaseIntegrationAdapter {
    //Wrapper class for dynamic data for generating request body
    private class RequestBody{
        String subscriber_identifier;
        String security;
        String partyName;
        String xmlRequestBody;
        String abnNumber;
    }
    RequestBody reqBody = new RequestBody();
    global override virtual String generateRequestBody(Map<String, Object> filledInRequestMap){
        try {
            if(filledInRequestMap != null) {
                //Fetching Details from Request Mapping in API Configuration
                List<Map<String, Object>> equifaxCredList = (List<Map<String,Object>>)filledInRequestMap.get(ConstantValues.EQUIFAX_CREDS);
                reqBody.subscriber_identifier = (String) equifaxCredList[0].get(ConstantValues.SUBSCRIBER_IDENTIFIER);
                reqBody.security = (String) equifaxCredList[0].get(ConstantValues.SECURITY);

                List<Map<String, Object>> partyList = (List<Map<String,Object>>)filledInRequestMap.get(ConstantValues.PARTY_INFO);
                reqBody.partyName = (String) partyList[0].get(ConstantValues.PARTY_NAME);

                reqBody.xmlRequestBody = (String)filledInRequestMap.get(ConstantValues.EQUIFAX_XML_REQUEST_BODY);
                reqBody.abnNumber = (String)filledInRequestMap.get(ConstantValues.EQUIFAX_ABN_NUMBER);
                //Null checking for all paramters from Request Mapping
                isValid(equifaxCredList,partyList);

                reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace(ConstantValues.CS_SUBSCRIBER_IDENTIFIER,reqBody.subscriber_identifier);
                reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace(ConstantValues.CS_SECURITY,reqBody.security);
                reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace(ConstantValues.REQUEST_BODY_PARTY_NAME,reqBody.partyName);
                reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace(ConstantValues.USERNAME,ConstantValues.CREDENTIAL_USERNAME);
                reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace(ConstantValues.PASSWORD,ConstantValues.CREDENTIAL_PASSWORD);
                reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace(ConstantValues.REQUEST_ABN_NUMBER,reqBody.abnNumber);

                return reqBody.xmlRequestBody;
            }
            else {
                 throw new intframework.IntegrationException(ConstantValues.GENERAL_ERROR);
            }
        }
        catch(Exception ex){
            GenericUtility.insertLog('EquifaxOrgIdSearchAdapter', ex);
            return null;
        }
    }
    global override System.HttpResponse sendRequest(System.HttpRequest httpReq) {
        try {
            httpReq.setEndpoint('callout:'+apiConfig.apiNamedCredential);
            httpReq.setMethod(apiConfig.httpMethod);
            httpReq.setTimeout(apiConfig.requestTimeout);
            System.Http http = new System.Http();
            System.HTTPResponse res;
            res = http.send(httpReq);
            return res;
        } 
        catch (Exception ex) {
            GenericUtility.insertLog('EquifaxOrgIdSearchAdapter', ex);
            return null;
        }
    }
    public void isValid(List<Map<String, Object>> equifaxCredList,List<Map<String, Object>> partyList){
        //Null check on Credentials List
        GenericUtility.isListValid(equifaxCredList, ConstantValues.EQUIFAX_CRED_EXCEP);
        //Null check on Party Name List
        GenericUtility.isListValid(partyList, ConstantValues.PARTY_NAME_EXCEP);
        //Null check on Subsrciber Identifier
        GenericUtility.isValid(reqBody.subscriber_identifier, ConstantValues.SUBSCRIBER_IDENTIFIER_EXCEP);
        //Null check on Security
        GenericUtility.isValid(reqBody.security, ConstantValues.SECURITY_EXCEP);
        //Null check on Party Name
        GenericUtility.isValid(reqBody.partyName, ConstantValues.PARTY_NAME_EXCEP);
    }
 }