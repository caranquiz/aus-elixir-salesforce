/****************************************************************************************************/
/* Description          : This is the callout for SMSFABNNameSearchAdapter class. 
                          This class fetches the trust response using SMSF Name and calls SMSFABNNameSearchHelper
                          class to parse the response */
/****************************************************************************************************/

global with sharing class SMSFABNNameSearchCallout {
  private static SMSFABNNameSearchHelper parserObject = new SMSFABNNameSearchHelper();
  webService static String searchBySMSFName(String partyId) {
    if(String.isBlank(partyId)){
      parserObject.errMessage = ConstantValues.PARTY_ID_EMPTY;
      return JSON.serialize(parserObject);
    }
    Map<String, Object> queryIdMap = new Map<String, Object>();
    queryIdMap.put(ConstantValues.PARTY_ID, partyId);
    Map<String, Object> requestParamMap = new Map<String, Object>();
    dom.Document doc = new dom.Document();
    SMSFABNNameSearchHelper result = new SMSFABNNameSearchHelper();

    try {
      intframework.AbstractIntegrationService baseintegrationService = intframework.IntegrationServiceFactory.getBaseIntegrationService();
      intframework.BaseIntegrationResponse responseObject;
      String apiType = ConstantValues.NAME_API_TYPE;
      // Calling the adapter class, by specifying integraiton family and api type in the base integration service
      responseObject = (intframework.BaseIntegrationResponse) baseintegrationService.runSynchronousIntegrationService(
        ConstantValues.FAMILY_NAME,
        apiType,
        queryIdMap,
        requestParamMap
      );
      // null check before fetching the body data
      if (responseObject == null || responseObject.getBody() == null) {
        parserObject.errMessage = ConstantValues.GENERAL_EXCEPTION;
        return JSON.serialize(parserObject);
      }
      doc.load(responseObject.getBody());
      // Changing the response format from String to Map
      Map<String, Object> responseMap = intframework.XmlToJson.parseDocumentToMap(doc);

      String json = System.JSON.serialize(responseMap);
      result = parse(json);
      /*
      Converting the ABNNameSearchHelper class response object into JSON string format
      to be able to process it in skuid javascript snippet.
      */
      return System.JSON.serialize(result);
    } catch (Exception ex) {
      GenericUtility.insertLog('SMSFABNNameSearchCallout', ex);
      return null;
    }
  }
  //Method to parse the response
  public static SMSFABNNameSearchHelper parse(String json){
    if(String.isNotBlank(json)){
      // Changing the response format from Map to SMSFABNNameSearchHelper class object
      SMSFABNNameSearchHelper parserObject = SMSFABNNameSearchHelper.parse(json);
      if(parserObject == null){
        parserObject = new SMSFABNNameSearchHelper();
        parserObject.errMessage = ConstantValues.GENERAL_EXCEPTION;
        return parserObject;
      }
      /* The following try-catch block handles if any exception happens while fetching
      matchingFundNames201908 null check */
      try {
        if (parserObject.superFundNamesPayload.response.matchingFundNames201908 == null) {
          parserObject.errMessage = ConstantValues.INVALID_SMSF_NAME;
        }
      } catch (Exception ex) {
        parserObject.errMessage = ConstantValues.GENERAL_EXCEPTION;
      }
      return parserObject;
    }
    return null;
  } 
}