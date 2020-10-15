/**********************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : InvokeOnPartyUpdateTest */
/* Created Date         : 15/10/2020 */
/* Developed By         : Souvik */
/* Description          : This test class mostly covers InvokeOnPartyUpdate apex class. */
/* Last Modified Date   : 15/10/2020 */
/* Last Modified By     : Souvik */
/*********************************************************************************************************/

@isTest
private class InvokeOnPartyUpdateTest {
    @TestSetup
    static void initialize(){
        Account acctObj = GenericUtilityTestHelper.insertDummyAccount();
        List<Account> accList = [SELECT Id FROM Account];
        System.assert(!accList.isEmpty(), 'Account not inserted');
        genesis__Applications__c appObj = GenericUtilityTestHelper.returnApplication(
            acctObj.Id
        );
        List<genesis__Applications__c> appList = [SELECT Id FROM genesis__Applications__c];
        System.assert(!appList.isEmpty(), 'Application not inserted');
        clcommon__Party__c partyObj = GenericUtilityTestHelper.returnParty(
            appObj.Id,
            acctObj.Id
        );
        partyObj.Primary_Residence_Property_Costs__c = 1000;
        update partyObj;
        List<clcommon__Party__c> partyList = [SELECT Id FROM clcommon__Party__c];
        System.assert(!partyList.isEmpty(), 'Party not inserted');
    }
    @isTest
    static void testLivingExpenseUpdate(){
        List<Id> appIdList = new List<Id>();
        List<genesis__Applications__c> appList = [SELECT Id FROM genesis__Applications__c];
        for(genesis__Applications__c eachApp : appList){
            appIdList.add(eachApp.Id);
        }
        Test.startTest();
        InvokeOnPartyUpdate.updateLivingExpense(appIdList);
        Test.stopTest();
        appList = [SELECT Id, Total_Monthly_Living_Expenses_Declared__c FROM genesis__Applications__c];
        System.assert(!appList.isEmpty(), 'Application not inserted');
        System.debug(appList[0].Total_Monthly_Living_Expenses_Declared__c);
        System.assert(appList[0].Total_Monthly_Living_Expenses_Declared__c == 1000, 'Value is not updated on Application');
    }
}
