/****************************************************************************************************
Company              : Cloudkaptan Consultancy Services Pvt. Ltd. 
Class Name           : UpdateEmploymentTypeOnApplication 
Created Date         : 04/07/2022 
Developed By         : Sayak Mukhopadhyay 
Description          : This is used to Migrate all existing data(regarding the development of 
                       UpdateEmploymentTypeOnApplication Class)
****************************************************************************************************/

public class UpdateEmpTypeBatch implements DataBase.StateFul,DataBase.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT id,
                                            Total_Self_Employed_Full_Doc_Income__c,
                                            Total_Self_Employed_Income__c,
                                            Total_Self_Employed_Alt_Doc_Income__c,
                                            Total_PAYG_Income__c,
                                            Total_Other_Income__c,
                                            Total_Unemployment_Income__c,
                                            Employment_Type__c,
                                            Months_Self_Employed__c,
                                            Document_Type__c,
                                            (
                                                SELECT id,
                                                Employment_Type__c
                                                FROM genesis__Parties__r
                                                WHERE Legal_Entity_Type__c =: ConstantValues.indType
                                            )
                                            FROM genesis__Applications__c]);
                                            // FROM genesis__Applications__c
                                            // WHERE id = 'a5m9p000000202L']);
    }
    public void execute(Database.BatchableContext bc, List<genesis__Applications__c>objAppList){
        try{
            Double totalAmount,maxOne,maxTwo,maxIncome,totalPaygIncome,ammount;
            String empType,frequency;
            List<String> docTypeList = new String[]{ConstantValues.FullDocType,ConstantValues.ALT};
            List<String> legalEntityList = new String[]{ConstantValues.indType,ConstantValues.JOINT};
            List<String> partyTypeList = new String[]{ConstantValues.HOUSEHOLD_PARTY_TYPE,ConstantValues.SOLICITOR_PARTY_TYPE};
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
                                                                            AND Party__r.Party_Type_Name__c NOT IN: partyTypeList
                                                                            AND Party__r.Legal_Entity_Type__c IN: legalEntityList];
            List<genesis__Income__c> objIncomeList = [SELECT id,
                                                        genesis__Amount__c,
                                                        genesis__Application__r.id,
                                                        genesis__Frequency__c
                                                        FROM genesis__Income__c
                                                        WHERE genesis__Application__c in: objAppList
                                                        AND PAYG_Income__c = true];                                                                
            for(genesis__Applications__c objApp : objAppList){
                Integer count = 0;
                Integer flag = 1;
                for(clcommon__Party__c objParty : objApp.genesis__Parties__r){
                    if(objParty.Employment_Type__c == null){
                        count += 1;
                    }
                }
                if(objApp.genesis__Parties__r.size() > 0 && count == objApp.genesis__Parties__r.size()){
                    objApp.Employment_Type__c = ConstantValues.SELF_EMPLOYED;
                    flag = 0;
                }
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
                for(genesis__Employment_Information__c objEmpInfo : objEmpInfoList){
                    if(objEmpInfo.Document_Type__c == ConstantValues.FullDocType && objEmpInfo.Incomes__r.size()>0 && objEmpInfo.genesis__Application__c == objApp.id){
                        if(objEmpInfo.Override_Amount__c != null){
                            totalAmount += decimal.valueOf(objEmpInfo.Override_Amount__c);
                        }else if(objEmpInfo.Income_for_servicing_purposes__c != null){
                            totalAmount += objEmpInfo.Income_for_servicing_purposes__c;
                        }
                    }
                }
                    // System.debug('totalAmount(Full) ' + totalAmount);
                if(!String.isBlank(objApp.Document_Type__c) && objApp.Document_Type__c == ConstantValues.LEASE_DOC && flag == 1){
                    objApp.Employment_Type__c = ConstantValues.LEASE_DOC;
                }
                else{
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
                    System.debug(empType);
                    if(empType == ConstantValues.SELF_EMPLOYED){
                        objApp.Months_Self_Employed__c = UpdateEmploymentTypeOnApplication.getMonthsSelfEmpIncome(objApp.id,objEmpInfoList);
                    }
                }
                objApp.Total_Self_Employed_Full_Doc_Income__c = totalAmount;
                objApp.Total_Self_Employed_Income__c = objApp.Total_Self_Employed_Alt_Doc_Income__c + totalAmount;
            }
            if(objAppList.size() > 0){
                Database.update(objAppList,false);
            }
        }catch(Exception exe){
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'UpdateEmpTypeBatch :Exception: '+exe.getStackTraceString()
                                        +'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
    }
    public void finish(Database.BatchableContext bc){
    }
}



// UpdateEmpTypeBatch obj = new UpdateEmpTypeBatch();
// database.executebatch(obj,100);