/****************************************************************************************************
Description:    This Class is the test class for PersonAccountApprovalMail class
Developer:      Sayak Mukhopadhyay
Created Date:   14/07/2022
*****************************************************************************************************/

@isTest(SeeAllData = false)
public class PersonAccountApprovalMailTest {
    @TestSetup
    static void initialize(){
        /// Inserting Individual Legal Entity ///
        clcommon__Legal_Entity__c objIndiLegalEntity = GenericUtilityTestHelper.returnLegalEntity();
        System.AssertNotEquals(
            objIndiLegalEntity.Id,
            null,
            'Legal Entity inserted successfully.'
        );
        /// Inserting Account /// 
        Account objAccount = GenericUtilityTestHelper.insertDummyAccount();
        objAccount.clcommon__Legal_Entity_Type__c = objIndiLegalEntity.id;
        objAccount.Approved__c = true;
        update objAccount;
        System.AssertNotEquals(
            objAccount.Id,
            null,
            'Account inserted successfully.'
        );
        /// Inserting Application ///
        genesis__applications__c objApplication = GenericUtilityTestHelper.returnApplication(objAccount.id);
        System.AssertNotEquals(
            objApplication.Id,
            null,
            'Application inserted successfully.'
        );
    }
    @isTest
    static void approvalMailTestMethodOne(){
        test.startTest();
        List<Account> objAccountList = [SELECT id FROM Account];
        List<Id> objAccoutIdList = new List<Id>();
        for(Account objAccount : objAccountList){
            objAccoutIdList.add(objAccount.id);
        }
        PersonAccountApprovalMail.personAccountApprovalMail(objAccoutIdList);
        test.stopTest();
    }
    @isTest
    static void approvalMailTestMethodTwo(){
        test.startTest();
        String recieverEmail = ConstantValues.TEST_EMAIL_ID;
        String status = ConstantValues.REJECTED;
        String accName = ConstantValues.TEST_TEXT;
        String comment = ConstantValues.TEST_TEXT;
        PersonAccountApprovalMail.sendEmail(recieverEmail,status,accName,comment);
        test.stopTest();
    }
    @isTest
    static void approvalMailTestMethodThree(){
        test.startTest();
        List<Account> objAccountList = [SELECT id,Rejected__c FROM Account];
        if(objAccountList.size()>0){
            objAccountList[0].Rejected__c = true;
            objAccountList[0].Approved__c = false;
            update objAccountList[0];
        }
        String recieverEmail = ConstantValues.TEST_EMAIL_ID;
        String status = ConstantValues.APPROVED;
        String accName = ConstantValues.TEST_TEXT;
        String comment = '';
        PersonAccountApprovalMail.sendEmail(recieverEmail,status,accName,comment);
        test.stopTest();
    }
}