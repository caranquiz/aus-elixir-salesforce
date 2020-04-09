/********************************************************************************
Description:    This class is used to invoke the ABN Name API According to the 
                typeIndicator Value. This class also houses the Webservice method 
                which is used by the Skuid button to trigger the integration
Developer:      Deepro De
Created Date:   05/10/2018
*********************************************************************************/

global without sharing class ABNNameCallout{

        
    //MAIN CALLOUT METHOD
        global static String makeABNNameCallout(Id sfId, String typeIndicator){           
            String entityName = '',resp = '';
            try{
                if(String.isNotBlank(typeIndicator) == false){
                    throw new CustomException(ConstantValues.exceptionNoType);
                }else if(String.isNotBlank(typeIndicator) && typeIndicator.equalsIgnoreCase('P')){
    
                    //PROCESSINGS FROM PARTIES
                    String party;
                    List<clcommon__Party__c> pList = [SELECT Id, 
                                                         Name,
                                                         Flag_Party__c
                                                         FROM clcommon__Party__c
                                                         WHERE Id=:sfId];
                    if(pList.isEmpty()){
                        throw new CustomException(ConstantValues.partyNotFound);
                    }
                    party = sfId;
                    entityName = pList.get(0).Name;
                    Map<String,Object> empInfo = new Map<String,Object>();
                    Map<String,Object> companyMap = new Map<String,Object>();
                    empInfo.put('partyId',pList.get(0).id);
                    companyMap.put('partyInfo',empInfo);
                    companyMap.put('ExecutionPriority', Integer.valueof(System.label.Execution_Priority_for_ABN_from_Parties.trim()));
            
                    ints.IntegrationResponseObject responseObject = invokeCLIntegrationAPI(companyMap, 'ID Verification');
                                        
                    //PARSING RESPONSE AND INSERTING RECORDS
                    ABNNameResponse.ABNNameWrapperPopulate(responseObject);
                    resp = ABNNameResponse.createRecords(party,typeIndicator);
                    
                    //EXTRA DML FOR CUSTOM SKUID LOGIC
                    pList.get(0).Flag_Party__c = true;
                    UPDATE pList;
                    
                }else if(String.isNotBlank(typeIndicator) && typeIndicator.equalsIgnoreCase('E')){
                    
                    //PROCESSING FROM EMPLOYMENT INFORMATION
                    List<genesis__Employment_Information__c> empList = [SELECT Id, 
                                                        Name,
                                                        Flag_Emp__c
                                                        FROM genesis__Employment_Information__c
                                                                WHERE Id=:sfId];
                    if(empList.isEmpty()){
                        throw new CustomException(ConstantValues.employeeNotFound);
                    }
                    String emp = sfId;
                    entityName = empList.get(0).Name;
                    Map<String,Object> empInfo = new Map<String,Object>();
                    Map<String,Object> companyMap = new Map<String,Object>();
                    empInfo.put('empId',empList.get(0).id);
                    companyMap.put('partyInfo',empInfo);
                    companyMap.put('ExecutionPriority', Integer.valueof(System.label.Execution_Priority_for_ABN_from_Employment_Information.trim()));
    
                    ints.IntegrationResponseObject responseObject = invokeCLIntegrationAPI(companyMap, 'ID Verification');
    
                    
                    //PARSING RESPONSE AND INSERTING RECORDS
                    ABNNameResponse.ABNNameWrapperPopulate(responseObject);
                    resp = ABNNameResponse.createRecords(emp,typeIndicator);    
                    
                    
                    //EXTRA DML FOR CUSTOM SKUID LOGIC
                    empList.get(0).Flag_Emp__c = true;
                    UPDATE empList;
                                     
                }else{
                    throw new CustomException(ConstantValues.genericExceptionmsg);
                }
                                
               return resp;         
            }catch(Exception e){
                ExceptionUtilClass.createExceptionLog(e, entityName);                
                throw new CustomException(ConstantValues.genericException2+e);
            }
        
        }
        
        //METHOD TO INVOKE CLS INTEGRATION FRAMEWORK API
        global static ints.IntegrationResponseObject invokeCLIntegrationAPI(Map<String,Object> params, String serviceName){

            try{
                ints.AbstractMockService   mc  = ints.APIFactory.getPassthroughService();
                ints.IntegrationResponseObject responseObject = mc.runPassthroughService(params,serviceName,'');
                return responseObject;
            }catch(Exception e){
                throw e;
            }

        }
        
        
        //ADDED LOGIC FOR SAVING RESPONSE AS ATTACHMENT
        global static void createAttachment(String name, String body, String sfId){
            Attachment attachmentInstance = new Attachment();
            attachmentInstance.Body = Blob.valueOf(body);
            attachmentInstance.Name = name; 
            attachmentInstance.ParentID = sfId;
            attachmentInstance.ContentType = 'text/xml';
            INSERT attachmentInstance;
        }                
            
             
        
    //WEBSERVICE METHOD FOR SKUID BUTTON
        Webservice static String makeABNSkuidCallout(String sfId, String typeIndicator){
            try{
                //MAKE API CALL
                String resp = makeABNNameCallout(sfId, typeIndicator); 
                if(resp == System.label.ABN_Search_results_error_message){
                    return resp;
                }
                else {
                    return ConstantValues.msg; 
                }  
            }catch(Exception e){
                return e.getMessage();    
            }
        }
        //WEBSERVICE METHOD FOR DELETION THROUGH SKUID BUTTON
        Webservice static String deleteCompanyList(String sfId, String typeIndicator){
            List <ABN_Company_List__c> existantCompanyList;
            try{
                if(String.isNotBlank(typeIndicator) && typeIndicator.equalsIgnoreCase('P')){
                    existantCompanyList = [select id,ABN_Company_Information__r.Party__c from ABN_Company_List__c where ABN_Company_Information__r.Party__c =: sfId];
                }
                else if(String.isNotBlank(typeIndicator) && typeIndicator.equalsIgnoreCase('E')){
                    existantCompanyList = [select id,ABN_Company_Information__r.Employment_Information__r.Party__c from ABN_Company_List__c where ABN_Company_Information__r.Employment_Information__r.Party__c =: sfId];
                }
                if(existantCompanyList != null && existantCompanyList.size() > 0){
                    delete existantCompanyList;
                }
                return ConstantValues.msg; 
            }
            catch(Exception e){
                return e.getMessage();    
            }
        }
    }