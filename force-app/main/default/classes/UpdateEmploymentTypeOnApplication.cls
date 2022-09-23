/****************************************************************************************************
Company              : Cloudkaptan Consultancy Services Pvt. Ltd. 
Class Name           : UpdateEmploymentTypeOnApplication 
Created Date         : 16/06/2022 
Developed By         : Sayak Mukhopadhyay 
Description          : This class is used to update the Employment Type of Application
****************************************************************************************************/

global with sharing class UpdateEmploymentTypeOnApplication {
    webService static void updateEmploymentTypeWS(Id applicationId){
        try {
            Double totalAmount;
            Double maxOne;
            Double maxTwo;
            Double maxIncome;
            Double totalPaygIncome;
            Double ammount;
            String empType,frequency;
            Integer count = 0;
            Integer flag = 1;
            if(String.isBlank(applicationId)){
                return;
            }
            List<String> docTypeList = new String[]{ConstantValues.FullDocType,ConstantValues.ALT};
            List<String> legalEntityList = new String[]{ConstantValues.indType,ConstantValues.JOINT};
            List<String> partyTypeList = new String[]{ConstantValues.HOUSEHOLD_PARTY_TYPE,ConstantValues.SOLICITOR_PARTY_TYPE};
            List<clcommon__Party__c> objPartyList = [SELECT id,
                                                        Employment_Type__c
                                                        FROM clcommon__Party__c
                                                        WHERE genesis__Application__c =: applicationId
                                                        AND Legal_Entity_Type__c =: ConstantValues.indType];
            List<genesis__Applications__c> objAppList = [SELECT id,
                                                                Total_Self_Employed_Full_Doc_Income__c,
                                                                Total_Self_Employed_Income__c,
                                                                Total_Self_Employed_Alt_Doc_Income__c,
                                                                Total_PAYG_Income__c,
                                                                Total_Other_Income__c,
                                                                Total_Unemployment_Income__c,
                                                                Employment_Type__c,
                                                                Months_Self_Employed__c,
                                                                Document_Type__c
                                                                FROM genesis__Applications__c
                                                                WHERE id =: applicationId];
            List<genesis__Employment_Information__c> objEmpInfoList = [SELECT id,
                                                                        Override_Amount__c,
                                                                        Income_for_servicing_purposes__c,
                                                                        genesis__Application__c,
                                                                        Party__c,
                                                                        Months_Self_Employed__c,
                                                                        Document_Type__c,
                                                                        ( SELECT id,
                                                                            genesis__Amount__c,
                                                                            Document_Type__c
                                                                            FROM Incomes__r
                                                                            WHERE Document_Type__c in: docTypeList
                                                                        )
                                                                        FROM genesis__Employment_Information__c
                                                                        WHERE Document_Type__c in: docTypeList
                                                                        AND genesis__Application__c in: objAppList
                                                                        AND Party__r.Party_Type_Name__c NOT IN :partyTypeList
                                                                        AND Party__r.Legal_Entity_Type__c IN :legalEntityList];
            List<genesis__Income__c> objIncomeList = [SELECT id,
                                                        genesis__Amount__c,
                                                        genesis__Application__r.id,
                                                        genesis__Frequency__c
                                                        FROM genesis__Income__c
                                                        WHERE genesis__Application__c in: objAppList
                                                        AND PAYG_Income__c = true]; 
            for(clcommon__Party__c objParty : objPartyList){
                if(objParty.Employment_Type__c == null){
                    count += 1;
                }
            }
            if(objPartyList.size() > 0 && count == objPartyList.size()){
                if(objAppList.size()>0){
                    System.debug('count -> ' + count);
                    objAppList[0].Employment_Type__c = ConstantValues.SELF_EMPLOYED;
                    Database.update(objAppList,false);
                    //return;
                    flag = 0;
                }
            }                                                                                                                        
            for(genesis__Applications__c objApp : objAppList){
                totalAmount = 0;
                totalPaygIncome = 0;
                for(genesis__Income__c objIncome : objIncomeList){
                    ammount = 0;
                    if(objIncome.genesis__Application__r.id == objApp.id){
                        if(objIncome.genesis__Amount__c != null){
                            ammount = objIncome.genesis__Amount__c;
                        }
                        if(objIncome.genesis__Frequency__c != null){
                            frequency = objIncome.genesis__Frequency__c;
                            if(frequency == ConstantValues.weekly){
                                ammount *= 52;
                            }else if(frequency == ConstantValues.FORTNIGHTLY){
                                ammount *= 26;
                            }else if(frequency == ConstantValues.monthly){
                                ammount *= 12;
                            }else if(frequency == ConstantValues.YEARLY){
                                ammount *= 1;
                            }
                        }
                    }
                    totalPaygIncome += ammount;
                }
                objApp.Total_PAYG_Income__c = totalPaygIncome;
                System.debug('Payg -> ' + totalPaygIncome);
                for(genesis__Employment_Information__c objEmpInfo : objEmpInfoList){
                    if(objEmpInfo.Document_Type__c == ConstantValues.FullDocType && objEmpInfo.genesis__Application__c == objApp.id){
                        if(objEmpInfo.Override_Amount__c != null){
                            totalAmount += decimal.valueOf(objEmpInfo.Override_Amount__c);
                        }else if(objEmpInfo.Income_for_servicing_purposes__c != null){
                            totalAmount += objEmpInfo.Income_for_servicing_purposes__c;
                        }
                    }
                }
                if(!String.isBlank(objApp.Document_Type__c) && objApp.Document_Type__c == ConstantValues.LEASE_DOC && flag == 1){
                    objApp.Employment_Type__c = ConstantValues.LEASE_DOC;
                }
                else{
                    // variable name change
                    maxOne = Math.max(objApp.Total_PAYG_Income__c,objApp.Total_Self_Employed_Alt_Doc_Income__c + totalAmount);
                    maxTwo = Math.max(objApp.Total_Unemployment_Income__c,objApp.Total_Other_Income__c);
                    maxIncome = Math.max(maxOne,maxTwo);
                    empType = (maxIncome == objApp.Total_PAYG_Income__c ? ConstantValues.PAYG
                            : maxIncome == objApp.Total_Self_Employed_Alt_Doc_Income__c + totalAmount ? ConstantValues.SELF_EMPLOYED
                            : maxIncome == objApp.Total_Unemployment_Income__c ? ConstantValues.UNEMPLOYMENT_STUDENT_HOME_DUTIES_RETIREMENT
                            : ConstantValues.OTHER);
                    if(flag == 1){
                        objApp.Employment_Type__c = empType;
                    }
                    if(empType == ConstantValues.SELF_EMPLOYED){
                        objApp.Months_Self_Employed__c = getMonthsSelfEmpIncome(objApp.id,objEmpInfoList);
                    }
                }
                objApp.Total_Self_Employed_Full_Doc_Income__c = totalAmount;
                objApp.Total_Self_Employed_Income__c = objApp.Total_Self_Employed_Alt_Doc_Income__c + totalAmount;
            }
            if(objAppList.size() > 0){
                Database.update(objAppList,false);
            }
            return;
        } catch (Exception e) {
            GenericUtility.insertLog('UpdateEmploymentTypeOnApplication', e);
            return;
        }
    }
    public static Double getMonthsSelfEmpIncome(Id applicationId,List<genesis__Employment_Information__c> objEmpInfoList){
        try {
            Double maxSelfIncome = 0, totalSelfIncome = 0, maxMonthSelfEmpOfApp = 0, maxMonthSelfIncome = 0;
            List<clcommon__Party__c> objPartyList = [SELECT id,
                                                        Name
                                                        FROM clcommon__Party__c
                                                        WHERE Legal_Entity_Type__c =: ConstantValues.indType
                                                        AND genesis__Application__c =: applicationId];
            for(clcommon__Party__c objParty : objPartyList){
                totalSelfIncome = 0;
                maxMonthSelfIncome = 0;
                for(genesis__Employment_Information__c objEmpInfo : objEmpInfoList){
                    if(objEmpInfo.Party__c == objParty.id){
                        if(objEmpInfo.Document_Type__c == ConstantValues.FullDocType && objEmpInfo.Incomes__r.size()>0){
                            if(objEmpInfo.Override_Amount__c != null){
                                totalSelfIncome += decimal.valueOf(objEmpInfo.Override_Amount__c);
                            }else if(objEmpInfo.Income_for_servicing_purposes__c != null){
                                totalSelfIncome += objEmpInfo.Income_for_servicing_purposes__c;
                            }
                        }else if(objEmpInfo.Document_Type__c == ConstantValues.ALT){
                            for(genesis__Income__c objIncome : objEmpInfo.Incomes__r){
                                if(objIncome.Document_Type__c == ConstantValues.ALT && objIncome.genesis__Amount__c != null){
                                    totalSelfIncome += objIncome.genesis__Amount__c;
                                }
                            } 
                        }
                        if(objEmpInfo.Months_Self_Employed__c > maxMonthSelfIncome && objEmpInfo.Months_Self_Employed__c != null){
                            maxMonthSelfIncome = objEmpInfo.Months_Self_Employed__c;
                        }
                    }
                }
                if(totalSelfIncome > maxSelfIncome) {
                    maxSelfIncome = totalSelfIncome;
                    maxMonthSelfEmpOfApp = maxMonthSelfIncome;
                }
            }
            return maxMonthSelfEmpOfApp;
        } catch (Exception e) {
            GenericUtility.insertLog('UpdateEmploymentTypeOnApplication', e);
            return 0;
        }
    }
}