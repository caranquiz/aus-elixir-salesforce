/****************************************************************************************************
Company              : Cloudkaptan Consultancy Services Pvt. Ltd. 
Class Name           : DataMigrationBatchTest 
Created Date         : 24/08/2022 
Developed By         : Sayak Mukhopadhyay 
Description          : This is Test class for DataMigrationBatch Class
****************************************************************************************************/
@isTest(SeeAllData = false)
public class DataMigrationBatchTest {
    @TestSetup
    static void initialize() {
        //Inserting Individual Legal Entity
        clcommon__Legal_Entity__c objLegEntity = GenericUtilityTestHelper.returnLegalEntity();
        System.AssertNotEquals(
            objLegEntity.Id,
            null,
            'Legal Entity inserted successfully.'
        );

        // Inserting Borrower Party Type
        clcommon__Party_Type__c objBorrowerPartyType = GenericUtilityTestHelper.returnBorrowerPartyType();
        System.AssertNotEquals(
            objBorrowerPartyType.Id,
            null,
            'Party Type inserted successfully.'
        );

        // Inserting Account for Individual
        Account objAccount = GenericUtilityTestHelper.insertDummyAccount();
        System.AssertNotEquals(
            objAccount.Id,
            null,
            'Account inserted successfully.'
        );
        objAccount.clcommon__Legal_Entity_Type__c = objLegEntity.id; 
        update objAccount;
        System.assertEquals(objAccount.clcommon__Legal_Entity_Type__c, objLegEntity.id, 'Account updated successfully!');

        // Inserting Application
        genesis__applications__c objApplication = GenericUtilityTestHelper.returnApplication(objAccount.id);
        System.AssertNotEquals(
            objApplication.Id,
            null,
            'Application inserted successfully.'
        );
        objApplication.Monthly_Living_Expenses_Used__c = 0.0;
        update objApplication;
        System.assertEquals(objApplication.Monthly_Living_Expenses_Used__c, 0.0, 'Application updated successfully!');

        // Inserting Individual Party 
        clcommon__Party__c objParty = GenericUtilityTestHelper.returnParty(objApplication.id,objAccount.id);
        System.AssertNotEquals(
            objParty.Id,
            null,
            'Party inserted successfully.'
        );
        objParty.clcommon__Type__c = objBorrowerPartyType.id; 
        objParty.Living_Expense_Used_for_Servicing_Purpos__c = 230.0;
        update objParty;
        System.assertEquals(objParty.Living_Expense_Used_for_Servicing_Purpos__c, 230.0, 'Party updated successfully!');
    }
    @isTest
    static void DataMigrationBatchTestMethodeOne() {
        List<genesis__applications__c> objApplicationList = [SELECT id,
                                                                Monthly_Living_Expenses_Used__c
                                                                FROM genesis__applications__c];
        System.assertEquals(objApplicationList.size() > 0, true, 'Application found successfully!');   
        DataMigrationBatch obj = new DataMigrationBatch();
        database.executebatch(obj,1);
        System.assertEquals(objApplicationList[0].Monthly_Living_Expenses_Used__c, 0.0, 'Application updated successfully!');
    }
}