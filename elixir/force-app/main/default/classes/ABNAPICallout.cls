/******************************************
* Descrption : This is the callout class for ABN Integration. 
*              This class called the adapter class.
*              And also responsible for store the response of ABN.
*
* Developer : Soumik Sarkar
*************************************************/

global class ABNAPICallout{
    
    public static List<ABN_Company_List__c> companyList = new List<ABN_Company_List__c>();
    public static List<ABN_Company_List__c> updatedCompanyList = new List<ABN_Company_List__c>();
    
    global static void makeABNCallout(Id companyListId){
        try{
            companyList = [SELECT Id,
                                  Name, 
                                  Selected_for_ABN_Search__c,
                                  ABN_Company_Information__r.Employment_Information__c,
                                  ABN_Company_Information__r.Party__c
                                  FROM ABN_Company_List__c
                                  WHERE Id=:companyListId];

            if(companyList.isEmpty() == true){
                throw new CustomException(ConstantValues.companyNotFound);
            }
            
            Map<String,Object> compInfo = new Map<String,Object>();
            Map<String,Object> companyMap = new Map<String,Object>();
            compInfo.put('abnCompanyId',companyList.get(0).id);
            companyMap.put('companyInfo',compInfo);
            companyMap.put('ExecutionPriority', 1);

            ints.AbstractMockService   mc  = ints.APIFactory.getPassthroughService();
            ints.IntegrationResponseObject responseObject = mc.runPassthroughService(companyMap,ConstantValues.serviceName,'');
            
            ABN_Information__c abnObj = new ABN_Information__c();
            abnObj = ABNResponse.saveResponse(responseObject);
            insert abnObj;
            updateParentRecord(abnObj);
            
            //return ConstantValues.ABN_GENERATED;
            
        }
        catch(Exception e){
            insert new clcommon__Log__c(
                        clcommon__Message__c = 'ABN_API :Exception:: '+e.getStackTraceString()+'error='+e.getMessage()+' at Line Number '+e.getLineNumber(),
                        clcommon__Time__c = System.Now());
            //return ConstantValues.EXCEPTION_OCCURED;
        }
        
    }
    
    //******* Update ABN values to Party Object & Employment Information Object. *******//

    private static void updateParentRecord(ABN_Information__c abnObj){
        try{
            //CHECK IF NEWLY CREATED ABN INFORMATION OBJECT IS BLANK OR NOT
            if(abnObj == NULL){
                throw new CustomException(ConstantValues.abnInfoException);
            }
            
            if(String.isNotBlank(companyList.get(0).ABN_Company_Information__r.Employment_Information__c) && String.isBlank(companyList.get(0).ABN_Company_Information__r.Party__c)){
                List<genesis__Employment_Information__c > empInfoList = [SELECT Id, Name FROM genesis__Employment_Information__c WHERE Id =:companyList.get(0).ABN_Company_Information__r.Employment_Information__c LIMIT 1];
                if(empInfoList.isEmpty() == false){
                    //UPDATE ELEMENTS FROM ABN INFORMATION OBJ TO EMPLOYMENT INFORMATION OBJ
                    empInfoList.get(0).Company_ABN__c = String.isNotBlank(abnObj.Identifier_value__c) ? abnObj.Identifier_value__c : '';
                    empInfoList.get(0).Company_ACN__c = String.isNotBlank(abnObj.ASICNumber__c) ? abnObj.ASICNumber__c : '';
                    empInfoList.get(0).Record_Extract_Date__c = String.isNotBlank(abnObj.DateTimeRetrieved__c) ? abnObj.DateTimeRetrieved__c : '';
                    empInfoList.get(0).Entity_Type__c = String.isNotBlank(abnObj.Entity_description__c) ? abnObj.Entity_description__c : '';
                    empInfoList.get(0).ABN_Status__c = String.isNotBlank(abnObj.Entity_status_code__c) ? abnObj.Entity_status_code__c : '';
                    empInfoList.get(0).Goods_Services_Tax__c = String.isNotBlank(abnObj.GST_EffectiveFrom__c) ? abnObj.GST_EffectiveFrom__c : 'Not currently registered for GST';
                    empInfoList.get(0).ABN_Effective_From__c = String.isNotBlank(abnObj.Effective_From__c) ? abnObj.Effective_From__c : '';
                    UPDATE empInfoList.get(0);
                    deleteUnwantedCompanyRecords(companyList.get(0).id);
                    
                }
            }else if(String.isNotBlank(companyList.get(0).ABN_Company_Information__r.Party__c) && String.isBlank(companyList.get(0).ABN_Company_Information__r.Employment_Information__c)){
                List<clcommon__Party__c> partyList = [SELECT Id, Name FROM clcommon__Party__c WHERE Id =: companyList.get(0).ABN_Company_Information__r.Party__c LIMIT 1];
                if(partyList.isEmpty() == false){
                    //UPDATE ELEMENTS FROM ABN INFORMATION OBJ TO PARTY OBJ
                    partyList.get(0).Company_ACN__c = String.isNotBlank(abnObj.ASICNumber__c) ? abnObj.ASICNumber__c : '';
                    partyList.get(0).Company_ABN_Status__c = String.isNotBlank(abnObj.Entity_status_code__c) ? abnObj.Entity_status_code__c : '';
                    partyList.get(0).Record_Extract_Date__c = String.isNotBlank(abnObj.DateTimeRetrieved__c) ? abnObj.DateTimeRetrieved__c : '';
                    partyList.get(0).Goods_Services_Tax__c = String.isNotBlank(abnObj.GST_EffectiveFrom__c) ? abnObj.GST_EffectiveFrom__c : 'Not currently registered for GST';
                    partyList.get(0).Entity_Type__c = String.isNotBlank(abnObj.Entity_description__c) ? abnObj.Entity_description__c : '';
                    partyList.get(0).Company_ABN__c = String.isNotBlank(abnObj.Identifier_value__c) ? abnObj.Identifier_value__c : '';
                    partyList.get(0).ABN_Effective_From__c = String.isNotBlank(abnObj.Effective_From__c) ? abnObj.Effective_From__c : '';
                    UPDATE partyList.get(0); 
                    deleteUnwantedCompanyRecords(companyList.get(0).id);                   
                    
                }
            }else if(String.isNotBlank(companyList.get(0).ABN_Company_Information__r.Party__c) && String.isNotBlank(companyList.get(0).ABN_Company_Information__r.Employment_Information__c)){
                throw new CustomException(ConstantValues.lookupConflict);
            }else{
                 throw new CustomException(ConstantValues.parentRecordLookupException);   
            }
        }catch(Exception e){
            throw new CustomException(e.getMessage());
        }
        
        
    }
    
    // ***** Delete Unwanted Company Record from ABN Company Search ******//
    
    private static void deleteUnwantedCompanyRecords(Id companyListId){
        updatedCompanyList = [SELECT Id, 
                                     Name, 
                                     Selected_for_ABN_Search__c 
                                     FROM  ABN_Company_List__c 
                                     WHERE Id !=: companyListId
                                     AND Selected_for_ABN_Search__c = false];
        
        companyList.get(0).Selected_for_ABN_Search__c = true;
        UPDATE companyList.get(0);        
        DELETE updatedCompanyList;
        
        
    }
    
    // Webservice method for calling this ABNAPICallout class &  makeABNCallout() method for ABN COmpany Search Integration. ******//

    Webservice static String makeABNCompanySkuidCallout(Id companyId){
        try{
            makeABNCallout(companyId);
            return ConstantValues.msg;    
        }catch(Exception e){
            throw new CustomException(e.getMessage());
        }
    }
    
}