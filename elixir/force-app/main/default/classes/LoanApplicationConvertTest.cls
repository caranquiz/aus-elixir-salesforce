/************************************************************************
Description: Test class for LoanApplicationConvert
Developer: Rameswari Barman
**************************************************************************/
@isTest
public class LoanApplicationConvertTest{
    public static testmethod void test1(){
    
        //Inserting legal entity
        clcommon__Legal_Entity__c legEntity = new clcommon__Legal_Entity__c(Name = 'Individual');
        insert legEntity;
        System.assertEquals(legEntity.Name,'Individual');
            
        //Inserting Account
        Account acc = new Account(name = 'Test account',clcommon__Legal_Entity_Type__c = legEntity.id);
        insert acc;
        System.assertEquals(acc.name,'Test account');
        
        
        //Test data using the Loan Product
        loan.TestHelper.createSeedDataForTesting();
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        
        //Create a dummy MF_Account
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        loan__MF_Account__c dummyIncAccount = loan.TestHelper.createMFAccount('XXXIncAccountForTest','30000 - INCOME');
        
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr,dummyIncAccount ,dummyAccount);                                   
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);
        
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        
        //Create a dummy Loan Product
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(dummyOffice,
                                        dummyAccount, 
                                        curr, 
                                        dummyFeeSet);
                                        
        upsert dummyLP;
        
        
        //inserting CL product 
        clcommon__CL_Product__c clp= new clcommon__CL_Product__c(clcommon__Product_Name__c='Interest Only', loan__Lending_Product__c=dummyLP.Id);
        insert clp;                                
        System.assertEquals(clp.clcommon__Product_Name__c,'Interest Only');
        
        //Inserting Applications
        genesis__applications__c app = new genesis__applications__c(genesis__Status__c='Approved',
                                                                    genesis__Fees_Amount__c=10,
                                                                    genesis__account__c = acc.id,
                                                                    genesis__Term__c=12,
                                                                    genesis__Interest_Rate__c=10,
                                                                    genesis__Payment_Frequency__c=ConstantValues.MONTHLY,
                                                                    genesis__Loan_Amount__c=10000,
                                                                    genesis__CL_Product__c=clp.id);
        insert app;
        System.assertEquals(app.genesis__Status__c,'Approved');
        
        //Inserting borrower bank account
        loan__Bank_Account__c borrBank= new loan__Bank_Account__c();
        borrBank.loan__Account__c=acc.Id;
        borrBank.loan__Account_Type__c='Saving';
        borrBank.loan__Account_Usage__c='Borrower/Investor Account';
        borrBank.loan__Bank_Account_Number__c='21432534543';
        borrBank.loan__Active__c=true;
        borrBank.loan__Bank_Name__c ='SBI';
        insert borrBank;
        System.assertEquals(borrBank.loan__Bank_Name__c,'SBI');
        
        //Inserting Borrower Party
        list< clcommon__Party_Type__c > partyTypes= new list<clcommon__Party_Type__c>();
        partyTypes.add(new clcommon__Party_Type__c(Name='BORROWER'));
        partyTypes.add(new clcommon__Party_Type__c(Name='Solicitor'));
        insert partyTypes;
        System.assertEquals(partyTypes.size(),2);
        
        //Inserting borrower Party
        clcommon__Party__c borrParty= new clcommon__Party__c(clcommon__Account__c=acc.Id, genesis__Application__c=app.Id,clcommon__Type__c=[select id from clcommon__Party_Type__c Where Name='BORROWER'].Id);
        insert borrParty;
        System.assertEquals(borrParty.clcommon__Account__c,acc.Id);
        
        //inserting Solicitor Account
        Account solicitorAcc= new Account();
        solicitorAcc.name = 'Test account';
        solicitorAcc.clcommon__Legal_Entity_Type__c = legEntity.id;
        insert solicitorAcc;
        System.assertEquals(solicitorAcc.name,'Test account');
        
        //Inserting solicitor Acc
        loan__Bank_Account__c soliBank= new loan__Bank_Account__c();
        soliBank.loan__Account__c=solicitorAcc.Id;
        soliBank.loan__Account_Type__c='Saving';
        soliBank.loan__Account_Usage__c='Borrower/Investor Account';
        soliBank.loan__Bank_Account_Number__c='21432534543';
        soliBank.loan__Active__c=true;
        soliBank.loan__Bank_Name__c ='SBI';
        insert soliBank;
        System.assertEquals(soliBank.loan__Bank_Name__c,'SBI');
        
        //Inserting borrower Party
        clcommon__Party__c solicitorParty= new clcommon__Party__c(clcommon__Account__c=solicitorAcc.Id, genesis__Application__c=app.Id,clcommon__Type__c=[select id from clcommon__Party_Type__c Where Name='Solicitor'].Id);
        insert solicitorParty;
        System.assertEquals(solicitorParty.clcommon__Account__c,solicitorAcc.Id);
        
        Test.startTest();
            String st=LoanApplicationConvert.convertLoanApplicationCtrl(app.Id);
            System.assert(st!=null);
        Test.stopTest();    
                
    }
    
    //Test Method 2
    public static testmethod void test2(){
        
        //Inserting legal entity
        clcommon__Legal_Entity__c legEntity = new clcommon__Legal_Entity__c(Name = 'Individual');
        insert legEntity;
        System.assertEquals(legEntity.Name,'Individual');
            
        //Inserting Account
        Account acc = new Account(name = 'Test account',clcommon__Legal_Entity_Type__c = legEntity.id);
        insert acc;
        System.assertEquals(acc.name,'Test account');
        
        //Test data using the Loan Product
        loan.TestHelper.createSeedDataForTesting();
        loan__Currency__c curr = loan.TestHelper.createCurrency();
        
        //Create a dummy MF_Account
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        loan__MF_Account__c dummyIncAccount = loan.TestHelper.createMFAccount('XXXIncAccountForTest','30000 - INCOME');
        
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr,dummyIncAccount ,dummyAccount);                                   
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);
        
        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();
        
        //Create a dummy Loan Product
        loan__Loan_Product__c dummyLP = loan.TestHelper.createLoanProduct(dummyOffice,
                                        dummyAccount, 
                                        curr, 
                                        dummyFeeSet);
                                        
        upsert dummyLP;
        
        
        //inserting CL product 
        clcommon__CL_Product__c clp= new clcommon__CL_Product__c(clcommon__Product_Name__c='Interest Only', loan__Lending_Product__c=dummyLP.Id);
        insert clp;                                
        System.assertEquals(clp.clcommon__Product_Name__c,'Interest Only');
        
        //Inserting Applications
        genesis__applications__c app = new genesis__applications__c(genesis__Status__c=ConstantValues.Approved,
                                                                    genesis__Fees_Amount__c=10,
                                                                    genesis__account__c = acc.id,
                                                                    genesis__Term__c=12,
                                                                    genesis__Interest_Rate__c=10,
                                                                    genesis__Payment_Frequency__c=ConstantValues.MONTHLY,
                                                                    genesis__Loan_Amount__c=10000,
                                                                    genesis__CL_Product__c=clp.id);
        insert app;
        System.assertEquals(app.genesis__Status__c,'Approved');
        
        insert new clcommon__Repayment_Plan__c(genesis__Application__c =app.Id, 
                                               clcommon__Frequency__c='Monthly',
                                               clcommon__Payment_Type__c='Interest Only',
                                               clcommon__Number_Of_Payments__c=1,
                                               clcommon__Payment_Start_Date__c=Date.today());
        
        //Inserting borrower bank account
        loan__Bank_Account__c borrBank= new loan__Bank_Account__c();
        borrBank.loan__Account__c=acc.Id;
        borrBank.loan__Account_Type__c='Saving';
        borrBank.loan__Account_Usage__c='Borrower/Investor Account';
        borrBank.loan__Bank_Account_Number__c='21432534543';
        borrBank.loan__Active__c=true;
        borrBank.loan__Bank_Name__c ='SBI';
        insert borrBank;
        System.assertEquals(borrBank.loan__Bank_Name__c,'SBI');
        
        //Inserting Borrower Party
        list< clcommon__Party_Type__c > partyTypes= new list<clcommon__Party_Type__c>();
        partyTypes.add(new clcommon__Party_Type__c(Name='BORROWER'));
        partyTypes.add(new clcommon__Party_Type__c(Name='Solicitor'));
        insert partyTypes;
        System.assertEquals(partyTypes.size(),2);
        
        //Inserting borrower Party
        clcommon__Party__c borrParty= new clcommon__Party__c(clcommon__Account__c=acc.Id, genesis__Application__c=app.Id,clcommon__Type__c=[select id from clcommon__Party_Type__c Where Name='BORROWER'].Id);
        insert borrParty;
        System.assertEquals(borrParty.clcommon__Account__c,acc.Id);
        
        //inserting Solicitor Account
        Account solicitorAcc= new Account();
        solicitorAcc.name = 'Test account';
        solicitorAcc.clcommon__Legal_Entity_Type__c = legEntity.id;
        insert solicitorAcc;
        System.assertEquals(solicitorAcc.name,'Test account');
        
        //Inserting solicitor Acc
        loan__Bank_Account__c soliBank= new loan__Bank_Account__c();
        soliBank.loan__Account__c=solicitorAcc.Id;
        soliBank.loan__Account_Type__c='Saving';
        soliBank.loan__Account_Usage__c='Borrower/Investor Account';
        soliBank.loan__Bank_Account_Number__c='21432534543';
        soliBank.loan__Active__c=true;
        soliBank.loan__Bank_Name__c ='SBI';
        insert soliBank;
        System.assertEquals(soliBank.loan__Bank_Name__c,'SBI');
        
        //Inserting borrower Party
        clcommon__Party__c solicitorParty= new clcommon__Party__c(clcommon__Account__c=solicitorAcc.Id, genesis__Application__c=app.Id,clcommon__Type__c=[select id from clcommon__Party_Type__c Where Name='Solicitor'].Id);
        insert solicitorParty;
        System.assertEquals(solicitorParty.clcommon__Account__c,solicitorAcc.Id);
        
        Test.startTest();
            String st=LoanApplicationConvert.convertLoanApplicationCtrl(app.Id);
            System.assert(st!=null);
        Test.stopTest();    
                
    }
    
}