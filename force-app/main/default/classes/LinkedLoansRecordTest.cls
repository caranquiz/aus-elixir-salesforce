/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class give coverage to LinkedLoansExtension,LinkedLoanDetails,
                UpdateSumOfLinkedLoanTest and WebServiceExecuteBatches  apex class.
Development Date : 6/05/2021
Last Modified Date : 20/05/2021
****************************************************************************************************/

@isTest(SeeAllData=false)
public class LinkedLoansRecordTest {
    @TestSetup
    static void initialize(){

        loan__Org_Parameters__c checkTrigger = ElixirTestHelper.returnOrgParameter();
        insert checkTrigger;
        checkTrigger = loan__Org_Parameters__c.getInstance();
        System.assertEquals(
        checkTrigger.loan__Disable_Triggers__c,
        true,
        'Org Parameter config error');

        clcommon__Legal_Entity__c legalEntity=ElixirTestHelper.returnLegalEntity();
        insert legalEntity;
        System.assertEquals(
        legalEntity.Name, 
        'Individual', 
        'Legal Entity Inserted Succesfully');

        Account testAccount = ElixirTestHelper.returnBorrowerAccount(legalEntity.id);
        insert testAccount;
        System.assertEquals(
        testAccount.name,
        'Rameswari Barman',
        'Account Inserted Successfully');

        genesis__applications__c testApplication = ElixirTestHelper.returnApplication(testAccount.id);
        insert testApplication;
        System.assertEquals(
        testApplication.genesis__Loan_Amount__c, 
        100000, 
        'Application Inserted Succesfully');

        loan__Loan_Account__c testLoanAccount = ElixirTestHelper.returnLoan(testAccount.id,testApplication.id);
        testLoanAccount.loan__Loan_Amount__c = 500000;
        testLoanAccount.loan__Loan_Status__c = 'Approved';
        insert testLoanAccount;
        System.assertEquals(
        testLoanAccount.loan__Loan_Amount__c, 
        500000, 
        'Loan Account Inserted Successfully');

        loan__Loan_Account__c testLoanAccount2 = ElixirTestHelper.returnLoan(testAccount.id,testApplication.id);
        testLoanAccount2.loan__Loan_Amount__c = 550000;
        testLoanAccount2.loan__Loan_Status__c = 'Approved';
        insert testLoanAccount2;
        System.assertEquals(testLoanAccount2.loan__Loan_Amount__c, 
        550000, 
        'Loan Account Inserted Successfully');

    }
	@isTest
    static void deleteRecordTest1(){
        
        List<loan__Loan_Account__c> llaList=[SELECT id,
                                         loan__Loan_Amount__c 
                                     FROM loan__Loan_Account__c];
        system.assertNotEquals(llaList.size(), 
        0, 
        'Loan Account is Present');
        
        Linked_Loan__c linkedloan=ElixirTestHelper.returnlinkedLoan(llaList[0].id,llaList[1].id);
        insert linkedloan;
        system.assertEquals(
        linkedloan.Current_Loan_Record__c,
        llaList[0].id,
        'Linked Loan Inserted Successfully');

        Linked_Loan__c linkedloan1=ElixirTestHelper.returnlinkedLoan(llaList[1].id,llaList[0].id);
        insert linkedloan1;
        system.assertEquals(
        linkedloan1.Current_Loan_Record__c,
        llaList[1].id,
        'Linked Loan Inserted Successfully');

        PageReference pageRef =page.LinkedLoansPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',llaList[0].id);
        
        ApexPages.StandardController stc = new ApexPages.StandardController(llaList[0]);
        
        test.startTest();
        LinkedLoanDetails obj=new LinkedLoanDetails(stc);
        obj.llId=linkedloan.id;
        PageReference objPageRef = obj.deleteRecord();
        
        test.stopTest();
            
    }
    @isTest
    static void deleteRecordTest2(){
        
        List<loan__Loan_Account__c> llaList=[SELECT id,
                                         loan__Loan_Amount__c 
                                     FROM loan__Loan_Account__c];
        system.assertNotEquals(
        llaList.size(), 
        0, 
        'Loan Account is Present');

        PageReference pageRef =page.LinkedLoansPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',llaList[0].id);
        
        ApexPages.StandardController stc = new ApexPages.StandardController(llaList[0]);
        
        test.startTest();
        LinkedLoanDetails obj=new LinkedLoanDetails(stc);
        PageReference objPageRef = obj.deleteRecord();
        
        test.stopTest();
            
    }

    @isTest
    static void saveRecordTest(){
        
        List<loan__Loan_Account__c> llaList=[SELECT id,
                                         loan__Loan_Amount__c 
                                     FROM loan__Loan_Account__c];
        system.assertNotEquals(
        llaList.size(), 
        0, 
        'Loan Account is Present');
        
        PageReference pageRef =page.CustomLinkedLoansPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('loanId',llaList[0].id);
        
        ApexPages.StandardController stc = new ApexPages.StandardController(llaList[0]);
        
        test.startTest();
        LinkedLoansExtension obj=new LinkedLoansExtension(stc);
        obj.linkedLoan1.Current_Loan_Record__c=llaList[0].id;
        obj.linkedLoan1.Linked_Loan__c=llaList[1].id;
        obj.linkedLoan2.Current_Loan_Record__c=llaList[0].id;
        obj.linkedLoan2.Linked_Loan__c=llaList[1].id;
        PageReference objPageRef = obj.Save();
        test.stopTest();
            
    }
    @isTest
    static void cancelTest(){
        
        List<loan__Loan_Account__c> llaList=[SELECT id,
                                                    loan__Loan_Amount__c 
                                                FROM loan__Loan_Account__c 
                                                WHERE loan__Loan_Amount__c=500000 
                                                LIMIT 1];
        system.assertEquals(
        llaList.size(),
        1,
        'Loan Account is present');

        PageReference pageRef =page.CustomLinkedLoansPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('loanId',llaList[0].id);
        
        ApexPages.StandardController stc = new ApexPages.StandardController(llaList[0]);
        
        test.startTest();
        LinkedLoansExtension obj=new LinkedLoansExtension(stc);
        PageReference objPageRef = obj.Cancel();
        
        test.stopTest();
            
    }

    @isTest
    static void UpdateSumOfLinkedLoanTest(){

        List<loan__Loan_Account__c> llaList=[SELECT id,
                                         loan__Loan_Amount__c 
                                     FROM loan__Loan_Account__c];
        system.assertNotEquals(
        llaList.size(), 
        0, 
        'Loan Account is Present');
        
        Linked_Loan__c linkedloan=ElixirTestHelper.returnlinkedLoan(llaList[0].id,llaList[1].id);
        insert linkedloan;
        system.assertEquals(linkedloan.Current_Loan_Record__c,
        llaList[0].id,
        'Linked Loan Inserted Successfully');

        test.startTest();
        UpdateSumOfLinkedLoanBatch obj=new UpdateSumOfLinkedLoanBatch();
        String sch = '0 0 23 * * ?';
		system.schedule('Test Check', sch, obj );
        WebServiceExecuteBatches.ExecuteUpdateSumOfLinkedLoanBatch();
        test.stopTest();
    }
}