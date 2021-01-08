/********************************************************************************************
 Description : This class is the Adapter class for generating request body under Integration
                 framework for Org Id Verification of Current Directorship.
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Pratik Agarwal
Development Date : 2/09/2020
Last Modified Date : 14/10/2020                 
********************************************************************************************/
global without sharing class EquifaxOrgIdSearchAdapter extends intframework.BaseIntegrationAdapter {
  //Wrapper class for dynamic data for generating request body
  private class RequestBody {
    String subscriberIdentifier;
    String security;
    String partyName;
    String xmlRequestBody;
    String acnNumber;
  }
  global String attachmentPartyId;
  global String attachmentRequestBody;
  RequestBody reqBody = new RequestBody();
  global override virtual String generateRequestBody(
    Map<String, Object> filledInRequestMap
  ) {
    try {
      if (filledInRequestMap != null) {
        //Fetching Details from Request Mapping in API Configuration
        List<Map<String, Object>> equifaxCredList = (List<Map<String, Object>>) filledInRequestMap.get(
          ConstantValues.EQUIFAX_CREDS
        );
        GenericUtility.isListValid(
          equifaxCredList,
          ConstantValues.EQUIFAX_CRED_EXCEP
        );
        reqBody.subscriberIdentifier = (String) equifaxCredList[0]
          .get(ConstantValues.SUBSCRIBER_IDENTIFIER);
        reqBody.security = (String) equifaxCredList[0]
          .get(ConstantValues.SECURITY);

        List<Map<String, Object>> partyList = (List<Map<String, Object>>) filledInRequestMap.get(
          ConstantValues.PARTY_INFO
        );
        GenericUtility.isListValid(partyList, ConstantValues.PARTY_NAME_EXCEP);
        reqBody.partyName = (String) partyList[0]
          .get(ConstantValues.PARTY_NAME);

        reqBody.xmlRequestBody = (String) filledInRequestMap.get(
          ConstantValues.EQUIFAX_XML_REQUEST_BODY
        );
        reqBody.acnNumber = (String) filledInRequestMap.get(
          ConstantValues.EQUIFAX_ACN_NUMBER
        );
        //Null checking for all paramters from Request Mapping
        isValid(equifaxCredList, partyList);

        reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace(
          ConstantValues.CS_SUBSCRIBER_IDENTIFIER,
          reqBody.subscriberIdentifier
        );
        reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace(
          ConstantValues.CS_SECURITY,
          reqBody.security
        );
        reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace(
          ConstantValues.REQUEST_BODY_PARTY_NAME,
          reqBody.partyName
        );
        reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace(
          ConstantValues.USERNAME,
          ConstantValues.CREDENTIAL_USERNAME
        );
        reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace(
          ConstantValues.PASSWORD,
          ConstantValues.CREDENTIAL_PASSWORD
        );
        reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace(
          ConstantValues.REQUEST_ACN_NUMBER,
          reqBody.acnNumber
        );
        // Checks if callout happening in test environment
        Equifax_Referece__c equifaxRefObj = Equifax_Referece__c.getInstance();
        if (
          equifaxRefObj == null ||
          (equifaxRefObj != null && !equifaxRefObj.Test_Environment__c)
        ) {
          reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace(
            ConstantValues.MODE_OF_ENVIRONMENT,
            ConstantValues.PRODUCTION_ENVIRONMENT
          );
        }
        else{
          reqBody.xmlRequestBody = reqBody.xmlRequestBody.replace(
            ConstantValues.MODE_OF_ENVIRONMENT,
            ConstantValues.TEST_ENVIRONMENT
          );
        }
        attachmentRequestBody = reqBody.xmlRequestBody;
        if(String.valueOf(partyList[0].get('partyId')) != NULL
          && String.valueOf(partyList[0].get('partyId')) != ''){
          attachmentPartyId = String.valueOf(partyList[0].get('partyId'));
        }
        return reqBody.xmlRequestBody;
      } else {
        throw new intframework.IntegrationException(
          ConstantValues.GENERAL_ERROR
        );
      }
    } catch (Exception ex) {
      GenericUtility.insertLog('EquifaxOrgIdSearchAdapter', ex);
      return null;
    }
  }
  global override intframework.BaseIntegrationResponse preProcessResponse(intframework.BaseIntegrationResponse response){
    //Storing Request as Attachment
    Request_And_Response_Storage__c responseSettings = Request_And_Response_Storage__c.getOrgDefaults(); 
    if(responseSettings.Store_Equifax_Org_ID_Request_Response__c == true){
        GenericUtility.createAttachment('EquifaxOrgIdEnquiryRequest_'+String.valueOf(DateTime.now())+'.xml',
        attachmentRequestBody,
        attachmentPartyId
      );
    }
    return response;
  }
  global override System.HttpResponse sendRequest(System.HttpRequest httpReq) {
    try {
      httpReq.setEndpoint('callout:' + apiConfig.apiNamedCredential);
      httpReq.setMethod(apiConfig.httpMethod);
      httpReq.setTimeout(apiConfig.requestTimeout);
      System.Http http = new System.Http();
      System.HTTPResponse res;
      res = http.send(httpReq);
      return res;
    } catch (Exception ex) {
      GenericUtility.insertLog('EquifaxOrgIdSearchAdapter', ex);
      return null;
    }
  }
  public void isValid(
    List<Map<String, Object>> equifaxCredList,
    List<Map<String, Object>> partyList
  ) {
    //Null check on Credentials List
    GenericUtility.isListValid(
      equifaxCredList,
      ConstantValues.EQUIFAX_CRED_EXCEP
    );
    //Null check on Party Name List
    GenericUtility.isListValid(partyList, ConstantValues.PARTY_NAME_EXCEP);
    //Null check on Subsrciber Identifier
    GenericUtility.isValid(
      reqBody.subscriberIdentifier,
      ConstantValues.SUBSCRIBER_IDENTIFIER_EXCEP
    );
    //Null check on Security
    GenericUtility.isValid(reqBody.security, ConstantValues.SECURITY_EXCEP);
    //Null check on Party Name
    GenericUtility.isValid(reqBody.partyName, ConstantValues.PARTY_NAME_EXCEP);
  }
}