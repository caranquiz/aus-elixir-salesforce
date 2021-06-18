/******************************************************************
Description : This test class provides coverage to LTSMigrationJob and LTSMigrationHandlerJob
                that are  provided by CL to handle transactions present
                on Transaction Summary object and migrate to Loan Transaction Summary
******************************************************************/
@isTest(SeeAllData=false)
public with sharing class TestMigrationForLTS {
    
    @testSetup
    public static void createSeedData() {
        
        Test.startTest();
        loan.TestHelper.systemDate = Date.newInstance(2010, 04, 06);
        loan.TestHelper.createSeedDataForTesting();

        loan__Payment_Mode__c dummyPM = GenericUtilityTestHelper.getPaymentMode();
        dummyPM.name= 'WRITE OFF';
        update dummyPM;
        List<loan__Payment_Mode__c> paymentMode=[SELECT Id FROM loan__Payment_Mode__c WHERE Name='WRITE OFF'];
        System.AssertEquals(
            paymentMode.size(),
            1,
            ' Payment Mode inserted successfully.'
        );
        //Update Org Parameter to generate schedule
        loan__Org_Parameters__c orgParams = loan.CustomSettingsUtil.getOrgParameters();
        orgparams.loan__Draw_Amortization_Schedule__c = true;
        orgParams.loan__Zeroise_Provision_Amt_On_Good_Standing__c = true;
        Database.update(orgParams);
        System.AssertEquals(
            orgParams.loan__Draw_Amortization_Schedule__c,
            true
        );
        //Setup approval config
        loan.TestHelper.setupApprovalProcessForTxnFilegen();
        //Currency
        loan__Currency__c  curr = loan.TestHelper.createCurrency();
        //Create a dummy MF_Account
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest','10000 - ASSETS');
        loan__MF_Account__c dummyIncAccount = loan.TestHelper.createMFAccount('XXXIncAccountForTest','30000 - INCOME');
        //Create a Fee Set
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr,dummyIncAccount ,dummyAccount,'Dis Fee','Late Fees');
        Database.insert(dummyFee);
        
        loan__Fee__c lateFee =GenericUtilityTestHelper.returnLateFee(curr.Id); 
        system.assertNotEquals(
            lateFee.Id, 
            null, 
            'Late Fee Inserted'
        );

        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet();
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee,dummyFeeSet);

        loan__Office_Name__c dummyOffice = loan.TestHelper.createOffice();

        //Loan Product
        loan__Loan_Product__c lp= loan.TestHelper.createLoanProductwithProductType('Loan Product',
                                                               dummyOffice,
                                                               dummyAccount,
                                                               curr,
                                                               dummyFeeSet,
                                                               'Fixed',
                                                               12,
                                                               12.00,
                                                               'Same for all loans',
                                                               loan.LoanConstants.Loan);
        lp.loan__Create_Summaries__C = false;
        Database.update(lp);
        loan__Loan_Purpose__c dummyLoanPurpose = loan.TestHelper.createLoanPurpose();
        
        //Borrower Detail
        Contact borrower = GenericUtilityTestHelper.returnContactDetail();
        system.assertNotEquals(borrower.id, null);

        //Loan Account Detail
        loan__Loan_Account__c loanAcc = loan.TestHelper.createLoanAccountForContactObj(lp,
                                                                            borrower,
                                                                            dummyFeeSet,
                                                                            dummyLoanPurpose,
                                                                            dummyOffice);
        Database.update(loanAcc);
        loanAcc.loan__Interest_Rate__c = 5;
        loanAcc.loan__Number_of_Installments__c = 12;
        Database.update(loanAcc);
        List<loan__Loan_Account__c> loanAccountList=[SELECT id FROM loan__Loan_Account__c WHERE loan__Interest_Rate__c=5];
        system.assertEquals(
            loanAccountList.size(), 
            1,
            'Loan Account Inserted'
        );

        loan__Client__c dummyClient = loan.TestHelper.createClient(dummyOffice);

        //Contact Details
        Contact cont = GenericUtilityTestHelper.returnContactDetail();
        cont.FirstName='Dummy';
        Database.update(cont);
        List<Contact> contList = [SELECT Id FROM Contact where FirstName = 'Dummy'];
        System.assertEquals(contList.size(), 1);

        loan.BorrowerAPI1 bAPI = loan.APIFactory.getBorrowerAPI1();
        loan__Loan_Account__c newLoanAccount = bAPI.createContract(loanAcc, null, null);
        Test.stopTest();
        TestLoan.insertObjEventMapData();
        List<loan__Object_Event_Mapping__c> objList = [SELECT Id,loan__Enable_Tracking__C FROM loan__Object_Event_Mapping__C];
        for(loan__Object_Event_Mapping__C obj:objList){
            obj.loan__Enable_Tracking__c = true;
        }
        Database.update(objList);
        
    }
    private static loan__Loan_Product__c getLoanProduct(String name) {
        loan__Loan_Product__c retVal;

        //Get loan Product
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache loanOC = ec.getObject('LoanProduct');
        if(loanOC != null) {
            ec.deleteObject('LoanProduct');
        }

        String namespacePrefix = '';
        if(loan.CustomSettingsUtil.getOrgParameters().loan__Namespace_Prefix__c != null && 
        !String.isEmpty(loan.CustomSettingsUtil.getOrgParameters().loan__Namespace_Prefix__c)) {
            namespacePrefix += loan.CustomSettingsUtil.getOrgParameters().loan__Namespace_Prefix__c + '__';
        }
        loanOC = ec.createObject('LoanProduct', namespacePrefix+'Loan_Product__c');

        String fields = null;
        loanOC.addFields(fields);
        loanOC.addNamedParameter('loanProductName', name);
        loanOC.setWHEREClause('Name = :loanProductName');

        loanOC.executeQuery();

        if(!loanOC.getRecords().isEmpty()) {
            retVal = (loan__Loan_Product__c)loanOC.getRecords().get(0);
        }

        return retVal;
    }

    private static List<loan__Loan_Account__c> getLoanAccount(Id loanIds) {
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache loanOC = ec.getObject('LoanAccount');
        if (loanOC != null) {
            ec.deleteObject('LoanAccount');
        }

        loanOC = ec.createObject('LoanAccount', 'Loan_Account__c', 'loan');
        String fields = loan.ObjectCacheQueryUtil.getLoanSnapshotFields();
        fields += ', Minimum_Amount_Due__c,  Minimum_Amount_Due_Type__c ';
        loanOC.addFields(fields);
        loanOC.addNamedParameter('loanIds', loanIds);
        loanOC.setWhereClause('ID = :loanIds');

        mfiflexUtil.ObjectCache bills = ec.createRelationship('Dues_Details__r')
                .addFields(loan.ObjectCacheQueryUtil.getDueDetailsFields())
                .setWhereClause('DD_Primary_Flag__c = true AND Late_Charge_Applied__c = false');
        loanOC.addRelationship(bills);

        List<loan__Loan_Account__c> retVal = (List<loan__Loan_Account__c>)loanOC.buildQuery().executeQuery().getRecords();
        return retVal;
    }

//It will cover disbursal , payment , payment rev 
    public static testMethod void TestSummaryCreationDisbursalAndPayment(){
        loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
        List<String> trans = new List<String>();
        Date currentSystemDate = dateutil.getCurrentSystemDate();
        Date startDate = currentSystemDate;
        List<loan__Loan_Account__c> loanAccountList = new List<loan__Loan_Account__c>();
        loan__Loan_Product__c lp = getLoanProduct('Loan Product');
        loan__Payment_Mode__c pMode = [SELECT Id, Name FROM loan__Payment_Mode__c WHERE Name = 'Cash'];
        loan.TestHelper.createDayProcessForFullYear(dateutil.getCurrentSystemDate());
        
        loan__Loan_Account__C loanAcc = [SELECT id,
                                                loan__Provision_Amount__C ,
                                                loan__Loan_Status__c
                                         FROM loan__Loan_Account__c 
                                         WHERE loan__Product_Type__c =:loan.LoanConstants.LOAN 
                                         LIMIT 1];
        Test.startTest();
        loan__Loan_Disbursal_Transaction__c disTxn = GenericUtilityTestHelper.returnDisbursal(loanAcc.Id,currentSystemDate,pMode.Id);
        loan.LoanDisbursalActionAPI action = new loan.LoanDisbursalActionAPI(disTxn);
        loanAcc = action.disburseLoanAccount();
        loanAcc = TestLoan.getLoanAccount(loanAcc);
        disTxn = [SELECT Id, 
                        Name, 
                        loan__Transaction_Creation_Date__c,
                        loan__Bank_Account__c ,
                        loan__Disbursed_Amt__c  
                    FROM loan__Loan_Disbursal_Transaction__c ];
        System.assertNotEquals(
            disTxn.Id, 
            'null');

        Test.stopTest();

        loan__Loan_Payment_Transaction__c pmt = GenericUtilityTestHelper.returnPayment(loanAcc.Id,currentSystemDate,pMode.Id);
        pmt.loan__Cleared__c = true;
        Database.update(pmt);
        List<loan__Loan_Payment_Transaction__c> payment = [SELECT Id ,
                                                                loan__Transaction_Amount__c 
                                                            FROM loan__Loan_Payment_Transaction__c LIMIT 1];
        
        System.assertEquals(
            payment.size(), 
            1,
            'LPT inserted Sucessfully'
        );
        
        //Reverse Payment
        loan__Repayment_Transaction_Adjustment__c reversalTxn = GenericUtilityTestHelper.returnrevpayment(
            currentSystemDate,
            pmt.Id
        );   
        System.assertNotEquals(
            reversalTxn.Id,
            null
        );

        loanAcc = TestLoan.getLoanAccount(loanAcc);
        List<loan__Loan_Account__c > loanAccList = new List<loan__Loan_Account__c>();
        LTSMigrationHandler handler = new LTSMigrationHandler(startDate,currentSystemDate);
        loanAccList.add(TestLoan.getLoanAccount(loanAcc));
        Date resolvedDate = Date.newinstance(currentSystemDate.year(), currentSystemDate.month(), currentSystemDate.day());
        handler.process(loanAccList);
        
        List<loan__Loan_Transaction_Summary__c> summary = [SELECT loan__Current_Interest_Rate__c,
                                                                  loan__Current_Loan_Balance__c,
                                                                  loan__Current_Payoff_Balance__c,
                                                                  loan__Current_Principal_Remaining__c,
                                                                  loan__Current_Delinquent_Amount__c,
                                                                  loan__Invalid_data__c
                                                           FROM loan__Loan_Transaction_Summary__c
                                                           Order By loan__Transaction_Time__c ASC]; 
        
        System.assertEquals(summary.size(),3);
    }
    
    public static testMethod void TestSummaryIfAlreadyPresent(){

        loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
        Date currentSystemDate = dateutil.getCurrentSystemDate();
        Date startDate =currentSystemDate;
        loan__Loan_Product__c lp = getLoanProduct('Loan Product');
        Map<Id,loan__Loan_Transaction_Summary__c> existingSummaries = new Map<Id,loan__Loan_Transaction_Summary__c>();
        List<loan__Loan_Account__c> loanAccountList = new List<loan__Loan_Account__c>();
        loan__Loan_Product__c loanProd = getLoanProduct('Loan Product');
        List<loan__Office_Name__c> dummyOffice = [SELECT Id FROM loan__Office_Name__c];
        loan__Payment_Mode__c pMode = [SELECT Id,Name FROM loan__Payment_Mode__c WHERE Name = 'Cash'];
        loan.TestHelper.createDayProcessForFullYear(dateutil.getCurrentSystemDate());
        
        loan__Loan_Account__C loanAcc = [SELECT id,
                                                loan__Provision_Amount__C ,
                                                loan__Loan_Status__c
                                        FROM loan__Loan_Account__c 
                                        WHERE loan__Product_Type__c =:loan.LoanConstants.LOAN 
                                        LIMIT 1];
        lp.loan__Create_Summaries__C = true;
        Database.update(lp);
        Test.startTest();
        loan__Loan_Disbursal_Transaction__c disTxn = GenericUtilityTestHelper.returnDisbursal(loanAcc.Id,currentSystemDate,pMode.Id);
        loan.LoanDisbursalActionAPI action = new loan.LoanDisbursalActionAPI(disTxn);
        loanAcc = action.disburseLoanAccount();
        loanAcc = TestLoan.getLoanAccount(loanAcc);
        disTxn = [SELECT Id, 
                        Name, 
                        loan__Transaction_Creation_Date__c,
                        loan__Bank_Account__c ,
                        loan__Disbursed_Amt__c  
                    FROM loan__Loan_Disbursal_Transaction__c ];
        System.assertNotEquals(
            disTxn.Id, 
            'null');
        Test.stopTest();
        List<loan__Loan_transaction_summary__c> summary = [SELECT loan__Current_Interest_Rate__c,
                                                                  loan__Current_Loan_Balance__c,
                                                                  loan__Current_Payoff_Balance__c,
                                                                  loan__Current_Principal_Remaining__c,
                                                                  loan__Loan_Disbursal__c,
                                                                  loan__Transaction_Amount__c,
                                                                  loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                                                                  loan__Consolidated_Loan_Balance__c
                                                           FROM loan__Loan_Transaction_Summary__c
                                                           Order By CreatedDate ASC];

        existingSummaries.put(summary[0].Id,summary[0]);

        loan__Loan_Payment_Transaction__c pmt = GenericUtilityTestHelper.returnPayment(loanAcc.Id,currentSystemDate,pMode.Id);
        pmt.loan__Cleared__c = true;
        Database.update(pmt);
        List<loan__Loan_Payment_Transaction__c> payment = [SELECT Id ,
                                                                loan__Transaction_Amount__c 
                                                            FROM loan__Loan_Payment_Transaction__c LIMIT 1];
        
        System.assertEquals(
            payment.size(), 
            1,
            'LPT inserted Sucessfully'
        );

        summary = [SELECT loan__Current_Interest_Rate__c,
                          loan__Current_Loan_Balance__c,
                          loan__Current_Payoff_Balance__c,
                          loan__Current_Principal_Remaining__c,
                          loan__Loan_Payment_Txn__c,
                          loan__Transaction_Amount__c,
                          loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                          loan__Consolidated_Loan_Balance__c
                   FROM loan__Loan_Transaction_Summary__c
                   Order By CreatedDate ASC];
        
        existingSummaries.put(summary[1].Id,summary[1]);
        
        loan.LoanActionFactory factory = new loan.LoanActionFactory();
        loan.LoanAction2 api = factory.getLoanAction2API();
        Set<Id> paymentId = new  Set<Id> ();
        paymentId.add(pmt.id);
        List<loan__Repayment_Transaction_Adjustment__c> rev = api.reverseLoanPayment(paymentId,'Human Error','Ref-001');
            
        List<loan__Repayment_Transaction_Adjustment__c> reverse = [SELECT Id,
                                                                          loan__Loan_Payment_Transaction__r.loan__Transaction_Amount__c 
                                                                   FROM loan__Repayment_Transaction_Adjustment__c 
                                                                   LIMIT 1];
        summary = [SELECT loan__Current_Interest_Rate__c,
                          loan__Current_Loan_Balance__c,
                          loan__Current_Payoff_Balance__c,
                          loan__Current_Principal_Remaining__c,
                          loan__Repayment_Txn_Reversal__c,
                          loan__Transaction_Amount__c,
                          loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                          loan__Consolidated_Loan_Balance__c
                   FROM loan__Loan_Transaction_Summary__c
                   Order By CreatedDate ASC];
        
        loanAcc = TestLoan.getLoanAccount(loanAcc);

        existingSummaries.put(summary[2].Id,summary[2]);

        List<loan__Loan_Account__c> loanAccList = new List<loan__Loan_Account__c>();
        LTSMigrationHandler handler = new LTSMigrationHandler(startDate,currentSystemDate);       
        loanAccList.add(TestLoan.getLoanAccount(loanAcc));
        handler.process(loanAccList);
       
        List<loan__Loan_Transaction_Summary__c> newSummariesList = [SELECT Id,loan__Current_Interest_Rate__c,
                                                                      loan__Current_Loan_Balance__c,
                                                                      loan__Current_Payoff_Balance__c,
                                                                      loan__Current_Principal_Remaining__c,
                                                                      loan__Disbursal_Reversal__c,
                                                                      loan__Transaction_Amount__c,
                                                                	  loan__Repayment_Txn_Reversal__c,
                                                                      loan__Loan_Payment_Txn__c,
                                                              		  loan__Loan_Disbursal__c,
                                                                      loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                                                                      loan__Consolidated_Loan_Balance__c
                                                               FROM loan__Loan_Transaction_Summary__c
                                                               Order By CreatedDate ASC];
        System.assertEquals(newSummariesList.size(),3);

        for(loan__Loan_Transaction_Summary__c lts:newSummariesList){
            loan__Loan_Transaction_Summary__c extngLts = existingSummaries.get(lts.Id);
            System.assertEquals(extngLts.loan__Current_Principal_Remaining__c, lts.loan__Current_Principal_Remaining__c);
        }       
    }
    public static testMethod void TestSummaryOLTTxn(){
        loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
        Date currentSystemDate = dateutil.getCurrentSystemDate();
        Date startDate = currentSystemDate;
        loan__Loan_Product__c lp = getLoanProduct('Loan Product');
        List<loan__Loan_Account__c> loanAccountList = new List<loan__Loan_Account__c>();
        List<loan__Office_Name__c> dummyOffice = [SELECT Id
                                                FROM loan__Office_Name__c
                                            ];
        loan__Payment_Mode__c pMode = [SELECT Id,
                                            Name 
                                    FROM loan__Payment_Mode__c 
                                    WHERE Name = 'Cash'];
        loan.TestHelper.createDayProcessForFullYear(dateutil.getCurrentSystemDate());
            
        loan__Loan_Account__C loanAcc = [SELECT id,
                                                loan__Provision_Amount__C ,
                                                loan__Loan_Status__c
                                            FROM loan__Loan_Account__c 
                                            WHERE loan__Product_Type__c =:loan.LoanConstants.LOAN 
                                            LIMIT 1];
        Test.startTest();
        loan__Loan_Disbursal_Transaction__c disTxn = GenericUtilityTestHelper.returnDisbursal(loanAcc.Id,currentSystemDate,pMode.Id);
        loan.LoanDisbursalActionAPI action = new loan.LoanDisbursalActionAPI(disTxn);
        loanAcc = action.disburseLoanAccount();
        loanAcc = TestLoan.getLoanAccount(loanAcc);
        disTxn = [SELECT Id, 
                        Name, 
                        loan__Transaction_Creation_Date__c,
                        loan__Bank_Account__c ,
                        loan__Disbursed_Amt__c  
                    FROM loan__Loan_Disbursal_Transaction__c ];
        System.assertNotEquals(
            disTxn.Id, 
            'null');
       	//Rate change
        loan.LoanAction la = new loan.LoanActionFactory().getLoanActionAPI();
		la.changeInterestRate(loanAcc.id, null, 7);
        List<loan__Other_Transaction__c> oTxn = [SELECT Id,
                                                        Name,
                                                        CreatedDate,
                                                        loan__Transaction_Type__c,
                                                        loan__Loan_Account__c
                                                FROM loan__Other_Transaction__c
                                                WHERE loan__Loan_Account__c = :loanAcc.Id
                                                Order By CreatedDate ASC];
        System.assertEquals(oTxn.size(),1);
        Test.stopTest();
        loan.GlobalProcessFacade.moveSystemToDate(currentSystemDate+1,false);   
        currentSystemDate=dateutil.getCurrentSystemDate();

        loan__Loan_Payment_Transaction__c pmt = GenericUtilityTestHelper.returnPayment(loanAcc.Id,currentSystemDate,pMode.Id);
        pmt.loan__Cleared__c = true;
        Database.update(pmt);
        List<loan__Loan_Payment_Transaction__c> payment = [SELECT Id ,
                                                                loan__Transaction_Amount__c 
                                                            FROM loan__Loan_Payment_Transaction__c LIMIT 1];
        
        System.assertEquals(
            payment.size(), 
            1,
            'LPT inserted Sucessfully'
        );
        
        lp.loan__Create_Summaries__C = true;
        Database.update(lp);
        List<loan__Loan_Account__c > loanAccList = new List<loan__Loan_Account__c>();
        LTSMigrationHandler handler = new LTSMigrationHandler(startDate,currentSystemDate);
        loanAccList.add(TestLoan.getLoanAccount(loanAcc));
        handler.process(loanAccList);
        List<loan__Loan_transaction_summary__c> summary = [SELECT loan__Current_Interest_Rate__c,
                                                                  loan__Current_Loan_Balance__c,
                                                                  loan__Current_Payoff_Balance__c,
                                                                  loan__Current_Principal_Remaining__c,
                                                                  loan__Other_Loan_Txn__c,
                                                                  loan__Invalid_data__c,
                                                                  loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                                                                  loan__Consolidated_Loan_Balance__c,
                                                                  loan__Loan_Payment_Txn__c
                                                         FROM loan__Loan_Transaction_Summary__c
                                                         Order By loan__Transaction_Time__c ASC];
       
        System.assertEquals(3, summary.size());
        
    }
    
    public static testMethod void TestSummaryForDateRange(){ 
        loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
        Date currentSystemDate = dateutil.getCurrentSystemDate();
        loan__Loan_Product__c lp = getLoanProduct('Loan Product');
        List<loan__Loan_Account__c> loanAccountList = new List<loan__Loan_Account__c>();
        loan__Loan_Product__c loanProd = getLoanProduct('Loan Product');
        List<loan__Office_Name__c> dummyOffice = [SELECT Id
                                                FROM loan__Office_Name__c
                                            ];
        loan__Payment_Mode__c pMode = [SELECT Id,
                                            Name 
                                    FROM loan__Payment_Mode__c 
                                    WHERE Name = 'Cash'];
        loan.TestHelper.createDayProcessForFullYear(dateutil.getCurrentSystemDate());
            
        loan__Loan_Account__C loanAcc = [SELECT id,
                                            loan__Provision_Amount__C ,
                                            loan__Loan_status__c
                                        FROM loan__Loan_Account__c 
                                    WHERE loan__Product_Type__c =:loan.LoanConstants.LOAN 
                                    LIMIT 1];
        Test.startTest();
        loan__Loan_Disbursal_Transaction__c disTxn = GenericUtilityTestHelper.returnDisbursal(loanAcc.Id,currentSystemDate,pMode.Id);
        loan.LoanDisbursalActionAPI action = new loan.LoanDisbursalActionAPI(disTxn);
        loanAcc = action.disburseLoanAccount();
        loanAcc = TestLoan.getLoanAccount(loanAcc);
        disTxn = [SELECT Id, 
                        Name, 
                        loan__Transaction_Creation_Date__c,
                        loan__Bank_Account__c ,
                        loan__Disbursed_Amt__c  
                    FROM loan__Loan_Disbursal_Transaction__c ];
        System.assertNotEquals(
            disTxn.Id, 
            'null');
        
        loan.GlobalProcessFacade.moveSystemToDate(currentSystemDate+3,false);   
        currentSystemDate=dateutil.getCurrentSystemDate();   
        Date startDate = currentSystemDate;

        loan__Loan_Payment_Transaction__c pmt = GenericUtilityTestHelper.returnPayment(loanAcc.Id,currentSystemDate,pMode.Id);
        pmt.loan__Cleared__c = true;
        Database.update(pmt);
        List<loan__Loan_Payment_Transaction__c> payment = [SELECT Id ,
                                                                loan__Transaction_Amount__c 
                                                            FROM loan__Loan_Payment_Transaction__c LIMIT 1];
        
        System.assertEquals(
            payment.size(), 
            1,
            'LPT inserted Sucessfully'
        );
        
        List<loan__Loan_Account__c > loanAccList = new List<loan__Loan_Account__c>();
        LTSMigrationHandler handler = new LTSMigrationHandler(startDate,currentSystemDate);       
        loanAccList.add(TestLoan.getLoanAccount(loanAcc));
        handler.process(loanAccList);
        List<loan__Loan_transaction_summary__c> summary = [SELECT loan__Current_Interest_Rate__c,
                                                            loan__Current_Loan_Balance__c,
                                                            loan__Current_Payoff_Balance__c,
                                                            loan__Current_Principal_Remaining__c,
                                                            loan__Other_Loan_Txn__c,
                                                            loan__Invalid_data__c,
                                                    		loan__Transaction_Amount__c,
                                                            loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                                                            loan__Consolidated_Loan_Balance__c,
                                                            loan__Loan_Payment_Txn__c
                                                        FROM loan__Loan_Transaction_Summary__c
                                                        Order By loan__Transaction_Time__c ASC];
            
        loanAcc=TestLoan.getLoanAccount(loanAcc) ; 
        System.assertEquals(1, summary.size());
    }
    
    public static testMethod void TestSummaryBills(){
        loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
        Date currentSystemDate = dateutil.getCurrentSystemDate();
         Date startDate = currentSystemDate;
        List<loan__Loan_Account__c> loanAccountList = new List<loan__Loan_Account__c>();
         loan__Loan_Product__c lp = getLoanProduct('Loan Product');
        List<loan__Office_Name__c> dummyOffice = [SELECT Id
                                            FROM loan__Office_Name__c
                                           ];
        loan__Payment_Mode__c pMode = [SELECT Id,
                                        Name 
                                 FROM loan__Payment_Mode__c 
                                 WHERE Name = 'Cash'];
        loan.TestHelper.createDayProcessForFullYear(dateutil.getCurrentSystemDate());
        
        loan__Loan_Account__C loanAcc = [SELECT id,
                                         loan__Provision_Amount__C ,
                                         loan__Loan_status__c
                                  FROM loan__Loan_Account__c 
                                  WHERE loan__Product_Type__c =:loan.LoanConstants.LOAN 
                                  LIMIT 1];
        Test.startTest();
        loan__Loan_Disbursal_Transaction__c disTxn = GenericUtilityTestHelper.returnDisbursal(loanAcc.Id,currentSystemDate,pMode.Id);
        loan.LoanDisbursalActionAPI action = new loan.LoanDisbursalActionAPI(disTxn);
        loanAcc = action.disburseLoanAccount();
        loanAcc = TestLoan.getLoanAccount(loanAcc);
        disTxn = [SELECT Id, 
                        Name, 
                        loan__Transaction_Creation_Date__c,
                        loan__Bank_Account__c ,
                        loan__Disbursed_Amt__c  
                    FROM loan__Loan_Disbursal_Transaction__c ];
        System.assertNotEquals(
            disTxn.Id, 
            'null');
        //Generating Bills
        loan.GlobalProcessFacade.moveSystemToDate(currentSystemDate+31,false);   
        currentSystemDate=dateutil.getCurrentSystemDate();
        loan__Loan_Product__c loanProd = getLoanProduct('Loan Product');
        
        loan__Loan_account_Due_Details__c bills = GenericUtilityTestHelper.returnBills(loanAcc.Id,currentSystemDate) ;
        System.assertNotEquals(bills.Id, null);

        List<loan__Fee__c> fees = [SELECT Id, Name, loan__Include_In_Dues__c FROM loan__Fee__c ORDER BY Name ASC];

        loan__Charge__c charge = GenericUtilityTestHelper.returncharge(
            loanAcc.Id,
            dateutil.getCurrentSystemDate(),
            fees.get(0).Id);
        charge.loan__Transaction_Creation_Date__c = currentSystemDate;
        Database.update(charge);
        List<loan__Charge__c> charges = [SELECT ID,
                                                loan__Date__c,
                                                loan__Fee__c,
                                                loan__Original_Amount__c,
                                                loan__Transaction_Creation_Date__c
                                            FROM loan__Charge__c
                                            WHERE loan__loan_Account__c=:loanAcc.Id];
        System.assertEquals(charges.size(),1);

        loan__Loan_Payment_Transaction__c pmt = GenericUtilityTestHelper.returnPayment(loanAcc.Id,currentSystemDate,pMode.Id);
        pmt.loan__Cleared__c = true;
        Database.update(pmt);
        List<loan__Loan_Payment_Transaction__c> payment = [SELECT Id ,
                                                                loan__Transaction_Amount__c 
                                                            FROM loan__Loan_Payment_Transaction__c LIMIT 1];
        
        System.assertEquals(
            payment.size(), 
            1,
            'LPT inserted Sucessfully'
        );

        lp.loan__Create_Summaries__C = true;
        Database.update(lp);

        List<loan__Loan_Account__c > loanAccList = new List<loan__Loan_Account__c>();
        LTSMigrationHandler handler = new LTSMigrationHandler(startDate,currentSystemDate);

        loanAccList.add(TestLoan.getLoanAccount(loanAcc));
        handler.process(loanAccList);
        Test.stopTest(); 

        List<loan__Loan_transaction_summary__c> summary = [SELECT loan__Current_Interest_Rate__c,
                                                            loan__Current_Loan_Balance__c,
                                                            loan__Current_Principal_Remaining__c,
                                                            loan__Loan_Due_Detail__c,
                                                            loan__Transaction_Amount__c,
                                                            loan__Current_Delinquent_Amount__c,
                                                            loan__Current_Payoff_Balance__c,                                                     
                                                            loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                                                            loan__Consolidated_Loan_Balance__c
                                                        FROM loan__Loan_Transaction_Summary__c
                                                        Order By loan__Transaction_Time__c ASC];
        loanAcc = TestLoan.getLoanAccount(loanAcc);
        System.assertEquals(4, summary.size());
    }
    
        //marking payment as invalid so it wont get stored
    public static testMethod void TestSummaryWithInvalidTxns(){
        loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
        List<String> trans = new List<String>();
        Date currentSystemDate = dateutil.getCurrentSystemDate();
        Date startDate = currentSystemDate;
        List<loan__Loan_Account__c> loanAccountList = new List<loan__Loan_Account__c>();
        loan__Loan_Product__c lp = getLoanProduct('Loan Product');
        loan__Payment_Mode__c pMode = [SELECT Id,Name FROM loan__Payment_Mode__c WHERE Name = 'Cash'];
        loan.TestHelper.createDayProcessForFullYear(dateutil.getCurrentSystemDate());
        List<loan__Object_Event_Mapping__c> oemList=[SELECT Id, 
                                                        	loan__Enable_Tracking__c, 
                                                        	loan__Transaction_Name__c, 
                                                        	loan__API_Name__c, 
                                                        	loan__Transaction_Type__c 
                                                        FROM loan__Object_Event_Mapping__c
                                                        WHERE loan__Transaction_Name__c = 'Regular Payment'];
         
        oemList[0].loan__Enable_Tracking__c = false;
        Database.update(oemList);
        loan__Loan_Account__C loanAcc = [SELECT id,
                                         		loan__Provision_Amount__C ,
                                          		loan__Loan_Status__c
                                      	FROM loan__Loan_Account__c 
                                 		WHERE loan__Product_Type__c =:loan.LoanConstants.LOAN 
                                  		LIMIT 1];
        Test.startTest();
        loan__Loan_Disbursal_Transaction__c disTxn = GenericUtilityTestHelper.returnDisbursal(loanAcc.Id,currentSystemDate,pMode.Id);
        loan.LoanDisbursalActionAPI action = new loan.LoanDisbursalActionAPI(disTxn);
        loanAcc = action.disburseLoanAccount();
        loanAcc = TestLoan.getLoanAccount(loanAcc);
        disTxn = [SELECT Id, 
                        Name, 
                        loan__Transaction_Creation_Date__c,
                        loan__Bank_Account__c ,
                        loan__Disbursed_Amt__c  
                    FROM loan__Loan_Disbursal_Transaction__c ];
        System.assertNotEquals(
            disTxn.Id, 
            'null');
        Test.stopTest();

        loan__Loan_Payment_Transaction__c pmt = GenericUtilityTestHelper.returnPayment(loanAcc.Id,currentSystemDate,pMode.Id);
        pmt.loan__Cleared__c = true;
        Database.update(pmt);
        List<loan__Loan_Payment_Transaction__c> payment = [SELECT Id ,
                                                                loan__Transaction_Amount__c 
                                                            FROM loan__Loan_Payment_Transaction__c LIMIT 1];
        
        System.assertEquals(
            payment.size(), 
            1,
            'LPT inserted Sucessfully'
        );

        loan__Repayment_Transaction_Adjustment__c reversalTxn =GenericUtilityTestHelper.returnrevpayment(
            currentSystemDate,
            pmt.Id
        ); 
        System.assertNotEquals(
            reversalTxn.Id,
            null
        );
        loanAcc = TestLoan.getLoanAccount(loanAcc);

        lp.loan__Create_Summaries__C = true;
        Database.update(lp);

        List<loan__Loan_Account__c > loanAccList = new List<loan__Loan_Account__c>();
        LTSMigrationHandler handler = new LTSMigrationHandler(startDate,currentSystemDate);
        loanAccList.add(TestLoan.getLoanAccount(loanAcc));
        Date resolvedDate = Date.newinstance(currentSystemDate.year(), currentSystemDate.month(), currentSystemDate.day());
      
        handler.process(loanAccList);
        
        List<loan__Loan_Transaction_Summary__c> summary = [SELECT loan__Current_Interest_Rate__c,
                                                                  loan__Current_Loan_Balance__c,
                                                                  loan__Current_Payoff_Balance__c,
                                                                  loan__Current_Principal_Remaining__c,
                                                                  loan__Current_Delinquent_Amount__c,
                                                                  loan__Invalid_data__c,
                                                           		  loan__Transaction_Type_Id__r.loan__Transaction_Name__C
                                                            FROM loan__Loan_Transaction_Summary__c
                                                            Order By loan__Transaction_Time__c ASC]; 
        
        System.assertEquals(3,summary.size());
        
    }
    public static testMethod void testMigrationWithDeposit(){
        loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
        Contact cont = [SELECT Id FROM Contact where FirstName = 'Dummy'];
        Date currentSystemDate = dateutil.getCurrentSystemDate();
        Date startDate = currentSystemDate;
        loan__Client__c dummyClient = [SELECT Id FROM loan__Client__c Limit 1];

        loan__Loan_Product__c lp = getLoanProduct('Loan Product');
        lp.loan__Adjust_Deposit_Amount_In_Payoff__c = true;
        lp.loan__Payment_Application_Mode__c = loan.LoanConstants.LOAN_PAYMENT_APPLICATION_DEPOSIT;
        Database.update(lp);
        system.assertEquals(lp.loan__Adjust_Deposit_Amount_In_Payoff__c,true);

        loan__Loan_Account__c loanAcc1 =GenericUtilityTestHelper.returnLLAccount(currentSystemDate,dummyClient.ID,cont.ID,lp.ID); 

        List<loan.LoanAccountParameters.Deposit> depositList = new List<loan.LoanAccountParameters.Deposit>();       
     	loan.LoanAccountParameters loanAccountParam = new loan.LoanAccountParameters();
     	loanAccountParam.setLoanAccountToCreate(loanAcc1);
     //   loanAccountParam.setDepositList(depositList);
        loan.AbstractLoanActions loanAPI = new loan.LoanActionFactory().getLoanActionsAPI();
     	loan__Loan_Account__c loanAcc = loanAPI.createContract(loanAccountParam); 

        List<clcommon__Deposit__c> depositList1 = new List<clcommon__Deposit__c>();
        clcommon__Deposit__c deposit1 = GenericUtilityTestHelper.returnDeposit(
            loanAcc.Id,
            currentSystemDate,5,1);
        depositList1.add(deposit1);
        deposit1 =  GenericUtilityTestHelper.returnDeposit(
            loanAcc.Id,
            currentSystemDate,10,2);
        depositList1.add(deposit1);
        system.assertEquals(depositList1.size(),2);

        List<loan__Office_Name__c> dummyOffice = [SELECT Id
                                                    FROM loan__Office_Name__c];
        loan__Payment_Mode__c pMode = [SELECT Id,
                                        Name 
                                    FROM loan__Payment_Mode__c 
                                    WHERE Name = 'Cash'];
        loan.TestHelper.createDayProcessForFullYear(dateutil.getCurrentSystemDate());
        Set<Id> loanAccsId = new  Set<Id>();
        loanAccsId.add(loanAcc.Id);
        loan.LoanTransactionUtil.queryAndSetDepositDetailsMap(loanAccsId);
        List<clcommon__Deposit__c> depositList123 = loan.LoanTransactionUtil.getDepositListForALoan(loanAcc.Id); 

        Test.startTest();
        loan__Loan_Disbursal_Transaction__c disTxn = GenericUtilityTestHelper.returnDisbursal(loanAcc.Id,currentSystemDate,pMode.Id);
        loan.LoanDisbursalActionAPI action = new loan.LoanDisbursalActionAPI(disTxn);
        loanAcc = action.disburseLoanAccount();
        loanAcc = TestLoan.getLoanAccount(loanAcc);
        disTxn = [SELECT Id, 
                        Name, 
                        loan__Transaction_Creation_Date__c,
                        loan__Bank_Account__c ,
                        loan__Disbursed_Amt__c  
                    FROM loan__Loan_Disbursal_Transaction__c ];
        System.assertNotEquals(
            disTxn.Id, 
            'null');
        Test.stopTest();

        loan.GlobalProcessFacade.moveSystemToDate(currentSystemDate+1,false);   
        currentSystemDate=dateutil.getCurrentSystemDate();

        loan__Loan_Payment_Transaction__c pmt = GenericUtilityTestHelper.returnPayment(loanAcc.Id,currentSystemDate,pMode.Id);
        pmt.loan__Cleared__c = true;
        Database.update(pmt);
        List<loan__Loan_Payment_Transaction__c> payment = [SELECT Id ,
                                                                loan__Transaction_Amount__c 
                                                            FROM loan__Loan_Payment_Transaction__c LIMIT 1];
        
        System.assertEquals(
            payment.size(), 
            1,
            'LPT inserted Sucessfully'
        );
        
        loan.GlobalProcessFacade.moveSystemToDate(currentSystemDate+1,false);   
        currentSystemDate = dateutil.getCurrentSystemDate(); 
   
        loan.LoanActionFactory factory = new loan.LoanActionFactory();
        loan.LoanAction2 api = factory.getLoanAction2API();

        Set<Id> paymentId = new  Set<Id> ();
        paymentId.add(pmt.id);
        List<loan__Repayment_Transaction_Adjustment__c> rev = api.reverseLoanPayment(paymentId,'Human Error','Ref-001');
            
        List<loan__Repayment_Transaction_Adjustment__c> reverse = [SELECT Id,
                                                                        loan__Loan_Payment_Transaction__r.loan__Transaction_Amount__c 
                                                                    FROM loan__Repayment_Transaction_Adjustment__c LIMIT 1];
        lp.loan__Create_Summaries__C = true;
        Database.update(lp);
        LTSMigrationJob batchLTS=new LTSMigrationJob(null,startDate,currentSystemDate,null);
        batchLTS.getBatchSize();
        batchLTS.getInstance();
        List<loan__Loan_Account__c > loanAccList = new List<loan__Loan_Account__c>();
        LTSMigrationHandler handler = new LTSMigrationHandler(startDate,currentSystemDate);
        
        loanAccList.add(TestLoan.getLoanAccount(loanAcc));
        handler.process(loanAccList);
        List<loan__Loan_transaction_summary__c> summary = [SELECT loan__Current_Interest_Rate__c,
                                                            loan__Current_Loan_Balance__c,
                                                            loan__Current_Payoff_Balance__c,
                                                            loan__Current_Principal_Remaining__c,
                                                            loan__Other_Loan_Txn__c,
                                                            loan__Invalid_data__c,
                                                            loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                                                            loan__Consolidated_Loan_Balance__c,
                                                            loan__Current_Delinquent_Amount__c,
                                                            loan__Loan_Payment_Txn__c
                                                        FROM loan__Loan_Transaction_Summary__c
                                                        Order By loan__Transaction_Time__c ASC];
        
        System.assertEquals(3, summary.size()); 
        
    }
    public static testMethod void TestSummaryInterestPosting(){
        loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
        Date currentSystemDate = dateutil.getCurrentSystemDate();
        Date startDate = currentSystemDate;
        loan__Loan_Product__c lp = getLoanProduct('Loan Product');
        List<loan__Loan_Account__c> loanAccountList = new List<loan__Loan_Account__c>();
        List<loan__Office_Name__c> dummyOffice = [SELECT Id
                                                FROM loan__Office_Name__c
                                            ];
        loan__Payment_Mode__c pMode = [SELECT Id,
                                            Name 
                                    FROM loan__Payment_Mode__c 
                                    WHERE Name = 'Cash'];
        loan.TestHelper.createDayProcessForFullYear(dateutil.getCurrentSystemDate());
            
        loan__Loan_Account__C loanAcc = [SELECT id,
                                                loan__Provision_Amount__C ,
                                                loan__Loan_Status__c
                                            FROM loan__Loan_Account__c 
                                            WHERE loan__Product_Type__c =:loan.LoanConstants.LOAN 
                                            LIMIT 1];
        Test.startTest();
        loan__Loan_Disbursal_Transaction__c disTxn = GenericUtilityTestHelper.returnDisbursal(loanAcc.Id,currentSystemDate,pMode.Id);
        loan.LoanDisbursalActionAPI action = new loan.LoanDisbursalActionAPI(disTxn);
        loanAcc = action.disburseLoanAccount();
        loanAcc = TestLoan.getLoanAccount(loanAcc);
        disTxn = [SELECT Id, 
                        Name, 
                        loan__Transaction_Creation_Date__c,
                        loan__Bank_Account__c ,
                        loan__Disbursed_Amt__c  
                    FROM loan__Loan_Disbursal_Transaction__c ];
        System.assertNotEquals(
            disTxn.Id, 
            'null');
       	//Rate change
        loan.LoanAction la = new loan.LoanActionFactory().getLoanActionAPI();
		la.changeInterestRate(loanAcc.id, null, 7);

        loan__Interest_Posting_Transaction__c interestPosting = GenericUtilityTestHelper.returnInterest(
            loanAcc.Id,
            currentSystemDate);
        System.assertNotEquals(interestPosting.Id,null);

        loan.GlobalProcessFacade.moveSystemToDate(currentSystemDate+1,false);   
        currentSystemDate=dateutil.getCurrentSystemDate();
        loan__Loan_Payment_Transaction__c pmt = GenericUtilityTestHelper.returnPayment(loanAcc.Id,currentSystemDate,pMode.Id);
        pmt.loan__Cleared__c = true;
        Database.update(pmt);
        List<loan__Loan_Payment_Transaction__c> payment = [SELECT Id ,
                                                                loan__Transaction_Amount__c 
                                                            FROM loan__Loan_Payment_Transaction__c LIMIT 1];
        
        System.assertEquals(
            payment.size(), 
            1,
            'LPT inserted Sucessfully'
        );

        Test.stopTest();

        lp.loan__Create_Summaries__C = true;
        Database.update(lp);
        Set<Id> record=new Set<Id>();
        record.add(loanAcc.id);
        LTSMigrationJob batchLTS=new LTSMigrationJob(null,startDate,currentSystemDate,10);
        batchLTS.doInitialize();
        batchLTS.batchSize=10;
        batchLTS.getBatchSize();
        batchLTS.getInstance();
        Database.executeBatch(batchLTS,10);
        batchLTS.getRuntimeQuery();
        batchLTS.getRuntimeQueryForPipelinedExecution(record);
        List<loan__Loan_Account__c > loanAccList = new List<loan__Loan_Account__c>();
        LTSMigrationHandler handler = new LTSMigrationHandler(startDate,currentSystemDate);
        loanAccList.add(TestLoan.getLoanAccount(loanAcc));
        handler.process(loanAccList);
        List<loan__Loan_transaction_summary__c> summary = [SELECT loan__Current_Interest_Rate__c,
                                                                  loan__Current_Loan_Balance__c,
                                                                  loan__Current_Payoff_Balance__c,
                                                                  loan__Current_Principal_Remaining__c,
                                                                  loan__Other_Loan_Txn__c,
                                                                  loan__Invalid_data__c,
                                                                  loan__Transaction_Type_Id__r.loan__Transaction_Name__C,
                                                                  loan__Consolidated_Loan_Balance__c,
                                                                  loan__Loan_Payment_Txn__c
                                                         FROM loan__Loan_Transaction_Summary__c
                                                         Order By loan__Transaction_Time__c ASC];
       
        System.assertEquals(4, summary.size());
    }
    
    public testMethod static void LTSRedrawUpdateTest(){
        loan.GlobalLoanUtilFacade dateutil = new loan.GlobalLoanUtilFacade();
        Date currentSystemDate = dateutil.getCurrentSystemDate();
        Date startDate = currentSystemDate;
        loan__Loan_Product__c lp = getLoanProduct('Loan Product');
        List<loan__Loan_Account__c> loanAccountList = new List<loan__Loan_Account__c>();
        List<loan__Office_Name__c> dummyOffice = [SELECT Id
                                                FROM loan__Office_Name__c
                                            ];
        loan__Payment_Mode__c pMode = [SELECT Id,
                                            Name 
                                    FROM loan__Payment_Mode__c 
                                    WHERE Name = 'Cash'];

        loan.TestHelper.createDayProcessForFullYear(dateutil.getCurrentSystemDate());
            
        loan__Loan_Account__C loanAcc = [SELECT id,
                                                loan__Provision_Amount__C ,
                                                loan__Loan_Status__c
                                            FROM loan__Loan_Account__c 
                                            WHERE loan__Product_Type__c =:loan.LoanConstants.LOAN 
                                            LIMIT 1];
        Test.startTest();
        loan__Loan_Disbursal_Transaction__c disTxn = GenericUtilityTestHelper.returnDisbursal(loanAcc.Id,currentSystemDate,pMode.Id);
        loan.LoanDisbursalActionAPI action = new loan.LoanDisbursalActionAPI(disTxn);
        loanAcc = action.disburseLoanAccount();
        loanAcc = TestLoan.getLoanAccount(loanAcc);
        disTxn = [SELECT Id, 
                        Name, 
                        loan__Transaction_Creation_Date__c,
                        loan__Bank_Account__c ,
                        loan__Disbursed_Amt__c  
                    FROM loan__Loan_Disbursal_Transaction__c ];
        System.assertNotEquals(
            disTxn.Id, 
            'null'
        );

        loan.LoanAction la = new loan.LoanActionFactory().getLoanActionAPI();
		la.changeInterestRate(loanAcc.id, null, 7);
        List<loan__Other_Transaction__c> oTxn = [SELECT Id,
                                                        Name,
                                                        CreatedDate,
                                                        loan__Transaction_Type__c,
                                                        loan__Loan_Account__c
                                                FROM loan__Other_Transaction__c
                                                WHERE loan__Loan_Account__c = :loanAcc.Id
                                                Order By CreatedDate ASC];
        System.assertEquals(
            oTxn.size(),
            1,
            'Other Transaction Inserted'
        );

        loan__Loan_Transaction_Summary__c lts=GenericUtilityTestHelper.returntransactionSumm(
            loanAcc.id,
            oTxn[0].id
        );
        system.assertNotEquals(
            lts.id, 
            null,
            'Trasaction Summary Inserted Successfully'
        );
        
        clcommon__Deposit__c deposit=GenericUtilityTestHelper.depInfo(
            loanAcc.id
        );
        deposit.loan__Other_Loan_Transaction__c=oTxn[0].Id;
        update deposit;
        List<clcommon__Deposit__c> depositList=[SELECT id 
                                                    FROM clcommon__Deposit__c 
                                                    WHERE loan__Other_Loan_Transaction__c=:oTxn[0].id];
        system.assertEquals(
            depositList.size(), 
            1,
            'Deposit Inserted Successfully'
        );

        LTSRedrawUpdateBatch obj=new LTSRedrawUpdateBatch();
        String sch = '0 0 23 * * ?';
		system.schedule('Test Check', sch, obj );
        LTSRedrawUpdateBatchExecution.executeLTSRedrawUpdateBatchWS();
        Test.stopTest();
        
    }
    
}