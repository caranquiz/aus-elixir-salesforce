/****************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : LASDocumentHelper */
/* Created Date         : 15/03/2021 */
/* Developed By         : Rameswari Barman */
/* Description          : */
/* Last Modified Date   : 25/03/2021 */
/* Last Modified By     : Rameswari Barman */
/****************************************************************************************************/

global with sharing class LASDocumentHelper{
    Webservice static String updateValues(Id appId){
        try{
            if(String.isBlank(appId)){
                return null;
            }
            List <clcommon__Party__c> borrowerPartyList = [SELECT Id,
                                                            clcommon__Account__c,
                                                            clcommon__Account__r.Name,
                                                            NewExisting__c
                                                            FROM clcommon__Party__c 
                                                            WHERE genesis__Application__c =: appId
                                                            AND Party_Type_Name__c in (:ConstantValues.GUARANTOR,:ConstantValues.CO_APPLICANT,:ConstantValues.BORROWER)
                                                          ];
            if(borrowerPartyList.size() > 0 == false){
                return null;
            }
            List <Id> accountIds = new List<Id>();
            for(clcommon__Party__c eachParty : borrowerPartyList){
                accountIds.add(eachParty.clcommon__Account__c);
            }
            List <clcommon__Party__c> allBorrowerPartyList = [SELECT Id,
                                                                clcommon__Account__c,
                                                                clcommon__Account__r.Name
                                                                FROM clcommon__Party__c 
                                                                WHERE Party_Type_Name__c in (:ConstantValues.GUARANTOR,:ConstantValues.CO_APPLICANT,:ConstantValues.BORROWER)
                                                                AND genesis__Application__c NOT IN (:appId)
                                                                AND genesis__Application__c != NULL
                                                                AND clcommon__Account__c =: accountIds
                                                            ];
            for(clcommon__Party__c eachParty : borrowerPartyList){
                eachParty.NewExisting__c = ConstantValues.NEW_TAG;
                for(clcommon__Party__c eachRemainingParty : allBorrowerPartyList){
                    if(eachParty.clcommon__Account__c == eachRemainingParty.clcommon__Account__c){
                        eachParty.NewExisting__c = ConstantValues.EXISTING_TAG;
                    }
                }
            }
            update borrowerPartyList;                               
        }
        catch (Exception ex) {
            GenericUtility.insertLog('LASDocumentHelper.updateValues', ex);
            return ConstantValues.GENERAL_ERROR;
        }
        return ConstantValues.SUCCESS;
    }
    Webservice static String updateOverrideValues(Id appId){
        try{
            if(String.isBlank(appId)){
                return null;
            }
            List <String> companyList = new List<String>();
            List <genesis__Employment_Information__c> empInfoList = [SELECT Id,
                                                                        Override_Amount__c,
                                                                        Company_Name__c
                                                                    FROM genesis__Employment_Information__c 
                                                                    WHERE Document_Type__c =: ConstantValues.FullDocType
                                                                    AND Party__r.genesis__Application__c =: appId 
                                                                    AND Override__c =: ConstantValues.YES
                                                                    AND Company_Name__c != NULL
                                                                    AND Override_Amount__c != NULL];  
            if(empInfoList.size() > 0){
                List <RecordType> selfEmployedRecordTypeList = [SELECT Id,
                                                                    Name 
                                                                    FROM RecordType 
                                                                    WHERE Name =: ConstantValues.SELF_EMPLOYED
                                                                    LIMIT 1]; 
                if(selfEmployedRecordTypeList.size() > 0){
                    for(genesis__Employment_Information__c eachEmp : empInfoList){
                        companyList.add(eachEmp.Company_Name__c);
                    }
                    //Developer comment - not checking the size of companyList
                    //as in the list query null check is provided in where clause 
                    List <genesis__Employment_Information__c> incomeList =  [SELECT Id,
                                                                                Company_Name__c,
                                                                                LAS_Utility_Override_Amt__c,
                                                                                LAS_Utility_Override_Amt_Rendered__c
                                                                                FROM genesis__Employment_Information__c 
                                                                                WHERE Previous_Employment__c = false 
                                                                                AND genesis__Application__c =: appId 
                                                                                AND Party__r.genesis__Application__c =: appId 
                                                                                AND RecordTypeId =: selfEmployedRecordTypeList[0].Id
                                                                                AND Company_Name__c =: companyList];
                    for(genesis__Employment_Information__c eachIncome : incomeList){
                        eachIncome.LAS_Utility_Override_Amt__c = 0;
                        eachIncome.LAS_Utility_Override_Amt_Rendered__c = ConstantValues.NO_TAG;
                        for(genesis__Employment_Information__c eachEmp : empInfoList){
                            if(eachEmp.Company_Name__c == eachIncome.Company_Name__c){
                                eachIncome.LAS_Utility_Override_Amt__c = Decimal.valueOf(eachEmp.Override_Amount__c);
                                eachIncome.LAS_Utility_Override_Amt_Rendered__c = ConstantValues.YES_TAG;
                            }
                        }
                    }
                    update incomeList;
                }
            }                         
        }
        catch (Exception ex) {
            GenericUtility.insertLog('LASDocumentHelper.updateOverriValues', ex);
            return ConstantValues.GENERAL_ERROR;
        }
        return ConstantValues.SUCCESS;
    }
    Webservice static String updateEmploymentValues(Id appId){
        try{
            Integer employmentDeclared = 0;
            if(String.isBlank(appId)){
                return null;
            }
            List <clcommon__Party__c> borrowerPartyList = [SELECT Id,
                                                            LAS_Utility_Show_in_Capacity_Section__c
                                                            FROM clcommon__Party__c 
                                                            WHERE genesis__Application__c =: appId
                                                            AND Party_Type_Name__c in (:ConstantValues.GUARANTOR,:ConstantValues.CO_APPLICANT,:ConstantValues.BORROWER)
                                                          ];
            if(borrowerPartyList.size() > 0 == false){
                return null;
            }
            List <RecordType> selfEmployedRecordTypeList = [SELECT Id 
                                                                FROM RecordType 
                                                                WHERE Name =: ConstantValues.SELF_EMPLOYED
                                                                LIMIT 1];
            if(selfEmployedRecordTypeList.size() > 0 == false){
                return null;
            }
            List <genesis__Income__c> altIncomeDetailsList = [SELECT Id,
                                                                Party__c
                                                                FROM genesis__Income__c 
                                                                WHERE Income_Alt__c = true and genesis__Application__c =: appId
                                                                AND Party__c != NULL
                                                                AND Party__r.genesis__Application__c =: appId 
                                                                AND Party__r.Document_Type__c =: ConstantValues.ALT];  
            List <clcommon__Party__c> nonIndividualBorrowerFullList = [SELECT Id 
                                                                        FROM clcommon__Party__c 
                                                                        WHERE genesis__Application__c =: appId 
                                                                        AND Party_Type_Name__c IN (:ConstantValues.BORROWER,:ConstantValues.CO_APPLICANT) 
                                                                        AND Legal_Entity_Type__c NOT IN (:ConstantValues.indType)
                                                                        AND Document_Type__c =: ConstantValues.FullDocType];
            List <genesis__Income__c> altSelEmployedList = [SELECT Id,
                                                                Employment_Information__r.Party__c
                                                                FROM genesis__Income__c 
                                                                WHERE genesis__Application__c =: appId 
                                                                AND Document_Type__c =: ConstantValues.ALT 
                                                                AND Employment_Information__r.RecordTypeId =: selfEmployedRecordTypeList[0].Id
                                                                AND Employment_Information__r.Party__c != NULL]; 
            List <genesis__Employment_Information__c> individualSelfEmployedDetailsList = [SELECT Id,
                                                                                                Party__c
                                                                                                FROM genesis__Employment_Information__c 
                                                                                                WHERE Previous_Employment__c = false
                                                                                                AND genesis__Application__c =: appId 
                                                                                                AND Party__c != NULL
                                                                                                AND Party__r.genesis__Application__c =: appId 
                                                                                                AND RecordTypeId =: selfEmployedRecordTypeList[0].Id];
            List <genesis__Income__c> individualPAYGList =[SELECT Id,
                                                                Employment_Information__r.Party__c
                                                                FROM genesis__Income__c
                                                                WHERE genesis__Application__c =: appId
                                                                AND PAYG_Income__c = true
                                                                AND Employment_Information__r.Party__c != NULL];                                                                               
            for(clcommon__Party__c eachBorrower : borrowerPartyList){
                employmentDeclared = 0;
                eachBorrower.LAS_Utility_Show_in_Capacity_Section__c = false;
                if(altIncomeDetailsList.size() > 0){
                    for(genesis__Income__c eachIncome : altIncomeDetailsList){
                        if(eachIncome.Party__c == eachBorrower.Id){
                            employmentDeclared++;
                        }
                    }
                }
                if(nonIndividualBorrowerFullList.size() > 0){
                    for(clcommon__Party__c nonIndividualParty : nonIndividualBorrowerFullList){
                        if(nonIndividualParty.Id == eachBorrower.Id){
                            employmentDeclared++;
                        }
                    }
                }
                if(altSelEmployedList.size() > 0){
                    for(genesis__Income__c eachIncome : altSelEmployedList){
                        if(eachIncome.Employment_Information__r.Party__c == eachBorrower.Id){
                            employmentDeclared++;
                        }
                    }
                }
                if(individualSelfEmployedDetailsList.size() > 0){
                    for(genesis__Employment_Information__c eachEmp : individualSelfEmployedDetailsList){
                        if(eachEmp.Party__c == eachBorrower.Id){
                            employmentDeclared++;
                        }
                    }
                }
                if(individualPAYGList.size() > 0){
                    for(genesis__Income__c eachIncome : individualPAYGList){
                        if(eachIncome.Employment_Information__r.Party__c == eachBorrower.Id){
                            employmentDeclared++;
                        }
                    }
                }
                if(employmentDeclared == 0){
                    eachBorrower.LAS_Utility_Show_in_Capacity_Section__c = true;
                }
                update borrowerPartyList;
            }                                                      
        }
        catch (Exception ex) {
            GenericUtility.insertLog('LASDocumentHelper.updateEmploymentValues', ex);
            return ConstantValues.GENERAL_ERROR;
        }
        return ConstantValues.SUCCESS;
    }
 }