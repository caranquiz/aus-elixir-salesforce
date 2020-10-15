/****************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : InvokeOnPartyUpdate */
/* Created Date         : 15/10/2020 */
/* Developed By         : Souvik */
/* Description          : This class is used to update total monthly expenses declared value on
application. */
/* Last Modified Date   : 15/10/2020 */
/* Last Modified By     : Souvik */
/****************************************************************************************************/

public with sharing class InvokeOnPartyUpdate {
    @InvocableMethod(
        label='Update Living Expense'
        description='Updates Total Monthly Living Expenses Declared value on Application'
    )
    public static void updateLivingExpense(List<Id> appIdList){
        Decimal sumOfAllLivingExpenses = 0;
        Id appId;
        List<clcommon__Party__c> parties;
        genesis__Applications__c appObj;
        try{
            if(appIdList.isEmpty()){
                GenericUtility.insertLog('InvokeOnPartyUpdate.updateLivingExpense', new CustomException(ConstantValues.NO_PARTY));
                return;
            }
            appId = appIdList[0];
            parties = [SELECT Id,
                        Total_HEM_Monthly_Living_Expenses__c,
                        Total_Non_HEM_Living_Expenses__c
                        FROM clcommon__Party__c
                        WHERE genesis__Application__c =:appId];
            for(clcommon__Party__c eachParty : parties) {
                sumOfAllLivingExpenses += eachParty.Total_HEM_Monthly_Living_Expenses__c;
                sumOfAllLivingExpenses += eachParty.Total_Non_HEM_Living_Expenses__c;
            }
            appObj = new genesis__Applications__c(Id = appId);
            appObj.Total_Monthly_Living_Expenses_Declared__c = sumOfAllLivingExpenses;
            Database.update(appObj);
        }
        catch(Exception ex){
            GenericUtility.insertLog('InvokeOnPartyUpdate.updateLivingExpense', ex);
        }
    }
}
