/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Rameswari Barman
Description : This class is the helper class of UpdateValueDateTrigger and UpdateValuationDateExpiry
Development Date : 09/09/2021
Last Modified Date : 09/09/2021
****************************************************************************************************/ 

global class UpdateFees{
    global static void updateMortgageFees(List <Id> appIds){
        
        List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
        List <Statewise_MRF_and_Title_Insurace__mdt> mortgageFees=new List <Statewise_MRF_and_Title_Insurace__mdt>();
        Map <String,Decimal> mortgageFeeMap = new Map<String,Decimal>();
        try{
            appList = [SELECT Id,
                            Mortgage_Registration_Fee__c,
                            (SELECT id,
                                    genesis__Collateral__c,
                                    genesis__Application__c,
                                    genesis__Collateral__r.clcommon__State__c
                                FROM genesis__Application_Collaterals__r
                                WHERE genesis__Collateral__c != NULL
                                AND genesis__Collateral__r.clcommon__State__c != NULL)
                        FROM genesis__Applications__c
                        WHERE Id in: appIds
                        ORDER BY Id];
                                

            mortgageFees = [SELECT Id,
                                MasterLabel,
                                Mortgage_Registration_Fee__c 
                            FROM Statewise_MRF_and_Title_Insurace__mdt 
                            LIMIT 100];
            
            for(Statewise_MRF_and_Title_Insurace__mdt eachMortgageFee : mortgageFees){
                mortgageFeeMap.put(eachMortgageFee.MasterLabel,eachMortgageFee.Mortgage_Registration_Fee__c);
            }

            for(genesis__Applications__c eachApp : appList){
                eachApp.Mortgage_Registration_Fee__c = 0;
                for(genesis__Application_Collateral__c appCollateral : eachApp.genesis__Application_Collaterals__r){
                    if(mortgageFeeMap.get(appCollateral.genesis__Collateral__r.clcommon__State__c) != NULL){
                        eachApp.Mortgage_Registration_Fee__c = eachApp.Mortgage_Registration_Fee__c + mortgageFeeMap.get(appCollateral.genesis__Collateral__r.clcommon__State__c);
                    }                    
                }
            }
            update appList;
        }
        catch(Exception e){
            GenericUtility.insertLog('UpdateFees.updateMortgageFees', e);
        }
    }
    global static void updateApplicationFees(List <Id> appIds){

        List<genesis__Application_Collateral__c> appCollateralList=new List<genesis__Application_Collateral__c>();
        List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
        List <Application_Fee_LVR_Doc_Type_Fee_Table__mdt> appFeeMetadataList=new List <Application_Fee_LVR_Doc_Type_Fee_Table__mdt>();
        List <Additional_Appication_Fee_on_Loan_Size__mdt> additionalAppFeeMetadataList=new List <Additional_Appication_Fee_on_Loan_Size__mdt>();
        Set <Id> appSet = new Set<Id>();
        
        try{
            appList = [SELECT Id,
                            Application_Fee__c,
                            LVR_Used_for_Pricing__c,
                            Document_Type__c,
                            Risk_grade_list__c,
                            genesis__Loan_Amount__c,
                            genesis__CL_Product_Name__c
                        FROM genesis__Applications__c
                        WHERE Id IN: appIds];
            
            appCollateralList=[SELECT id,
                                    genesis__Collateral__c,
                                    genesis__Application__c
                                FROM genesis__Application_Collateral__c 
                                WHERE genesis__Application__c in: appIds
                                AND genesis__Collateral__c != NULL
                                AND genesis__Collateral__r.clcommon__Status__c =: ConstantValues.VACANT_LAND
                                ORDER BY genesis__Application__c];

            appFeeMetadataList = [SELECT Id,
                                        MasterLabel,
                                        Near_Prime_Amount__c,
                                        Near_Prime_Plus_Amount__c,
                                        Prime_Amount__c,
                                        Specialist_Amount__c,
                                        Specialist_Plus_Amount__c 
                                    FROM Application_Fee_LVR_Doc_Type_Fee_Table__mdt 
                                    LIMIT 100];

            additionalAppFeeMetadataList = [SELECT Id,
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
                    if(eachApp.Document_Type__c != NULL  
                            && eachApp.Document_Type__c == ConstantValues.FULL_DOC 
                            && eachApp.LVR_Used_for_Pricing__c <= 70 
                            && eachApp.LVR_Used_for_Pricing__c >= 0 
                            && appFeeMap.get(ConstantValues.FULL_DOC_LESS_THAN_EQUAL_TO_SEVENTY) != NULL
                    ){
                        appFee = appFeeMap.get(ConstantValues.FULL_DOC_LESS_THAN_EQUAL_TO_SEVENTY);
                    }
                    else if(eachApp.Document_Type__c != NULL  
                            && eachApp.Document_Type__c == ConstantValues.FULL_DOC  
                            && eachApp.LVR_Used_for_Pricing__c <= 80 
                            && eachApp.LVR_Used_for_Pricing__c > 70 
                            && appFeeMap.get(ConstantValues.FULL_dOC_LESS_THAN_EIGHTY_GREATER_THAN_SEVENTY) != NULL){
                        appFee = appFeeMap.get(ConstantValues.FULL_dOC_LESS_THAN_EIGHTY_GREATER_THAN_SEVENTY);
                    }
                    else if(eachApp.Document_Type__c != NULL  
                            && eachApp.Document_Type__c == ConstantValues.ALT_DOC  
                            && eachApp.LVR_Used_for_Pricing__c <= 70 
                            && eachApp.LVR_Used_for_Pricing__c >= 0 
                            && appFeeMap.get(ConstantValues.ALT_LESS_THAN_SEVENTY) != NULL){
                        appFee = appFeeMap.get(ConstantValues.ALT_LESS_THAN_SEVENTY);
                    }
                    else if(eachApp.Document_Type__c != NULL  
                            && eachApp.Document_Type__c == ConstantValues.ALT_DOC  
                            && eachApp.LVR_Used_for_Pricing__c <= 80 
                            && eachApp.LVR_Used_for_Pricing__c > 70 
                            && appFeeMap.get(ConstantValues.ALT_DOC_LESS_THAN_EIGHTY_GREATER_THAN_SEVENTY) != NULL){
                        appFee = appFeeMap.get(ConstantValues.ALT_DOC_LESS_THAN_EIGHTY_GREATER_THAN_SEVENTY);
                    }

                    if(appFee != NULL){
                        applicationFeeCalculation(appFee,eachApp);
                    }

                    for(genesis__Application_Collateral__c eachAppCollateral : appCollateralList){
                        appSet.add(eachAppCollateral.genesis__Application__c);
                    }
                    if(appSet.contains(eachApp.Id) 
                            && eachApp.genesis__Loan_Amount__c!=NULL 
                            && (additionalAppFeeMap.get(ConstantValues.VACANT_LAND_DETAILS_LIMIT)).Additional_Fee_for_Application_Fee__c != NULL  
                            && (additionalAppFeeMap.get(ConstantValues.VACANT_LAND_DETAILS_LIMIT)).Additional_Fee_for_Application_Fee__c > 0){
                        eachApp.Application_Fee__c = eachApp.Application_Fee__c + ((((additionalAppFeeMap.get(ConstantValues.VACANT_LAND_DETAILS_LIMIT)).Additional_Fee_for_Application_Fee__c))/100)*eachApp.genesis__Loan_Amount__c;
                            
                    }
                    else if(eachApp.genesis__Loan_Amount__c != NULL 
                            && eachApp.genesis__Loan_Amount__c >= 1000000 
                            && eachApp.genesis__Loan_Amount__c <= 1500000 
                            && additionalAppFeeMap.get(ConstantValues.BETWEEN_ONE_AND_ONE_POINT_FIVE) != NULL){
                        eachApp.Application_Fee__c = eachApp.Application_Fee__c + ((((additionalAppFeeMap.get(ConstantValues.BETWEEN_ONE_AND_ONE_POINT_FIVE)).Additional_Fee_for_Application_Fee__c))/100)*eachApp.genesis__Loan_Amount__c;
                        
                    }
                    else if(eachApp.genesis__Loan_Amount__c != NULL
                            && eachApp.genesis__Loan_Amount__c > 1500000
                            && eachApp.genesis__Loan_Amount__c <= 2000000
                            && additionalAppFeeMap.get(ConstantValues.BETWEEN_ONE_POINT_FIVE_AND_TWO) != NULL){
                        eachApp.Application_Fee__c = eachApp.Application_Fee__c + ((((additionalAppFeeMap.get(ConstantValues.BETWEEN_ONE_POINT_FIVE_AND_TWO)).Additional_Fee_for_Application_Fee__c))/100)*eachApp.genesis__Loan_Amount__c;
                    }
                }
                update appList;
            }   
        }
        catch(Exception e){
            GenericUtility.insertLog('UpdateFees.updateApplicationFees', e);
        }
    }

    global static void updateTitleInsuranceFees(List<Id> appIds){

        List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
        List <Statewise_MRF_and_Title_Insurace__mdt> mortgageFees=new List <Statewise_MRF_and_Title_Insurace__mdt>();
        Map <String,Decimal> mortgageFeeMap = new Map<String,Decimal>();
        List <Title_Insurance_Fee_Base_Premium_and_GST__mdt> titleFeesMetadataList=new List <Title_Insurance_Fee_Base_Premium_and_GST__mdt>();
        Map <String,Title_Insurance_Fee_Base_Premium_and_GST__mdt> titleInsFeeMap = new Map<String,Title_Insurance_Fee_Base_Premium_and_GST__mdt>();
        Map <Id,Integer> appCollateralMap = new Map <Id,Integer>();
        Integer size=0;
        Decimal stampDuty=0;

        try{
            mortgageFees = [SELECT Id,
                                  MasterLabel,
                                  Stamp_Duty__c 
                              FROM Statewise_MRF_and_Title_Insurace__mdt 
                              LIMIT 100];

            for(Statewise_MRF_and_Title_Insurace__mdt eachMortgageFee : mortgageFees){
                mortgageFeeMap.put(eachMortgageFee.MasterLabel,eachMortgageFee.Stamp_Duty__c);
            }

            appList = [SELECT Id,
                            genesis__Loan_Amount__c,
                            Title_Insurance_Fee__c,
                            Mortgage_Registration_Fee__c,
                            (SELECT id,
                                    genesis__Collateral__c,
                                    genesis__Application__c,
                                    genesis__Collateral__r.clcommon__State__c,
                                    genesis__Collateral__r.Primary_Usage__c,
                                    genesis__Collateral__r.Primary_Security__c
                                FROM genesis__Application_Collaterals__r 
                                WHERE genesis__Collateral__c != NULL
                                AND genesis__Collateral__r.clcommon__State__c != NULL
                                AND genesis__Collateral__r.Primary_Usage__c != NULL)
                        FROM genesis__Applications__c
                        WHERE Id in: appIds
                        ORDER BY Id];

            titleFeesMetadataList = [SELECT Id,
                                            MasterLabel,
                                            Additional_Fee_per_Unit__c,
                                            Base_Premium__c,
                                            Base_Premiumum_Unit__c,
                                            GST__c
                                        FROM Title_Insurance_Fee_Base_Premium_and_GST__mdt 
                                        LIMIT 100];

            for(Title_Insurance_Fee_Base_Premium_and_GST__mdt eachTitleFee : TitleFeesMetadataList){
                titleInsFeeMap.put(eachTitleFee.MasterLabel,eachTitleFee);
            }
            for(genesis__Applications__c eachApp : appList){
                for(genesis__Application_Collateral__c appCollateral : eachApp.genesis__Application_Collaterals__r){
                    appCollateralMap.put(appCollateral.id,size);
                    size+=1;
                }
            }
            for(genesis__Applications__c eachApp : appList){
                eachApp.Title_Insurance_Fee__c = 0;
                for(genesis__Application_Collateral__c appCollateral : eachApp.genesis__Application_Collaterals__r){
                    if( appCollateralMap.size() > 0 
                            && appCollateralMap.get(appCollateral.id) != NULL 
                            && appCollateralMap.get(appCollateral.id) == 0
                    ){
                        titleInsuranceFeesCalculation(appCollateral, eachApp, titleInsFeeMap);

                        if(eachApp.Id == appCollateral.genesis__Application__c 
                                && appCollateralMap.size() > 0 
                                && appCollateralMap.get(appCollateral.id) != NULL 
                                && size>1){
                            eachApp.Title_Insurance_Fee__c += (Decimal.ValueOf(System.Label.Each_Additional_Property_Title_Insurance_Fee)+
                            Decimal.ValueOf(System.Label.Each_Additional_Property_Title_Insurance_GST_Fee))*(size-1);
                        }
                    }
                    if(mortgageFeeMap.get(appCollateral.genesis__Collateral__r.clcommon__State__c) != NULL && appCollateral.genesis__Collateral__r.Primary_Security__c=='Yes'){
                        stampDuty=(eachApp.Title_Insurance_Fee__c)*(mortgageFeeMap.get(appCollateral.genesis__Collateral__r.clcommon__State__c));
                        
                    }
                }
                eachApp.Title_Insurance_Fee__c = stampDuty;
            }
            update appList;
        }
        catch(Exception e){
            GenericUtility.insertLog('UpdateFees.updateFees', e);
        }
    }
    public static void applicationFeeCalculation(Application_Fee_LVR_Doc_Type_Fee_Table__mdt appFee,genesis__Applications__c eachApp){
        if(eachApp.Risk_grade_list__c == ConstantValues.PRIME){
            if(appFee.Prime_Amount__c != NULL && appFee.Prime_Amount__c != '' && (appFee.Prime_Amount__c).contains('%')){
                calculateApplicationFeeAmount(appFee.Prime_Amount__c, eachApp);
            }
            else {
                eachApp.Application_Fee__c = Decimal.ValueOf(appFee.Prime_Amount__c);
            }
        }
        else if(eachApp.Risk_grade_list__c == ConstantValues.NEAR_PRIME){
            if(appFee.Near_Prime_Amount__c != NULL && appFee.Near_Prime_Amount__c != '' && (appFee.Near_Prime_Amount__c).contains('%')){
                calculateApplicationFeeAmount(appFee.Near_Prime_Amount__c, eachApp);
            }
            else {
                eachApp.Application_Fee__c = Decimal.ValueOf(appFee.Near_Prime_Amount__c);
            }
        }
        else if(eachApp.Risk_grade_list__c == ConstantValues.NEAR_PRIME_PLUS){
            if(appFee.Near_Prime_Plus_Amount__c != NULL && appFee.Near_Prime_Plus_Amount__c != '' && (appFee.Near_Prime_Plus_Amount__c).contains('%')){
                calculateApplicationFeeAmount(appFee.Near_Prime_Plus_Amount__c, eachApp);
            }
            else {
                eachApp.Application_Fee__c = Decimal.ValueOf(appFee.Near_Prime_Plus_Amount__c);
            }
        }
        else if(eachApp.Risk_grade_list__c == ConstantValues.SPECIALIST){
            if(appFee.Specialist_Amount__c != NULL && appFee.Specialist_Amount__c != '' && (appFee.Specialist_Amount__c).contains('%')){
                calculateApplicationFeeAmount(appFee.Specialist_Amount__c, eachApp);
            }
            else {
                eachApp.Application_Fee__c = Decimal.ValueOf(appFee.Specialist_Amount__c);
            }
        }
        else if(eachApp.Risk_grade_list__c == ConstantValues.SPECIALIST_PLUS){
            if(appFee.Specialist_Plus_Amount__c != NULL && appFee.Specialist_Plus_Amount__c != '' && (appFee.Specialist_Plus_Amount__c).contains('%')){
                calculateApplicationFeeAmount(appFee.Specialist_Plus_Amount__c, eachApp);
            }
            else {
                eachApp.Application_Fee__c = Decimal.ValueOf(appFee.Specialist_Plus_Amount__c);
            }
        }
    }
    public static void titleInsuranceFeesCalculation(genesis__Application_Collateral__c appCollateral,genesis__Applications__c eachApp,Map <String,Title_Insurance_Fee_Base_Premium_and_GST__mdt> titleInsFeeMap){
        
        if(appCollateral.genesis__Collateral__r.Primary_Usage__c == ConstantValues.RESIDENTIAL){
            if(eachApp.genesis__Loan_Amount__c <= 600000 
                    && titleInsFeeMap.get(ConstantValues.RESIDENTIAL_LESS_THAN_600000) != NULL ){
                    calculateTitleInsuranceFeeAmount(titleInsFeeMap.get(ConstantValues.RESIDENTIAL_LESS_THAN_600000), eachApp);
            }
            else if(eachApp.genesis__Loan_Amount__c > 600000 
                    && eachApp.genesis__Loan_Amount__c <= 1000000
                    && titleInsFeeMap.get(ConstantValues.RESIDENTIAL_GREATER_THAN_600000_AND_LESS_THAN_1000000) != NULL ){
                calculateTitleInsuranceFeeAmount(titleInsFeeMap.get(ConstantValues.RESIDENTIAL_GREATER_THAN_600000_AND_LESS_THAN_1000000), eachApp);
            }
            else if(eachApp.genesis__Loan_Amount__c > 1000000 
                    && eachApp.genesis__Loan_Amount__c <= 2000000
                    && titleInsFeeMap.get(ConstantValues.RESIDENTIAL_GREATER_THAN_1000000_AND_LESS_THAN_2000000) != NULL ){
                calculateTitleInsuranceFeeAmount(titleInsFeeMap.get(ConstantValues.RESIDENTIAL_GREATER_THAN_1000000_AND_LESS_THAN_2000000), eachApp);
            }
            else if(eachApp.genesis__Loan_Amount__c > 2000000 
                    && eachApp.genesis__Loan_Amount__c <= 3000000
                    && titleInsFeeMap.get(ConstantValues.RESIDENTIAL_GREATER_THAN_2000000_AND_LESS_THAN_3000000) != NULL ){                
                calculateTitleInsuranceFeeAmount(titleInsFeeMap.get(ConstantValues.RESIDENTIAL_GREATER_THAN_2000000_AND_LESS_THAN_3000000), eachApp);

            }
            else if(eachApp.genesis__Loan_Amount__c > 3000000 
                    && eachApp.genesis__Loan_Amount__c <= 4000000
                    && titleInsFeeMap.get(ConstantValues.RESIDENTIAL_GREATER_THAN_3000000_AND_LESS_THAN_4000000) != NULL ){
                calculateTitleInsuranceFeeAmount(titleInsFeeMap.get(ConstantValues.RESIDENTIAL_GREATER_THAN_3000000_AND_LESS_THAN_4000000), eachApp);
            }
        }
        else if(appCollateral.genesis__Collateral__r.Primary_Usage__c == ConstantValues.COMMERCIAL){
            if(eachApp.genesis__Loan_Amount__c <= 500000 
                    && titleInsFeeMap.get(ConstantValues.COMMERCIAL_LESS_THAN_500000) != NULL 
            ){                    
                calculateTitleInsuranceFeeAmount(titleInsFeeMap.get(ConstantValues.COMMERCIAL_LESS_THAN_500000), eachApp);
            }
            else if(eachApp.genesis__Loan_Amount__c > 500000 
                    && titleInsFeeMap.get(ConstantValues.COMMERCIAL_GREATER_THAN_500000) != NULL 
                    && (titleInsFeeMap.get(ConstantValues.COMMERCIAL_GREATER_THAN_500000)).Base_Premium__c != NULL 
                    && (titleInsFeeMap.get(ConstantValues.COMMERCIAL_GREATER_THAN_500000)).GST__c != NULL
                    && (titleInsFeeMap.get(ConstantValues.COMMERCIAL_GREATER_THAN_500000)).Additional_Fee_per_Unit__c !=NULL
            ){
                eachApp.Title_Insurance_Fee__c = titleInsFeeMap.get(ConstantValues.COMMERCIAL_GREATER_THAN_500000).Base_Premium__c + 
                    titleInsFeeMap.get(ConstantValues.COMMERCIAL_GREATER_THAN_500000).GST__c;
                    eachApp.Title_Insurance_Fee__c += (titleInsFeeMap.get(ConstantValues.COMMERCIAL_GREATER_THAN_500000)).Additional_Fee_per_Unit__c * 
                        ((eachApp.genesis__Loan_Amount__c-500000)/(titleInsFeeMap.get(ConstantValues.COMMERCIAL_GREATER_THAN_500000).Base_Premiumum_Unit__c));
            }
        }       
    }
    public static void calculateApplicationFeeAmount(String amount,genesis__Applications__c eachApp){
        String riskPercentage = amount;
        Decimal basePercentage = Decimal.ValueOf(riskPercentage.substring(0,riskPercentage.length()-1));
        if(eachApp.genesis__Loan_Amount__c!=NULL){
            eachApp.Application_Fee__c = (basePercentage/100)*(eachApp.genesis__Loan_Amount__c);            
        }
    }
    public static void calculateTitleInsuranceFeeAmount(Title_Insurance_Fee_Base_Premium_and_GST__mdt titleInsFee,genesis__Applications__c eachApp){
            if((titleInsFee).Base_Premium__c != NULL 
                && (titleInsFee).GST__c != NULL){
                eachApp.Title_Insurance_Fee__c = (titleInsFee).Base_Premium__c + titleInsFee.GST__c;
        }
    }
}