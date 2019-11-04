/********************************************************************************
Description:    This class is used to form the GET URL paramater specific for ABN Name API
                Also contains as a response parsing method which converts the XML to JSON
Developer:      Deepro De
Created Date:   05/10/2018
*********************************************************************************/

global without sharing class ABNNameAdapter extends ints.AbstractMockAdapter{
    
    global ABNNameAdapter(){}
 
    //CREATEREQUEST OVERRRIDING METHOD 
    
    global override ints.HttpRequestObject createRequest(Map<String, Object> abnRequestMap, ints.IntegrationConfigurationDTO IntegrationConfiguration)
    {
        ints.HttpRequestObject httpReq = new ints.HttpRequestObject();
        try{
                if(abnRequestMap != NULL){
                    List<Map<String,Object>> companyNameInfo = (List<Map<String,Object>>)abnRequestMap.get(ConstantValues.partyInfo);                   
                    ABN_Values__c guidValue = ABN_Values__c.getOrgDefaults();
                    String store = String.valueOf(abnRequestMap.get(ConstantValues.abnAPIservice))+'?name='+ EncodingUtil.urlEncode(String.valueOf(companyNameInfo.get(0).get(ConstantValues.abnAPIcompanyABN)),'UTF-8')+'&postcode='+String.valueOf(abnRequestMap.get(ConstantValues.abnAPIpostcode))+'&legalName='+String.valueOf(abnRequestMap.get(ConstantValues.abnAPIlegalName))+'&tradingName='+String.valueOf(abnRequestMap.get(ConstantValues.abnAPItradingName))+'&businessName='+String.valueOf(abnRequestMap.get(ConstantValues.abnAPIbusinessName))+'&activeABNsOnly='+String.valueOf(abnRequestMap.get(ConstantValues.abnAPIactiveABNsOnly))+'&NSW='+String.valueOf(abnRequestMap.get(ConstantValues.abnAPINSW))+'&SA='+String.valueOf(abnRequestMap.get(ConstantValues.abnAPISA))+'&ACT='+String.valueOf(abnRequestMap.get(ConstantValues.abnAPIACT))+'&VIC='+String.valueOf(abnRequestMap.get(ConstantValues.abnAPIVIC))+'&WA='+String.valueOf(abnRequestMap.get(ConstantValues.abnAPIWA))+'&NT='+String.valueOf(abnRequestMap.get(ConstantValues.abnAPINT))+'&QLD='+String.valueOf(abnRequestMap.get(ConstantValues.abnAPIQLD))+'&TAS='+String.valueOf(abnRequestMap.get(ConstantValues.abnAPITAS))+'&authenticationGuid='+ guidValue.Guid__c +'&searchWidth='+String.valueOf(abnRequestMap.get(ConstantValues.abnAPIsearchWidth))+'&minimumScore='+String.valueOf(abnRequestMap.get(ConstantValues.abnAPIminimumScore))+'&maxSearchResults='+String.valueOf(abnRequestMap.get(ConstantValues.abnAPImaxSearchResults));
                    httpReq.endpoint =IntegrationConfiguration.apiEndpoint+store;
                    httpReq.timeout = 120000 ;
                    httpReq.method = 'GET';
                    
                    /************************Creating and assigning header values******************************/
                    
                    //Additional parameters for TEst Mock
                    if(Test.isRunningTest()) {
                        httpReq.addHeaderParameter(ints.IntegrationConstants.HEADER_USE_MOCKER,'True');
                        httpReq.addHeaderParameter(ints.IntegrationConstants.HEADER_CONTROL_FIELD_VALUE,ConstantValues.testString1);
                        httpReq.addHeaderParameter(ints.IntegrationConstants.HEADER_INTEGRATION_SERVICE,IntegrationConfiguration.integrationService);
                        httpReq.addHeaderParameter(ints.IntegrationConstants.HEADER_THIRD_PARTY,'');
                        httpReq.addHeaderParameter(ints.IntegrationConstants.HEADER_API_NAME,'');
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
            abnParse.responseStore = ints.XmlToJson.parseDocumentToMap(doc);
            abnParse.body = ints.XmlToJson.parseDocumentToJson(doc);               
            
        }catch(Exception e){
            throw new CustomException(ConstantValues.genericResponseError+e);
        } 
        res = abnParse;
        return res;   
    }

}