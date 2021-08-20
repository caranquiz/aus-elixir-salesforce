@isTest(SeeAllData=false)
public class AccountMigrationBatchTest {
	@TestSetup
    static void initialize(){

        //Inserting legal entity
        clcommon__Legal_Entity__c legEntity = GenericUtilityTestHelper.returnLegalEntity();
        System.AssertNotEquals(
            legEntity.Id,
            null,
            ' Legal Entity inserted successfully.'
        );
        
        //Inserting Account
        Account testAccount = GenericUtilityTestHelper.insertDummyAccount();
        testAccount.clcommon__Legal_Entity_Type__c=legEntity.Id;
        update testAccount;
        List<Account> testAccountList=[SELECT id 
                                        FROM Account 
                                        WHERE clcommon__Legal_Entity_Type__r.Name=:ConstantValues.indType 
                                        LIMIT 1];
        System.AssertNotEquals(
        testAccount.Id,
        null,
        ' Account inserted successfully.'
        );
        
        //Insert Contact
        Contact testContact=GenericUtilityTestHelper.insertDummyContact(
            testAccount
        );
        System.AssertNotEquals(
        testContact.Id,
        null,
        ' Contact inserted successfully.'
        );

        //Insert Application
        genesis__Applications__c testApplication = GenericUtilityTestHelper.returnApplication(
            testAccount.Id
        );
        testApplication.Allow_Direct_Marketing__c=ConstantValues.NO_TAG;
        testApplication.First_Home_Buyer__c=ConstantValues.NO_TAG;
        update testApplication;
        List<genesis__Applications__c> applicationList=[SELECT id 
                                                        FROM genesis__Applications__c 
                                                        WHERE Allow_Direct_Marketing__c=:ConstantValues.NO_TAG
                                                        LIMIT 1 ];
        System.assertEquals(
            applicationList.size(), 
            1, 
            'Application Inserted Successfully'
        );
        clcommon__Party_Type__c partyType =GenericUtilityTestHelper.insertPartyType(ConstantValues.BORROWER);
        System.AssertNotEquals(
            partyType.Id,
            null,
            ' Party Type inserted successfully.'
        );
		//Insert Party
        clcommon__Party__c testParty=GenericUtilityTestHelper.returnParty(
            testApplication.id,
            testAccount.Id
        );
        testParty.clcommon__Contact__c=testContact.Id;
        testParty.clcommon__Type__c=partyType.Id ;
        update testParty;
        List<clcommon__Party__c> partyList=[SELECT id 
                                                        FROM clcommon__Party__c 
                                                        WHERE id=:testParty.Id
                                                        LIMIT 1 ];
        System.assertEquals(
            partyList.size(), 
            1, 
            'Party Inserted Successfully'
        );
    }
    @isTest
    static void partyTest(){
        List<clcommon__Party__c> testParty1=[SELECT id 
                                                FROM clcommon__Party__c 
                                                WHERE clcommon__Type__r.Name=:ConstantValues.BORROWER
                                                LIMIT 1];
        test.startTest();
        AccountMigrationBatch obj=new AccountMigrationBatch();
        database.executeBatch(obj,1);
        test.stopTest();
        
    }  

}