@isTest(SeeAllData=false)
global class InvestTest{

    global static testmethod void test1(){
        
        Elixir_Before_Or_On_Settlement_Fees__c fee = new Elixir_Before_Or_On_Settlement_Fees__c();
        fee.name = 'Application Fee';
        fee.Distribution_Type__c = 'Pre-Paid Fee';
        fee.Fee_Field_API_Name__c = 'Application_Fee__c';
        insert fee;
        System.assertEquals(fee.name,'Application Fee');
        
        Account acc1 = new Account();
        acc1.Name = 'Testing';
        acc1.loan__Undeployed_Funds__c = 40000;
        acc1.peer__Auto_Invest__c = True;
        acc1.loan__Investor__c = True;
        insert acc1;
        System.assertEquals(acc1.Name,'Testing'); 
        
        Account acc = new Account();
        acc.Name = 'Testing';
        acc.loan__Undeployed_Funds__c = 1000;
        acc.peer__Auto_Invest__c = True;
        insert acc;
        System.assertEquals(acc.Name,'Testing');
        
        loan__Bank_Account__c bank1 = new loan__Bank_Account__c();
        bank1.loan__Bank_Account_Number__c = '11223344';
        bank1.loan__Bank_Name__c = 'ABC';
        bank1.loan__Account__c = acc.id;
        bank1.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank1.loan__Active__c = True;
        insert bank1;
        System.assertEquals(bank1.loan__Bank_Name__c,'ABC');
        
        loan__Bank_Account__c bank = new loan__Bank_Account__c();
        bank.loan__Bank_Account_Number__c = '11223344';
        bank.loan__Bank_Name__c = 'ABC';
        bank.loan__Account__c = acc1.id;
        bank.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank.loan__Active__c = True;
        insert bank;
        System.assertEquals(bank.loan__Bank_Name__c,'ABC');
        
        clcommon__Bank_Account__c mBank = ElixirTestHelper.returnmoneyAccount('Collections Trust Account');
        upsert mBank;
        System.assertEquals(mBank.clcommon__Account_Usage__c,'Collections Trust Account');
        
        clcommon__Bank_Account__c mBank2 = ElixirTestHelper.returnmoneyAccount('Investor Trust Account');
        upsert mBank2;
        System.assertEquals(mBank2.clcommon__Account_Usage__c,'Investor Trust Account');
        
        clcommon__Bank_Account__c mBank3 = ElixirTestHelper.returnmoneyAccount('Business Account');
        upsert mBank3;
        System.assertEquals(mBank3.clcommon__Account_Usage__c,'Business Account');
        
        clcommon__Bank_Account__c mBank4 = ElixirTestHelper.returnmoneyAccount('Advance Trust Account');
        upsert mBank4;
        System.assertEquals(mBank4.clcommon__Account_Usage__c,'Advance Trust Account');
        
        loan__Payment_Mode__c mode = new loan__Payment_Mode__c();
        mode.Name = 'ACH';
        insert mode;
        System.assertEquals(mode.Name,'ACH');
        
        loan__Investor_Fund_Transaction__c ift1 = new loan__Investor_Fund_Transaction__c();
        ift1.loan__Account__c = acc1.id;
        ift1.loan__Transaction_Date__c = Date.today();
        ift1.loan__Payment_Mode__c = mode.id;
        ift1.loan__Transaction_Amount__c = 40000;
        insert ift1;
        ift1.loan__Cleared__c = True;
        update ift1;
        System.assertEquals(ift1.loan__Transaction_Amount__c,40000);
        
        loan__Investor_Fund_Transaction__c ift = new loan__Investor_Fund_Transaction__c();
        ift.loan__Account__c = acc1.id;
        ift.loan__Transaction_Date__c = Date.today();
        ift.loan__Payment_Mode__c = mode.id;
        ift.loan__Transaction_Amount__c = -10;
        insert ift;
        ift.loan__Cleared__c = True;
        update ift;
        System.assertEquals(ift.loan__Transaction_Amount__c,-10);
        
        Contact con = new Contact();
        con.lastName = 'Testing';
        con.accountid = acc.id;
        insert con;
        System.assertEquals(con.lastName,'Testing');
        
        genesis__Applications__c app = new genesis__Applications__c();
        app.genesis__Account__c = acc.id;
        app.genesis__Contact__c = con.id;
        app.genesis__Status__c = 'Approved';
        
        insert app;
        System.assertEquals(app.genesis__Status__c,'Approved');
        
        loan__Loan_Account__c loanC = ElixirTestHelper.returnLoanAccount();
        loanC.loan__Account__c = acc.Id;
        loanC.loan__Frequency_of_Loan_Payment__c = ConstantValues.MONTHLY;
        loanC.Loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING;
        loanC.Application__c = app.id;
        upsert loanC;
        System.assertEquals(loanC.Loan__Loan_Status__c,loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING);
        
        peer__Loan_Application__c mloan = ElixirTestHelper.createLoanApplication(acc);
        mloan.peer__Loan__c = loanC.id;
        upsert mloan;
        
        app.Loan_Application__c = mloan.id;
        update app;
        
        peer__Booking_Order__c testbookor = new peer__Booking_Order__c(peer__Investor__c = acc1.id);
        insert testbookor;
         
        peer__Investment_Booking__c testinvstbook = new peer__Investment_Booking__c(peer__Booking_Order__c=testbookor.id,peer__Loan_Application__c = mloan.id,peer__Investment_Amount__c =1,peer__Certificate_Rate__c = 10,peer__Service_Rate__c = 10,peer__Stage__c = System.label.InFunding,Invest__c = True);
        //testinvstbook.peer__Credit_Band_Allocation__c=[select id from peer__Credit_Band_Allocation__c where peer__Credit_Band__c='A'].ID;
        insert testinvstbook;
        
        loan__Loan_Payment_Transaction__c lpt = ElixirTestHelper.returnLoanPayment(loanC);
        lpt.loan__Paid_to_Investor__c = True;
        lpt.loan__Payment_Mode__c = mode.id;
        upsert lpt;
        
        loan__Investor_Loan__c io = ElixirTestHelper.returninvLoan(acc1,loanC,10);
        upsert io;
        
        loan__Investor_Loan_Account_Txns__c iltid = ElixirTestHelper.returnilTid(io, 10, 10, 10);
        iltid.loan__Loan_Payment_Transaction__c = lpt.id;
        iltid.loan__Txn_Code__c = 'PAYMENT APPROVAL';
        iltid.loan__Txn_Amount__c = 100;
        iltid.loan__Total_Service_Charge__c = 10;
        upsert iltid;
        
        test.startTest();
            Invest.makeAllInvestment(mloan.id);
        test.stopTest();     
        
        
    }
    global static testmethod void test2(){
        
        Account acc1 = new Account();
        acc1.Name = 'Testing';
        acc1.loan__Undeployed_Funds__c = 40000;
        acc1.peer__Auto_Invest__c = True;
        acc1.loan__Investor__c = True;
        insert acc1;
        System.assertEquals(acc1.Name,'Testing'); 
        
        Account acc = new Account();
        acc.Name = 'Testing';
        acc.loan__Undeployed_Funds__c = 1000;
        acc.peer__Auto_Invest__c = True;
        insert acc;
        System.assertEquals(acc.Name,'Testing');
        
        loan__Bank_Account__c bank1 = new loan__Bank_Account__c();
        bank1.loan__Bank_Account_Number__c = '11223344';
        bank1.loan__Bank_Name__c = 'ABC';
        bank1.loan__Account__c = acc.id;
        bank1.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank1.loan__Active__c = True;
        insert bank1;
        System.assertEquals(bank1.loan__Bank_Name__c,'ABC');
        
        loan__Bank_Account__c bank = new loan__Bank_Account__c();
        bank.loan__Bank_Account_Number__c = '11223344';
        bank.loan__Bank_Name__c = 'ABC';
        bank.loan__Account__c = acc1.id;
        bank.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank.loan__Active__c = True;
        insert bank;
        System.assertEquals(bank.loan__Bank_Name__c,'ABC');
        
        clcommon__Bank_Account__c mBank = ElixirTestHelper.returnmoneyAccount('Collections Trust Account');
        upsert mBank;
        System.assertEquals(mBank.clcommon__Account_Usage__c,'Collections Trust Account');
        
        clcommon__Bank_Account__c mBank2 = ElixirTestHelper.returnmoneyAccount('Investor Trust Account');
        upsert mBank2;
        System.assertEquals(mBank2.clcommon__Account_Usage__c,'Investor Trust Account');
        
        clcommon__Bank_Account__c mBank3 = ElixirTestHelper.returnmoneyAccount('Business Account');
        upsert mBank3;
        System.assertEquals(mBank3.clcommon__Account_Usage__c,'Business Account');
        
        clcommon__Bank_Account__c mBank4 = ElixirTestHelper.returnmoneyAccount('Advance Trust Account');
        upsert mBank4;
        System.assertEquals(mBank4.clcommon__Account_Usage__c,'Advance Trust Account');
        
        loan__Payment_Mode__c mode = new loan__Payment_Mode__c();
        mode.Name = 'ACH';
        insert mode;
        System.assertEquals(mode.Name,'ACH');
        
        loan__Investor_Fund_Transaction__c ift1 = new loan__Investor_Fund_Transaction__c();
        ift1.loan__Account__c = acc1.id;
        ift1.loan__Transaction_Date__c = Date.today();
        ift1.loan__Payment_Mode__c = mode.id;
        ift1.loan__Transaction_Amount__c = 40000;
        insert ift1;
        ift1.loan__Cleared__c = True;
        update ift1;
        System.assertEquals(ift1.loan__Transaction_Amount__c,40000);
        
        loan__Investor_Fund_Transaction__c ift = new loan__Investor_Fund_Transaction__c();
        ift.loan__Account__c = acc1.id;
        ift.loan__Transaction_Date__c = Date.today();
        ift.loan__Payment_Mode__c = mode.id;
        ift.loan__Transaction_Amount__c = -10;
        insert ift;
        ift.loan__Cleared__c = True;
        update ift;
        System.assertEquals(ift.loan__Transaction_Amount__c,-10);
        
        Contact con = new Contact();
        con.lastName = 'Testing';
        con.accountid = acc.id;
        insert con;
        System.assertEquals(con.lastName,'Testing');
        
        genesis__Applications__c app = new genesis__Applications__c();
        app.genesis__Account__c = acc.id;
        app.genesis__Contact__c = con.id;
        app.genesis__Status__c = 'Approved';
        
        insert app;
        System.assertEquals(app.genesis__Status__c,'Approved');
        
        loan__Loan_Account__c loanC = ElixirTestHelper.returnLoanAccount();
        loanC.loan__Account__c = acc.Id;
        loanC.loan__Frequency_of_Loan_Payment__c = ConstantValues.MONTHLY;
        loanC.Loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING;
        loanC.Application__c = app.id;
        upsert loanC;
        System.assertEquals(loanC.Loan__Loan_Status__c,loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING);
        
        peer__Loan_Application__c mloan = ElixirTestHelper.createLoanApplication(acc);
        mloan.peer__Loan__c = loanC.id;
        upsert mloan;
        
        app.Loan_Application__c = mloan.id;
        update app;
        
        peer__Booking_Order__c testbookor = new peer__Booking_Order__c(peer__Investor__c = acc1.id);
        insert testbookor;
         
        peer__Investment_Booking__c testinvstbook = new peer__Investment_Booking__c(peer__Booking_Order__c=testbookor.id,peer__Loan_Application__c = mloan.id,peer__Investment_Amount__c =1,peer__Certificate_Rate__c = 10,peer__Service_Rate__c = 10,peer__Stage__c = System.label.InFunding,Invest__c = True);
        //testinvstbook.peer__Credit_Band_Allocation__c=[select id from peer__Credit_Band_Allocation__c where peer__Credit_Band__c='A'].ID;
        insert testinvstbook;
        
        loan__Loan_Payment_Transaction__c lpt = ElixirTestHelper.returnLoanPayment(loanC);
        lpt.loan__Paid_to_Investor__c = True;
        lpt.loan__Payment_Mode__c = mode.id;
        upsert lpt;
        
        loan__Investor_Loan__c io = ElixirTestHelper.returninvLoan(acc1,loanC,10);
        upsert io;
        
        loan__Investor_Loan_Account_Txns__c iltid = ElixirTestHelper.returnilTid(io, 10, 10, 10);
        iltid.loan__Loan_Payment_Transaction__c = lpt.id;
        iltid.loan__Txn_Code__c = 'PAYMENT APPROVAL';
        iltid.loan__Txn_Amount__c = 100;
        iltid.loan__Total_Service_Charge__c = 10;
        upsert iltid;
        
        test.startTest();
            Invest.makeAllInvestment(mloan.id);
        test.stopTest();     
        
        
    }
    global static testmethod void test3(){
        
        Elixir_Before_Or_On_Settlement_Fees__c fee = new Elixir_Before_Or_On_Settlement_Fees__c();
        fee.name = 'Application Fee';
        fee.Distribution_Type__c = 'Pre-Paid Fee';
        fee.Fee_Field_API_Name__c = 'Application_Fee__c';
        insert fee;
        System.assertEquals(fee.name,'Application Fee');
        
        Account acc1 = new Account();
        acc1.Name = 'Testing';
        acc1.loan__Undeployed_Funds__c = 40000;
        acc1.peer__Auto_Invest__c = True;
        acc1.loan__Investor__c = True;
        insert acc1;
        System.assertEquals(acc1.Name,'Testing'); 
        
        Account acc = new Account();
        acc.Name = 'Testing';
        acc.loan__Undeployed_Funds__c = 1000;
        acc.peer__Auto_Invest__c = True;
        insert acc;
        System.assertEquals(acc.Name,'Testing');
        
        loan__Bank_Account__c bank1 = new loan__Bank_Account__c();
        bank1.loan__Bank_Account_Number__c = '11223344';
        bank1.loan__Bank_Name__c = 'ABC';
        bank1.loan__Account__c = acc.id;
        bank1.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank1.loan__Active__c = True;
        insert bank1;
        System.assertEquals(bank1.loan__Bank_Name__c,'ABC');
        
        loan__Bank_Account__c bank = new loan__Bank_Account__c();
        bank.loan__Bank_Account_Number__c = '11223344';
        bank.loan__Bank_Name__c = 'ABC';
        bank.loan__Account__c = acc1.id;
        bank.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank.loan__Active__c = True;
        insert bank;
        System.assertEquals(bank.loan__Bank_Name__c,'ABC');
        
        clcommon__Bank_Account__c mBank = ElixirTestHelper.returnmoneyAccount('Collections Trust Account');
        upsert mBank;
        System.assertEquals(mBank.clcommon__Account_Usage__c,'Collections Trust Account');
        
        clcommon__Bank_Account__c mBank2 = ElixirTestHelper.returnmoneyAccount('Investor Trust Account');
        upsert mBank2;
        System.assertEquals(mBank2.clcommon__Account_Usage__c,'Investor Trust Account');
        
        clcommon__Bank_Account__c mBank3 = ElixirTestHelper.returnmoneyAccount('Business Account');
        upsert mBank3;
        System.assertEquals(mBank3.clcommon__Account_Usage__c,'Business Account');
        
        clcommon__Bank_Account__c mBank4 = ElixirTestHelper.returnmoneyAccount('Advance Trust Account');
        upsert mBank4;
        System.assertEquals(mBank4.clcommon__Account_Usage__c,'Advance Trust Account');
        
        loan__Payment_Mode__c mode = new loan__Payment_Mode__c();
        mode.Name = 'ACH';
        insert mode;
        System.assertEquals(mode.Name,'ACH');
        
        loan__Investor_Fund_Transaction__c ift1 = new loan__Investor_Fund_Transaction__c();
        ift1.loan__Account__c = acc1.id;
        ift1.loan__Transaction_Date__c = Date.today();
        ift1.loan__Payment_Mode__c = mode.id;
        ift1.loan__Transaction_Amount__c = 40000;
        insert ift1;
        ift1.loan__Cleared__c = True;
        update ift1;
        System.assertEquals(ift1.loan__Transaction_Amount__c,40000);
        
        loan__Investor_Fund_Transaction__c ift = new loan__Investor_Fund_Transaction__c();
        ift.loan__Account__c = acc1.id;
        ift.loan__Transaction_Date__c = Date.today();
        ift.loan__Payment_Mode__c = mode.id;
        ift.loan__Transaction_Amount__c = -10;
        insert ift;
        ift.loan__Cleared__c = True;
        update ift;
        System.assertEquals(ift.loan__Transaction_Amount__c,-10);
        
        Contact con = new Contact();
        con.lastName = 'Testing';
        con.accountid = acc.id;
        insert con;
        System.assertEquals(con.lastName,'Testing');
        
        genesis__Applications__c app = new genesis__Applications__c();
        app.genesis__Account__c = acc.id;
        app.genesis__Contact__c = con.id;
        app.genesis__Status__c = 'Approved';
        
        insert app;
        System.assertEquals(app.genesis__Status__c,'Approved');
        
        loan__Loan_Account__c loanC = ElixirTestHelper.returnLoanAccount();
        loanC.loan__Account__c = acc.Id;
        loanC.loan__Frequency_of_Loan_Payment__c = ConstantValues.WEEKLY;
        loanC.Loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING;
        loanC.Application__c = app.id;
        upsert loanC;
        System.assertEquals(loanC.Loan__Loan_Status__c,loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING);
        
        peer__Loan_Application__c mloan = ElixirTestHelper.createLoanApplication(acc);
        mloan.peer__Loan__c = loanC.id;
        upsert mloan;
        
        app.Loan_Application__c = mloan.id;
        update app;
        
        peer__Booking_Order__c testbookor = new peer__Booking_Order__c(peer__Investor__c = acc1.id);
        insert testbookor;
         
        peer__Investment_Booking__c testinvstbook = new peer__Investment_Booking__c(peer__Booking_Order__c=testbookor.id,peer__Loan_Application__c = mloan.id,peer__Investment_Amount__c =1,peer__Certificate_Rate__c = 10,peer__Service_Rate__c = 10,peer__Stage__c = System.label.InFunding,Invest__c = True);
        //testinvstbook.peer__Credit_Band_Allocation__c=[select id from peer__Credit_Band_Allocation__c where peer__Credit_Band__c='A'].ID;
        insert testinvstbook;
        
        loan__Loan_Payment_Transaction__c lpt = ElixirTestHelper.returnLoanPayment(loanC);
        lpt.loan__Paid_to_Investor__c = True;
        lpt.loan__Payment_Mode__c = mode.id;
        upsert lpt;
        
        loan__Investor_Loan__c io = ElixirTestHelper.returninvLoan(acc1,loanC,10);
        upsert io;
        
        loan__Investor_Loan_Account_Txns__c iltid = ElixirTestHelper.returnilTid(io, 10, 10, 10);
        iltid.loan__Loan_Payment_Transaction__c = lpt.id;
        iltid.loan__Txn_Code__c = 'PAYMENT APPROVAL';
        iltid.loan__Txn_Amount__c = 100;
        iltid.loan__Total_Service_Charge__c = 10;
        upsert iltid;
        
        test.startTest();
            Invest.makeAllInvestment(mloan.id);
        test.stopTest();     
        
        
    }
    
    global static testmethod void test5(){
        
        Elixir_Before_Or_On_Settlement_Fees__c fee = new Elixir_Before_Or_On_Settlement_Fees__c();
        fee.name = 'Application Fee';
        fee.Distribution_Type__c = 'Pre-Paid Fee';
        fee.Fee_Field_API_Name__c = 'Application_Fee__c';
        insert fee;
        System.assertEquals(fee.name,'Application Fee');
        
        Account acc1 = new Account();
        acc1.Name = 'Testing';
        acc1.loan__Undeployed_Funds__c = 40000;
        acc1.peer__Auto_Invest__c = True;
        acc1.loan__Investor__c = True;
        insert acc1;
        System.assertEquals(acc1.Name,'Testing'); 
        
        Account acc = new Account();
        acc.Name = 'Testing';
        acc.loan__Undeployed_Funds__c = 1000;
        acc.peer__Auto_Invest__c = True;
        insert acc;
        System.assertEquals(acc.Name,'Testing');
        
        loan__Bank_Account__c bank1 = new loan__Bank_Account__c();
        bank1.loan__Bank_Account_Number__c = '11223344';
        bank1.loan__Bank_Name__c = 'ABC';
        bank1.loan__Account__c = acc.id;
        bank1.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank1.loan__Active__c = True;
        insert bank1;
        System.assertEquals(bank1.loan__Bank_Name__c,'ABC');
        
        loan__Bank_Account__c bank = new loan__Bank_Account__c();
        bank.loan__Bank_Account_Number__c = '11223344';
        bank.loan__Bank_Name__c = 'ABC';
        bank.loan__Account__c = acc1.id;
        bank.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank.loan__Active__c = True;
        insert bank;
        System.assertEquals(bank.loan__Bank_Name__c,'ABC');
        
        clcommon__Bank_Account__c mBank = ElixirTestHelper.returnmoneyAccount('Collections Trust Account');
        upsert mBank;
        System.assertEquals(mBank.clcommon__Account_Usage__c,'Collections Trust Account');
        
        clcommon__Bank_Account__c mBank2 = ElixirTestHelper.returnmoneyAccount('Investor Trust Account');
        upsert mBank2;
        System.assertEquals(mBank2.clcommon__Account_Usage__c,'Investor Trust Account');
        
        clcommon__Bank_Account__c mBank3 = ElixirTestHelper.returnmoneyAccount('Business Account');
        upsert mBank3;
        System.assertEquals(mBank3.clcommon__Account_Usage__c,'Business Account');
        
        clcommon__Bank_Account__c mBank4 = ElixirTestHelper.returnmoneyAccount('Advance Trust Account');
        upsert mBank4;
        System.assertEquals(mBank4.clcommon__Account_Usage__c,'Advance Trust Account');
        
        loan__Payment_Mode__c mode = new loan__Payment_Mode__c();
        mode.Name = 'ACH';
        insert mode;
        System.assertEquals(mode.Name,'ACH');
        
        loan__Investor_Fund_Transaction__c ift1 = new loan__Investor_Fund_Transaction__c();
        ift1.loan__Account__c = acc1.id;
        ift1.loan__Transaction_Date__c = Date.today();
        ift1.loan__Payment_Mode__c = mode.id;
        ift1.loan__Transaction_Amount__c = 40000;
        insert ift1;
        ift1.loan__Cleared__c = True;
        update ift1;
        System.assertEquals(ift1.loan__Transaction_Amount__c,40000);
        
        loan__Investor_Fund_Transaction__c ift = new loan__Investor_Fund_Transaction__c();
        ift.loan__Account__c = acc1.id;
        ift.loan__Transaction_Date__c = Date.today();
        ift.loan__Payment_Mode__c = mode.id;
        ift.loan__Transaction_Amount__c = -10;
        insert ift;
        ift.loan__Cleared__c = True;
        update ift;
        System.assertEquals(ift.loan__Transaction_Amount__c,-10);
        
        Contact con = new Contact();
        con.lastName = 'Testing';
        con.accountid = acc.id;
        insert con;
        System.assertEquals(con.lastName,'Testing');
        
        genesis__Applications__c app = new genesis__Applications__c();
        app.genesis__Account__c = acc.id;
        app.genesis__Contact__c = con.id;
        app.genesis__Status__c = 'Approved';
        
        insert app;
        System.assertEquals(app.genesis__Status__c,'Approved');
        
        loan__Loan_Account__c loanC = ElixirTestHelper.returnLoanAccount();
        loanC.loan__Account__c = acc.Id;
        loanC.loan__Frequency_of_Loan_Payment__c = ConstantValues.WEEKLY;
        loanC.Loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING;
        loanC.Application__c = app.id;
        upsert loanC;
        System.assertEquals(loanC.Loan__Loan_Status__c,loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING);
        
        peer__Loan_Application__c mloan = ElixirTestHelper.createLoanApplication(acc);
        mloan.peer__Loan__c = loanC.id;
        upsert mloan;
        
        app.Loan_Application__c = mloan.id;
        update app;
        
        peer__Booking_Order__c testbookor = new peer__Booking_Order__c(peer__Investor__c = acc1.id);
        insert testbookor;
         
        peer__Credit_Band_Allocation__c cba = new peer__Credit_Band_Allocation__c(peer__Account__c = acc1.Id, peer__Credit_Band__c = 'A',peer__Total_Investment_Booking_Amount__c = 1000);
        insert cba;
        
        peer__Investment_Booking__c testinvstbook = new peer__Investment_Booking__c(peer__Booking_Order__c=testbookor.id,peer__Loan_Application__c = mloan.id,peer__Investment_Amount__c =1,peer__Certificate_Rate__c = 10,peer__Service_Rate__c = 10,peer__Stage__c = System.label.InFunding,Invest__c = True);
        testinvstbook.peer__Credit_Band_Allocation__c=[select id from peer__Credit_Band_Allocation__c where peer__Credit_Band__c='A'].ID;
        insert testinvstbook;
        
        loan__Loan_Payment_Transaction__c lpt = ElixirTestHelper.returnLoanPayment(loanC);
        lpt.loan__Paid_to_Investor__c = True;
        lpt.loan__Payment_Mode__c = mode.id;
        upsert lpt;
        
        loan__Investor_Loan__c io = ElixirTestHelper.returninvLoan(acc1,loanC,10);
        upsert io;
        
        loan__Investor_Loan_Account_Txns__c iltid = ElixirTestHelper.returnilTid(io, 10, 10, 10);
        iltid.loan__Loan_Payment_Transaction__c = lpt.id;
        iltid.loan__Txn_Code__c = 'PAYMENT APPROVAL';
        iltid.loan__Txn_Amount__c = 100;
        iltid.loan__Total_Service_Charge__c = 10;
        upsert iltid;
        
        test.startTest();
            Invest.makeAllInvestment(mloan.id);
        test.stopTest();     
        
        
    }
    global static testmethod void test6(){
        
        Elixir_Before_Or_On_Settlement_Fees__c fee = new Elixir_Before_Or_On_Settlement_Fees__c();
        fee.name = 'Application Fee';
        fee.Distribution_Type__c = 'Pre-Paid Fee';
        fee.Fee_Field_API_Name__c = 'Application_Fee__c';
        insert fee;
        System.assertEquals(fee.name,'Application Fee');
        
        Account acc1 = new Account();
        acc1.Name = 'Testing';
        acc1.loan__Undeployed_Funds__c = 40000;
        acc1.peer__Auto_Invest__c = True;
        acc1.loan__Investor__c = True;
        insert acc1;
        System.assertEquals(acc1.Name,'Testing'); 
        
        Account acc = new Account();
        acc.Name = 'Testing';
        acc.loan__Undeployed_Funds__c = 1000;
        acc.peer__Auto_Invest__c = True;
        insert acc;
        System.assertEquals(acc.Name,'Testing');
        
        loan__Bank_Account__c bank1 = new loan__Bank_Account__c();
        bank1.loan__Bank_Account_Number__c = '11223344';
        bank1.loan__Bank_Name__c = 'ABC';
        bank1.loan__Account__c = acc.id;
        bank1.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank1.loan__Active__c = True;
        insert bank1;
        System.assertEquals(bank1.loan__Bank_Name__c,'ABC');
        
        loan__Bank_Account__c bank = new loan__Bank_Account__c();
        bank.loan__Bank_Account_Number__c = '11223344';
        bank.loan__Bank_Name__c = 'ABC';
        bank.loan__Account__c = acc1.id;
        bank.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank.loan__Active__c = True;
        insert bank;
        System.assertEquals(bank.loan__Bank_Name__c,'ABC');
        
        clcommon__Bank_Account__c mBank = ElixirTestHelper.returnmoneyAccount('Collections Trust Account');
        upsert mBank;
        System.assertEquals(mBank.clcommon__Account_Usage__c,'Collections Trust Account');
        
        clcommon__Bank_Account__c mBank2 = ElixirTestHelper.returnmoneyAccount('Investor Trust Account');
        upsert mBank2;
        System.assertEquals(mBank2.clcommon__Account_Usage__c,'Investor Trust Account');
        
        clcommon__Bank_Account__c mBank3 = ElixirTestHelper.returnmoneyAccount('Business Account');
        upsert mBank3;
        System.assertEquals(mBank3.clcommon__Account_Usage__c,'Business Account');
        
        clcommon__Bank_Account__c mBank4 = ElixirTestHelper.returnmoneyAccount('Advance Trust Account');
        upsert mBank4;
        System.assertEquals(mBank4.clcommon__Account_Usage__c,'Advance Trust Account');
        
        loan__Payment_Mode__c mode = new loan__Payment_Mode__c();
        mode.Name = 'ACH';
        insert mode;
        System.assertEquals(mode.Name,'ACH');
        
        loan__Investor_Fund_Transaction__c ift1 = new loan__Investor_Fund_Transaction__c();
        ift1.loan__Account__c = acc1.id;
        ift1.loan__Transaction_Date__c = Date.today();
        ift1.loan__Payment_Mode__c = mode.id;
        ift1.loan__Transaction_Amount__c = 40000;
        insert ift1;
        ift1.loan__Cleared__c = True;
        update ift1;
        System.assertEquals(ift1.loan__Transaction_Amount__c,40000);
        
        loan__Investor_Fund_Transaction__c ift = new loan__Investor_Fund_Transaction__c();
        ift.loan__Account__c = acc1.id;
        ift.loan__Transaction_Date__c = Date.today();
        ift.loan__Payment_Mode__c = mode.id;
        ift.loan__Transaction_Amount__c = -10;
        insert ift;
        ift.loan__Cleared__c = True;
        update ift;
        System.assertEquals(ift.loan__Transaction_Amount__c,-10);
        
        Contact con = new Contact();
        con.lastName = 'Testing';
        con.accountid = acc.id;
        insert con;
        System.assertEquals(con.lastName,'Testing');
        
        genesis__Applications__c app = new genesis__Applications__c();
        app.genesis__Account__c = acc.id;
        app.genesis__Contact__c = con.id;
        app.genesis__Status__c = 'Approved';
        
        insert app;
        System.assertEquals(app.genesis__Status__c,'Approved');
        
        loan__Loan_Account__c loanC = ElixirTestHelper.returnLoanAccount();
        loanC.loan__Account__c = acc.Id;
        loanC.loan__Frequency_of_Loan_Payment__c = ConstantValues.WEEKLY;
        loanC.Loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING;
        loanC.Application__c = app.id;
        upsert loanC;
        System.assertEquals(loanC.Loan__Loan_Status__c,loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING);
        
        peer__Loan_Application__c mloan = ElixirTestHelper.createLoanApplication(acc);
        mloan.peer__Loan__c = loanC.id;
        mloan.peer__Requested_Loan_Amount__c=400;
        upsert mloan;
        
        app.Loan_Application__c = mloan.id;
        update app;
        
        peer__Booking_Order__c testbookor = new peer__Booking_Order__c(peer__Investor__c = acc1.id);
        insert testbookor;
         
        peer__Credit_Band_Allocation__c cba = new peer__Credit_Band_Allocation__c(peer__Account__c = acc1.Id, peer__Credit_Band__c = 'A',peer__Total_Investment_Booking_Amount__c = 1000);
        insert cba;
        
        peer__Investment_Booking__c testinvstbook = new peer__Investment_Booking__c(peer__Booking_Order__c=testbookor.id,peer__Loan_Application__c = mloan.id,peer__Investment_Amount__c =100,peer__Certificate_Rate__c = 10,peer__Service_Rate__c = 10,peer__Stage__c =System.label.InFunding,Invest__c = True);
        testinvstbook.peer__Credit_Band_Allocation__c=[select id from peer__Credit_Band_Allocation__c where peer__Credit_Band__c='A'].ID;
        insert testinvstbook;
        
        loan__Loan_Payment_Transaction__c lpt = ElixirTestHelper.returnLoanPayment(loanC);
        lpt.loan__Paid_to_Investor__c = True;
        lpt.loan__Payment_Mode__c = mode.id;
        upsert lpt;
        
        loan__Investor_Loan__c io = ElixirTestHelper.returninvLoan(acc1,loanC,10);
        upsert io;
        
        loan__Investor_Loan_Account_Txns__c iltid = ElixirTestHelper.returnilTid(io, 10, 10, 10);
        iltid.loan__Loan_Payment_Transaction__c = lpt.id;
        iltid.loan__Txn_Code__c = 'PAYMENT APPROVAL';
        iltid.loan__Txn_Amount__c = 100;
        iltid.loan__Total_Service_Charge__c = 10;
        upsert iltid;
        
        test.startTest();
            Invest.makeAllInvestment(mloan.id);
        test.stopTest();     
        
        
    }
    global static testmethod void test7(){
        
        Elixir_Before_Or_On_Settlement_Fees__c fee = new Elixir_Before_Or_On_Settlement_Fees__c();
        fee.name = 'Application Fee';
        fee.Distribution_Type__c = 'Pre-Paid Fee';
        fee.Fee_Field_API_Name__c = 'Application_Fee__c';
        insert fee;
        System.assertEquals(fee.name,'Application Fee');
        
        Account acc1 = new Account();
        acc1.Name = 'Testing';
        acc1.loan__Undeployed_Funds__c = 40000;
        acc1.peer__Auto_Invest__c = True;
        acc1.loan__Investor__c = True;
        insert acc1;
        System.assertEquals(acc1.Name,'Testing'); 
        
        Account acc = new Account();
        acc.Name = 'Testing';
        acc.loan__Undeployed_Funds__c = 1000;
        acc.peer__Auto_Invest__c = True;
        insert acc;
        System.assertEquals(acc.Name,'Testing');
        
        loan__Bank_Account__c bank1 = new loan__Bank_Account__c();
        bank1.loan__Bank_Account_Number__c = '11223344';
        bank1.loan__Bank_Name__c = 'ABC';
        bank1.loan__Account__c = acc.id;
        bank1.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank1.loan__Active__c = True;
        insert bank1;
        System.assertEquals(bank1.loan__Bank_Name__c,'ABC');
        
        loan__Bank_Account__c bank = new loan__Bank_Account__c();
        bank.loan__Bank_Account_Number__c = '11223344';
        bank.loan__Bank_Name__c = 'ABC';
        bank.loan__Account__c = acc1.id;
        bank.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank.loan__Active__c = True;
        insert bank;
        System.assertEquals(bank.loan__Bank_Name__c,'ABC');
        
        clcommon__Bank_Account__c mBank = ElixirTestHelper.returnmoneyAccount('Collections Trust Account');
        upsert mBank;
        System.assertEquals(mBank.clcommon__Account_Usage__c,'Collections Trust Account');
        
        clcommon__Bank_Account__c mBank2 = ElixirTestHelper.returnmoneyAccount('Investor Trust Account');
        upsert mBank2;
        System.assertEquals(mBank2.clcommon__Account_Usage__c,'Investor Trust Account');
        
        clcommon__Bank_Account__c mBank3 = ElixirTestHelper.returnmoneyAccount('Business Account');
        upsert mBank3;
        System.assertEquals(mBank3.clcommon__Account_Usage__c,'Business Account');
        
        clcommon__Bank_Account__c mBank4 = ElixirTestHelper.returnmoneyAccount('Advance Trust Account');
        upsert mBank4;
        System.assertEquals(mBank4.clcommon__Account_Usage__c,'Advance Trust Account');
        
        loan__Payment_Mode__c mode = new loan__Payment_Mode__c();
        mode.Name = 'ACH';
        insert mode;
        System.assertEquals(mode.Name,'ACH');
        
        loan__Investor_Fund_Transaction__c ift1 = new loan__Investor_Fund_Transaction__c();
        ift1.loan__Account__c = acc1.id;
        ift1.loan__Transaction_Date__c = Date.today();
        ift1.loan__Payment_Mode__c = mode.id;
        ift1.loan__Transaction_Amount__c = 40000;
        insert ift1;
        ift1.loan__Cleared__c = True;
        update ift1;
        System.assertEquals(ift1.loan__Transaction_Amount__c,40000);
        
        loan__Investor_Fund_Transaction__c ift = new loan__Investor_Fund_Transaction__c();
        ift.loan__Account__c = acc1.id;
        ift.loan__Transaction_Date__c = Date.today();
        ift.loan__Payment_Mode__c = mode.id;
        ift.loan__Transaction_Amount__c = -10;
        insert ift;
        ift.loan__Cleared__c = True;
        update ift;
        System.assertEquals(ift.loan__Transaction_Amount__c,-10);
        
        Contact con = new Contact();
        con.lastName = 'Testing';
        con.accountid = acc.id;
        insert con;
        System.assertEquals(con.lastName,'Testing');
        
        genesis__Applications__c app = new genesis__Applications__c();
        app.genesis__Account__c = acc.id;
        app.genesis__Contact__c = con.id;
        app.genesis__Status__c = 'Approved';
        
        insert app;
        System.assertEquals(app.genesis__Status__c,'Approved');
        
        loan__Loan_Account__c loanC = ElixirTestHelper.returnLoanAccount();
        loanC.loan__Account__c = acc.Id;
        loanC.loan__Frequency_of_Loan_Payment__c = ConstantValues.WEEKLY;
        loanC.Loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING;
        loanC.Application__c = app.id;
        upsert loanC;
        System.assertEquals(loanC.Loan__Loan_Status__c,loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING);
        
        peer__Loan_Application__c mloan = ElixirTestHelper.createLoanApplication(acc);
        mloan.peer__Loan__c = loanC.id;
        mloan.peer__Requested_Loan_Amount__c=400;
        upsert mloan;
        
        app.Loan_Application__c = mloan.id;
        update app;
        
        peer__Booking_Order__c testbookor = new peer__Booking_Order__c(peer__Investor__c = acc1.id);
        insert testbookor;
         
        peer__Credit_Band_Allocation__c cba = new peer__Credit_Band_Allocation__c(peer__Account__c = acc1.Id, peer__Credit_Band__c = 'A',peer__Total_Investment_Booking_Amount__c = 1000);
        insert cba;
        
        peer__Investment_Booking__c testinvstbook = new peer__Investment_Booking__c(peer__Booking_Order__c=testbookor.id,peer__Loan_Application__c = mloan.Id,peer__Investment_Amount__c =400,peer__Certificate_Rate__c = 10,peer__Service_Rate__c = 10,peer__Stage__c = System.label.InFunding,Invest__c = True);
        testinvstbook.peer__Credit_Band_Allocation__c=[select id from peer__Credit_Band_Allocation__c where peer__Credit_Band__c='A'].ID;
        insert testinvstbook;
        
        loan__Loan_Payment_Transaction__c lpt = ElixirTestHelper.returnLoanPayment(loanC);
        lpt.loan__Paid_to_Investor__c = True;
        lpt.loan__Payment_Mode__c = mode.id;
        upsert lpt;
        
        loan__Investor_Loan__c io = ElixirTestHelper.returninvLoan(acc1,loanC,10);
        upsert io;
        
        loan__Investor_Loan_Account_Txns__c iltid = ElixirTestHelper.returnilTid(io, 10, 10, 10);
        iltid.loan__Loan_Payment_Transaction__c = lpt.id;
        iltid.loan__Txn_Code__c = 'PAYMENT APPROVAL';
        iltid.loan__Txn_Amount__c = 100;
        iltid.loan__Total_Service_Charge__c = 10;
        upsert iltid;
        
        test.startTest();
        Invest.makeAllInvestment(mloan.id);
        loanC.loan__Loan_Status__c ='Approved';
        update loanC;
       
        loan__Fee__c feeAmt = new loan__Fee__c(name = 'test', loan__Amount__c = 400,loan__Time_of_charge__c='Pre-Paid Fees');
        insert feeAmt;
        
        loan__Contract_Pre_Paid_Fee__c conFee = new loan__Contract_Pre_Paid_Fee__c(loan__Amount__c = 400,loan__Contract__c = loanC.Id,loan__Fee_Type__c = feeAmt.Id);
        insert conFee;
        
        Invest.createDisbursalwithDist(loanC.Id,400,mloan.peer__Loan__r.Name,app);
        test.stopTest();     
         
    }
    global static testmethod void test8(){
        
        Elixir_Before_Or_On_Settlement_Fees__c fee = new Elixir_Before_Or_On_Settlement_Fees__c();
        fee.name = 'Application Fee';
        fee.Distribution_Type__c = 'Pre-Paid Fee';
        fee.Fee_Field_API_Name__c = 'Application_Fee__c';
        insert fee;
        System.assertEquals(fee.name,'Application Fee');
        
        Account acc1 = new Account();
        acc1.Name = 'Testing';
        acc1.loan__Undeployed_Funds__c = 40000;
        acc1.peer__Auto_Invest__c = True;
        acc1.loan__Investor__c = True;
        insert acc1;
        System.assertEquals(acc1.Name,'Testing'); 
        
        Account acc = new Account();
        acc.Name = 'Testing';
        acc.loan__Undeployed_Funds__c = 1000;
        acc.peer__Auto_Invest__c = True;
        insert acc;
        System.assertEquals(acc.Name,'Testing');
        
        loan__Bank_Account__c bank1 = new loan__Bank_Account__c();
        bank1.loan__Bank_Account_Number__c = '11223344';
        bank1.loan__Bank_Name__c = 'ABC';
        bank1.loan__Account__c = acc.id;
        bank1.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank1.loan__Active__c = True;
        insert bank1;
        System.assertEquals(bank1.loan__Bank_Name__c,'ABC');
        
        loan__Bank_Account__c bank = new loan__Bank_Account__c();
        bank.loan__Bank_Account_Number__c = '11223344';
        bank.loan__Bank_Name__c = 'ABC';
        bank.loan__Account__c = acc1.id;
        bank.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank.loan__Active__c = True;
        insert bank;
        System.assertEquals(bank.loan__Bank_Name__c,'ABC');
        
        clcommon__Bank_Account__c mBank = ElixirTestHelper.returnmoneyAccount('Collections Trust Account');
        upsert mBank;
        System.assertEquals(mBank.clcommon__Account_Usage__c,'Collections Trust Account');
        
        clcommon__Bank_Account__c mBank2 = ElixirTestHelper.returnmoneyAccount('Investor Trust Account');
        upsert mBank2;
        System.assertEquals(mBank2.clcommon__Account_Usage__c,'Investor Trust Account');
        
        clcommon__Bank_Account__c mBank3 = ElixirTestHelper.returnmoneyAccount('Business Account');
        upsert mBank3;
        System.assertEquals(mBank3.clcommon__Account_Usage__c,'Business Account');
        
        clcommon__Bank_Account__c mBank4 = ElixirTestHelper.returnmoneyAccount('Advance Trust Account');
        upsert mBank4;
        System.assertEquals(mBank4.clcommon__Account_Usage__c,'Advance Trust Account');
        
        loan__Payment_Mode__c mode = new loan__Payment_Mode__c();
        mode.Name = 'ACH';
        insert mode;
        System.assertEquals(mode.Name,'ACH');
        
        loan__Investor_Fund_Transaction__c ift1 = new loan__Investor_Fund_Transaction__c();
        ift1.loan__Account__c = acc1.id;
        ift1.loan__Transaction_Date__c = Date.today();
        ift1.loan__Payment_Mode__c = mode.id;
        ift1.loan__Transaction_Amount__c = 40000;
        insert ift1;
        ift1.loan__Cleared__c = True;
        update ift1;
        System.assertEquals(ift1.loan__Transaction_Amount__c,40000);
        
        loan__Investor_Fund_Transaction__c ift = new loan__Investor_Fund_Transaction__c();
        ift.loan__Account__c = acc1.id;
        ift.loan__Transaction_Date__c = Date.today();
        ift.loan__Payment_Mode__c = mode.id;
        ift.loan__Transaction_Amount__c = -10;
        insert ift;
        ift.loan__Cleared__c = True;
        update ift;
        System.assertEquals(ift.loan__Transaction_Amount__c,-10);
        
        Contact con = new Contact();
        con.lastName = 'Testing';
        con.accountid = acc.id;
        insert con;
        System.assertEquals(con.lastName,'Testing');
        
        genesis__Applications__c app = new genesis__Applications__c();
        app.genesis__Account__c = acc.id;
        app.genesis__Contact__c = con.id;
        app.genesis__Status__c = 'Approved';
        
        insert app;
        System.assertEquals(app.genesis__Status__c,'Approved');
        
        loan__Loan_Account__c loanC = ElixirTestHelper.returnLoanAccount();
        loanC.loan__Account__c = acc.Id;
        loanC.loan__Frequency_of_Loan_Payment__c = ConstantValues.WEEKLY;
        loanC.Loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING;
        loanC.Application__c = app.id;
        upsert loanC;
        System.assertEquals(loanC.Loan__Loan_Status__c,loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING);
        
        peer__Loan_Application__c mloan = ElixirTestHelper.createLoanApplication(acc);
        mloan.peer__Loan__c = loanC.id;
        mloan.peer__Requested_Loan_Amount__c=400;
        upsert mloan;
        
        app.Loan_Application__c = mloan.id;
        update app;
        
        peer__Booking_Order__c testbookor = new peer__Booking_Order__c(peer__Investor__c = acc1.id);
        insert testbookor;
         
        peer__Credit_Band_Allocation__c cba = new peer__Credit_Band_Allocation__c(peer__Account__c = acc1.Id, peer__Credit_Band__c = 'A',peer__Total_Investment_Booking_Amount__c = 1000);
        insert cba;
        
        peer__Investment_Booking__c testinvstbook = new peer__Investment_Booking__c(peer__Booking_Order__c=testbookor.id,peer__Loan_Application__c = mloan.Id,peer__Investment_Amount__c =400,peer__Certificate_Rate__c = 10,peer__Service_Rate__c = 10,peer__Stage__c = System.label.InFunding,Invest__c = True);
        testinvstbook.peer__Credit_Band_Allocation__c=[select id from peer__Credit_Band_Allocation__c where peer__Credit_Band__c='A'].ID;
        insert testinvstbook;
        
        loan__Loan_Payment_Transaction__c lpt = ElixirTestHelper.returnLoanPayment(loanC);
        lpt.loan__Paid_to_Investor__c = True;
        lpt.loan__Payment_Mode__c = mode.id;
        upsert lpt;
        
        loan__Investor_Loan__c io = ElixirTestHelper.returninvLoan(acc1,loanC,10);
        upsert io;
        
        loan__Investor_Loan_Account_Txns__c iltid = ElixirTestHelper.returnilTid(io, 10, 10, 10);
        iltid.loan__Loan_Payment_Transaction__c = lpt.id;
        iltid.loan__Txn_Code__c = 'PAYMENT APPROVAL';
        iltid.loan__Txn_Amount__c = 100;
        iltid.loan__Total_Service_Charge__c = 10;
        upsert iltid;
        
        test.startTest();
        //Invest.makeAllInvestment(mloan.id);
        loanC.loan__Loan_Status__c ='Approved';
        loanC.loan__Frequency_of_Loan_Payment__c = ConstantValues.MONTHLY;
        update loanC;
       
        loan__Fee__c feeAmt = new loan__Fee__c(name = 'test', loan__Amount__c = 400,loan__Time_of_charge__c='Pre-Paid Fees');
        insert feeAmt;
        
        loan__Contract_Pre_Paid_Fee__c conFee = new loan__Contract_Pre_Paid_Fee__c(loan__Amount__c = 400,loan__Contract__c = loanC.Id,loan__Fee_Type__c = feeAmt.Id);
        insert conFee;
        
        Invest.createDisbursalwithDist(loanC.Id,400,mloan.peer__Loan__r.Name,app);
        io.loan__Status__c = System.label.Active;
        update io;
        Invest.makeAllInvestment(mloan.id);
        
        test.stopTest();     
         
    }
    global static testmethod void test9(){
        
        Elixir_Before_Or_On_Settlement_Fees__c fee = new Elixir_Before_Or_On_Settlement_Fees__c();
        fee.name = 'Application Fee';
        fee.Distribution_Type__c = 'Pre-Paid Fee';
        fee.Fee_Field_API_Name__c = 'Application_Fee__c';
        insert fee;
        System.assertEquals(fee.name,'Application Fee');
        
        Account acc1 = new Account();
        acc1.Name = 'Testing';
        acc1.loan__Undeployed_Funds__c = 40000;
        acc1.peer__Auto_Invest__c = True;
        acc1.loan__Investor__c = True;
        insert acc1;
        System.assertEquals(acc1.Name,'Testing'); 
        
        Account acc = new Account();
        acc.Name = 'Testing';
        acc.loan__Undeployed_Funds__c = 1000;
        acc.peer__Auto_Invest__c = True;
        insert acc;
        System.assertEquals(acc.Name,'Testing');
        
        loan__Bank_Account__c bank1 = new loan__Bank_Account__c();
        bank1.loan__Bank_Account_Number__c = '11223344';
        bank1.loan__Bank_Name__c = 'ABC';
        bank1.loan__Account__c = acc.id;
        bank1.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank1.loan__Active__c = True;
        insert bank1;
        System.assertEquals(bank1.loan__Bank_Name__c,'ABC');
        
        loan__Bank_Account__c bank = new loan__Bank_Account__c();
        bank.loan__Bank_Account_Number__c = '11223344';
        bank.loan__Bank_Name__c = 'ABC';
        bank.loan__Account__c = acc1.id;
        bank.loan__Account_Usage__c = 'Borrower/Investor Account';
        bank.loan__Active__c = True;
        insert bank;
        System.assertEquals(bank.loan__Bank_Name__c,'ABC');
        
        clcommon__Bank_Account__c mBank = ElixirTestHelper.returnmoneyAccount('Collections Trust Account');
        upsert mBank;
        System.assertEquals(mBank.clcommon__Account_Usage__c,'Collections Trust Account');
        
        clcommon__Bank_Account__c mBank2 = ElixirTestHelper.returnmoneyAccount('Investor Trust Account');
        upsert mBank2;
        System.assertEquals(mBank2.clcommon__Account_Usage__c,'Investor Trust Account');
        
        clcommon__Bank_Account__c mBank3 = ElixirTestHelper.returnmoneyAccount('Business Account');
        upsert mBank3;
        System.assertEquals(mBank3.clcommon__Account_Usage__c,'Business Account');
        
        clcommon__Bank_Account__c mBank4 = ElixirTestHelper.returnmoneyAccount('Advance Trust Account');
        upsert mBank4;
        System.assertEquals(mBank4.clcommon__Account_Usage__c,'Advance Trust Account');
        
        loan__Payment_Mode__c mode = new loan__Payment_Mode__c();
        mode.Name = 'ACH';
        insert mode;
        System.assertEquals(mode.Name,'ACH');
        
        loan__Investor_Fund_Transaction__c ift1 = new loan__Investor_Fund_Transaction__c();
        ift1.loan__Account__c = acc1.id;
        ift1.loan__Transaction_Date__c = Date.today();
        ift1.loan__Payment_Mode__c = mode.id;
        ift1.loan__Transaction_Amount__c = 40000;
        insert ift1;
        ift1.loan__Cleared__c = True;
        update ift1;
        System.assertEquals(ift1.loan__Transaction_Amount__c,40000);
        
        loan__Investor_Fund_Transaction__c ift = new loan__Investor_Fund_Transaction__c();
        ift.loan__Account__c = acc1.id;
        ift.loan__Transaction_Date__c = Date.today();
        ift.loan__Payment_Mode__c = mode.id;
        ift.loan__Transaction_Amount__c = -10;
        insert ift;
        ift.loan__Cleared__c = True;
        update ift;
        System.assertEquals(ift.loan__Transaction_Amount__c,-10);
        
        Contact con = new Contact();
        con.lastName = 'Testing';
        con.accountid = acc.id;
        insert con;
        System.assertEquals(con.lastName,'Testing');
        
        genesis__Applications__c app = new genesis__Applications__c();
        app.genesis__Account__c = acc.id;
        app.genesis__Contact__c = con.id;
        app.genesis__Status__c = 'Approved';
        
        insert app;
        System.assertEquals(app.genesis__Status__c,'Approved');
        
        loan__Loan_Account__c loanC = ElixirTestHelper.returnLoanAccount();
        loanC.loan__Account__c = acc.Id;
        loanC.loan__Frequency_of_Loan_Payment__c = ConstantValues.WEEKLY;
        loanC.Loan__Loan_Status__c = loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING;
        loanC.Application__c = app.id;
        upsert loanC;
        System.assertEquals(loanC.Loan__Loan_Status__c,loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING);
        
        peer__Loan_Application__c mloan = ElixirTestHelper.createLoanApplication(acc);
        mloan.peer__Loan__c = loanC.id;
        mloan.peer__Requested_Loan_Amount__c=400;
        upsert mloan;
        
        app.Loan_Application__c = mloan.id;
        update app;
        
        peer__Booking_Order__c testbookor = new peer__Booking_Order__c(peer__Investor__c = acc1.id);
        insert testbookor;
         
        //peer__Credit_Band_Allocation__c cba = new peer__Credit_Band_Allocation__c(peer__Account__c = acc1.Id, peer__Credit_Band__c = 'A',peer__Total_Investment_Booking_Amount__c = 1000);
        //insert cba;
        
        peer__Investment_Booking__c testinvstbook = new peer__Investment_Booking__c(peer__Booking_Order__c=testbookor.id,peer__Loan_Application__c = mloan.Id,peer__Investment_Amount__c =400,peer__Certificate_Rate__c = 10,peer__Service_Rate__c = 10,peer__Stage__c = System.label.InFunding,Invest__c = True);
        //testinvstbook.peer__Credit_Band_Allocation__c=[select id from peer__Credit_Band_Allocation__c where peer__Credit_Band__c='A'].ID;
        insert testinvstbook;
        
        loan__Loan_Payment_Transaction__c lpt = ElixirTestHelper.returnLoanPayment(loanC);
        lpt.loan__Paid_to_Investor__c = True;
        lpt.loan__Payment_Mode__c = mode.id;
        upsert lpt;
        
        loan__Investor_Loan__c io = ElixirTestHelper.returninvLoan(acc1,loanC,10);
        upsert io;
        
        loan__Investor_Loan_Account_Txns__c iltid = ElixirTestHelper.returnilTid(io, 10, 10, 10);
        iltid.loan__Loan_Payment_Transaction__c = lpt.id;
        iltid.loan__Txn_Code__c = 'PAYMENT APPROVAL';
        iltid.loan__Txn_Amount__c = 100;
        iltid.loan__Total_Service_Charge__c = 10;
        upsert iltid;
        
        test.startTest();
        //Invest.makeAllInvestment(mloan.id);
        loanC.loan__Loan_Status__c ='Approved';
        loanC.loan__Frequency_of_Loan_Payment__c = ConstantValues.MONTHLY;
        update loanC;
       
        loan__Fee__c feeAmt = new loan__Fee__c(name = 'test', loan__Amount__c = 400,loan__Time_of_charge__c='Pre-Paid Fees');
        insert feeAmt;
        
        loan__Contract_Pre_Paid_Fee__c conFee = new loan__Contract_Pre_Paid_Fee__c(loan__Amount__c = 400,loan__Contract__c = loanC.Id,loan__Fee_Type__c = feeAmt.Id);
        insert conFee;
        
        Invest.createDisbursalwithDist(loanC.Id,400,mloan.peer__Loan__r.Name,app);
        io.loan__Status__c = System.label.Active;
        update io;
        Invest.makeAllInvestment(mloan.id);
        
        test.stopTest();     
         
    }
}