/**********************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : EquifaxSearchTitleByAddressAdapter */
/* Created Date         : 28/07/2020 */
/* Developed By         : Souvik */
/* Description          : This is the adapter class for Title Search by Address API of Equifax */
/* Last Modified Date   : 28/07/2020 */
/* Last Modified By     : Souvik */
/*********************************************************************************************************/

global with sharing class EquifaxSearchTitleByAddressAdapter extends intframework.BaseIntegrationAdapter {
  global override virtual String generateRequestBody(
    Map<String, Object> filledInRequestMap
  ) {
    String unitNo;
    String streetNo;
    String streetName;
    String streetType;
    String city;
    String state;
    String postalCode;
    String country;
    String stateRef;
    String requestbody;
    Map<String, Object> collateralFieldsMap;
    List<Map<String, Object>> collateralFieldsList;
    Equifax_Referece__c equifaxRefObj;
    if (filledInRequestMap == null) {
      return null;
    }
    try {
      requestbody =
        ConstantValues.REQ_ENVELOPE_START +
        ConstantValues.REQ_HEADER +
        ConstantValues.REQ_SLT_ACTION;
      requestbody +=
        ConstantValues.REQ_BODY + '<land:search-land-titles-request>';
      requestbody +=
        '<land:request-header><land:client-reference>' +
        (String) UserInfo.getUserId() +
        '</land:client-reference></land:request-header>';
      requestbody += '<land:search-land-titles-request-data>';
      collateralFieldsList = (List<Map<String, Object>>) filledInRequestMap.get(
        'collateralInfo'
      );
      if (collateralFieldsList.isEmpty()) {
        return null;
      }
      collateralFieldsMap = collateralFieldsList[0];
      if (
        collateralFieldsMap.containsKey('state') &&
        String.isNotBlank((String) collateralFieldsMap.get('state'))
      ) {
        requestbody +=
          '<land:state-territory-land-registry>' +
          (String) collateralFieldsMap.get('state') +
          '</land:state-territory-land-registry>';
      }
      // Checks if callout happening in test environment
      equifaxRefObj = Equifax_Referece__c.getInstance();
      if (
        filledInRequestMap.containsKey('confirmPrice') &&
        filledInRequestMap.get('confirmPrice') != null
      ) {
        requestbody += '<land:price-confirm-proceed>true</land:price-confirm-proceed>';
      } else {
        requestbody += '<land:price-confirm-proceed/>';
      }
      requestbody += '<land:land-title-search-by-address-request><land:address>';
      if (
        collateralFieldsMap.containsKey('unitNo') &&
        String.isNotBlank((String) collateralFieldsMap.get('unitNo'))
      ) {
        requestbody +=
          '<land:unit-number>' +
          (String) collateralFieldsMap.get('unitNo') +
          '</land:unit-number>';
      }
      if (
        collateralFieldsMap.containsKey('streetNo') &&
        String.isNotBlank((String) collateralFieldsMap.get('streetNo'))
      ) {
        requestbody +=
          '<land:street-number>' +
          (String) collateralFieldsMap.get('streetNo') +
          '</land:street-number>';
      }
      if (
        collateralFieldsMap.containsKey('streetName') &&
        String.isNotBlank((String) collateralFieldsMap.get('streetName'))
      ) {
        requestbody +=
          '<land:street-name>' +
          (String) collateralFieldsMap.get('streetName') +
          '</land:street-name>';
      }
      if (
        collateralFieldsMap.containsKey('streetType') &&
        String.isNotBlank((String) collateralFieldsMap.get('streetType'))
      ) {
        requestbody +=
          '<land:street-type>' +
          GenericUtility.convert2StreetTypeCode(
            (String) collateralFieldsMap.get('streetType')
          ) +
          '</land:street-type>';
      }
      if (
        collateralFieldsMap.containsKey('city') &&
        String.isNotBlank((String) collateralFieldsMap.get('city'))
      ) {
        requestbody +=
          '<land:suburb>' +
          (String) collateralFieldsMap.get('city') +
          '</land:suburb>';
      }
      if (
        collateralFieldsMap.containsKey('state') &&
        String.isNotBlank((String) collateralFieldsMap.get('state'))
      ) {
        requestbody +=
          '<land:state>' +
          (String) collateralFieldsMap.get('state') +
          '</land:state>';
      }
      if (
        collateralFieldsMap.containsKey('postalCode') &&
        String.isNotBlank((String) collateralFieldsMap.get('postalCode'))
      ) {
        requestbody +=
          '<land:postcode>' +
          (String) collateralFieldsMap.get('postalCode') +
          '</land:postcode>';
      }
      requestbody +=
        '</land:address></land:land-title-search-by-address-request>' +
        '</land:search-land-titles-request-data></land:search-land-titles-request></soap:Body></soap:Envelope>';
      return requestbody;
    } catch (Exception ex) {
      GenericUtility.insertLog('EquifaxSearchTitleByAddressAdapter', ex);
      return null;
    }
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
      GenericUtility.insertLog('EquifaxSearchTitleByAddressAdapter', ex);
      return null;
    }
  }
}