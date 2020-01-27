/************************************************************************
Description: Test class for PrepaidFeeCalculatorClass
Developer: Rameswari Barman
**************************************************************************/
@isTest
public class PrepaidFeeCalculatorClassTest{
    public static testmethod void test1(){
        //Disabling triggers
        insert new genesis__Org_Parameters__c(genesis__Disable_Triggers__c=true);
        System.assert(genesis__Org_Parameters__c.getInstance()!=null);
        
        //Fee structure
        list<Elixir_Before_Or_On_Settlement_Fees__c> feeSetup= new list<Elixir_Before_Or_On_Settlement_Fees__c>();
        feeSetup.add(new Elixir_Before_Or_On_Settlement_Fees__c(Name='Application Fee', Distribution_Type__c='Pre-Paid Fee', Fee_Field_API_Name__c='Application_Fee__c'));
        insert feeSetup;
        System.assert(Elixir_Before_Or_On_Settlement_Fees__c.getAll().size()==1);
        
        //Inserting legal entity
        clcommon__Legal_Entity__c legEntity = new clcommon__Legal_Entity__c(Name = 'Individual');
        insert legEntity;
        System.assertEquals(legEntity.name,'Individual');
            
        //Inserting Account
        Account acc = new Account(name = 'Rameswari Barman',clcommon__Legal_Entity_Type__c = legEntity.id);
        insert acc;
        
        //Inserting Applications
        genesis__applications__c app = new genesis__applications__c(genesis__Fees_Amount__c=10,genesis__account__c = acc.id);
        insert app;
        System.assertEquals(app.genesis__Fees_Amount__c,10);
        
        acc.last_Approved_Application_ID__c = app.Id;
        update acc;
        
        loan__Loan_Account__c  loanAcc=ElixirTestHelper.returnLoanAccount();
        loanAcc.loan__Account__c=acc.Id;
        loanAcc.loan__Frequency_of_Loan_Payment__c='Weekly';
        loanAcc.Application__c = app.Id;
        upsert loanAcc;
        System.assertEquals(loanAcc.loan__Account__c,acc.Id);

        Test.startTest();
        PrepaidFeeCalculatorClass feeClsObj= new PrepaidFeeCalculatorClass();
        Decimal fee1=feeClsObj.computeFee(new loan__Fee__c(Name='Application Fee'),loanAcc);
        Test.stopTest();            
    }
    public static testmethod void test2(){
        //Disabling triggers
        insert new genesis__Org_Parameters__c(genesis__Disable_Triggers__c=true);
        System.assert(genesis__Org_Parameters__c.getInstance()!=null);
        
        //Fee structure
        list<Elixir_Before_Or_On_Settlement_Fees__c> feeSetup= new list<Elixir_Before_Or_On_Settlement_Fees__c>();
        feeSetup.add(new Elixir_Before_Or_On_Settlement_Fees__c(Name='Application Fee', Distribution_Type__c='Pre-Paid Fee', Fee_Field_API_Name__c='Application_Fee__c'));
        insert feeSetup;
        System.assert(Elixir_Before_Or_On_Settlement_Fees__c.getAll().size()==1);
        
        //Inserting legal entity
        clcommon__Legal_Entity__c legEntity = new clcommon__Legal_Entity__c(Name = 'Individual');
        insert legEntity;
        System.assertEquals(legEntity.Name,'Individual');
            
        //Inserting Account
        Account acc = new Account(name = 'Rameswari Barman',clcommon__Legal_Entity_Type__c = legEntity.id);
        insert acc;
        System.assertEquals(acc.name,'Rameswari Barman');
        
        //Inserting Applications
        genesis__applications__c app = new genesis__applications__c(genesis__Fees_Amount__c=10,genesis__account__c = acc.id);
        insert app;
        System.assertEquals(app.genesis__Fees_Amount__c,10);
        
        acc.last_Approved_Application_ID__c = app.Id;
        update acc;

        loan__Loan_Account__c  loanAcc=ElixirTestHelper.returnLoanAccount();
        loanAcc.loan__Account__c=acc.Id;
        loanAcc.loan__Frequency_of_Loan_Payment__c='Weekly';
        loanAcc.Application__c = app.Id;
        upsert loanAcc;
        System.assertEquals(loanAcc.loan__Account__c,acc.Id);

        Test.startTest();
        PrepaidFeeCalculatorClass feeClsObj= new PrepaidFeeCalculatorClass();
        Decimal fee1=feeClsObj.computeFee(new loan__Fee__c(Name='A'),loanAcc);
        Test.stopTest();            
    }
}