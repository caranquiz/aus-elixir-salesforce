/******************************************
* Descrption :  This is the Adapter class for ACN_API. 
*               Responsible for creating the request body.
*               And also for handling the incomming response and converting it to List<Map<String,Object>> format.
*
* Developer : Deep Bhattacharjee
*************************************************/

global without sharing class ACNAdapter extends ints.AbstractMockAdapter{
    
    global ACNAdapter(){}
 
    //CREATEREQUEST OVERRRIDING METHOD 
    
    global override ints.HttpRequestObject createRequest(Map<String, Object> acnRequestMap, ints.IntegrationConfigurationDTO IntegrationConfiguration)
    {
        ints.HttpRequestObject httpReq = new ints.HttpRequestObject();
        try{
                if(acnRequestMap != NULL){
                    List<Map<String,Object>> partyMap = (List<Map<String,Object>>)acnRequestMap.get('partyInfo');
                    ABN_Values__c guidValue = ABN_Values__c.getOrgDefaults();
                    String store = String.valueOf(acnRequestMap.get(ConstantValues.acn_API_service)) + '?searchString=' + String.valueOf(partyMap.get(0).get(ConstantValues.acn_API_companyACN)) + '&includeHistoricalDetails=' + String.valueOf(acnRequestMap.get(ConstantValues.acn_API_histdetails)) + '&authenticationGuid='+ guidValue.Guid__c;
                    httpReq.endpoint =IntegrationConfiguration.apiEndpoint+store;
                    httpReq.timeout = 60000 ;
                    httpReq.method = 'GET';

                    //Additional parameters for TEst Mock
                    if(Test.isRunningTest()) {
                        httpReq.addHeaderParameter(ints.IntegrationConstants.HEADER_USE_MOCKER,'True');
                        httpReq.addHeaderParameter(ints.IntegrationConstants.HEADER_CONTROL_FIELD_VALUE,ConstantValues.acn_API_controlField);
                        httpReq.addHeaderParameter(ints.IntegrationConstants.HEADER_INTEGRATION_SERVICE,IntegrationConfiguration.integrationService);
                        httpReq.addHeaderParameter(ints.IntegrationConstants.HEADER_THIRD_PARTY,IntegrationConfiguration.name);
                        httpReq.addHeaderParameter(ints.IntegrationConstants.HEADER_API_NAME,IntegrationConfiguration.apiName);
                        httpReq.addHeaderParameter(ints.IntegrationConstants.HEADER_EXEC_PRIORITY,IntegrationConfiguration.executionPriority+'');
                    }
                    httpReq.addHeaderParameter('Content-type','application/x-www-form-urlencoded');
                    
                    /************************Creating and assigning header values******************************/                    
                    //Map<String,String> headerMap = new Map<String,String>();
                    //headerMap.put('Content-type','application/x-www-form-urlencoded'); 
                    //httpReq.headerMap = (headerMap);
                    
                 }else{
                    throw new CustomException(ConstantValues.acnAPIemptyMap);
            }
        }catch(Exception ex){
           throw new CustomException(ConstantValues.genericResponseError+ex);
        }
        return httpReq;
        
    }
    
    global override  ints.IntegrationResponseObject parseResponse(HttpResponse response, ints.ThirdPartyRequest thirdPartyRequest) {
        ints.IntegrationResponseObject res; 
        ABNResponseHelper acnParse = new ABNResponseHelper();
        try{      
            
            if(response.getStatusCode() != 200){
                throw new CustomException('Response Status: '+response.getStatusCode()+ '\n'+ ConstantValues.acnInfoError +  '\n');
            }
             
            String resp = response.getBody();
            Dom.Document doc = new Dom.Document();
            doc.load(resp);
            acnParse.responseStore = ints.XmlToJson.parseDocumentToMap(doc);
            acnParse.body = ints.XmlToJson.parseDocumentToJson(doc);               
            ACNRespHelper acnResp = new ACNRespHelper();
            acnResp = (ACNRespHelper)JSON.deserialize(acnParse.body, ACNRespHelper.class);
           
            
        }catch(Exception e){
            throw new ints.IntegrationException(e.getMessage());
        } 
        res = acnParse;
        return res;   
    }
}