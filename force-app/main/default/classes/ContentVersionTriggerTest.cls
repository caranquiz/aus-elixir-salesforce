/**
 * Created by Ethan Sargent on 30/08/2021.
 */

@IsTest
private class ContentVersionTriggerTest
{

    @TestSetup
    static void setup()
    {
        loan__Org_Parameters__c checkTrigger = new loan__Org_Parameters__c();
        checkTrigger.loan__Disable_Triggers__c = true;
        insert checkTrigger;
        RecordType personAccountType = [SELECT Id FROM RecordType WHERE IsPersonType = TRUE AND IsActive = TRUE];
        Account authorisedAccount = new Account(FirstName = 'Authorised', LastName = 'Person Account', RecordTypeId = personAccountType.Id);
        insert authorisedAccount;
        Map<Id, Account> personAccountsForContactIds = new Map<Id, Account>([SELECT Id, PersonContactId FROM Account]);
        authorisedAccount = personAccountsForContactIds.get(authorisedAccount.Id);

        loan__Loan_Account__c loanAccount = (loan__Loan_Account__c) JSON.deserialize('{"Name": "LAI-00000675", "Current_Loan_Balance_Excluding_Deposit__c": 0.00, "loan__Delinquent_Amount__c": 0.00, "loan__Loan_Status__c": "Closed - Obligations met", "loan__Loan_Amount__c": 300000.00, "loan__Disbursal_Date__c": "2020-05-26", "loan__Maturity_Date_Current__c": "2021-05-26", "loan__Interest_Rate__c": 4.5000, "loan__Next_Installment_Date__c": "2020-08-26", "loan__Pmt_Amt_Cur__c": 25618.42, "Remaining_IO_Period__c": 0, "Restrict_Redraw__c": false, "loan__Loan_Status__c": "Active - Good Standing"}', loan__Loan_Account__c.class);
        loanAccount.loan__Account__c = authorisedAccount.Id;
        loanAccount.loan__Disbursal_Date__c = Date.today();
        insert loanAccount;
    }

    @IsTest
    static void testCreateRedrawRequestAndLinkDocument()
    {
        // Arrange
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.Title = 'Test ContentVersion';
        cv.PathOnClient = 'Test ContentVersion';
        cv.VersionData = Blob.valueOf('testData');
        cv.Loan_Account_fileupload__c = [SELECT Id FROM loan__Loan_Account__c].Id;


        // Act
        Test.startTest();
        insert cv;
        Test.stopTest();
        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        // Assert
        System.assertEquals(3, [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :contentDocumentId].size());
        System.assertEquals(1, [SELECT Id FROM Redraw_Request__c].size());
        System.assertEquals(1, [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId IN (SELECT Id FROM loan__Loan_Account__c)].size());
    }

    @IsTest
    static void testInsertNormalDocument()
    {
        // Arrange
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.Title = 'Test ContentVersion';
        cv.PathOnClient = 'Test ContentVersion';
        cv.VersionData = Blob.valueOf('testData');

        // Act
        Test.startTest();
        insert cv;
        Test.stopTest();
        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion].ContentDocumentId;
        // Assert
        System.assertEquals(1, [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :contentDocumentId].size());
        System.assertEquals(0, [SELECT Id FROM Redraw_Request__c].size());
    }
}