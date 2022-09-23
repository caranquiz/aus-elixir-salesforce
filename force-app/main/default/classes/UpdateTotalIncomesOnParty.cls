global with sharing class UpdateTotalIncomesOnParty {
    webService static void updateIncomesWS(Id partyId) {
        try{
            Double totalUnEmpIncome = 0;
            Double totalPaygIncome = 0;
            Double totalOtherIncome = 0;
            Double totalCurrentIncome = 0;
            String frequency;
            Double ammount = 0;
            Double totalSelfEmpAltDocIncome = 0;
            clcommon__Party__c objParty = [SELECT id,
                                                Name,
                                                Total_Unemployment_Income__c,
                                                Total_Other_Income__c,
                                                Total_PAYG_Income__c,
                                                Total_Self_Employed_Income__c,
                                                Gross_Taxable_Income__c,
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
                                                WHERE id =: partyId];
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
                    System.debug('amount -> ' + ammount);
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
            update objParty;
        }
        catch(Exception e){
            GenericUtility.insertLog('UpdateTotalIncomesOnParty', e);
        }
    }
}