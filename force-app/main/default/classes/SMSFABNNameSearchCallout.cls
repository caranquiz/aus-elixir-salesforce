/****************************************************************************************************/
/* Description          : This is the callout for SMSFABNNameSearchAdapter class. 
                          This class fetches the trust response using SMSF Name. */
/****************************************************************************************************/

global with sharing class SMSFABNNameSearchCallout {
  private static SMSFABNNameSearchHelper parserObject = new SMSFABNNameSearchHelper();
  webService static String searchBySMSFName(String partyId) {
    if(String.isBlank(partyId)){
      parserObject.errMessage = 'ABN field is empty';
      return JSON.serialize(parserObject);
    }
    Map<String, Object> queryIdMap = new Map<String, Object>();
    queryIdMap.put('partyId', partyId);
    Map<String, Object> requestParamMap = new Map<String, Object>();
    dom.Document doc = new dom.Document();

    try {
      intframework.AbstractIntegrationService baseintegrationService = intframework.IntegrationServiceFactory.getBaseIntegrationService();
      intframework.BaseIntegrationResponse responseObject;
      String apiType = 'ABNSearchSMSFAPI';
      // Calling the adapter class, by speifying integraiton family and api type in the base integration service
      responseObject = (intframework.BaseIntegrationResponse) baseintegrationService.runSynchronousIntegrationService(
        'ABNSearchSMSF',
        apiType,
        queryIdMap,
        requestParamMap
      );
      // null check before fetching the body data
      if (responseObject == null || responseObject.getBody() == null) {
        parserObject.errMessage = 'Something went wrong';
        return JSON.serialize(parserObject);
      }
      doc.load(responseObject.getBody());
      // Changing the response format from String to Map
      Map<String, Object> responseMap = intframework.XmlToJson.parseDocumentToMap(
        doc
      );
      String json = System.JSON.serialize(responseMap);
      // Changing the response format from Map to SMSFABNNameSearchHelper class object
      SMSFABNNameSearchHelper parserObject = SMSFABNNameSearchHelper.parse(
        json
      );
      if(parserObject == null){
        parserObject = new SMSFABNNameSearchHelper();
        parserObject.errMessage = 'Something went wrong';
        return System.JSON.serialize(parserObject);
      }
      /* The following try-catch block handles if any exception happens while fetching
       matchingFundNames201908 null check */
      try {
        if (parserObject.superFundNamesPayload.response.matchingFundNames201908 == null) {
          parserObject.errMessage = 'Invalid SMSF Name';
          //return null;
        }
      } catch (Exception ex) {
        parserObject.errMessage = 'Something went wrong';
      }
      /*
      Converting the ABNNameSearchHelper class response object into JSON string format
      to be able to process it in skuid javascript snippet.
      */
      return System.JSON.serialize(parserObject);
    } catch (Exception ex) {
      GenericUtility.insertLog('SMSFABNNameSearchCallout', ex);
      return null;
    }
  }
}