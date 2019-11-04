global without sharing class ABNResponse{
    global static ABN_Information__c saveResponse (ints.IntegrationResponseObject responseObject){
        try{
            if((responseObject.body).contains('"mainName"') == true){
                if((responseObject.body.subStringBetween('"mainName":','"')).equals('[{') == false ){
                    String tempBody = responseObject.body;
                    String partialBody = (tempBody).subStringBetween('"mainName":','},"');
                    partialBody = '[' + partialBody + ']';
                    tempBody = tempBody.replace(tempBody.subStringBetween('"mainName":','},"'), partialBody);
                    tempBody = tempBody.replace(']},"','}],"');
                    responseObject.body = tempBody;
                                  
                }
            }
            ABNResponseParser respParse = new ABNResponseParser();
            respParse = (ABNResponseParser)JSON.deserialize(responseObject.body, ABNResponseParser.class);
            
          //  String orgName = respParse.response.businessEntity.mainName.organisationName;
            //String effecForm = respParse.response.businessEntity.mainName.effectiveForm;
            ABN_Information__c abnObj = new ABN_Information__c();
            if(respParse!=null){           
                if(respParse.response!=null){
                    abnObj.DateTimeRetrieved__c = respParse.response.dateTimeRetrieved;
                    if(respParse.response.businessEntity != null){
                        abnObj.ASICNumber__c = String.valueOf(respParse.response.businessEntity.ASICNumber);
                    }                   
                    if(respParse.response.businessEntity.mainName !=null && respParse.response.businessEntity.mainName.isEmpty() == false){
                        if(respParse.response.businessEntity.mainName.size() == 1){
                            abnObj.Organisation_Name__c = respParse.response.businessEntity.mainName.get(0).organisationName;
                        }else{
                            Integer flag = 0;
                            for(ABNResponseParser.MainName eachMainNameObj : respParse.response.businessEntity.mainName){
                                if (String.isBlank(eachMainNameObj.effectiveTo)){
                                    flag = 1;
                                    abnObj.Organisation_Name__c = String.isNotBlank(eachMainNameObj.organisationName) ? eachMainNameObj.organisationName : '';
                                }
                            }
                            if(flag == 0){
                                throw new CustomException(ConstantValues.OrganizationNameNotfound);
                            }
                        }
                    }
                    if(respParse.response.businessEntity.ABN !=null){
                        abnObj.Identifier_value__c = String.valueOf(respParse.response.businessEntity.ABN.identifierValue);
                    }
                    if(respParse.response.businessEntity.entityStatus !=null){
                        abnObj.Entity_status_code__c = respParse.response.businessEntity.entityStatus.entityStatusCode;
                        abnObj.Effective_From__c = respParse.response.businessEntity.entityStatus.effectiveFrom;
                    } 
                    if(respParse.response.businessEntity.entityType !=null){
                        abnObj.Entity_description__c = respParse.response.businessEntity.entityType.entityDescription;
                    }
                    if(respParse.response.businessEntity.GoodsAndServicesTax !=null){
                        abnObj.GST_EffectiveFrom__c = respParse.response.businessEntity.GoodsAndServicesTax.effectiveFrom;
                    }
                }
    
            }
                    
                return abnObj;
        }catch(Exception ex){
            throw new CustomException(ConstantValues.abnResponseError+ex);
        } 
    }
}