/******************************************
* Descrption : This is the callout class for ACN Integration. 
*              This class called the adapter class.
*              And also responsible for store the response of ACN.
*
* Developer : Deep Bhattacharjee
*************************************************/

global without sharing class ACNCallout{
    public static List<clcommon__Party__c> pList = new List<clcommon__Party__c>();

    global static String makeACNCallout(Id partyId){  
        Savepoint sp;
        try{
                         pList = [SELECT Id, 
                                          Name
                                          FROM clcommon__Party__c
                                          WHERE Id=:partyId];
             
            if(pList.isEmpty()){
               throw new CustomException(ConstantValues.partyNotFound);
            }                                
                                                                                                  
            Map<String,Object> partyMap = new Map<String,Object>();
            Map<String,Object> companyValues = new Map<String,Object>();
            partyMap.put('pId',pList.get(0).id); 
            companyValues.put('partyInfo',partyMap);
            companyValues.put('ExecutionPriority', 3);
            companyValues.put('actualAcn', '');
            //companyValues.put('partyId',partyId);
            
            ints.AbstractMockService   mc  = ints.APIFactory.getPassthroughService();
            ints.IntegrationResponseObject responseObject = mc.runPassthroughService(companyValues,'ID Verification','');
            ACN_Information__c acnObj = new ACN_Information__c();
            acnObj = ACNResponse.saveResponse(responseObject);
            acnObj.Party__c = pList[0].id;
            insert acnObj;  
            updateParentRecord(acnObj,pList[0].id);
            return ConstantValues.ACN_GENERATED;        
          }
       catch(Exception e){
            insert new clcommon__Log__c(
                        clcommon__Message__c = 'ACN_API :Exception:: '+e.getStackTraceString()+'error='+e.getMessage()+' at Line Number '+e.getLineNumber(),
                        clcommon__Time__c = System.Now());
            throw new CustomException(e.getMessage());
       }
     }

      global static void updateParentRecord(ACN_Information__c acnObj, String partyId){
        try{
            //CHECK IF NEWLY CREATED ABN INFORMATION OBJECT IS BLANK OR NOT
            if(acnObj == NULL){
                throw new CustomException(ConstantValues.acnInfoNotFound);
            }
           // if(pList.isEmpty() == false){
              //if(String.isNotBlank(pList.get(0).id)){  
                List<clcommon__Party__c> partyList = [SELECT Id, Name FROM clcommon__Party__c WHERE Id =: partyId LIMIT 1];
                if(partyList.isEmpty() == false){
                    //UPDATE ELEMENTS FROM ABN INFORMATION OBJ TO PARTY OBJ
                    partyList.get(0).Trustee_Name__c = String.isNotBlank(acnObj.Organisation_Name__c) ? acnObj.Organisation_Name__c : '';
                    partyList.get(0).Trustee_ABN_Status__c = String.isNotBlank(acnObj.Entity_status_code__c) ? acnObj.Entity_status_code__c : '';
                    partyList.get(0).Trustee_Record_Extract_date__c = String.isNotBlank(acnObj.DateTimeRetrieved__c) ? acnObj.DateTimeRetrieved__c : '';
                    partyList.get(0).Trustee_GST_Effective_From__c = String.isNotBlank(acnObj.GST_EffectiveFrom__c) ? acnObj.GST_EffectiveFrom__c : '';
                    partyList.get(0).Trustee_Entity_Description__c = String.isNotBlank(acnObj.Entity_description__c) ? acnObj.Entity_description__c : '';
                    partyList.get(0).Trustee_ABN__c = String.isNotBlank(acnObj.Identifier_value__c) ? acnObj.Identifier_value__c : '';
                    partyList.get(0).Trustee_ACN_Effective_From__c = String.isNotBlank(acnObj.Effective_From__c) ? acnObj.Effective_From__c : '';
                    UPDATE partyList.get(0); 
                }else{
                     throw new CustomException(Constantvalues.acnInfoError);   
                }
            //  }
           // }else{
            //     throw new CustomException(Constantvalues.acnInfoError);   
           // }
        }catch(Exception e){
            throw new CustomException(e.getMessage());
        }
      }

// This makeACNSkuidCallout(partyId) method used for ACN Callout from Skuid.

    Webservice static String makeACNSkuidCallout(Id partyId){
        Savepoint sp;

        try{
            
            makeACNCallout(partyId);
            return ConstantValues.msg;    
        }catch(Exception e){
            return e.getMessage();
        }
    }
    // This makeACNPortalCallout(acn) method used for ACN Callout from Portal.
    public static String makeACNPortalCallout(String acn){
        Savepoint sp;
        try{
            if(String.isBlank(acn)){
                throw new CustomException('ACN Not Found');
            }
            
            Map<String,Object> partyMap = new Map<String,Object>();
            Map<String,Object> companyValues = new Map<String,Object>();
            companyValues.put('ExecutionPriority', 3);
            companyValues.put('actualAcn', acn);
            
            ints.AbstractMockService   mc  = ints.APIFactory.getPassthroughService();
            ints.IntegrationResponseObject responseObject = mc.runPassthroughService(companyValues,'ID Verification','');
            System.debug('RESPONSE:-'+responseObject);
            ACN_Information__c acnObj = new ACN_Information__c();
            acnObj = ACNResponse.saveResponse(responseObject);
            insert acnObj; 
            return acnObj.Id;
        }catch(Exception e){
            insert new clcommon__Log__c(
                                        clcommon__Message__c = 'ACN_API :Exception:: '+e.getStackTraceString()+'error='+e.getMessage()+' at Line Number '+e.getLineNumber(),
                                        clcommon__Time__c = System.Now()
                                        );
            return ConstantValues.EXCEPTION_OCCURED;
        }

        
        
    }
        
        

}