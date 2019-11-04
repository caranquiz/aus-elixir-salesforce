/********************************************************************************
Description:    This class is used to invoke the ABN Name API According to the 
                typeIndicator Value. This class also houses the Webservice method 
                which is used by the Skuid button to trigger the integration
Developer:      Deepro De
Created Date:   05/10/2018
*********************************************************************************/

global class ABNNameCallout{
        
    //MAIN CALLOUT METHOD
        global static void makeABNNameCallout(Id sfId, String typeIndicator){           
            String entityName = '';
            try{
                    if(String.isNotBlank(typeIndicator) == false){
                        throw new CustomException(ConstantValues.exceptionNoType);
                    }else if(String.isNotBlank(typeIndicator) && typeIndicator.equalsIgnoreCase('P')){
    
                //PROCESSINGS FROM PARTIES
                    
                    String party;
                    List< clcommon__Party__c> empList = [SELECT Id, 
                                                         Name
                                                         FROM clcommon__Party__c
                                                         WHERE Id=:sfId];
                    if(empList.isEmpty()){
                        throw new CustomException(ConstantValues.partyNotFound);
                    }
    
                    party = sfId;
                    entityName = empList.get(0).Name;
                    Map<String,Object> empInfo = new Map<String,Object>();
                    Map<String,Object> companyMap = new Map<String,Object>();
                    empInfo.put('partyId',empList.get(0).id);
                    companyMap.put('partyInfo',empInfo);
                    companyMap.put('ExecutionPriority', 2);
            
                    ints.IntegrationResponseObject responseObject = invokeCLIntegrationAPI(companyMap, 'ID Verification');
                    
                //PARSING RESPONSE AND INSERTING RECORDS
                    ABNNameResponse.ABNNameWrapperPopulate(responseObject);
                    ABNNameResponse.createRecords(party,typeIndicator);
    
    
                }else if(String.isNotBlank(typeIndicator) && typeIndicator.equalsIgnoreCase('E')){
                    
                //PROCESSING FROM EMPLOYMENT INFORMATION
    
                    List<genesis__Employment_Information__c> empList = [SELECT Id, 
                                                        Name
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
                    companyMap.put('ExecutionPriority', 5);
    
                    ints.IntegrationResponseObject responseObject = invokeCLIntegrationAPI(companyMap, 'ID Verification');
    
                    
                //PARSING RESPONSE AND INSERTING RECORDS
                    ABNNameResponse.ABNNameWrapperPopulate(responseObject);
                    ABNNameResponse.createRecords(emp,typeIndicator);    
                }else{
                    throw new CustomException(ConstantValues.genericExceptionmsg);
                }
                        
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

              
        
    //WEBSERVICE METHOD FOR SKUID BUTTON
        Webservice static String makeABNSkuidCallout(String sfId, String typeIndicator){
            try{
                //MAKE API CALL
                makeABNNameCallout(sfId, typeIndicator); 
                return ConstantValues.msg;   
            }catch(Exception e){
                return e.getMessage();    
            }
        }
    
    }