/******************************************
 * Descrption : This class is used to take the response POJO and creates records accordingly to ABN Integration response. 
 *              This class is called from ABNAPICallout 
 *              And also responsible for store the response of ABN.
 *
 * Developer : Soumik Sarkar
 *************************************************/

public without sharing class ABNResponse {
 public static ABN_Information__c saveResponse(ints.IntegrationResponseObject responseObject) {
  try {
   String betOne = '';
   if (responseObject.body != null && (responseObject.body).contains('"mainName"') == true) {
    if ((responseObject.body.subStringBetween('"mainName":', '"')).equals('[{') == false) {
     String tempBody = responseObject.body;
     String partialBody = (tempBody).subStringBetween('"mainName":', '},"');
     partialBody = '[' + partialBody + ']';
     tempBody = tempBody.replace(tempBody.subStringBetween('"mainName":', '},"'), partialBody);
     tempBody = tempBody.replace(']},"', '}],"');
     responseObject.body = tempBody;
    }
   }
   ABN_Information__c abnObj = new ABN_Information__c();
   betOne = (responseObject.body).subStringBetween('"ABN":', '{"');
   if (betOne == '[') {
    ABNResponseParserListClass respParse = ABNResponseParserListClass.parse(responseObject.body);
    if (respParse != null) {
     if (respParse.response != null) {
      abnObj = populateInstance(abnObj, respParse);
      if (respParse.response.businessEntity != null && respParse.response.businessEntity.ABN != null && respParse.response.businessEntity.ABN.size() != 0) {
       abnObj.Identifier_value__c = String.valueOf(respParse.response.businessEntity.ABN.get(0).identifierValue);
      }

     }
    }
   } else {
    ABNResponseParser respParse1 = new ABNResponseParser();
    respParse1 = (ABNResponseParser) JSON.deserialize(responseObject.body, ABNResponseParser.class);
    if (respParse1 != null) {
     if (respParse1.response != null) {
      abnObj = populateInstance2(abnObj, respParse1);
      if (respParse1.response.businessEntity != null && respParse1.response.businessEntity.ABN != null) {
       abnObj.Identifier_value__c = String.valueOf(respParse1.response.businessEntity.ABN.identifierValue);
      }

     }
    }
   }
   return abnObj;
  } catch (Exception ex) {
   throw new CustomException(ConstantValues.abnResponseError + ex);
  }
 }

 public static ABN_Information__c populateInstance(ABN_Information__c abnObj, ABNResponseParserListClass respParse) {
  abnObj.DateTimeRetrieved__c = respParse.response.dateTimeRetrieved;
  if (respParse.response.businessEntity != null) {
   abnObj.ASICNumber__c = String.valueOf(respParse.response.businessEntity.ASICNumber);
  }
  if (respParse.response.businessEntity != null) {
   if (respParse.response.businessEntity.mainName != null && respParse.response.businessEntity.mainName.isEmpty() == false) {
    if (respParse.response.businessEntity.mainName.size() == 1) {
     abnObj.Organisation_Name__c = respParse.response.businessEntity.mainName.get(0).organisationName;
    } else {
     Integer flag = 0;
     for (ABNResponseParserListClass.MainTradingName eachMainNameObj: respParse.response.businessEntity.mainName) {
      if (String.isBlank(eachMainNameObj.effectiveTo)) {
       flag = 1;
       abnObj.Organisation_Name__c = String.isNotBlank(eachMainNameObj.organisationName) ? eachMainNameObj.organisationName : '';
      }
     }
     if (flag == 0) {
      throw new CustomException(ConstantValues.OrganizationNameNotfound);
     }
    }
   } else if (respParse.response.businessEntity.legalName != null && respParse.response.businessEntity.mainName == null) {
    abnObj.Organisation_Name__c = (String.isNotBlank(respParse.response.businessEntity.legalName.familyName) ? respParse.response.businessEntity.legalName.familyName : '') + ', ' + (String.isNotBlank(respParse.response.businessEntity.legalName.givenName) ? respParse.response.businessEntity.legalName.givenName : '') + ' ' + (String.isNotBlank(respParse.response.businessEntity.legalName.otherGivenName) ? respParse.response.businessEntity.legalName.otherGivenName : '');

   }
  }
  if (respParse.response.businessEntity.entityStatus != null) {
   abnObj.Entity_status_code__c = respParse.response.businessEntity.entityStatus.entityStatusCode;
   abnObj.Effective_From__c = respParse.response.businessEntity.entityStatus.effectiveFrom;
  }
  if (respParse.response.businessEntity.entityType != null) {
   abnObj.Entity_description__c = respParse.response.businessEntity.entityType.entityDescription;
  }
  if (respParse.response.businessEntity.GoodsAndServicesTax != null) {
   abnObj.GST_EffectiveFrom__c = respParse.response.businessEntity.GoodsAndServicesTax.effectiveFrom;
  }
  return abnObj;
 }
 public static ABN_Information__c populateInstance2(ABN_Information__c abnObj, ABNResponseParser respParse) {
  abnObj.DateTimeRetrieved__c = respParse.response.dateTimeRetrieved;
  if (respParse.response.businessEntity != null) {
   abnObj.ASICNumber__c = String.valueOf(respParse.response.businessEntity.ASICNumber);
  }
  if (respParse.response.businessEntity != null) {
   if (respParse.response.businessEntity.mainName != null && respParse.response.businessEntity.mainName.isEmpty() == false) {
    if (respParse.response.businessEntity.mainName.size() == 1 && respParse.response.businessEntity.mainName != null) {
     abnObj.Organisation_Name__c = respParse.response.businessEntity.mainName.get(0).organisationName;
    } else {
     Integer flag = 0;
     for (ABNResponseParser.MainName eachMainNameObj: respParse.response.businessEntity.mainName) {
      if (String.isBlank(eachMainNameObj.effectiveTo)) {
       flag = 1;
       abnObj.Organisation_Name__c = String.isNotBlank(eachMainNameObj.organisationName) ? eachMainNameObj.organisationName : '';
      }
     }
     if (flag == 0) {
      throw new CustomException(ConstantValues.OrganizationNameNotfound);
     }
    }
   } else if (respParse.response.businessEntity.legalName != null && respParse.response.businessEntity.mainName == null) {
    abnObj.Organisation_Name__c = (String.isNotBlank(respParse.response.businessEntity.legalName.familyName) ? respParse.response.businessEntity.legalName.familyName : '') + ', ' + (String.isNotBlank(respParse.response.businessEntity.legalName.givenName) ? respParse.response.businessEntity.legalName.givenName : '') + ' ' + (String.isNotBlank(respParse.response.businessEntity.legalName.otherGivenName) ? respParse.response.businessEntity.legalName.otherGivenName : '');
   }
  }
  if (respParse.response.businessEntity.entityStatus != null) {
   abnObj.Entity_status_code__c = respParse.response.businessEntity.entityStatus.entityStatusCode;
   abnObj.Effective_From__c = respParse.response.businessEntity.entityStatus.effectiveFrom;
  }
  if (respParse.response.businessEntity.entityType != null) {
   abnObj.Entity_description__c = respParse.response.businessEntity.entityType.entityDescription;
  }
  if (respParse.response.businessEntity.GoodsAndServicesTax != null) {
   abnObj.GST_EffectiveFrom__c = respParse.response.businessEntity.GoodsAndServicesTax.effectiveFrom;
  }
  return abnObj;
 }
}