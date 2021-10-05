/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Rameswari Barman
Description : This class is the helper class of UpdateValueDateTrigger and UpdateValuationDateExpiry
Development Date : 09/09/2021
Last Modified Date : 09/09/2021
****************************************************************************************************/ 

global class UpdateFees{
    global static void updateMortgageFees(List <Id> appIds){
        List<genesis__Application_Collateral__c> appCollateralList=new List<genesis__Application_Collateral__c>();
        List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
        try{
            appList = [Select Id,
                                Mortgage_Registration_Fee__c
                                FROM genesis__Applications__c
                                WHERE Id in: appIds
                                ORDER BY Id];
                                
            appCollateralList=[SELECT id,
                                        genesis__Collateral__c,
                                        genesis__Application__c,
                                        genesis__Collateral__r.clcommon__State__c
                                        FROM genesis__Application_Collateral__c 
                                        WHERE genesis__Application__c in: appIds
                                        AND genesis__Collateral__c != NULL
                                        AND genesis__Collateral__r.clcommon__State__c != NULL
                                        ORDER BY genesis__Application__c];

            List <Statewise_MRF_and_Title_Insurace__mdt> mortgageFees = [SELECT Id,
                                                                                    MasterLabel,
                                                                                    Mortgage_Registration_Fee__c 
                                                                                    FROM Statewise_MRF_and_Title_Insurace__mdt 
                                                                                    LIMIT 100];
            Map <String,Decimal> mortgageFeeMap = new Map<String,Decimal>();
            for(Statewise_MRF_and_Title_Insurace__mdt eachMortgageFee : mortgageFees){
                mortgageFeeMap.put(eachMortgageFee.MasterLabel,eachMortgageFee.Mortgage_Registration_Fee__c);
            }

            for(genesis__Applications__c eachApp : appList){
                eachApp.Mortgage_Registration_Fee__c = 0;
                for(genesis__Application_Collateral__c appCollateral : appCollateralList){
                    if(eachApp.Id == appCollateral.genesis__Application__c){
                        if(mortgageFeeMap.get(appCollateral.genesis__Collateral__r.clcommon__State__c) != NULL){
                            eachApp.Mortgage_Registration_Fee__c = eachApp.Mortgage_Registration_Fee__c + mortgageFeeMap.get(appCollateral.genesis__Collateral__r.clcommon__State__c);
                        }
                    }
                }
            }

            update appList;
        }
        catch(Exception e){
            GenericUtility.insertLog('UpdateMortgageRegistrationFees.updateFees', e);
        }
    }
    global static void updateApplicationFees(List <Id> appIds){
        List<genesis__Application_Collateral__c> appCollateralList=new List<genesis__Application_Collateral__c>();
        List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
        try{
            appList = [Select Id,
                                Application_Fee__c,
                                LVR_Used_for_Pricing__c,
                                Document_Type__c,
                                Risk_grade_list__c,
                                genesis__Loan_Amount__c,
                                genesis__CL_Product_Name__c
                                FROM genesis__Applications__c
                                WHERE Id IN: appIds];

            List <Application_Fee_LVR_Doc_Type_Fee_Table__mdt> appFeeMetadataList = [SELECT Id,
                                                                                            MasterLabel,
                                                                                            Near_Prime_Amount__c,
                                                                                            Near_Prime_Plus_Amount__c,
                                                                                            Prime_Amount__c,
                                                                                            Specialist_Amount__c,
                                                                                            Specialist_Plus_Amount__c 
                                                                                            FROM Application_Fee_LVR_Doc_Type_Fee_Table__mdt 
                                                                                            LIMIT 100];

 

            List <Additional_Appication_Fee_on_Loan_Size__mdt> additionalAppFeeMetadataList = [SELECT Id,
                                                                                            MasterLabel,
                                                                                            Additional_Fee_for_Application_Fee__c,
                                                                                            Loan_Size_Lower_Limit__c,
                                                                                            Loan_Size_Upper_Limit__c 
                                                                                            FROM Additional_Appication_Fee_on_Loan_Size__mdt 
                                                                                            LIMIT 100];                                                                               

            if(appFeeMetadataList.size() > 0 && additionalAppFeeMetadataList.size() > 0){
                Map <String,Application_Fee_LVR_Doc_Type_Fee_Table__mdt> appFeeMap = new Map<String,Application_Fee_LVR_Doc_Type_Fee_Table__mdt>();
                for(Application_Fee_LVR_Doc_Type_Fee_Table__mdt eachAppFee : appFeeMetadataList){
                    appFeeMap.put(eachAppFee.MasterLabel,eachAppFee);
                }

                Map <String,Additional_Appication_Fee_on_Loan_Size__mdt> additionalAppFeeMap = new Map<String,Additional_Appication_Fee_on_Loan_Size__mdt>();
                for(Additional_Appication_Fee_on_Loan_Size__mdt eachAppFee : additionalAppFeeMetadataList){
                    additionalAppFeeMap.put(eachAppFee.MasterLabel,eachAppFee);
                }

                for(genesis__Applications__c eachApp : appList){
                    Application_Fee_LVR_Doc_Type_Fee_Table__mdt appFee;
                    eachApp.Application_Fee__c = 0;
                    if(eachApp.Document_Type__c != NULL && 
                        eachApp.Document_Type__c == 'Full Doc' && 
                        eachApp.LVR_Used_for_Pricing__c <= 70 &&
                        eachApp.LVR_Used_for_Pricing__c >= 0 &&
                        appFeeMap.get('Full Doc less than equal to 70') != NULL){
                        appFee = appFeeMap.get('Full Doc less than equal to 70');
                    }
                    else if(eachApp.Document_Type__c != NULL && 
                        eachApp.Document_Type__c == 'Full Doc' && 
                        eachApp.LVR_Used_for_Pricing__c <= 80 &&
                        eachApp.LVR_Used_for_Pricing__c > 70 &&
                        appFeeMap.get('Full Doc Less than 80 greater than 70') != NULL){
                        appFee = appFeeMap.get('Full Doc Less than 80 greater than 70');
                    }
                    else if(eachApp.Document_Type__c != NULL && 
                        eachApp.Document_Type__c == 'Alt Doc' && 
                        eachApp.LVR_Used_for_Pricing__c <= 70 &&
                        eachApp.LVR_Used_for_Pricing__c >= 0 &&
                        appFeeMap.get('Alt Doc less than 70') != NULL){
                        appFee = appFeeMap.get('Alt Doc less than 70');
                    }
                    else if(eachApp.Document_Type__c != NULL && 
                        eachApp.Document_Type__c == 'Alt Doc' && 
                        eachApp.LVR_Used_for_Pricing__c <= 80 &&
                        eachApp.LVR_Used_for_Pricing__c > 70 &&
                        appFeeMap.get('Alt Doc Less than 80 greater than 70') != NULL){
                        appFee = appFeeMap.get('Alt Doc Less than 80 greater than 70');
                    }

                    if(appFee != NULL){
                        if(eachApp.Risk_grade_list__c == 'Prime'){
                            if(appFee.Prime_Amount__c != NULL && appFee.Prime_Amount__c != '' && (appFee.Prime_Amount__c).contains('%')){
                                String riskPercentage = appFee.Prime_Amount__c;
                                Decimal basePercentage = Decimal.ValueOf(riskPercentage.substring(0,riskPercentage.length()-1));
                                eachApp.Application_Fee__c = (basePercentage/100)*(eachApp.genesis__Loan_Amount__c);
                            }
                            else {
                                eachApp.Application_Fee__c = Decimal.ValueOf(appFee.Prime_Amount__c);
                            }
                        }
                        else if(eachApp.Risk_grade_list__c == 'Near Prime'){
                            if(appFee.Near_Prime_Amount__c != NULL && appFee.Near_Prime_Amount__c != '' && (appFee.Near_Prime_Amount__c).contains('%')){
                                String riskPercentage = appFee.Near_Prime_Amount__c;
                                Decimal basePercentage = Decimal.ValueOf(riskPercentage.substring(0,riskPercentage.length()-1));
                                eachApp.Application_Fee__c = (basePercentage/100)*(eachApp.genesis__Loan_Amount__c);
                            }
                            else {
                                eachApp.Application_Fee__c = Decimal.ValueOf(appFee.Near_Prime_Amount__c);
                            }
                        }
                        else if(eachApp.Risk_grade_list__c == 'Near Prime +'){
                            if(appFee.Near_Prime_Plus_Amount__c != NULL && appFee.Near_Prime_Plus_Amount__c != '' && (appFee.Near_Prime_Plus_Amount__c).contains('%')){
                                String riskPercentage = appFee.Near_Prime_Plus_Amount__c;
                                Decimal basePercentage = Decimal.ValueOf(riskPercentage.substring(0,riskPercentage.length()-1));
                                eachApp.Application_Fee__c = (basePercentage/100)*(eachApp.genesis__Loan_Amount__c);
                            }
                            else {
                                eachApp.Application_Fee__c = Decimal.ValueOf(appFee.Near_Prime_Plus_Amount__c);
                            }
                        }
                        else if(eachApp.Risk_grade_list__c == 'Specialist'){
                            if(appFee.Specialist_Amount__c != NULL && appFee.Specialist_Amount__c != '' && (appFee.Specialist_Amount__c).contains('%')){
                                String riskPercentage = appFee.Specialist_Amount__c;
                                Decimal basePercentage = Decimal.ValueOf(riskPercentage.substring(0,riskPercentage.length()-1));
                                eachApp.Application_Fee__c = (basePercentage/100)*(eachApp.genesis__Loan_Amount__c);
                            }
                            else {
                                eachApp.Application_Fee__c = Decimal.ValueOf(appFee.Specialist_Amount__c);
                            }
                        }
                        else if(eachApp.Risk_grade_list__c == 'Specialist +'){
                            if(appFee.Specialist_Plus_Amount__c != NULL && appFee.Specialist_Plus_Amount__c != '' && (appFee.Specialist_Plus_Amount__c).contains('%')){
                                String riskPercentage = appFee.Specialist_Plus_Amount__c;
                                Decimal basePercentage = Decimal.ValueOf(riskPercentage.substring(0,riskPercentage.length()-1));
                                eachApp.Application_Fee__c = (basePercentage/100)*(eachApp.genesis__Loan_Amount__c);
                            }
                            else {
                                eachApp.Application_Fee__c = Decimal.ValueOf(appFee.Specialist_Plus_Amount__c);
                            }
                        }
                    }

                    appCollateralList=[SELECT id,
                                        genesis__Collateral__c,
                                        genesis__Application__c
                                        FROM genesis__Application_Collateral__c 
                                        WHERE genesis__Application__c in: appIds
                                        AND genesis__Collateral__c != NULL
                                        AND genesis__Collateral__r.clcommon__Status__c = 'Vacant Land'
                                        ORDER BY genesis__Application__c];

                    Set <Id> appSet = new Set<Id>();
                    for(genesis__Application_Collateral__c eachAppCollateral : appCollateralList){
                        appSet.add(eachAppCollateral.genesis__Application__c);
                    }
                    if(appSet.contains(eachApp.Id) && 
                        (additionalAppFeeMap.get('Vacant Land Details Limit')).Additional_Fee_for_Application_Fee__c != NULL && 
                        (additionalAppFeeMap.get('Vacant Land Details Limit')).Additional_Fee_for_Application_Fee__c > 0){
                        eachApp.Application_Fee__c = eachApp.Application_Fee__c + ((((additionalAppFeeMap.get('Vacant Land Details Limit')).Additional_Fee_for_Application_Fee__c))/100)*eachApp.genesis__Loan_Amount__c;
                            
                    }
                    else if(eachApp.genesis__Loan_Amount__c != NULL 
                        && eachApp.genesis__Loan_Amount__c >= 1000000 
                        && eachApp.genesis__Loan_Amount__c <= 1500000 && 
                        additionalAppFeeMap.get('Between $1mil and $1.5mil') != NULL){
                        eachApp.Application_Fee__c = eachApp.Application_Fee__c + ((((additionalAppFeeMap.get('Between $1mil and $1.5mil')).Additional_Fee_for_Application_Fee__c))/100)*eachApp.genesis__Loan_Amount__c;
                        
                    }
                    else if(eachApp.genesis__Loan_Amount__c != NULL
                        && eachApp.genesis__Loan_Amount__c > 1500000
                        && eachApp.genesis__Loan_Amount__c <= 2000000
                        && additionalAppFeeMap.get('Between $1.5mil and $2mil') != NULL){
                        eachApp.Application_Fee__c = eachApp.Application_Fee__c + ((((additionalAppFeeMap.get('Between $1.5mil and $2mil')).Additional_Fee_for_Application_Fee__c))/100)*eachApp.genesis__Loan_Amount__c;
                    }
                }
                update appList;
            }   
        }
        catch(Exception e){
            GenericUtility.insertLog('UpdateMortgageRegistrationFees.updateFees', e);
        }
    }

    global static void updateTitleInsuranceFees(List<Id> appIds){
        List<genesis__Application_Collateral__c> appCollateralList=new List<genesis__Application_Collateral__c>();
        List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
        try{
            List <Statewise_MRF_and_Title_Insurace__mdt> mortgageFees = [SELECT Id,
                                                                                    MasterLabel,
                                                                                    Stamp_Duty__c 
                                                                                    FROM Statewise_MRF_and_Title_Insurace__mdt 
                                                                                    LIMIT 100];

            Map <String,Decimal> mortgageFeeMap = new Map<String,Decimal>();
            for(Statewise_MRF_and_Title_Insurace__mdt eachMortgageFee : mortgageFees){
                mortgageFeeMap.put(eachMortgageFee.MasterLabel,eachMortgageFee.Stamp_Duty__c);
            }

            appList = [Select Id,
                                genesis__Loan_Amount__c,
                                Title_Insurance_Fee__c,
                                Mortgage_Registration_Fee__c
                                FROM genesis__Applications__c
                                WHERE Id in: appIds
                                ORDER BY Id];

            appCollateralList=[SELECT id,
                                        genesis__Collateral__c,
                                        genesis__Application__c,
                                        genesis__Collateral__r.clcommon__State__c,
                                        genesis__Collateral__r.Primary_Usage__c,
                                        genesis__Collateral__r.Primary_Security__c
                                        FROM genesis__Application_Collateral__c 
                                        WHERE genesis__Application__c in: appIds
                                        AND genesis__Collateral__c != NULL
                                        AND genesis__Collateral__r.clcommon__State__c != NULL
                                        AND genesis__Collateral__r.Primary_Usage__c != NULL
                                        ORDER BY genesis__Application__c,genesis__Collateral__r.Primary_Security__c];

            List <Title_Insurance_Fee_Base_Premium_and_GST__mdt> titleFeesMetadataList = [SELECT Id,
                                                                                                    MasterLabel,
                                                                                                    Additional_Fee_per_Unit__c,
                                                                                                    Base_Premium__c,
                                                                                                    Base_Premiumum_Unit__c,
                                                                                                    GST__c
                                                                                                    FROM Title_Insurance_Fee_Base_Premium_and_GST__mdt 
                                                                                                    LIMIT 100];

            Map <String,Title_Insurance_Fee_Base_Premium_and_GST__mdt> titleInsFeeMap = new Map<String,Title_Insurance_Fee_Base_Premium_and_GST__mdt>();
            for(Title_Insurance_Fee_Base_Premium_and_GST__mdt eachTitleFee : TitleFeesMetadataList){
                titleInsFeeMap.put(eachTitleFee.MasterLabel,eachTitleFee);
            }

            Map <Id,Integer> appCollateralMap = new Map <Id,Integer>();
            Integer size=0;
            Decimal stampDuty=0;
            for(genesis__Application_Collateral__c appCollateral : appCollateralList){
                appCollateralMap.put(appCollateral.id,size);
                size+=1;
            }
            for(genesis__Applications__c eachApp : appList){
                eachApp.Title_Insurance_Fee__c = 0;
                for(genesis__Application_Collateral__c appCollateral : appCollateralList){
                    if(eachApp.Id == appCollateral.genesis__Application__c 
                        && appCollateralMap.size() > 0 
                        && appCollateralMap.get(appCollateral.id) != NULL 
                        && appCollateralMap.get(appCollateral.id) == 0
                    ){
                        if(appCollateral.genesis__Collateral__r.Primary_Usage__c == 'Residential'){
                            if(eachApp.genesis__Loan_Amount__c <= 600000 
                                && titleInsFeeMap.get('Residential <= 600000') != NULL 
                                && (titleInsFeeMap.get('Residential <= 600000')).Base_Premium__c != NULL 
                                && (titleInsFeeMap.get('Residential <= 600000')).GST__c != NULL){
                                eachApp.Title_Insurance_Fee__c = titleInsFeeMap.get('Residential <= 600000').Base_Premium__c + titleInsFeeMap.get('Residential <= 600000').GST__c; 
                                
                            }
                            else if(eachApp.genesis__Loan_Amount__c > 600000 
                                && eachApp.genesis__Loan_Amount__c <= 1000000
                                && titleInsFeeMap.get('Residential >= 600001 and <=1000000') != NULL 
                                && (titleInsFeeMap.get('Residential >= 600001 and <=1000000')).Base_Premium__c != NULL 
                                && (titleInsFeeMap.get('Residential >= 600001 and <=1000000')).GST__c != NULL){
                                eachApp.Title_Insurance_Fee__c = titleInsFeeMap.get('Residential >= 600001 and <=1000000').Base_Premium__c + 
                                    titleInsFeeMap.get('Residential >= 600001 and <=1000000').GST__c;                                

                            }
                            else if(eachApp.genesis__Loan_Amount__c > 1000000 
                                && eachApp.genesis__Loan_Amount__c <= 2000000
                                && titleInsFeeMap.get('Residential >= 1000001 and <= 2000000') != NULL 
                                && (titleInsFeeMap.get('Residential >= 1000001 and <= 2000000')).Base_Premium__c != NULL 
                                && (titleInsFeeMap.get('Residential >= 1000001 and <= 2000000')).GST__c != NULL){
                                    eachApp.Title_Insurance_Fee__c = titleInsFeeMap.get('Residential >= 1000001 and <= 2000000').Base_Premium__c +
                                    titleInsFeeMap.get('Residential >= 1000001 and <= 2000000').GST__c;
                            }
                            else if(eachApp.genesis__Loan_Amount__c > 2000000 
                                && eachApp.genesis__Loan_Amount__c <= 3000000
                                && titleInsFeeMap.get('Residential >= 2000001 and <= 3000000') != NULL 
                                && (titleInsFeeMap.get('Residential >= 2000001 and <= 3000000')).Base_Premium__c != NULL 
                                && (titleInsFeeMap.get('Residential >= 2000001 and <= 3000000')).GST__c != NULL){
                                eachApp.Title_Insurance_Fee__c = titleInsFeeMap.get('Residential >= 2000001 and <= 3000000').Base_Premium__c + 
                                    titleInsFeeMap.get('Residential >= 2000001 and <= 3000000').GST__c;
                            }
                            else if(eachApp.genesis__Loan_Amount__c > 3000000 
                                && eachApp.genesis__Loan_Amount__c <= 4000000
                                && titleInsFeeMap.get('Residential >= 3000001 and <= 4000000') != NULL 
                                && (titleInsFeeMap.get('Residential >= 3000001 and <= 4000000')).Base_Premium__c != NULL 
                                && (titleInsFeeMap.get('Residential >= 3000001 and <= 4000000')).GST__c != NULL){
                                eachApp.Title_Insurance_Fee__c = titleInsFeeMap.get('Residential >= 3000001 and <= 4000000').Base_Premium__c + titleInsFeeMap.get('Residential >= 3000001 and <= 4000000').GST__c;
                            }
                        }
                        else if(appCollateral.genesis__Collateral__r.Primary_Usage__c == 'Commercial'){
                            if(eachApp.genesis__Loan_Amount__c <= 500000 
                                && titleInsFeeMap.get('Commercial <=500000') != NULL 
                                && (titleInsFeeMap.get('Commercial <=500000')).Base_Premium__c != NULL 
                                && (titleInsFeeMap.get('Commercial <=500000')).GST__c != NULL){
                                eachApp.Title_Insurance_Fee__c = titleInsFeeMap.get('Commercial <=500000').Base_Premium__c + 
                                    titleInsFeeMap.get('Commercial <=500000').GST__c;
                            }
                            else if(eachApp.genesis__Loan_Amount__c > 500000 
                                && titleInsFeeMap.get('Commercial >=500001') != NULL 
                                && (titleInsFeeMap.get('Commercial >=500001')).Base_Premium__c != NULL 
                                && (titleInsFeeMap.get('Commercial >=500001')).GST__c != NULL
                                && (titleInsFeeMap.get('Commercial >=500001')).Additional_Fee_per_Unit__c !=NULL){
                                eachApp.Title_Insurance_Fee__c = titleInsFeeMap.get('Commercial >=500001').Base_Premium__c + 
                                    titleInsFeeMap.get('Commercial >=500001').GST__c;
                                    eachApp.Title_Insurance_Fee__c += (titleInsFeeMap.get('Commercial >=500001')).Additional_Fee_per_Unit__c * 
                                        ((eachApp.genesis__Loan_Amount__c-500000)/(titleInsFeeMap.get('Commercial >=500001').Base_Premiumum_Unit__c));
                            }
                        }
                        
                        if(eachApp.Id == appCollateral.genesis__Application__c 
                            && appCollateralMap.size() > 0 
                            && appCollateralMap.get(appCollateral.id) != NULL 
                            && size>1){
                            eachApp.Title_Insurance_Fee__c += (Decimal.ValueOf(System.Label.Each_Additional_Property_Title_Insurance_Fee)+
                            Decimal.ValueOf(System.Label.Each_Additional_Property_Title_Insurance_GST_Fee))*(size-1);
                        }
                        
                    }
                    if(mortgageFeeMap.get(appCollateral.genesis__Collateral__r.clcommon__State__c) != NULL){
                        if(stampDuty<((eachApp.Title_Insurance_Fee__c)*(mortgageFeeMap.get(appCollateral.genesis__Collateral__r.clcommon__State__c)/100)))
                        stampDuty=(eachApp.Title_Insurance_Fee__c)*(mortgageFeeMap.get(appCollateral.genesis__Collateral__r.clcommon__State__c)/100);
                        
                    }
                }
                eachApp.Title_Insurance_Fee__c += stampDuty;
            }
            update appList;
        }
        catch(Exception e){
            GenericUtility.insertLog('UpdateMortgageRegistrationFees.updateFees', e);
        }
    }
}