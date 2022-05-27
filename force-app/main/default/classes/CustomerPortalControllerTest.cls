/**
 * Created by Ethan Sargent on 8/07/2021.
 */

@IsTest
private class CustomerPortalControllerTest
{
    private static String authorisedUsername = 'argo-ordeportalauthorised@test.com';
    private static String unauthorisedUsername = 'argo-ordeportalunauthorised@test.com';
    private static String delegatedUsername = 'argo-ordeportaldelegated@test.com';

    private static User authorisedUser;
    private static User unAuthorisedUser;
    private static User delegatedUser;
    private static User getAuthorisedUser()
    {
        if (authorisedUser != null) return authorisedUser;
        return authorisedUser = [SELECT Id, AccountId, ContactId FROM User WHERE Username = :authorisedUsername];
    }
    private static User getUnauthorisedUser()
    {
        if (unAuthorisedUser != null) return unAuthorisedUser;
        return unAuthorisedUser = [SELECT Id, AccountId, ContactId FROM User WHERE Username = :unauthorisedUsername];
    }
    private static User getDelegatedUser()
    {
        if (delegatedUser != null) return delegatedUser;
        return delegatedUser = [SELECT Id, AccountId, ContactId FROM User WHERE Username = :delegatedUsername];
    }

    @TestSetup
    static void setup()
    {
        loan__Org_Parameters__c checkTrigger = new loan__Org_Parameters__c();
        checkTrigger.loan__Disable_Triggers__c = true;
        insert checkTrigger;
        RecordType personAccountType = [SELECT Id FROM RecordType WHERE IsPersonType = TRUE AND IsActive = TRUE];
        Account authorisedAccount = new Account(FirstName = 'Authorised', LastName = 'Person Account', RecordTypeId = personAccountType.Id);
        Account unauthorisedAccount = new Account(FirstName = 'Unauthorised', LastName = 'PersonAccount', RecordTypeId = personAccountType.Id);
        Account delegatedAuthAccount = new Account(FirstName = 'Delegated', LastName = 'PersonAccount', RecordTypeId = personAccountType.Id);
        insert new List<Account> {authorisedAccount, unauthorisedAccount, delegatedAuthAccount};
        Map<Id, Account> personAccountsForContactIds = new Map<Id, Account>([SELECT Id, PersonContactId FROM Account]);
        authorisedAccount = personAccountsForContactIds.get(authorisedAccount.Id);
        unauthorisedAccount = personAccountsForContactIds.get(unauthorisedAccount.Id);
        delegatedAuthAccount = personAccountsForContactIds.get(delegatedAuthAccount.Id);
        AccountContactRelation delegatedAuthRelation = new AccountContactRelation(Roles = 'Director', AccountId = authorisedAccount.Id, ContactId = delegatedAuthAccount.PersonContactId);
        insert delegatedAuthRelation;

        loan__Loan_Account__c loanAccount = (loan__Loan_Account__c) JSON.deserialize('{"Name": "LAI-00000675", "Current_Loan_Balance_Excluding_Deposit__c": 0.00, "loan__Delinquent_Amount__c": 0.00, "loan__Loan_Status__c": "Closed - Obligations met", "loan__Loan_Amount__c": 300000.00, "loan__Disbursal_Date__c": "2020-05-26", "loan__Maturity_Date_Current__c": "2021-05-26", "loan__Interest_Rate__c": 4.5000, "loan__Next_Installment_Date__c": "2020-08-26", "loan__Pmt_Amt_Cur__c": 25618.42, "Remaining_IO_Period__c": 0, "Restrict_Redraw__c": false, "loan__Loan_Status__c": "Active - Good Standing"}', loan__Loan_Account__c.class);
        loanAccount.loan__Account__c = authorisedAccount.Id;
        loanAccount.loan__Disbursal_Date__c = Date.today();
        insert loanAccount;
        loan__Coborrower__c coborrower = new loan__Coborrower__c(loan__Loan__c = loanAccount.Id, loan__Account__c = authorisedAccount.Id, loan__Party_Type__c = 'Borrower');
        insert coborrower;

        loan__Loan_Payment_Transaction__c uncleared = new loan__Loan_Payment_Transaction__c(
                loan__Cleared__c = false,
                loan__Reversed__c = false,
                loan__Rejected__c = false,
                loan__Loan_Account__c = loanAccount.Id,
                loan__Transaction_Date__c = Date.today(),
                loan__Transaction_Amount__c = 100,
                loan__Receipt_Date__c = Date.today()
        );
        loan__Loan_Payment_Transaction__c dishonoured = new loan__Loan_Payment_Transaction__c(
                loan__Cleared__c = false,
                loan__Reversed__c = false,
                loan__Rejected__c = true,
                loan__Loan_Account__c = loanAccount.Id,
                loan__Transaction_Date__c = Date.today(),
                loan__Transaction_Amount__c = 100,
                loan__Receipt_Date__c = Date.today()
        );
        loan__Loan_Payment_Transaction__c paymentTransaction = new loan__Loan_Payment_Transaction__c(
                loan__Payment_Type__c = 'Regular',
                loan__Loan_Account__c = loanAccount.Id,
                loan__Transaction_Date__c = Date.today(),
                loan__Transaction_Amount__c = 100,
                loan__Receipt_Date__c = Date.today()
        );
        insert paymentTransaction;
        loan__Loan_Transaction_Summary__c historyTransaction = new loan__Loan_Transaction_Summary__c(
                loan__Loan_Account__c = loanAccount.Id,
                loan__Consolidated_Loan_Balance__c = 0,
                loan__Transaction_Amount__c = 100,
                loan__Transaction_Date__c = Date.today(),
                loan__Loan_Payment_Txn__c = paymentTransaction.Id
        );
        insert new List<SObject> {uncleared, dishonoured, historyTransaction};

        loan__Automated_Payment_Setup__c paymentSetup = new loan__Automated_Payment_Setup__c();
        paymentSetup.loan__Transaction_Amount__c = 10000;
        paymentSetup.loan__Debit_Date__c = Date.today().addDays(1);
        paymentSetup.loan__Active__c = true;
        paymentSetup.loan__CL_Contract__c = loanAccount.Id;
        paymentSetup.loan__Type__c = 'RECURRING';
        paymentSetup.loan__Amount_Type__c = 'FIXED AMOUNT';
        paymentSetup.loan__Actual_Date__c = paymentSetup.loan__Debit_Date__c;
        paymentSetup.loan__Frequency__c = 'MONTHLY';
        insert paymentSetup;


        Profile p = [SELECT Id FROM Profile WHERE Name = 'Orde Customer Community Plus User'];
        User authorisedUser = new User(Alias = 'test', Email = 'argo-ordeportal@test.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = p.Id,
                TimeZoneSidKey = 'Australia/Sydney', Username = authorisedUsername, ContactId = authorisedAccount.PersonContactId);
        User unauthorisedUser = new User(Alias = 'testuac', Email = 'argo-ordeportal@test.com',
                EmailEncodingKey = 'UTF-8', LastName = 'TestingUnauthorised', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = p.Id,
                TimeZoneSidKey = 'Australia/Sydney', Username = unauthorisedUsername, ContactId = unauthorisedAccount.PersonContactId);
        User delegatedAccountAccessUser = new User(Alias = 'testdac', Email = 'argo-ordeportal@test.com',
                EmailEncodingKey = 'UTF-8', LastName = 'TestingDelegated', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = p.Id,
                TimeZoneSidKey = 'Australia/Sydney', Username = delegatedUsername, ContactId = delegatedAuthAccount.PersonContactId);

        insert new List<User> {authorisedUser, unauthorisedUser, delegatedAccountAccessUser};

    }

    @IsTest
    static void testGetLoanAccountAuthorised()
    {
        // Arrange
        User u = getAuthorisedUser();
        CustomerPortalController.LoanAccountRequestDto req = new CustomerPortalController.LoanAccountRequestDto();
        req.loanAccountId = [SELECT Id FROM loan__Loan_Account__c LIMIT 1].Id;
        // Act
        CustomerPortalController.LoanAccountDto result;
        Test.startTest();
        System.runAs(u)
        {
            result = CustomerPortalController.getLoanAccountDetails(req);
        }
        Test.stopTest();
        // Assert
        System.assertNotEquals(null, result);
        System.assertNotEquals(0, result.fields.keySet().size());
        System.assertEquals(req.loanAccountId, result.recordId);
    }

    @IsTest
    static void testGetLoanAccountUnauthorised()
    {
        // Arrange
        User u = getUnauthorisedUser();
        CustomerPortalController.LoanAccountRequestDto req = new CustomerPortalController.LoanAccountRequestDto();
        req.loanAccountId = [SELECT Id FROM loan__Loan_Account__c LIMIT 1].Id;
        // Act
        CustomerPortalController.LoanAccountDto result;
        Test.startTest();
        System.runAs(u)
        {
            result = CustomerPortalController.getLoanAccountDetails(req);
        }
        Test.stopTest();
        // Assert
        System.assertEquals(0, result.fields.keySet().size());
        System.assertEquals(null, result.recordId);
    }


    @IsTest
    static void testGetTransactionHistoryAuthorised()
    {
        // Arrange
        User u = getAuthorisedUser();
        CustomerPortalController.TransactionHistoryRequestDto req = new CustomerPortalController.TransactionHistoryRequestDto();
        req.loanAccountId = [SELECT Id FROM loan__Loan_Account__c LIMIT 1].Id;
        // Act
        CustomerPortalController.TransactionHistoryResponseDto result;
        Test.startTest();
        System.runAs(u)
        {
            result = CustomerPortalController.getTransactionHistory(req);
        }
        Test.stopTest();
        // Assert
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.transactionHistory.size());
        System.assertEquals(2, result.unclearedPayments.size());
        System.assertEquals(1, result.dishonouredPayments.size());
    }

    @IsTest
    static void testGetTransactionHistoryUnauthorised()
    {
        // Arrange
        User u = getUnauthorisedUser();
        CustomerPortalController.TransactionHistoryRequestDto req = new CustomerPortalController.TransactionHistoryRequestDto();
        req.loanAccountId = [SELECT Id FROM loan__Loan_Account__c LIMIT 1].Id;
        // Act
        CustomerPortalController.TransactionHistoryResponseDto result;
        Test.startTest();
        System.runAs(u)
        {
            result = CustomerPortalController.getTransactionHistory(req);
        }
        Test.stopTest();
        // Assert
        System.assertNotEquals(null, result);
        System.assertEquals(0, result.transactionHistory.size());
        System.assertEquals(0, result.unclearedPayments.size());
        System.assertEquals(0, result.dishonouredPayments.size());
    }

    @IsTest
    static void testGetAccountsWithDelegated()
    {
        User u = getDelegatedUser();

        // Act
        List<CustomerPortalController.AccountSwitcherDto> result;
        Test.startTest();
        System.runAs(u)
        {
            result = CustomerPortalController.getAccounts();
        }
        Test.stopTest();
        // Assert
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());

    }

    @IsTest
    static void testGetAccountsNotDelegated()
    {
        User u = getAuthorisedUser();

        // Act
        List<CustomerPortalController.AccountSwitcherDto> result;
        Test.startTest();
        System.runAs(u)
        {
            result = CustomerPortalController.getAccounts();
        }
        Test.stopTest();
        // Assert
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());

    }

    @IsTest
    static void testGetLoansAuthorised()
    {
        User u = getAuthorisedUser();
        CustomerPortalController.LoanSwitcherRequestDto requestDto = new CustomerPortalController.LoanSwitcherRequestDto();
        // Act
        List<CustomerPortalController.LoanSwitcherDto> result;
        Test.startTest();
        System.runAs(u)
        {
            result = CustomerPortalController.getLoans(requestDto);
        }
        Test.stopTest();
        // Assert
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());

    }

    @IsTest
    static void testGetLoansDelegated()
    {
        User u = getDelegatedUser();
        User authorisedUser = getAuthorisedUser();
        CustomerPortalController.LoanSwitcherRequestDto requestDto = new CustomerPortalController.LoanSwitcherRequestDto();
        requestDto.requestedAccountId = authorisedUser.AccountId;
        // Act
        List<CustomerPortalController.LoanSwitcherDto> result;
        Test.startTest();
        System.runAs(u)
        {
            result = CustomerPortalController.getLoans(requestDto);
        }
        Test.stopTest();
        // Assert
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());

    }

    @IsTest
    static void testGetLoansUnauthorised()
    {
        User u = getUnauthorisedUser();
        User authorisedUser = getAuthorisedUser();
        CustomerPortalController.LoanSwitcherRequestDto requestDto = new CustomerPortalController.LoanSwitcherRequestDto();
        requestDto.requestedAccountId = authorisedUser.AccountId;
        // Act
        List<CustomerPortalController.LoanSwitcherDto> result;
        Test.startTest();
        System.runAs(u)
        {
            result = CustomerPortalController.getLoans(requestDto);
        }
        Test.stopTest();
        // Assert
        System.assertNotEquals(null, result);
        System.assertEquals(0, result.size());

    }


    @IsTest
    static void testGetDirectDebitInformationAuthorised()
    {
        User u = getAuthorisedUser();
        CustomerPortalController.LoanAccountRequestDto requestDto = new CustomerPortalController.LoanAccountRequestDto();
        requestDto.loanAccountId = [SELECT Id FROM loan__Loan_Account__c].Id;
        // Act
        List<CustomerPortalController.TabulatedDetailsResponseDto> result;
        Test.startTest();
        System.runAs(u)
        {
            result = CustomerPortalController.getDirectDebitInformation(requestDto);
        }
        Test.stopTest();
        // Assert
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());

    }


    @IsTest
    static void testGetDirectDebitInformationUnauthorised()
    {
        User u = getUnauthorisedUser();
        User authorisedUser = getAuthorisedUser();
        CustomerPortalController.LoanSwitcherRequestDto requestDto = new CustomerPortalController.LoanSwitcherRequestDto();
        requestDto.requestedAccountId = authorisedUser.AccountId;
        // Act
        List<CustomerPortalController.LoanSwitcherDto> result;
        Test.startTest();
        System.runAs(u)
        {
            result = CustomerPortalController.getLoans(requestDto);
        }
        Test.stopTest();
        // Assert
        System.assertNotEquals(null, result);
        System.assertEquals(0, result.size());

    }

    @IsTest
    static void testGetStatementInformationAuthorised()
    {
        User u = getAuthorisedUser();
        CustomerPortalController.LoanAccountRequestDto requestDto = new CustomerPortalController.LoanAccountRequestDto();
        requestDto.loanAccountId = [SELECT Id FROM loan__Loan_Account__c].Id;
        Attachment attachment = new Attachment();
        attachment.Name = 'Half Yearly Statement Jun 2021';
        attachment.Body = Blob.valueOf('Test Data');
        attachment.ParentId = requestDto.loanAccountId;
        insert attachment;

        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.Title = 'Half Yearly Statement Jun 2021';
        cv.PathOnClient = 'Test ContentVersion';
        cv.VersionData = Blob.valueOf('testData');
        cv.SharingPrivacy = 'N';
        insert cv;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;

        cdl.LinkedEntityId = requestDto.loanAccountId;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
        System.assertNotEquals(null, cdl.Id);

        // Act
        List<CustomerPortalController.TabulatedDetailsResponseDto> result;
        Test.startTest();
        System.runAs(u)
        {
            result = CustomerPortalController.getStatementDetails(requestDto);
        }
        Test.stopTest();
        // Assert
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());

    }

    @IsTest
    static void testGetStatementInformationUnauthorised()
    {
        User u = getUnauthorisedUser();
        CustomerPortalController.LoanAccountRequestDto requestDto = new CustomerPortalController.LoanAccountRequestDto();
        requestDto.loanAccountId = [SELECT Id FROM loan__Loan_Account__c].Id;
        Attachment attachment = new Attachment();
        attachment.Name = 'Half Yearly Statement Jun 2021';
        attachment.Body = Blob.valueOf('Test Data');
        attachment.ParentId = requestDto.loanAccountId;
        insert attachment;

        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.Title = 'Half Yearly Statement Jun 2021';
        cv.PathOnClient = 'Test ContentVersion';
        cv.VersionData = Blob.valueOf('testData');
        insert cv;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;

        cdl.LinkedEntityId = requestDto.loanAccountId;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
        System.assertNotEquals(null, cdl.Id);

        // Act
        List<CustomerPortalController.TabulatedDetailsResponseDto> result;
        Test.startTest();
        System.runAs(u)
        {
            result = CustomerPortalController.getStatementDetails(requestDto);
        }
        Test.stopTest();
        // Assert
        System.assertNotEquals(null, result);
        System.assertEquals(0, result.size());

    }

//    @IsTest
//    static void testGetStatementFileAuthorised()
//    {
//        User u = getAuthorisedUser();
//        CustomerPortalController.StatementDownloadRequestDto requestDto = new CustomerPortalController.StatementDownloadRequestDto();
//        requestDto.loanAccountId = [SELECT Id FROM loan__Loan_Account__c].Id;
//        ContentVersion cv = new ContentVersion();
//        cv.ContentLocation = 'S';
//        cv.Title = 'Test ContentVersion';
//        cv.PathOnClient = 'Test ContentVersion';
//        cv.VersionData = Blob.valueOf('testData');
//        insert cv;
//
//        ContentDocumentLink cdl = new ContentDocumentLink();
//        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
//
//        cdl.LinkedEntityId = requestDto.loanAccountId;
//        cdl.ShareType = 'V';
//        cdl.Visibility = 'AllUsers';
//        insert cdl;
//        System.assertNotEquals(null, cdl.Id);
//
//        requestDto.statementId = cdl.Id;
//        // Act
//        List<String> results;
//        Test.startTest();
//        System.runAs(u)
//        {
//            results = CustomerPortalController.getStatementFile(requestDto);
//        }
//        Test.stopTest();
//        // Assert
//        System.assertNotEquals(0, results.size());
//        System.assertEquals('Half Yearly Statement Jun 2021', results[0]);
//        System.assertEquals(EncodingUtil.base64Encode(Blob.valueOf('Test Data')), results[1]);
//    }
//
//    @IsTest
//    static void testGetStatementFileUnauthorised()
//    {
//        User u = getUnauthorisedUser();
//        CustomerPortalController.StatementDownloadRequestDto requestDto = new CustomerPortalController.StatementDownloadRequestDto();
//        requestDto.loanAccountId = [SELECT Id FROM loan__Loan_Account__c].Id;
//        Attachment attachment = new Attachment();
//        attachment.Name = 'Half Yearly Statement Jun 2021';
//        attachment.Body = Blob.valueOf('Test Data');
//        attachment.ParentId = requestDto.loanAccountId;
//        insert attachment;
//
//        requestDto.statementId = attachment.Id;
//        // Act
//        List<String> results;
//        Test.startTest();
//        System.runAs(u)
//        {
//            results = CustomerPortalController.getStatementFile(requestDto);
//        }
//        Test.stopTest();
//        // Assert
//        System.assertEquals(null, results[0]);
//        System.assertEquals(null, results[1]);
//    }

    @IsTest
    static void testGetPortalUserInfo()
    {
        User u = getAuthorisedUser();
        // Act
        CustomerPortalController.UserDetailsDto result;
        Test.startTest();
        System.runAs(u)
        {
            result = CustomerPortalController.getPortalUserInfo();
        }
        Test.stopTest();
        // Assert
        System.assertNotEquals(null, result);
        System.assertNotEquals(null, result);
    }

    @IsTest
    static void testUpdatePortalUserInfo()
    {
        User u = getAuthorisedUser();
        // Act
        CustomerPortalController.UserDetailsDto request;
        System.runAs(u)
        {
            request = CustomerPortalController.getPortalUserInfo();
        }
        request.phone = '99998888';
        Boolean result = false;
        Test.startTest();
        System.runAs(u)
        {
            result = CustomerPortalController.updatePortalUserInfo(request);
        }
        Test.stopTest();
        // Assert
        System.assertEquals(true, result);
    }


    @IsTest
    static void testException()
    {
        CustomerPortalException.test();
    }

    @IsTest
    static void testDirectDebitDto()
    {
        PortalManageDirectDebitRequestDto requestDto = new PortalManageDirectDebitRequestDto();
        requestDto.recordId = 'test';
        requestDto.loanAccountId = 'test';
        requestDto.isDelete = false;
        requestDto.directDebitType = 'test';
        requestDto.amountType = 'test';
        requestDto.debitDate = Date.today();
        requestDto.transactionAmount = 1;
        requestDto.frequency = 'test';

    }

}