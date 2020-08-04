/****************************************************************************************************/
/* Description          : This is the callout for SMSFSearchByABNNumberAdapter class. 
                          This class fetches the trust response using ABN Number. */
/****************************************************************************************************/

global with sharing class SMSFSearchByABNNumberCallout {
    private static SMSFSearchByABNNumberHelper parserObject = new SMSFSearchByABNNumberHelper();
    webservice static String searchByABNNumber(String abn) {
      if(String.isBlank(abn)){
        parserObject.errMessage = 'ABN field is empty';
        return JSON.serialize(parserObject);
      }
      
      Map<String, Object> requestParamMap = new Map<String, Object>();
      requestParamMap.put('abnnumber', abn);
      dom.Document doc = new dom.Document();
  
      try {
        intframework.AbstractIntegrationService baseintegrationService = intframework.IntegrationServiceFactory.getBaseIntegrationService();
        intframework.BaseIntegrationResponse responseObject;
        String apiType = 'SearchByABNNumberAPI';
        // Calling the adapter class, by speifying integraiton family and api type in the base integration service
        responseObject = (intframework.BaseIntegrationResponse) baseintegrationService.runSynchronousIntegrationService(
          'ABNSearchSMSF',
          apiType,
          new Map<String, Object>(),
          requestParamMap
        );

        // null check before fetching the body data
        if (responseObject == null || responseObject.getBody() == null) {
          parserObject.errMessage = 'Something went wrong';
          return JSON.serialize(parserObject);
        }
        doc.load(responseObject.getBody());
        // Changing the response format from String to Map
        Map<String, Object> responseMap = intframework.XmlToJson.parseDocumentToMap(doc);

        String json = System.JSON.serialize(responseMap);
        // Changing the response format from Map to SearchByABNNumberHelper class object
        SMSFSearchByABNNumberHelper parserObject = SMSFSearchByABNNumberHelper.parse(
          json
        );
        if(parserObject == null){
          parserObject = new SMSFSearchByABNNumberHelper();
          parserObject.errMessage = 'Something went wrong';
          return System.JSON.serialize(parserObject);
        }
        /* The following try-catch block handles if any exception happens while fetching
         matchingFundNames201908 null check */
        try {
          if (parserObject.superFundPayload.response.superannuationFund2015 == null) {
            parserObject.errMessage = 'Invalid ABN';
          }
        } catch (Exception ex) {
          parserObject.errMessage = 'Something went wrong';
        }
        /*
        Converting the SearchByABNNumberHelper class response object into JSON string format
        to be able to process it in skuid javascript snippet.
        */
        return System.JSON.serialize(parserObject);
        } 
        catch (Exception ex) {
            GenericUtility.insertLog('SMSFSearchByABNNumberCallout', ex);
            return null;
        }
    }
  }