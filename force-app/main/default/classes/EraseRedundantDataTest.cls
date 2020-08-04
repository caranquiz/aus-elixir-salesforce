/****************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : EraseRedundantDataTest */
/* Created Date         : 10/07/2020 */
/* Developed By         : Souvik Dey */
/* Description          : This test class mostly covers EraseRedundantData apex class. */
/* Testing Scenario 1   : (testMethod1) */
/* Last Modified Date   : 10/07/2020 */
/* Last Modified By     : Souvik Dey */
/****************************************************************************************************/

@isTest
private class EraseRedundantDataTest{
    @TestSetup
    static void initialize(){
        Account acct = GenericUtilityTestHelper.insertDummyAccount();
        acct.clcommon__Archived__c = true;
        acct.peer__Auto_Invest__c = true;
        acct.loan__Borrower__c = true;
        acct.clcommon__Email__c = 'some@mail.com'; // Rendered Field (Dependent Field, Depending on clcommon__Archived__c)
        update acct;
        Rendered_Field__c renderedFieldConfig = GenericUtilityTestHelper.insertRenderedField(
            'clcommon__Email__c', '$1 && $2 || $3', 'Account'
        );
        GenericUtilityTestHelper.insertRenderingCriteria(
            renderedFieldConfig.Id, 1, 'clcommon__Archived__c', '==', 'false'
        );
        GenericUtilityTestHelper.insertRenderingCriteria(
            renderedFieldConfig.Id, 2, 'peer__Auto_Invest__c', '==', 'false'
        );
        GenericUtilityTestHelper.insertRenderingCriteria(
            renderedFieldConfig.Id, 3, 'loan__Borrower__c', '==', 'false'
        );
        GenericUtilityTestHelper.insertDummyContact(acct);
        renderedFieldConfig = GenericUtilityTestHelper.insertRenderedField(
            'Contact List', '$1', 'Account', 'Contact'
        );
        GenericUtilityTestHelper.insertRenderingCriteria(
            renderedFieldConfig.Id, 1, 'clcommon__Archived__c', '==', 'false'
        );
    }
    @isTest
    static void testFieldDataErased(){
        List<Account> acct = [SELECT Id FROM Account];
        System.assertEquals(1, acct.size(), 'Account record not Inserted');
        Test.startTest();
        EraseRedundantData.eraseHiddenFieldsDataOf(
            'Account',
            acct[0].Id
        );
        Test.stopTest();
        List<clcommon__Log__c> logList = [SELECT Id, clcommon__Message__c FROM clcommon__Log__c];
        for (clcommon__Log__c each : logList) {
            System.debug(each.clcommon__Message__c);
        }
        acct = [SELECT Id, clcommon__Email__c FROM Account];
        System.assertEquals(null, acct[0].clcommon__Email__c, 'Email field not cleared');
    }
    @isTest
    static void testChildRecordsDeleted(){
        List<Account> acct = [SELECT Id FROM Account];
        System.assertEquals(1, acct.size(), 'Account record not Inserted');
        List<Contact> conList = [SELECT Id FROM Contact];
        System.assertEquals(1, conList.size(), 'Contact record not Inserted');
        EraseRedundantData.eraseHiddenObjectData(
            'Account',
            'Contact List',
            'Contact',
            acct[0].Id,
            conList[0].Id,
            (Boolean) null,
            (String) null
        );
        conList = [SELECT Id FROM Contact];
        System.assertEquals(0, conList.size(), 'Contact record not Deleted');
    }
    @isTest
    static void testExpressionEvaluation(){
        System.assert(true == EraseRedundantData.checkIfDataMatched((String) null, (String) null, (String) null), 'Data not matched');
        System.assert(true == EraseRedundantData.checkIfDataMatched((String) null, (String) null, '=='), 'Data not matched');
        System.assert(true == EraseRedundantData.checkIfDataMatched('010.1', '10.1', '=='), 'Data not matched');
        System.assert(true == EraseRedundantData.checkIfDataMatched('TeSt', 'tEsT', '=='), 'Data not matched');
        System.assert(true == EraseRedundantData.checkIfDataMatched('notTest', 'tEsT', '!='), 'Data not matched');
        System.assert(true == EraseRedundantData.checkIfDataMatched('12', '10.1', '>='), 'Data not matched');
        System.assert(true == EraseRedundantData.checkIfDataMatched('greater', 'less', '>='), 'Data not matched');
        System.assert(true == EraseRedundantData.checkIfDataMatched((String) null, 'less', '>='), 'Data not matched');
        System.assert(true == EraseRedundantData.checkIfDataMatched('12', '10.1', '>'), 'Data not matched');
        System.assert(true == EraseRedundantData.checkIfDataMatched('d1', 'd2', '>'), 'Data not matched');
        System.assert(true == EraseRedundantData.checkIfDataMatched((String) null, 'd2', '>'), 'Data not matched');
        System.assert(true == EraseRedundantData.checkIfDataMatched('11', '15', '<='), 'Data not matched');
        System.assert(true == EraseRedundantData.checkIfDataMatched('d1', 'd2', '<='), 'Data not matched');
        System.assert(true == EraseRedundantData.checkIfDataMatched((String) null, 'd2', '<='), 'Data not matched');
        System.assert(true == EraseRedundantData.checkIfDataMatched('11', '15', '<'), 'Data not matched');
        System.assert(true == EraseRedundantData.checkIfDataMatched('d1', 'd2', '<'), 'Data not matched');
        System.assert(true == EraseRedundantData.checkIfDataMatched((String) null, 'd2', '<'), 'Data not matched');
    }
}