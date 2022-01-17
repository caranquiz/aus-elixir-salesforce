/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class give coverage to TaskRelatedLoanController  apex class.
Development Date : 14/01/2022
Last Modified Date : 14/01/2022
****************************************************************************************************/

@isTest(SeeAllData=false)
public class ActivityPageRecordTest {
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
    static void deleteRecordTest(){
        
        List<loan__Loan_Account__c> loanAccountList=[SELECT id,
                                                            loan__Loan_Amount__c 
                                                        FROM loan__Loan_Account__c];
        system.assertNotEquals(
            loanAccountList.size(), 
            0, 
            'Loan Account is Present'
        );
        
        List<Task> taskList=[SELECT id FROM Task];
		system.assertNotEquals(
            taskList.size(), 
            0, 
            'Task is Present'
        );
        
        PageReference pageRef =page.LinkedLoansPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',loanAccountList[0].id);
        
        ApexPages.StandardController stc = new ApexPages.StandardController(loanAccountList[0]);
        
        test.startTest();
        TaskRelatedLoanController obj=new TaskRelatedLoanController(stc);
        obj.gettaskList();
        obj.taskId=taskList[0].id;
        PageReference objPageRef = obj.deleteTask();
        System.assert(objPageRef != null, 'No Task is selected to delete');
        test.stopTest();
            
    }
}