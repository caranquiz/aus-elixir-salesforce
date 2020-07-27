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
        Account acct = new Account(Name = 'Test');
        acct.clcommon__Archived__c = true;
        acct.peer__Auto_Invest__c = true;
        acct.loan__Borrower__c = true;
        acct.clcommon__Email__c = 'some@mail.com'; // Rendered Field (Dependent Field, Depending on clcommon__Archived__c)
        insert acct;
        Rendered_Field__c renderedFieldConfig = new Rendered_Field__c();
        renderedFieldConfig.Name = 'clcommon__Email__c';
        renderedFieldConfig.Evaluation_Expression__c = '$1 && $2 || $3';
        renderedFieldConfig.Rendered_Object__c = 'Account';
        insert renderedFieldConfig;
        Rendering_Criteria__c renderingCriteria = new Rendering_Criteria__c();
        renderingCriteria.Rendered_Field__c = renderedFieldConfig.Id;
        renderingCriteria.Serial_Number__c = 1;
        renderingCriteria.Related_Field__c = 'clcommon__Archived__c';
        renderingCriteria.Matching_Type_c__c = '==';
        renderingCriteria.Associated_Value__c = 'false';
        insert renderingCriteria;
        renderingCriteria = new Rendering_Criteria__c();
        renderingCriteria.Rendered_Field__c = renderedFieldConfig.Id;
        renderingCriteria.Serial_Number__c = 2;
        renderingCriteria.Related_Field__c = 'peer__Auto_Invest__c';
        renderingCriteria.Matching_Type_c__c = '==';
        renderingCriteria.Associated_Value__c = 'false';
        insert renderingCriteria;
        renderingCriteria = new Rendering_Criteria__c();
        renderingCriteria.Rendered_Field__c = renderedFieldConfig.Id;
        renderingCriteria.Serial_Number__c = 3;
        renderingCriteria.Related_Field__c = 'loan__Borrower__c';
        renderingCriteria.Matching_Type_c__c = '==';
        renderingCriteria.Associated_Value__c = 'false';
        insert renderingCriteria;
    }
    @isTest
    static void testMethod1(){
        Account acct = [SELECT Id FROM Account LIMIT 1];
        System.assertNotEquals(null, acct, 'Account record not Inserted');
        Test.startTest();
        EraseRedundantData.eraseHiddenFieldsDataOf(
            'Account',
            acct.Id
        );
        Test.stopTest();
        List<clcommon__Log__c> logList = [SELECT Id, clcommon__Message__c FROM clcommon__Log__c];
        for (clcommon__Log__c each : logList) {
            System.debug(each.clcommon__Message__c);
        }
        acct = [SELECT Id, clcommon__Email__c FROM Account LIMIT 1];
        System.assertEquals(null, acct.clcommon__Email__c, 'Email field not cleared');
    }
}