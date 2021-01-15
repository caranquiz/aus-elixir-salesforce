/****************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : SkuidValuesUpdateHelper */
/* Created Date         : 29/12/2020 */
/* Developed By         : Rameswari Barman */
/* Description          : This class is used to update values when called from skuid*/
/* Last Modified Date   : 12/01/2021 */
/* Last Modified By     : Rameswari Barman */
/****************************************************************************************************/

global with sharing class SkuidValuesUpdateHelper {
    //This method helps in update S&P and QBE location values
    //from custom settings to collateral-security records
    Webservice static String updateLocationValues(Id appId){
        try{
            if(String.isBlank(appId)){
                return null;
            }
            //sub-query is used to query out collateral with the help of application id
            List <clcommon__Collateral__c> collateralList = [select Id,
                                                            S_P_Location__c,
                                                            QBE_Location__c,
                                                            clcommon__Postal_Code__c
                                                            from clcommon__Collateral__c
                                                            where Id in (Select genesis__Collateral__c 
                                                                            from genesis__Application_Collateral__c 
                                                                            where genesis__Application__c =: appId)];
            //Querying out locations from Custom settings
            List <QBEpostCode__c> qbeList = [Select Id,
                                                PostCode_High_RangeNumber__c,
                                                PostCode_Low_RangeNumber__c,
                                                Location__c
                                                From QBEpostCode__c
                                            ];
            List <S_P_Postcode__c> sAndPList = [Select Id,
                                                PostCode_High_RangeNumber__c,
                                                PostCode_Low_RangeNumber__c,
                                                Location__c
                                                From S_P_Postcode__c
                                            ];
            if(collateralList.size() > 0 == false){
                return null;
            }
            for(clcommon__Collateral__c collateral : collateralList){
                if(collateral.clcommon__Postal_Code__c != NULL && collateral.clcommon__Postal_Code__c != ''){
                    if(qbeList.size() > 0){
                        collateral.QBE_Location__c = ConstantValues.CATEGORY_3_OR_4;
                        for(QBEpostCode__c qbe : qbeList){
                            //looping to find the correct match from QBE custom setting values
                            //NULL check is not done on Location__c,PostCode_High_RangeNumber__c and QBE_Location__c as the values are already updated in custom settings and are hardly changed
                            if(qbe.PostCode_High_RangeNumber__c >= Decimal.ValueOf(collateral.clcommon__Postal_Code__c)
                                    && qbe.PostCode_Low_RangeNumber__c <= Decimal.ValueOf(collateral.clcommon__Postal_Code__c)){
                                collateral.QBE_Location__c = qbe.Location__c;
                                break;//as correct match is found it will break from the loop
                            }
                        }
                    }
                    if(sAndPList.size() > 0){
                        collateral.S_P_Location__c = '';
                        for(S_P_Postcode__c sp : sAndPList){
                            //NULL check is not done on Location__c,PostCode_High_RangeNumber__c and QBE_Location__c as the values are already updated in custom settings and are hardly changed
                            if(sp.PostCode_High_RangeNumber__c >= Decimal.ValueOf(collateral.clcommon__Postal_Code__c)
                                    && sp.PostCode_Low_RangeNumber__c <= Decimal.ValueOf(collateral.clcommon__Postal_Code__c)){
                                collateral.S_P_Location__c = sp.Location__c;
                                break;//as correct match is found it will break from the loop
                            }
                        }
                    }
                }
            }
            update collateralList;//updation of collaterals with the latest location values from custom settings
        }
        catch (Exception ex) {
            GenericUtility.insertLog('SkuidValuesUpdateHelper.updateLocationValues', ex);
        }
        return ConstantValues.SUCCESS;
    }
    //This method updates the mortgagor field value in collateral object for its displayal in the credit contract
    Webservice static String updateMortgagorName(Id appId){
        try{
            String mortgagor = '';
            Integer k = 0 ;
            if(String.isBlank(appId)){
                return null;
            }
            //Querying the Borrower Party
            List <clcommon__Party__c> borrowerPartyList = [Select Id,
                                                            Trust_Structure__c,
                                                            Legal_Entity_Type__c,
                                                            clcommon__Account__c,
                                                            clcommon__Account__r.Name
                                                            from clcommon__Party__c 
                                                            where genesis__Application__c =: appId
                                                            and Party_Type_Name__c =: ConstantValues.BORROWER
                                                            limit 1];
            if(borrowerPartyList.size() > 0 == false){
                return null;
            }
            //Querying out the list of collaterals with the help of application Id
            List <clcommon__Collateral__c> collateralList = [select Id,
                                                                Mortgagor__c
                                                                from clcommon__Collateral__c
                                                                where Id in (Select genesis__Collateral__c 
                                                                                from genesis__Application_Collateral__c 
                                                                                where genesis__Application__c =: appId)];
            if(collateralList.size() > 0 == false){
                return null;
            }
            //Querying out the collateral owners of the collaterals of the application
            List <clcommon__Collateral_Owner__c> collaterOwnerList = [Select Id,
                                                                        clcommon__Account__c,
                                                                        clcommon__Account__r.Name,
                                                                        clcommon__Collateral__c
                                                                        From clcommon__Collateral_Owner__c
                                                                        where clcommon__Collateral__c in (Select genesis__Collateral__c 
                                                                                                                from genesis__Application_Collateral__c 
                                                                                                                where genesis__Application__c =: appId)];
            if(borrowerPartyList[0].Legal_Entity_Type__c == ConstantValues.ENQUIRY_SMSF || (String.isBlank(borrowerPartyList[0].Trust_Structure__c) == false && borrowerPartyList[0].Trust_Structure__c == ConstantValues.ENQUIRY_SMSF)){
                //When the borrower is SMSF, the borower account holder is always the mortgagor
                for(clcommon__Collateral__c collateral : collateralList)
                {
                    if(String.isBlank(borrowerPartyList[0].clcommon__Account__c) == false && String.isBlank(borrowerPartyList[0].clcommon__Account__r.Name) == false){
                        collateral.Mortgagor__c = borrowerPartyList[0].clcommon__Account__r.Name;
                    }
                }
            }
            else{
                for(clcommon__Collateral__c collateral : collateralList){
                    //When the borrower is non-SMSF, the collateral owners are always the mortgagor
                    if(collaterOwnerList.size() > 0){
                        mortgagor = '';
                        k=0;
                        for(clcommon__Collateral_Owner__c colOwner : collaterOwnerList){
                            if(colOwner.clcommon__Collateral__c != NULL && colOwner.clcommon__Collateral__c == collateral.Id){
                                if(colOwner.clcommon__Account__c != NULl && String.isBlank(colOwner.clcommon__Account__r.Name) == false){
                                    if(k == 0){
                                        mortgagor = colOwner.clcommon__Account__r.Name;
                                    }
                                    else{
                                        mortgagor += ' and ' + colOwner.clcommon__Account__r.Name;
                                    }
                                    k++;
                                }
                            }
                        }
                    }
                    collateral.Mortgagor__c = mortgagor;
                }
            }
            update collateralList;//updation of the mortgagors
        }
        catch (Exception ex) {
            GenericUtility.insertLog('SkuidValuesUpdateHelper.updateMortgagorName', ex);
        }
        return ConstantValues.SUCCESS;
    }
    //Method to update first payment date and due date
    Webservice static String updateFirstPaymentDate(Id appId){
        try{
            List <genesis__Applications__c> appList = [SELECT Id,
                                                        genesis__Expected_Start_Date__c,
                                                        genesis__Expected_First_Payment_Date__c,
                                                        genesis__Due_Day__c
                                                        FROM genesis__Applications__c 
                                                        WHERE Id =: appId];
            if(appList.size() > 0 && appList[0].genesis__Expected_Start_Date__c != NULL){
                Date settlementDate = appList[0].genesis__Expected_Start_Date__c;
                String scheduleResult;
                appList[0].genesis__Expected_First_Payment_Date__c = settlementDate.addMonths(1);
                appList[0].genesis__Due_Day__c = (appList[0].genesis__Expected_First_Payment_Date__c).Day();
                //updated the values as without putting first payment date and due date the schedule cant be generated
                update appList;
                //calling the Schedule generation class to generate schedule whoch considers business days
                scheduleResult = genesis.SkuidNewApplication.generateSchedule(appId);
                if(scheduleResult == ConstantValues.SUCCESSFULLY_DONE){
                    List <genesis__Amortization_Schedule__c> scheduleList = [SELECT id,
                                                                            genesis__Due_Date__c
                                                                            FROM genesis__Amortization_Schedule__c 
                                                                            WHERE genesis__Application__c =: appId
                                                                            ORDER BY genesis__Due_Date__c ASC LIMIT 1 ];
                    if(scheduleList.size() > 0 && scheduleList[0].genesis__Due_Date__c != NULL){
                        appList[0].genesis__Expected_First_Payment_Date__c = scheduleList[0].genesis__Due_Date__c;
                        update appList;//updating the first payment date from Schedule
                        return ConstantValues.SUCCESS_STATUS;
                    }
                    else{
                        return ConstantValues.GENERAL_EXCEPTION;
                    }
                    
                }
                else{
                    return scheduleResult;
                }
            }
            else {
                return ConstantValues.START_DATE_MISSING;
            }                       
        }
        catch (Exception ex) {
            GenericUtility.insertLog('SkuidValuesUpdateHelper.updateFirstPaymrentDate', ex);
        }
        return '';
    }
}