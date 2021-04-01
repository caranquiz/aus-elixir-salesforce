/********************************************************************************
Description:    This class is used to take the response POJO and creates records accordingly
Developer:      Deepro De
Created Date:   05/10/2018
*********************************************************************************/

public without sharing class ABNNameResponse{
    
    //DEFINING LOCAL VARIABLES NEEDED IN API
        private static List<String> organizationNameList = new List<String>();
        private static List<String> isCurrentIndi = new List<String>();
        private static List<String> stateCodeList = new List<String>();
        private static List<String> postCodeList = new List<String>();
        private static List<String> mainNameCurrentIndi = new List<String>();
        private static List<String> scoreList = new List<String>();
        private static List<String> identifierStatusList = new List<String>();
        private static List<String> abnIdentifierStatList = new List<String>();
        private static List<String> abnIdentifierValList = new List<String>();
        private static List<String> dateTimeRetreivedList = new List<String>();
        private static List<String> dateRegisterList = new List<String>();
        private static List<String> usageStatementList = new List<String>();
        private static List<String> tradingNameIndicatorList = new List<String>();
        private static List<String> businessNameIndicatorList = new List<String>();
        private static List<String> tradingNameScoreList = new List<String>();
        private static List<String> businessScoreList = new List<String>();
        private static List<String> tradingOrgNameList = new List<String>();
        private static List<String> businessOrgNameList = new List<String>();
        private static List<String> otherTradingNameList = new List<String>();
        private static List<String> otherTradingIndicatorList = new List<String>();
        private static List<String> otherTradingScoreList = new List<String>();
        private static List<String> asicList = new List<String>();
        private static List<String> gstEffectiveFromList = new List<String>();
        private static List<String> entityStatusCodeList = new List<String>();
        private static List<String> entityEffectiveFromList = new List<String>();
        private static List<String> entityDescList = new List<String>(); 
        private static List<String> legalNameList = new List<String>();
        private static List<String> legalCurrentIndicator = new List<String>();
        private static List<String> legalScoreList = new List<String>();
        public static String party;
        public static String partyName;
        private static String UNIQUE_BLANK_INDICATOR = ConstantValues.uniqueBlank;
        private static Integer sizeOfList;


        
        //LOCAL VARIABLE POPULATING METHOD
        public static void ABNNameWrapperPopulate(ints.IntegrationResponseObject responseObject){
            try{
                if(responseObject == NULL){
                    //throw EXCEPTION
                    throw new CustomException(ConstantValues.responseParsingException);
                }else{
                    //DESERIALIZING RESPONSE INTO POJO CLASS
                    ABNNameResponseParser responsePojo = new ABNNameResponseParser();
                    
                    //Lines Added by Rameswari on 11/01/2020 to facilitate proper parsing of response when single result is returned
                    String responseBody = responseObject.body;
                    if(responseBody.contains('"searchResultsRecord":{"mainBusinessPhysicalAddress')){
                        responseBody = responseBody.replace('"searchResultsRecord":{"mainBusinessPhysicalAddress','"searchResultsRecord":[{"mainBusinessPhysicalAddress');
                        if(responseBody.contains('}},"exceedsMaximum"')){
                            responseBody = responseBody.replace('}},"exceedsMaximum"','}}],"exceedsMaximum"');
                        }
                    }
                    responsePojo = (ABNNameResponseParser)JSON.deserialize(responseBody, ABNNameResponseParser.class);   
                    //CHECK IF ROOT IS EMPTY OR NOT            
                    if(responsePojo.response == NULL){
                        //THROW EXCEPTION AS ROOT CONTAINS NO INFORMATION
                        throw new CustomException(ConstantValues.responseParsingException);
                    }else{
                        //CHECK IF 2nd LEVEL IS EMPTY OR NOT
                        if(responsePojo.response.searchResultsList != NULL){
                            //CHECK TO SEE IF THE LIST EXISTS AND SIZE > 1
                            if(responsePojo.response.searchResultsList.searchResultsRecord != NULL && (responsePojo.response.searchResultsList.searchResultsRecord).isEmpty() == false){
                                //TRAVERSING THROUGH EACH ELEMENT OF LIST
                                sizeOfList = (responsePojo.response.searchResultsList.searchResultsRecord).size();
                                List<ABNNameResponseParser.SearchResultsRecord> searchList = new List<ABNNameResponseParser.SearchResultsRecord>();
                                searchList = responsePojo.response.searchResultsList.searchResultsRecord;
                                for(ABNNameResponseParser.SearchResultsRecord eachElement : searchList){
                                    
                                    //CHECKING INSIDE MAIN BUSINESS PHYSICAL ADDRESS NODE
                                    if(eachElement.mainBusinessPhysicalAddress != NULL){
                                        if(String.isNotBlank(String.valueOf(eachElement.mainBusinessPhysicalAddress.isCurrentIndicator))){
                                            isCurrentIndi.add(String.valueOf(eachElement.mainBusinessPhysicalAddress.isCurrentIndicator));
                                        }else{
                                            isCurrentIndi.add(UNIQUE_BLANK_INDICATOR);
                                        }
                                        
                                        if(String.isNotBlank(String.valueOf(eachElement.mainBusinessPhysicalAddress.postcode))){
                                            postCodeList.add(String.valueOf(eachElement.mainBusinessPhysicalAddress.postcode));    
                                        }else{
                                            postCodeList.add(UNIQUE_BLANK_INDICATOR);
                                        }
                                        
                                        if(String.isNotBlank(String.valueOf(eachElement.mainBusinessPhysicalAddress.stateCode))){
                                            stateCodeList.add(String.valueOf(eachElement.mainBusinessPhysicalAddress.stateCode));
                                        }else{
                                            stateCodeList.add(UNIQUE_BLANK_INDICATOR);
                                        }
                                        
                                    }else{
                                        isCurrentIndi.add(UNIQUE_BLANK_INDICATOR);
                                        postCodeList.add(UNIQUE_BLANK_INDICATOR);
                                        stateCodeList.add(UNIQUE_BLANK_INDICATOR);    
                                    }
                                    
                                    //CHECKING INSIDE MAIN NAME NODE
                                    if(eachElement.mainName != NULL){
                                        if(String.isNotBlank(String.valueOf(eachElement.mainName.isCurrentIndicator))){
                                            mainNameCurrentIndi.add(String.valueOf(eachElement.mainName.isCurrentIndicator));    
                                            businessNameIndicatorList.add(UNIQUE_BLANK_INDICATOR); 
                                            tradingNameIndicatorList.add(UNIQUE_BLANK_INDICATOR); 
                                            otherTradingIndicatorList.add(UNIQUE_BLANK_INDICATOR);
                                            legalCurrentIndicator.add(UNIQUE_BLANK_INDICATOR); 
                                        }else{
                                           mainNameCurrentIndi.add(UNIQUE_BLANK_INDICATOR); 
                                        } 
                                        
                                        if(String.isNotBlank(String.valueOf(eachElement.mainName.score))){
                                            scoreList.add(String.valueOf(eachElement.mainName.score));
                                            tradingNameScoreList.add(UNIQUE_BLANK_INDICATOR); 
                                            businessScoreList.add(UNIQUE_BLANK_INDICATOR);
                                            otherTradingScoreList.add(UNIQUE_BLANK_INDICATOR); 
                                            legalScoreList.add(UNIQUE_BLANK_INDICATOR);   
                                        }else{
                                           scoreList.add(UNIQUE_BLANK_INDICATOR) ;   
                                        } 
                                        
                                        if(String.isNotBlank(String.valueOf(eachElement.mainName.organisationName))){
                                            organizationNameList.add(String.valueOf(eachElement.mainName.organisationName));
                                            businessOrgNameList.add(UNIQUE_BLANK_INDICATOR);
                                            tradingOrgNameList.add(UNIQUE_BLANK_INDICATOR); 
                                            otherTradingNameList.add(UNIQUE_BLANK_INDICATOR);
                                            legalNameList.add(UNIQUE_BLANK_INDICATOR);
                                        }else{
                                           organizationNameList.add(UNIQUE_BLANK_INDICATOR);
                                        }  
                                    }
                                    
                                    //CHECKING INSIDE ABN NODE
                                    if(eachElement.ABN != NULL){
                                        if(String.isNotBlank(String.valueOf(eachElement.ABN.identifierStatus))){
                                            abnIdentifierStatList.add(String.valueOf(eachElement.ABN.identifierStatus));                                        
                                        }else{
                                            abnIdentifierStatList.add(UNIQUE_BLANK_INDICATOR);
                                        }
                                        
                                        if(String.isNotBlank(String.valueOf(eachElement.ABN.identifierValue))){
                                            abnIdentifierValList.add(String.valueOf(eachElement.ABN.identifierValue)); 
                                        }else{
                                            abnIdentifierValList.add(UNIQUE_BLANK_INDICATOR);
                                        }
                                    }else{
                                        abnIdentifierStatList.add(UNIQUE_BLANK_INDICATOR);
                                        abnIdentifierValList.add(UNIQUE_BLANK_INDICATOR);   
                                    }
                                    
                                    //CHECKING INSIDE MAIN TRADING NAME NODE
                                    if(eachElement.mainTradingName != NULL){
                                        if(String.isNotBlank(String.valueOf(eachElement.mainTradingName.isCurrentIndicator))){
                                            tradingNameIndicatorList.add(String.valueOf(eachElement.mainTradingName.isCurrentIndicator)); 
                                            mainNameCurrentIndi.add(UNIQUE_BLANK_INDICATOR);    
                                            businessNameIndicatorList.add(UNIQUE_BLANK_INDICATOR);  
                                            otherTradingIndicatorList.add(UNIQUE_BLANK_INDICATOR); 
                                            legalCurrentIndicator.add(UNIQUE_BLANK_INDICATOR);  
                                        }else{
                                           tradingNameIndicatorList.add(UNIQUE_BLANK_INDICATOR); 
                                        } 
                                        
                                        if(String.isNotBlank(String.valueOf(eachElement.mainTradingName.score))){
                                            tradingNameScoreList.add(String.valueOf(eachElement.mainTradingName.score)); 
                                            businessScoreList.add(UNIQUE_BLANK_INDICATOR);
                                            scoreList.add(UNIQUE_BLANK_INDICATOR) ; 
                                            otherTradingScoreList.add(UNIQUE_BLANK_INDICATOR);  
                                            legalScoreList.add(UNIQUE_BLANK_INDICATOR); 
                                        }else{
                                           tradingNameScoreList.add(UNIQUE_BLANK_INDICATOR);    
                                        } 
                                        
                                        if(String.isNotBlank(String.valueOf(eachElement.mainTradingName.organisationName))){
                                            tradingOrgNameList.add(String.valueOf(eachElement.mainTradingName.organisationName));
                                            organizationNameList.add(UNIQUE_BLANK_INDICATOR);
                                            businessOrgNameList.add(UNIQUE_BLANK_INDICATOR);
                                            otherTradingNameList.add(UNIQUE_BLANK_INDICATOR);
                                            legalNameList.add(UNIQUE_BLANK_INDICATOR);
                                        }else{
                                           tradingOrgNameList.add(UNIQUE_BLANK_INDICATOR);
                                        }  
                                    }
                                    //CHECKING INSIDE DGR FUND NAME NODE
                                    if(eachElement.dgrFundName != NULL){
                                        if(String.isNotBlank(String.valueOf(eachElement.dgrFundName.isCurrentIndicator))){
                                            tradingNameIndicatorList.add(String.valueOf(eachElement.dgrFundName.isCurrentIndicator)); 
                                            mainNameCurrentIndi.add(UNIQUE_BLANK_INDICATOR);    
                                            businessNameIndicatorList.add(UNIQUE_BLANK_INDICATOR);  
                                            otherTradingIndicatorList.add(UNIQUE_BLANK_INDICATOR); 
                                            legalCurrentIndicator.add(UNIQUE_BLANK_INDICATOR);  
                                        }else{
                                           tradingNameIndicatorList.add(UNIQUE_BLANK_INDICATOR); 
                                        } 
                                        
                                        if(String.isNotBlank(String.valueOf(eachElement.dgrFundName.score))){
                                            tradingNameScoreList.add(String.valueOf(eachElement.dgrFundName.score)); 
                                            businessScoreList.add(UNIQUE_BLANK_INDICATOR);
                                            scoreList.add(UNIQUE_BLANK_INDICATOR) ; 
                                            otherTradingScoreList.add(UNIQUE_BLANK_INDICATOR);  
                                            legalScoreList.add(UNIQUE_BLANK_INDICATOR); 
                                        }else{
                                           tradingNameScoreList.add(UNIQUE_BLANK_INDICATOR);    
                                        } 
                                        
                                        if(String.isNotBlank(String.valueOf(eachElement.dgrFundName.organisationName))){
                                            tradingOrgNameList.add(String.valueOf(eachElement.dgrFundName.organisationName));
                                            organizationNameList.add(UNIQUE_BLANK_INDICATOR);
                                            businessOrgNameList.add(UNIQUE_BLANK_INDICATOR);
                                            otherTradingNameList.add(UNIQUE_BLANK_INDICATOR);
                                            legalNameList.add(UNIQUE_BLANK_INDICATOR);
                                        }else{
                                           tradingOrgNameList.add(UNIQUE_BLANK_INDICATOR);
                                        }  
                                    }
                                    
                                    //CHECKING INSIDE BUSINESS NAME NODE
                                    if(eachElement.businessName != NULL){
                                        if(String.isNotBlank(String.valueOf(eachElement.businessName.isCurrentIndicator))){
                                            businessNameIndicatorList.add(String.valueOf(eachElement.businessName.isCurrentIndicator)); 
                                            mainNameCurrentIndi.add(UNIQUE_BLANK_INDICATOR); 
                                            tradingNameIndicatorList.add(UNIQUE_BLANK_INDICATOR); 
                                            otherTradingIndicatorList.add(UNIQUE_BLANK_INDICATOR);  
                                            legalCurrentIndicator.add(UNIQUE_BLANK_INDICATOR); 
                                        }else{
                                           businessNameIndicatorList.add(UNIQUE_BLANK_INDICATOR); 
                                        } 
                                        
                                        if(String.isNotBlank(String.valueOf(eachElement.businessName.score))){
                                            businessScoreList.add(String.valueOf(eachElement.businessName.score)); 
                                            scoreList.add(UNIQUE_BLANK_INDICATOR) ;  
                                            tradingNameScoreList.add(UNIQUE_BLANK_INDICATOR); 
                                            otherTradingScoreList.add(UNIQUE_BLANK_INDICATOR); 
                                            legalScoreList.add(UNIQUE_BLANK_INDICATOR);  
                                        }else{
                                           businessScoreList.add(UNIQUE_BLANK_INDICATOR);    
                                        } 
                                        
                                        if(String.isNotBlank(String.valueOf(eachElement.businessName.organisationName))){
                                            businessOrgNameList.add(String.valueOf(eachElement.businessName.organisationName));
                                            tradingOrgNameList.add(UNIQUE_BLANK_INDICATOR);
                                            organizationNameList.add(UNIQUE_BLANK_INDICATOR);
                                            otherTradingNameList.add(UNIQUE_BLANK_INDICATOR);
                                            legalNameList.add(UNIQUE_BLANK_INDICATOR);
                                        }else{
                                           businessOrgNameList.add(UNIQUE_BLANK_INDICATOR);
                                        }  
                                    } 
                                    
                                   //CHECKING INSIDE OTHER TRADING NAME NODE
                                   if(eachElement.otherTradingName != NULL){
                                       if(String.isNotBlank(String.valueOf(eachElement.otherTradingName.isCurrentIndicator))){
                                           otherTradingIndicatorList.add(String.valueOf(eachElement.otherTradingName.isCurrentIndicator)); 
                                           mainNameCurrentIndi.add(UNIQUE_BLANK_INDICATOR); 
                                           tradingNameIndicatorList.add(UNIQUE_BLANK_INDICATOR); 
                                           businessNameIndicatorList.add(UNIQUE_BLANK_INDICATOR); 
                                           legalCurrentIndicator.add(UNIQUE_BLANK_INDICATOR);  
                                       }else{
                                          otherTradingIndicatorList.add(UNIQUE_BLANK_INDICATOR); 
                                       } 
                                        
                                       if(String.isNotBlank(String.valueOf(eachElement.otherTradingName.score))){
                                           otherTradingScoreList.add(String.valueOf(eachElement.otherTradingName.score)); 
                                           scoreList.add(UNIQUE_BLANK_INDICATOR) ;  
                                           tradingNameScoreList.add(UNIQUE_BLANK_INDICATOR); 
                                           businessScoreList.add(UNIQUE_BLANK_INDICATOR);
                                           legalScoreList.add(UNIQUE_BLANK_INDICATOR);   
                                       }else{
                                          otherTradingScoreList.add(UNIQUE_BLANK_INDICATOR);    
                                       } 
                                        
                                       if(String.isNotBlank(String.valueOf(eachElement.otherTradingName.organisationName))){
                                           otherTradingNameList.add(String.valueOf(eachElement.otherTradingName.organisationName));
                                           tradingOrgNameList.add(UNIQUE_BLANK_INDICATOR);
                                           organizationNameList.add(UNIQUE_BLANK_INDICATOR);
                                           businessOrgNameList.add(UNIQUE_BLANK_INDICATOR);
                                           legalNameList.add(UNIQUE_BLANK_INDICATOR);
                                       }else{
                                          otherTradingNameList.add(UNIQUE_BLANK_INDICATOR);
                                       }  
                                    }
                                    
                                    //CHECKING INSIDE LEGAL NAME NODE
                                   if(eachElement.legalName != NULL){
                                       if(String.isNotBlank(String.valueOf(eachElement.legalName.isCurrentIndicator))){
                                           legalCurrentIndicator.add(String.valueOf(eachElement.legalName.isCurrentIndicator)); 
                                           mainNameCurrentIndi.add(UNIQUE_BLANK_INDICATOR); 
                                           tradingNameIndicatorList.add(UNIQUE_BLANK_INDICATOR); 
                                           businessNameIndicatorList.add(UNIQUE_BLANK_INDICATOR); 
                                           otherTradingIndicatorList.add(UNIQUE_BLANK_INDICATOR); 
                                       }else{
                                          legalCurrentIndicator.add(UNIQUE_BLANK_INDICATOR); 
                                       } 
                                        
                                       if(String.isNotBlank(String.valueOf(eachElement.legalName.score))){
                                           legalScoreList.add(String.valueOf(eachElement.legalName.score)); 
                                           scoreList.add(UNIQUE_BLANK_INDICATOR) ;  
                                           tradingNameScoreList.add(UNIQUE_BLANK_INDICATOR); 
                                           businessScoreList.add(UNIQUE_BLANK_INDICATOR);
                                           otherTradingScoreList.add(UNIQUE_BLANK_INDICATOR);   
                                       }else{
                                          legalScoreList.add(UNIQUE_BLANK_INDICATOR);    
                                       } 
                                        
                                       if(String.isNotBlank(String.valueOf(eachElement.legalName.fullName))){
                                           legalNameList.add(String.valueOf(eachElement.legalName.fullName));
                                           tradingOrgNameList.add(UNIQUE_BLANK_INDICATOR);
                                           organizationNameList.add(UNIQUE_BLANK_INDICATOR);
                                           businessOrgNameList.add(UNIQUE_BLANK_INDICATOR);
                                           otherTradingNameList.add(UNIQUE_BLANK_INDICATOR);
                                       }else{
                                          legalNameList.add(UNIQUE_BLANK_INDICATOR);
                                       }  
                                    }
                                    
                                    //CHECKING FOR ASIC NUMBER NODE
                                    if(eachElement.ASICNumber != NULL){
                                        if(String.isNotBlank(String.valueOf(eachElement.ASICNumber))){
                                            asicList.add(String.valueOf(eachElement.ASICNumber));    
                                        }else{
                                            asicList.add(UNIQUE_BLANK_INDICATOR);
                                        }
                                    }else{
                                        asicList.add(UNIQUE_BLANK_INDICATOR);
                                    }
                                    
                                    //CHECKING FOR ENTITY STATUS NODE
                                    if(eachElement.entityStatus != NULL){
                                        if(String.isNotBlank(String.valueOf(eachElement.entityStatus.entityStatusCode))){
                                            entityStatusCodeList.add(String.valueOf(eachElement.entityStatus.entityStatusCode));    
                                        }else{
                                            entityStatusCodeList.add(UNIQUE_BLANK_INDICATOR);
                                        }
                                        
                                        if(String.isNotBlank(String.valueOf(eachElement.entityStatus.effectiveFrom))){
                                            entityEffectiveFromList.add(String.valueOf(eachElement.entityStatus.effectiveFrom));    
                                        }else{
                                            entityEffectiveFromList.add(UNIQUE_BLANK_INDICATOR);
                                        }
                                    }else{
                                        entityEffectiveFromList.add(UNIQUE_BLANK_INDICATOR); 
                                        entityStatusCodeList.add(UNIQUE_BLANK_INDICATOR);   
                                    }
                                    
                                    //CHECKING FOR ENTITY TYPE NODE
                                    if(eachElement.entityType != NULL){
                                        if(String.isNotBlank(String.valueOf(eachElement.entityType.entityDescription))){
                                            entityDescList.add(String.valueOf(eachElement.entityType.entityDescription));    
                                        }else{
                                            entityDescList.add(UNIQUE_BLANK_INDICATOR);    
                                        }
                                    }else{
                                        entityDescList.add(UNIQUE_BLANK_INDICATOR);    
                                    } 
                                    
                                    //CHECKING FOR GST NODE
                                    if(eachElement.goodsAndServicesTax != NULL){
                                        if(String.isNotBlank(String.valueOf(eachElement.goodsAndServicesTax.effectiveFrom))){
                                            gstEffectiveFromList.add(String.valueOf(eachElement.goodsAndServicesTax.effectiveFrom));
                                        }else{
                                            gstEffectiveFromList.add(UNIQUE_BLANK_INDICATOR);
                                        }
                                    }else{
                                        gstEffectiveFromList.add(UNIQUE_BLANK_INDICATOR);
                                    }
                                          
                                }// END OF FOR LOOP TO TRAVERSE LIST
                                
                            }                                       
                        }
                        
                        //EXTRACTING DATA FROM TOP LEVEL NODE
                        if(String.isNotBlank(String.valueOf(responsePojo.response.dateTimeRetrieved))){
                            dateTimeRetreivedList.add(String.valueOf(responsePojo.response.dateTimeRetrieved));    
                        }else{
                           dateTimeRetreivedList.add(UNIQUE_BLANK_INDICATOR); 
                        }
                        
                        if(String.isNotBlank(String.valueOf(responsePojo.response.dateRegisterLastUpdated))){
                            dateRegisterList.add(String.valueOf(responsePojo.response.dateRegisterLastUpdated));    
                        }else{
                           dateRegisterList.add(UNIQUE_BLANK_INDICATOR); 
                        }
                        
                        if(String.isNotBlank(String.valueOf(responsePojo.response.usageStatement))){
                            usageStatementList.add(String.valueOf(responsePojo.response.usageStatement));    
                        }else{
                           usageStatementList.add(UNIQUE_BLANK_INDICATOR); 
                        }
                    }                     
                }                
            }catch(Exception e){
                throw new CustomException(ConstantValues.responseParsingException+ e);
            }       
              
        }
        
        //RECORD GEN METHOD
        public static String createRecords(String sfId, String identifier){
            //INITIALIZING AND POPULATING VALUES INTO PARENT RECORD
            Savepoint sp;
            String ret = '';
            try{
                ABN_Company_Information__c abnInfo = new ABN_Company_Information__c();
                List<ABN_Company_List__c> companyList = new List<ABN_Company_List__c>();
                if(dateTimeRetreivedList.isEmpty() == false){
                    abnInfo.DateTimeRetrieved__c = dateTimeRetreivedList.get(0);
                }
                //INSERTING PARENT RECORD
                if(abnInfo != NULL){
                    if(identifier.equalsIgnoreCase('P')){
                        abnInfo.Party__c = sfId;
                    }else if(identifier.equalsIgnoreCase('E')){
                        abnInfo.Employment_Information__c = sfId;
                    }
                    sp = Database.setSavepoint();
                    INSERT abnInfo;
                }
                
                if(sizeOfList > 0){
                    if(sizeOfList < 200){
                        for(Integer i = 0 ; i < sizeOfList; i++){
                            ABN_Company_List__c companyObj = new ABN_Company_List__c();
                            //ASSIGNING ABN INFORMATION INSIDE RECORD
                            companyObj.ABN_Identifier_Status__c = abnIdentifierStatList.size() > i ?  (abnIdentifierStatList.get(i) != NULL && abnIdentifierStatList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? abnIdentifierStatList.get(i) : '') : '';
                            companyObj.ABN_Identifier_Value__c = abnIdentifierValList.size() > i ?  (abnIdentifierValList.get(i) != NULL && abnIdentifierValList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? abnIdentifierValList.get(i) : '') : ''; 
                            
                            //ASSIGNING BUSINESS INFORMATION INSIDE RECORD
                            companyObj.Business_Current_Indicator__c = businessNameIndicatorList.size() > i ?  (businessNameIndicatorList.get(i) != NULL && businessNameIndicatorList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? businessNameIndicatorList.get(i) : '') : '';
                            companyObj.Business_Organization_Name__c = businessOrgNameList.size() > i ?  (businessOrgNameList.get(i) != NULL && businessOrgNameList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? businessOrgNameList.get(i) : '') : ''; 
                            companyObj.Business_Organization_Score__c = businessScoreList.size() > i ?  (businessScoreList.get(i) != NULL && businessScoreList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? Integer.valueOf(businessScoreList.get(i)) : NULL) : NULL;
                            
                            //ASSIGNING TRADING INFORMATION INSIDE RECORD
                            companyObj.Trading_Current_Indicator__c = tradingNameIndicatorList.size() > i ?  (tradingNameIndicatorList.get(i) != NULL && tradingNameIndicatorList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? tradingNameIndicatorList.get(i) : '') : '';
                            companyObj.Trading_Name_Score__c = tradingNameScoreList.size() > i ?  (tradingNameScoreList.get(i) != NULL && tradingNameScoreList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? Integer.valueOf(tradingNameScoreList.get(i)) : NULL) : NULL; 
                            companyObj.Trading_Organization_Name__c = tradingOrgNameList.size() > i ?  (tradingOrgNameList.get(i) != NULL && tradingOrgNameList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? tradingOrgNameList.get(i) : '') : '';
                            
                            //ASSIGNING MAIN ORGANIZATION INFORMATION INSIDE RECORD
                            companyObj.Main_Current_Indicator__c = mainNameCurrentIndi.size() > i ?  (mainNameCurrentIndi.get(i) != NULL && mainNameCurrentIndi.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? mainNameCurrentIndi.get(i) : '') : '';
                            companyObj.Main_Organization_Name__c = organizationNameList.size() > i ?  (organizationNameList.get(i) != NULL && organizationNameList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? organizationNameList.get(i) : '') : '';
                            companyObj.Main_Organization_Name_Score__c = scoreList.size() > i ?  (scoreList.get(i) != NULL && scoreList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? Integer.valueOf(scoreList.get(i)) : NULL) : NULL;
                            
                            //ASSIGNING OTHER TRADING ORGANIZATION INFORMATION INSIDE RECORD
                            companyObj.Other_Trading_Name_Current_Indicator__c = otherTradingIndicatorList.size() > i ?  (otherTradingIndicatorList.get(i) != NULL && otherTradingIndicatorList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? otherTradingIndicatorList.get(i) : '') : '';
                            companyObj.Other_Trading_Organization_Name__c = otherTradingNameList.size() > i ?  (otherTradingNameList.get(i) != NULL && otherTradingNameList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? otherTradingNameList.get(i) : '') : '';
                            companyObj.Other_Trading_Name_Score__c = otherTradingScoreList.size() > i ?  (otherTradingScoreList.get(i) != NULL && otherTradingScoreList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? Integer.valueOf(otherTradingScoreList.get(i)) : NULL) : NULL;
                            
                            //ASSIGNING LEGAL NAME INSIDE RECORD
                            companyObj.LegalName_Current_Indicator__c = legalCurrentIndicator.size() > i ?  (legalCurrentIndicator.get(i) != NULL && legalCurrentIndicator.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? legalCurrentIndicator.get(i) : '') : '';
                            companyObj.Legal_FullName__c = legalNameList.size() > i ?  (legalNameList.get(i) != NULL && legalNameList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? legalNameList.get(i) : '') : '';
                            companyObj.LegalName_Score__c = legalScoreList.size() > i ?  (legalScoreList.get(i) != NULL && legalScoreList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? Integer.valueOf(legalScoreList.get(i)) : NULL) : NULL;
    
                            
                            //ASSIGNING ADDRESS DETAIL INSIDE RECORD
                            companyObj.Post_Code__c = postCodeList.size() > i ?  (postCodeList.get(i) != NULL && postCodeList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? postCodeList.get(i) : '') : '';
                            companyObj.State_Code__c = stateCodeList.size() > i ?  (stateCodeList.get(i) != NULL && stateCodeList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? stateCodeList.get(i) : '') : '';
                            
                            //ASSIGNING ASIC NUMBER
                            companyObj.ASIC_Number__c = asicList.size() > i ?  (asicList.get(i) != NULL && asicList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? asicList.get(i) : '') : '';
                            
                            //ASSIGNING ENTITY DETAILS
                            companyObj.Entity_Description__c = entityDescList.size() > i ?  (entityDescList.get(i) != NULL && entityDescList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? entityDescList.get(i) : '') : '';
                            companyObj.Entity_Effective_From__c = entityEffectiveFromList.size() > i ?  (entityEffectiveFromList.get(i) != NULL && entityEffectiveFromList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? entityEffectiveFromList.get(i) : '') : '';
                            companyObj.Entity_Status_Code__c = entityStatusCodeList.size() > i ?  (entityStatusCodeList.get(i) != NULL && entityStatusCodeList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? entityStatusCodeList.get(i) : '') : '';
                            
                            //ASSIGNING GST DETAILS
                            companyObj.GST_Effective_From__c = gstEffectiveFromList.size() > i ?  (gstEffectiveFromList != NULL && gstEffectiveFromList.get(i).equalsIgnoreCase(UNIQUE_BLANK_INDICATOR) == false ? gstEffectiveFromList.get(i) : '') : '';
                            
                            //ASSIGNING PARENT ID TO EACH CHILD RECORD
                            companyObj.ABN_Company_Information__c = abnInfo.id;
                            
                            if(companyObj != NULL){
                                companyList.add(companyObj);    
                            }
            
                        }
                        //INSERTING CHILD RECORDS            
                        if(companyList.isEmpty() == false){
                            sp = Database.setSavepoint();
                            INSERT companyList; 
                            ret = ConstantValues.msg;
                        }
                    }
                    else {
                        ret = (System.label.ABN_Search_results_error_message);
                    }
                }
                return ret;
            }catch(Exception e){
                Database.rollback(sp);
                throw new CustomException (ConstantValues.recordCreationException+e); 
            }
        }
    }