/**
 * Created by caleb on 1/07/2022.
 */

@IsTest
public with sharing class LoanAccountTriggerTest
{
    @IsTest(SeeAllData=true)
    public static void test1()
    {
        /*
        Account personAccount = new Account();
        personAccount.RecordTypeId = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();
        personAccount.FirstName = 'Test';
        personAccount.LastName = 'Test';
        personAccount.PersonEmail = 't@t.com';
        insert personAccount;

        loan__Loan_Account__c t = new loan__Loan_Account__c();
        t.loan__Loan_Amount__c = 1.0;
        t.New_Interest_Rate__c = 0.0;
        t.First_Repayment_Date_After_IR_Change__c = Date.today();
        t.Second_Repayment_Date_After_IR_Change__c = Date.today();
        t.loan__Account__c = personAccount.Id;
        insert t;

        //Test.startTest();
        loan__Loan_Account__c t2 = new loan__Loan_Account__c();
        t2.New_Interest_Rate_Effective_Date__c = Date.today();
        t2.Id = t.Id;
        update t2;
        //Test.stopTest();
        */
        List<loan__Loan_Account__c> loanAccounts = [
                SELECT Id, Calculated_Upcoming_Repayment_Amount__c, Remaining_Term_from_Schedule__c
                FROM loan__Loan_Account__c
                WHERE Calculated_Upcoming_Repayment_Amount__c != NULL
                AND Remaining_Term_from_Schedule__c != 0
                ORDER BY Id
                LIMIT 10
        ];
        for (loan__Loan_Account__c loanAccount : loanAccounts)
        {
            loanAccount.New_Interest_Rate__c = 6;
            loanAccount.First_Repayment_Date_After_IR_Change__c = Date.today();
            loanAccount.Second_Repayment_Date_After_IR_Change__c = Date.today().addDays(10);
            loanAccount.New_Interest_Rate_Effective_Date__c = Date.today().addDays(20);
            loanAccount.Scheduled_Balance_As_at_IR_change_date__c = 4;
            loanAccount.loan__Interest_Rate__c = 5;
        }
        Test.startTest();
        update loanAccounts;
        Test.stopTest();
    }

    @IsTest(SeeAllData=true)
    public static void test2()
    {
        List<loan__Loan_Account__c> loanAccounts1 = [
                SELECT Id, Calculated_Upcoming_Repayment_Amount__c, Remaining_Term_from_Schedule__c
                FROM loan__Loan_Account__c
                WHERE Calculated_Upcoming_Repayment_Amount__c != NULL
                AND Remaining_Term_from_Schedule__c != 0
                ORDER BY Id
                LIMIT 10
        ];
        for (loan__Loan_Account__c loanAccount : loanAccounts1)
        {
            loanAccount.New_Interest_Rate__c = 6;
            loanAccount.First_Repayment_Date_After_IR_Change__c = Date.today();
            loanAccount.Second_Repayment_Date_After_IR_Change__c = Date.today().addDays(10);
            loanAccount.New_Interest_Rate_Effective_Date__c = Date.today().addDays(20);
            loanAccount.Scheduled_Balance_As_at_IR_change_date__c = 4;
            loanAccount.loan__Interest_Rate__c = 5;
        }
        List<loan__Loan_Account__c> loanAccounts2 = [
                SELECT Id, Calculated_Upcoming_Repayment_Amount__c, Remaining_Term_from_Schedule__c
                FROM loan__Loan_Account__c
                WHERE Calculated_Upcoming_Repayment_Amount__c != NULL
                AND Remaining_Term_from_Schedule__c != 0
                ORDER BY Id
                LIMIT 10
        ];
        for (loan__Loan_Account__c loanAccount : loanAccounts2)
        {
            loanAccount.New_Interest_Rate__c = 6;
            loanAccount.First_Repayment_Date_After_IR_Change__c = Date.today();
            loanAccount.Second_Repayment_Date_After_IR_Change__c = Date.today().addDays(10);
            loanAccount.New_Interest_Rate_Effective_Date__c = Date.today().addDays(20);
            loanAccount.Scheduled_Balance_As_at_IR_change_date__c = 4;
            loanAccount.loan__Interest_Rate__c = 5;
        }
        Test.startTest();
        update loanAccounts1;
        update loanAccounts2;
        Test.stopTest();
    }
}