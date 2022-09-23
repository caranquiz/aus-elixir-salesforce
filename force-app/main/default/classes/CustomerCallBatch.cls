/****************************************************************************************************
Company              : Cloudkaptan Consultancy Services Pvt. Ltd. 
Class Name           : UpdateEmploymentTypeOnApplication 
Created Date         : 01/08/2022 
Developed By         : Sayak Mukhopadhyay 
Description          : This is used to Migrate all existing data(regarding the development of 
                       Customer Call Automation)
****************************************************************************************************/
public class CustomerCallBatch implements DataBase.StateFul,DataBase.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT id,
                                            Total_Contract_Price__c
                                            FROM genesis__Applications__c]);
    }
    public void execute(Database.BatchableContext bc, List<genesis__Applications__c>objAppList){
        try {
            /// To Calculate Diff of Asset and Liability of Parties ///
            Map<Id,Double> sumOfOriginalAmountMap = new Map<Id,Double>();
            Map<Id,Double> sumOfMarketValueMap = new Map<Id,Double>();
            List<genesis__Liability__c> liabiltyRecords = [SELECT Id,
                                                genesis__Original_Amount__c,
                                                Party__c 
                                                FROM genesis__Liability__c
                                                WHERE genesis__Application__c in: objAppList];
            List<genesis__Asset_Information__c> assetRecords = [SELECT Id,
                                                                    genesis__Market_Value__c,
                                                                    Party__c 
                                                                    FROM genesis__Asset_Information__c
                                                                    WHERE genesis__Application__c in: objAppList]; 
            List<clcommon__Party__c> partyRecords = [SELECT id,
                                                        Diff_Of_Asset_and_Liability__c,
                                                        Application_Status__c 
                                                        FROM clcommon__Party__c 
                                                        WHERE genesis__Application__c in: objAppList];
            for(clcommon__Party__c eachParty : partyRecords){
                sumOfOriginalAmountMap.put(eachParty.id,0);
                sumOfMarketValueMap.put(eachParty.id,0);
            }
            for(genesis__Liability__c eachLiability : liabiltyRecords){
                if(sumOfOriginalAmountMap.containsKey(eachLiability.Party__c) && 
                        eachLiability.genesis__Original_Amount__c != null){
                    sumOfOriginalAmountMap.put(eachLiability.Party__c,sumOfOriginalAmountMap.get(eachLiability.Party__c) + eachLiability.genesis__Original_Amount__c); 
                }
            }
            for(genesis__Asset_Information__c eachAsset : assetRecords){
                if(sumOfMarketValueMap.containsKey(eachAsset.Party__c) && 
                        eachAsset.genesis__Market_Value__c != null){
                    sumOfMarketValueMap.put(eachAsset.Party__c,sumOfMarketValueMap.get(eachAsset.Party__c) + eachAsset.genesis__Market_Value__c); 
                }
            }
            for(clcommon__Party__c eachParty : partyRecords){
                if(sumOfOriginalAmountMap.containsKey(eachParty.id) && sumOfMarketValueMap.containsKey(eachParty.id)){
                    eachParty.Diff_Of_Asset_and_Liability__c = math.abs(sumOfOriginalAmountMap.get(eachParty.id) - sumOfMarketValueMap.get(eachParty.id));
                }
            }
            if(partyRecords.size()>0){
                Database.update(partyRecords,false);
            }
            /// To update diff of asset and liability and living expenses of individual parties from Household ///
            List<clcommon__Party__c> houseHoldPartyList = [SELECT id,
                                    genesis__Application__r.Id,
                                    clcommon__Account__r.Name,
                                    Diff_Of_Asset_and_Liability__c,
                                    Childcare_Monthly_Income__c,
                                    Insurance__c,
                                    Private_Health_Life_and_IP_Insurance__c,
                                    Telephone_Media_Streaming_Amount__c,
                                    Recreation_Entertainment__c,
                                    Memberships_gym_sporting_clubs_etc__c,
                                    Non_Compulsory_Superannuation__c,
                                    Maintenance_Alimony__c,
                                    Other_Expenses__c,
                                    Primary_Residence_Property_Costs__c,
                                    Investment_Property_Costs__c,
                                    Groceries__c,
                                    Clothing_Personal_Care__c,
                                    Transport_Monthly_Amount__c,
                                    Medical_Health__c,
                                    Education_excluding_Private_School_Fees__c,
                                    Education_Private_School_Fees__c
                                    FROM clcommon__Party__c
                                    WHERE Party_Type_Name__c =: ConstantValues.HOUSEHOLD_PARTY_TYPE
                                    AND genesis__Application__c in: objAppList];
            List<clcommon__Party__c> individualPartyList = [SELECT id,
                                                                genesis__Application__r.Id,
                                                                clcommon__Account__r.Name,
                                                                Diff_Of_Asset_and_Liability__c,
                                                                Childcare_Monthly_Income__c,
                                                                Insurance__c,
                                                                Private_Health_Life_and_IP_Insurance__c,
                                                                Telephone_Media_Streaming_Amount__c,
                                                                Recreation_Entertainment__c,
                                                                Memberships_gym_sporting_clubs_etc__c,
                                                                Non_Compulsory_Superannuation__c,
                                                                Maintenance_Alimony__c,
                                                                Other_Expenses__c,
                                                                Primary_Residence_Property_Costs__c,
                                                                Investment_Property_Costs__c,
                                                                Groceries__c,
                                                                Clothing_Personal_Care__c,
                                                                Transport_Monthly_Amount__c,
                                                                Medical_Health__c,
                                                                Education_excluding_Private_School_Fees__c,
                                                                Education_Private_School_Fees__c
                                                                FROM clcommon__Party__c
                                                                WHERE Party_Type_Name__c !=: ConstantValues.HOUSEHOLD_PARTY_TYPE
                                                                AND Legal_Entity_Type__c =: ConstantValues.indType
                                                                AND genesis__Application__c in: objAppList];
            for(clcommon__Party__c eachHouseholdParty : houseHoldPartyList){
                Id applicationId = eachHouseholdParty.genesis__Application__r.Id;
                String householdAccountName = eachHouseholdParty.clcommon__Account__r.Name.toLowercase();
                if(!String.isBlank(householdAccountName) && householdAccountName.contains('&') && eachHouseholdParty.Diff_Of_Asset_and_Liability__c != null){
                    String individualOne = householdAccountName.split('&')[0].split(' ')[0];
                    String individualTwo = householdAccountName.split('&')[1].split(' ')[1];
                    for(clcommon__Party__c eachIndividualParty : individualPartyList){
                        if(eachIndividualParty.genesis__Application__r.Id == applicationId){
                            String individualAccountName = eachIndividualParty.clcommon__Account__r.Name.toLowercase();
                            if(!String.isBlank(individualAccountName)){
                                if(individualAccountName.contains(individualOne) || individualAccountName.contains(individualTwo)){
                                    /// Diff Of Assets and Liability ///
                                    eachIndividualParty.Diff_Of_Asset_and_Liability__c = eachHouseholdParty.Diff_Of_Asset_and_Liability__c;
                                    /// Living Expenses ///
                                    eachIndividualParty.Childcare_Monthly_Income__c = eachHouseholdParty.Childcare_Monthly_Income__c ;
                                    eachIndividualParty.Insurance__c = eachHouseholdParty.Insurance__c ;
                                    eachIndividualParty.Private_Health_Life_and_IP_Insurance__c = eachHouseholdParty.Private_Health_Life_and_IP_Insurance__c ;
                                    eachIndividualParty.Telephone_Media_Streaming_Amount__c = eachHouseholdParty.Telephone_Media_Streaming_Amount__c ;
                                    eachIndividualParty.Recreation_Entertainment__c = eachHouseholdParty.Recreation_Entertainment__c ;
                                    eachIndividualParty.Memberships_gym_sporting_clubs_etc__c = eachHouseholdParty.Memberships_gym_sporting_clubs_etc__c ;
                                    eachIndividualParty.Non_Compulsory_Superannuation__c = eachHouseholdParty.Non_Compulsory_Superannuation__c ;
                                    eachIndividualParty.Maintenance_Alimony__c = eachHouseholdParty.Maintenance_Alimony__c ;
                                    eachIndividualParty.Other_Expenses__c = eachHouseholdParty.Other_Expenses__c ;
                                    eachIndividualParty.Primary_Residence_Property_Costs__c = eachHouseholdParty.Primary_Residence_Property_Costs__c;
                                    eachIndividualParty.Investment_Property_Costs__c = eachHouseholdParty.Investment_Property_Costs__c;
                                    eachIndividualParty.Groceries__c = eachHouseholdParty.Groceries__c;
                                    eachIndividualParty.Clothing_Personal_Care__c = eachHouseholdParty.Clothing_Personal_Care__c;
                                    eachIndividualParty.Transport_Monthly_Amount__c = eachHouseholdParty.Transport_Monthly_Amount__c;
                                    eachIndividualParty.Medical_Health__c = eachHouseholdParty.Medical_Health__c;
                                    eachIndividualParty.Education_excluding_Private_School_Fees__c = eachHouseholdParty.Education_excluding_Private_School_Fees__c;
                                    eachIndividualParty.Education_Private_School_Fees__c = eachHouseholdParty.Education_Private_School_Fees__c ;
                                }
                            }
                        }
                    }
                }
            }
            if(individualPartyList.size()>0){
                Database.update(individualPartyList,false);
            }
            /// To update Total Contract Price on Application ///
            List<genesis__Application_Collateral__c> appCollList = [SELECT id,
                                                            genesis__Application__c,
                                                            genesis__Collateral__r.Contract_Price_Amount__c 
                                                            FROM genesis__Application_Collateral__c 
                                                            WHERE genesis__Collateral__r.Contract_Of_Sale__c =: ConstantValues.YES
                                                            AND genesis__Application__c in: objAppList];
            for(genesis__Applications__c eachApp: objAppList){
                Double total = 0;
                for(genesis__Application_Collateral__c eachAppColl : appCollList){
                    if(eachAppColl.genesis__Application__c == eachApp.id && eachAppColl.genesis__Collateral__r.Contract_Price_Amount__c != null){
                        total += eachAppColl.genesis__Collateral__r.Contract_Price_Amount__c;
                    }
                }
                eachApp.Total_Contract_Price__c = total;
            }
            if(objAppList.size()>0){
                Database.update(objAppList,false);
            }
            /// To update Total Incomes on Party ///
            List<String> partyTypeList = new String[]{ConstantValues.BORROWER,ConstantValues.CO_APPLICANT,ConstantValues.GUARANTOR};
            List<clcommon__Party__c> objPartyList = [SELECT id,
                                                Name,
                                                genesis__Application__r.Id,
                                                Total_Unemployment_Income__c,
                                                Total_Other_Income__c,
                                                Total_PAYG_Income__c,
                                                Total_Self_Employed_Income__c,
                                                Gross_Taxable_Income__c,
                                                Customer_Interview_Signed__c,
                                                (
                                                    SELECT id,
                                                    Understand_English_Confirm__c,
                                                    Date_And_Time__c,
                                                    Credit_Analyst_Signature_Check__c
                                                    FROM Customer_Call_Automations__r
                                                ),
                                                (
                                                    SELECT id,
                                                    genesis__Application__c,
                                                    Unemployed_Income__c,
                                                    Document_Type__c,
                                                    Other_Income__c,
                                                    PAYG_Income__c,
                                                    genesis__Amount__c,
                                                    genesis__Frequency__c
                                                    FROM Incomes__r
                                                ),
                                                (
                                                    SELECT Id,
                                                    Party__c,
                                                    genesis__Application__c,
                                                    Total_Current_Income_Period__c
                                                    FROM Employment_Information__r
                                                )  
                                                FROM clcommon__Party__c 
                                                WHERE Legal_Entity_Type__c = 'Individual'
                                                AND Party_Type_Name__c in: partyTypeList
                                                AND genesis__Application__c in: objAppList];
            for(clcommon__Party__c objParty : objPartyList){
                Double totalUnEmpIncome = 0;
                Double totalPaygIncome = 0;
                Double totalOtherIncome = 0;
                Double totalCurrentIncome = 0;
                String frequency;
                Double ammount = 0;
                Double totalSelfEmpAltDocIncome = 0;
                if(objParty.Customer_Call_Automations__r.size()>0){
                    if(objParty.Customer_Call_Automations__r[0].Date_And_Time__c != null && objParty.Customer_Call_Automations__r[0].Credit_Analyst_Signature_Check__c == false){
                        objParty.Customer_Interview_Signed__c = true;
                    }
                }
                for(genesis__Income__c objIncome : objParty.Incomes__r){
                    if(objIncome.Unemployed_Income__c == true  && objIncome.genesis__Amount__c != null){
                        frequency = objIncome.genesis__Frequency__c;
                        ammount = objIncome.genesis__Amount__c;
                        if(frequency != null){
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
                        totalUnEmpIncome += ammount;
                    }
                    if(objIncome.Other_Income__c == true  && objIncome.genesis__Amount__c != null){
                        frequency = objIncome.genesis__Frequency__c;
                        ammount = objIncome.genesis__Amount__c;
                        if(frequency != null){
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
                        totalOtherIncome += ammount;
                    }
                    if(objIncome.PAYG_Income__c == true  && objIncome.genesis__Amount__c != null){
                        frequency = objIncome.genesis__Frequency__c;
                        ammount = objIncome.genesis__Amount__c;
                        if(frequency != null){
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
                        totalPaygIncome += ammount;
                    }
                    if(objIncome.Document_Type__c != null && objIncome.Document_Type__c == ConstantValues.ALT && objIncome.genesis__Amount__c != null){
                        totalSelfEmpAltDocIncome += objIncome.genesis__Amount__c; 
                    }       
                }
                for(genesis__Employment_Information__c objEmpInfo : objParty.Employment_Information__r){
                    if(objEmpInfo.Total_Current_Income_Period__c != null){
                        totalCurrentIncome += objEmpInfo.Total_Current_Income_Period__c; 
                    }
                }
                objParty.Total_Self_Employed_Income__c = totalCurrentIncome + totalSelfEmpAltDocIncome;
                objParty.Total_Unemployment_Income__c = totalUnEmpIncome;
                objParty.Total_PAYG_Income__c = totalPaygIncome;
                objParty.Total_Other_Income__c = totalOtherIncome;
                objParty.Gross_Taxable_Income__c = totalCurrentIncome + totalSelfEmpAltDocIncome + totalUnEmpIncome + totalPaygIncome + totalOtherIncome; 
            }
            if(objPartyList.size()>0){
                Database.update(objPartyList,false);
            }
            /// To update Telephone number ///
            List<Customer_Call_Automation__c> customerCallList = [SELECT Id,
                                                                    Party__r.clcommon__Contact__c,
                                                                    Telephone_Number__c 
                                                                    FROM Customer_Call_Automation__c 
                                                                    WHERE Party__c in: objPartyList];
            List<Id> contactIdList = new List<Id>();
            for(Customer_Call_Automation__c obj :  customerCallList){
                contactIdList.add(obj.Party__r.clcommon__Contact__c);
            }                                                        
            List<Contact> contactList = [SELECT id,
                                                (
                                                    SELECT id,
                                                    Phone_Number__c
                                                    FROM Telephone_Contact_Number__r
                                                    ORDER BY CreatedDate LIMIT 1
                                                )
                                                FROM Contact
                                                WHERE id in: contactIdList];
            for(Customer_Call_Automation__c obj : customerCallList){
                for(Contact c : contactList){
                    if(obj.Party__r.clcommon__Contact__c == c.id){
                        if(c.Telephone_Contact_Number__r.size()>0){
                            obj.Telephone_Number__c  = c.Telephone_Contact_Number__r[0].Phone_Number__c;
                        }
                    }
                }
            }
            if(customerCallList.size()>0){
                DataBase.update(customerCallList,false);
            }
        }catch(Exception exe) {
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'CustomerCallBatch :Exception: '+exe.getStackTraceString()
                                        +'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
    }
    public void finish(Database.BatchableContext bc){
    }
}