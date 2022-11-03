/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class give coverage to SendSMSControllerClass,
                CreateTaskToContract,QueueUserTriggerHelper,
                LoanContactExtension,TaskRelatedLoanContractController apex class.
Development Date : 28/09/2022
Last Modified Date : 28/09/2022
****************************************************************************************************/

@isTest(SeeAllData=false)
public class CollectionModuleTest {
    @TestSetup
    static void initialize(){
        loan__Org_Parameters__c checkTrigger = GenericUtilityTestHelper.returnOrgParameter();
        checkTrigger = loan__Org_Parameters__c.getInstance();
        System.AssertEquals(
            checkTrigger.loan__Disable_Triggers__c,
            true,
            'Org Parameter error'
        );
        clcommon__Legal_Entity__c legalEntity = GenericUtilityTestHelper.returnLegalEntity();
        System.AssertNotEquals(
        legalEntity.Id,
        null,
        'Legal Entity inserted successfully.'
        );

        User objUser = GenericUtilityTestHelper.returnUser();
        System.AssertNotEquals(
            objUser.Id,
            null,
            ' User inserted successfully.'
        );

        //Collection Queue
        collect__Queue__c objQueue=GenericUtilityTestHelper.returnQueue();
        System.AssertNotEquals(
            objQueue.Id,
            null,
            ' Queue inserted successfully.'
        );

        //Collection Queue User
        collect__Queue_User__c objQueueUserTest=GenericUtilityTestHelper.returnQueueuser(
            objUser.id,
            objQueue.id
        );
        System.AssertNotEquals(
            objQueueUserTest.Id,
            null,
            ' Queue User inserted successfully.'
        );

        //Inserting Account
        Account testAccount = GenericUtilityTestHelper.returnBorrowerAccount(
        legalEntity.Id
        );
        System.AssertNotEquals(
        testAccount.Id,
        null,
        ' Account inserted successfully.'
        );
        
        //Inserting Contact
        Contact testContact = GenericUtilityTestHelper.insertDummyContact(
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
        System.assertNotEquals(
            testApplication.Id,
            null,
            ' Application inserted Successfully'
        );

        //Payment Mode
        loan__Payment_Mode__c testDDPaymentMode = GenericUtilityTestHelper.getPaymentMode();
        System.assertNotEquals(
        testDDPaymentMode.Id,
        null,
        'Payment Mode insert error'
        );

        //CL Contract
        loan__Loan_Account__c testLoanAccount = GenericUtilityTestHelper.returnLoan(
            testAccount.id,
            testApplication.id
        );
        testLoanAccount.loan__Loan_Amount__c = 500000;
        update testLoanAccount;
        List<loan__Loan_Account__c> loanAccountList1=[SELECT id 
                                                        FROM loan__Loan_Account__c 
                                                        WHERE loan__Loan_Amount__c=500000
                                                        LIMIT 1 ];
        System.assertEquals(
            loanAccountList1.size(), 
            1, 
            'Loan Account Inserted Successfully'
        );

        //Contract Parties
        loan__Coborrower__c contractParty = GenericUtilityTestHelper.insertContractParty(
            testAccount,
            testContact,
            testLoanAccount
        );
        contractParty.loan__Party_Type__c = 'Borrower';
        update contractParty;
        List<loan__Coborrower__c> coborrowerList = [
            SELECT Id
            FROM loan__Coborrower__c
            WHERE loan__Party_Type__c='Borrower'
        ];
        System.assertEquals(
            coborrowerList.size(),
            1,
            'Co-Borrower insertion error'
        );

        loan__Coborrower__c contractPartyTwo = GenericUtilityTestHelper.insertContractParty(
            testAccount,
            testContact,
            testLoanAccount
        );
        System.assertNotEquals(
            contractPartyTwo.id,
            null,
            'Co-Borrower insertion successfull'
        );
        contractPartyTwo.loan__Party_Type__c = ConstantValues.CO_APPLICANT;
        contractPartyTwo.loan__Contact__c = null;
        update contractPartyTwo;
        System.assertEquals(
            contractPartyTwo.loan__Party_Type__c,
            ConstantValues.CO_APPLICANT,
            'Co-Borrower updated successfull'
        );

        
        //Salesforce Queue
        Group queryGroup = GenericUtilityTestHelper.returnGroup();
        System.assertNotEquals(
            queryGroup.Id,
            null,
            'Group insert error'
        );

        //Contracts
        collect__Loan_Account__c objLoanContract=GenericUtilityTestHelper.returnCollectAccount(
            testLoanAccount.id,
            testAccount.id,
            testContact.id
        );
        System.assertNotEquals(
            objLoanContract.Id,
            null,
            'Contract insert error'
        );

        //Task
        Task testTask=GenericUtilityTestHelper.returnTask(
            testLoanAccount.id
        );
        System.assertNotEquals(
            testTask.Id,
            null,
            ' Task inserted Successfully'
        );

    }
    @isTest
    static void collectionTestOne(){

        List<loan__Loan_Account__c> loanAccountList=[SELECT id FROM loan__Loan_Account__c ];
        List<collect__Queue_User__c> objQueueUserList=[SELECT id,collect__User__c FROM collect__Queue_User__c];
        List<Id> loanIdList=new List<Id>();
        loanIdList.add(loanAccountList[0].id);
        PageReference pageRef =page.CustomContactSearchPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('loanId',loanAccountList[0].id);

        ApexPages.StandardController stc = new ApexPages.StandardController(loanAccountList[0]);

        test.startTest();

        LoanContactExtension obj=new LoanContactExtension(stc);
        PageReference objPageRef = obj.Cancel();
        
        CreateTaskToContract.createTaskRelatedToContract(loanIdList);
        QueueUserTriggerHelper.QueueUserInsertion(objQueueUserList);
        QueueUserTriggerHelper.QueueUserDeletion(objQueueUserList);
        test.stopTest();
    }
    @isTest      
    static void collectionTestTwo(){

        List<collect__Queue_User__c> objQueueUserList=[SELECT id,collect__User__c FROM collect__Queue_User__c];

        List<collect__Loan_Account__c> objCollectLoansList=[SELECT id FROM collect__Loan_Account__c ];


        PageReference pageRef =page.SendSMSPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',objCollectLoansList[0].id);
        
        ApexPages.StandardController stc = new ApexPages.StandardController(objCollectLoansList[0]);
        
        test.startTest();
        delete objQueueUserList;
        SendSMSControllerClass obj=new SendSMSControllerClass(stc);
        obj.SendSMS();
        test.stopTest();

    }
    @isTest 
    static void collectionTestThree(){
        List<loan__Loan_Account__c> loanAccountList=[SELECT id,
                                                            loan__Loan_Amount__c 
                                                        FROM loan__Loan_Account__c];
        system.assertEquals(
        loanAccountList.size(), 
        1, 
        'Loan Account is Present'
        );

        PageReference pageRef =page.CustomContactSearchPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('loanId',loanAccountList[0].id);

        ApexPages.StandardController stc = new ApexPages.StandardController(loanAccountList[0]);

        test.startTest();
        LoanContactExtension obj=new LoanContactExtension(stc);
        PageReference objPageRef = obj.Save();
        test.stopTest();
    }

    @isTest 
    static void collectionTestFour(){
        List<loan__Loan_Account__c> loanAccountList=[SELECT id,
                                                            loan__Loan_Amount__c 
                                                        FROM loan__Loan_Account__c];
        system.assertEquals(
        loanAccountList.size(), 
        1, 
        'Loan Account is Present'
        );

        List<Contact> objContactList=[SELECT id FROM Contact];
        objContactList[0].Email='abc@cloudkaptan.com';
        update objContactList;

        List<loan__Coborrower__c> objCoBorrowerList=[SELECT id,loan__Contact__c FROM loan__Coborrower__c];
        objCoBorrowerList[0].loan__Contact__c=objContactList[0].id;
        update objCoBorrowerList;

        PageReference pageRef =page.CustomContactSearchPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('loanId',loanAccountList[0].id);

        ApexPages.StandardController stc = new ApexPages.StandardController(loanAccountList[0]);

        test.startTest();
        LoanContactExtension obj=new LoanContactExtension(stc);
        obj.getCoborrowerList();
        PageReference objPageRef = obj.Save();
        test.stopTest();
    }
    @isTest 
    static void collectionTestFive(){
        List<collect__Loan_Account__c> loanAccountList=[SELECT id
                                                        FROM collect__Loan_Account__c];
        system.assertEquals(
        loanAccountList.size(), 
        1, 
        'Contract is Present'
        );
        List<Task> taskList=[SELECT id FROM Task];
        system.assertNotEquals(
                taskList.size(), 
                0, 
                'Task is Present'
            );

        PageReference pageRef =page.TaskRelatedLoanContractPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',loanAccountList[0].id);

        ApexPages.StandardController stc = new ApexPages.StandardController(loanAccountList[0]);

        test.startTest();
        TaskRelatedLoanContractController obj=new TaskRelatedLoanContractController(stc);
        obj.gettaskList();
        obj.taskId=taskList[0].id;
        PageReference objPageRef = obj.deleteTask();
        System.assert(objPageRef != null, 'No Task is selected to delete');
        test.stopTest();
    }

}