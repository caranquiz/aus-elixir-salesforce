/******************************************
* Descrption :  This is the Adapter class for ABN_API. 
*               Responsible for creating the request body.
*               And also for handling the incomming response and converting it to List<Map<String,Object>> format.
*
* Developer : Soumik Sarkar
*************************************************/

global without sharing class ABNAdapter extends ints.AbstractMockAdapter{
    
    global ABNAdapter(){}
 
    //CREATEREQUEST OVERRRIDING METHOD 
    
    global override ints.HttpRequestObject createRequest(Map<String, Object> abnRequestMap, ints.IntegrationConfigurationDTO IntegrationConfiguration)
    {
        ints.HttpRequestObject httpReq = new ints.HttpRequestObject();
        try{
                if(abnRequestMap != NULL){
                    List<Map<String,Object>> employerInfo = (List<Map<String,Object>>)abnRequestMap.get(ConstantValues.CompanyInfo);                   
                    ABN_Values__c guidValue = ABN_Values__c.getOrgDefaults();
                    String store = String.valueOf(abnRequestMap.get(ConstantValues.abn_API_service))+'?searchString='+String.valueOf(employerInfo.get(0).get(ConstantValues.abn_API_companyABN))+'&includeHistoricalDetails='+String.valueOf(abnRequestMap.get(ConstantValues.abn_API_histdetails))+ '&authenticationGuid='+ guidValue.Guid__c;
                    httpReq.endpoint =IntegrationConfiguration.apiEndpoint+store;
                    httpReq.timeout = 60000 ;
                    httpReq.method = 'GET';
                    
                    //Additional parameters for TEst Mock
                    if(Test.isRunningTest()) {
                        httpReq.addHeaderParameter(ints.IntegrationConstants.HEADER_USE_MOCKER,'True');
                        httpReq.addHeaderParameter(ints.IntegrationConstants.HEADER_CONTROL_FIELD_VALUE,ConstantValues.abn_API_controlField);
                        httpReq.addHeaderParameter(ints.IntegrationConstants.HEADER_INTEGRATION_SERVICE,IntegrationConfiguration.integrationService);
                        httpReq.addHeaderParameter(ints.IntegrationConstants.HEADER_THIRD_PARTY,IntegrationConfiguration.name);
                        httpReq.addHeaderParameter(ints.IntegrationConstants.HEADER_API_NAME,IntegrationConfiguration.apiName);
                        httpReq.addHeaderParameter(ints.IntegrationConstants.HEADER_EXEC_PRIORITY,IntegrationConfiguration.executionPriority+'');
                    }
                    
                    httpReq.addHeaderParameter('Content-type','application/x-www-form-urlencoded');

                    
                }else{
                    throw new CustomException(ConstantValues.abnAPIemptyMap);
                }
        }catch(Exception ex){
             throw new CustomException(ConstantValues.genericResponseError+ex);          
        }
        return httpReq;
        
    }
    
    
    global override  ints.IntegrationResponseObject parseResponse(HttpResponse response, ints.ThirdPartyRequest thirdPartyRequest) {
        ints.IntegrationResponseObject res; 
        ABNResponseHelper abnParse = new ABNResponseHelper();
        try{      
            
            if(response.getStatusCode() != 200){
                throw new CustomException('Response Status: '+response.getStatusCode()+ '\n This indicates that we did not get the expected response from ABN API \n');
            }
             
            String resp = response.getBody();
            Dom.Document doc = new Dom.Document();
            doc.load(resp);
            abnParse.message = resp;
            abnParse.responseStore = ints.XmlToJson.parseDocumentToMap(doc);
            abnParse.body = ints.XmlToJson.parseDocumentToJson(doc);               
            
        }catch(Exception ex){
             throw new CustomException(ConstantValues.genericResponseError+ex);
        } 
        res = abnParse;
        return res;   
    }

}