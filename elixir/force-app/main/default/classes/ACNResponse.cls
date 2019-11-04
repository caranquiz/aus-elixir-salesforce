global without sharing class ACNResponse{
    global static ACN_Information__c saveResponse(ints.IntegrationResponseObject responseObject){
     
     try{
        ACNRespHelper respHelper = new ACNRespHelper();
        respHelper = (ACNRespHelper)JSON.deserialize(responseObject.body,ACNRespHelper.class);
      
        
        ACN_Information__c acnObj = new ACN_Information__c();
        if(respHelper!=NULL){
            if(respHelper.response!=NULL){
                acnObj.DateTimeRetrieved__c = respHelper.response.dateTimeRetrieved;
                if(respHelper.response.businessEntity201408.ABN !=NULL){
                    acnObj.Identifier_value__c = String.valueOf(respHelper.response.businessEntity201408.ABN.identifierValue);
                }
                if(respHelper.response.businessEntity201408.entityStatus !=NULL){
                    acnObj.Entity_status_code__c = respHelper.response.businessEntity201408.entityStatus.entityStatusCode;
                    acnObj.Effective_From__c     = respHelper.response.businessEntity201408.entityStatus.effectiveFrom;
                }
                if(respHelper.response.businessEntity201408 !=NULL){
                    acnObj.ASICNumber__c= String.valueOf(respHelper.response.businessEntity201408.ASICNumber);
                }
                if(respHelper.response.businessEntity201408.entityType !=null){
                    acnObj.Entity_description__c = respHelper.response.businessEntity201408.entityType.entityDescription;
                }
                if(respHelper.response.businessEntity201408.goodsAndServicesTax !=null){
                    acnObj.GST_EffectiveFrom__c = respHelper.response.businessEntity201408.goodsAndServicesTax.effectiveFrom;
                }
                if(respHelper.response.businessEntity201408.mainName!=null){
                    acnObj.Organisation_Name__c = respHelper.response.businessEntity201408.mainName.organisationName;
                }
            }
        }
        return acnObj;
    }catch(Exception ex){
        throw new CustomException(ConstantValues.acnResponseError+ex); 
    } 
     }
 }