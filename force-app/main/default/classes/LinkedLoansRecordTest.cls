/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class give coverage to LinkedLoansExtension,LinkedLoanRelatedLoanController,
                TotalSumOfLinkedLoanUpdateBatch and TotalSumOfLinkedLoanBatchExecution  apex class.
Development Date : 6/05/2021
Last Modified Date : 20/05/2021
****************************************************************************************************/

@isTest(SeeAllData=false)
public class LinkedLoansRecordTest {
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

        //Inserting Account
        Account testAccount = GenericUtilityTestHelper.returnBorrowerAccount(
        legalEntity.Id
        );
        System.AssertNotEquals(
        testAccount.Id,
        null,
        ' Account inserted successfully.'
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

        loan__Loan_Account__c testLoanAccount2 = GenericUtilityTestHelper.returnLoan(
            testAccount.id,
            testApplication.id
        );
        testLoanAccount2.loan__Loan_Amount__c = 550000;
        update testLoanAccount2;
        List<loan__Loan_Account__c> loanAccountList2=[SELECT id 
                                                        FROM loan__Loan_Account__c 
                                                        WHERE loan__Loan_Amount__c= 550000 
                                                        LIMIT 1 ];
        System.assertEquals(
            loanAccountList2.size(), 
            1, 
            'Loan Account Inserted Successfully'
        );

        Linked_Loan__c linkedloan1=GenericUtilityTestHelper.returnlinkedLoan(
            testLoanAccount2.id,
            testLoanAccount.id
        );
        system.assertEquals(
            linkedloan1.Linked_Loan__c,
            testLoanAccount.id,
            'Linked Loan Inserted Successfully'
        );

        Linked_Loan__c linkedloan2=GenericUtilityTestHelper.returnlinkedLoan(
            testLoanAccount2.id,
            testLoanAccount2.id
        );
        system.assertEquals(
            linkedloan2.Linked_Loan__c,
            testLoanAccount2.id,
            'Linked Loan Inserted Successfully'
        );

    }
	@isTest
    static void deleteRecordTest1(){
        
        List<loan__Loan_Account__c> loanAccountList=[SELECT id,
                                         loan__Loan_Amount__c 
                                     FROM loan__Loan_Account__c];
        system.assertEquals(
            loanAccountList.size(), 
            2, 
            'Loan Account is Present'
        );
        
        Linked_Loan__c linkedloan=GenericUtilityTestHelper.returnlinkedLoan(
            loanAccountList[0].id,
            loanAccountList[1].id
        );
        system.assertEquals(
            linkedloan.Linked_Loan__c,
            loanAccountList[1].id,
            'Linked Loan Inserted Successfully'
        );

        PageReference pageRef =page.LinkedLoansPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',loanAccountList[0].id);
        
        ApexPages.StandardController stc = new ApexPages.StandardController(loanAccountList[0]);
        
        test.startTest();
        LinkedLoanRelatedLoanController obj=new LinkedLoanRelatedLoanController(stc);
        obj.linkedLoanId=linkedloan.id;
        PageReference objPageRef = obj.deleteLinkedLoan();
        test.stopTest();
            
    }
    @isTest
    static void deleteRecordTest2(){
        
        List<loan__Loan_Account__c> loanAccountList=[SELECT id,
                                         loan__Loan_Amount__c 
                                     FROM loan__Loan_Account__c];
        system.assertNotEquals(
            loanAccountList.size(), 
            0, 
            'Loan Account is Present'
        );

        PageReference pageRef =page.LinkedLoansPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',loanAccountList[0].id);
        
        ApexPages.StandardController stc = new ApexPages.StandardController(loanAccountList[0]);
        
        test.startTest();
        LinkedLoanRelatedLoanController obj=new LinkedLoanRelatedLoanController(stc);
        obj.getLinkedLoanList();
        PageReference objPageRef = obj.deleteLinkedLoan();
        
        test.stopTest();
            
    }

    @isTest
    static void saveRecordTest1(){
        
        List<loan__Loan_Account__c> loanAccountList=[SELECT id,
                                         loan__Loan_Amount__c 
                                     FROM loan__Loan_Account__c];
        system.assertEquals(
            loanAccountList.size(), 
            2, 
            'Loan Account is Present'
        );
        
        PageReference pageRef =page.CustomLinkedLoansPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('loanId',loanAccountList[0].id);
        
        ApexPages.StandardController stc = new ApexPages.StandardController(loanAccountList[0]);
        
        test.startTest();
        LinkedLoansExtension obj=new LinkedLoansExtension(stc);
        obj.linkedLoan1.Current_Loan_Record__c=loanAccountList[0].id;
        obj.linkedLoan1.Linked_Loan__c=loanAccountList[1].id;
        obj.linkedLoan2.Current_Loan_Record__c=loanAccountList[0].id;
        obj.linkedLoan2.Linked_Loan__c=loanAccountList[1].id;
        PageReference objPageRef = obj.Save();
        test.stopTest();
            
    }
    @isTest
    static void saveRecordTest2(){
        
        List<loan__Loan_Account__c> loanAccountList=[SELECT id,
                                         loan__Loan_Amount__c 
                                     FROM loan__Loan_Account__c];
        system.assertEquals(
            loanAccountList.size(), 
            2, 
            'Loan Account is Present'
        );
        
        PageReference pageRef =page.CustomLinkedLoansPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('loanId',loanAccountList[0].id);
        
        ApexPages.StandardController stc = new ApexPages.StandardController(loanAccountList[0]);
        
        test.startTest();
        LinkedLoansExtension obj=new LinkedLoansExtension(stc);
        obj.linkedLoan1.Current_Loan_Record__c=loanAccountList[0].id;
        obj.linkedLoan1.Linked_Loan__c=loanAccountList[0].id;
        obj.linkedLoan2.Current_Loan_Record__c=loanAccountList[0].id;
        obj.linkedLoan2.Linked_Loan__c=loanAccountList[1].id;
        PageReference objPageRef = obj.Save();
        test.stopTest();
            
    }
    @isTest
    static void cancelTest(){
        
        List<loan__Loan_Account__c> loanAccountList=[SELECT id,
                                                    loan__Loan_Amount__c 
                                                FROM loan__Loan_Account__c 
                                                WHERE loan__Loan_Amount__c=500000 
                                                LIMIT 1];
        system.assertEquals(
            loanAccountList.size(),
            1,
            'Loan Account is present'
        );

        PageReference pageRef =page.CustomLinkedLoansPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('loanId',loanAccountList[0].id);
        
        ApexPages.StandardController stc = new ApexPages.StandardController(loanAccountList[0]);
        
        test.startTest();
        LinkedLoansExtension obj=new LinkedLoansExtension(stc);
        obj.getlinkedLoanList();
        PageReference objPageRef = obj.Cancel();
        
        test.stopTest();
            
    }

    @isTest
    static void UpdateSumOfLinkedLoanTest(){

        List<loan__Loan_Account__c> loanAccountList=[SELECT id,
                                         loan__Loan_Amount__c 
                                     FROM loan__Loan_Account__c];
        system.assertNotEquals(
            loanAccountList.size(), 
            0, 
            'Loan Account is Present'
        );

        test.startTest();
        TotalSumOfLinkedLoanUpdateBatch obj=new TotalSumOfLinkedLoanUpdateBatch();
        String sch = '0 0 23 * * ?';
		system.schedule('Test Check', sch, obj );
        TotalSumOfLinkedLoanBatchExecution.executeTotalSumOfLinkedLoanUpdateBatchWS();
        test.stopTest();
    }
}